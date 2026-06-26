import { useMutation, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import { ITALY_ID } from '../catalog/hooks'
import { slugFromNorm } from './utils'
import type { ImportReport, ValidatedRow } from './types'

export function useCheckDuplicates() {
  return useMutation({
    mutationFn: async (rows: ValidatedRow[]): Promise<ValidatedRow[]> => {
      const validRows = rows.filter(r => r.isValid)
      if (validRows.length === 0) return rows

      const cragNames = [...new Set(validRows.map(r => r.normalized_crag))]

      const { data: existingCrags } = await supabase
        .from('crags')
        .select('id, normalized_name')
        .in('normalized_name', cragNames.map(n => slugFromNorm(n)))

      const cragMap = new Map(existingCrags?.map(c => [c.normalized_name, c.id]) ?? [])

      const cragIds = [...cragMap.values()]
      const sectorMap = new Map<string, string>()

      if (cragIds.length > 0) {
        const { data: existingSectors } = await supabase
          .from('sectors')
          .select('id, crag_id, normalized_name')
          .in('crag_id', cragIds)

        existingSectors?.forEach(s => {
          sectorMap.set(`${s.crag_id}:${s.normalized_name}`, s.id)
        })

        const sectorIds = [...sectorMap.values()]
        const routeMap = new Map<string, string>()

        if (sectorIds.length > 0) {
          const { data: existingRoutes } = await supabase
            .from('routes')
            .select('id, sector_id, normalized_name')
            .in('sector_id', sectorIds)

          existingRoutes?.forEach(r => {
            routeMap.set(`${r.sector_id}:${r.normalized_name}`, r.id)
          })
        }

        return rows.map(row => {
          if (!row.isValid) return row

          const cragId = cragMap.get(slugFromNorm(row.normalized_crag))
          if (!cragId) return row

          const sectorId = sectorMap.get(`${cragId}:${slugFromNorm(row.normalized_sector)}`)
          if (!sectorId) return { ...row, existingCragId: cragId }

          const routeId = routeMap.get(`${sectorId}:${slugFromNorm(row.normalized_route)}`)
          if (!routeId) return { ...row, existingCragId: cragId, existingSectorId: sectorId }

          return {
            ...row,
            existingCragId: cragId,
            existingSectorId: sectorId,
            existingRouteId: routeId,
            action: 'update' as const,
          }
        })
      }

      return rows
    },
  })
}

export function useExecuteImport() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (rows: ValidatedRow[]): Promise<ImportReport> => {
      const report: ImportReport = {
        total: rows.filter(r => r.isValid).length,
        imported: 0,
        updated: 0,
        skipped: 0,
        errors: [],
      }

      const cragCache = new Map<string, string>()
      const sectorCache = new Map<string, string>()

      rows.forEach(row => {
        if (row.existingCragId) cragCache.set(slugFromNorm(row.normalized_crag), row.existingCragId)
        if (row.existingCragId && row.existingSectorId) {
          sectorCache.set(`${row.existingCragId}:${slugFromNorm(row.normalized_sector)}`, row.existingSectorId)
        }
      })

      for (const row of rows) {
        if (!row.isValid) continue

        if (row.action === 'skip') {
          report.skipped++
          continue
        }

        try {
          const cragSlug = slugFromNorm(row.normalized_crag)
          let cragId = cragCache.get(cragSlug)
          if (!cragId) {
            const { data, error } = await supabase
              .from('crags')
              .insert({
                name: row.crag_name,
                normalized_name: cragSlug,
                country: 'Italia',
                country_id: ITALY_ID,
                municipality: row.crag_municipality,
                province: row.crag_province,
                access_status: 'open',
                rainproof: false,
                services: {},
              })
              .select('id')
              .single()
            if (error || !data) throw new Error(`Falesia "${row.crag_name}": ${error?.message ?? 'no data'}`)
            const newCragId: string = data.id
            cragCache.set(cragSlug, newCragId)
            cragId = newCragId
          }

          if (!cragId) throw new Error(`ID falesia non trovato: ${row.crag_name}`)
          const resolvedCragId: string = cragId

          const sectorSlug = slugFromNorm(row.normalized_sector)
          const sectorKey = `${resolvedCragId}:${sectorSlug}`
          let sectorId = sectorCache.get(sectorKey)
          if (!sectorId) {
            const { data, error } = await supabase
              .from('sectors')
              .insert({
                crag_id: resolvedCragId,
                name: row.sector_name,
                normalized_name: sectorSlug,
                sort_order: 0,
              })
              .select('id')
              .single()
            if (error || !data) throw new Error(`Settore "${row.sector_name}": ${error?.message ?? 'no data'}`)
            const newSectorId: string = data.id
            sectorCache.set(sectorKey, newSectorId)
            sectorId = newSectorId
          }

          if (!sectorId) throw new Error(`ID settore non trovato: ${row.sector_name}`)
          const resolvedSectorId: string = sectorId

          const routePayload = {
            name: row.route_name,
            normalized_name: slugFromNorm(row.normalized_route),
            official_grade: row.official_grade,
            route_type: row.route_type,
            length_m: row.length_m,
            pitches: row.pitches,
            bolts: row.bolts,
            angle: row.angle,
            first_ascent: row.first_ascent,
            description: row.description,
            line_order: row.line_order,
          }

          if (row.action === 'update' && row.existingRouteId) {
            const { error } = await supabase
              .from('routes')
              .update(routePayload)
              .eq('id', row.existingRouteId)
            if (error) throw new Error(`Via "${row.route_name}": ${error.message}`)
            report.updated++
          } else {
            const { error } = await supabase
              .from('routes')
              .insert({ ...routePayload, sector_id: resolvedSectorId })
            if (error) throw new Error(`Via "${row.route_name}": ${error.message}`)
            report.imported++
          }
        } catch (e) {
          report.errors.push({ rowNum: row.rowNum, message: (e as Error).message })
          report.skipped++
        }
      }

      return report
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['admin-crags'] })
      qc.invalidateQueries({ queryKey: ['regions-with-counts'] })
      qc.invalidateQueries({ queryKey: ['sectors-with-routes'] })
    },
  })
}
