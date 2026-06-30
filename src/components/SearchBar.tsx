import { useState, useRef, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { useCragSearch } from '../features/sessions/hooks'
import { useRouteSearch } from '../features/logbook/hooks'
import './SearchBar.css'

// Barra cerca globale: trova falesie e vie, naviga alla pagina relativa.
export default function SearchBar() {
  const navigate = useNavigate()
  const [query, setQuery] = useState('')
  const [open, setOpen] = useState(false)
  const wrapRef = useRef<HTMLDivElement>(null)

  const { data: crags, isFetching: cragsFetching } = useCragSearch(query)
  const { data: routes, isFetching: routesFetching } = useRouteSearch(query)

  useEffect(() => {
    function onClick(e: MouseEvent) {
      if (wrapRef.current && !wrapRef.current.contains(e.target as Node)) setOpen(false)
    }
    document.addEventListener('mousedown', onClick)
    return () => document.removeEventListener('mousedown', onClick)
  }, [])

  function go(path: string) {
    setOpen(false)
    setQuery('')
    navigate(path)
  }

  function goToAllResults() {
    if (query.trim().length < 2) return
    const q = query.trim()
    setOpen(false)
    setQuery('')
    navigate(`/cerca?q=${encodeURIComponent(q)}`)
  }

  const hasQuery = query.trim().length >= 2
  const cragList = crags ?? []
  const routeList = routes ?? []
  const empty = hasQuery && !cragsFetching && !routesFetching && cragList.length === 0 && routeList.length === 0

  return (
    <div className="search-bar" ref={wrapRef}>
      <input
        className="search-bar-input"
        type="search"
        value={query}
        onChange={e => { setQuery(e.target.value); setOpen(true) }}
        onFocus={() => hasQuery && setOpen(true)}
        onKeyDown={e => { if (e.key === 'Enter') goToAllResults() }}
        placeholder="Cerca vie e falesie…"
        autoComplete="off"
      />
      {open && hasQuery && (
        <div className="search-bar-dropdown">
          {(cragsFetching || routesFetching) && cragList.length === 0 && routeList.length === 0 && (
            <div className="search-bar-hint">Ricerca…</div>
          )}
          {cragList.length > 0 && (
            <>
              <div className="search-bar-group">Falesie</div>
              {cragList.map(c => (
                <button key={`c-${c.id}`} type="button" className="search-bar-item" onClick={() => go(`/crags/${c.id}`)}>
                  <span className="search-bar-item-icon">🪨</span>
                  <span className="search-bar-item-main">
                    <span className="search-bar-item-name">{c.name}</span>
                    {(c.region || c.province) && (
                      <span className="search-bar-item-sub">{[c.region, c.province].filter(Boolean).join(' · ')}</span>
                    )}
                  </span>
                </button>
              ))}
            </>
          )}
          {routeList.length > 0 && (
            <>
              <div className="search-bar-group">Vie</div>
              {routeList.map(r => (
                <button key={`r-${r.id}`} type="button" className="search-bar-item" onClick={() => go(`/routes/${r.id}`)}>
                  <span className="search-bar-item-icon">🧗</span>
                  <span className="search-bar-item-main">
                    <span className="search-bar-item-name">{r.name}</span>
                    <span className="search-bar-item-sub">{r.crag_name}{r.sector_name ? ` › ${r.sector_name}` : ''}</span>
                  </span>
                  {r.official_grade && <span className="grade-badge">{r.official_grade}</span>}
                </button>
              ))}
            </>
          )}
          {empty && <div className="search-bar-hint">Nessun risultato.</div>}
          {(cragList.length > 0 || routeList.length > 0) && (
            <button type="button" className="search-bar-all" onClick={goToAllResults}>
              Vedi tutti i risultati →
            </button>
          )}
        </div>
      )}
    </div>
  )
}
