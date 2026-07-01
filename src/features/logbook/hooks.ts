import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import { capitalScoreFromAscent, SCORE_VERSION } from '../../lib/scoring'
import type { Ascent, Route, Sector, Crag, UserRouteNote } from '../../types/database'
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
  session_id: string | null
  date: string
  attempt_type: AttemptType | null
  ascent_style: string | null
  attempt_count: number | null
  attempt_bucket: string | null
  is_repeat: boolean
  grade_at_ascent: string | null
  grade_numeric_at_ascent: number | null
  draws_mode: string | null
  personal_grade: string | null
  quality: number | null
  difficulty_feel: string | null
  style_feel: string | null
  proposed_grade: string | null
  want_repeat: boolean | null
  kneepad_used: boolean | null
  effort: number | null
  notes: string | null
  visibility: Visibility
}

export function useCreateAscent() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async ({ userId, values, routeId }: { userId: string; values: AscentFormValues; routeId?: string }) => {
      console.log('[useCreateAscent] inserting', { userId, route_id: values.route_id, session_id: values.session_id })
      // Le ripetizioni NON generano punteggio: score=null.
      const capitalScore = values.is_repeat
        ? null
        : capitalScoreFromAscent({
            grade: values.grade_at_ascent,
            ascent_style: values.ascent_style,
            attempt_count: values.attempt_count,
            attempt_type: values.attempt_type,
            draws_mode: values.draws_mode as 'unknown' | 'preplaced' | 'placed_by_user' | null,
          })
      const { error } = await supabase
        .from('ascents')
        .insert({
          ...values,
          user_id: userId,
          status: 'completed',
          score: capitalScore,
          score_version: capitalScore === null ? null : SCORE_VERSION,
          needs_review: false,
        })
      if (error) {
        console.error('[useCreateAscent] Supabase error:', error)
        throw new Error(error.message + (error.details ? ` — ${error.details}` : '') + (error.hint ? ` (${error.hint})` : ''))
      }
      console.log('[useCreateAscent] insert OK')
      return { routeId }
    },
    onSuccess: (result, { userId }) => {
      qc.invalidateQueries({ queryKey: ['my-ascents', userId] })
      qc.invalidateQueries({ queryKey: ['my-sessions', userId] })
      // Un'ascensione può chiudere un progetto (trigger 033) → aggiorna Progetti.
      qc.invalidateQueries({ queryKey: ['my-projects', userId] })
      if (result?.routeId) {
        qc.invalidateQueries({ queryKey: ['route-history', result.routeId, userId] })
      }
    },
  })
}

export type AscentUpdateValues = {
  date?: string
  ascent_style?: string | null
  attempt_count?: number | null
  attempt_bucket?: string | null
  grade_at_ascent?: string | null
  is_repeat?: boolean
  personal_grade?: string | null
  quality?: number | null
  effort?: number | null
  kneepad_used?: boolean | null
  notes?: string | null
  visibility?: Visibility
}

export function useUpdateAscent() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (variables: { id: string; userId: string; values: AscentUpdateValues; routeId?: string }) => {
      const values = variables.values
      // Ricalcola il Capital Score se cambia stile/conteggio/ripetizione.
      // Le ripetizioni NON generano punteggio: score=null.
      const touchesScore =
        'ascent_style' in values || 'attempt_count' in values || 'is_repeat' in values
      const payload =
        touchesScore && (values.is_repeat || values.grade_at_ascent)
          ? (() => {
              const capitalScore = values.is_repeat
                ? null
                : values.grade_at_ascent
                  ? capitalScoreFromAscent({
                      grade: values.grade_at_ascent,
                      ascent_style: values.ascent_style,
                      attempt_count: values.attempt_count,
                    })
                  : undefined
              if (capitalScore === undefined) return values
              return {
                ...values,
                score: capitalScore,
                score_version: capitalScore === null ? null : SCORE_VERSION,
              }
            })()
          : values
      const { error } = await supabase
        .from('ascents')
        .update(payload)
        .eq('id', variables.id)
      if (error) throw new Error(error.message + (error.details ? ` — ${error.details}` : ''))
      return { routeId: variables.routeId }
    },
    onSuccess: (result, variables) => {
      qc.invalidateQueries({ queryKey: ['my-ascents', variables.userId] })
      qc.invalidateQueries({ queryKey: ['my-sessions', variables.userId] })
      if (result?.routeId) {
        qc.invalidateQueries({ queryKey: ['route-history', result.routeId, variables.userId] })
      }
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
      qc.invalidateQueries({ queryKey: ['my-sessions', variables.userId] })
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

export function useRouteSearch(query: string, limit = 20) {
  return useQuery({
    queryKey: ['route-search', query, limit],
    queryFn: async (): Promise<RouteSearchResult[]> => {
      const { data, error } = await supabase
        .from('routes')
        .select(`
          id, name, official_grade, grade_numeric, route_type,
          sector:sectors(name, crag:crags(name))
        `)
        .ilike('name', `%${query}%`)
        .limit(limit)
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

// ── Personal route notes (technical data per user+route) ───────────────────

export function useMyRouteNotes(routeId: string, userId: string) {
  return useQuery({
    queryKey: ['my-route-notes', routeId, userId],
    queryFn: async (): Promise<UserRouteNote | null> => {
      const { data, error } = await supabase
        .from('user_route_notes')
        .select('*')
        .eq('route_id', routeId)
        .eq('user_id', userId)
        .maybeSingle()
      if (error) throw error
      return data as UserRouteNote | null
    },
    enabled: !!routeId && !!userId,
  })
}

export type RouteNotesPayload = {
  user_id: string
  route_id: string
  hold_profile?: Record<string, string>
  movement_profile?: Record<string, string>
  style_profile?: Record<string, string>
  crux?: string | null
  rests?: string | null
  main_beta?: string | null
  alternative_beta?: string | null
  kneepad_data?: Record<string, unknown>
  equipment_data?: Record<string, unknown>
  safety_notes?: string | null
  visibility?: Visibility
}

export function useUpsertRouteNotes() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (payload: RouteNotesPayload) => {
      const { error } = await supabase
        .from('user_route_notes')
        .upsert(payload, { onConflict: 'user_id,route_id' })
      if (error) throw new Error(error.message + (error.details ? ` — ${error.details}` : ''))
    },
    onSuccess: (_, payload) => {
      qc.invalidateQueries({ queryKey: ['my-route-notes', payload.route_id, payload.user_id] })
    },
  })
}
