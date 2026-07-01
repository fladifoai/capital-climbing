import { useState } from 'react'
import { Link } from 'react-router-dom'
import { useCountriesWithCounts } from '../features/catalog/hooks'
import { useCragSearch } from '../features/sessions/hooks'
import { useRouteSearch } from '../features/logbook/hooks'
import { useAuth } from '../features/auth/AuthContext'
import '../styles/catalog.css'

// iso2 → emoji bandiera (indicatori regionali unicode)
function flagFor(iso2: string): string {
  if (!iso2 || iso2.length !== 2) return '🏳️'
  const A = 0x1f1e6
  return String.fromCodePoint(
    A + iso2.toUpperCase().charCodeAt(0) - 65,
    A + iso2.toUpperCase().charCodeAt(1) - 65,
  )
}

export default function ExplorePage() {
  const { user } = useAuth()
  const { data: countries, isLoading, error } = useCountriesWithCounts()
  const [search, setSearch] = useState('')

  const trimmed = search.trim()
  const hasSearch = trimmed.length >= 2
  const { data: cragResults, isFetching: cragsFetching } = useCragSearch(trimmed)
  const { data: routeResults, isFetching: routesFetching } = useRouteSearch(trimmed)

  const totals = (countries ?? []).reduce(
    (acc, c) => {
      acc.crags += c.crag_count
      acc.sectors += c.sector_count
      acc.routes += c.route_count
      return acc
    },
    { crags: 0, sectors: 0, routes: 0 },
  )

  return (
    <div className="catalog-page">
      <div className="catalog-header">
        <div>
          <h1 className="catalog-title">Esplora il catalogo</h1>
          <p className="catalog-subtitle">Scegli una nazione, poi la regione e la falesia. Il catalogo è condiviso, i tuoi dati personali restano separati.</p>
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

      {countries && countries.length > 0 && (
        <div className="stat-bar">
          <div className="stat-item">
            <span className="stat-number">{countries.length}</span>
            <span className="stat-label">Nazioni</span>
          </div>
          <div className="stat-item">
            <span className="stat-number">{totals.crags}</span>
            <span className="stat-label">Falesie</span>
          </div>
          <div className="stat-item">
            <span className="stat-number">{totals.sectors}</span>
            <span className="stat-label">Settori</span>
          </div>
          <div className="stat-item">
            <span className="stat-number">{totals.routes}</span>
            <span className="stat-label">Vie</span>
          </div>
        </div>
      )}

      <div className="explore-toolbar">
        <input
          className="explore-search"
          type="search"
          placeholder="Cerca falesia o via…"
          value={search}
          onChange={e => setSearch(e.target.value)}
        />
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

      {isLoading && <div className="loading-state">Caricamento nazioni…</div>}
      {error && <div className="error-state">Errore nel caricamento.</div>}

      {countries && (
        countries.length === 0
          ? <div className="empty-state">Nessuna nazione nel catalogo.</div>
          : (
            <div className="region-grid">
              {countries.map(c => (
                <Link key={c.id} to={`/countries/${c.id}`} className="region-card country-card">
                  <div className="country-card-head">
                    <span className="country-flag">{flagFor(c.iso2)}</span>
                    <span className="region-card-name">{c.name}</span>
                  </div>
                  <div className="region-card-counts">
                    <div><span>{c.region_count}</span> {c.region_count === 1 ? 'regione' : 'regioni'}</div>
                    <div><span>{c.crag_count}</span> {c.crag_count === 1 ? 'falesia' : 'falesie'} · <span>{c.route_count}</span> vie</div>
                  </div>
                </Link>
              ))}
            </div>
          )
      )}
    </div>
  )
}
