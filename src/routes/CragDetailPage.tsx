import { useMemo, useState } from 'react'
import { Link, useParams, useNavigate } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'
import {
  useCrag, useSectorsWithRoutes, useRouteUserStatuses,
  type SectorWithRoutes, type RouteUserStatus,
} from '../features/catalog/hooks'
import type { Route } from '../types/database'
import '../styles/catalog.css'

const ATTEMPT_SHORT: Record<string, string> = {
  onsight: 'OS', flash: 'FL', second: 'RP', third: 'RP', four_plus: 'RP', redpoint: 'RP',
}

type RouteFilter = 'all' | 'done' | 'todo' | 'project' | 'attempted'

const FILTER_TABS: { key: RouteFilter; label: string }[] = [
  { key: 'all', label: 'Tutte' },
  { key: 'done', label: 'Scalate' },
  { key: 'todo', label: 'Da fare' },
  { key: 'project', label: 'Progetti' },
  { key: 'attempted', label: 'Provate' },
]

function matchesFilter(status: RouteUserStatus | undefined, filter: RouteFilter): boolean {
  const kind = status?.status ?? 'not_tried'
  switch (filter) {
    case 'all': return true
    case 'done': return kind === 'sent' || kind === 'repeated'
    case 'todo': return kind === 'not_tried'
    case 'project': return kind === 'project'
    case 'attempted': return kind === 'attempted'
  }
}

function RouteStatusBadge({ status }: { status: RouteUserStatus | undefined }) {
  if (!status || status.status === 'not_tried') return <span style={{ color: 'var(--text-muted)' }}>—</span>
  const { status: kind } = status
  if (kind === 'repeated') {
    return <span className="route-status-badge repeated">Ripetuta ×{status.ascent_count}</span>
  }
  if (kind === 'project') {
    return <span className="route-status-badge project">Progetto</span>
  }
  if (kind === 'attempted') {
    return <span className="route-status-badge attempted">Provata</span>
  }
  // sent
  const style = status.best_attempt_type ? ATTEMPT_SHORT[status.best_attempt_type] : null
  return (
    <span className="route-status-cell">
      <span className="route-status-badge sent">Scalata{style ? ` ${style}` : ''}</span>
      {status.first_ascent_date && (
        <span className="route-status-date">
          {new Date(status.first_ascent_date).toLocaleDateString('it-IT')}
        </span>
      )}
    </span>
  )
}

function RouteRows({
  routes, statuses, showStatus, onOpen,
}: {
  routes: Route[]
  statuses: Map<string, RouteUserStatus>
  showStatus: boolean
  onOpen: (id: string) => void
}) {
  return (
    <>
      {routes.map((route, i) => {
        const st = statuses.get(route.id)
        const rowClass = showStatus && st ? `row-${st.status}` : ''
        return (
          <tr key={route.id} className={rowClass} onClick={() => onOpen(route.id)}>
            <td style={{ color: '#8a9a87' }}>{route.line_order ?? i + 1}</td>
            <td><strong>{route.name}</strong></td>
            <td>
              {route.official_grade
                ? <span className="grade-badge">{route.official_grade}</span>
                : <span style={{ color: '#ccc' }}>—</span>}
            </td>
            <td>{route.length_m ? `${route.length_m} m` : '—'}</td>
            <td>{route.bolts ?? '—'}</td>
            {showStatus && <td><RouteStatusBadge status={st} /></td>}
          </tr>
        )
      })}
    </>
  )
}

export default function CragDetailPage() {
  const { cragId = '' } = useParams()
  const navigate = useNavigate()
  const { user } = useAuth()
  const { data: crag, isLoading: loadingCrag, error: cragError } = useCrag(cragId)
  const { data: sectors, isLoading: loadingSectors } = useSectorsWithRoutes(cragId)

  const [filter, setFilter] = useState<RouteFilter>('all')

  // Tutti i routeId della falesia (settori + sottosettori)
  const allRouteIds = useMemo(() => {
    if (!sectors) return []
    const ids: string[] = []
    sectors.forEach(s => {
      s.routes.forEach(r => ids.push(r.id))
      s.subsectors?.forEach(sub => sub.routes.forEach(r => ids.push(r.id)))
    })
    return ids
  }, [sectors])

  const { data: statusMap } = useRouteUserStatuses(allRouteIds, user?.id ?? '')
  const statuses = statusMap ?? new Map<string, RouteUserStatus>()
  const showStatus = !!user

  if (loadingCrag) return <div className="loading-state">Caricamento falesia…</div>
  if (cragError || !crag) return <div className="error-state">Falesia non trovata.</div>

  const totalRoutes = sectors?.reduce((sum, s) => sum + s.routes.length, 0) ?? 0

  // Conteggi per i tab filtro
  const filterCounts: Record<RouteFilter, number> = { all: 0, done: 0, todo: 0, project: 0, attempted: 0 }
  if (showStatus) {
    allRouteIds.forEach(id => {
      const st = statuses.get(id)
      filterCounts.all++
      if (matchesFilter(st, 'done')) filterCounts.done++
      if (matchesFilter(st, 'todo')) filterCounts.todo++
      if (matchesFilter(st, 'project')) filterCounts.project++
      if (matchesFilter(st, 'attempted')) filterCounts.attempted++
    })
  }

  const filterRoutes = (routes: Route[]) =>
    showStatus && filter !== 'all'
      ? routes.filter(r => matchesFilter(statuses.get(r.id), filter))
      : routes

  return (
    <div className="catalog-page">
      <nav className="breadcrumb">
        <Link to="/explore">Falesie</Link>
        {crag.region && (
          <>
            <span className="breadcrumb-sep">›</span>
            <Link to={`/regions/${crag.region.id}`}>{crag.region.name}</Link>
          </>
        )}
        <span className="breadcrumb-sep">›</span>
        <span>{crag.name}</span>
      </nav>

      <div className="crag-header-card">
        <h1 className="crag-name">{crag.name}</h1>
        <div className="crag-meta-row">
          {crag.municipality && (
            <div className="crag-meta-item">
              <span className="crag-meta-label">Comune:</span> {crag.municipality}
            </div>
          )}
          {crag.province && (
            <div className="crag-meta-item">
              <span className="crag-meta-label">Provincia:</span> {crag.province}
            </div>
          )}
          {crag.rock_type && (
            <div className="crag-meta-item">
              <span className="crag-meta-label">Roccia:</span> {crag.rock_type}
            </div>
          )}
          {crag.approach_minutes != null && (
            <div className="crag-meta-item">
              <span className="crag-meta-label">Avvicinamento:</span> {crag.approach_minutes} min
            </div>
          )}
          {crag.access_status && (
            <div className="crag-meta-item">
              <span className={`access-badge ${crag.access_status}`}>
                {crag.access_status === 'open' ? 'Accesso aperto' :
                 crag.access_status === 'limited' ? 'Accesso limitato' : 'Accesso chiuso'}
              </span>
            </div>
          )}
        </div>

        <div className="stat-bar" style={{ marginBottom: 0, paddingBottom: 0, borderBottom: 'none', marginTop: 16 }}>
          <div className="stat-item">
            <span className="stat-number">{sectors?.length ?? '—'}</span>
            <span className="stat-label">Settori</span>
          </div>
          <div className="stat-item">
            <span className="stat-number">{totalRoutes}</span>
            <span className="stat-label">Vie</span>
          </div>
          {showStatus && filterCounts.done > 0 && (
            <div className="stat-item">
              <span className="stat-number">{filterCounts.done}</span>
              <span className="stat-label">Scalate</span>
            </div>
          )}
        </div>
      </div>

      {loadingSectors && <div className="loading-state">Caricamento settori…</div>}

      {showStatus && totalRoutes > 0 && (
        <div className="route-filter-tabs">
          {FILTER_TABS.map(tab => (
            <button
              key={tab.key}
              className={`route-filter-tab${filter === tab.key ? ' active' : ''}`}
              onClick={() => setFilter(tab.key)}
            >
              {tab.label} <span style={{ opacity: 0.7 }}>({filterCounts[tab.key]})</span>
            </button>
          ))}
        </div>
      )}

      {sectors && sectors.length === 0 && (
        <div className="empty-state">Nessun settore ancora inserito.</div>
      )}

      {sectors && sectors.map((sector: SectorWithRoutes) => {
        const routesWithGrade = sector.routes.filter(r => r.grade_numeric != null)
        const minRoute = routesWithGrade.length
          ? routesWithGrade.reduce((a, b) => (a.grade_numeric! < b.grade_numeric! ? a : b))
          : null
        const maxRoute = routesWithGrade.length
          ? routesWithGrade.reduce((a, b) => (a.grade_numeric! > b.grade_numeric! ? a : b))
          : null
        const gradeRange = minRoute && maxRoute && minRoute.id !== maxRoute.id
          ? `${minRoute.official_grade} – ${maxRoute.official_grade}`
          : (minRoute ? minRoute.official_grade : null)

        const visibleRoutes = filterRoutes(sector.routes)
        const visibleSubs = (sector.subsectors ?? [])
          .map(sub => ({ sub, routes: filterRoutes(sub.routes) }))
          .filter(x => x.routes.length > 0)

        // Nasconde interamente il settore se il filtro non lascia vie
        if (showStatus && filter !== 'all' && visibleRoutes.length === 0 && visibleSubs.length === 0) {
          return null
        }

        return (
          <div key={sector.id} className="sector-block">
            <div className="sector-header">
              <div>
                <span className="sector-name">{sector.name}</span>
                {(sector.orientation || sector.approach_notes) && (
                  <div style={{ fontSize: 11, color: 'var(--text-muted)', marginTop: 2 }}>
                    {[sector.orientation, sector.approach_notes].filter(Boolean).join(' · ')}
                  </div>
                )}
              </div>
              <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-end', gap: 2 }}>
                <span className="sector-badge">{sector.routes.length} vie</span>
                {gradeRange && (
                  <span style={{ fontSize: 11, color: 'var(--text-muted)' }}>{gradeRange}</span>
                )}
              </div>
            </div>

            {visibleRoutes.length === 0 ? (
              <div className="empty-state" style={{ padding: '20px' }}>Nessuna via.</div>
            ) : (
              <table className="route-table">
                <thead>
                  <tr>
                    <th>#</th>
                    <th>Via</th>
                    <th>Grado</th>
                    <th>Lunghezza</th>
                    <th>Spit</th>
                    {showStatus && <th>Stato</th>}
                  </tr>
                </thead>
                <tbody>
                  <RouteRows
                    routes={visibleRoutes}
                    statuses={statuses}
                    showStatus={showStatus}
                    onOpen={id => navigate(`/routes/${id}`)}
                  />
                </tbody>
              </table>
            )}

            {visibleSubs.length > 0 && (
              <div style={{ padding: '0 16px 16px' }}>
                {visibleSubs.map(({ sub, routes }) => (
                  <div key={sub.id} style={{ marginTop: 12 }}>
                    <div style={{ fontSize: 13, fontWeight: 700, color: 'var(--text-2)', padding: '8px 6px 4px' }}>
                      {sub.name}
                      <span style={{ fontSize: 11, fontWeight: 400, color: 'var(--text-muted)', marginLeft: 8 }}>
                        {sub.routes.length} vie
                      </span>
                    </div>
                    <table className="route-table">
                      <tbody>
                        <RouteRows
                          routes={routes}
                          statuses={statuses}
                          showStatus={showStatus}
                          onOpen={id => navigate(`/routes/${id}`)}
                        />
                      </tbody>
                    </table>
                  </div>
                ))}
              </div>
            )}
          </div>
        )
      })}
    </div>
  )
}
