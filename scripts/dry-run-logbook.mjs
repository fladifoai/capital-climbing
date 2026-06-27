#!/usr/bin/env node
// Blocco 11 — dry-run logbook
// Legge Flavio vie_scalate.md, verifica quante ascensioni trovano corrispondenza nel catalogo.
// NON scrive nulla nel DB. NON committare dati personali.

import { readFileSync, existsSync } from 'node:fs'
import { resolve, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'
import { createClient } from '@supabase/supabase-js'

const __dirname = dirname(fileURLToPath(import.meta.url))

function loadEnv() {
  const envPath = resolve(__dirname, '../.env')
  if (!existsSync(envPath)) {
    console.error('❌ .env non trovato. Crea capital-climbing/.env con SUPABASE_URL e SUPABASE_KEY.')
    process.exit(1)
  }
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
    if (/^\|[-| ]+\|$/.test(trimmed)) continue // separator

    const cells = trimmed.split('|').slice(1, -1).map(c => c.trim())

    if (!headers) {
      headers = cells.map(h => h.toLowerCase().replace(/[\s/]+/g, '_'))
      continue
    }

    if (cells.length !== headers.length) continue

    const row = {}
    headers.forEach((h, i) => { row[h] = cells[i] === '—' || cells[i] === '' ? null : cells[i] })
    rows.push(row)
  }
  return rows
}

function norm(s) {
  return (s ?? '').toLowerCase().trim().replace(/\s+/g, ' ').replace(/[‘’‚‛`]/g, "'")
}

async function main() {
  const env = loadEnv()
  const url = env.SUPABASE_URL ?? env.VITE_SUPABASE_URL
  const key = env.SUPABASE_KEY ?? env.SUPABASE_ANON_KEY ?? env.VITE_SUPABASE_PUBLISHABLE_KEY

  if (!url || !key) {
    console.error('❌ SUPABASE_URL o SUPABASE_KEY mancanti nel .env')
    process.exit(1)
  }

  const supabase = createClient(url, key)

  const defaultPath = resolve(__dirname, '../../../OneDrive/Desktop/Claude/Capital climbing/Flavio vie_scalate.md')
  const logbookPath = process.argv[2] ?? defaultPath

  if (!existsSync(logbookPath)) {
    console.error(`❌ File non trovato: ${logbookPath}`)
    console.error('   Uso: node scripts/dry-run-logbook.mjs [percorso/logbook.md]')
    process.exit(1)
  }

  const rows = parseMarkdownTable(readFileSync(logbookPath, 'utf8'))
  console.log(`\n📋 Lette ${rows.length} righe da logbook\n`)

  // Carica catalogo da DB
  const [{ data: crags, error: ce }, { data: routes, error: re }] = await Promise.all([
    supabase.from('crags').select('id, name'),
    supabase.from('routes').select('id, name, official_grade, sectors(crag_id)'),
  ])

  if (ce) { console.error('❌ Errore crags:', ce.message); process.exit(1) }
  if (re) { console.error('❌ Errore routes:', re.message); process.exit(1) }

  const cragByName = new Map((crags ?? []).map(c => [norm(c.name), c]))

  const routesByCragId = new Map()
  for (const r of (routes ?? [])) {
    const cragId = r.sectors?.crag_id
    if (!cragId) continue
    if (!routesByCragId.has(cragId)) routesByCragId.set(cragId, [])
    routesByCragId.get(cragId).push(r)
  }

  const results = { matched: [], new_crag: [], new_route: [], needs_review: [] }

  for (const row of rows) {
    const { ascent_id: id, status, crag: cragName, route: routeName, route_aliases, grade, attempt_key, date, notes } = row

    if (status === 'needs_review') {
      results.needs_review.push({ id, cragName, routeName, notes })
      continue
    }

    const crag = cragByName.get(norm(cragName))
    if (!crag) {
      results.new_crag.push({ id, cragName, routeName, date })
      continue
    }

    const aliases = (route_aliases ?? '').split(';').map(a => a.trim()).filter(Boolean)
    const allNames = [routeName, ...aliases].map(norm)
    const cragRoutes = routesByCragId.get(crag.id) ?? []
    const hit = cragRoutes.find(r => allNames.includes(norm(r.name)))

    if (hit) {
      results.matched.push({ id, cragName, routeName, route_id: hit.id, grade, attempt: attempt_key, date })
    } else {
      results.new_route.push({ id, cragName, routeName, date, grade })
    }
  }

  // Report
  const W = 62
  const line = '━'.repeat(W)
  console.log(line)
  console.log(`✅  Matchate         : ${String(results.matched.length).padStart(3)}`)
  console.log(`🏔   Falesia mancante : ${String(results.new_crag.length).padStart(3)}`)
  console.log(`🪨   Via mancante     : ${String(results.new_route.length).padStart(3)}`)
  console.log(`⚠️   Needs review     : ${String(results.needs_review.length).padStart(3)}`)
  console.log(line)

  if (results.matched.length > 0) {
    console.log('\n✅  ASCENSIONI MATCHATE:')
    for (const r of results.matched) {
      console.log(`    ${r.date}  ${r.cragName} › ${r.routeName}  [${r.grade ?? '?'}] ${r.attempt ?? '?'}`)
      console.log(`    → route_id: ${r.route_id}`)
    }
  }

  if (results.new_crag.length > 0) {
    console.log('\n🏔  FALESIE NON NEL CATALOGO (bloccano import):')
    const uniq = [...new Set(results.new_crag.map(r => r.cragName))]
    for (const c of uniq) {
      const n = results.new_crag.filter(r => r.cragName === c).length
      console.log(`    ${c}  (${n} ascension${n === 1 ? 'e' : 'i'})`)
    }
  }

  if (results.new_route.length > 0) {
    console.log('\n🪨  VIE NON NEL CATALOGO (bloccano import):')
    for (const r of results.new_route) {
      console.log(`    ${r.date}  ${r.cragName} › ${r.routeName}  [${r.grade ?? '?'}]`)
    }
  }

  if (results.needs_review.length > 0) {
    console.log('\n⚠️  NEEDS REVIEW (saltate automaticamente):')
    for (const r of results.needs_review) {
      console.log(`    ${r.id}  ${r.cragName} › ${r.routeName}`)
      if (r.notes) console.log(`    → ${r.notes}`)
    }
  }

  const canImport = results.new_crag.length === 0 && results.new_route.length === 0 && results.matched.length > 0
  console.log('\n💡  PROSSIMI PASSI:')
  if (results.new_crag.length > 0 || results.new_route.length > 0) {
    console.log('    1. Aggiungi falesie/vie mancanti nel catalogo (Admin → CSV import).')
    console.log('    2. Ri-esegui: npm run dry-run-logbook')
  }
  if (results.needs_review.length > 0) {
    console.log('    3. Verifica manualmente i record needs_review.')
  }
  if (canImport) {
    console.log('    ✓ Tutto matchato. Pronto per import reale (Blocco 11b).')
  }
  console.log()
}

main().catch(e => { console.error('❌', e.message); process.exit(1) })
