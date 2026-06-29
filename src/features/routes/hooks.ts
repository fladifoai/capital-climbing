import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import type { Ascent } from '../../types/database'

// ─── Types ───────────────────────────────────────────────────

export type ProfileLevel = 'none' | 'secondary' | 'important' | 'dominant'

export interface RouteFeatures {
  id: string
  route_id: string
  hold_profile: Record<string, ProfileLevel>
  movement_profile: Record<string, ProfileLevel>
  style_profile: Record<string, ProfileLevel>
  crux_data: {
    position?: string
    crux_type?: string
    moves_count?: number
    reading_difficulty?: string
    notes?: string
  }
  rest_data: {
    rest_count?: number
    has_no_hand_rest?: boolean
    has_kneebar_rest?: boolean
    notes?: string
  }
  kneepad_data: {
    kneepad_possible?: boolean
    kneepad_useful?: 'not_needed' | 'useful' | 'very_useful' | 'essential'
    knee?: 'left' | 'right' | 'both'
    kneebar_count?: number
    notes?: string
  }
  equipment_data: {
    minimum_rope?: string
    recommended_rope?: string
    minimum_draws?: number
    recommended_draws?: number
    stick_clip?: boolean
    helmet?: boolean
    notes?: string
  }
  safety_data: {
    first_bolt_high?: boolean
    ground_fall_risk?: boolean
    ledge_fall_risk?: boolean
    unstable_rock?: boolean
    problematic_anchor?: boolean
    minimum_rope?: string
    minimum_draws?: number
    helmet_recommended?: boolean
    status?: 'verified' | 'unverified' | 'flagged' | 'outdated'
    notes?: string
    verified_at?: string
  }
  verified: boolean
  verified_at: string | null
}

export interface CommunityRating {
  route_id: string
  avg_grade_numeric: number | null
  avg_beauty: number | null
  rating_count: number
  grades: { grade: string; count: number }[]
}

// ─── Route technical features ─────────────────────────────────

export function useRouteFeatures(routeId: string) {
  return useQuery({
    queryKey: ['route-features', routeId],
    queryFn: async (): Promise<RouteFeatures | null> => {
      const { data, error } = await supabase
        .from('route_features')
        .select('*')
        .eq('route_id', routeId)
        .maybeSingle()
      if (error) throw error
      return data as RouteFeatures | null
    },
    enabled: !!routeId,
  })
}

// ─── Spoiler unlock ───────────────────────────────────────────

export function useIsSpoilerUnlocked(routeId: string, userId: string) {
  return useQuery({
    queryKey: ['spoiler-unlocked', routeId, userId],
    queryFn: async (): Promise<boolean> => {
      const { data, error } = await supabase
        .from('route_spoiler_unlocks')
        .select('unlocked_at')
        .eq('route_id', routeId)
        .eq('user_id', userId)
        .maybeSingle()
      if (error) throw error
      return data !== null
    },
    enabled: !!routeId && !!userId,
  })
}

export function useUnlockSpoiler() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async ({ routeId, userId }: { routeId: string; userId: string }) => {
      const { error } = await supabase
        .from('route_spoiler_unlocks')
        .insert({ route_id: routeId, user_id: userId })
      if (error && error.code !== '23505') throw error // ignore duplicate
    },
    onSuccess: (_, { routeId, userId }) => {
      qc.invalidateQueries({ queryKey: ['spoiler-unlocked', routeId, userId] })
    },
  })
}

// ─── Personal history on this route ──────────────────────────

export function useRoutePersonalHistory(routeId: string, userId: string) {
  return useQuery({
    queryKey: ['route-history', routeId, userId],
    queryFn: async (): Promise<Ascent[]> => {
      const { data, error } = await supabase
        .from('ascents')
        .select('*')
        .eq('route_id', routeId)
        .eq('user_id', userId)
        .order('date', { ascending: false })
      if (error) throw error
      return (data ?? []) as Ascent[]
    },
    enabled: !!routeId && !!userId,
  })
}

// ─── Chi ha salito questa via (ascensioni pubbliche + proprie) ─

export interface PublicAscent {
  ascent_id: string
  user_id: string
  username: string
  display_name: string
  avatar_url: string | null
  date: string
  attempt_type: string | null
  grade_at_ascent: string | null
  is_own: boolean
  is_private: boolean
  ascent_count: number
  public_note: string | null
}

export function useRoutePublicAscents(routeId: string, userId: string | null) {
  return useQuery({
    queryKey: ['route-public-ascents', routeId, userId ?? 'anon'],
    queryFn: async (): Promise<PublicAscent[]> => {
      // RLS restituisce solo ascensioni public OR proprie
      const { data: ascents, error } = await supabase
        .from('ascents')
        .select('id, user_id, date, status, attempt_type, grade_at_ascent, visibility, notes')
        .eq('route_id', routeId)
        .eq('status', 'completed')
        .order('date', { ascending: false })
      if (error) throw error
      const rows = ascents ?? []
      if (rows.length === 0) return []

      // Conteggio ascensioni per utente (per badge ripetizioni)
      const countByUser = new Map<string, number>()
      rows.forEach(a => countByUser.set(a.user_id, (countByUser.get(a.user_id) ?? 0) + 1))

      // Carica profili pubblici (no FK diretto ascents→profiles, query separata)
      const userIds = [...new Set(rows.map(a => a.user_id))]
      const { data: profiles, error: pErr } = await supabase
        .from('profiles')
        .select('id, username, display_name, avatar_url')
        .in('id', userIds)
      if (pErr) throw pErr
      const profMap = new Map((profiles ?? []).map(p => [p.id, p]))

      return rows.map(a => {
        const p = profMap.get(a.user_id)
        const isOwn = userId != null && a.user_id === userId
        return {
          ascent_id: a.id,
          user_id: a.user_id,
          username: p?.username ?? 'utente',
          display_name: p?.display_name || p?.username || 'Utente',
          avatar_url: p?.avatar_url ?? null,
          date: a.date,
          attempt_type: a.attempt_type,
          grade_at_ascent: a.grade_at_ascent,
          is_own: isOwn,
          is_private: a.visibility !== 'public',
          ascent_count: countByUser.get(a.user_id) ?? 1,
          public_note: a.visibility === 'public' ? (a.notes ?? null) : null,
        }
      })
    },
    enabled: !!routeId,
  })
}

// ─── Community ratings ────────────────────────────────────────

export function useCommunityRating(routeId: string) {
  return useQuery({
    queryKey: ['community-rating', routeId],
    queryFn: async (): Promise<CommunityRating> => {
      const { data, error } = await supabase
        .from('community_route_ratings')
        .select('perceived_grade, grade_numeric, beauty')
        .eq('route_id', routeId)
      if (error) throw error
      const rows = data ?? []
      const gradeMap = new Map<string, number>()
      let gradeSum = 0, gradeCount = 0, beautySum = 0, beautyCount = 0
      rows.forEach(r => {
        if (r.grade_numeric) { gradeSum += r.grade_numeric; gradeCount++ }
        if (r.beauty) { beautySum += r.beauty; beautyCount++ }
        if (r.perceived_grade) gradeMap.set(r.perceived_grade, (gradeMap.get(r.perceived_grade) ?? 0) + 1)
      })
      return {
        route_id: routeId,
        avg_grade_numeric: gradeCount > 0 ? gradeSum / gradeCount : null,
        avg_beauty: beautyCount > 0 ? beautySum / beautyCount : null,
        rating_count: rows.length,
        grades: Array.from(gradeMap.entries()).map(([grade, count]) => ({ grade, count })).sort((a, b) => b.count - a.count),
      }
    },
    enabled: !!routeId,
  })
}

export function useMyRouteRating(routeId: string, userId: string) {
  return useQuery({
    queryKey: ['my-route-rating', routeId, userId],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('community_route_ratings')
        .select('*')
        .eq('route_id', routeId)
        .eq('user_id', userId)
        .maybeSingle()
      if (error) throw error
      return data
    },
    enabled: !!routeId && !!userId,
  })
}

export function useVoteRoute() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (v: { routeId: string; userId: string; perceived_grade?: string | null; grade_numeric?: number | null; beauty?: number | null }) => {
      const { error } = await supabase
        .from('community_route_ratings')
        .upsert({
          route_id: v.routeId,
          user_id: v.userId,
          perceived_grade: v.perceived_grade ?? null,
          grade_numeric: v.grade_numeric ?? null,
          beauty: v.beauty ?? null,
          updated_at: new Date().toISOString(),
        }, { onConflict: 'route_id,user_id' })
      if (error) throw error
    },
    onSuccess: (_, v) => {
      qc.invalidateQueries({ queryKey: ['community-rating', v.routeId] })
      qc.invalidateQueries({ queryKey: ['my-route-rating', v.routeId, v.userId] })
    },
  })
}
