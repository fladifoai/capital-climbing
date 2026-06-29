import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import { ITALY_ID } from '../catalog/hooks'
import { slugFromNorm } from '../import/utils'
import { normalizeKey } from '../logbook-import/normalize'
import { gradeToNum } from '../../analytics/normalizers/grades'
import type { CragGroup, CragImportReport, ParsedCragRow } from './types'

export interface RegionOption { id: string; name: string }

// Lista regioni (per il menu manuale).
export function useRegions() {
  return useQuery({
    queryKey: ['regions-all'],
    queryFn: async (): Promise<RegionOption[]> => {
      const { data, error } = await supabase
        .from('regions').select('id, name').order('name')
      if (error) throw error
      return (data ?? []) as RegionOption[]
    },
  })
}

// Raggruppa le righe per falesia + risolve stato catalogo e regione.
export function useResolveCragImport() {
  return useMutation({
    mutationFn: async (rows: ParsedCragRow[]): Promise<CragGroup[]> => {
      const valid = rows.filter(r => r.isValid)

      // regioni: mappa normalizeKey(name) → id
      const { data: regions } = await supabase.from('regions').select('id, name')
      const regionMap = new Map((regions ?? []).map(r => [normalizeKey(r.name as string), r.id as string]))

      // falesie esistenti: normalizeKey(name) → id
      const { data: crags } = await supabase.from('crags').select('id, name, region_id')
      const cragMap = new Map<string, { id: string; region_id: string | null }>()
      for (const c of crags ?? []) {
        const k = normalizeKey(c.name as string)
        if (!cragMap.has(k)) cragMap.set(k, { id: c.id as string, region_id: c.region_id as string | null })
      }

      // raggruppa per falesia
      const byCrag = new Map<string, ParsedCragRow[]>()
      for (const r of valid) {
        if (!byCrag.has(r.normalized_crag)) byCrag.set(r.normalized_crag, [])
        byCrag.get(r.normalized_crag)!.push(r)
      }

      const cragIds = [...byCrag.keys()].map(k => cragMap.get(k)?.id).filter(Boolean) as string[]

      // settori + vie esistenti per le falesie già presenti
      const existingSectors = new Map<string, Set<string>>()   // cragId → set(normalizeKey sector)
      const existingRoutes = new Map<string, Set<string>>()    // cragId → set(normalizeKey route)
      if (cragIds.length > 0) {
        const { data: secs } = await supabase.from('sectors').select('id, crag_id, name').in('crag_id', cragIds)
        for (const s of secs ?? []) {
          const set = existingSectors.get(s.crag_id as string) ?? new Set()
          set.add(normalizeKey(s.name as string)); existingSectors.set(s.crag_id as string, set)
        }
        const { data: rts } = await supabase.from('routes').select('crag_id, sector_id, name').in('crag_id', cragIds)
        for (const r of rts ?? []) {
          const cid = r.crag_id as string | null
          if (!cid) continue
          const set = existingRoutes.get(cid) ?? new Set()
          set.add(normalizeKey(r.name as string)); existingRoutes.set(cid, set)
        }
      }

      const groups: CragGroup[] = []
      for (const [normCrag, grpRows] of byCrag) {
        const first = grpRows[0]
        const existing = cragMap.get(normCrag) ?? null
        const fileRegion = grpRows.map(r => r.region).find(Boolean) ?? ''
        const region_id = fileRegion ? (regionMap.get(normalizeKey(fileRegion)) ?? null) : (existing?.region_id ?? null)

        const exSectors = existing ? (existingSectors.get(existing.id) ?? new Set()) : new Set<string>()
        const exRoutes = existing ? (existingRoutes.get(existing.id) ?? new Set()) : new Set<string>()

        const sectorNames = [...new Set(grpRows.map(r => r.sector_name).filter(Boolean))]
        const sectors = sectorNames.map(name => ({
          name, normalized: normalizeKey(name), existing: exSectors.has(normalizeKey(name)),
        }))

        let routesNew = 0, routesExisting = 0
        for (const r of grpRows) {
          if (exRoutes.has(r.normalized_route)) routesExisting++; else routesNew++
        }

        groups.push({
          normalized_crag: normCrag,
          crag_name: first.crag_name,
          region: fileRegion,
          region_id,
          province: grpRows.map(r => r.province).find(Boolean) ?? '',
          municipality: grpRows.map(r => r.municipality).find(Boolean) ?? '',
          geoSource: fileRegion ? 'file' : 'none',
          existingCragId: existing?.id ?? null,
          sectors,
          routesNew,
          routesExisting,
          rows: grpRows,
        })
      }
      return groups
    },
  })
}

// Crea/merge falesie, settori, vie.
export function useExecuteCragImport() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (groups: CragGroup[]): Promise<CragImportReport> => {
      const report: CragImportReport = {
        cragsCreated: 0, cragsMerged: 0, sectorsCreated: 0, routesCreated: 0, routesSkipped: 0, errors: [],
      }

      for (const g of groups) {
        try {
          // 1. falesia: trova o crea
          let cragId = g.existingCragId
          if (cragId) {
            report.cragsMerged++
            // se esiste ma senza regione e ora ce l'abbiamo, aggiornala
            if (g.region_id) {
              await supabase.from('crags').update({ region_id: g.region_id, country_id: ITALY_ID }).eq('id', cragId).is('region_id', null)
            }
          } else {
            const slug = slugFromNorm(g.normalized_crag)
            const { data, error } = await supabase.from('crags').insert({
              name: g.crag_name,
              normalized_name: slug,
              slug,
              country: 'Italia',
              country_id: ITALY_ID,
              region_id: g.region_id,
              province: g.province || null,
              municipality: g.municipality || null,
              access_status: 'open',
              rainproof: false,
              services: {},
            }).select('id').single()
            if (error || !data) throw new Error(error?.message ?? 'creazione falesia fallita')
            cragId = data.id as string
            report.cragsCreated++
          }
          const resolvedCragId = cragId

          // 2. settori esistenti della falesia → mappa
          const { data: secs } = await supabase.from('sectors').select('id, name').eq('crag_id', resolvedCragId)
          const sectorIdByNorm = new Map<string, string>()
          for (const s of secs ?? []) sectorIdByNorm.set(normalizeKey(s.name as string), s.id as string)

          // vie esistenti → set per dedup merge
          const { data: rts } = await supabase.from('routes').select('name').eq('crag_id', resolvedCragId)
          const existingRouteNorms = new Set((rts ?? []).map(r => normalizeKey(r.name as string)))

          // 3. crea i settori mancanti
          for (const sec of g.sectors) {
            if (sec.normalized && !sectorIdByNorm.has(sec.normalized)) {
              const sslug = slugFromNorm(sec.normalized)
              const { data, error } = await supabase.from('sectors').insert({
                crag_id: resolvedCragId, name: sec.name, normalized_name: sslug, slug: sslug, sort_order: 0,
              }).select('id').single()
              if (error || !data) throw new Error(`settore "${sec.name}": ${error?.message}`)
              sectorIdByNorm.set(sec.normalized, data.id as string)
              report.sectorsCreated++
            }
          }

          // 4. crea le vie mancanti (merge)
          const routePayloads: Record<string, unknown>[] = []
          const seenRoute = new Set<string>()
          for (const r of g.rows) {
            if (!r.normalized_route || existingRouteNorms.has(r.normalized_route) || seenRoute.has(r.normalized_route)) {
              if (existingRouteNorms.has(r.normalized_route)) report.routesSkipped++
              continue
            }
            seenRoute.add(r.normalized_route)
            const sectorId = r.normalized_sector ? sectorIdByNorm.get(r.normalized_sector) ?? null : null
            routePayloads.push({
              crag_id: resolvedCragId,
              sector_id: sectorId,
              name: r.route_name,
              normalized_name: slugFromNorm(r.normalized_route),
              slug: slugFromNorm(r.normalized_route),
              official_grade: r.grade,
              grade_numeric: r.grade ? gradeToNum(r.grade) : null,
              route_type: r.route_type,
              pitches: 1,
            })
          }
          if (routePayloads.length > 0) {
            const { error } = await supabase.from('routes').insert(routePayloads)
            if (error) throw new Error(`vie: ${error.message}`)
            report.routesCreated += routePayloads.length
          }
        } catch (e) {
          report.errors.push({ crag: g.crag_name, message: (e as Error).message })
        }
      }
      return report
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['admin-crags'] })
      qc.invalidateQueries({ queryKey: ['crags'] })
    },
  })
}
