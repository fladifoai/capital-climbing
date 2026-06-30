import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import type { Session, Crag } from '../../types/database'

export interface SessionAscent {
  id: string
  date: string
  grade_at_ascent: string | null
  grade_numeric_at_ascent: number | null
  attempt_type: string | null
  ascent_style: string | null
  attempt_count: number | null
  attempt_bucket: string | null
  is_repeat: boolean
  personal_grade: string | null
  quality: number | null
  effort: number | null
  kneepad_used: boolean | null
  notes: string | null
  visibility: 'public' | 'private'
  route: { id: string; name: string; official_grade: string | null; grade_numeric: number | null; route_type: string } | null
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
        .select('*, crag:crags(id, name), ascents(id, date, grade_at_ascent, grade_numeric_at_ascent, attempt_type, ascent_style, attempt_count, attempt_bucket, is_repeat, personal_grade, quality, effort, kneepad_used, notes, visibility, route:routes(id, name, official_grade, grade_numeric, route_type))')
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

export function useUpdateSession() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (variables: { id: string; userId: string; values: SessionFormValues }) => {
      const { data, error } = await supabase
        .from('sessions')
        .update(variables.values)
        .eq('id', variables.id)
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

export interface CragSearchResult {
  id: string
  name: string
  region: string | null
  province: string | null
}

export function useCragSearch(query: string, limit = 15) {
  return useQuery({
    queryKey: ['crag-search', query, limit],
    queryFn: async (): Promise<CragSearchResult[]> => {
      const { data, error } = await supabase
        .from('crags')
        .select('id, name, region, province')
        .ilike('name', `%${query}%`)
        .order('name')
        .limit(limit)
      if (error) throw error
      return (data ?? []) as CragSearchResult[]
    },
    enabled: query.length >= 2,
  })
}
