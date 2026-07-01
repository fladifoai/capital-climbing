import { useQuery } from '@tanstack/react-query'
import { supabase } from '../../lib/supabase'
import type { Country, Region, Area, Crag, Sector, Route } from '../../types/database'

export const ITALY_ID = '00000000-0000-0000-0001-000000000001'

export interface RegionWithCount extends Region {
  crag_count: number
  sector_count: number
  route_count: number
}

export interface CountryWithCount extends Country {
  region_count: number
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
  subsectors?: SectorWithRoutes[]
}

// Ordine nazioni: Italia sempre prima, poi per numero falesie decrescente, poi nome.
const COUNTRY_PRIORITY: Record<string, number> = { [ITALY_ID]: 0 }

export function useCountriesWithCounts() {
  return useQuery({
    queryKey: ['countries-with-counts'],
    queryFn: async (): Promise<CountryWithCount[]> => {
      // Conteggi aggregati lato server (view country_counts): niente più
      // download dell'intera tabella routes nel browser.
      const [countriesRes, regionsRes, countsRes] = await Promise.all([
        supabase.from('countries').select('*').order('name'),
        supabase.from('regions').select('id, country_id'),
        supabase.from('country_counts').select('country_id, crag_count, sector_count, route_count'),
      ])
      if (countriesRes.error) throw countriesRes.error
      if (regionsRes.error) throw regionsRes.error
      if (countsRes.error) throw countsRes.error

      const countries = countriesRes.data ?? []
      const regions = regionsRes.data ?? []
      const counts = new Map(
        (countsRes.data ?? []).map(c => [c.country_id as string, c])
      )

      const regionsByCountry = new Map<string, number>()
      regions.forEach(r => {
        if (!r.country_id) return
        regionsByCountry.set(r.country_id, (regionsByCountry.get(r.country_id) ?? 0) + 1)
      })

      const withCounts = countries.map(c => {
        const ct = counts.get(c.id)
        return {
          ...c,
          region_count: regionsByCountry.get(c.id) ?? 0,
          crag_count: ct?.crag_count ?? 0,
          sector_count: ct?.sector_count ?? 0,
          route_count: ct?.route_count ?? 0,
        }
      })

      return withCounts.sort((a, b) => {
        const pa = COUNTRY_PRIORITY[a.id] ?? 1
        const pb = COUNTRY_PRIORITY[b.id] ?? 1
        if (pa !== pb) return pa - pb
        if (b.crag_count !== a.crag_count) return b.crag_count - a.crag_count
        return a.name.localeCompare(b.name, 'it')
      })
    },
  })
}

export function useRegionsWithCounts(countryId: string) {
  return useQuery({
    queryKey: ['regions-with-counts', countryId],
    queryFn: async (): Promise<RegionWithCount[]> => {
      // Conteggi aggregati lato server (view region_counts).
      const [regionsRes, countsRes] = await Promise.all([
        supabase.from('regions').select('*').eq('country_id', countryId).order('name'),
        supabase.from('region_counts').select('region_id, crag_count, sector_count, route_count').eq('country_id', countryId),
      ])

      if (regionsRes.error) throw regionsRes.error
      if (countsRes.error) throw countsRes.error

      const counts = new Map(
        (countsRes.data ?? []).map(r => [r.region_id as string, r])
      )

      return (regionsRes.data ?? []).map(r => {
        const ct = counts.get(r.id)
        return {
          ...r,
          crag_count: ct?.crag_count ?? 0,
          sector_count: ct?.sector_count ?? 0,
          route_count: ct?.route_count ?? 0,
        }
      })
    },
    enabled: !!countryId,
  })
}

export function useCountry(countryId: string) {
  return useQuery({
    queryKey: ['country', countryId],
    queryFn: async (): Promise<Country> => {
      const { data, error } = await supabase
        .from('countries')
        .select('*')
        .eq('id', countryId)
        .single()
      if (error) throw error
      return data as Country
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
      const sectorsRes = await supabase
        .from('sectors').select('*').eq('crag_id', cragId).order('sort_order')
      if (sectorsRes.error) throw sectorsRes.error

      const sectorIds = (sectorsRes.data ?? []).map(s => s.id)

      // Query routes by sector_id (works regardless of whether crag_id backfill ran)
      // Also fetch routes with crag_id but no sector (direct-on-crag routes)
      const [bySecRes, byCragRes] = await Promise.all([
        sectorIds.length > 0
          ? supabase.from('routes').select('*')
              .in('sector_id', sectorIds)
              .order('line_order', { nullsFirst: false })
              .order('name')
          : Promise.resolve({ data: [], error: null }),
        supabase.from('routes').select('*')
          .eq('crag_id', cragId)
          .is('sector_id', null)
          .order('line_order', { nullsFirst: false })
          .order('name'),
      ])
      if (bySecRes.error) throw bySecRes.error
      if (byCragRes.error) throw byCragRes.error

      const routesBySector = new Map<string, Route[]>()
      const unsectoredRoutes: Route[] = [...((byCragRes.data ?? []) as Route[])]

      ;((bySecRes.data ?? []) as Route[]).forEach(r => {
        const list = routesBySector.get(r.sector_id!) ?? []
        list.push(r)
        routesBySector.set(r.sector_id!, list)
      })

      const topLevelSectors = (sectorsRes.data ?? []).filter(s => !s.parent_sector_id)
      const subsectorsBySector = new Map<string, typeof sectorsRes.data>()
      ;(sectorsRes.data ?? []).filter(s => s.parent_sector_id).forEach(s => {
        const list = subsectorsBySector.get(s.parent_sector_id!) ?? []
        list.push(s)
        subsectorsBySector.set(s.parent_sector_id!, list)
      })

      const result: SectorWithRoutes[] = topLevelSectors.map(s => ({
        ...s,
        routes: routesBySector.get(s.id) ?? [],
        subsectors: (subsectorsBySector.get(s.id) ?? []).map(sub => ({
          ...sub,
          routes: routesBySector.get(sub.id) ?? [],
        })),
      }))

      if (unsectoredRoutes.length > 0) {
        result.push({
          id: '__unsectored__',
          crag_id: cragId,
          parent_sector_id: null,
          name: 'Da assegnare',
          normalized_name: 'da-assegnare',
          slug: null,
          aliases: [],
          description: null,
          orientation: null,
          approach_notes: null,
          sun_morning: null,
          sun_afternoon: null,
          summer_score: null,
          winter_score: null,
          best_season: null,
          sort_order: 9999,
          created_at: '',
          updated_at: '',
          routes: unsectoredRoutes,
        })
      }

      return result
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

// ─── Stato personale vie in una falesia ──────────────────────
// Priorità: sent/repeated > project > attempted > not_tried

export type RouteUserStatusKind =
  | 'not_tried' | 'attempted' | 'project' | 'sent' | 'repeated'

export interface RouteUserStatus {
  status: RouteUserStatusKind
  ascent_count: number
  first_ascent_date: string | null
  best_attempt_type: string | null
  active_project_id: string | null
}

// Ordine "migliore" stile (più basso = meglio) per scegliere best_attempt_type
const ATTEMPT_RANK: Record<string, number> = {
  onsight: 0, flash: 1, second: 2, third: 3, four_plus: 4, redpoint: 5,
}

export function useRouteUserStatuses(routeIds: string[], userId: string) {
  const sortedIds = [...routeIds].sort()
  return useQuery({
    queryKey: ['route-user-statuses', userId, sortedIds],
    queryFn: async (): Promise<Map<string, RouteUserStatus>> => {
      const map = new Map<string, RouteUserStatus>()
      if (routeIds.length === 0 || !userId) return map

      const [ascentsRes, projectsRes, attemptsRes] = await Promise.all([
        supabase.from('ascents')
          .select('route_id, date, status, attempt_type')
          .eq('user_id', userId)
          .in('route_id', routeIds),
        supabase.from('projects')
          .select('id, route_id')
          .eq('user_id', userId)
          .eq('status', 'active')
          .in('route_id', routeIds),
        supabase.from('attempts')
          .select('route_id')
          .eq('user_id', userId)
          .in('route_id', routeIds),
      ])
      if (ascentsRes.error) throw ascentsRes.error
      if (projectsRes.error) throw projectsRes.error
      if (attemptsRes.error) throw attemptsRes.error

      const ensure = (rid: string): RouteUserStatus => {
        let s = map.get(rid)
        if (!s) {
          s = { status: 'not_tried', ascent_count: 0, first_ascent_date: null, best_attempt_type: null, active_project_id: null }
          map.set(rid, s)
        }
        return s
      }

      const hasAttempt = new Set<string>()

      ;(ascentsRes.data ?? []).forEach(a => {
        const s = ensure(a.route_id)
        if (a.status === 'completed') {
          s.ascent_count++
          if (!s.first_ascent_date || a.date < s.first_ascent_date) s.first_ascent_date = a.date
          if (a.attempt_type) {
            const rank = ATTEMPT_RANK[a.attempt_type] ?? 99
            const curRank = s.best_attempt_type ? (ATTEMPT_RANK[s.best_attempt_type] ?? 99) : 99
            if (rank < curRank) s.best_attempt_type = a.attempt_type
          }
        } else {
          hasAttempt.add(a.route_id)
        }
      })
      ;(attemptsRes.data ?? []).forEach(t => hasAttempt.add(t.route_id))
      ;(projectsRes.data ?? []).forEach(p => { ensure(p.route_id).active_project_id = p.id })

      // Risolvi stato finale per priorità
      const allIds = new Set<string>([
        ...map.keys(), ...hasAttempt,
      ])
      allIds.forEach(rid => {
        const s = ensure(rid)
        if (s.ascent_count > 1) s.status = 'repeated'
        else if (s.ascent_count === 1) s.status = 'sent'
        else if (s.active_project_id) s.status = 'project'
        else if (hasAttempt.has(rid)) s.status = 'attempted'
        else s.status = 'not_tried'
      })

      return map
    },
    enabled: !!userId && routeIds.length > 0,
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
