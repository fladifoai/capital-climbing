import { Link } from 'react-router-dom'
import { useRegionsWithCounts, useItalyStats, ITALY_ID } from '../features/catalog/hooks'
import '../styles/catalog.css'

export default function ExplorePage() {
  const { data: regions, isLoading, error } = useRegionsWithCounts(ITALY_ID)
  const { data: stats } = useItalyStats()

  return (
    <div className="catalog-page">
      <div className="catalog-header">
        <h1 className="catalog-title">Falesie</h1>
        <p className="catalog-subtitle">Italia · tutte le regioni</p>
      </div>

      {stats && (
        <div className="stat-bar">
          <div className="stat-item">
            <span className="stat-number">{stats.crags}</span>
            <span className="stat-label">Falesie</span>
          </div>
          <div className="stat-item">
            <span className="stat-number">{stats.sectors}</span>
            <span className="stat-label">Settori</span>
          </div>
          <div className="stat-item">
            <span className="stat-number">{stats.routes}</span>
            <span className="stat-label">Vie</span>
          </div>
        </div>
      )}

      {isLoading && <div className="loading-state">Caricamento regioni…</div>}
      {error && <div className="error-state">Errore nel caricamento.</div>}

      {regions && (
        <div className="region-grid">
          {regions.map(r => (
            <Link key={r.id} to={`/regions/${r.id}`} className="region-card">
              <div className="region-card-name">{r.name}</div>
              <div className="region-card-counts">
                <div><span>{r.crag_count}</span> {r.crag_count === 1 ? 'falesia' : 'falesie'}</div>
                {r.sector_count > 0 && <div><span>{r.sector_count}</span> settori · <span>{r.route_count}</span> vie</div>}
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}
