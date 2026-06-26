import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import type { Session, Crag } from '../../types/database'

export interface SessionAscent {
  id: string
  grade_at_ascent: string | null
  attempt_type: string | null
  route: { id: string; name: string } | null
}

export interface SessionWithCrag extends Session {
  crag: Pick<Crag, 'id' | 'name'> | null
  ascents: SessionAscent[]
}

export function useMySessions(userId: string) {
  return useQuery({
    queryKey: ['my-sessions', userId],
    queryFn: async (): Promise<SessionWithCrag[]> => {
      const { data, error } = await supabase
        .from('sessions')
        .select('*, crag:crags(id, name), ascents(id, grade_at_ascent, attempt_type, route:routes(id, name))')
        .eq('user_id', userId)
        .order('date', { ascending: false })
      if (error) throw error
      return (data ?? []) as unknown as SessionWithCrag[]
    },
    enabled: !!userId,
  })
}

export interface SessionFormValues {
  date: string
  crag_id: string | null
  partner: string | null
  conditions: string | null
  rock_condition: string | null
  temperature: number | null
  session_rpe: number | null
  rest_days: number | null
  notes: string | null
  visibility: 'public' | 'private'
}

export function useCreateSession() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (variables: { userId: string; values: SessionFormValues }) => {
      const { data, error } = await supabase
        .from('sessions')
        .insert({ user_id: variables.userId, ...variables.values })
        .select()
        .single()
      if (error) throw error
      return data
    },
    onSuccess: (_, variables) => {
      qc.invalidateQueries({ queryKey: ['my-sessions', variables.userId] })
    },
  })
}

export function useDeleteSession() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (variables: { id: string; userId: string }) => {
      const { error } = await supabase.from('sessions').delete().eq('id', variables.id)
      if (error) throw error
    },
    onSuccess: (_, variables) => {
      qc.invalidateQueries({ queryKey: ['my-sessions', variables.userId] })
    },
  })
}

export interface CragSearchResult { id: string; name: string }

export function useCragSearch(query: string) {
  return useQuery({
    queryKey: ['crag-search', query],
    queryFn: async (): Promise<CragSearchResult[]> => {
      const { data, error } = await supabase
        .from('crags')
        .select('id, name')
        .ilike('name', `%${query}%`)
        .order('name')
        .limit(15)
      if (error) throw error
      return data ?? []
    },
    enabled: query.length >= 2,
  })
}
