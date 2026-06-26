import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import { ITALY_ID } from '../catalog/hooks'
import type { Area, Crag, Region, Sector, Route } from '../../types/database'

export function slugify(name: string) {
  return name
    .toLowerCase()
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
}

// ── Types ──────────────────────────────────────────────────────────────

export interface CragFormValues {
  name: string
  region_id: string
  area_id: string | null
  municipality: string | null
  province: string | null
  latitude: number | null
  longitude: number | null
  altitude_m: number | null
  rock_type: string | null
  access_status: string
  approach_minutes: number | null
  orientation: string | null
  rainproof: boolean
  access_notes: string | null
  parking_notes: string | null
}

export interface SectorFormValues {
  name: string
  description: string | null
  orientation: string | null
  approach_notes: string | null
  sort_order: number
}

export interface RouteFormValues {
  name: string
  official_grade: string | null
  length_m: number | null
  pitches: number
  bolts: number | null
  angle: string | null
  route_type: string
  first_ascent: string | null
  bolter: string | null
  description: string | null
  line_order: number | null
}

// ── Queries ────────────────────────────────────────────────────────────

export function useAllAreas(regionId: string) {
  return useQuery({
    queryKey: ['all-areas', regionId],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('areas')
        .select('id, name')
        .eq('region_id', regionId)
        .order('name')
      if (error) throw error
      return data as Pick<Area, 'id' | 'name'>[]
    },
    enabled: !!regionId,
  })
}

export function useAllRegions() {
  return useQuery({
    queryKey: ['all-regions'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('regions')
        .select('id, name')
        .eq('country_id', ITALY_ID)
        .order('name')
      if (error) throw error
      return data as Pick<Region, 'id' | 'name'>[]
    },
  })
}

export function useAdminCrags() {
  return useQuery({
    queryKey: ['admin-crags'],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('crags')
        .select('*, region:regions(id, name)')
        .order('name')
      if (error) throw error
      return data as (Crag & { region: Pick<Region, 'id' | 'name'> | null })[]
    },
  })
}

export function useAdminSectors(cragId: string) {
  return useQuery({
    queryKey: ['admin-sectors', cragId],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('sectors')
        .select('*')
        .eq('crag_id', cragId)
        .order('sort_order')
      if (error) throw error
      return data as Sector[]
    },
    enabled: !!cragId,
  })
}

export function useAdminRoutes(sectorId: string) {
  return useQuery({
    queryKey: ['admin-routes', sectorId],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('routes')
        .select('*')
        .eq('sector_id', sectorId)
        .order('line_order', { nullsFirst: false })
        .order('name')
      if (error) throw error
      return data as Route[]
    },
    enabled: !!sectorId,
  })
}

// ── Crag mutations ──────────────────────────────────────────────────────

export function useCreateCrag() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (values: CragFormValues) => {
      const { data: regionRow } = await supabase
        .from('regions')
        .select('name')
        .eq('id', values.region_id)
        .single()

      const { data, error } = await supabase
        .from('crags')
        .insert({
          ...values,
          normalized_name: slugify(values.name),
          country_id: ITALY_ID,
          country: 'Italia',
          region: regionRow?.name ?? null,
          services: {},
        })
        .select()
        .single()
      if (error) throw error
      return data
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['admin-crags'] })
      qc.invalidateQueries({ queryKey: ['regions-with-counts'] })
    },
  })
}

export function useUpdateCrag() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async ({ id, values }: { id: string; values: CragFormValues }) => {
      const { data: regionRow } = await supabase
        .from('regions')
        .select('name')
        .eq('id', values.region_id)
        .single()

      const { data, error } = await supabase
        .from('crags')
        .update({
          ...values,
          normalized_name: slugify(values.name),
          region: regionRow?.name ?? null,
        })
        .eq('id', id)
        .select()
        .single()
      if (error) throw error
      return data
    },
    onSuccess: (_, { id }) => {
      qc.invalidateQueries({ queryKey: ['admin-crags'] })
      qc.invalidateQueries({ queryKey: ['crag', id] })
      qc.invalidateQueries({ queryKey: ['regions-with-counts'] })
    },
  })
}

export function useDeleteCrag() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (id: string) => {
      const { error } = await supabase.from('crags').delete().eq('id', id)
      if (error) throw error
    },
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['admin-crags'] })
      qc.invalidateQueries({ queryKey: ['regions-with-counts'] })
    },
  })
}

// ── Sector mutations ────────────────────────────────────────────────────

export function useCreateSector() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async ({ cragId, values }: { cragId: string; values: SectorFormValues }) => {
      const { data, error } = await supabase
        .from('sectors')
        .insert({ ...values, crag_id: cragId, normalized_name: slugify(values.name) })
        .select()
        .single()
      if (error) throw error
      return data
    },
    onSuccess: (_, { cragId }) => {
      qc.invalidateQueries({ queryKey: ['admin-sectors', cragId] })
      qc.invalidateQueries({ queryKey: ['sectors-with-routes', cragId] })
    },
  })
}

export function useUpdateSector() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (variables: { id: string; cragId: string; values: SectorFormValues }) => {
      const { data, error } = await supabase
        .from('sectors')
        .update({ ...variables.values, normalized_name: slugify(variables.values.name) })
        .eq('id', variables.id)
        .select()
        .single()
      if (error) throw error
      return data
    },
    onSuccess: (_, variables) => {
      qc.invalidateQueries({ queryKey: ['admin-sectors', variables.cragId] })
      qc.invalidateQueries({ queryKey: ['sectors-with-routes', variables.cragId] })
    },
  })
}

export function useDeleteSector() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (variables: { id: string; cragId: string }) => {
      const { error } = await supabase.from('sectors').delete().eq('id', variables.id)
      if (error) throw error
    },
    onSuccess: (_, variables) => {
      qc.invalidateQueries({ queryKey: ['admin-sectors', variables.cragId] })
      qc.invalidateQueries({ queryKey: ['sectors-with-routes', variables.cragId] })
    },
  })
}

// ── Route mutations ─────────────────────────────────────────────────────

export function useCreateRoute() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async ({ sectorId, values }: { sectorId: string; values: RouteFormValues }) => {
      const { data, error } = await supabase
        .from('routes')
        .insert({ ...values, sector_id: sectorId, normalized_name: slugify(values.name) })
        .select()
        .single()
      if (error) throw error
      return data
    },
    onSuccess: (_, { sectorId }) => {
      qc.invalidateQueries({ queryKey: ['admin-routes', sectorId] })
    },
  })
}

export function useUpdateRoute() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (variables: { id: string; sectorId: string; values: RouteFormValues }) => {
      const { data, error } = await supabase
        .from('routes')
        .update({ ...variables.values, normalized_name: slugify(variables.values.name) })
        .eq('id', variables.id)
        .select()
        .single()
      if (error) throw error
      return data
    },
    onSuccess: (_, variables) => {
      qc.invalidateQueries({ queryKey: ['admin-routes', variables.sectorId] })
    },
  })
}

export function useDeleteRoute() {
  const qc = useQueryClient()
  return useMutation({
    mutationFn: async (variables: { id: string; sectorId: string }) => {
      const { error } = await supabase.from('routes').delete().eq('id', variables.id)
      if (error) throw error
    },
    onSuccess: (_, variables) => {
      qc.invalidateQueries({ queryKey: ['admin-routes', variables.sectorId] })
    },
  })
}
