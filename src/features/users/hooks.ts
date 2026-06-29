import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import type { Profile, Route, Sector, Crag, Ascent, Project } from '../../types/database'

// ─── Follow system ────────────────────────────────────────

export function useIsFollowing(currentUserId: string, targetUserId: string) {
  return useQuery({
    queryKey: ['is-following', currentUserId, targetUserId],
    queryFn: async (): Promise<boolean> => {
      const { data, error } = await supabase
        .from('follows')
        .select('follower_id')
        .eq('follower_id', currentUserId)
        .eq('following_id', targetUserId)
        .maybeSingle()
      if (error) throw error
      return data !== null
    },
    enabled: !!currentUserId && !!targetUserId && currentUserId !== targetUserId,
  })
}

export interface FollowCounts { followers: number; following: number }

export function useFollowCounts(userId: string) {
  return useQuery({
    queryKey: ['follow-counts', userId],
    queryFn: async (): Promise<FollowCounts> => {
      const [{ count: followers }, { count: following }] = await Promise.all([
        supabase.from('follows').select('*', { count: 'exact', head: true }).eq('following_id', userId),
        supabase.from('follows').select('*', { count: 'exact', head: true }).eq('follower_id', userId),
      ])
      return { followers: followers ?? 0, following: following ?? 0 }
    },
    enabled: !!userId,
  })
}

export function useFollowUser() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (variables: { followerId: string; followingId: string }) => {
      const { error } = await supabase.from('follows').insert({
        follower_id: variables.followerId,
        following_id: variables.followingId,
      })
      if (error) throw error
    },
    onSuccess: (_, v) => {
      qc.invalidateQueries({ queryKey: ['is-following', v.followerId, v.followingId] })
      qc.invalidateQueries({ queryKey: ['follow-counts', v.followingId] })
      qc.invalidateQueries({ queryKey: ['follow-counts', v.followerId] })
      qc.invalidateQueries({ queryKey: ['feed-ascents', v.followerId] })
    },
  })
}

export function useUnfollowUser() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (variables: { followerId: string; followingId: string }) => {
      const { error } = await supabase
        .from('follows')
        .delete()
        .eq('follower_id', variables.followerId)
        .eq('following_id', variables.followingId)
      if (error) throw error
    },
    onSuccess: (_, v) => {
      qc.invalidateQueries({ queryKey: ['is-following', v.followerId, v.followingId] })
      qc.invalidateQueries({ queryKey: ['follow-counts', v.followingId] })
      qc.invalidateQueries({ queryKey: ['follow-counts', v.followerId] })
      qc.invalidateQueries({ queryKey: ['feed-ascents', v.followerId] })
    },
  })
}

// ─── Friend activity feed ─────────────────────────────────

export interface FeedAscent {
  id: string
  user_id: string
  date: string
  grade_at_ascent: string | null
  attempt_type: string | null
  ascent_style: string | null
  notes: string | null
  profile: { username: string; display_name: string | null; avatar_url: string | null } | null
  route: {
    id: string
    name: string
    official_grade: string | null
    sector: { name: string; crag: { id: string; name: string } }
  } | null
}

export function useFeedAscents(userId: string) {
  return useQuery({
    queryKey: ['feed-ascents', userId],
    queryFn: async (): Promise<FeedAscent[]> => {
      // Step 1: get IDs of users we follow
      const { data: followRows, error: fErr } = await supabase
        .from('follows')
        .select('following_id')
        .eq('follower_id', userId)
      if (fErr) throw fErr
      const ids = (followRows ?? []).map(r => r.following_id as string)
      if (ids.length === 0) return []

      // Step 2: get their recent public ascents
      const { data, error } = await supabase
        .from('ascents')
        .select(`
          id, user_id, date, grade_at_ascent, attempt_type, ascent_style, notes,
          route:routes(id, name, official_grade, sector:sectors(name, crag:crags(id, name)))
        `)
        .in('user_id', ids)
        .eq('visibility', 'public')
        .eq('status', 'completed')
        .order('date', { ascending: false })
        .limit(30)
      if (error) throw error

      // Step 3: fetch profiles for those users
      const { data: profiles } = await supabase
        .from('profiles')
        .select('id, username, display_name, avatar_url')
        .in('id', ids)
      const profileMap = Object.fromEntries((profiles ?? []).map(p => [p.id, p]))

      return ((data ?? []) as unknown as FeedAscent[]).map(a => ({
        ...a,
        profile: profileMap[a.user_id] ?? null,
      }))
    },
    enabled: !!userId,
  })
}

export function useSearchUsers(query: string) {
  return useQuery({
    queryKey: ['users-search', query],
    queryFn: async (): Promise<Profile[]> => {
      let q = supabase.from('profiles').select('*').order('display_name').limit(50)
      if (query.trim().length >= 2) {
        q = q.or(`username.ilike.%${query}%,display_name.ilike.%${query}%`)
      }
      const { data, error } = await q
      if (error) throw error
      return data ?? []
    },
  })
}

export function useProfile(username: string) {
  return useQuery({
    queryKey: ['profile', username],
    queryFn: async (): Promise<Profile> => {
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('username', username)
        .single()
      if (error) throw error
      return data
    },
    enabled: !!username,
  })
}

export function useOwnProfile(userId: string) {
  return useQuery({
    queryKey: ['profile-own', userId],
    queryFn: async (): Promise<Profile | null> => {
      const { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', userId)
        .maybeSingle()
      if (error) throw error
      return data
    },
    enabled: !!userId,
  })
}

export interface ProfileUpdateValues {
  username?: string
  display_name?: string
  avatar_url?: string | null
  bio?: string | null
  city?: string | null
  country?: string | null
  climbing_since?: number | null
  preferred_style?: string | null
  is_public?: boolean
  show_ascents?: boolean
  show_projects?: boolean
  show_stats?: boolean
  show_charts?: boolean
  show_visited_crags?: boolean
  show_max_grade?: boolean
}

export function useUpdateProfile() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (variables: { userId: string; values: ProfileUpdateValues }) => {
      const { data, error } = await supabase
        .from('profiles')
        .update(variables.values)
        .eq('id', variables.userId)
        .select()
        .single()
      if (error) throw error
      return data
    },
    onSuccess: (_, variables) => {
      qc.invalidateQueries({ queryKey: ['profile-own', variables.userId] })
      qc.invalidateQueries({ queryKey: ['profile'] })
      qc.invalidateQueries({ queryKey: ['users-search'] })
    },
  })
}

// Public ascents for a user profile
export interface PublicAscent extends Ascent {
  route: Pick<Route, 'id' | 'name' | 'official_grade' | 'route_type'> & {
    sector: Pick<Sector, 'name'> & { crag: Pick<Crag, 'id' | 'name'> }
  }
}

export function usePublicAscents(userId: string) {
  return useQuery({
    queryKey: ['public-ascents', userId],
    queryFn: async (): Promise<PublicAscent[]> => {
      const { data, error } = await supabase
        .from('ascents')
        .select(`
          *,
          route:routes(
            id, name, official_grade, route_type,
            sector:sectors(name, crag:crags(id, name))
          )
        `)
        .eq('user_id', userId)
        .eq('visibility', 'public')
        .eq('status', 'completed')
        .order('date', { ascending: false })
        .limit(20)
      if (error) throw error
      return (data ?? []) as unknown as PublicAscent[]
    },
    enabled: !!userId,
  })
}

// Public projects for a user profile
export interface PublicProject extends Project {
  route: Pick<Route, 'id' | 'name' | 'official_grade'> & {
    sector: Pick<Sector, 'name'> & { crag: Pick<Crag, 'id' | 'name'> }
  }
}

export function usePublicProjects(userId: string) {
  return useQuery({
    queryKey: ['public-projects', userId],
    queryFn: async (): Promise<PublicProject[]> => {
      const { data, error } = await supabase
        .from('projects')
        .select(`
          *,
          route:routes(
            id, name, official_grade,
            sector:sectors(name, crag:crags(id, name))
          )
        `)
        .eq('user_id', userId)
        .eq('visibility', 'public')
        .in('status', ['active', 'paused'])
        .order('updated_at', { ascending: false })
        .limit(10)
      if (error) throw error
      return (data ?? []) as unknown as PublicProject[]
    },
    enabled: !!userId,
  })
}
