import { useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'
import { useMyAscents, useCreateAscent, useDeleteAscent, type AscentFormValues, type AscentWithRoute } from '../features/logbook/hooks'
import AscentForm from '../features/logbook/AscentForm'
import '../styles/admin.css'
import '../styles/catalog.css'
import '../styles/logbook.css'

const ATTEMPT_LABELS: Record<string, string> = {
  onsight: 'OS', flash: 'FL', redpoint: 'RP', second: '2G', third: '3G', four_plus: '4+',
}
const ATTEMPT_COLORS: Record<string, string> = {
  onsight: '#1a6e2c', flash: '#c47800', redpoint: '#c0392b', second: '#2d5a27', third: '#4a8a42', four_plus: '#4a8a42',
}

type SortKey = 'date_desc' | 'date_asc' | 'grade_desc' | 'grade_asc' | 'quality_desc'
type StatusFilter = 'completed' | 'attempted' | 'all'

function Stars({ n }: { n: number | null }) {
  if (!n) return null
  return (
    <span style={{ color: '#f5a623', fontSize: 12, letterSpacing: -1 }}>
      {'★'.repeat(n)}{'☆'.repeat(5 - n)}
    </span>
  )
}

function sortAscents(list: AscentWithRoute[], sort: SortKey): AscentWithRoute[] {
  return [...list].sort((a, b) => {
    switch (sort) {
      case 'date_desc': return b.date.localeCompare(a.date)
      case 'date_asc':  return a.date.localeCompare(b.date)
      case 'grade_desc': return (b.grade_numeric_at_ascent ?? b.route?.grade_numeric ?? 0) - (a.grade_numeric_at_ascent ?? a.route?.grade_numeric ?? 0)
      case 'grade_asc':  return (a.grade_numeric_at_ascent ?? a.route?.grade_numeric ?? 0) - (b.grade_numeric_at_ascent ?? b.route?.grade_numeric ?? 0)
      case 'quality_desc': {
        const qa = a.quality ?? 0, qb = b.quality ?? 0
        return qb !== qa ? qb - qa : b.date.localeCompare(a.date)
      }
    }
  })
}

interface AscentRowProps {
  a: AscentWithRoute
  onDelete: (id: string, name: string) => void
  isPending: boolean
}
function AscentRow({ a, onDelete, isPending }: AscentRowProps) {
  const grade = a.grade_at_ascent ?? a.route?.official_grade
  const type = a.attempt_type
  return (
    <div className="ascent-card-row">
      <div className="ascent-row-main">
        <Link to={`/routes/${a.route?.id}`} className="ascent-row-name">
          {a.route?.name ?? '—'}
        </Link>
        <div className="ascent-row-sub">
          <Link to={`/crags/${a.route?.sector?.crag?.id}`} style={{ color: 'inherit', textDecoration: 'none' }}>
            {a.route?.sector?.crag?.name}
          </Link>
          {a.route?.sector?.name ? ` › ${a.route.sector.name}` : ''}
        </div>
      </div>
      <div className="ascent-row-meta">
        {grade && <span className="grade-badge">{grade}</span>}
        {type && (
          <span style={{ fontSize: 11, fontWeight: 700, color: ATTEMPT_COLORS[type] ?? '#2d5a27' }}>
            {ATTEMPT_LABELS[type] ?? type}
          </span>
        )}
        {a.status === 'attempted' && !type && (
          <span style={{ fontSize: 11, color: '#8a9a87' }}>Tentativo</span>
        )}
        <Stars n={a.quality ?? null} />
        <span className="ascent-row-date">{a.date}</span>
        <button
          className="btn-secondary"
          style={{ fontSize: 11, padding: '2px 7px', color: '#c0392b' }}
          onClick={() => onDelete(a.id, a.route?.name ?? '')}
          disabled={isPending}
        >×</button>
      </div>
    </div>
  )
}

export default function MyRoutesPage() {
  const { user } = useAuth()
  const { data: ascents, isLoading, error } = useMyAscents(user?.id ?? '')
  const createAscent = useCreateAscent()
  const deleteAscent = useDeleteAscent()

  const [adding, setAdding] = useState(false)
  const [actionError, setActionError] = useState('')

  // Filters + sort + view
  const [search, setSearch] = useState('')
  const [yearFilter, setYearFilter] = useState<string>('all')
  const [typeFilter, setTypeFilter] = useState<string>('all')
  const [statusFilter, setStatusFilter] = useState<StatusFilter>('completed')
  const [sort, setSort] = useState<SortKey>('date_desc')
  const [grouped, setGrouped] = useState(false)

  async function handleCreate(values: AscentFormValues) {
    if (!user) return
    setActionError('')
    try {
      await createAscent.mutateAsync({ userId: user.id, values })
      setAdding(false)
    } catch (e) {
      setActionError((e as Error).message)
    }
  }

  async function handleDelete(id: string, name: string) {
    if (!user) return
    if (!confirm(`Eliminare l'ascensione su "${name}"?`)) return
    try {
      await deleteAscent.mutateAsync({ id, userId: user.id })
    } catch (e) {
      setActionError((e as Error).message)
    }
  }

  // Available years from data
  const availableYears = useMemo(() => {
    const years = new Set<string>()
    ;(ascents ?? []).forEach(a => years.add(a.date.slice(0, 4)))
    return Array.from(years).sort((a, b) => b.localeCompare(a))
  }, [ascents])

  // Filtered + sorted list
  const filtered = useMemo(() => {
    let list = ascents ?? []
    if (statusFilter !== 'all') list = list.filter(a => a.status === statusFilter)
    if (yearFilter !== 'all') list = list.filter(a => a.date.startsWith(yearFilter))
    if (typeFilter !== 'all') list = list.filter(a => a.attempt_type === typeFilter)
    if (search.trim().length >= 2) {
      const q = search.toLowerCase()
      list = list.filter(a =>
        a.route?.name?.toLowerCase().includes(q) ||
        a.route?.sector?.crag?.name?.toLowerCase().includes(q)
      )
    }
    return sortAscents(list, sort)
  }, [ascents, statusFilter, yearFilter, typeFilter, search, sort])

  // Grade groups (sorted highest first)
  const gradeGroups = useMemo(() => {
    const map = new Map<string, { numeric: number; items: AscentWithRoute[] }>()
    filtered.forEach(a => {
      const g = a.grade_at_ascent ?? a.route?.official_grade ?? '?'
      const n = a.grade_numeric_at_ascent ?? a.route?.grade_numeric ?? 0
      const existing = map.get(g)
      if (existing) existing.items.push(a)
      else map.set(g, { numeric: n, items: [a] })
    })
    return Array.from(map.entries())
      .sort(([, a], [, b]) => b.numeric - a.numeric)
      .map(([grade, { numeric, items }]) => ({ grade, numeric, items }))
  }, [filtered])

  return (
    <div className="logbook-page">
      <div className="logbook-header">
        <h1 className="logbook-title">Le mie vie</h1>
        {!adding && (
          <button className="btn-primary" onClick={() => { setAdding(true); setActionError('') }}>
            + Nuova ascensione
          </button>
        )}
      </div>

      {adding && (
        <AscentForm
          onSubmit={handleCreate}
          onCancel={() => { setAdding(false); setActionError('') }}
          isLoading={createAscent.isPending}
        />
      )}

      {actionError && <div className="admin-error">{actionError}</div>}

      {/* Filter bar */}
      <div className="logbook-filters">
        <input
          className="logbook-search"
          placeholder="Cerca via o falesia…"
          value={search}
          onChange={e => setSearch(e.target.value)}
        />

        <select className="logbook-select" value={yearFilter} onChange={e => setYearFilter(e.target.value)}>
          <option value="all">Tutti gli anni</option>
          {availableYears.map(y => <option key={y} value={y}>{y}</option>)}
        </select>

        <select className="logbook-select" value={statusFilter} onChange={e => setStatusFilter(e.target.value as StatusFilter)}>
          <option value="completed">Solo salite</option>
          <option value="attempted">Solo tentativi</option>
          <option value="all">Tutto</option>
        </select>

        <select className="logbook-select" value={typeFilter} onChange={e => setTypeFilter(e.target.value)}>
          <option value="all">Tutti i tipi</option>
          <option value="onsight">On-sight</option>
          <option value="flash">Flash</option>
          <option value="redpoint">Redpoint</option>
          <option value="second">2° giro</option>
          <option value="third">3° giro</option>
          <option value="four_plus">4+</option>
        </select>
      </div>

      {/* Sort + group controls */}
      <div className="logbook-sort-bar">
        <div style={{ display: 'flex', gap: 6, alignItems: 'center' }}>
          <span style={{ fontSize: 11, color: '#8a9a87', fontWeight: 600 }}>Ordina:</span>
          {([
            ['date_desc', 'Data ↓'],
            ['date_asc', 'Data ↑'],
            ['grade_desc', 'Grado ↓'],
            ['grade_asc', 'Grado ↑'],
            ['quality_desc', '★ Bellezza'],
          ] as [SortKey, string][]).map(([key, label]) => (
            <button
              key={key}
              onClick={() => setSort(key)}
              style={{
                padding: '3px 9px', fontSize: 11, borderRadius: 12, border: '1px solid',
                cursor: 'pointer', fontFamily: 'inherit', fontWeight: 600,
                background: sort === key ? '#2d5a27' : 'transparent',
                color: sort === key ? '#fff' : '#6a7a68',
                borderColor: sort === key ? '#2d5a27' : '#d0d8cc',
              }}
            >
              {label}
            </button>
          ))}
        </div>
        <label style={{ display: 'flex', alignItems: 'center', gap: 6, fontSize: 12, cursor: 'pointer', color: '#4a5a48' }}>
          <input type="checkbox" checked={grouped} onChange={e => setGrouped(e.target.checked)} />
          Raggruppa per grado
        </label>
        <span style={{ fontSize: 12, color: '#8a9a87', marginLeft: 'auto' }}>
          {filtered.length} {filtered.length === 1 ? 'ascensione' : 'ascensioni'}
        </span>
      </div>

      {isLoading && <div className="loading-state">Caricamento…</div>}
      {error && <div className="error-state">Errore nel caricamento.</div>}

      {!isLoading && filtered.length === 0 && (
        <div className="empty-state">Nessuna ascensione con i filtri selezionati.</div>
      )}

      {/* GROUPED VIEW */}
      {grouped && gradeGroups.map(g => (
        <div key={g.grade} className="grade-group">
          <div className="grade-group-header">
            <span className="grade-badge" style={{ fontSize: 14 }}>{g.grade}</span>
            <span style={{ fontSize: 12, color: '#8a9a87' }}>{g.items.length} {g.items.length === 1 ? 'salita' : 'salite'}</span>
          </div>
          {g.items.map(a => (
            <AscentRow key={a.id} a={a} onDelete={handleDelete} isPending={deleteAscent.isPending} />
          ))}
        </div>
      ))}

      {/* FLAT VIEW */}
      {!grouped && filtered.map(a => (
        <AscentRow key={a.id} a={a} onDelete={handleDelete} isPending={deleteAscent.isPending} />
      ))}
    </div>
  )
}
