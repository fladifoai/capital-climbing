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

      {sectors && sectors.map(sector => (
        <div key={sector.id} className="sector-block">
          <div className="sector-header">
            <span className="sector-name">{sector.name}</span>
            <span className="sector-badge">{sector.routes.length} vie</span>
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
        </div>
      ))}
    </div>
  )
}
