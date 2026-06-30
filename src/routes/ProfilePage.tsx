import { useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import {
  ResponsiveContainer, BarChart, Bar, XAxis, YAxis,
  CartesianGrid, Tooltip, Cell, Legend, LineChart, Line,
} from 'recharts'
import { useAuth } from '../features/auth/AuthContext'
import { useOwnProfile } from '../features/users/hooks'
import { useMyAscents, useCreateAscent, useDeleteAscent, type AscentFormValues, type AscentWithRoute } from '../features/logbook/hooks'
import { buildGroups, sortGroups, isRepeatAscent, type RouteGroup } from '../features/logbook/groupAscents'
import { useMyProjects } from '../features/projects/hooks'
import { useMySessions } from '../features/sessions/hooks'
import AscentForm from '../features/logbook/AscentForm'
import {
  computeKpis,
  computeGradePyramid,
  computeGradeProgressionLine,
  computeAscentModeBreakdown,
  filterAscents,
} from '../analytics/metrics/ascents'
import { ASCENT_STYLE_COLORS, ASCENT_STYLE_LABELS } from '../analytics/calculations/ascent-style'
import { numToGrade } from '../analytics/normalizers/grades'
import { DEFAULT_FILTERS } from '../analytics/types'
import '../styles/admin.css'
import '../styles/catalog.css'
import '../styles/logbook.css'
import '../styles/analytics.css'

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

// Riga timeline: singola ascensione/ripetizione di una via, con elimina.
function HistoryItem({ a, onDelete, isPending }: { a: AscentWithRoute; onDelete: (id: string, name: string) => void; isPending: boolean }) {
  const repeat = isRepeatAscent(a)
  const type = repeat ? 'repeat' : (a.ascent_style ?? a.attempt_type ?? '')
  const label = a.status !== 'completed' ? 'Tentativo' : (ATTEMPT_FULL[type] ?? type)
  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 10, flexWrap: 'wrap',
      padding: '8px 12px', borderTop: '1px solid rgba(247,243,234,0.08)', fontSize: 13,
    }}>
      <span style={{ color: 'var(--text-muted)', minWidth: 88 }}>{a.date}</span>
      <span style={{ fontWeight: 700, color: ATTEMPT_COLORS[type] ?? 'var(--text-muted)' }}>{label}</span>
      {repeat && (
        <span style={{ fontSize: 10, fontWeight: 700, color: '#A78BFA', border: '1px solid rgba(167,139,250,0.4)', borderRadius: 8, padding: '1px 6px' }}>
          Nessun punteggio
        </span>
      )}
      {a.grade_at_ascent && <span className="grade-badge">{a.grade_at_ascent}</span>}
      <Stars n={a.quality ?? null} />
      {a.notes && <span style={{ color: 'var(--text-muted)', flex: 1, minWidth: 120 }}>{a.notes}</span>}
      <button
        className="btn-secondary"
        style={{ marginLeft: 'auto', fontSize: 11, padding: '2px 7px', color: '#FFB0A5' }}
        onClick={() => onDelete(a.id, a.route?.name ?? '')}
        disabled={isPending}
      >×</button>
    </div>
  )
}

// Card di una via: UNA riga nel logbook, espandibile sulla timeline.
function RouteGroupRow({ g, onDelete, isPending }: { g: RouteGroup; onDelete: (id: string, name: string) => void; isPending: boolean }) {
  const [open, setOpen] = useState(false)
  const bs = g.bestStyle
  return (
    <div className={`ascent-card-row${open ? ' expanded' : ''}`}>
      <div className="ascent-row-header" onClick={() => setOpen(o => !o)} style={{ cursor: 'pointer' }}>
        <div className="ascent-row-main">
          <span className="ascent-row-name">
            <Link to={`/routes/${g.routeId}`} style={{ color: 'inherit', textDecoration: 'none' }} onClick={e => e.stopPropagation()}>
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
          {!g.hasSend && <span style={{ fontSize: 11, color: 'var(--text-muted)' }}>Tentativo</span>}
          {g.repeatCount > 0 && (
            <span style={{ fontSize: 11, fontWeight: 700, color: '#A78BFA' }} title="Ripetizioni">↻ {g.repeatCount}</span>
          )}
          <span style={{ fontSize: 11, color: 'var(--text-muted)' }} title="Sessioni">{g.sessionCount} sess.</span>
          <Stars n={g.quality} />
          <span className="ascent-row-date">{g.lastActivity}</span>
          <span style={{ fontSize: 11, color: 'var(--text-muted)' }}>{open ? '▲' : '▼'}</span>
        </div>
      </div>

      {open && (
        <div className="ascent-detail-panel" style={{ padding: '4px 0 8px' }}>
          <div style={{ display: 'flex', gap: 16, flexWrap: 'wrap', padding: '8px 16px', fontSize: 12, color: 'var(--text-muted)' }}>
            {g.firstSendDate && <span>Prima salita: <strong style={{ color: 'var(--text)' }}>{g.firstSendDate}</strong></span>}
            <span>Ripetizioni: <strong style={{ color: 'var(--text)' }}>{g.repeatCount}</strong></span>
            <span>Sessioni: <strong style={{ color: 'var(--text)' }}>{g.sessionCount}</strong></span>
            <Link to={`/routes/${g.routeId}`} style={{ marginLeft: 'auto', color: 'var(--accent)', textDecoration: 'none', fontWeight: 600 }}>
              Apri dettaglio via →
            </Link>
          </div>
          {g.items.map(a => (
            <HistoryItem key={a.id} a={a} onDelete={onDelete} isPending={isPending} />
          ))}
        </div>
      )}
    </div>
  )
}

function KpiCard({ value, label }: { value: string | number; label: string }) {
  return (
    <div className="kpi-card">
      <div className="kpi-value">{value}</div>
      <div className="kpi-label">{label}</div>
    </div>
  )
}

export default function ProfilePage() {
  const { user } = useAuth()
  const { data: profile, isLoading: profileLoading } = useOwnProfile(user?.id ?? '')
  const { data: ascents, isLoading: ascentsLoading, error: ascentsError } = useMyAscents(user?.id ?? '')
  const { data: projects } = useMyProjects(user?.id ?? '')
  const { data: sessions } = useMySessions(user?.id ?? '')
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

  // ── KPI + charts (solo vie completate, tutti gli anni) ─────────────────────
  const completedAscents = useMemo(
    () => filterAscents(ascents ?? [], DEFAULT_FILTERS),
    [ascents]
  )

  const kpis = useMemo(
    () => computeKpis(ascents ?? [], projects ?? [], sessions ?? [], DEFAULT_FILTERS),
    [ascents, projects, sessions]
  )

  const maxGradeLabel = useMemo(() => {
    // Grado massimo: solo salite valide, le ripetizioni non contano.
    const sends = completedAscents.filter(a => !isRepeatAscent(a))
    const grades = sends.map(a => a.grade_numeric_at_ascent ?? 0).filter(n => n > 0)
    if (!grades.length) return '—'
    const mx = Math.max(...grades)
    return sends.find(a => (a.grade_numeric_at_ascent ?? 0) === mx)?.grade_at_ascent ?? numToGrade(mx)
  }, [completedAscents])

  const pyramidData = useMemo(() => computeGradePyramid(completedAscents), [completedAscents])
  const progressionData = useMemo(() => computeGradeProgressionLine(completedAscents, 'all'), [completedAscents])
  const modeBreakdown = useMemo(() => computeAscentModeBreakdown(completedAscents), [completedAscents])

  // ── Lista vie (filtrable) ──────────────────────────────────────────────────
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
    if (statusFilter === 'completed') g = g.filter(x => x.hasSend)
    else if (statusFilter === 'attempted') g = g.filter(x => !x.hasSend)
    if (typeFilter === 'repeat') g = g.filter(x => x.repeatCount > 0)
    else if (typeFilter === 'redpoint') g = g.filter(x => ['redpoint', 'second', 'third', 'four_plus'].includes(x.bestStyle ?? ''))
    else if (typeFilter !== 'all') g = g.filter(x => x.bestStyle === typeFilter)
    return sortGroups(g, sort)
  }, [ascents, statusFilter, yearFilter, typeFilter, search, sort])

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
        const rp = items.filter(g => ['redpoint','second','third','four_plus'].includes(g.bestStyle ?? '')).length
        return { grade, numeric, items, os, fl, rp }
      })
  }, [groups])

  const isEmpty = !ascentsLoading && (ascents?.length ?? 0) === 0
  const noResults = !ascentsLoading && (ascents?.length ?? 0) > 0 && groups.length === 0

  if (!user) return null

  const displayName = profile?.display_name ?? (user.user_metadata?.display_name as string | undefined) ?? ''
  const username = (user.user_metadata?.username as string | undefined) ?? user.email ?? ''

  const isLoading = profileLoading || ascentsLoading

  return (
    <div className="logbook-page">

      {/* ── Header profilo ── */}
      <div style={{
        background: 'rgba(255,247,234,0.04)',
        border: '1px solid rgba(255,247,234,0.10)',
        borderRadius: 18,
        padding: '28px 32px',
        marginBottom: 28,
        display: 'flex',
        gap: 24,
        alignItems: 'flex-start',
        flexWrap: 'wrap',
      }}>
        <div style={{
          width: 72, height: 72, borderRadius: '50%',
          background: 'rgba(200,95,58,0.18)',
          border: '2px solid rgba(200,95,58,0.40)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          fontSize: 28, flexShrink: 0,
        }}>
          🧗
        </div>
        <div style={{ flex: 1, minWidth: 200 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, flexWrap: 'wrap', marginBottom: 4 }}>
            <h1 style={{ margin: 0, fontSize: 22, fontWeight: 800, color: 'var(--text-on-dark)', fontFamily: '"Sora","Inter",system-ui,sans-serif' }}>
              {displayName || username}
            </h1>
            {displayName && (
              <span style={{ fontSize: 13, color: 'var(--text-on-dark-muted)' }}>@{username}</span>
            )}
          </div>
          {profile?.bio && (
            <p style={{ margin: '0 0 8px', fontSize: 13, color: 'var(--text-on-dark-muted)', lineHeight: 1.5 }}>{profile.bio}</p>
          )}
          <div style={{ display: 'flex', gap: 16, flexWrap: 'wrap', fontSize: 12, color: 'var(--text-on-dark-muted)' }}>
            {profile?.city && <span>📍 {profile.city}</span>}
            {profile?.climbing_since && <span>🗓 Dal {profile.climbing_since}</span>}
            {profile?.preferred_style && <span>🏔 {profile.preferred_style}</span>}
          </div>
        </div>
        <div style={{ display: 'flex', gap: 8, flexShrink: 0, flexWrap: 'wrap' }}>
          <Link to="/logbook/import" className="btn-secondary" style={{ textDecoration: 'none', fontSize: 12, padding: '6px 14px' }}>
            📒 Importa logbook
          </Link>
          <Link to="/settings" className="btn-secondary" style={{ textDecoration: 'none', fontSize: 12, padding: '6px 14px' }}>
            Modifica profilo
          </Link>
        </div>
      </div>

      {/* ── KPI principali ── */}
      {!isLoading && (
        <div className="kpi-grid" style={{ marginBottom: 28 }}>
          <KpiCard value={kpis.uniqueRoutes} label="Vie scalate" />
          <KpiCard value={maxGradeLabel} label="Grado massimo" />
          <KpiCard value={kpis.bestOnsightLabel} label="Max On-sight" />
          <KpiCard value={kpis.bestFlashLabel} label="Max Flash" />
          <KpiCard value={kpis.bestRedpointLabel} label="Max Redpoint" />
          <KpiCard value={kpis.totalCrags} label="Falesie visitate" />
          <KpiCard value={kpis.activeProjects} label="Progetti attivi" />
        </div>
      )}

      {/* ── 3 Grafici essenziali ── */}
      {!isLoading && completedAscents.length > 0 && (
        <>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: 16, marginBottom: 16 }}>

            <div className="chart-section">
              <h2>Piramide dei gradi</h2>
              {pyramidData.length === 0 ? (
                <div className="chart-empty">Nessun dato con grado registrato.</div>
              ) : (
                <ResponsiveContainer width="100%" height={Math.max(140, Math.min(pyramidData.length, 8) * 24)}>
                  <BarChart data={pyramidData.slice(0, 8)} layout="vertical" margin={{ top: 4, right: 8, left: 36, bottom: 4 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="rgba(247,243,234,0.10)" horizontal={false} />
                    <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                    <YAxis type="category" dataKey="grade" tick={{ fontSize: 10 }} width={36} />
                    <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8, background: '#181E27', border: '1px solid rgba(247,243,234,0.14)', color: '#F7F3EA' }} />
                    <Bar dataKey="onsight"  name="OS"  stackId="a" fill="#28B487" />
                    <Bar dataKey="flash"    name="FL"  stackId="a" fill="#4C9BE8" />
                    <Bar dataKey="redpoint" name="RP"  stackId="a" fill="#D9902F" />
                    <Bar dataKey="repeat"   name="Rip" stackId="a" fill="#A78BFA" />
                    <Bar dataKey="unknown"  name="?"   stackId="a" fill="#8E887E" radius={[0, 3, 3, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              )}
            </div>

            <div className="chart-section">
              <h2>Progressione nel tempo</h2>
              {progressionData.length < 2 ? (
                <div className="chart-empty">Servono dati su almeno 2 anni.</div>
              ) : (
                <ResponsiveContainer width="100%" height={Math.max(140, Math.min(pyramidData.length, 8) * 24)}>
                  <LineChart data={progressionData} margin={{ top: 4, right: 16, left: -10, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="rgba(247,243,234,0.10)" />
                    <XAxis dataKey="label" tick={{ fontSize: 10 }} />
                    <YAxis allowDecimals={false} tick={{ fontSize: 10 }} tickFormatter={(n: number) => numToGrade(n)} domain={['auto', 'auto']} />
                    <Tooltip
                      contentStyle={{ fontSize: 11, borderRadius: 8, background: '#181E27', border: '1px solid rgba(247,243,234,0.14)', color: '#F7F3EA' }}
                      formatter={(value, name) => [numToGrade(Math.round(Number(value))), name === 'best' ? 'Massimo' : 'Media']}
                    />
                    <Legend formatter={(v: string) => v === 'best' ? 'Massimo' : 'Media'} wrapperStyle={{ fontSize: 11 }} />
                    <Line type="monotone" dataKey="best" stroke="#E27A4F" strokeWidth={2} dot={{ r: 3 }} name="best" />
                    <Line type="monotone" dataKey="avg"  stroke="#4C9BE8" strokeWidth={2} dot={{ r: 3 }} strokeDasharray="4 2" name="avg" />
                  </LineChart>
                </ResponsiveContainer>
              )}
            </div>

            <div className="chart-section">
              <h2>Modalità di salita</h2>
              {modeBreakdown.length === 0 ? (
                <div className="chart-empty">Nessun dato.</div>
              ) : (
                <ResponsiveContainer width="100%" height={Math.max(140, modeBreakdown.length * 36)}>
                  <BarChart
                    data={modeBreakdown.map(e => ({ count: e.count, label: ASCENT_STYLE_LABELS[e.ascentStyle] }))}
                    layout="vertical" margin={{ top: 4, right: 16, left: 80, bottom: 0 }}
                  >
                    <CartesianGrid strokeDasharray="3 3" stroke="rgba(247,243,234,0.10)" horizontal={false} />
                    <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                    <YAxis type="category" dataKey="label" tick={{ fontSize: 10 }} width={80} />
                    <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8, background: '#181E27', border: '1px solid rgba(247,243,234,0.14)', color: '#F7F3EA' }} formatter={(v) => [v, 'Salite']} />
                    <Bar dataKey="count" radius={[0, 3, 3, 0]}>
                      {modeBreakdown.map(entry => (
                        <Cell key={entry.ascentStyle} fill={ASCENT_STYLE_COLORS[entry.ascentStyle]} />
                      ))}
                    </Bar>
                  </BarChart>
                </ResponsiveContainer>
              )}
            </div>

          </div>

          <div style={{ textAlign: 'center', marginBottom: 32 }}>
            <Link to="/analytics" className="btn-primary" style={{ textDecoration: 'none', fontSize: 13, padding: '10px 24px' }}>
              Vedi tutte le analisi →
            </Link>
          </div>
        </>
      )}

      {/* ── Vie scalate ── */}
      <div className="logbook-header">
        <h2 style={{ margin: 0, fontSize: 16, fontWeight: 700, color: 'var(--text-on-dark)' }}>Vie scalate</h2>
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

      {ascentsLoading && <div className="loading-state">Caricamento…</div>}
      {ascentsError && <div className="error-state">Errore nel caricamento.</div>}

      {isEmpty && !adding && (
        <div style={{
          background: 'rgba(255,247,234,0.05)',
          border: '2px dashed rgba(255,247,234,0.14)',
          borderRadius: 20, padding: '56px 32px', textAlign: 'center', marginTop: 8,
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

      {noResults && (
        <div style={{ textAlign: 'center', padding: '40px 0', color: 'var(--text-on-dark-muted)', fontSize: 14 }}>
          Nessuna via con i filtri selezionati.
        </div>
      )}

      {!ascentsLoading && view === 'grade' && gradeGroups.map(gg => (
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
            <RouteGroupRow key={g.routeId} g={g} onDelete={handleDelete} isPending={deleteAscent.isPending} />
          ))}
        </div>
      ))}

      {!ascentsLoading && view === 'list' && groups.map(g => (
        <RouteGroupRow key={g.routeId} g={g} onDelete={handleDelete} isPending={deleteAscent.isPending} />
      ))}
    </div>
  )
}
