import { useQuery } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import type { Region, Area, Crag, Sector, Route } from '../../types/database'

export const ITALY_ID = '00000000-0000-0000-0001-000000000001'

export interface RegionWithCount extends Region {
  crag_count: number
  sector_count: number
  route_count: number
}

export interface CragSummary {
  id: string
  name: string
  municipality: string | null
  rock_type: string | null
  access_status: string
  approach_minutes: number | null
  area: Pick<Area, 'id' | 'name'> | null
}

export interface SectorWithRoutes extends Sector {
  routes: Route[]
}

export function useRegionsWithCounts(countryId: string) {
  return useQuery({
    queryKey: ['regions-with-counts', countryId],
    queryFn: async (): Promise<RegionWithCount[]> => {
      const [regionsRes, cragsRes, sectorsRes, routesRes] = await Promise.all([
        supabase.from('regions').select('*').eq('country_id', countryId).order('name'),
        supabase.from('crags').select('id, region_id').eq('country_id', countryId),
        supabase.from('sectors').select('id, crag_id'),
        supabase.from('routes').select('id, sector_id'),
      ])

      if (regionsRes.error) throw regionsRes.error

      const regions = regionsRes.data ?? []
      const crags = cragsRes.data ?? []
      const sectors = sectorsRes.data ?? []
      const routes = routesRes.data ?? []

      const cragsByRegion = new Map<string, string[]>()
      crags.forEach(c => {
        if (!c.region_id) return
        const list = cragsByRegion.get(c.region_id) ?? []
        list.push(c.id)
        cragsByRegion.set(c.region_id, list)
      })

      const sectorsByCrag = new Map<string, string[]>()
      sectors.forEach(s => {
        const list = sectorsByCrag.get(s.crag_id) ?? []
        list.push(s.id)
        sectorsByCrag.set(s.crag_id, list)
      })

      const routesBySector = new Map<string, number>()
      routes.forEach(r => {
        routesBySector.set(r.sector_id, (routesBySector.get(r.sector_id) ?? 0) + 1)
      })

      return regions.map(r => {
        const regionCrags = cragsByRegion.get(r.id) ?? []
        const regionSectors = regionCrags.flatMap(cid => sectorsByCrag.get(cid) ?? [])
        const regionRoutes = regionSectors.reduce((sum, sid) => sum + (routesBySector.get(sid) ?? 0), 0)
        return {
          ...r,
          crag_count: regionCrags.length,
          sector_count: regionSectors.length,
          route_count: regionRoutes,
        }
      })
    },
    enabled: !!countryId,
  })
}

export function useRegion(regionId: string) {
  return useQuery({
    queryKey: ['region', regionId],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('regions')
        .select('*, country:countries(id, name, slug)')
        .eq('id', regionId)
        .single()
      if (error) throw error
      return data
    },
    enabled: !!regionId,
  })
}

export function useCragsForRegion(regionId: string) {
  return useQuery({
    queryKey: ['crags', 'region', regionId],
    queryFn: async (): Promise<CragSummary[]> => {
      const { data, error } = await supabase
        .from('crags')
        .select('id, name, municipality, rock_type, access_status, approach_minutes, area:areas(id, name)')
        .eq('region_id', regionId)
        .order('name')
      if (error) throw error
      return (data ?? []) as unknown as CragSummary[]
    },
    enabled: !!regionId,
  })
}

export function useCrag(cragId: string) {
  return useQuery({
    queryKey: ['crag', cragId],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('crags')
        .select('*, region:regions(id, name, slug), area:areas(id, name, slug)')
        .eq('id', cragId)
        .single()
      if (error) throw error
      return data as Crag & {
        region: Pick<Region, 'id' | 'name' | 'slug'> | null
        area: Pick<Area, 'id' | 'name' | 'slug'> | null
      }
    },
    enabled: !!cragId,
  })
}

export function useSectorsWithRoutes(cragId: string) {
  return useQuery({
    queryKey: ['sectors-with-routes', cragId],
    queryFn: async (): Promise<SectorWithRoutes[]> => {
      const [sectorsRes, routesRes] = await Promise.all([
        supabase.from('sectors').select('*').eq('crag_id', cragId).order('sort_order'),
        supabase.from('routes')
          .select('*, sectors!inner(crag_id)')
          .eq('sectors.crag_id', cragId)
          .order('line_order', { nullsFirst: false })
          .order('name'),
      ])
      if (sectorsRes.error) throw sectorsRes.error
      if (routesRes.error) throw routesRes.error

      const routesBySector = new Map<string, Route[]>()
      ;(routesRes.data ?? []).forEach(r => {
        const list = routesBySector.get(r.sector_id) ?? []
        list.push(r as Route)
        routesBySector.set(r.sector_id, list)
      })

      return (sectorsRes.data ?? []).map(s => ({
        ...s,
        routes: routesBySector.get(s.id) ?? [],
      }))
    },
    enabled: !!cragId,
  })
}

export function useRoute(routeId: string) {
  return useQuery({
    queryKey: ['route', routeId],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('routes')
        .select('*, sector:sectors(id, name, crag:crags(id, name, region_id, region))')
        .eq('id', routeId)
        .single()
      if (error) throw error
      return data as Route & {
        sector: Pick<Sector, 'id' | 'name'> & {
          crag: Pick<Crag, 'id' | 'name' | 'region_id' | 'region'>
        }
      }
    },
    enabled: !!routeId,
  })
}

export function useItalyStats() {
  return useQuery({
    queryKey: ['italy-stats'],
    queryFn: async () => {
      const [cragsRes, sectorsRes, routesRes] = await Promise.all([
        supabase.from('crags').select('id', { count: 'exact', head: true }).eq('country_id', ITALY_ID),
        supabase.from('sectors').select('id', { count: 'exact', head: true }),
        supabase.from('routes').select('id', { count: 'exact', head: true }),
      ])
      return {
        crags: cragsRes.count ?? 0,
        sectors: sectorsRes.count ?? 0,
        routes: routesRes.count ?? 0,
      }
    },
  })
}
