import { Link, useParams, useNavigate } from 'react-router-dom'
import { useCrag, useSectorsWithRoutes } from '../features/catalog/hooks'
import '../styles/catalog.css'

export default function CragDetailPage() {
  const { cragId = '' } = useParams()
  const navigate = useNavigate()
  const { data: crag, isLoading: loadingCrag, error: cragError } = useCrag(cragId)
  const { data: sectors, isLoading: loadingSectors } = useSectorsWithRoutes(cragId)

  if (loadingCrag) return <div className="loading-state">Caricamento falesia…</div>
  if (cragError || !crag) return <div className="error-state">Falesia non trovata.</div>

  const totalRoutes = sectors?.reduce((sum, s) => sum + s.routes.length, 0) ?? 0

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
        </div>
      </div>

      {loadingSectors && <div className="loading-state">Caricamento settori…</div>}

      {sectors && sectors.length === 0 && (
        <div className="empty-state">Nessun settore ancora inserito.</div>
      )}

      {sectors && sectors.map(sector => {
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

            {sector.routes.length === 0 ? (
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
                  </tr>
                </thead>
                <tbody>
                  {sector.routes.map((route, i) => (
                    <tr
                      key={route.id}
                      onClick={() => navigate(`/routes/${route.id}`)}
                    >
                      <td style={{ color: '#8a9a87' }}>{route.line_order ?? i + 1}</td>
                      <td><strong>{route.name}</strong></td>
                      <td>
                        {route.official_grade
                          ? <span className="grade-badge">{route.official_grade}</span>
                          : <span style={{ color: '#ccc' }}>—</span>}
                      </td>
                      <td>{route.length_m ? `${route.length_m} m` : '—'}</td>
                      <td>{route.bolts ?? '—'}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            )}

            {sector.subsectors && sector.subsectors.length > 0 && (
              <div style={{ padding: '0 16px 16px' }}>
                {sector.subsectors.map(sub => (
                  <div key={sub.id} style={{ marginTop: 12 }}>
                    <div style={{ fontSize: 13, fontWeight: 700, color: 'var(--text-2)', padding: '8px 6px 4px' }}>
                      {sub.name}
                      <span style={{ fontSize: 11, fontWeight: 400, color: 'var(--text-muted)', marginLeft: 8 }}>
                        {sub.routes.length} vie
                      </span>
                    </div>
                    {sub.routes.length > 0 && (
                      <table className="route-table">
                        <tbody>
                          {sub.routes.map((route, i) => (
                            <tr key={route.id} onClick={() => navigate(`/routes/${route.id}`)}>
                              <td style={{ color: '#8a9a87' }}>{route.line_order ?? i + 1}</td>
                              <td><strong>{route.name}</strong></td>
                              <td>
                                {route.official_grade
                                  ? <span className="grade-badge">{route.official_grade}</span>
                                  : <span style={{ color: '#ccc' }}>—</span>}
                              </td>
                              <td>{route.length_m ? `${route.length_m} m` : '—'}</td>
                              <td>{route.bolts ?? '—'}</td>
                            </tr>
                          ))}
                        </tbody>
                      </table>
                    )}
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
