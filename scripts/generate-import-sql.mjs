#!/usr/bin/env node
// Generates reports/import.sql from all sector JSON files.
// No network needed — reads local files only.
// Usage: node scripts/generate-import-sql.mjs

import { readFileSync, writeFileSync, readdirSync, statSync, mkdirSync, existsSync } from 'node:fs'
import { join, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = join(__dirname, '..')
const CRAGS_DIR = join(ROOT, 'src', 'data', 'crags', 'italia')
const REPORTS_DIR = join(ROOT, 'reports')

const ITALY_ID = '00000000-0000-0000-0001-000000000001'

const REGION_IDS = {
  'lazio':        '00000000-0000-0000-0002-000000000007',
  'abruzzo':      '00000000-0000-0000-0002-000000000001',
  'umbria':       '00000000-0000-0000-0002-000000000018',
  'molise':       '00000000-0000-0000-0002-000000000011',
  "valle d'aosta":'00000000-0000-0000-0002-000000000019',
  'sardegna':     '00000000-0000-0000-0002-000000000014',
}

function walkJson(dir) {
  const results = []
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry)
    if (statSync(full).isDirectory()) results.push(...walkJson(full))
    else if (entry.endsWith('.json')) results.push(full)
  }
  return results.sort()
}

function norm(s) {
  return s.toLowerCase().trim().normalize('NFD').replace(/[̀-ͯ]/g, '')
}

function slug(s) {
  return s.toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '').replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '')
}

function esc(s) {
  if (s === null || s === undefined) return 'NULL'
  return "'" + String(s).replace(/'/g, "''") + "'"
}

// Group sectors by crag
const files = walkJson(CRAGS_DIR)
const cragMap = new Map() // cragKey -> { data, sectors[] }

for (const file of files) {
  const data = JSON.parse(readFileSync(file, 'utf8'))
  const key = norm(data.crag) + '|' + norm(data.region)
  if (!cragMap.has(key)) {
    cragMap.set(key, {
      name: data.crag,
      region: data.region,
      province: data.province,
      municipality: data.municipality ?? null,
      sectors: []
    })
  }
  cragMap.get(key).sectors.push({ name: data.sector, routes: data.routes })
}

const lines = []

lines.push('-- Capital Climbing — crag/sector/route import')
lines.push('-- Generated: ' + new Date().toISOString())
lines.push('-- Paste in Supabase SQL Editor and run.')
lines.push('-- Safe to re-run: skips existing records by name.')
lines.push('')
lines.push('DO $$')
lines.push('DECLARE')
lines.push('  v_crag_id   uuid;')
lines.push('  v_sector_id uuid;')
lines.push('BEGIN')
lines.push('')

let cragCount = 0
let sectorCount = 0
let routeCount = 0

for (const [, crag] of cragMap) {
  const regionId = REGION_IDS[norm(crag.region)] ?? null
  if (!regionId) {
    lines.push(`  -- ⚠️  REGION NOT FOUND: ${crag.region} — skipped ${crag.name}`)
    continue
  }

  cragCount++
  lines.push(`  -- ── ${crag.name} (${crag.region}) ──`)
  lines.push(`  SELECT id INTO v_crag_id FROM crags`)
  lines.push(`    WHERE lower(name) = lower(${esc(crag.name)})`)
  lines.push(`      AND region_id = '${regionId}' LIMIT 1;`)
  lines.push(`  IF v_crag_id IS NULL THEN`)
  lines.push(`    -- Also check crags without region_id (from previous imports)`)
  lines.push(`    SELECT id INTO v_crag_id FROM crags`)
  lines.push(`      WHERE lower(name) = lower(${esc(crag.name)}) AND region_id IS NULL LIMIT 1;`)
  lines.push(`    IF v_crag_id IS NOT NULL THEN`)
  lines.push(`      UPDATE crags SET region_id = '${regionId}', country_id = '${ITALY_ID}',`)
  lines.push(`        region = ${esc(crag.region)}, province = ${esc(crag.province)},`)
  lines.push(`        municipality = ${esc(crag.municipality)}`)
  lines.push(`      WHERE id = v_crag_id;`)
  lines.push(`    ELSE`)
  lines.push(`      INSERT INTO crags (name, normalized_name, slug, country, country_id, region, region_id, province, municipality, access_status, rainproof, services, aliases)`)
  lines.push(`      VALUES (${esc(crag.name)}, ${esc(norm(crag.name))}, ${esc(slug(crag.name))},`)
  lines.push(`              'Italy', '${ITALY_ID}', ${esc(crag.region)}, '${regionId}',`)
  lines.push(`              ${esc(crag.province)}, ${esc(crag.municipality)}, 'open', false, '{}', '{}')`)
  lines.push(`      RETURNING id INTO v_crag_id;`)
  lines.push(`    END IF;`)
  lines.push(`  END IF;`)
  lines.push('')

  for (const sector of crag.sectors) {
    sectorCount++
    lines.push(`  -- Settore: ${sector.name}`)
    lines.push(`  SELECT id INTO v_sector_id FROM sectors`)
    lines.push(`    WHERE lower(name) = lower(${esc(sector.name)}) AND crag_id = v_crag_id LIMIT 1;`)
    lines.push(`  IF v_sector_id IS NULL THEN`)
    lines.push(`    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)`)
    lines.push(`    VALUES (${esc(sector.name)}, ${esc(norm(sector.name))}, ${esc(slug(sector.name))}, v_crag_id, '{}', 0)`)
    lines.push(`    RETURNING id INTO v_sector_id;`)
    lines.push(`  END IF;`)

    for (const route of sector.routes) {
      routeCount++
      const grade = route.grade !== null ? esc(route.grade) : 'NULL'
      lines.push(`  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)`)
      lines.push(`  SELECT ${esc(route.name)}, ${esc(norm(route.name))}, ${esc(slug(route.name))}, ${grade}, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'`)
      lines.push(`  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower(${esc(route.name)}) AND sector_id = v_sector_id);`)
    }
    lines.push('')
  }
}

lines.push('END $$;')
lines.push('')
lines.push(`-- Summary: ${cragCount} crags, ${sectorCount} sectors, ${routeCount} routes`)

if (!existsSync(REPORTS_DIR)) mkdirSync(REPORTS_DIR, { recursive: true })
const outPath = join(REPORTS_DIR, 'import.sql')
writeFileSync(outPath, lines.join('\n') + '\n')
console.log(`\nSQL written to reports/import.sql`)
console.log(`  Crags  : ${cragCount}`)
console.log(`  Sectors: ${sectorCount}`)
console.log(`  Routes : ${routeCount}\n`)
