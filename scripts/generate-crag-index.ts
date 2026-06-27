#!/usr/bin/env node
// Generates src/data/crags/index.json from all sector JSON files
// Usage: npm run generate:crag-index

import { readFileSync, writeFileSync, readdirSync, statSync } from 'node:fs'
import { join, relative } from 'node:path'
import { fileURLToPath } from 'node:url'
import { dirname } from 'node:path'

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = join(__dirname, '..')
const CRAGS_DIR = join(ROOT, 'src', 'data', 'crags', 'italia')
const OUT = join(ROOT, 'src', 'data', 'crags', 'index.json')

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

interface IndexEntry {
  country: string
  region: string
  province: string
  municipality?: string
  crag: string
  sector: string
  routeCount: number
  file: string
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
const index: IndexEntry[] = []
let totalRoutes = 0

for (const file of files) {
  const rel = relative(join(ROOT, 'src', 'data', 'crags'), file).replace(/\\/g, '/')
  const data = JSON.parse(readFileSync(file, 'utf8')) as CragSector
  const entry: IndexEntry = {
    country: data.country,
    region: data.region,
    province: data.province,
    crag: data.crag,
    sector: data.sector,
    routeCount: data.routes.length,
    file: rel,
  }
  if (data.municipality) entry.municipality = data.municipality
  index.push(entry)
  totalRoutes += data.routes.length
}

const output = {
  generated: new Date().toISOString(),
  totalSectors: index.length,
  totalRoutes,
  sectors: index,
}

writeFileSync(OUT, JSON.stringify(output, null, 2) + '\n')
console.log(`\nGenerated ${OUT.replace(ROOT, '')}`)
console.log(`  Sectors: ${index.length}`)
console.log(`  Routes : ${totalRoutes}\n`)
