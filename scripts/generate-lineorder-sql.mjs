#!/usr/bin/env node
// Generates reports/lineorder.sql — sets line_order on all imported routes.

import { readFileSync, writeFileSync, readdirSync, statSync, mkdirSync, existsSync } from 'node:fs'
import { join, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = join(__dirname, '..')
const CRAGS_DIR = join(ROOT, 'src', 'data', 'crags', 'italia')
const REPORTS_DIR = join(ROOT, 'reports')

function walkJson(dir) {
  const results = []
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry)
    if (statSync(full).isDirectory()) results.push(...walkJson(full))
    else if (entry.endsWith('.json')) results.push(full)
  }
  return results.sort()
}

function esc(s) {
  return "'" + String(s).replace(/'/g, "''") + "'"
}

const files = walkJson(CRAGS_DIR)
const lines = []

lines.push('-- Set line_order for all imported routes based on PDF order')
lines.push('-- Safe to re-run.')
lines.push('')
lines.push('DO $$')
lines.push('DECLARE')
lines.push('  v_sector_id uuid;')
lines.push('BEGIN')
lines.push('')

let total = 0

for (const file of files) {
  const data = JSON.parse(readFileSync(file, 'utf8'))

  lines.push(`  -- ${data.crag} › ${data.sector}`)
  lines.push(`  SELECT s.id INTO v_sector_id`)
  lines.push(`    FROM sectors s JOIN crags c ON c.id = s.crag_id`)
  lines.push(`    WHERE lower(s.name) = lower(${esc(data.sector)})`)
  lines.push(`      AND lower(c.name) = lower(${esc(data.crag)})`)
  lines.push(`    LIMIT 1;`)
  lines.push(`  IF v_sector_id IS NOT NULL THEN`)

  for (let i = 0; i < data.routes.length; i++) {
    const r = data.routes[i]
    lines.push(`    UPDATE routes SET line_order = ${i + 1}`)
    lines.push(`      WHERE lower(name) = lower(${esc(r.name)}) AND sector_id = v_sector_id;`)
    total++
  }

  lines.push(`  ELSE`)
  lines.push(`    RAISE WARNING 'Sector not found: % › %', ${esc(data.crag)}, ${esc(data.sector)};`)
  lines.push(`  END IF;`)
  lines.push('')
}

lines.push('END $$;')
lines.push(`-- Total: ${total} route updates`)

if (!existsSync(REPORTS_DIR)) mkdirSync(REPORTS_DIR, { recursive: true })
const outPath = join(REPORTS_DIR, 'lineorder.sql')
writeFileSync(outPath, lines.join('\n') + '\n')
console.log(`\nSQL written to reports/lineorder.sql (${total} routes)\n`)
