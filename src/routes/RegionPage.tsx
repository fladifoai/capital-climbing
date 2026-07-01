import { useMemo, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { useRegion, useCragsForRegion, type CragSummary } from '../features/catalog/hooks'
import '../styles/catalog.css'

interface AreaGroup {
  key: string
  area: { id: string; name: string } | null
  crags: CragSummary[]
}

export default function RegionPage() {
  const { regionId = '' } = useParams()
  const { data: region, isLoading: loadingRegion } = useRegion(regionId)
  const { data: crags, isLoading: loadingCrags, error } = useCragsForRegion(regionId)
  const [openAreas, setOpenAreas] = useState<Set<string>>(new Set())

  const areaGroups = useMemo((): AreaGroup[] => {
    if (!crags) return []
    const map = new Map<string, AreaGroup>()
    crags.forEach(c => {
      const key = c.area?.id ?? '__none__'
      if (!map.has(key)) map.set(key, { key, area: c.area ?? null, crags: [] })
      map.get(key)!.crags.push(c)
    })
    return [...map.values()].sort((a, b) => {
      if (!a.area) return 1
      if (!b.area) return -1
      return a.area.name.localeCompare(b.area.name, 'it')
    })
  }, [crags])

  const toggleArea = (key: string) =>
    setOpenAreas(prev => {
      const next = new Set(prev)
      next.has(key) ? next.delete(key) : next.add(key)
      return next
    })

  if (loadingRegion) return <div className="loading-state">Caricamento…</div>
  if (!region) return <div className="error-state">Regione non trovata.</div>

  return (
    <div className="catalog-page">
      <nav className="breadcrumb">
        <Link to="/explore">Falesie</Link>
        {region.country && (
          <>
            <span className="breadcrumb-sep">›</span>
            <Link to={`/countries/${region.country.id}`}>{region.country.name}</Link>
          </>
        )}
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

      {areaGroups.map(group => {
        // Aree a tendina (chiuse di default, come i settori). Se c'è un solo
        // gruppo o è quello senza area, mostra aperto direttamente.
        const isOpen = openAreas.has(group.key) || areaGroups.length === 1 || !group.area
        const label = group.area?.name ?? 'Altre falesie'
        const count = group.crags.length
        return (
          <div key={group.key} style={{ marginBottom: 12 }}>
            {group.area ? (
              <button
                type="button"
                onClick={() => toggleArea(group.key)}
                aria-expanded={isOpen}
                style={{
                  width: '100%',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'space-between',
                  gap: 10,
                  padding: '12px 14px',
                  background: 'var(--surface-card, #181E27)',
                  border: '1px solid var(--border, rgba(255,255,255,0.08))',
                  borderRadius: 10,
                  cursor: 'pointer',
                  color: 'var(--text-on-dark, #F7F3EA)',
                  textAlign: 'left',
                }}
              >
                <span style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                  <span style={{
                    fontSize: 12,
                    transition: 'transform 0.15s',
                    transform: isOpen ? 'rotate(90deg)' : 'none',
                    color: 'var(--accent, #C85F3A)',
                  }}>▶</span>
                  <span style={{ fontWeight: 700, fontSize: 15 }}>{label}</span>
                </span>
                <span style={{
                  fontSize: 12,
                  fontWeight: 600,
                  color: 'var(--text-on-dark-muted)',
                }}>
                  {count} {count === 1 ? 'falesia' : 'falesie'}
                </span>
              </button>
            ) : null}

            {isOpen && (
              <div className="crag-list" style={{ marginTop: group.area ? 8 : 0 }}>
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
            )}
          </div>
        )
      })}
    </div>
  )
}
