import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'

export interface CragRequest {
  id: string
  requester_id: string
  crag_name: string
  sector_name: string | null
  route_name: string
  raw_grade: string | null
  normalized_crag: string
  normalized_route: string
  status: 'pending' | 'resolved' | 'rejected'
  count: number
  notes: string | null
  created_at: string
  resolved_at: string | null
}

export function useCragRequests(status?: CragRequest['status']) {
  return useQuery({
    queryKey: ['crag-requests', status ?? 'all'],
    queryFn: async (): Promise<CragRequest[]> => {
      let q = supabase.from('crag_requests').select('*').order('created_at', { ascending: false })
      if (status) q = q.eq('status', status)
      const { data, error } = await q
      if (error) throw error
      return (data ?? []) as CragRequest[]
    },
  })
}

export function useSetCragRequestStatus() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async ({ id, status }: { id: string; status: CragRequest['status'] }) => {
      const { error } = await supabase
        .from('crag_requests')
        .update({ status, resolved_at: status === 'pending' ? null : new Date().toISOString() })
        .eq('id', id)
      if (error) throw error
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['crag-requests'] })
    },
  })
}
