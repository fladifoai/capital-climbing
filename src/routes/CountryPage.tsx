import { useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { useRegionsWithCounts, useCountry } from '../features/catalog/hooks'
import '../styles/catalog.css'

export default function CountryPage() {
  const { countryId = '' } = useParams()
  const { data: country } = useCountry(countryId)
  const { data: regions, isLoading, error } = useRegionsWithCounts(countryId)
  const [search, setSearch] = useState('')
  const [hideEmpty, setHideEmpty] = useState(false)

  const trimmed = search.trim()

  const filtered = regions
    ? regions.filter(r => {
        if (hideEmpty && r.crag_count === 0) return false
        if (trimmed) return r.name.toLowerCase().includes(trimmed.toLowerCase())
        return true
      })
    : []

  return (
    <div className="catalog-page">
      <nav className="breadcrumb">
        <Link to="/explore">Falesie</Link>
        <span className="breadcrumb-sep">›</span>
        <span>{country?.name ?? '…'}</span>
      </nav>

      <div className="catalog-header">
        <div>
          <h1 className="catalog-title">{country?.name ?? 'Regioni'}</h1>
          <p className="catalog-subtitle">Scegli una regione per vedere le falesie.</p>
        </div>
      </div>

      <div className="explore-toolbar">
        <input
          className="explore-search"
          type="search"
          placeholder="Cerca regione…"
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
