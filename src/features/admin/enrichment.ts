// Coda di arricchimento falesie (admin): stato, review, backfill, run manuale.
// Vedi edge function `crag-enrich` + migrations 043/044.
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'

export interface EnrichmentSummary {
  pending: number
  running: number
  done: number
  error: number
  needsReview: number
  total: number
}

export interface EnrichmentReviewItem {
  crag_id: string
  crag_name: string
  status: string
  last_error: string | null
  review: Record<string, unknown> | null
  result: Record<string, unknown> | null
}

// Conteggi per stato (poche centinaia di righe: fetch e aggrega lato client).
export function useEnrichmentSummary() {
  return useQuery({
    queryKey: ['enrichment-summary'],
    refetchInterval: 15000, // si aggiorna mentre il cron lavora
    queryFn: async (): Promise<EnrichmentSummary> => {
      const { data, error } = await supabase
        .from('enrichment_queue')
        .select('status, needs_review')
      if (error) throw error
      const rows = data ?? []
      const s: EnrichmentSummary = { pending: 0, running: 0, done: 0, error: 0, needsReview: 0, total: rows.length }
      for (const r of rows) {
        if (r.status === 'pending') s.pending++
        else if (r.status === 'running') s.running++
        else if (r.status === 'done') s.done++
        else if (r.status === 'error') s.error++
        if (r.needs_review) s.needsReview++
      }
      return s
    },
  })
}

// Elenco falesie da rivedere (discrepanza utente↔calcolato, o geocode incerto, o errore).
export function useEnrichmentReview() {
  return useQuery({
    queryKey: ['enrichment-review'],
    queryFn: async (): Promise<EnrichmentReviewItem[]> => {
      const { data, error } = await supabase
        .from('enrichment_queue')
        .select('crag_id, status, last_error, review, result, needs_review, crags(name)')
        .or('needs_review.eq.true,status.eq.error')
        .order('updated_at', { ascending: false })
        .limit(200)
      if (error) throw error
      return (data ?? []).map((r: Record<string, any>) => ({
        crag_id: r.crag_id,
        crag_name: r.crags?.name ?? '—',
        status: r.status,
        last_error: r.last_error,
        review: r.review,
        result: r.result,
      }))
    },
  })
}

// Backfill: accoda tutte le falesie con campi mancanti (RPC admin-only).
export function useEnqueueMissing() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (): Promise<number> => {
      const { data, error } = await supabase.rpc('enqueue_missing_enrichment')
      if (error) throw error
      // primo giro subito, poi ci pensa il cron
      supabase.functions.invoke('crag-enrich', { body: { mode: 'drain', batch: 5 } }).catch(() => {})
      return (data as number) ?? 0
    },
    onSuccess: () => qc.invalidateQueries({ queryKey: ['enrichment-summary'] }),
  })
}

// Forza un giro immediato di elaborazione (senza aspettare il cron).
export function useRunEnrichmentNow() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async () => {
      const { error } = await supabase.functions.invoke('crag-enrich', { body: { mode: 'drain', batch: 5 } })
      if (error) throw error
    },
    onSuccess: () => setTimeout(() => qc.invalidateQueries({ queryKey: ['enrichment-summary'] }), 1500),
  })
}
