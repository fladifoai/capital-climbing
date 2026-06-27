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

function norm(s: string): string {
  return s.toLowerCase().trim().normalize('NFD').replace(/[̀-ͯ]/g, '')
}

async function loadRegions(sb: SupabaseClient): Promise<Map<string, string>> {
  const { data, error } = await sb.from('regions').select('id, name')
  if (error) throw new Error(`regions load failed: ${error.message}`)
  const map = new Map<string, string>()
  for (const r of (data ?? [])) map.set(norm(r.name), r.id)
  return map
}

async function loadCountry(sb: SupabaseClient, name: string): Promise<string | null> {
  const { data } = await sb.from('countries').select('id').ilike('name', name).single()
  return (data as { id: string } | null)?.id ?? null
}

async function upsertCrag(
  sb: SupabaseClient,
  data: CragSector,
  regionId: string | null,
  countryId: string | null,
): Promise<string> {
  const { data: existing } = await sb
    .from('crags')
    .select('id')
    .ilike('name', data.crag)
    .eq('region_id', regionId ?? '')
    .maybeSingle()

  if (existing) return (existing as { id: string }).id

  // Also try without region_id filter in case crag exists but lacks region_id
  const { data: existingAny } = await sb
    .from('crags')
    .select('id, region_id')
    .ilike('name', data.crag)
    .is('region_id', null)
    .maybeSingle()

  if (existingAny) {
    // Crag exists but missing region_id — patch it
    if (!DRY_RUN) {
      await sb.from('crags').update({
        region_id: regionId,
        country_id: countryId,
        region: data.region,
        province: data.province,
        municipality: data.municipality ?? null,
        slug: slugify(data.crag),
      }).eq('id', (existingAny as { id: string }).id)
    }
    return (existingAny as { id: string }).id
  }

  if (DRY_RUN) return `dry-crag-${slugify(data.crag)}`

  const { data: inserted, error } = await sb
    .from('crags')
    .insert({
      name: data.crag,
      normalized_name: norm(data.crag),
      slug: slugify(data.crag),
      country: data.country,
      country_id: countryId,
      region: data.region,
      region_id: regionId,
      province: data.province,
      municipality: data.municipality ?? null,
      access_status: 'open',
      rainproof: false,
      services: {},
      aliases: [],
    })
    .select('id')
    .single()

  if (error) throw new Error(`crag insert failed (${data.crag}): ${error.message}`)
  return (inserted as { id: string }).id
}

async function upsertSector(sb: SupabaseClient, cragId: string, sectorName: string): Promise<string> {
  const { data: existing } = await sb
    .from('sectors')
    .select('id')
    .ilike('name', sectorName)
    .eq('crag_id', cragId)
    .maybeSingle()

  if (existing) return (existing as { id: string }).id

  if (DRY_RUN) return `dry-sector-${slugify(sectorName)}`

  const { data: inserted, error } = await sb
    .from('sectors')
    .insert({
      name: sectorName,
      normalized_name: norm(sectorName),
      slug: slugify(sectorName),
      crag_id: cragId,
      aliases: [],
      sort_order: 0,
    })
    .select('id')
    .single()

  if (error) throw new Error(`sector insert failed (${sectorName}): ${error.message}`)
  return (inserted as { id: string }).id
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

  const existingNames = new Set(((existing ?? []) as { name: string }[]).map(r => norm(r.name)))
  const toInsert = routes.filter(r => !existingNames.has(norm(r.name)))

  if (toInsert.length === 0) return { inserted: 0, skipped: routes.length }
  if (DRY_RUN) return { inserted: toInsert.length, skipped: routes.length - toInsert.length }

  const rows = toInsert.map(r => ({
    name: r.name,
    normalized_name: norm(r.name),
    official_grade: r.grade,
    slug: slugify(r.name),
    sector_id: sectorId,
    crag_id: cragId,
    source: 'pdf_import',
    pitches: 1,
    repetitions_count: 0,
    route_type: 'sport',
    aliases: [],
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

  // Load lookup tables once
  const [regionMap, countryId] = await Promise.all([
    loadRegions(sb),
    loadCountry(sb, 'Italy'),
  ])

  console.log(`\nRegions in DB: ${regionMap.size}`)
  console.log(`Country Italy ID: ${countryId ?? '(not found)'}`)

  const files = walkJson(CRAGS_DIR)
  console.log(`\nImporting ${files.length} sector files...\n`)

  let totalInsertedRoutes = 0
  let totalSkippedRoutes = 0
  let errors = 0
  const missingRegions = new Set<string>()

  for (const file of files) {
    const rel = relative(ROOT, file).replace(/\\/g, '/')
    const data = JSON.parse(readFileSync(file, 'utf8')) as CragSector

    const regionId = regionMap.get(norm(data.region)) ?? null
    if (!regionId) missingRegions.add(data.region)

    try {
      const cragId = await upsertCrag(sb, data, regionId, countryId)
      const sectorId = await upsertSector(sb, cragId, data.sector)
      const { inserted, skipped } = await upsertRoutes(sb, data.routes, cragId, sectorId)
      totalInsertedRoutes += inserted
      totalSkippedRoutes += skipped
      const tag = inserted > 0 ? '✅' : '⏭ '
      const regionWarn = !regionId ? ' ⚠️  region_id not found' : ''
      console.log(`${tag} ${rel} (+${inserted} routes, ${skipped} exist)${regionWarn}`)
    } catch (e) {
      console.error(`❌ ${rel}: ${(e as Error).message}`)
      errors++
    }
  }

  if (missingRegions.size > 0) {
    console.log('\n⚠️  Regions not found in DB (crags inserted without region_id):')
    for (const r of missingRegions) console.log(`   - "${r}"`)
    console.log('\n   Fix: insert these regions via Admin panel or SQL, then re-run this script.')
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
