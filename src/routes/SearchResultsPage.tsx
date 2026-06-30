import { useEffect, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { useCragSearch } from '../features/sessions/hooks'
import { useRouteSearch } from '../features/logbook/hooks'
import '../styles/catalog.css'

const PAGE = 30

export default function SearchResultsPage() {
  const [params, setParams] = useSearchParams()
  const initialQ = params.get('q') ?? ''
  const [query, setQuery] = useState(initialQ)
  const [cragLimit, setCragLimit] = useState(PAGE)
  const [routeLimit, setRouteLimit] = useState(PAGE)

  const trimmed = query.trim()
  const hasQuery = trimmed.length >= 2

  // Sincronizza la query nell'URL (condivisibile) e azzera la paginazione
  useEffect(() => {
    const id = setTimeout(() => {
      setParams(trimmed ? { q: trimmed } : {}, { replace: true })
      setCragLimit(PAGE)
      setRouteLimit(PAGE)
    }, 250)
    return () => clearTimeout(id)
  }, [trimmed, setParams])

  const { data: crags, isFetching: cragsFetching } = useCragSearch(trimmed, cragLimit)
  const { data: routes, isFetching: routesFetching } = useRouteSearch(trimmed, routeLimit)

  const cragList = crags ?? []
  const routeList = routes ?? []
  const empty = hasQuery && !cragsFetching && !routesFetching && cragList.length === 0 && routeList.length === 0

  return (
    <div className="catalog-page">
      <div className="catalog-header">
        <div>
          <h1 className="catalog-title">Cerca</h1>
          <p className="catalog-subtitle">Trova falesie e vie nel catalogo.</p>
        </div>
        <Link to="/explore" style={{
          display: 'inline-flex', alignItems: 'center', gap: 6, height: 36, padding: '0 14px',
          borderRadius: 999, border: '1px solid rgba(255,247,234,0.20)', background: 'rgba(255,247,234,0.05)',
          color: 'var(--text-muted)', fontSize: 13, fontWeight: 600, textDecoration: 'none', flexShrink: 0,
        }}>← Catalogo</Link>
      </div>

      <div className="explore-toolbar">
        <input
          className="explore-search"
          type="search"
          autoFocus
          placeholder="Cerca vie e falesie…"
          value={query}
          onChange={e => setQuery(e.target.value)}
        />
      </div>

      {!hasQuery && (
        <div className="empty-state">Scrivi almeno 2 caratteri per cercare.</div>
      )}

      {hasQuery && (
        <>
          {/* Falesie */}
          {cragList.length > 0 && (
            <>
              <h2 className="explore-results-heading">Falesie ({cragList.length})</h2>
              <div className="explore-results-list">
                {cragList.map(c => (
                  <Link key={c.id} to={`/crags/${c.id}`} className="explore-result-row">
                    <span className="explore-result-icon">🪨</span>
                    <span className="explore-result-main">
                      <span className="explore-result-name">{c.name}</span>
                      {(c.region || c.province) && (
                        <span className="explore-result-sub">
                          {[c.region, c.province].filter(Boolean).join(' · ')}
                        </span>
                      )}
                    </span>
                  </Link>
                ))}
              </div>
              {cragList.length >= cragLimit && (
                <button className="btn-secondary" style={{ marginBottom: 16 }}
                  onClick={() => setCragLimit(l => l + PAGE)} disabled={cragsFetching}>
                  {cragsFetching ? 'Caricamento…' : 'Carica altre falesie'}
                </button>
              )}
            </>
          )}

          {/* Vie */}
          {routeList.length > 0 && (
            <>
              <h2 className="explore-results-heading">Vie ({routeList.length})</h2>
              <div className="explore-results-list">
                {routeList.map(r => (
                  <Link key={r.id} to={`/routes/${r.id}`} className="explore-result-row">
                    <span className="explore-result-icon">🧗</span>
                    <span className="explore-result-main">
                      <span className="explore-result-name">{r.name}</span>
                      <span className="explore-result-sub">
                        {r.crag_name}{r.sector_name ? ` › ${r.sector_name}` : ''}
                      </span>
                    </span>
                    {r.official_grade && <span className="grade-badge">{r.official_grade}</span>}
                  </Link>
                ))}
              </div>
              {routeList.length >= routeLimit && (
                <button className="btn-secondary" style={{ marginBottom: 16 }}
                  onClick={() => setRouteLimit(l => l + PAGE)} disabled={routesFetching}>
                  {routesFetching ? 'Caricamento…' : 'Carica altre vie'}
                </button>
              )}
            </>
          )}

          {(cragsFetching || routesFetching) && cragList.length === 0 && routeList.length === 0 && (
            <div className="loading-state">Ricerca…</div>
          )}
          {empty && <div className="empty-state">Nessun risultato per “{trimmed}”.</div>}
        </>
      )}
    </div>
  )
}
