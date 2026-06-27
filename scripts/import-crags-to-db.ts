#!/usr/bin/env node
// Imports all sector JSON files into Supabase (crags, sectors, routes tables).
// Requires SUPABASE_URL and SUPABASE_SECRET_KEY in .env (service role — bypasses RLS).
// Idempotent: upserts by name. Does NOT modify existing ascents.
// Usage: npm run import:crags-to-db [--dry-run]

import { readFileSync, readdirSync, statSync, existsSync } from 'node:fs'
import { join, relative } from 'node:path'
import { fileURLToPath } from 'node:url'
import { dirname } from 'node:path'
import { createClient, SupabaseClient } from '@supabase/supabase-js'

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = join(__dirname, '..')
const CRAGS_DIR = join(ROOT, 'src', 'data', 'crags', 'italia')
const DRY_RUN = process.argv.includes('--dry-run')

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

function loadEnv(): Record<string, string> {
  const envPath = join(ROOT, '.env')
  if (!existsSync(envPath)) { console.error('❌ .env not found'); process.exit(1) }
  const env: Record<string, string> = {}
  for (const line of readFileSync(envPath, 'utf8').split('\n')) {
    const m = line.match(/^([^#=\s][^=]*)=(.*)$/)
    if (m) env[m[1].trim()] = m[2].trim().replace(/^["']|["']$/g, '')
  }
  return env
}

function walkJson(dir: string): string[] {
  const results: string[] = []
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry)
    if (statSync(full).isDirectory()) results.push(...walkJson(full))
    else if (entry.endsWith('.json')) results.push(full)
  }
  return results.sort()
}

function slugify(s: string): string {
  return s
    .toLowerCase()
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '')
}

interface DbCrag { id: string; name: string }
interface DbSector { id: string; name: string; crag_id: string }
interface DbRoute { id: string; name: string; sector_id: string | null; crag_id: string | null }

async function upsertCrag(sb: SupabaseClient, data: CragSector): Promise<string> {
  const { data: existing } = await sb
    .from('crags')
    .select('id')
    .ilike('name', data.crag)
    .eq('region', data.region)
    .single()

  if (existing) return (existing as DbCrag).id

  if (DRY_RUN) return `dry-crag-${slugify(data.crag)}`

  const { data: inserted, error } = await sb
    .from('crags')
    .insert({
      name: data.crag,
      slug: slugify(data.crag),
      region: data.region,
      country: data.country,
    })
    .select('id')
    .single()

  if (error) throw new Error(`crag insert failed (${data.crag}): ${error.message}`)
  return (inserted as DbCrag).id
}

async function upsertSector(sb: SupabaseClient, cragId: string, sectorName: string): Promise<string> {
  const { data: existing } = await sb
    .from('sectors')
    .select('id')
    .ilike('name', sectorName)
    .eq('crag_id', cragId)
    .single()

  if (existing) return (existing as DbSector).id

  if (DRY_RUN) return `dry-sector-${slugify(sectorName)}`

  const { data: inserted, error } = await sb
    .from('sectors')
    .insert({
      name: sectorName,
      slug: slugify(sectorName),
      crag_id: cragId,
    })
    .select('id')
    .single()

  if (error) throw new Error(`sector insert failed (${sectorName}): ${error.message}`)
  return (inserted as DbSector).id
}

async function upsertRoutes(
  sb: SupabaseClient,
  routes: Route[],
  cragId: string,
  sectorId: string,
): Promise<{ inserted: number; skipped: number }> {
  const { data: existing } = await sb
    .from('routes')
    .select('name')
    .eq('sector_id', sectorId)

  const existingNames = new Set(((existing ?? []) as DbRoute[]).map(r => r.name.toLowerCase().trim()))
  const toInsert = routes.filter(r => !existingNames.has(r.name.toLowerCase().trim()))

  if (toInsert.length === 0) return { inserted: 0, skipped: routes.length }
  if (DRY_RUN) return { inserted: toInsert.length, skipped: routes.length - toInsert.length }

  const rows = toInsert.map(r => ({
    name: r.name,
    grade: r.grade,
    slug: slugify(r.name),
    sector_id: sectorId,
    crag_id: cragId,
    source: 'pdf_import',
  }))

  const { error } = await sb.from('routes').insert(rows)
  if (error) throw new Error(`routes insert failed: ${error.message}`)

  return { inserted: toInsert.length, skipped: routes.length - toInsert.length }
}

async function main() {
  if (DRY_RUN) console.log('\n🔍 DRY RUN — no writes to database\n')

  const env = loadEnv()
  const url = env.SUPABASE_URL ?? env.VITE_SUPABASE_URL
  const secret = env.SUPABASE_SECRET_KEY

  if (!url || !secret) {
    console.error('❌ SUPABASE_URL and SUPABASE_SECRET_KEY required in .env')
    process.exit(1)
  }

  const sb = createClient(url, secret, { auth: { autoRefreshToken: false, persistSession: false } })

  const files = walkJson(CRAGS_DIR)
  console.log(`\nImporting ${files.length} sector files...\n`)

  let totalInsertedRoutes = 0
  let totalSkippedRoutes = 0
  let errors = 0

  for (const file of files) {
    const rel = relative(ROOT, file).replace(/\\/g, '/')
    const data = JSON.parse(readFileSync(file, 'utf8')) as CragSector

    try {
      const cragId = await upsertCrag(sb, data)
      const sectorId = await upsertSector(sb, cragId, data.sector)
      const { inserted, skipped } = await upsertRoutes(sb, data.routes, cragId, sectorId)
      totalInsertedRoutes += inserted
      totalSkippedRoutes += skipped
      const tag = inserted > 0 ? '✅' : '⏭ '
      console.log(`${tag} ${rel} (+${inserted} routes, ${skipped} already exist)`)
    } catch (e) {
      console.error(`❌ ${rel}: ${(e as Error).message}`)
      errors++
    }
  }

  console.log('\n' + '─'.repeat(60))
  if (DRY_RUN) console.log('DRY RUN — no data written')
  console.log(`Routes inserted : ${totalInsertedRoutes}`)
  console.log(`Routes skipped  : ${totalSkippedRoutes}`)
  console.log(`Errors          : ${errors}`)
  console.log('─'.repeat(60) + '\n')

  if (errors > 0) process.exit(1)
}

main().catch(e => { console.error('❌', (e as Error).message); process.exit(1) })
