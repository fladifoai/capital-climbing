import { useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import {
  ResponsiveContainer, BarChart, Bar, XAxis, YAxis,
  CartesianGrid, Tooltip, Cell, Legend, LineChart, Line,
} from 'recharts'
import { useAuth } from '../features/auth/AuthContext'
import { useOwnProfile } from '../features/users/hooks'
import { useMyAscents, useCreateAscent, useDeleteAscent, type AscentFormValues, type AscentWithRoute } from '../features/logbook/hooks'
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
  second: '2° giro', third: '3° giro', four_plus: '4° giro o oltre',
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
          <span className="ascent-row-name">{a.route?.name ?? '—'}</span>
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
    const grades = completedAscents.map(a => a.grade_numeric_at_ascent ?? 0).filter(n => n > 0)
    if (!grades.length) return '—'
    const mx = Math.max(...grades)
    return completedAscents.find(a => (a.grade_numeric_at_ascent ?? 0) === mx)?.grade_at_ascent ?? numToGrade(mx)
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

  const isEmpty = !ascentsLoading && (ascents?.length ?? 0) === 0
  const noResults = !ascentsLoading && (ascents?.length ?? 0) > 0 && filtered.length === 0

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
          {filtered.length} {filtered.length === 1 ? 'ascensione' : 'ascensioni'}
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
          Nessuna ascensione con i filtri selezionati.
        </div>
      )}

      {!ascentsLoading && view === 'grade' && gradeGroups.map(g => (
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

      {!ascentsLoading && view === 'list' && filtered.map(a => (
        <AscentRow key={a.id} a={a} onDelete={handleDelete} isPending={deleteAscent.isPending} />
      ))}
    </div>
  )
}
