#!/usr/bin/env node
// Scans sector JSON files and generates reports/pdf_import_report.md
// Source data extracted manually from PDFs in Lista Falesie folder.
// Usage: npm run import:pdf-crags

import { readFileSync, writeFileSync, readdirSync, statSync, mkdirSync, existsSync } from 'node:fs'
import { join, relative } from 'node:path'
import { fileURLToPath } from 'node:url'
import { dirname } from 'node:path'

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = join(__dirname, '..')
const CRAGS_DIR = join(ROOT, 'src', 'data', 'crags', 'italia')
const REPORTS_DIR = join(ROOT, 'reports')

interface Route {
  name: string
  grade: string | null
}

interface CragSector {
  country: string
  region: string
  province: string
  municipality?: string
  crag: string
  sector: string
  routes: Route[]
}

function walkJson(dir: string): string[] {
  const results: string[] = []
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry)
    if (statSync(full).isDirectory()) {
      results.push(...walkJson(full))
    } else if (entry.endsWith('.json')) {
      results.push(full)
    }
  }
  return results.sort()
}

const files = walkJson(CRAGS_DIR)

// Group by crag
const byCrag = new Map<string, { region: string; province: string; sectors: { name: string; routes: Route[]; file: string }[] }>()

for (const file of files) {
  const rel = relative(ROOT, file).replace(/\\/g, '/')
  const data = JSON.parse(readFileSync(file, 'utf8')) as CragSector
  const key = `${data.region}|${data.crag}`
  if (!byCrag.has(key)) {
    byCrag.set(key, { region: data.region, province: data.province, sectors: [] })
  }
  byCrag.get(key)!.sectors.push({ name: data.sector, routes: data.routes, file: rel })
}

const now = new Date().toISOString().replace('T', ' ').substring(0, 19)
let totalSectors = 0
let totalRoutes = 0
let totalNullGrade = 0

const lines: string[] = [
  '# PDF Import Report',
  '',
  `Generated: ${now}`,
  `Source: PDFs extracted manually from Lista Falesie`,
  '',
  '---',
  '',
  '## Summary by Crag',
  '',
  '| Crag | Region | Sectors | Routes | Routes (no grade) |',
  '|------|--------|---------|--------|-------------------|',
]

const detailLines: string[] = ['', '---', '', '## Detail by Sector', '']

for (const [, info] of byCrag) {
  let cragRoutes = 0
  let cragNull = 0
  const cragName = info.sectors[0] ? (() => {
    const f = readFileSync(join(ROOT, info.sectors[0].file.replace(/\//g, '\\')), 'utf8')
    return (JSON.parse(f) as CragSector).crag
  })() : '?'

  for (const sec of info.sectors) {
    const nullCount = sec.routes.filter(r => r.grade === null).length
    cragRoutes += sec.routes.length
    cragNull += nullCount
    totalSectors++
    totalRoutes += sec.routes.length
    totalNullGrade += nullCount
    detailLines.push(`### ${cragName} — ${sec.name}`)
    detailLines.push('')
    detailLines.push(`File: \`${sec.file}\`  `)
    detailLines.push(`Routes: ${sec.routes.length} (${nullCount} without grade)`)
    detailLines.push('')
  }

  lines.push(`| ${cragName} | ${info.region} | ${info.sectors.length} | ${cragRoutes} | ${cragNull} |`)
}

lines.push('')
lines.push(`**Total: ${byCrag.size} crags, ${totalSectors} sectors, ${totalRoutes} routes (${totalNullGrade} without grade)**`)
lines.push(...detailLines)

if (!existsSync(REPORTS_DIR)) mkdirSync(REPORTS_DIR, { recursive: true })
const reportPath = join(REPORTS_DIR, 'pdf_import_report.md')
writeFileSync(reportPath, lines.join('\n') + '\n')

console.log(`\nReport written to ${reportPath.replace(ROOT, '')}`)
console.log(`  Crags  : ${byCrag.size}`)
console.log(`  Sectors: ${totalSectors}`)
console.log(`  Routes : ${totalRoutes}`)
console.log(`  No grade: ${totalNullGrade}\n`)
