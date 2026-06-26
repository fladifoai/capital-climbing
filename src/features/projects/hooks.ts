import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import type { Project, Route, Sector, Crag, ProjectStatus } from '../../types/database'

export interface ProjectWithRoute extends Project {
  route: Pick<Route, 'id' | 'name' | 'official_grade' | 'grade_numeric' | 'route_type'> & {
    sector: Pick<Sector, 'id' | 'name'> & {
      crag: Pick<Crag, 'id' | 'name'>
    }
  }
}

export function useMyProjects(userId: string) {
  return useQuery({
    queryKey: ['my-projects', userId],
    queryFn: async (): Promise<ProjectWithRoute[]> => {
      const { data, error } = await supabase
        .from('projects')
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
        .order('updated_at', { ascending: false })
      if (error) throw error
      return (data ?? []) as unknown as ProjectWithRoute[]
    },
    enabled: !!userId,
  })
}

export interface ProjectFormValues {
  route_id: string
  opened_date: string | null
  priority: 'high' | 'medium' | 'low'
  visibility: 'public' | 'private'
}

export function useCreateProject() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (variables: { userId: string; values: ProjectFormValues }) => {
      const { data, error } = await supabase
        .from('projects')
        .insert({
          user_id: variables.userId,
          route_id: variables.values.route_id,
          opened_date: variables.values.opened_date,
          priority: variables.values.priority,
          visibility: variables.values.visibility,
          status: 'active',
        })
        .select()
        .single()
      if (error) throw error
      return data
    },
    onSuccess: (_, variables) => {
      qc.invalidateQueries({ queryKey: ['my-projects', variables.userId] })
    },
  })
}

export interface ProjectUpdateValues {
  status?: ProjectStatus
  priority?: 'high' | 'medium' | 'low'
  attempts_count?: number
  last_session_date?: string | null
  progress?: number
  high_point?: string | null
  moves_solved?: string | null
  moves_missing?: string | null
  next_strategy?: string | null
  beta_notes?: string | null
  visibility?: 'public' | 'private'
}

export function useUpdateProject() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (variables: { id: string; userId: string; values: ProjectUpdateValues }) => {
      const { data, error } = await supabase
        .from('projects')
        .update(variables.values)
        .eq('id', variables.id)
        .select()
        .single()
      if (error) throw error
      return data
    },
    onSuccess: (_, variables) => {
      qc.invalidateQueries({ queryKey: ['my-projects', variables.userId] })
    },
  })
}

export function useDeleteProject() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (variables: { id: string; userId: string }) => {
      const { error } = await supabase.from('projects').delete().eq('id', variables.id)
      if (error) throw error
    },
    onSuccess: (_, variables) => {
      qc.invalidateQueries({ queryKey: ['my-projects', variables.userId] })
    },
  })
}
