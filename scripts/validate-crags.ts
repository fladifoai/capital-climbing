#!/usr/bin/env node
// Validates all JSON crag files under src/data/crags/italia/
// Usage: npm run validate:crags

import { readFileSync, readdirSync, statSync } from 'node:fs'
import { join, relative } from 'node:path'
import { fileURLToPath } from 'node:url'
import { dirname } from 'node:path'

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = join(__dirname, '..')
const CRAGS_DIR = join(ROOT, 'src', 'data', 'crags', 'italia')

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
  return results
}

const REQUIRED_TOP_FIELDS: (keyof CragSector)[] = ['country', 'region', 'province', 'crag', 'sector', 'routes']
const VALID_GRADE = /^[456789][abc][+]?([/][456789][abc][+]?)?$/

function validateGrade(grade: string): boolean {
  if (grade === null) return true
  return VALID_GRADE.test(grade) || /^[123456789][0-9]?[abc][+]?$/.test(grade)
}

const files = walkJson(CRAGS_DIR)
let totalRoutes = 0
let errors = 0
let warnings = 0

console.log(`\nValidating ${files.length} crag sector files...\n`)

for (const file of files) {
  const rel = relative(ROOT, file)
  let data: CragSector

  try {
    data = JSON.parse(readFileSync(file, 'utf8')) as CragSector
  } catch (e) {
    console.error(`❌ PARSE ERROR ${rel}: ${(e as Error).message}`)
    errors++
    continue
  }

  const fileErrors: string[] = []
  const fileWarnings: string[] = []

  for (const field of REQUIRED_TOP_FIELDS) {
    if (data[field] === undefined || data[field] === null || data[field] === '') {
      fileErrors.push(`missing field: ${field}`)
    }
  }

  if (!Array.isArray(data.routes)) {
    fileErrors.push('routes is not an array')
  } else {
    if (data.routes.length === 0) fileWarnings.push('routes array is empty')

    for (let i = 0; i < data.routes.length; i++) {
      const r = data.routes[i]
      if (!r.name || typeof r.name !== 'string') {
        fileErrors.push(`route[${i}]: missing or invalid name`)
      }
      if (r.grade !== null && typeof r.grade !== 'string') {
        fileErrors.push(`route[${i}]: grade must be string or null`)
      }
      // Check for forbidden fields
      const forbidden = ['stars', 'beauty', 'notes', 'description', 'repetitions', 'user', 'comment']
      for (const f of forbidden) {
        if (f in r) fileWarnings.push(`route[${i}] "${r.name}": forbidden field "${f}"`)
      }
    }

    totalRoutes += data.routes.length
  }

  if (fileErrors.length > 0) {
    console.error(`❌ ${rel}`)
    for (const e of fileErrors) console.error(`     error: ${e}`)
    errors++
  } else if (fileWarnings.length > 0) {
    console.warn(`⚠️  ${rel}`)
    for (const w of fileWarnings) console.warn(`     warn: ${w}`)
    warnings++
  } else {
    console.log(`✅ ${rel} (${data.routes.length} routes)`)
  }
}

console.log('\n' + '─'.repeat(60))
console.log(`Files   : ${files.length}`)
console.log(`Routes  : ${totalRoutes}`)
console.log(`Errors  : ${errors}`)
console.log(`Warnings: ${warnings}`)
console.log('─'.repeat(60) + '\n')

if (errors > 0) process.exit(1)
