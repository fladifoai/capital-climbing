#!/usr/bin/env node
// enrich_crags_osm.mjs — arricchimento metadati falesie da fonti open (OSM/Overpass, Open-Meteo).
//
// PERCHE Node e non Python: sul repo non esiste enrich_crags_osm.py e la macchina non ha
// runtime Python. Node 22 (fetch globale) e nativo del progetto. Nessuna dipendenza esterna.
//
// Cosa fa, per ogni falesia del CSV di input:
//  1. Geocoda il COMUNE (nome+regione+nazione) con Nominatim -> punto affidabile (centroide comune).
//  2. Interroga Overpass per nodi/way sport=climbing entro RADIUS dal comune.
//     - se un elemento climbing ha nome che matcha crag_name/alias -> "snap" li (status osm-climbing-name).
//     - altrimenti se c'e UN SOLO elemento climbing vicino -> snap (status osm-climbing-single).
//     - altrimenti resta il punto del comune (status verify-on-map): NON affidabile, va guardato su mappa.
//  3. Elevazione al punto finale via Open-Meteo (no key).
//  4. Parcheggio: amenity=parking piu vicino al punto finale (entro PARK_RADIUS), se esiste.
//
// RIGORE: nessun dato inventato. Ogni campo scrive provenienza (source/license/confidence/status).
// Coordinate mai "verified" da qui: al massimo "osm-climbing-*" o "verify-on-map". La verifica
// visiva su mappa e un passo umano separato.
//
// Idempotente: le risposte grezze sono cachate in ./cache/. Rilanci non ri-colpiscono le API.
// Uso: node enrich_crags_osm.mjs [--in crags_metadata.csv] [--out crags_enriched.csv]

import { readFileSync, writeFileSync, existsSync, mkdirSync, readdirSync } from 'node:fs';
import { createHash } from 'node:crypto';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const __dir = dirname(fileURLToPath(import.meta.url));
const args = process.argv.slice(2);
const getArg = (name, def) => {
  const i = args.indexOf(name);
  return i >= 0 && args[i + 1] ? args[i + 1] : def;
};
const IN = join(__dir, getArg('--in', 'crags_metadata.csv'));
const OUT = join(__dir, getArg('--out', 'crags_enriched.csv'));
const PROV_OUT = join(__dir, 'field_provenance.csv');
const CACHE = join(__dir, 'cache');
if (!existsSync(CACHE)) mkdirSync(CACHE, { recursive: true });

const UA = 'CapitalClimbing-crag-enrichment/1.0 (personal catalog; contact flavioaugusto.difoggia@gmail.com)';
const SEARCH_RADIUS_M = 5000;   // raggio ricerca climbing attorno al comune
const PARK_RADIUS_M = 1500;     // raggio ricerca parcheggio attorno al punto finale
const NOMINATIM_DELAY_MS = 1200; // rate limit cortesia (Nominatim: max 1 req/s)
const OVERPASS_DELAY_MS = 4000;

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

// ---------- CSV minimale (gestisce virgolette) ----------
function parseCSV(text) {
  const rows = [];
  let row = [], field = '', inQ = false;
  for (let i = 0; i < text.length; i++) {
    const c = text[i];
    if (inQ) {
      if (c === '"') { if (text[i + 1] === '"') { field += '"'; i++; } else inQ = false; }
      else field += c;
    } else {
      if (c === '"') inQ = true;
      else if (c === ',') { row.push(field); field = ''; }
      else if (c === '\n') { row.push(field); rows.push(row); row = []; field = ''; }
      else if (c === '\r') { /* skip */ }
      else field += c;
    }
  }
  if (field.length || row.length) { row.push(field); rows.push(row); }
  return rows.filter((r) => r.length > 1 || (r.length === 1 && r[0].trim() !== ''));
}
function toCSV(rows) {
  return rows.map((r) => r.map((v) => {
    const s = v == null ? '' : String(v);
    return /[",\n]/.test(s) ? '"' + s.replace(/"/g, '""') + '"' : s;
  }).join(',')).join('\n') + '\n';
}

// ---------- normalizzazione nomi ----------
const norm = (s) => (s || '')
  .toLowerCase()
  .normalize('NFD').replace(/[̀-ͯ]/g, '')
  .replace(/[^a-z0-9 ]/g, ' ')
  .replace(/\s+/g, ' ').trim();

function nameMatches(elName, crag) {
  const en = norm(elName);
  if (!en) return false;
  const candidates = [crag.crag_name, ...(crag.aliases || '').split(';'), ...(crag.sectors || '').split(';')]
    .map(norm).filter(Boolean);
  return candidates.some((c) => c && (en.includes(c) || c.includes(en)));
}

// ---------- fetch con cache su disco ----------
async function cachedFetch(url, opts = {}, tag = 'get') {
  const key = createHash('sha1').update(tag + '|' + url + '|' + (opts.body || '')).digest('hex').slice(0, 16);
  const file = join(CACHE, `${tag}_${key}.json`);
  if (existsSync(file)) return JSON.parse(readFileSync(file, 'utf8'));
  // retry con backoff sui codici transitori (Overpass 429/504/503/502)
  const RETRY = [0, 5000, 12000, 25000];
  let lastErr;
  for (let attempt = 0; attempt < RETRY.length; attempt++) {
    if (RETRY[attempt]) await sleep(RETRY[attempt]);
    try {
      const res = await fetch(url, { ...opts, headers: { 'User-Agent': UA, ...(opts.headers || {}) } });
      if ([429, 502, 503, 504].includes(res.status)) { lastErr = new Error(`HTTP ${res.status}`); continue; }
      if (!res.ok) throw new Error(`HTTP ${res.status} for ${url}`);
      const data = await res.json();
      writeFileSync(file, JSON.stringify(data));
      return data;
    } catch (e) { lastErr = e; }
  }
  throw lastErr || new Error('fetch failed');
}

// ---------- geocode comune (Nominatim) ----------
async function geocodeMunicipality(crag) {
  const parts = [crag.municipality_clean || crag.crag_name, crag.province_or_island, crag.region, crag.country]
    .filter(Boolean).join(', ');
  const url = 'https://nominatim.openstreetmap.org/search?format=jsonv2&limit=1&q=' + encodeURIComponent(parts);
  const data = await cachedFetch(url, {}, 'nominatim');
  if (!Array.isArray(data) || !data.length) return null;
  return { lat: parseFloat(data[0].lat), lon: parseFloat(data[0].lon), display: data[0].display_name, query: parts };
}

// ---------- Overpass: climbing + parking attorno a un punto ----------
async function overpassAround(lat, lon) {
  const q = `[out:json][timeout:60];
(
  node["sport"="climbing"](around:${SEARCH_RADIUS_M},${lat},${lon});
  way["sport"="climbing"](around:${SEARCH_RADIUS_M},${lat},${lon});
  node["climbing"](around:${SEARCH_RADIUS_M},${lat},${lon});
  way["natural"="cliff"]["sport"="climbing"](around:${SEARCH_RADIUS_M},${lat},${lon});
);
out center tags;`;
  const data = await cachedFetch('https://overpass-api.de/api/interpreter',
    { method: 'POST', body: 'data=' + encodeURIComponent(q), headers: { 'Content-Type': 'application/x-www-form-urlencoded' } },
    'overpass_climb');
  return data.elements || [];
}
async function overpassParking(lat, lon) {
  const q = `[out:json][timeout:60];
(
  node["amenity"="parking"](around:${PARK_RADIUS_M},${lat},${lon});
  way["amenity"="parking"](around:${PARK_RADIUS_M},${lat},${lon});
);
out center tags;`;
  const data = await cachedFetch('https://overpass-api.de/api/interpreter',
    { method: 'POST', body: 'data=' + encodeURIComponent(q), headers: { 'Content-Type': 'application/x-www-form-urlencoded' } },
    'overpass_park');
  return data.elements || [];
}

// ---------- Open-Meteo elevation ----------
async function elevation(lat, lon) {
  const url = `https://api.open-meteo.com/v1/elevation?latitude=${lat}&longitude=${lon}`;
  const data = await cachedFetch(url, {}, 'elev');
  return Array.isArray(data.elevation) ? data.elevation[0] : null;
}

// ---------- geo utils ----------
const R = 6371000;
const toRad = (d) => (d * Math.PI) / 180;
function haversine(a, b, c, d) {
  const dLat = toRad(c - a), dLon = toRad(d - b);
  const s = Math.sin(dLat / 2) ** 2 + Math.cos(toRad(a)) * Math.cos(toRad(c)) * Math.sin(dLon / 2) ** 2;
  return 2 * R * Math.asin(Math.sqrt(s));
}
const elCoord = (el) => el.type === 'node' ? { lat: el.lat, lon: el.lon } : (el.center || null);

// ---------- main ----------
const rows = parseCSV(readFileSync(IN, 'utf8'));
const header = rows[0];
const idx = Object.fromEntries(header.map((h, i) => [h.trim(), i]));
const crags = rows.slice(1).map((r) => {
  const o = {};
  for (const h of header) o[h.trim()] = (r[idx[h.trim()]] || '').trim();
  // comune "pulito": toglie parentesi e "da_verificare"
  o.municipality_clean = o.municipality.replace(/\(.*?\)/g, '').trim();
  return o;
});

const outHeader = [
  'crag_id', 'country', 'region', 'province_or_island', 'municipality', 'crag_name',
  'latitude', 'longitude', 'coord_status', 'coord_source_element', 'coord_dist_from_town_m',
  'altitude_m', 'parking_lat', 'parking_lon', 'parking_dist_m',
  'rock_type', 'needs_review', 'notes',
];
const provHeader = ['crag_id', 'crag_name', 'field', 'value', 'source', 'source_license', 'confidence', 'status', 'last_verified'];
const TODAY = new Date().toISOString().slice(0, 10);
const outRows = [outHeader];
const provRows = [provHeader];
const prov = (c, field, value, source, license, confidence, status) =>
  provRows.push([c.crag_id, c.crag_name, field, value ?? '', source, license, confidence, status, value == null || value === '' ? '' : TODAY]);

for (const c of crags) {
  const note = [];
  let lat = '', lon = '', coordStatus = 'no-geocode', coordEl = '', distTown = '';
  let alt = '', pLat = '', pLon = '', pDist = '', rock = '';
  let needsReview = false;

  process.stderr.write(`\n[${c.crag_id}] ${c.crag_name} ...`);

  // se comune sconosciuto, geocoda comunque col nome falesia ma marca review
  if (c.municipality_status === 'da_verificare' || !c.municipality_clean) {
    needsReview = true;
    note.push('comune da verificare');
  }

  let town = null;
  try { town = await geocodeMunicipality(c); await sleep(NOMINATIM_DELAY_MS); }
  catch (e) { note.push('nominatim: ' + e.message); }

  if (town) {
    lat = town.lat; lon = town.lon; coordStatus = 'town-centroid'; coordEl = 'nominatim:' + (c.municipality_clean || c.crag_name);
    // cerca climbing attorno
    let climb = [];
    try { climb = await overpassAround(town.lat, town.lon); await sleep(OVERPASS_DELAY_MS); }
    catch (e) { note.push('overpass climb: ' + e.message); }
    const withCoord = climb.map((el) => ({ el, co: elCoord(el) })).filter((x) => x.co);
    const named = withCoord.filter((x) => nameMatches(x.el.tags?.name || '', c));

    let picked = null, why = '';
    if (named.length) {
      // prendi il match per nome piu vicino al comune
      named.sort((a, b) => haversine(town.lat, town.lon, a.co.lat, a.co.lon) - haversine(town.lat, town.lon, b.co.lat, b.co.lon));
      picked = named[0]; why = 'osm-climbing-name';
    } else if (withCoord.length === 1) {
      picked = withCoord[0]; why = 'osm-climbing-single';
    } else if (withCoord.length > 1) {
      why = 'osm-climbing-multi'; // ambiguo: non snappare, resta comune
      note.push(`${withCoord.length} nodi climbing vicini senza match nome`);
    }

    if (picked) {
      lat = picked.co.lat; lon = picked.co.lon; coordStatus = why;
      coordEl = `${picked.el.type}/${picked.el.id}` + (picked.el.tags?.name ? ` (${picked.el.tags.name})` : '');
      distTown = Math.round(haversine(town.lat, town.lon, lat, lon));
      rock = picked.el.tags?.['climbing:rock'] || picked.el.tags?.rock || '';
    } else {
      coordStatus = 'verify-on-map';
      needsReview = true;
    }

    // parcheggio attorno al punto finale
    let parks = [];
    try { parks = await overpassParking(lat, lon); await sleep(OVERPASS_DELAY_MS); }
    catch (e) { note.push('overpass park: ' + e.message); }
    const pc = parks.map((el) => ({ el, co: elCoord(el) })).filter((x) => x.co)
      .map((x) => ({ ...x, d: haversine(lat, lon, x.co.lat, x.co.lon) })).sort((a, b) => a.d - b.d);
    if (pc.length) { pLat = pc[0].co.lat; pLon = pc[0].co.lon; pDist = Math.round(pc[0].d); }

    // elevazione
    try { alt = await elevation(lat, lon); } catch (e) { note.push('elev: ' + e.message); }
  } else {
    coordStatus = 'no-geocode'; needsReview = true; note.push('geocoding fallito');
  }

  outRows.push([
    c.crag_id, c.country, c.region, c.province_or_island, c.municipality, c.crag_name,
    lat, lon, coordStatus, coordEl, distTown,
    alt, pLat, pLon, pDist, rock, needsReview ? 'true' : 'false', note.join('; '),
  ]);

  // provenienza per campo
  const coordConf = coordStatus === 'osm-climbing-name' ? 'med' : (coordStatus.startsWith('osm-climbing') ? 'low' : 'low');
  prov(c, 'latitude', lat, 'OpenStreetMap/Overpass', 'ODbL', coordConf, coordStatus === 'osm-climbing-name' || coordStatus.startsWith('osm-climbing') ? 'osm-snapped' : 'verify-on-map');
  prov(c, 'longitude', lon, 'OpenStreetMap/Overpass', 'ODbL', coordConf, coordStatus === 'osm-climbing-name' || coordStatus.startsWith('osm-climbing') ? 'osm-snapped' : 'verify-on-map');
  prov(c, 'altitude_m', alt, 'Open-Meteo Elevation (Copernicus DEM)', 'open', alt === '' || alt == null ? 'low' : 'med', alt === '' || alt == null ? 'missing' : 'derived-from-coord');
  prov(c, 'parking', pLat ? `${pLat},${pLon}` : '', 'OpenStreetMap/Overpass', 'ODbL', pLat ? 'med' : 'low', pLat ? 'osm-nearest' : 'missing');
  prov(c, 'rock_type', rock, rock ? 'OpenStreetMap' : '', rock ? 'ODbL' : '', rock ? 'low' : 'low', rock ? 'osm-tag' : 'missing');
  process.stderr.write(` ${coordStatus} alt=${alt} park=${pDist || '-'}m`);
}

writeFileSync(OUT, toCSV(outRows));
writeFileSync(PROV_OUT, toCSV(provRows));
process.stderr.write(`\n\nOK -> ${OUT}\n   -> ${PROV_OUT}\n   crag rows: ${outRows.length - 1}, cache files: ${readdirSync(CACHE).length}\n`);
