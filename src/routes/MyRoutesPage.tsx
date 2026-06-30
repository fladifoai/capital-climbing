import { useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'
import { useMyAscents, useCreateAscent, useDeleteAscent, useUpdateAscent, type AscentFormValues, type AscentUpdateValues, type AscentWithRoute } from '../features/logbook/hooks'
import AscentForm from '../features/logbook/AscentForm'
import AscentEditForm from '../features/logbook/AscentEditForm'
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
const ATTEMPT_FULL: Record<string, string> = {
  onsight: 'On-sight', flash: 'Flash', redpoint: 'Redpoint',
  second: '2° giro', third: '3° giro', four_plus: '4° giro o oltre', repeat: 'Ripetizione',
}
// Ordine di "bontà" stile per scegliere il miglior stile di una via (0 = migliore).
const STYLE_RANK: Record<string, number> = {
  onsight: 0, flash: 1, redpoint: 2, second: 2, third: 2, four_plus: 2, unknown: 4,
}

type SortKey = 'date_desc' | 'date_asc' | 'grade_desc' | 'grade_asc' | 'quality_desc'
type StatusFilter = 'completed' | 'attempted' | 'all'
type ViewMode = 'grade' | 'list'

// ── Una via raggruppata: tutte le ascensioni dell'utente su quella via ──────
interface RouteGroup {
  routeId: string
  route: AscentWithRoute['route'] | null
  items: AscentWithRoute[]      // ordinate per data desc
  displayGrade: string
  gradeNumeric: number
  bestStyle: string | null      // miglior stile tra le SALITE (no ripetizioni)
  firstSendDate: string | null
  lastActivity: string
  repeatCount: number
  sessionCount: number
  quality: number | null
  hasSend: boolean
}

function styleKey(a: AscentWithRoute): string {
  return (a.ascent_style ?? a.attempt_type ?? 'unknown')
}
function isRepeatAscent(a: AscentWithRoute): boolean {
  return a.is_repeat === true || styleKey(a) === 'repeat'
}

function buildGroups(ascents: AscentWithRoute[]): RouteGroup[] {
  const byRoute = new Map<string, AscentWithRoute[]>()
  for (const a of ascents) {
    const arr = byRoute.get(a.route_id)
    if (arr) arr.push(a)
    else byRoute.set(a.route_id, [a])
  }
  const groups: RouteGroup[] = []
  byRoute.forEach((items, routeId) => {
    const sorted = [...items].sort((a, b) => b.date.localeCompare(a.date))
    const sends = sorted.filter(a => !isRepeatAscent(a) && a.status === 'completed')
    // Miglior salita: rank stile più basso, a parità grado più alto, poi data più vecchia.
    const best = [...sends].sort((a, b) => {
      const ra = STYLE_RANK[styleKey(a)] ?? 4
      const rb = STYLE_RANK[styleKey(b)] ?? 4
      if (ra !== rb) return ra - rb
      const ga = a.grade_numeric_at_ascent ?? a.route?.grade_numeric ?? 0
      const gb = b.grade_numeric_at_ascent ?? b.route?.grade_numeric ?? 0
      if (gb !== ga) return gb - ga
      return a.date.localeCompare(b.date)
    })[0] ?? null
    const repeatCount = sorted.filter(isRepeatAscent).length
    const sessionKeys = new Set(sorted.map(a => a.session_id ?? `d:${a.date}`))
    const ref = best ?? sorted[0]
    groups.push({
      routeId,
      route: ref?.route ?? null,
      items: sorted,
      displayGrade: ref?.grade_at_ascent ?? ref?.route?.official_grade ?? '?',
      gradeNumeric: ref?.grade_numeric_at_ascent ?? ref?.route?.grade_numeric ?? 0,
      bestStyle: best ? styleKey(best) : null,
      firstSendDate: sends.length ? sends.map(a => a.date).sort()[0] : null,
      lastActivity: sorted[0]?.date ?? '',
      repeatCount,
      sessionCount: sessionKeys.size,
      quality: best?.quality ?? sorted.find(a => a.quality != null)?.quality ?? null,
      hasSend: sends.length > 0,
    })
  })
  return groups
}

function Stars({ n }: { n: number | null }) {
  if (!n) return null
  return (
    <span style={{ color: '#f5a623', fontSize: 12, letterSpacing: -1 }}>
      {'★'.repeat(n)}{'☆'.repeat(5 - n)}
    </span>
  )
}

function sortGroups(list: RouteGroup[], sort: SortKey): RouteGroup[] {
  return [...list].sort((a, b) => {
    switch (sort) {
      case 'date_desc': return b.lastActivity.localeCompare(a.lastActivity)
      case 'date_asc':  return a.lastActivity.localeCompare(b.lastActivity)
      case 'grade_desc': return b.gradeNumeric - a.gradeNumeric
      case 'grade_asc':  return a.gradeNumeric - b.gradeNumeric
      case 'quality_desc': {
        const qa = a.quality ?? 0, qb = b.quality ?? 0
        return qb !== qa ? qb - qa : b.lastActivity.localeCompare(a.lastActivity)
      }
    }
  })
}

// ── Una riga della timeline (singola ascensione/ripetizione) con edit/elimina ─
interface HistoryItemProps {
  a: AscentWithRoute
  onDelete: (id: string, name: string) => void
  isPending: boolean
  editing: boolean
  onStartEdit: (id: string) => void
  onCancelEdit: () => void
  onSaveEdit: (values: AscentUpdateValues) => void
  savingEdit: boolean
}
function HistoryItem({ a, onDelete, isPending, editing, onStartEdit, onCancelEdit, onSaveEdit, savingEdit }: HistoryItemProps) {
  if (editing) {
    return (
      <div style={{ padding: '10px 12px', borderTop: '1px solid rgba(247,243,234,0.08)' }}>
        <AscentEditForm
          ascent={{
            id: a.id,
            date: a.date,
            ascent_style: a.ascent_style,
            attempt_count: a.attempt_count,
            grade_at_ascent: a.grade_at_ascent,
            is_repeat: a.is_repeat,
            personal_grade: a.personal_grade,
            quality: a.quality,
            effort: a.effort,
            kneepad_used: a.kneepad_used,
            notes: a.notes,
            visibility: a.visibility,
            route: a.route ? { id: a.route.id, name: a.route.name, official_grade: a.route.official_grade } : null,
          }}
          onSubmit={onSaveEdit}
          onCancel={onCancelEdit}
          isLoading={savingEdit}
        />
      </div>
    )
  }

  const repeat = isRepeatAscent(a)
  const type = repeat ? 'repeat' : styleKey(a)
  const label = a.status !== 'completed' ? 'Tentativo' : (ATTEMPT_FULL[type] ?? type)

  return (
    <div className="history-timeline-row" style={{
      display: 'flex', alignItems: 'center', gap: 10, flexWrap: 'wrap',
      padding: '8px 12px', borderTop: '1px solid rgba(247,243,234,0.08)', fontSize: 13,
    }}>
      <span style={{ color: 'var(--text-muted)', minWidth: 88 }}>{a.date}</span>
      <span style={{ fontWeight: 700, color: ATTEMPT_COLORS[type] ?? 'var(--text-muted)' }}>{label}</span>
      {repeat && (
        <span style={{
          fontSize: 10, fontWeight: 700, color: '#A78BFA',
          border: '1px solid rgba(167,139,250,0.4)', borderRadius: 8, padding: '1px 6px',
        }}>Nessun punteggio</span>
      )}
      {a.grade_at_ascent && <span className="grade-badge">{a.grade_at_ascent}</span>}
      <Stars n={a.quality ?? null} />
      {a.notes && <span style={{ color: 'var(--text-muted)', flex: 1, minWidth: 120 }}>{a.notes}</span>}
      <span style={{ marginLeft: 'auto', display: 'flex', gap: 6 }}>
        <button
          className="btn-secondary" style={{ fontSize: 11, padding: '2px 7px' }}
          onClick={() => onStartEdit(a.id)} title="Modifica"
        >✎</button>
        <button
          className="btn-secondary" style={{ fontSize: 11, padding: '2px 7px', color: '#FFB0A5' }}
          onClick={() => onDelete(a.id, a.route?.name ?? '')} disabled={isPending}
        >×</button>
      </span>
    </div>
  )
}

// ── La card di una via (riga unica del logbook) ──────────────────────────────
interface RouteGroupRowProps {
  g: RouteGroup
  onDelete: (id: string, name: string) => void
  deletePending: boolean
  editingId: string | null
  onStartEdit: (id: string) => void
  onCancelEdit: () => void
  onSaveEdit: (ascentId: string, routeId: string | undefined, values: AscentUpdateValues) => void
  savingEdit: boolean
}
function RouteGroupRow({ g, onDelete, deletePending, editingId, onStartEdit, onCancelEdit, onSaveEdit, savingEdit }: RouteGroupRowProps) {
  const [open, setOpen] = useState(false)
  const bs = g.bestStyle

  return (
    <div className={`ascent-card-row${open ? ' expanded' : ''}`}>
      <div className="ascent-row-header" onClick={() => setOpen(o => !o)} style={{ cursor: 'pointer' }}>
        <div className="ascent-row-main">
          <span className="ascent-row-name">
            <Link
              to={`/routes/${g.routeId}`}
              style={{ color: 'inherit', textDecoration: 'none' }}
              onClick={e => e.stopPropagation()}
            >
              {g.route?.name ?? '—'}
            </Link>
          </span>
          <div className="ascent-row-sub">
            <Link
              to={`/crags/${g.route?.sector?.crag?.id}`}
              style={{ color: 'inherit', textDecoration: 'none' }}
              onClick={e => e.stopPropagation()}
            >
              {g.route?.sector?.crag?.name}
            </Link>
            {g.route?.sector?.name ? ` › ${g.route.sector.name}` : ''}
          </div>
        </div>
        <div className="ascent-row-meta">
          {g.displayGrade && g.displayGrade !== '?' && <span className="grade-badge">{g.displayGrade}</span>}
          {bs && (
            <span style={{ fontSize: 11, fontWeight: 700, color: ATTEMPT_COLORS[bs] ?? 'var(--accent)' }}>
              {ATTEMPT_LABELS[bs] ?? bs}
            </span>
          )}
          {!g.hasSend && (
            <span style={{ fontSize: 11, color: 'var(--text-muted)' }}>Tentativo</span>
          )}
          {g.repeatCount > 0 && (
            <span style={{ fontSize: 11, fontWeight: 700, color: '#A78BFA' }} title="Ripetizioni">
              ↻ {g.repeatCount}
            </span>
          )}
          <span style={{ fontSize: 11, color: 'var(--text-muted)' }} title="Sessioni">
            {g.sessionCount} {g.sessionCount === 1 ? 'sess.' : 'sess.'}
          </span>
          <Stars n={g.quality} />
          <span className="ascent-row-date">{g.lastActivity}</span>
          <span style={{ fontSize: 11, color: 'var(--text-muted)' }}>{open ? '▲' : '▼'}</span>
        </div>
      </div>

      {open && (
        <div className="ascent-detail-panel" style={{ padding: '4px 0 8px' }}>
          <div style={{
            display: 'flex', gap: 16, flexWrap: 'wrap', padding: '8px 16px',
            fontSize: 12, color: 'var(--text-muted)',
          }}>
            {g.firstSendDate && <span>Prima salita: <strong style={{ color: 'var(--text)' }}>{g.firstSendDate}</strong></span>}
            <span>Ripetizioni: <strong style={{ color: 'var(--text)' }}>{g.repeatCount}</strong></span>
            <span>Sessioni: <strong style={{ color: 'var(--text)' }}>{g.sessionCount}</strong></span>
            <Link to={`/routes/${g.routeId}`} style={{ marginLeft: 'auto', color: 'var(--accent)', textDecoration: 'none', fontWeight: 600 }}>
              Apri dettaglio via →
            </Link>
          </div>
          {g.items.map(a => (
            <HistoryItem
              key={a.id}
              a={a}
              onDelete={onDelete}
              isPending={deletePending}
              editing={editingId === a.id}
              onStartEdit={onStartEdit}
              onCancelEdit={onCancelEdit}
              onSaveEdit={values => onSaveEdit(a.id, a.route?.id, values)}
              savingEdit={savingEdit}
            />
          ))}
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
  const updateAscent = useUpdateAscent()

  const [adding, setAdding] = useState(false)
  const [editingId, setEditingId] = useState<string | null>(null)
  const [actionError, setActionError] = useState('')
  const [savedOk, setSavedOk] = useState(false)

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
      setSavedOk(true)
    } catch (e) {
      setActionError((e as Error).message || String(e))
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

  async function handleSaveEdit(id: string, routeId: string | undefined, values: AscentUpdateValues) {
    if (!user) return
    setActionError('')
    try {
      await updateAscent.mutateAsync({ id, userId: user.id, values, routeId })
      setEditingId(null)
    } catch (e) {
      setActionError((e as Error).message)
    }
  }

  const availableYears = useMemo(() => {
    const years = new Set<string>()
    ;(ascents ?? []).forEach(a => years.add(a.date.slice(0, 4)))
    return Array.from(years).sort((a, b) => b.localeCompare(a))
  }, [ascents])

  // Filtra le ascensioni, poi raggruppa: UNA riga per via.
  const groups = useMemo(() => {
    let list = ascents ?? []
    if (yearFilter !== 'all') list = list.filter(a => a.date.startsWith(yearFilter))
    if (search.trim().length >= 2) {
      const q = search.toLowerCase()
      list = list.filter(a =>
        a.route?.name?.toLowerCase().includes(q) ||
        a.route?.sector?.crag?.name?.toLowerCase().includes(q)
      )
    }
    let g = buildGroups(list)
    // Stato: completate (con almeno una salita) / solo tentativi / tutto.
    if (statusFilter === 'completed') g = g.filter(x => x.hasSend)
    else if (statusFilter === 'attempted') g = g.filter(x => !x.hasSend)
    // Tipo
    if (typeFilter === 'repeat') g = g.filter(x => x.repeatCount > 0)
    else if (typeFilter === 'redpoint') g = g.filter(x => ['redpoint', 'second', 'third', 'four_plus'].includes(x.bestStyle ?? ''))
    else if (typeFilter !== 'all') g = g.filter(x => x.bestStyle === typeFilter)
    return sortGroups(g, sort)
  }, [ascents, yearFilter, search, statusFilter, typeFilter, sort])

  const gradeGroups = useMemo(() => {
    const map = new Map<string, { numeric: number; items: RouteGroup[] }>()
    groups.forEach(g => {
      const existing = map.get(g.displayGrade)
      if (existing) existing.items.push(g)
      else map.set(g.displayGrade, { numeric: g.gradeNumeric, items: [g] })
    })
    return Array.from(map.entries())
      .sort(([, a], [, b]) => b.numeric - a.numeric)
      .map(([grade, { numeric, items }]) => {
        const os = items.filter(g => g.bestStyle === 'onsight').length
        const fl = items.filter(g => g.bestStyle === 'flash').length
        const rp = items.filter(g => ['redpoint', 'second', 'third', 'four_plus'].includes(g.bestStyle ?? '')).length
        return { grade, numeric, items, os, fl, rp }
      })
  }, [groups])

  const isEmpty = !isLoading && (ascents?.length ?? 0) === 0
  const noResults = !isLoading && (ascents?.length ?? 0) > 0 && groups.length === 0

  return (
    <div className="logbook-page">
      <div className="logbook-header">
        <h1 className="logbook-title">Le mie vie</h1>
        {!adding && (
          <button className="btn-primary" onClick={() => { setAdding(true); setActionError(''); setSavedOk(false) }}>
            + Nuova ascensione
          </button>
        )}
      </div>

      {savedOk && !adding && (
        <div style={{
          display: 'flex', alignItems: 'center', gap: 10,
          padding: '12px 16px', marginBottom: 12,
          background: 'rgba(40,180,135,0.12)', border: '1px solid rgba(40,180,135,0.30)',
          borderRadius: 10, fontSize: 13, color: '#28B487', fontWeight: 600,
        }}>
          <span>✓ Ascensione salvata!</span>
          <button
            className="link-btn"
            style={{ marginLeft: 'auto', fontSize: 12, color: '#28B487', opacity: 0.8 }}
            onClick={() => setSavedOk(false)}
          >✕</button>
        </div>
      )}

      {adding && (
        <>
          {actionError && <div className="admin-error" style={{ marginBottom: 12 }}>{actionError}</div>}
          <AscentForm
            onSubmit={handleCreate}
            onCancel={() => { setAdding(false); setActionError('') }}
            isLoading={createAscent.isPending}
          />
        </>
      )}

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
          <option value="repeat">Con ripetizioni</option>
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
          {groups.length} {groups.length === 1 ? 'via' : 'vie'}
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
          Nessuna via con i filtri selezionati.
        </div>
      )}

      {/* Grade view */}
      {!isLoading && view === 'grade' && gradeGroups.map(gg => (
        <div key={gg.grade} className="grade-group">
          <div className="grade-group-header">
            <span className="grade-badge" style={{ fontSize: 14, padding: '4px 12px' }}>{gg.grade}</span>
            <span style={{ fontSize: 13, color: 'var(--text-on-dark)', fontWeight: 600 }}>
              {gg.items.length} {gg.items.length === 1 ? 'via' : 'vie'}
            </span>
            <span style={{ fontSize: 12, color: 'var(--text-on-dark-muted)', display: 'flex', gap: 8 }}>
              {gg.os > 0 && <span style={{ color: '#28B487', fontWeight: 700 }}>{gg.os} OS</span>}
              {gg.fl > 0 && <span style={{ color: '#4C9BE8', fontWeight: 700 }}>{gg.fl} FL</span>}
              {gg.rp > 0 && <span style={{ color: '#D9902F', fontWeight: 700 }}>{gg.rp} RP</span>}
            </span>
          </div>
          {gg.items.map(g => (
            <RouteGroupRow
              key={g.routeId} g={g}
              onDelete={handleDelete} deletePending={deleteAscent.isPending}
              editingId={editingId}
              onStartEdit={setEditingId}
              onCancelEdit={() => setEditingId(null)}
              onSaveEdit={handleSaveEdit}
              savingEdit={updateAscent.isPending}
            />
          ))}
        </div>
      ))}

      {/* List view */}
      {!isLoading && view === 'list' && groups.map(g => (
        <RouteGroupRow
          key={g.routeId} g={g}
          onDelete={handleDelete} deletePending={deleteAscent.isPending}
          editingId={editingId}
          onStartEdit={setEditingId}
          onCancelEdit={() => setEditingId(null)}
          onSaveEdit={handleSaveEdit}
          savingEdit={updateAscent.isPending}
        />
      ))}
    </div>
  )
}
