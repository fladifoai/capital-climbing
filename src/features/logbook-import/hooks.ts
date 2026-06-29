import { useMutation, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import { normalizeKey } from './normalize'
import type {
  LogbookImportReport, ParsedLogbookRow, ResolvedLogbookRow,
} from './types'

// ── Fase 2: abbina le righe al catalogo + rileva duplicati ──────────────────
export function useResolveLogbook(userId: string) {
  return useMutation({
    mutationFn: async (rows: ParsedLogbookRow[]): Promise<ResolvedLogbookRow[]> => {
      const valid = rows.filter(r => r.isValid)
      if (valid.length === 0) {
        return rows.map(r => ({ ...r, matchStatus: 'unmatched' as const, routeId: null, action: 'skip' as const }))
      }

      // 1. falesie: scarichiamo tutte e rinormalizziamo il NOME lato client.
      //    Il campo normalized_name salvato è incoerente (trattini/spazi/apostrofi
      //    misti), quindi non ci si può fidare: confrontiamo su normalizeKey(name).
      const { data: crags } = await supabase.from('crags').select('id, name')
      const cragMap = new Map<string, string>() // normalizeKey(name) → cragId
      for (const c of crags ?? []) {
        const k = normalizeKey(c.name as string)
        if (!cragMap.has(k)) cragMap.set(k, c.id as string)
      }

      // 2. vie dentro le falesie abbinate. Collegamento via crag_id diretto
      //    OPPURE solo via sector_id. Rinormalizziamo anche qui il nome.
      const cragIds = [...new Set(valid.map(r => cragMap.get(r.normalized_crag)).filter(Boolean) as string[])]
      const routeMap = new Map<string, string>() // `${cragId}:${normalizeKey(name)}` → routeId
      if (cragIds.length > 0) {
        // settori delle falesie → mappa sectorId → cragId
        const { data: sectors } = await supabase
          .from('sectors')
          .select('id, crag_id')
          .in('crag_id', cragIds)
        const sectorToCrag = new Map((sectors ?? []).map(s => [s.id as string, s.crag_id as string]))
        const sectorIds = [...sectorToCrag.keys()]

        const { data: byCrag } = await supabase
          .from('routes')
          .select('id, name, crag_id, sector_id')
          .in('crag_id', cragIds)
        const bySector = sectorIds.length > 0
          ? (await supabase
              .from('routes')
              .select('id, name, crag_id, sector_id')
              .in('sector_id', sectorIds)).data ?? []
          : []

        for (const r of [...(byCrag ?? []), ...bySector]) {
          const cragId = (r.crag_id as string | null) ?? (r.sector_id ? sectorToCrag.get(r.sector_id as string) : undefined)
          if (!cragId) continue
          const key = `${cragId}:${normalizeKey(r.name as string)}`
          if (!routeMap.has(key)) routeMap.set(key, r.id as string)
        }
      }

      // 3. ascensioni esistenti per dedup (user + route + data)
      const matchedRouteIds = [...new Set([...routeMap.values()])]
      const dupSet = new Set<string>()
      if (matchedRouteIds.length > 0) {
        const { data: existing } = await supabase
          .from('ascents')
          .select('route_id, date')
          .eq('user_id', userId)
          .in('route_id', matchedRouteIds)
        ;(existing ?? []).forEach(a => dupSet.add(`${a.route_id}|${a.date}`))
      }

      return rows.map(row => {
        if (!row.isValid) {
          return { ...row, matchStatus: 'unmatched' as const, routeId: null, action: 'skip' as const }
        }
        const cragId = cragMap.get(row.normalized_crag)
        const routeId = cragId ? routeMap.get(`${cragId}:${row.normalized_route}`) : undefined

        if (!routeId) {
          return { ...row, matchStatus: 'unmatched' as const, routeId: null, action: 'import' as const }
        }
        const isDup = dupSet.has(`${routeId}|${row.date}`)
        return {
          ...row,
          matchStatus: isDup ? ('duplicate' as const) : ('matched' as const),
          routeId,
          action: isDup ? ('skip' as const) : ('import' as const),
        }
      })
    },
  })
}

// ── Fase 2/3: salva ascensioni (matched) + coda + richieste (unmatched) ──────
export function useExecuteLogbookImport(userId: string) {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (rows: ResolvedLogbookRow[]): Promise<LogbookImportReport> => {
      const report: LogbookImportReport = {
        total: rows.length, imported: 0, queued: 0, skipped: 0, cragRequests: 0, errors: [],
      }
      const toProcess = rows.filter(r => r.isValid && r.action === 'import')

      // ── matched → insert ascents ──
      const matched = toProcess.filter(r => r.matchStatus === 'matched' && r.routeId)
      if (matched.length > 0) {
        const payload = matched.map(r => ({
          user_id: userId,
          route_id: r.routeId!,
          date: r.date!,
          status: 'completed',
          attempt_type: r.attempt_type,
          attempt_count: r.attempt_count,
          needs_review: r.needsReview,
          grade_at_ascent: r.grade,
          grade_snapshot: r.grade,
          proposed_grade: r.proposed_grade,
          quality: r.quality,
          route_name_snapshot: r.route_name,
          crag_name_snapshot: r.crag_name,
          sector_name_snapshot: r.sector_name || null,
          notes: r.notes,
          visibility: 'public',
        }))
        const { error } = await supabase.from('ascents').insert(payload)
        if (error) {
          report.errors.push({ rowNum: 0, message: `Salvataggio ascensioni: ${error.message}` })
        } else {
          report.imported = matched.length
        }
      }

      // ── unmatched → crag_requests (raggruppate) + pending_ascents ──
      const unmatched = toProcess.filter(r => r.matchStatus === 'unmatched')
      if (unmatched.length > 0) {
        // raggruppa per via+falesia per non duplicare richieste
        const reqKey = (r: ResolvedLogbookRow) => `${r.normalized_crag}|${r.normalized_route}`
        const requestIdByKey = new Map<string, string>()
        const seen = new Map<string, ResolvedLogbookRow[]>()
        for (const r of unmatched) {
          const k = reqKey(r)
          if (!seen.has(k)) seen.set(k, [])
          seen.get(k)!.push(r)
        }

        for (const [k, group] of seen) {
          const first = group[0]
          const { data: req, error: reqErr } = await supabase
            .from('crag_requests')
            .insert({
              requester_id: userId,
              crag_name: first.crag_name,
              sector_name: first.sector_name || null,
              route_name: first.route_name,
              raw_grade: first.raw_grade || null,
              normalized_crag: first.normalized_crag,
              normalized_route: first.normalized_route,
              count: group.length,
            })
            .select('id')
            .single()
          if (reqErr) {
            report.errors.push({ rowNum: first.rowNum, message: `Richiesta falesia: ${reqErr.message}` })
            continue
          }
          report.cragRequests++
          requestIdByKey.set(k, req.id as string)
        }

        const pendingPayload = unmatched.map(r => ({
          user_id: userId,
          crag_name: r.crag_name,
          sector_name: r.sector_name || null,
          route_name: r.route_name,
          normalized_crag: r.normalized_crag,
          normalized_sector: r.normalized_sector || null,
          normalized_route: r.normalized_route,
          date: r.date!,
          grade: r.grade,
          proposed_grade: r.proposed_grade,
          attempt_type: r.attempt_type,
          attempt_count: r.attempt_count,
          quality: r.quality,
          notes: r.notes,
          crag_request_id: requestIdByKey.get(reqKey(r)) ?? null,
        }))
        const { error: pErr } = await supabase.from('pending_ascents').insert(pendingPayload)
        if (pErr) {
          report.errors.push({ rowNum: 0, message: `Coda ascensioni: ${pErr.message}` })
        } else {
          report.queued = unmatched.length
        }
      }

      report.skipped = rows.filter(r => r.action === 'skip').length
      return report
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['my-ascents', userId] })
      qc.invalidateQueries({ queryKey: ['my-sessions', userId] })
    },
  })
}
