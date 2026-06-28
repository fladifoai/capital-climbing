import { useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'
import { useMyAscents, useCreateAscent, useDeleteAscent, type AscentFormValues, type AscentWithRoute } from '../features/logbook/hooks'
import AscentForm from '../features/logbook/AscentForm'
import '../styles/admin.css'
import '../styles/catalog.css'
import '../styles/logbook.css'

const ATTEMPT_LABELS: Record<string, string> = {
  onsight: 'OS', flash: 'FL', redpoint: 'RP', second: 'RP', third: 'RP', four_plus: 'RP',
  repeat: 'Rip', unknown: '?',
}
const ATTEMPT_COLORS: Record<string, string> = {
  onsight: '#28B487', flash: '#4C9BE8', redpoint: '#D9902F', second: '#D9902F', third: '#D9902F', four_plus: '#D9902F',
  repeat: '#A78BFA', unknown: '#8E887E',
}

type SortKey = 'date_desc' | 'date_asc' | 'grade_desc' | 'grade_asc' | 'quality_desc'
type StatusFilter = 'completed' | 'attempted' | 'all'
type ViewMode = 'grade' | 'list'

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

const ATTEMPT_FULL: Record<string, string> = {
  onsight: 'On-sight', flash: 'Flash', redpoint: 'Redpoint',
  second: '2° giro', third: '3° giro', four_plus: '4° giro o oltre',
}

interface AscentRowProps {
  a: AscentWithRoute
  onDelete: (id: string, name: string) => void
  isPending: boolean
}
function AscentRow({ a, onDelete, isPending }: AscentRowProps) {
  const [open, setOpen] = useState(false)
  const grade = a.grade_at_ascent ?? a.route?.official_grade
  const type = a.ascent_style ?? a.attempt_type

  return (
    <div className={`ascent-card-row${open ? ' expanded' : ''}`}>
      <div className="ascent-row-header" onClick={() => setOpen(o => !o)} style={{ cursor: 'pointer' }}>
        <div className="ascent-row-main">
          <span className="ascent-row-name">
            {a.route?.name ?? '—'}
          </span>
          <div className="ascent-row-sub">
            <Link
              to={`/crags/${a.route?.sector?.crag?.id}`}
              style={{ color: 'inherit', textDecoration: 'none' }}
              onClick={e => e.stopPropagation()}
            >
              {a.route?.sector?.crag?.name}
            </Link>
            {a.route?.sector?.name ? ` › ${a.route.sector.name}` : ''}
          </div>
        </div>
        <div className="ascent-row-meta">
          {grade && <span className="grade-badge">{grade}</span>}
          {type && (
            <span style={{ fontSize: 11, fontWeight: 700, color: ATTEMPT_COLORS[type] ?? 'var(--accent)' }}>
              {ATTEMPT_LABELS[type] ?? type}
            </span>
          )}
          {a.status === 'attempted' && !type && (
            <span style={{ fontSize: 11, color: 'var(--text-muted)' }}>Tentativo</span>
          )}
          <Stars n={a.quality ?? null} />
          <span className="ascent-row-date">{a.date}</span>
          <span style={{ fontSize: 11, color: 'var(--text-muted)' }}>{open ? '▲' : '▼'}</span>
          <button
            className="btn-secondary"
            style={{ fontSize: 11, padding: '2px 7px', color: '#FFB0A5' }}
            onClick={e => { e.stopPropagation(); onDelete(a.id, a.route?.name ?? '') }}
            disabled={isPending}
          >×</button>
        </div>
      </div>

      {open && (
        <div className="ascent-detail-panel">
          <div className="ascent-detail-grid">
            <div className="ascent-detail-item">
              <span className="ascent-detail-label">Via</span>
              <Link to={`/routes/${a.route?.id}`} style={{ color: 'var(--accent)', fontWeight: 600, textDecoration: 'none' }}>
                {a.route?.name}
              </Link>
            </div>
            <div className="ascent-detail-item">
              <span className="ascent-detail-label">Data</span>
              <span>{a.date}</span>
            </div>
            <div className="ascent-detail-item">
              <span className="ascent-detail-label">Tipo</span>
              <span>{type ? ATTEMPT_FULL[type] : a.status === 'attempted' ? 'Tentativo' : '—'}</span>
            </div>
            <div className="ascent-detail-item">
              <span className="ascent-detail-label">Grado salita</span>
              <span>{a.grade_at_ascent ?? '—'}</span>
            </div>
            {a.personal_grade && (
              <div className="ascent-detail-item">
                <span className="ascent-detail-label">Grado personale</span>
                <span>{a.personal_grade}</span>
              </div>
            )}
            <div className="ascent-detail-item">
              <span className="ascent-detail-label">Bellezza</span>
              <span>{a.quality ? <Stars n={a.quality} /> : '—'}</span>
            </div>
            {a.effort != null && (
              <div className="ascent-detail-item">
                <span className="ascent-detail-label">Sforzo</span>
                <span>{a.effort}/10</span>
              </div>
            )}
            {a.kneepad_used != null && (
              <div className="ascent-detail-item">
                <span className="ascent-detail-label">Ginocchiera</span>
                <span>{a.kneepad_used ? 'Sì' : 'No'}</span>
              </div>
            )}
            <div className="ascent-detail-item">
              <span className="ascent-detail-label">Visibilità</span>
              <span>{a.visibility === 'public' ? 'Pubblica' : 'Privata'}</span>
            </div>
          </div>
          {a.notes && (
            <div className="ascent-detail-notes">
              <span className="ascent-detail-label">Note</span>
              <p>{a.notes}</p>
            </div>
          )}
        </div>
      )}
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

  const [search, setSearch] = useState('')
  const [yearFilter, setYearFilter] = useState<string>('all')
  const [typeFilter, setTypeFilter] = useState<string>('all')
  const [statusFilter, setStatusFilter] = useState<StatusFilter>('completed')
  const [sort, setSort] = useState<SortKey>('grade_desc')
  const [view, setView] = useState<ViewMode>('grade')

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

  const availableYears = useMemo(() => {
    const years = new Set<string>()
    ;(ascents ?? []).forEach(a => years.add(a.date.slice(0, 4)))
    return Array.from(years).sort((a, b) => b.localeCompare(a))
  }, [ascents])

  const filtered = useMemo(() => {
    let list = ascents ?? []
    if (statusFilter !== 'all') list = list.filter(a => a.status === statusFilter)
    if (yearFilter !== 'all') list = list.filter(a => a.date.startsWith(yearFilter))
    if (typeFilter !== 'all') list = list.filter(a => (a.ascent_style ?? a.attempt_type) === typeFilter)
    if (search.trim().length >= 2) {
      const q = search.toLowerCase()
      list = list.filter(a =>
        a.route?.name?.toLowerCase().includes(q) ||
        a.route?.sector?.crag?.name?.toLowerCase().includes(q)
      )
    }
    return sortAscents(list, sort)
  }, [ascents, statusFilter, yearFilter, typeFilter, search, sort])

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
      .map(([grade, { numeric, items }]) => {
        const os = items.filter(a => (a.ascent_style ?? a.attempt_type) === 'onsight').length
        const fl = items.filter(a => (a.ascent_style ?? a.attempt_type) === 'flash').length
        const rp = items.filter(a => ['redpoint','second','third','four_plus'].includes(a.ascent_style ?? a.attempt_type ?? '')).length
        return { grade, numeric, items, os, fl, rp }
      })
  }, [filtered])

  const isEmpty = !isLoading && (ascents?.length ?? 0) === 0
  const noResults = !isLoading && (ascents?.length ?? 0) > 0 && filtered.length === 0

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
          <option value="repeat">Ripetizione</option>
        </select>
      </div>

      {/* Sort bar + view toggle */}
      <div className="logbook-sort-bar">
        <div style={{ display: 'flex', gap: 6, alignItems: 'center', flexWrap: 'wrap' }}>
          <span style={{ fontSize: 11, color: 'var(--text-on-dark-muted)', fontWeight: 600 }}>Ordina:</span>
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
                background: sort === key ? '#C85F3A' : 'transparent',
                color: sort === key ? '#FFF7EA' : 'var(--text-muted)',
                borderColor: sort === key ? '#C85F3A' : 'rgba(247,243,234,0.14)',
              }}
            >
              {label}
            </button>
          ))}
        </div>

        <div style={{ display: 'flex', gap: 4, background: 'rgba(247,243,234,0.08)', borderRadius: 999, padding: 3, marginLeft: 'auto' }}>
          {([['grade', '▤ Per grado'], ['list', '≡ Lista']] as [ViewMode, string][]).map(([v, label]) => (
            <button
              key={v}
              onClick={() => setView(v)}
              style={{
                padding: '3px 11px', borderRadius: 999, border: 'none', cursor: 'pointer',
                fontSize: 11, fontWeight: 700, fontFamily: 'inherit',
                background: view === v ? 'rgba(255,247,234,0.18)' : 'transparent',
                color: view === v ? '#FFF7EA' : 'var(--text-on-dark-muted)',
              }}
            >
              {label}
            </button>
          ))}
        </div>

        <span style={{ fontSize: 12, color: 'var(--text-on-dark-muted)' }}>
          {filtered.length} {filtered.length === 1 ? 'ascensione' : 'ascensioni'}
        </span>
      </div>

      {isLoading && <div className="loading-state">Caricamento…</div>}
      {error && <div className="error-state">Errore nel caricamento.</div>}

      {/* Empty state (no ascents at all) */}
      {isEmpty && !adding && (
        <div style={{
          background: 'rgba(255,247,234,0.05)',
          border: '2px dashed rgba(255,247,234,0.14)',
          borderRadius: 20,
          padding: '56px 32px',
          textAlign: 'center',
          marginTop: 8,
        }}>
          <div style={{ fontSize: 40, marginBottom: 16 }}>🧗</div>
          <h2 style={{ color: 'var(--text-on-dark)', fontFamily: '"Sora","Inter",system-ui,sans-serif', fontWeight: 800, fontSize: 20, margin: '0 0 8px' }}>
            Nessuna ascensione registrata
          </h2>
          <p style={{ color: 'var(--text-on-dark-muted)', fontSize: 14, lineHeight: 1.6, margin: '0 0 24px', maxWidth: 380, marginLeft: 'auto', marginRight: 'auto' }}>
            Registra la tua prima ascensione o esplora il catalogo falesie per trovare le vie che hai scalato.
          </p>
          <div style={{ display: 'flex', gap: 10, justifyContent: 'center', flexWrap: 'wrap' }}>
            <button className="btn-primary" onClick={() => { setAdding(true); setActionError('') }}>
              + Prima ascensione
            </button>
            <Link to="/explore" className="btn-secondary" style={{ textDecoration: 'none' }}>
              Esplora falesie
            </Link>
          </div>
        </div>
      )}

      {/* No results from filters */}
      {noResults && (
        <div style={{ textAlign: 'center', padding: '40px 0', color: 'var(--text-on-dark-muted)', fontSize: 14 }}>
          Nessuna ascensione con i filtri selezionati.
        </div>
      )}

      {/* Grade view */}
      {!isLoading && view === 'grade' && gradeGroups.map(g => (
        <div key={g.grade} className="grade-group">
          <div className="grade-group-header">
            <span className="grade-badge" style={{ fontSize: 14, padding: '4px 12px' }}>{g.grade}</span>
            <span style={{ fontSize: 13, color: 'var(--text-on-dark)', fontWeight: 600 }}>
              {g.items.length} {g.items.length === 1 ? 'via' : 'vie'}
            </span>
            <span style={{ fontSize: 12, color: 'var(--text-on-dark-muted)', display: 'flex', gap: 8 }}>
              {g.os > 0 && <span style={{ color: '#28B487', fontWeight: 700 }}>{g.os} OS</span>}
              {g.fl > 0 && <span style={{ color: '#4C9BE8', fontWeight: 700 }}>{g.fl} FL</span>}
              {g.rp > 0 && <span style={{ color: '#D9902F', fontWeight: 700 }}>{g.rp} RP</span>}
            </span>
          </div>
          {g.items.map(a => (
            <AscentRow key={a.id} a={a} onDelete={handleDelete} isPending={deleteAscent.isPending} />
          ))}
        </div>
      ))}

      {/* List view */}
      {!isLoading && view === 'list' && filtered.map(a => (
        <AscentRow key={a.id} a={a} onDelete={handleDelete} isPending={deleteAscent.isPending} />
      ))}
    </div>
  )
}
