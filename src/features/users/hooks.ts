import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import type { Profile, Route, Sector, Crag, Ascent, Project } from '../../types/database'

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
  display_name?: string
  bio?: string | null
  city?: string | null
  country?: string | null
  climbing_since?: number | null
  preferred_style?: string | null
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
