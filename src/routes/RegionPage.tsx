import { useMemo } from 'react'
import { Link, useParams } from 'react-router-dom'
import { useRegion, useCragsForRegion, type CragSummary } from '../features/catalog/hooks'
import '../styles/catalog.css'

interface AreaGroup {
  area: { id: string; name: string } | null
  crags: CragSummary[]
}

export default function RegionPage() {
  const { regionId = '' } = useParams()
  const { data: region, isLoading: loadingRegion } = useRegion(regionId)
  const { data: crags, isLoading: loadingCrags, error } = useCragsForRegion(regionId)

  const areaGroups = useMemo((): AreaGroup[] => {
    if (!crags) return []
    const map = new Map<string, AreaGroup>()
    crags.forEach(c => {
      const key = c.area?.id ?? '__none__'
      if (!map.has(key)) map.set(key, { area: c.area ?? null, crags: [] })
      map.get(key)!.crags.push(c)
    })
    return [...map.values()].sort((a, b) => {
      if (!a.area) return 1
      if (!b.area) return -1
      return a.area.name.localeCompare(b.area.name, 'it')
    })
  }, [crags])

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

      {areaGroups.map(group => (
        <div key={group.area?.id ?? '__none__'} style={{ marginBottom: 28 }}>
          {group.area && (
            <div style={{
              fontSize: 12,
              fontWeight: 700,
              letterSpacing: '0.08em',
              textTransform: 'uppercase',
              color: 'var(--text-on-dark-muted)',
              marginBottom: 10,
              paddingLeft: 4,
            }}>
              {group.area.name}
            </div>
          )}
          <div className="crag-list">
            {group.crags.map(c => (
              <Link key={c.id} to={`/crags/${c.id}`} className="crag-card">
                <div className="crag-card-left">
                  <div className="crag-card-name">{c.name}</div>
                  <div className="crag-card-meta">
                    {[c.municipality].filter(Boolean).join(' · ')}
                    {c.rock_type ? ` · ${c.rock_type}` : ''}
                    {c.approach_minutes ? ` · ${c.approach_minutes} min` : ''}
                  </div>
                </div>
                <div className="crag-card-right">
                  <span className={`access-badge ${c.access_status}`}>
                    {c.access_status === 'open' ? 'Aperto' :
                     c.access_status === 'limited' ? 'Limitato' : 'Chiuso'}
                  </span>
                </div>
              </Link>
            ))}
          </div>
        </div>
      ))}
    </div>
  )
}
