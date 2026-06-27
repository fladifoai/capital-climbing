#!/usr/bin/env node
// Blocco 11b — import reale logbook
// Inserisce le ascensioni canonical nel DB come utente flavio.
// Usa service role key (bypass RLS). NON committare .env.

import { readFileSync, existsSync } from 'node:fs'
import { resolve, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'
import { createClient } from '@supabase/supabase-js'

const __dirname = dirname(fileURLToPath(import.meta.url))

const USER_ID = '48268928-bbc1-4217-a07d-c3cc18e11592'

const GRADE_NUMERIC = {
  '5c': 0, '6a': 1, '6a+': 2,
  '6b': 3, '6b/6b+': 3.5, '6b+': 4,
  '6c': 5, '6c/6c+': 5.5, '6c+': 6,
  '6c+/7a': 6.5, '7a': 7, '7a+': 8,
  '7b': 9, '7b+': 10, '7c': 11,
  '7c+': 12, '8a': 13, '8a+': 14, '8b': 15,
}

function loadEnv() {
  const envPath = resolve(__dirname, '../.env')
  if (!existsSync(envPath)) { console.error('❌ .env non trovato'); process.exit(1) }
  const env = {}
  for (const line of readFileSync(envPath, 'utf8').split('\n')) {
    const m = line.match(/^([^#=\s][^=]*)=(.*)$/)
    if (m) env[m[1].trim()] = m[2].trim().replace(/^["']|["']$/g, '')
  }
  return env
}

function parseMarkdownTable(md) {
  const lines = md.split('\n')
  let headers = null
  const rows = []
  for (const line of lines) {
    const trimmed = line.trim()
    if (!trimmed.startsWith('|')) continue
    if (/^\|[-| ]+\|$/.test(trimmed)) continue
    const cells = trimmed.split('|').slice(1, -1).map(c => c.trim())
    if (!headers) { headers = cells.map(h => h.toLowerCase().replace(/[\s/]+/g, '_')); continue }
    if (cells.length !== headers.length) continue
    const row = {}
    headers.forEach((h, i) => { row[h] = cells[i] === '—' || cells[i] === '' ? null : cells[i] })
    rows.push(row)
  }
  return rows
}

function norm(s) {
  return (s ?? '').toLowerCase().trim().replace(/\s+/g, ' ').replace(/[''‚‛`‘’‚‛]/g, "'")
}

async function main() {
  const env = loadEnv()
  const url = env.SUPABASE_URL ?? env.VITE_SUPABASE_URL
  const secret = env.SUPABASE_SECRET_KEY

  if (!url || !secret) { console.error('❌ SUPABASE_URL o SUPABASE_SECRET_KEY mancanti nel .env'); process.exit(1) }

  const sb = createClient(url, secret, { auth: { autoRefreshToken: false, persistSession: false } })

  const defaultPath = resolve(__dirname, '../../../OneDrive/Desktop/Claude/Capital climbing/Flavio vie_scalate.md')
  const logbookPath = process.argv[2] ?? defaultPath
  if (!existsSync(logbookPath)) { console.error(`❌ File non trovato: ${logbookPath}`); process.exit(1) }

  const rows = parseMarkdownTable(readFileSync(logbookPath, 'utf8'))
  const canonical = rows.filter(r => r.status === 'canonical')
  console.log(`\n📋 ${rows.length} righe totali, ${canonical.length} canonical da importare\n`)

  // Carica catalogo
  const [{ data: crags, error: ce }, { data: routes, error: re }] = await Promise.all([
    sb.from('crags').select('id, name'),
    sb.from('routes').select('id, name, sectors(crag_id)'),
  ])
  if (ce) { console.error('❌ crags:', ce.message); process.exit(1) }
  if (re) { console.error('❌ routes:', re.message); process.exit(1) }

  const cragByName = new Map((crags ?? []).map(c => [norm(c.name), c]))
  const routesByCragId = new Map()
  for (const r of (routes ?? [])) {
    const cragId = r.sectors?.crag_id
    if (!cragId) continue
    if (!routesByCragId.has(cragId)) routesByCragId.set(cragId, [])
    routesByCragId.get(cragId).push(r)
  }

  // Controlla ascensioni già presenti (dedup per date + route_id)
  const { data: existing } = await sb.from('ascents').select('date, route_id').eq('user_id', USER_ID)
  const existingKeys = new Set((existing ?? []).map(a => `${a.date}|${a.route_id}`))

  const results = { inserted: [], skipped_dup: [], unmatched: [], errors: [] }

  for (const row of canonical) {
    const { crag: cragName, route: routeName, route_aliases, grade, attempt_key, beauty_1_5, notes, date } = row

    // Match route
    const crag = cragByName.get(norm(cragName))
    if (!crag) { results.unmatched.push(`${date} ${cragName} › ${routeName}`); continue }

    const aliases = (route_aliases ?? '').split(';').map(a => a.trim()).filter(Boolean)
    const allNames = [routeName, ...aliases].map(norm)
    const cragRoutes = routesByCragId.get(crag.id) ?? []
    const hit = cragRoutes.find(r => allNames.includes(norm(r.name)))

    if (!hit) { results.unmatched.push(`${date} ${cragName} › ${routeName}`); continue }

    // Dedup
    const key = `${date}|${hit.id}`
    if (existingKeys.has(key)) { results.skipped_dup.push(`${date} ${cragName} › ${routeName}`); continue }

    const gradeNumeric = GRADE_NUMERIC[grade ?? ''] ?? null
    const quality = beauty_1_5 ? parseInt(beauty_1_5, 10) : null

    const { error } = await sb.from('ascents').insert({
      user_id: USER_ID,
      route_id: hit.id,
      date,
      status: 'completed',
      attempt_type: attempt_key ?? 'unknown',
      grade_at_ascent: grade ?? null,
      grade_numeric_at_ascent: gradeNumeric,
      quality: quality && quality >= 1 && quality <= 5 ? quality : null,
      notes: notes ?? null,
      visibility: 'private',
      score: null,
      needs_review: false,
      kneepad_used: null,
      effort: null,
      ascent_style: null,
      attempt_count: null,
      attempt_bucket: null,
      personal_grade: null,
    })

    if (error) {
      results.errors.push(`${date} ${cragName} › ${routeName}: ${error.message}`)
    } else {
      existingKeys.add(key)
      results.inserted.push(`${date} ${cragName} › ${routeName} [${grade ?? '?'}] ${attempt_key ?? '?'}`)
    }
  }

  // Report
  const W = 62
  console.log('━'.repeat(W))
  console.log(`✅  Inserite   : ${String(results.inserted.length).padStart(3)}`)
  console.log(`⏭   Duplicati  : ${String(results.skipped_dup.length).padStart(3)}`)
  console.log(`❓  Non matchate: ${String(results.unmatched.length).padStart(3)}`)
  console.log(`❌  Errori      : ${String(results.errors.length).padStart(3)}`)
  console.log('━'.repeat(W))

  if (results.inserted.length > 0) {
    console.log('\n✅  INSERITE:')
    for (const r of results.inserted) console.log(`    ${r}`)
  }
  if (results.skipped_dup.length > 0) {
    console.log('\n⏭  DUPLICATE (saltate):')
    for (const r of results.skipped_dup) console.log(`    ${r}`)
  }
  if (results.unmatched.length > 0) {
    console.log('\n❓  NON MATCHATE:')
    for (const r of results.unmatched) console.log(`    ${r}`)
  }
  if (results.errors.length > 0) {
    console.log('\n❌  ERRORI:')
    for (const r of results.errors) console.log(`    ${r}`)
  }
  console.log()
}

main().catch(e => { console.error('❌', e.message); process.exit(1) })
