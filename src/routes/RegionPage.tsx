import { Link, useParams } from 'react-router-dom'
import { useRegion, useCragsForRegion } from '../features/catalog/hooks'
import '../styles/catalog.css'

export default function RegionPage() {
  const { regionId = '' } = useParams()
  const { data: region, isLoading: loadingRegion } = useRegion(regionId)
  const { data: crags, isLoading: loadingCrags, error } = useCragsForRegion(regionId)

  if (loadingRegion) return <div className="loading-state">Caricamento…</div>
  if (!region) return <div className="error-state">Regione non trovata.</div>

  return (
    <div className="catalog-page">
      <nav className="breadcrumb">
        <Link to="/explore">Falesie</Link>
        <span className="breadcrumb-sep">›</span>
        <span>{region.name}</span>
      </nav>

      <div className="catalog-header">
        <h1 className="catalog-title">{region.name}</h1>
        <p className="catalog-subtitle">
          {crags ? `${crags.length} ${crags.length === 1 ? 'falesia' : 'falesie'}` : ''}
        </p>
      </div>

      {loadingCrags && <div className="loading-state">Caricamento falesie…</div>}
      {error && <div className="error-state">Errore nel caricamento.</div>}

      {crags && crags.length === 0 && (
        <div className="empty-state">Nessuna falesia ancora inserita per questa regione.</div>
      )}

      {crags && crags.length > 0 && (
        <div className="crag-list">
          {crags.map(c => (
            <Link key={c.id} to={`/crags/${c.id}`} className="crag-card">
              <div className="crag-card-left">
                <div className="crag-card-name">{c.name}</div>
                <div className="crag-card-meta">
                  {[c.municipality, c.area?.name].filter(Boolean).join(' · ')}
                  {c.rock_type ? ` · ${c.rock_type}` : ''}
                  {c.approach_minutes ? ` · ${c.approach_minutes} min` : ''}
                </div>
              </div>
              <div className="crag-card-right">
                <div>
                  <span className={`access-badge ${c.access_status}`}>
                    {c.access_status === 'open' ? 'Aperto' :
                     c.access_status === 'limited' ? 'Limitato' : 'Chiuso'}
                  </span>
                </div>
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  )
}
