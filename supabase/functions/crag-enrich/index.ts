// Supabase Edge Function: crag-enrich
// Arricchisce una falesia (coord, quota, orientamento, parcheggio, stagione, best_months)
// leggendo SOLO fonti aperte (Nominatim/Overpass OSM, Open-Meteo). Porta della pipeline
// Node `enrich_web.mjs` + `crag_scoring.mjs` + modello best_months (Open-Meteo ERA5).
//
// Regole:
//  - IDEMPOTENTE: riempie solo i campi vuoti; se un campo c'e' gia' non lo tocca.
//  - VALIDA-NON-SOVRASCRIVE: se l'utente ha fornito un valore e il calcolo diverge,
//    tiene il valore utente e marca needs_review (con entrambi i valori in `review`).
//  - Scrive con service_role (bypassa RLS). Nessuna API key esterna necessaria.
//
// Invocazione:
//  - { mode: 'drain', batch: N }  -> il cron: prende N job dalla coda e li processa.
//  - { crag_id: '<uuid>' }        -> import client: processa subito quella falesia.
//
// Deploy: supabase functions deploy crag-enrich   (o via MCP)

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const UA = 'CapitalClimbing-crag-enrichment/1.0 (personal catalog)'
const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms))
const clamp = (x: number, lo = 0, hi = 1) => Math.max(lo, Math.min(hi, x))

// ---------- normalizzazione orientamento + scoring (porta di crag_scoring.mjs) ----------
const SUN_FACTOR: Record<string, number> = { N: 0, NE: 0.25, E: 0.4, SE: 0.7, S: 1, SW: 0.85, W: 0.6, NW: 0.2 }
const SUN_TIME: Record<string, { morning: string; afternoon: string }> = {
  N: { morning: 'no', afternoon: 'no' }, NE: { morning: 'si', afternoon: 'no' },
  E: { morning: 'si', afternoon: 'no' }, SE: { morning: 'si', afternoon: 'parziale' },
  S: { morning: 'si', afternoon: 'si' }, SW: { morning: 'no', afternoon: 'si' },
  W: { morning: 'no', afternoon: 'si' }, NW: { morning: 'no', afternoon: 'parziale' },
}
function normalizeOrientation(raw: string | null): { code: string | null; kind: string } {
  if (!raw) return { code: null, kind: 'unknown' }
  const s = String(raw).toLowerCase().trim()
  if (/\b(vari|misto|multi|tutte)/.test(s)) return { code: null, kind: 'varie' }
  const map: [string, string][] = [
    ['ne', 'NE'], ['nordest', 'NE'], ['se', 'SE'], ['sudest', 'SE'],
    ['sw', 'SW'], ['so', 'SW'], ['sudovest', 'SW'], ['nw', 'NW'], ['no', 'NW'], ['nordovest', 'NW'],
    ['n', 'N'], ['nord', 'N'], ['s', 'S'], ['sud', 'S'], ['e', 'E'], ['est', 'E'], ['w', 'W'], ['o', 'W'], ['ovest', 'W'],
  ]
  const compact = s.replace(/[^a-z]/g, '')
  for (const [k, v] of map) if (compact === k) return { code: v, kind: 'exact' }
  for (const [k, v] of map) if (compact.startsWith(k)) return { code: v, kind: 'exact' }
  return { code: null, kind: 'unknown' }
}
function computeSeasonScores(orientation: string | null, altitude_m: number | null, coastalMild = false) {
  const o = normalizeOrientation(orientation)
  const hasAlt = altitude_m != null && !Number.isNaN(Number(altitude_m))
  const alt = hasAlt ? Number(altitude_m) : null
  const sunFactor = o.kind === 'exact' ? SUN_FACTOR[o.code!] : 0.5
  if (!hasAlt) {
    return {
      sun_morning: o.kind === 'exact' ? SUN_TIME[o.code!].morning : null,
      sun_afternoon: o.kind === 'exact' ? SUN_TIME[o.code!].afternoon : null,
      summer_score: null, winter_score: null, best_season: null, confidence: 'low', needs_review: true,
    }
  }
  const altSummer = clamp((alt! - 400) / 1400)
  const altWinter = 1 - clamp((alt! - 200) / 1600)
  const summer = Math.round(clamp(100 * (0.5 * altSummer + 0.5 * (1 - sunFactor)), 0, 100))
  const winter = Math.round(clamp(100 * altWinter * (0.35 + 0.65 * sunFactor) + (coastalMild ? 12 : 0), 0, 100))
  let best_season: string
  if (Math.abs(summer - winter) <= 8) best_season = 'mezze stagioni'
  else if (summer > winter) best_season = 'estate'
  else best_season = 'inverno'
  return {
    sun_morning: o.kind === 'exact' ? SUN_TIME[o.code!].morning : null,
    sun_afternoon: o.kind === 'exact' ? SUN_TIME[o.code!].afternoon : null,
    summer_score: summer, winter_score: winter, best_season,
    confidence: o.kind === 'exact' ? 'high' : 'low', needs_review: o.kind !== 'exact',
  }
}

// ---------- helpers geo (porta di enrich_web.mjs) ----------
const norm = (s: string | null) => (s || '').toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '').replace(/[^a-z0-9 ]/g, ' ').replace(/\s+/g, ' ').trim()
function placeCandidates(name: string | null, municipality: string | null): string[] {
  const src: string[] = []
  for (const raw of [municipality, name]) {
    if (!raw) continue
    const base = raw.replace(/\(.*?\)/g, ' ').replace(/\s+/g, ' ').trim()
    const segs = base.split(/\s*[-–—/]\s*/).map((s) => s.trim()).filter(Boolean)
    if (segs.length) src.push(segs[0])
    const mDi = base.match(/\bdi\s+([A-Z][\p{L}' ]+)$/u)
    if (mDi) src.push(mDi[1].trim())
    src.push(base)
  }
  const seen = new Set<string>(); const out: string[] = []
  for (const s of src) { const k = norm(s); if (k.length >= 3 && !seen.has(k)) { seen.add(k); out.push(s) } }
  return out
}
function regionTokens(region: string | null, province: string | null): string[] {
  const toks = new Set<string>()
  for (const s of [region, province]) for (const t of norm(s).split(' ')) if (t.length >= 4) toks.add(t)
  return [...toks]
}
async function jget(url: string, opts: RequestInit = {}) {
  const r = await fetch(url, { ...opts, headers: { 'User-Agent': UA, ...(opts.headers || {}) } })
  if (!r.ok) throw new Error('HTTP ' + r.status)
  return await r.json()
}
async function geocodeMulti(candidates: string[], province: string | null, region: string | null, country: string | null) {
  const toks = regionTokens(region, province)
  for (const place of candidates) {
    const qs = [[place, province, region, country], [place, region, country], [place, province, country]]
      .map((a) => a.filter(Boolean).join(', '))
    for (const q of qs) {
      let d: any
      try { d = await jget('https://nominatim.openstreetmap.org/search?format=jsonv2&addressdetails=1&limit=3&q=' + encodeURIComponent(q)) } catch { d = null }
      await sleep(1100)
      if (!Array.isArray(d) || !d.length) continue
      for (const r of d) {
        const addr = norm(Object.values(r.address || {}).join(' ') + ' ' + (r.display_name || ''))
        if (toks.length === 0 || toks.some((t) => addr.includes(t))) return { lat: +r.lat, lon: +r.lon, verified: toks.length > 0, place }
      }
    }
  }
  return null
}
async function overpass(q: string): Promise<any[]> {
  try {
    const d = await jget('https://overpass-api.de/api/interpreter', {
      method: 'POST', body: 'data=' + encodeURIComponent(q), headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    })
    await sleep(1500); return d.elements || []
  } catch { await sleep(1500); return [] }
}
const elCoord = (el: any) => (el.type === 'node' ? { lat: el.lat, lon: el.lon } : el.center || null)
async function elevation(lat: number, lon: number): Promise<number | null> {
  try { const d = await jget(`https://api.open-meteo.com/v1/elevation?latitude=${lat}&longitude=${lon}`); await sleep(200); return Array.isArray(d.elevation) ? d.elevation[0] : null } catch { return null }
}
const R = 6371000, toRad = (d: number) => (d * Math.PI) / 180
const hav = (a: number, b: number, c: number, d: number) => { const dLat = toRad(c - a), dLon = toRad(d - b); const s = Math.sin(dLat / 2) ** 2 + Math.cos(toRad(a)) * Math.cos(toRad(c)) * Math.sin(dLon / 2) ** 2; return 2 * R * Math.asin(Math.sqrt(s)) }
const DIRS = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW']
async function demAspect(lat: number, lon: number): Promise<string | null> {
  const step = 50, dLat = step / 111320, dLon = step / (111320 * Math.cos((lat * Math.PI) / 180))
  const locs: string[] = []
  for (let j = -1; j <= 1; j++) for (let i = -1; i <= 1; i++) locs.push(`${(lat + j * dLat).toFixed(6)},${(lon + i * dLon).toFixed(6)}`)
  for (const ds of ['eudem25m', 'mapzen']) {
    try {
      const d = await jget(`https://api.opentopodata.org/v1/${ds}?locations=${locs.join('|')}`); await sleep(1100)
      if (d.status !== 'OK') continue
      const z = d.results.map((r: any) => r.elevation); if (z.some((v: any) => v == null)) continue
      const [a, b, c, dd, , f, g, h, i] = z
      const dzdx = ((c + 2 * f + i) - (a + 2 * dd + g)) / (8 * step), dzdy = ((g + 2 * h + i) - (a + 2 * b + c)) / (8 * step)
      const slope = Math.hypot(dzdx, dzdy); if (slope < 0.05) return null
      let az = (Math.atan2(-dzdx, -dzdy) * 180) / Math.PI; az = (az + 360) % 360
      return DIRS[Math.round(az / 45) % 8]
    } catch { /* prossimo dataset */ }
  }
  return null
}

// ---------- best_months (Open-Meteo archive ERA5) ----------
// Temp diurna = 0.66*max + 0.34*min. Boost solare da radiazione * fattore esposizione.
// Comfort gaussiano centrato ~12C, caldo penalizzato piu' del freddo. Mesi comfort>=0.6.
async function bestMonths(lat: number, lon: number, orientation: string | null): Promise<string | null> {
  const o = normalizeOrientation(orientation)
  const sunFactor = o.kind === 'exact' ? SUN_FACTOR[o.code!] : 0.5
  const url = `https://archive-api.open-meteo.com/v1/archive?latitude=${lat}&longitude=${lon}` +
    `&start_date=2022-01-01&end_date=2024-12-31&daily=temperature_2m_max,temperature_2m_min,shortwave_radiation_sum&timezone=auto`
  let d: any
  try { d = await jget(url); await sleep(300) } catch { return null }
  const t = d?.daily?.time as string[] | undefined
  const tmax = d?.daily?.temperature_2m_max as number[] | undefined
  const tmin = d?.daily?.temperature_2m_min as number[] | undefined
  const rad = d?.daily?.shortwave_radiation_sum as number[] | undefined
  if (!t || !tmax || !tmin) return null
  const sum = Array.from({ length: 12 }, () => ({ n: 0, comfort: 0 }))
  for (let k = 0; k < t.length; k++) {
    const m = Number(t[k].slice(5, 7)) - 1
    if (tmax[k] == null || tmin[k] == null) continue
    const diurnal = 0.66 * tmax[k] + 0.34 * tmin[k]
    const r = rad && rad[k] != null ? clamp(rad[k] / 28) : 0.4
    const perceived = diurnal + 6 * r * sunFactor
    const spread = perceived < 12 ? 9 : 6.5
    const comfort = Math.exp(-((perceived - 12) ** 2) / (2 * spread * spread))
    sum[m].n++; sum[m].comfort += comfort
  }
  const months: number[] = []
  for (let m = 0; m < 12; m++) if (sum[m].n > 0 && sum[m].comfort / sum[m].n >= 0.6) months.push(m + 1)
  return months.length ? months.join(',') : null
}

const SEASONS: Record<string, string[]> = { estate: ['estate'], inverno: ['inverno'], 'mezze stagioni': ['primavera', 'autunno'] }
const SEARCH = 5000, PARK = 1500

// ---------- pipeline per una falesia ----------
async function enrichCrag(sb: any, crag: any, provided: any, areaMap: Map<string, any>, regionMap: Map<string, string>) {
  const area = crag.area_id ? areaMap.get(crag.area_id) : null
  const province = crag.province || (area ? area.name : null)
  const region = crag.region || regionMap.get((area && area.region_id) || crag.region_id) || null
  const country = crag.country === 'Italy' || crag.country === 'Italia' ? 'Italia' : crag.country
  const isItaly = country === 'Italia'

  const review: Record<string, any> = {}
  const result: Record<string, any> = { steps: [] }

  let lat = crag.latitude != null ? Number(crag.latitude) : null
  let lon = crag.longitude != null ? Number(crag.longitude) : null
  let alt = crag.altitude_m != null ? Number(crag.altitude_m) : null
  let orient = crag.orientation || null
  let orientVerified = false
  let coordStatus = lat != null ? 'preesistente' : ''

  // 1. coordinate (solo se mancano)
  if (lat == null) {
    const cands = placeCandidates(crag.name, crag.municipality)
    const town = await geocodeMulti(cands, province, region, country)
    if (town) {
      lat = town.lat; lon = town.lon; coordStatus = town.verified ? 'town-centroid' : 'town-unverified'
      const q = `[out:json][timeout:60];(node["sport"="climbing"](around:${SEARCH},${lat},${lon});way["sport"="climbing"](around:${SEARCH},${lat},${lon}););out center tags;`
      const climb = await overpass(q)
      const wc = climb.map((el) => ({ el, co: elCoord(el) })).filter((x) => x.co)
      const cand = [norm(crag.name), ...((crag.aliases || []) as string[]).map(norm)].filter(Boolean)
      const named = wc.filter((x) => { const n = norm(x.el.tags?.name || ''); return n && cand.some((k) => n.includes(k) || k.includes(n)) })
      let picked: any = null
      if (named.length) { named.sort((a, b) => hav(lat!, lon!, a.co.lat, a.co.lon) - hav(lat!, lon!, b.co.lat, b.co.lon)); picked = named[0]; coordStatus = 'osm-climbing-name' }
      else if (wc.length === 1) { picked = wc[0]; coordStatus = 'osm-climbing-single' }
      if (picked) { lat = picked.co.lat; lon = picked.co.lon; const t = picked.el.tags?.['climbing:orientation']; if (t && !orient) { orient = t; orientVerified = true } }
    } else coordStatus = 'no-geocode'
    result.steps.push('geocode:' + coordStatus)
  }

  // 2. quota (se manca e ho coord)
  if (alt == null && lat != null) { alt = await elevation(lat, lon!); result.steps.push('elevation:' + (alt != null ? Math.round(alt) : 'null')) }

  // 3. orientamento (se manca e ho coord) -> DEM stima
  if (!orient && lat != null) { const d = await demAspect(lat, lon!); if (d) { orient = d; result.steps.push('dem-aspect:' + d) } }

  // 3b. VALIDA orientamento fornito dall'utente vs DEM (non sovrascrive)
  if (crag.orientation && lat != null) {
    const dem = await demAspect(lat, lon!)
    if (dem) {
      const u = normalizeOrientation(crag.orientation), c = normalizeOrientation(dem)
      if (u.kind === 'exact' && c.kind === 'exact' && u.code !== c.code) {
        const gap = Math.abs(DIRS.indexOf(u.code!) - DIRS.indexOf(c.code!))
        const ring = Math.min(gap, 8 - gap)
        if (ring >= 2) review.orientation = { user: crag.orientation, computed: dem, note: 'DEM diverge >=90 gradi' }
      }
    }
    orient = crag.orientation; orientVerified = true
  }

  // 4. parcheggio (se manca e ho coord)
  let parking: string | null = crag.parking_notes || null
  if (!parking && lat != null) {
    const pq = `[out:json][timeout:60];(node["amenity"="parking"](around:${PARK},${lat},${lon});way["amenity"="parking"](around:${PARK},${lat},${lon}););out center tags;`
    const parks = (await overpass(pq)).map((el) => ({ co: elCoord(el) })).filter((x) => x.co).map((x) => ({ ...x, d: hav(lat!, lon!, x.co.lat, x.co.lon) })).sort((a, b) => a.d - b.d)
    if (parks.length) parking = `Parcheggio ~${Math.round(parks[0].d)}m: https://maps.google.com/?q=${parks[0].co.lat},${parks[0].co.lon}`
  }

  // 5. scoring stagionale
  const coastalMild = /balear|valenc/i.test(region || '') || (!isItaly && (alt ?? 999) < 80)
  const s = computeSeasonScores(orient, alt, coastalMild)
  const best = s.best_season || null

  // 6. best_months (Open-Meteo) se ho coord
  let bmonths: string | null = null
  if (lat != null) { bmonths = await bestMonths(lat, lon!, orient); result.steps.push('best_months:' + (bmonths || 'null')) }

  // ---------- SCRITTURA (solo campi vuoti) ----------
  const cragPatch: Record<string, any> = {}
  if (crag.latitude == null && lat != null) { cragPatch.latitude = lat; cragPatch.longitude = lon }
  if (crag.altitude_m == null && alt != null) cragPatch.altitude_m = Math.round(alt)
  if (!crag.orientation && orient) cragPatch.orientation = orient
  if ((!crag.best_seasons || crag.best_seasons.length === 0) && best) cragPatch.best_seasons = SEASONS[best] || [best]
  if (!crag.parking_notes && parking) cragPatch.parking_notes = parking
  if (Object.keys(cragPatch).length) await sb.from('crags').update(cragPatch).eq('id', crag.id)

  // settori: riempi solo i campi null di ciascun settore
  const { data: secs } = await sb.from('sectors').select('id,orientation,sun_morning,sun_afternoon,summer_score,winter_score,best_season,best_months,orientation_verified').eq('crag_id', crag.id)
  let sectorsWritten = 0
  for (const sec of secs || []) {
    const p: Record<string, any> = {}
    if (!sec.orientation && orient) p.orientation = orient
    if (sec.orientation_verified == null && orient) p.orientation_verified = orientVerified ? true : null
    if (!sec.sun_morning && s.sun_morning) p.sun_morning = s.sun_morning
    if (!sec.sun_afternoon && s.sun_afternoon) p.sun_afternoon = s.sun_afternoon
    if (sec.summer_score == null && s.summer_score != null) p.summer_score = s.summer_score
    if (sec.winter_score == null && s.winter_score != null) p.winter_score = s.winter_score
    if (!sec.best_season && best) p.best_season = best
    if (!sec.best_months && bmonths) p.best_months = bmonths
    if (Object.keys(p).length) { await sb.from('sectors').update(p).eq('id', sec.id); sectorsWritten++ }
  }

  result.coordStatus = coordStatus
  result.wrote = { crag: Object.keys(cragPatch), sectors: sectorsWritten }
  result.values = { lat, lon, alt: alt != null ? Math.round(alt) : null, orient, best_season: best, best_months: bmonths }
  const needsReview = Object.keys(review).length > 0 || s.needs_review || coordStatus === 'no-geocode' || coordStatus === 'town-unverified'
  return { result, review, needsReview }
}

// ---------- handler ----------
Deno.serve(async (req) => {
  const sb = createClient(Deno.env.get('SUPABASE_URL')!, Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!)
  let body: any = {}
  try { body = await req.json() } catch { /* vuoto */ }

  // mappe area/regione (una volta per invocazione)
  const [{ data: areas }, { data: regions }] = await Promise.all([
    sb.from('areas').select('id,name,region_id'),
    sb.from('regions').select('id,name'),
  ])
  const areaMap = new Map((areas || []).map((a: any) => [a.id, a]))
  const regionMap = new Map((regions || []).map((r: any) => [r.id, r.name]))

  const cragCols = 'id,name,aliases,country,region,province,municipality,latitude,longitude,altitude_m,orientation,best_seasons,parking_notes,area_id,region_id'

  // Modo 1: singola falesia (import client) -> assicura riga in coda, processa subito.
  if (body.crag_id) {
    await sb.from('enrichment_queue').upsert({ crag_id: body.crag_id, status: 'running', provided: body.provided || {}, updated_at: new Date().toISOString() }, { onConflict: 'crag_id' })
    const { data: crag } = await sb.from('crags').select(cragCols).eq('id', body.crag_id).single()
    if (!crag) return json({ error: 'crag non trovata' }, 404)
    try {
      const { result, review, needsReview } = await enrichCrag(sb, crag, body.provided || {}, areaMap, regionMap)
      await sb.from('enrichment_queue').update({ status: 'done', result, review, needs_review: needsReview, updated_at: new Date().toISOString() }).eq('crag_id', body.crag_id)
      return json({ ok: true, crag_id: body.crag_id, result, needsReview })
    } catch (e) {
      await sb.from('enrichment_queue').update({ status: 'error', last_error: String((e as Error).message), updated_at: new Date().toISOString() }).eq('crag_id', body.crag_id)
      return json({ error: String((e as Error).message) }, 500)
    }
  }

  // Modo 2: drain (cron). Claim atomico e processa.
  const batch = Math.min(Math.max(Number(body.batch) || 3, 1), 5)
  const { data: jobs, error } = await sb.rpc('claim_enrichment_jobs', { p_limit: batch })
  if (error) return json({ error: error.message }, 500)
  const out: any[] = []
  for (const job of jobs || []) {
    const { data: crag } = await sb.from('crags').select(cragCols).eq('id', job.crag_id).single()
    if (!crag) { await sb.from('enrichment_queue').update({ status: 'error', last_error: 'crag mancante', attempts: job.attempts + 1 }).eq('id', job.id); continue }
    try {
      const { result, review, needsReview } = await enrichCrag(sb, crag, job.provided || {}, areaMap, regionMap)
      await sb.from('enrichment_queue').update({ status: 'done', result, review, needs_review: needsReview, updated_at: new Date().toISOString() }).eq('id', job.id)
      out.push({ crag: crag.name, status: 'done', coord: result.coordStatus })
    } catch (e) {
      const attempts = job.attempts + 1
      await sb.from('enrichment_queue').update({ status: attempts >= job.max_attempts ? 'error' : 'pending', last_error: String((e as Error).message), attempts, updated_at: new Date().toISOString() }).eq('id', job.id)
      out.push({ crag: crag.name, status: 'retry', error: String((e as Error).message) })
    }
  }
  return json({ processed: out.length, jobs: out })
})

function json(o: unknown, status = 200) {
  return new Response(JSON.stringify(o), { status, headers: { 'Content-Type': 'application/json' } })
}
