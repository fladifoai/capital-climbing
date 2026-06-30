import { useState } from 'react'
import { Link } from 'react-router-dom'
import { useRegionsWithCounts, useItalyStats, ITALY_ID } from '../features/catalog/hooks'
import { useCragSearch } from '../features/sessions/hooks'
import { useRouteSearch } from '../features/logbook/hooks'
import { useAuth } from '../features/auth/AuthContext'
import '../styles/catalog.css'

export default function ExplorePage() {
  const { user } = useAuth()
  const { data: regions, isLoading, error } = useRegionsWithCounts(ITALY_ID)
  const { data: stats } = useItalyStats()
  const [search, setSearch] = useState('')
  const [hideEmpty, setHideEmpty] = useState(false)

  const trimmed = search.trim()
  const hasSearch = trimmed.length >= 2
  const { data: cragResults, isFetching: cragsFetching } = useCragSearch(trimmed)
  const { data: routeResults, isFetching: routesFetching } = useRouteSearch(trimmed)

  const filtered = regions
    ? regions.filter(r => {
        if (hideEmpty && r.crag_count === 0) return false
        if (trimmed) return r.name.toLowerCase().includes(trimmed.toLowerCase())
        return true
      })
    : []

  return (
    <div className="catalog-page">
      <div className="catalog-header">
        <div>
          <h1 className="catalog-title">Esplora il catalogo</h1>
          <p className="catalog-subtitle">Cerca falesie, settori e vie. Il catalogo è condiviso, i tuoi dati personali restano separati.</p>
        </div>
        <Link to={user ? '/dashboard' : '/'} style={{
          display: 'inline-flex', alignItems: 'center', gap: 6,
          height: 36, padding: '0 14px', borderRadius: 999,
          border: '1px solid rgba(255,247,234,0.20)',
          background: 'rgba(255,247,234,0.05)',
          color: 'var(--text-muted)', fontSize: 13, fontWeight: 600,
          textDecoration: 'none',
          flexShrink: 0,
        }}>
          {user ? '← Dashboard' : '← Home'}
        </Link>
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

      <div className="explore-toolbar">
        <input
          className="explore-search"
          type="search"
          placeholder="Cerca regione, falesia o via…"
          value={search}
          onChange={e => setSearch(e.target.value)}
        />
        <label className="explore-filter-toggle">
          <input
            type="checkbox"
            checked={hideEmpty}
            onChange={e => setHideEmpty(e.target.checked)}
          />
          Solo regioni con falesie
        </label>
      </div>

      {/* Risultati falesie + vie quando si cerca */}
      {hasSearch && (
        <div style={{ marginBottom: 24 }}>
          {(cragResults?.length ?? 0) > 0 && (
            <>
              <h2 className="explore-results-heading">Falesie</h2>
              <div className="explore-results-list">
                {cragResults!.map(c => (
                  <Link key={c.id} to={`/crags/${c.id}`} className="explore-result-row">
                    <span className="explore-result-icon">🪨</span>
                    <span className="explore-result-main">
                      <span className="explore-result-name">{c.name}</span>
                      {(c.region || c.province) && (
                        <span className="explore-result-sub">{[c.region, c.province].filter(Boolean).join(' · ')}</span>
                      )}
                    </span>
                  </Link>
                ))}
              </div>
            </>
          )}
          {(routeResults?.length ?? 0) > 0 && (
            <>
              <h2 className="explore-results-heading">Vie</h2>
              <div className="explore-results-list">
                {routeResults!.map(r => (
                  <Link key={r.id} to={`/routes/${r.id}`} className="explore-result-row">
                    <span className="explore-result-icon">🧗</span>
                    <span className="explore-result-main">
                      <span className="explore-result-name">{r.name}</span>
                      <span className="explore-result-sub">{r.crag_name}{r.sector_name ? ` › ${r.sector_name}` : ''}</span>
                    </span>
                    {r.official_grade && <span className="grade-badge">{r.official_grade}</span>}
                  </Link>
                ))}
              </div>
            </>
          )}
          {!cragsFetching && !routesFetching && (cragResults?.length ?? 0) === 0 && (routeResults?.length ?? 0) === 0 && (
            <div className="empty-state">Nessuna falesia o via trovata per “{trimmed}”.</div>
          )}
        </div>
      )}

      {isLoading && <div className="loading-state">Caricamento regioni…</div>}
      {error && <div className="error-state">Errore nel caricamento.</div>}

      {regions && (
        filtered.length === 0
          ? <div className="empty-state">Nessuna regione trovata.</div>
          : (
            <div className="region-grid">
              {filtered.map(r => (
                <Link key={r.id} to={`/regions/${r.id}`} className="region-card">
                  <div className="region-card-name">{r.name}</div>
                  <div className="region-card-counts">
                    <div><span>{r.crag_count}</span> {r.crag_count === 1 ? 'falesia' : 'falesie'}</div>
                    {r.sector_count > 0 && <div><span>{r.sector_count}</span> settori · <span>{r.route_count}</span> vie</div>}
                  </div>
                </Link>
              ))}
            </div>
          )
      )}
    </div>
  )
}
