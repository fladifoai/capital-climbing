import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import type { Ascent, Route, Sector, Crag } from '../../types/database'
import type { AttemptType, Visibility } from '../../types/database'

export interface AscentWithRoute extends Ascent {
  route: Pick<Route, 'id' | 'name' | 'official_grade' | 'grade_numeric' | 'route_type'> & {
    sector: Pick<Sector, 'id' | 'name'> & {
      crag: Pick<Crag, 'id' | 'name'>
    }
  }
}

export function useMyAscents(userId: string) {
  return useQuery({
    queryKey: ['my-ascents', userId],
    queryFn: async (): Promise<AscentWithRoute[]> => {
      const { data, error } = await supabase
        .from('ascents')
        .select(`
          *,
          route:routes(
            id, name, official_grade, grade_numeric, route_type,
            sector:sectors(
              id, name,
              crag:crags(id, name)
            )
          )
        `)
        .eq('user_id', userId)
        .order('date', { ascending: false })
      if (error) throw error
      return (data ?? []) as unknown as AscentWithRoute[]
    },
    enabled: !!userId,
  })
}

export interface AscentFormValues {
  route_id: string
  date: string
  status: 'completed' | 'attempted'
  attempt_type: AttemptType | null
  ascent_style: string | null
  attempt_count: number | null
  attempt_bucket: string | null
  grade_at_ascent: string | null
  grade_numeric_at_ascent: number | null
  personal_grade: string | null
  quality: number | null
  kneepad_used: boolean | null
  effort: number | null
  notes: string | null
  visibility: Visibility
}

export function useCreateAscent() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async ({ userId, values }: { userId: string; values: AscentFormValues }) => {
      const { data, error } = await supabase
        .from('ascents')
        .insert({
          ...values,
          user_id: userId,
          score: null,
          needs_review: false,
        })
        .select()
        .single()
      if (error) throw error
      return data
    },
    onSuccess: (_, { userId }) => {
      qc.invalidateQueries({ queryKey: ['my-ascents', userId] })
    },
  })
}

export function useDeleteAscent() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (variables: { id: string; userId: string }) => {
      const { error } = await supabase.from('ascents').delete().eq('id', variables.id)
      if (error) throw error
    },
    onSuccess: (_, variables) => {
      qc.invalidateQueries({ queryKey: ['my-ascents', variables.userId] })
    },
  })
}

// Route search for ascent form
export interface RouteSearchResult {
  id: string
  name: string
  official_grade: string | null
  grade_numeric: number | null
  route_type: string
  sector_name: string
  crag_name: string
}

export function useRouteSearch(query: string) {
  return useQuery({
    queryKey: ['route-search', query],
    queryFn: async (): Promise<RouteSearchResult[]> => {
      const { data, error } = await supabase
        .from('routes')
        .select(`
          id, name, official_grade, grade_numeric, route_type,
          sector:sectors(name, crag:crags(name))
        `)
        .ilike('name', `%${query}%`)
        .limit(20)
      if (error) throw error
      return (data ?? []).map((r: unknown) => {
        const row = r as {
          id: string
          name: string
          official_grade: string | null
          grade_numeric: number | null
          route_type: string
          sector: { name: string; crag: { name: string } }
        }
        return {
          id: row.id,
          name: row.name,
          official_grade: row.official_grade,
          grade_numeric: row.grade_numeric,
          route_type: row.route_type,
          sector_name: row.sector?.name ?? '',
          crag_name: row.sector?.crag?.name ?? '',
        }
      })
    },
    enabled: query.length >= 2,
  })
}
