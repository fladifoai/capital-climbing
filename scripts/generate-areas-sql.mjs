#!/usr/bin/env node
// Generates reports/areas.sql — creates areas (province level) and links crags to them.
// Run AFTER import.sql has been executed in Supabase.

import { readFileSync, writeFileSync, readdirSync, statSync, mkdirSync, existsSync } from 'node:fs'
import { join, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = join(__dirname, '..')
const CRAGS_DIR = join(ROOT, 'src', 'data', 'crags', 'italia')
const REPORTS_DIR = join(ROOT, 'reports')

const REGION_IDS = {
  'lazio':         '00000000-0000-0000-0002-000000000007',
  'abruzzo':       '00000000-0000-0000-0002-000000000001',
  'umbria':        '00000000-0000-0000-0002-000000000018',
  'molise':        '00000000-0000-0000-0002-000000000011',
  "valle d'aosta": '00000000-0000-0000-0002-000000000019',
  'sardegna':      '00000000-0000-0000-0002-000000000014',
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

// Collect unique region+province combos and which crags belong to each
const files = walkJson(CRAGS_DIR)
const areaMap = new Map() // "region|province" -> { region, province, regionId, crags[] }

for (const file of files) {
  const data = JSON.parse(readFileSync(file, 'utf8'))
  const regionKey = norm(data.region)
  const regionId = REGION_IDS[regionKey]
  if (!regionId) continue
  const key = regionKey + '|' + norm(data.province)
  if (!areaMap.has(key)) {
    areaMap.set(key, { region: data.region, province: data.province, regionId, crags: new Set() })
  }
  areaMap.get(key).crags.add(data.crag)
}

const lines = []
lines.push('-- Capital Climbing — create areas (province level) and link crags')
lines.push('-- Run AFTER import.sql')
lines.push('-- Safe to re-run.')
lines.push('')
lines.push('DO $$')
lines.push('DECLARE')
lines.push('  v_area_id uuid;')
lines.push('BEGIN')
lines.push('')

for (const [, area] of areaMap) {
  lines.push(`  -- Area: ${area.province} (${area.region})`)
  lines.push(`  SELECT id INTO v_area_id FROM areas`)
  lines.push(`    WHERE lower(name) = lower(${esc(area.province)}) AND region_id = '${area.regionId}' LIMIT 1;`)
  lines.push(`  IF v_area_id IS NULL THEN`)
  lines.push(`    INSERT INTO areas (name, normalized_name, slug, region_id, area_type)`)
  lines.push(`    VALUES (${esc(area.province)}, ${esc(norm(area.province))}, ${esc(slug(area.province))}, '${area.regionId}', 'province')`)
  lines.push(`    RETURNING id INTO v_area_id;`)
  lines.push(`  END IF;`)
  lines.push(`  -- Link crags to this area`)
  for (const crag of area.crags) {
    lines.push(`  UPDATE crags SET area_id = v_area_id`)
    lines.push(`    WHERE lower(name) = lower(${esc(crag)}) AND region_id = '${area.regionId}' AND (area_id IS NULL OR area_id != v_area_id);`)
  }
  lines.push('')
}

lines.push('END $$;')

if (!existsSync(REPORTS_DIR)) mkdirSync(REPORTS_DIR, { recursive: true })
const outPath = join(REPORTS_DIR, 'areas.sql')
writeFileSync(outPath, lines.join('\n') + '\n')
console.log(`\nSQL written to reports/areas.sql`)
console.log(`  Areas: ${areaMap.size}\n`)
