import { useMemo, useState } from 'react'
import {
  ResponsiveContainer, BarChart, Bar, XAxis, YAxis,
  CartesianGrid, Tooltip, Cell, Legend,
  ScatterChart, Scatter, ZAxis,
  LineChart, Line,
} from 'recharts'
import { useAuth } from '../features/auth/AuthContext'
import { useMyAscents } from '../features/logbook/hooks'
import { useMyProjects } from '../features/projects/hooks'
import { useMySessions } from '../features/sessions/hooks'
import { useAnalyticsFilters } from '../analytics/filters/useAnalyticsFilters'
import { numToGrade } from '../analytics/normalizers/grades'
import {
  filterAscents,
  computeKpis,
  computeDataQuality,
  computeGradeProgression,
  computeGradeProgressionLine,
  computeGradePyramid,
  computeMonthlyActivity,
  computeTopCrags,
  computeAvailableYears,
  computeAscentModeBreakdown,
  computeAttemptBucketBreakdown,
  computeModeByAttempt,
  computeMaxByStylePerPeriod,
  computeCumulativeMax,
  computeUniqueVsRepeatPerMonth,
  computeDayOfWeekDistribution,
  computeSeasonalDistribution,
  computeGradeDistribution,
  computeUniquePyramid,
  computeMaxByStyleByYear,
  computeTopCragsByUniqueRoutes,
  computeTopCragsByAvgGrade,
  computeSessionsPerMonth,
} from '../analytics/metrics/ascents'
import { ASCENT_STYLE_LABELS, ASCENT_STYLE_COLORS, ASCENT_STYLE_ORDER } from '../analytics/calculations/ascent-style'
import { ATTEMPT_BUCKET_LABELS, type AttemptBucket } from '../analytics/calculations/attempt-buckets'
import type { AscentStyle } from '../analytics/calculations/ascent-style'
import '../styles/analytics.css'

type Tab = 'panoramica' | 'progressione' | 'volume' | 'profilo' | 'falesie' | 'efficienza' | 'qualita'

const SCATTER_STYLE_COLORS: Record<string, string> = {
  onsight: '#1a6e2c',
  flash: '#e07b00',
  redpoint: '#c0392b',
  repeat: '#5a7ab8',
  unknown: '#aac0a7',
}

function ScatterTooltipContent({ active, payload }: { active?: boolean; payload?: Array<{ payload: Record<string, unknown> }> }) {
  if (!active || !payload?.length) return null
  const d = payload[0]?.payload
  if (!d) return null
  const style = String(d.attemptType ?? '')
  return (
    <div className="chart-tooltip">
      <div className="chart-tooltip-title">{String(d.routeName ?? '—')}</div>
      <div className="chart-tooltip-sub">{String(d.cragName ?? '')}{d.sectorName ? ` · ${String(d.sectorName)}` : ''}</div>
      <div className="chart-tooltip-row">
        <b>{String(d.gradeLabel ?? '')}</b>
        <span>{ASCENT_STYLE_LABELS[style as AscentStyle] ?? (style || '—')}</span>
      </div>
      <div className="chart-tooltip-date">{String(d.date ?? '')}</div>
    </div>
  )
}

function KpiCard({ value, label, sub }: { value: string | number; label: string; sub?: string }) {
  return (
    <div className="kpi-card">
      <div className="kpi-value">{value}</div>
      <div className="kpi-label">{label}</div>
      {sub && <div className="kpi-sub">{sub}</div>}
    </div>
  )
}

function QualityBar({ label, value, total, warn }: { label: string; value: number; total: number; warn?: boolean }) {
  const pct = total > 0 ? Math.round((value / total) * 100) : 0
  return (
    <div className="quality-row">
      <div className="quality-row-label">{label}</div>
      <div className="quality-bar-wrap">
        <div className="quality-bar-fill" style={{ width: `${pct}%`, background: warn && pct > 0 ? '#c0392b' : '#2d5a27' }} />
      </div>
      <div className="quality-row-value" style={{ color: warn && value > 0 ? '#c0392b' : undefined }}>
        {value} <span>({pct}%)</span>
      </div>
    </div>
  )
}

function WithinBar({ label, value, total, color = '#2d5a27' }: { label: string; value: number; total: number; color?: string }) {
  const pct = total > 0 ? Math.round((value / total) * 100) : 0
  return (
    <div className="quality-row">
      <div className="quality-row-label">{label}</div>
      <div className="quality-bar-wrap">
        <div className="quality-bar-fill" style={{ width: `${pct}%`, background: color }} />
      </div>
      <div className="quality-row-value">{value} <span>({pct}%)</span></div>
    </div>
  )
}

export default function AnalyticsPage() {
  const { user } = useAuth()
  const { data: ascents, isLoading: loadingAscents, isError: ascentsError, error: ascentsQueryError } = useMyAscents(user?.id ?? '')
  const { data: projects } = useMyProjects(user?.id ?? '')
  const { data: sessions } = useMySessions(user?.id ?? '')
  const { filters, setYear, setAscentStyles, reset, isDefault } = useAnalyticsFilters()
  const [activeTab, setActiveTab] = useState<Tab>('panoramica')

  const currentYear = new Date().getFullYear()

  const availableYears = useMemo(() => {
    const years = computeAvailableYears(ascents ?? [])
    return years.length > 0 ? years : [currentYear]
  }, [ascents, currentYear])

  const filtered = useMemo(
    () => filterAscents(ascents ?? [], filters),
    [ascents, filters]
  )

  const kpis = useMemo(
    () => computeKpis(ascents ?? [], projects ?? [], sessions ?? [], filters),
    [ascents, projects, sessions, filters]
  )

  const dataQuality = useMemo(() => computeDataQuality(ascents ?? []), [ascents])

  // ── Panoramica ─────────────────────────────────────────────────────────────
  const progressionLineData = useMemo(
    () => computeGradeProgressionLine(filtered, filters.yearFilter),
    [filtered, filters.yearFilter]
  )
  const monthlyData = useMemo(
    () => computeMonthlyActivity(filtered, filters.yearFilter),
    [filtered, filters.yearFilter]
  )

  // ── Progressione ───────────────────────────────────────────────────────────
  const progressionPoints = useMemo(() => computeGradeProgression(filtered), [filtered])
  const scatterByStyle = useMemo(() => {
    return ASCENT_STYLE_ORDER.reduce<Record<string, typeof progressionPoints>>((acc, style) => {
      const pts = progressionPoints.filter(p => {
        const s = p.attemptType ?? 'unknown'
        return style === 'unknown'
          ? !ASCENT_STYLE_ORDER.slice(0, -1).some(x => x === s)
          : s === style
      })
      if (pts.length > 0) acc[style] = pts
      return acc
    }, {})
  }, [progressionPoints])
  const cumulativeMax = useMemo(() => computeCumulativeMax(filtered), [filtered])
  const maxByStylePerPeriod = useMemo(
    () => computeMaxByStylePerPeriod(filtered, filters.yearFilter),
    [filtered, filters.yearFilter]
  )
  const maxByStyleByYear = useMemo(() => computeMaxByStyleByYear(ascents ?? []), [ascents])

  // ── Volume ─────────────────────────────────────────────────────────────────
  const uniqueVsRepeat = useMemo(
    () => computeUniqueVsRepeatPerMonth(filtered, filters.yearFilter),
    [filtered, filters.yearFilter]
  )
  const sessionsPerMonth = useMemo(
    () => computeSessionsPerMonth(sessions ?? [], filters.yearFilter),
    [sessions, filters.yearFilter]
  )
  const dayOfWeek = useMemo(() => computeDayOfWeekDistribution(filtered), [filtered])
  const seasonal = useMemo(() => computeSeasonalDistribution(filtered), [filtered])

  // ── Profilo tecnico ────────────────────────────────────────────────────────
  const pyramidData = useMemo(() => computeGradePyramid(filtered), [filtered])
  const uniquePyramid = useMemo(() => computeUniquePyramid(filtered), [filtered])
  const gradeDist = useMemo(() => computeGradeDistribution(filtered), [filtered])
  const modeBreakdown = useMemo(() => computeAscentModeBreakdown(filtered), [filtered])
  const bucketBreakdown = useMemo(() => computeAttemptBucketBreakdown(filtered), [filtered])
  const modeByAttempt = useMemo(() => computeModeByAttempt(filtered), [filtered])

  // ── Falesie ────────────────────────────────────────────────────────────────
  const topCrags = useMemo(() => computeTopCrags(filtered), [filtered])
  const topCragsByUnique = useMemo(() => computeTopCragsByUniqueRoutes(filtered), [filtered])
  const topCragsByGrade = useMemo(() => computeTopCragsByAvgGrade(filtered), [filtered])

  if (!user) return null
  if (loadingAscents) return <div className="loading-state">Caricamento analisi…</div>

  const activeStyleFilter = filters.ascentStyles === 'all' ? null : filters.ascentStyles
  const total = kpis.totalAscents

  function toggleStyle(style: AscentStyle) {
    if (filters.ascentStyles === 'all') {
      setAscentStyles([style])
    } else {
      const current = filters.ascentStyles
      const next = current.includes(style)
        ? current.filter(s => s !== style)
        : [...current, style]
      setAscentStyles(next.length === 0 ? 'all' : next)
    }
  }

  const TABS: Array<{ key: Tab; label: string }> = [
    { key: 'panoramica',   label: 'Panoramica' },
    { key: 'progressione', label: 'Progressione' },
    { key: 'volume',       label: 'Volume' },
    { key: 'profilo',      label: 'Gradi e modalità' },
    { key: 'falesie',      label: 'Falesie' },
    { key: 'efficienza',   label: 'Efficienza' },
    { key: 'qualita',      label: 'Qualità dati' },
  ]

  return (
    <div className="analytics-page">
      {ascentsError && (
        <div className="chart-section" style={{ borderColor: '#f5c6cb', background: '#fff5f5', marginBottom: 16 }}>
          <h2 style={{ color: '#c0392b' }}>Errore caricamento dati</h2>
          <p className="chart-description">
            {ascentsQueryError instanceof Error ? ascentsQueryError.message : 'Errore sconosciuto dal server.'}
            {' '}Controlla la console (F12) per dettagli.
          </p>
        </div>
      )}
      {!ascentsError && ascents?.length === 0 && (
        <div className="chart-section" style={{ borderColor: '#bee5eb', background: '#f0f8ff', marginBottom: 16 }}>
          <h2>Nessuna ascensione nel logbook</h2>
          <p className="chart-description">
            Aggiungi le prime salite dal logbook.
          </p>
        </div>
      )}

      <div className="analytics-header">
        <h1>Analisi</h1>
        <div className="analytics-filter-bar">
          <div className="year-filter">
            <button
              className={`year-btn${filters.yearFilter === 'all' ? ' active' : ''}`}
              onClick={() => setYear('all')}
            >Tutti</button>
            {availableYears.map(y => (
              <button
                key={y}
                className={`year-btn${filters.yearFilter === y ? ' active' : ''}`}
                onClick={() => setYear(y)}
              >{y}</button>
            ))}
          </div>
          <div className="style-filter">
            {ASCENT_STYLE_ORDER.filter(s => s !== 'unknown').map(style => {
              const active = activeStyleFilter?.includes(style) ?? false
              return (
                <button
                  key={style}
                  className={`style-btn${active ? ' active' : ''}`}
                  style={active ? { background: ASCENT_STYLE_COLORS[style], borderColor: ASCENT_STYLE_COLORS[style] } : {}}
                  onClick={() => toggleStyle(style)}
                  title={ASCENT_STYLE_LABELS[style]}
                >
                  {ASCENT_STYLE_LABELS[style].split('-')[0].trim().slice(0, 2).toUpperCase()}
                </button>
              )
            })}
          </div>
          {!isDefault && (
            <button className="filter-reset-btn" onClick={reset} aria-label="Azzera filtri">✕ Reset</button>
          )}
        </div>
      </div>

      {/* ── KPI Attività ── */}
      <div className="kpi-section-label">Attività</div>
      <div className="kpi-grid">
        <KpiCard value={kpis.totalAscents} label="Salite totali" />
        <KpiCard value={kpis.uniqueRoutes} label="Vie uniche" />
        <KpiCard value={kpis.repeatCount} label="Ripetizioni" sub={total > 0 ? `${kpis.repeatPct}%` : undefined} />
        <KpiCard value={kpis.totalSessions} label="Sessioni" />
        <KpiCard value={kpis.activeDays} label="Giorni attivi" />
        <KpiCard value={kpis.totalCrags} label="Falesie" />
        <KpiCard value={kpis.activeProjects} label="Progetti attivi" />
        {kpis.lastSessionDaysAgo != null && (
          <KpiCard value={`${kpis.lastSessionDaysAgo}gg`} label="Dall'ultima sessione" />
        )}
      </div>

      {/* ── KPI Prestazione ── */}
      <div className="kpi-section-label">Prestazione</div>
      <div className="kpi-grid">
        <KpiCard value={kpis.bestOnsightLabel} label="Max On-sight" />
        <KpiCard value={kpis.bestFlashLabel} label="Max Flash" />
        <KpiCard value={kpis.bestRedpointLabel} label="Max Redpoint" />
        <KpiCard value={kpis.avgGradeLabel} label="Grado medio" />
        <KpiCard value={kpis.medianGradeLabel} label="Grado mediano" />
        <KpiCard value={`${kpis.osPct}%`} label="On-sight" />
        <KpiCard value={`${kpis.flashPct}%`} label="Flash" />
        <KpiCard value={`${kpis.rpPct}%`} label="Redpoint" />
        <KpiCard value={`${kpis.osFlashPct}%`} label="OS + Flash" />
      </div>

      {/* ── KPI Chiusure ── */}
      <div className="kpi-section-label">Chiusure per numero di giri</div>
      <div className="kpi-grid">
        <KpiCard value={kpis.within1} label="Al 1° giro" sub={total > 0 ? `${Math.round((kpis.within1 / total) * 100)}%` : undefined} />
        <KpiCard value={kpis.within3} label="Entro 3 giri" sub={total > 0 ? `${Math.round((kpis.within3 / total) * 100)}%` : undefined} />
        <KpiCard value={kpis.within5} label="Entro 5 giri" sub={total > 0 ? `${Math.round((kpis.within5 / total) * 100)}%` : undefined} />
        <KpiCard value={kpis.within10} label="Entro 10 giri" sub={total > 0 ? `${Math.round((kpis.within10 / total) * 100)}%` : undefined} />
        <KpiCard value={kpis.beyond10} label="Oltre 10 giri" sub={total > 0 ? `${Math.round((kpis.beyond10 / total) * 100)}%` : undefined} />
      </div>

      {/* ── Tab nav ── */}
      <div className="analytics-tabs" role="tablist">
        {TABS.map(({ key, label }) => (
          <button
            key={key}
            role="tab"
            aria-selected={activeTab === key}
            className={`analytics-tab${activeTab === key ? ' active' : ''}`}
            onClick={() => setActiveTab(key)}
          >{label}</button>
        ))}
      </div>

      {/* ────────────────────────────────────────────────────────────────────────
          Tab: Panoramica
      ──────────────────────────────────────────────────────────────────────── */}
      {activeTab === 'panoramica' && (
        <div className="analytics-tab-content" role="tabpanel">

          <div className="chart-section">
            <h2>Progressione grado nel tempo</h2>
            <p className="chart-description">Grado massimo e medio per periodo. {filtered.length} ascensioni.</p>
            {progressionLineData.length < 2 ? (
              <div className="chart-empty">Servono almeno 2 periodi con dati.</div>
            ) : (
              <ResponsiveContainer width="100%" height={220}>
                <LineChart data={progressionLineData} margin={{ top: 4, right: 16, left: -10, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" />
                  <XAxis dataKey="label" tick={{ fontSize: 10 }} interval="preserveStartEnd" />
                  <YAxis allowDecimals={false} tick={{ fontSize: 10 }} tickFormatter={(n: number) => numToGrade(n)} domain={['auto', 'auto']} />
                  <Tooltip
                    contentStyle={{ fontSize: 11, borderRadius: 8 }}
                    formatter={(value, name) => [numToGrade(Math.round(Number(value))), name === 'best' ? 'Massimo' : 'Media']}
                  />
                  <Legend formatter={(v: string) => v === 'best' ? 'Grado massimo' : 'Media'} wrapperStyle={{ fontSize: 11 }} />
                  <Line type="monotone" dataKey="best" stroke="#2d5a27" strokeWidth={2} dot={{ r: 3 }} name="best" />
                  <Line type="monotone" dataKey="avg" stroke="#e07b00" strokeWidth={2} dot={{ r: 3 }} strokeDasharray="4 2" name="avg" />
                </LineChart>
              </ResponsiveContainer>
            )}
          </div>

          <div className="chart-grid-2col">

            <div className="chart-section">
              <h2>Volume{filters.yearFilter !== 'all' ? ` — ${filters.yearFilter}` : ' per periodo'}</h2>
              {monthlyData.every(d => d.count === 0) ? (
                <div className="chart-empty">Nessuna salita nel periodo.</div>
              ) : (
                <ResponsiveContainer width="100%" height={200}>
                  <BarChart data={monthlyData} margin={{ top: 4, right: 8, left: -20, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" />
                    <XAxis dataKey="label" tick={{ fontSize: 10 }} interval="preserveStartEnd" />
                    <YAxis allowDecimals={false} tick={{ fontSize: 10 }} />
                    <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Salite']} />
                    <Bar dataKey="count" fill="#2d5a27" radius={[3, 3, 0, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              )}
            </div>

            <div className="chart-section">
              <h2>Modalità di salita</h2>
              {modeBreakdown.length === 0 ? (
                <div className="chart-empty">Nessun dato.</div>
              ) : (
                <ResponsiveContainer width="100%" height={200}>
                  <BarChart
                    data={modeBreakdown.map(e => ({ count: e.count, label: ASCENT_STYLE_LABELS[e.ascentStyle] }))}
                    layout="vertical" margin={{ top: 4, right: 16, left: 80, bottom: 0 }}
                  >
                    <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                    <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                    <YAxis type="category" dataKey="label" tick={{ fontSize: 10 }} width={80} />
                    <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Salite']} />
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

          <div className="chart-grid-2col-mt">

            <div className="chart-section">
              <h2>Piramide dei gradi</h2>
              {pyramidData.length === 0 ? (
                <div className="chart-empty">Nessun dato.</div>
              ) : (
                <ResponsiveContainer width="100%" height={Math.max(160, Math.min(pyramidData.length, 10) * 26)}>
                  <BarChart data={pyramidData.slice(0, 10)} layout="vertical" margin={{ top: 4, right: 8, left: 36, bottom: 4 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                    <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                    <YAxis type="category" dataKey="grade" tick={{ fontSize: 10 }} width={36} />
                    <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} />
                    <Bar dataKey="onsight"  name="OS"  stackId="a" fill="#1a6e2c" />
                    <Bar dataKey="flash"    name="FL"  stackId="a" fill="#e07b00" />
                    <Bar dataKey="redpoint" name="RP"  stackId="a" fill="#c0392b" />
                    <Bar dataKey="repeat"   name="Rip" stackId="a" fill="#5a7ab8" />
                    <Bar dataKey="unknown"  name="?"   stackId="a" fill="#aac0a7" radius={[0, 3, 3, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              )}
            </div>

            <div className="chart-section">
              <h2>Top falesie</h2>
              {topCrags.length === 0 ? (
                <div className="chart-empty">Nessun dato.</div>
              ) : (
                <ResponsiveContainer width="100%" height={Math.max(160, Math.min(topCrags.length, 8) * 26)}>
                  <BarChart data={topCrags.slice(0, 8)} layout="vertical" margin={{ top: 4, right: 16, left: 8, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                    <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                    <YAxis type="category" dataKey="name" tick={{ fontSize: 10 }} width={100} />
                    <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Salite']} />
                    <Bar dataKey="count" fill="#4a8a42" radius={[0, 3, 3, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              )}
            </div>

          </div>
        </div>
      )}

      {/* ────────────────────────────────────────────────────────────────────────
          Tab: Progressione
      ──────────────────────────────────────────────────────────────────────── */}
      {activeTab === 'progressione' && (
        <div className="analytics-tab-content" role="tabpanel">

          <div className="chart-section">
            <h2>Ascensioni nel tempo</h2>
            <p className="chart-description">Ogni punto = una via completata. {filtered.length} ascensioni nel periodo.</p>
            {progressionPoints.length === 0 ? (
              <div className="chart-empty">Nessuna ascensione disponibile per questo periodo.</div>
            ) : (
              <ResponsiveContainer width="100%" height={320}>
                <ScatterChart margin={{ top: 8, right: 16, bottom: 8, left: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" />
                  <XAxis
                    dataKey="dateTs" type="number" domain={['auto', 'auto']} scale="time"
                    tick={{ fontSize: 10 }}
                    tickFormatter={(ts: number) => {
                      const d = new Date(ts)
                      return `${String(d.getFullYear()).slice(2)}/${String(d.getMonth() + 1).padStart(2, '0')}`
                    }}
                    name="Data"
                  />
                  <YAxis
                    dataKey="gradeValue" type="number" domain={['auto', 'auto']}
                    tick={{ fontSize: 10 }} tickFormatter={(n: number) => numToGrade(n)}
                    name="Grado" width={36}
                  />
                  <ZAxis range={[45, 45]} />
                  <Tooltip content={<ScatterTooltipContent />} />
                  <Legend wrapperStyle={{ fontSize: 11 }} formatter={(v: string) => ASCENT_STYLE_LABELS[v as AscentStyle] ?? v} />
                  {Object.entries(scatterByStyle).map(([style, points]) => (
                    <Scatter
                      key={style} name={style} data={points}
                      fill={SCATTER_STYLE_COLORS[style] ?? '#aac0a7'} fillOpacity={0.85}
                    />
                  ))}
                </ScatterChart>
              </ResponsiveContainer>
            )}
          </div>

          <div className="chart-section">
            <h2>Massimo storico progressivo</h2>
            <p className="chart-description">Ogni punto segna un nuovo record personale di grado.</p>
            {cumulativeMax.length === 0 ? (
              <div className="chart-empty">Nessun dato con grado disponibile.</div>
            ) : (
              <ResponsiveContainer width="100%" height={220}>
                <LineChart data={cumulativeMax} margin={{ top: 4, right: 16, left: -10, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" />
                  <XAxis
                    dataKey="dateTs" type="number" domain={['auto', 'auto']} scale="time"
                    tick={{ fontSize: 10 }}
                    tickFormatter={(ts: number) => {
                      const d = new Date(ts)
                      return `${d.getFullYear()}/${String(d.getMonth() + 1).padStart(2, '0')}`
                    }}
                  />
                  <YAxis
                    dataKey="gradeValue" type="number" domain={['auto', 'auto']}
                    tick={{ fontSize: 10 }} tickFormatter={(n: number) => numToGrade(n)} width={36}
                  />
                  <Tooltip
                    contentStyle={{ fontSize: 11, borderRadius: 8 }}
                    formatter={(v) => [numToGrade(Number(v)), 'Record']}
                    labelFormatter={(ts) => new Date(Number(ts)).toLocaleDateString('it-IT')}
                  />
                  <Line type="stepAfter" dataKey="gradeValue" stroke="#2d5a27" strokeWidth={2} dot={{ r: 4, fill: '#2d5a27' }} name="Record" />
                </LineChart>
              </ResponsiveContainer>
            )}
          </div>

          <div className="chart-section">
            <h2>Massimo OS / Flash / Redpoint per periodo</h2>
            <p className="chart-description">Grado massimo raggiunto per modalità in ogni periodo.</p>
            {maxByStylePerPeriod.length === 0 ? (
              <div className="chart-empty">Nessun dato.</div>
            ) : (
              <ResponsiveContainer width="100%" height={220}>
                <LineChart data={maxByStylePerPeriod} margin={{ top: 4, right: 16, left: -10, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" />
                  <XAxis dataKey="label" tick={{ fontSize: 10 }} interval="preserveStartEnd" />
                  <YAxis allowDecimals={false} tick={{ fontSize: 10 }} tickFormatter={(n: number) => numToGrade(n)} domain={['auto', 'auto']} />
                  <Tooltip
                    contentStyle={{ fontSize: 11, borderRadius: 8 }}
                    formatter={(v, name) => [v != null ? numToGrade(Number(v)) : '—', name === 'onsight' ? 'On-sight' : name === 'flash' ? 'Flash' : 'Redpoint']}
                  />
                  <Legend wrapperStyle={{ fontSize: 11 }} formatter={(v: string) => v === 'onsight' ? 'On-sight' : v === 'flash' ? 'Flash' : 'Redpoint'} />
                  <Line type="monotone" dataKey="onsight"  stroke="#1a6e2c" strokeWidth={2} dot={{ r: 3 }} connectNulls name="onsight" />
                  <Line type="monotone" dataKey="flash"    stroke="#e07b00" strokeWidth={2} dot={{ r: 3 }} connectNulls name="flash" />
                  <Line type="monotone" dataKey="redpoint" stroke="#c0392b" strokeWidth={2} dot={{ r: 3 }} connectNulls name="redpoint" />
                </LineChart>
              </ResponsiveContainer>
            )}
          </div>

          <div className="chart-section">
            <h2>Progressione grado nel tempo</h2>
            <p className="chart-description">Grado massimo e medio per periodo.</p>
            {progressionLineData.length < 2 ? (
              <div className="chart-empty">Servono almeno 2 periodi con dati.</div>
            ) : (
              <ResponsiveContainer width="100%" height={220}>
                <LineChart data={progressionLineData} margin={{ top: 4, right: 16, left: -10, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" />
                  <XAxis dataKey="label" tick={{ fontSize: 10 }} interval="preserveStartEnd" />
                  <YAxis allowDecimals={false} tick={{ fontSize: 10 }} tickFormatter={(n: number) => numToGrade(n)} domain={['auto', 'auto']} />
                  <Tooltip
                    contentStyle={{ fontSize: 11, borderRadius: 8 }}
                    formatter={(value, name) => [numToGrade(Math.round(Number(value))), name === 'best' ? 'Massimo' : 'Media']}
                  />
                  <Legend formatter={(v: string) => v === 'best' ? 'Grado massimo' : 'Media'} wrapperStyle={{ fontSize: 11 }} />
                  <Line type="monotone" dataKey="best" stroke="#2d5a27" strokeWidth={2} dot={{ r: 3 }} name="best" />
                  <Line type="monotone" dataKey="avg" stroke="#e07b00" strokeWidth={2} dot={{ r: 3 }} strokeDasharray="4 2" name="avg" />
                </LineChart>
              </ResponsiveContainer>
            )}
          </div>

          <div className="chart-section">
            <h2>Massimo OS / Flash / RP per anno (tutti i periodi)</h2>
            <p className="chart-description">Record annuale per modalità, senza filtro anno.</p>
            {maxByStyleByYear.length === 0 ? (
              <div className="chart-empty">Nessun dato.</div>
            ) : (
              <div style={{ overflowX: 'auto' }}>
                <table className="max-by-year-table">
                  <thead>
                    <tr>
                      <th>Anno</th>
                      <th style={{ textAlign: 'center', color: '#1a6e2c' }}>On-sight</th>
                      <th style={{ textAlign: 'center', color: '#e07b00' }}>Flash</th>
                      <th style={{ textAlign: 'center', color: '#c0392b' }}>Redpoint</th>
                    </tr>
                  </thead>
                  <tbody>
                    {maxByStyleByYear.map(row => (
                      <tr key={row.year}>
                        <td style={{ fontWeight: 600 }}>{row.year}</td>
                        <td style={{ textAlign: 'center', color: '#1a6e2c' }}>{row.onsightLabel}</td>
                        <td style={{ textAlign: 'center', color: '#e07b00' }}>{row.flashLabel}</td>
                        <td style={{ textAlign: 'center', color: '#c0392b' }}>{row.redpointLabel}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>

        </div>
      )}

      {/* ────────────────────────────────────────────────────────────────────────
          Tab: Volume
      ──────────────────────────────────────────────────────────────────────── */}
      {activeTab === 'volume' && (
        <div className="analytics-tab-content" role="tabpanel">

          <div className="chart-grid-2col">

            <div className="chart-section">
              <h2>Salite per mese{filters.yearFilter !== 'all' ? ` — ${filters.yearFilter}` : ''}</h2>
              {monthlyData.every(d => d.count === 0) ? (
                <div className="chart-empty">Nessuna salita nel periodo.</div>
              ) : (
                <ResponsiveContainer width="100%" height={220}>
                  <BarChart data={monthlyData} margin={{ top: 4, right: 8, left: -20, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" />
                    <XAxis dataKey="label" tick={{ fontSize: 10 }} interval="preserveStartEnd" />
                    <YAxis allowDecimals={false} tick={{ fontSize: 10 }} />
                    <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Salite']} />
                    <Bar dataKey="count" fill="#2d5a27" radius={[3, 3, 0, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              )}
            </div>

            <div className="chart-section">
              <h2>Sessioni per mese</h2>
              {sessionsPerMonth.every(d => d.count === 0) ? (
                <div className="chart-empty">Nessuna sessione nel periodo.</div>
              ) : (
                <ResponsiveContainer width="100%" height={220}>
                  <BarChart data={sessionsPerMonth} margin={{ top: 4, right: 8, left: -20, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" />
                    <XAxis dataKey="label" tick={{ fontSize: 10 }} interval="preserveStartEnd" />
                    <YAxis allowDecimals={false} tick={{ fontSize: 10 }} />
                    <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Sessioni']} />
                    <Bar dataKey="count" fill="#5a7ab8" radius={[3, 3, 0, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              )}
            </div>

          </div>

          <div className="chart-section chart-section-mt">
            <h2>Vie uniche vs ripetizioni per mese</h2>
            <p className="chart-description">Prima volta su una via = unica; visite successive = ripetizione.</p>
            {uniqueVsRepeat.every(d => d.unique === 0 && d.repeat === 0) ? (
              <div className="chart-empty">Nessun dato nel periodo.</div>
            ) : (
              <ResponsiveContainer width="100%" height={220}>
                <BarChart data={uniqueVsRepeat} margin={{ top: 4, right: 16, left: -20, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" />
                  <XAxis dataKey="label" tick={{ fontSize: 10 }} interval="preserveStartEnd" />
                  <YAxis allowDecimals={false} tick={{ fontSize: 10 }} />
                  <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} />
                  <Legend wrapperStyle={{ fontSize: 11 }} />
                  <Bar dataKey="unique" name="Vie uniche" stackId="a" fill="#2d5a27" />
                  <Bar dataKey="repeat" name="Ripetizioni" stackId="a" fill="#aac0a7" radius={[3, 3, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            )}
          </div>

          <div className="chart-grid-2col-mt">

            <div className="chart-section">
              <h2>Distribuzione per giorno della settimana</h2>
              {dayOfWeek.every(d => d.count === 0) ? (
                <div className="chart-empty">Nessun dato.</div>
              ) : (
                <ResponsiveContainer width="100%" height={200}>
                  <BarChart data={dayOfWeek} margin={{ top: 4, right: 8, left: -20, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" />
                    <XAxis dataKey="day" tick={{ fontSize: 10 }} />
                    <YAxis allowDecimals={false} tick={{ fontSize: 10 }} />
                    <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Salite']} />
                    <Bar dataKey="count" fill="#4a8a42" radius={[3, 3, 0, 0]}>
                      {dayOfWeek.map((d, i) => (
                        <Cell key={d.day} fill={i === 0 || i === 6 ? '#e07b00' : '#4a8a42'} />
                      ))}
                    </Bar>
                  </BarChart>
                </ResponsiveContainer>
              )}
            </div>

            <div className="chart-section">
              <h2>Distribuzione stagionale</h2>
              <p className="chart-description">Salite per mese su tutti gli anni — mostra la stagione preferita.</p>
              {seasonal.every(d => d.count === 0) ? (
                <div className="chart-empty">Nessun dato.</div>
              ) : (
                <ResponsiveContainer width="100%" height={200}>
                  <BarChart data={seasonal} margin={{ top: 4, right: 8, left: -20, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" />
                    <XAxis dataKey="month" tick={{ fontSize: 10 }} />
                    <YAxis allowDecimals={false} tick={{ fontSize: 10 }} />
                    <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Salite']} />
                    <Bar dataKey="count" fill="#2d5a27" radius={[3, 3, 0, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              )}
            </div>

          </div>
        </div>
      )}

      {/* ────────────────────────────────────────────────────────────────────────
          Tab: Gradi e modalità (ex Profilo tecnico)
      ──────────────────────────────────────────────────────────────────────── */}
      {activeTab === 'profilo' && (
        <div className="analytics-tab-content" role="tabpanel">

          <div className="chart-grid-2col">

            <div className="chart-section">
              <h2>Distribuzione salite per grado</h2>
              {gradeDist.length === 0 ? (
                <div className="chart-empty">Nessun dato.</div>
              ) : (
                <ResponsiveContainer width="100%" height={Math.max(180, Math.min(gradeDist.length, 14) * 22)}>
                  <BarChart data={gradeDist} layout="vertical" margin={{ top: 4, right: 8, left: 36, bottom: 4 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                    <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                    <YAxis type="category" dataKey="grade" tick={{ fontSize: 10 }} width={36} />
                    <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Salite']} />
                    <Bar dataKey="count" fill="#2d5a27" radius={[0, 3, 3, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              )}
            </div>

            <div className="chart-section">
              <h2>Piramide dei gradi</h2>
              <p className="chart-description">{pyramidData.length} gradi nel periodo.</p>
              {pyramidData.length === 0 ? (
                <div className="chart-empty">Nessun dato.</div>
              ) : (
                <ResponsiveContainer width="100%" height={Math.max(180, Math.min(pyramidData.length, 14) * 22)}>
                  <BarChart data={pyramidData} layout="vertical" margin={{ top: 4, right: 16, left: 44, bottom: 4 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                    <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                    <YAxis type="category" dataKey="grade" tick={{ fontSize: 11 }} width={44} />
                    <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} />
                    <Legend wrapperStyle={{ fontSize: 11 }} />
                    <Bar dataKey="onsight"  name="On-sight"    stackId="a" fill="#1a6e2c" />
                    <Bar dataKey="flash"    name="Flash"       stackId="a" fill="#e07b00" />
                    <Bar dataKey="redpoint" name="Redpoint"    stackId="a" fill="#c0392b" />
                    <Bar dataKey="repeat"   name="Ripetizione" stackId="a" fill="#5a7ab8" />
                    <Bar dataKey="unknown"  name="Non spec."   stackId="a" fill="#aac0a7" radius={[0, 3, 3, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              )}
            </div>

          </div>

          <div className="chart-section chart-section-mt">
            <h2>Piramide vie uniche</h2>
            <p className="chart-description">Solo la prima ascensione per ogni via. Mostra quanto è largo il repertorio.</p>
            {uniquePyramid.length === 0 ? (
              <div className="chart-empty">Nessun dato.</div>
            ) : (
              <ResponsiveContainer width="100%" height={Math.max(200, uniquePyramid.length * 28)}>
                <BarChart data={uniquePyramid} layout="vertical" margin={{ top: 4, right: 16, left: 44, bottom: 4 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                  <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                  <YAxis type="category" dataKey="grade" tick={{ fontSize: 11 }} width={44} />
                  <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} />
                  <Legend wrapperStyle={{ fontSize: 11 }} />
                  <Bar dataKey="onsight"  name="On-sight"    stackId="a" fill="#1a6e2c" />
                  <Bar dataKey="flash"    name="Flash"       stackId="a" fill="#e07b00" />
                  <Bar dataKey="redpoint" name="Redpoint"    stackId="a" fill="#c0392b" />
                  <Bar dataKey="repeat"   name="Ripetizione" stackId="a" fill="#5a7ab8" />
                  <Bar dataKey="unknown"  name="Non spec."   stackId="a" fill="#aac0a7" radius={[0, 3, 3, 0]} />
                </BarChart>
              </ResponsiveContainer>
            )}
          </div>

          <div className="chart-section">
            <h2>Modalità di salita</h2>
            <p className="chart-description">second/third/four_plus classificati come Redpoint.</p>
            {modeBreakdown.length === 0 ? (
              <div className="chart-empty">Nessun dato.</div>
            ) : (
              <ResponsiveContainer width="100%" height={Math.max(140, modeBreakdown.length * 36)}>
                <BarChart
                  data={modeBreakdown.map(e => ({ count: e.count, label: ASCENT_STYLE_LABELS[e.ascentStyle] }))}
                  layout="vertical" margin={{ top: 4, right: 24, left: 80, bottom: 0 }}
                >
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                  <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                  <YAxis type="category" dataKey="label" tick={{ fontSize: 10 }} width={80} />
                  <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Salite']} />
                  <Bar dataKey="count" radius={[0, 3, 3, 0]}>
                    {modeBreakdown.map(entry => (
                      <Cell key={entry.ascentStyle} fill={ASCENT_STYLE_COLORS[entry.ascentStyle]} />
                    ))}
                  </Bar>
                </BarChart>
              </ResponsiveContainer>
            )}
          </div>

          <div className="chart-section">
            <h2>Numero di giri per chiudere</h2>
            <p className="chart-description">1° giro include OS e Flash.</p>
            {bucketBreakdown.length === 0 ? (
              <div className="chart-empty">Nessun dato con numero di giri registrato.</div>
            ) : (
              <ResponsiveContainer width="100%" height={Math.max(200, bucketBreakdown.length * 30)}>
                <BarChart
                  data={bucketBreakdown.map(e => ({ count: e.count, label: ATTEMPT_BUCKET_LABELS[e.bucket] }))}
                  layout="vertical" margin={{ top: 4, right: 24, left: 96, bottom: 0 }}
                >
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                  <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                  <YAxis type="category" dataKey="label" tick={{ fontSize: 10 }} width={96} />
                  <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Salite']} />
                  <Bar dataKey="count" fill="#4a8a42" radius={[0, 3, 3, 0]} />
                </BarChart>
              </ResponsiveContainer>
            )}
          </div>

          <div className="chart-section">
            <h2>Modalità per numero di giri</h2>
            {modeByAttempt.length === 0 ? (
              <div className="chart-empty">Nessun dato.</div>
            ) : (
              <ResponsiveContainer width="100%" height={Math.max(200, modeByAttempt.length * 30)}>
                <BarChart
                  data={modeByAttempt.map(e => ({ ...e, label: ATTEMPT_BUCKET_LABELS[e.bucket as AttemptBucket] ?? e.bucket }))}
                  layout="vertical" margin={{ top: 4, right: 16, left: 96, bottom: 4 }}
                >
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                  <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                  <YAxis type="category" dataKey="label" tick={{ fontSize: 10 }} width={96} />
                  <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} />
                  <Legend wrapperStyle={{ fontSize: 11 }} />
                  <Bar dataKey="onsight"  name="On-sight"    stackId="a" fill="#1a6e2c" />
                  <Bar dataKey="flash"    name="Flash"       stackId="a" fill="#e07b00" />
                  <Bar dataKey="redpoint" name="Redpoint"    stackId="a" fill="#c0392b" />
                  <Bar dataKey="repeat"   name="Ripetizione" stackId="a" fill="#5a7ab8" />
                  <Bar dataKey="unknown"  name="Non spec."   stackId="a" fill="#aac0a7" radius={[0, 3, 3, 0]} />
                </BarChart>
              </ResponsiveContainer>
            )}
          </div>

        </div>
      )}

      {/* ────────────────────────────────────────────────────────────────────────
          Tab: Falesie
      ──────────────────────────────────────────────────────────────────────── */}
      {activeTab === 'falesie' && (
        <div className="analytics-tab-content" role="tabpanel">

          <div className="chart-grid-2col">

            <div className="chart-section">
              <h2>Top falesie per salite totali</h2>
              {topCrags.length === 0 ? (
                <div className="chart-empty">Nessun dato.</div>
              ) : (
                <ResponsiveContainer width="100%" height={Math.max(160, topCrags.length * 30)}>
                  <BarChart data={topCrags} layout="vertical" margin={{ top: 4, right: 24, left: 8, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                    <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                    <YAxis type="category" dataKey="name" tick={{ fontSize: 10 }} width={110} />
                    <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Salite']} />
                    <Bar dataKey="count" fill="#4a8a42" radius={[0, 3, 3, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              )}
            </div>

            <div className="chart-section">
              <h2>Top falesie per vie uniche</h2>
              {topCragsByUnique.length === 0 ? (
                <div className="chart-empty">Nessun dato.</div>
              ) : (
                <ResponsiveContainer width="100%" height={Math.max(160, topCragsByUnique.length * 30)}>
                  <BarChart data={topCragsByUnique} layout="vertical" margin={{ top: 4, right: 24, left: 8, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                    <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                    <YAxis type="category" dataKey="name" tick={{ fontSize: 10 }} width={110} />
                    <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Vie uniche']} />
                    <Bar dataKey="count" fill="#2d5a27" radius={[0, 3, 3, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              )}
            </div>

          </div>

          <div className="chart-section chart-section-mt">
            <h2>Top falesie per grado medio</h2>
            <p className="chart-description">Solo falesie con almeno 2 ascensioni con grado registrato.</p>
            {topCragsByGrade.length === 0 ? (
              <div className="chart-empty">Dati insufficienti (servono almeno 2 salite con grado per falesia).</div>
            ) : (
              <ResponsiveContainer width="100%" height={Math.max(160, topCragsByGrade.length * 30)}>
                <BarChart data={topCragsByGrade} layout="vertical" margin={{ top: 4, right: 24, left: 8, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                  <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} tickFormatter={(n: number) => numToGrade(n)} />
                  <YAxis type="category" dataKey="name" tick={{ fontSize: 10 }} width={110} />
                  <Tooltip
                    contentStyle={{ fontSize: 11, borderRadius: 8 }}
                    formatter={(v) => [numToGrade(Number(v)), 'Grado medio']}
                  />
                  <Bar dataKey="count" fill="#5a7ab8" radius={[0, 3, 3, 0]} />
                </BarChart>
              </ResponsiveContainer>
            )}
          </div>

        </div>
      )}

      {/* ────────────────────────────────────────────────────────────────────────
          Tab: Efficienza
      ──────────────────────────────────────────────────────────────────────── */}
      {activeTab === 'efficienza' && (
        <div className="analytics-tab-content" role="tabpanel">

          <div className="chart-section">
            <h2>Percentuale di chiusura per numero di giri</h2>
            <p className="chart-description">
              Quante vie vengono chiuse entro un certo numero di tentativi.
              {' '}{filtered.length} ascensioni nel periodo.
            </p>
            {filtered.length === 0 ? (
              <div className="chart-empty">Nessun dato nel periodo.</div>
            ) : (
              <div className="quality-panel">
                <WithinBar label="Al 1° giro (OS + Flash)" value={kpis.within1} total={total} color="#1a6e2c" />
                <WithinBar label="Entro 3 giri" value={kpis.within3} total={total} color="#2d5a27" />
                <WithinBar label="Entro 5 giri" value={kpis.within5} total={total} color="#4a8a42" />
                <WithinBar label="Entro 10 giri" value={kpis.within10} total={total} color="#7ab87a" />
                <WithinBar label="Oltre 10 giri" value={kpis.beyond10} total={total} color="#c0392b" />
              </div>
            )}
          </div>

          <div className="chart-section">
            <h2>Distribuzione chiusure per fascia di tentativi</h2>
            {bucketBreakdown.length === 0 ? (
              <div className="chart-empty">Nessun dato con numero di giri registrato.</div>
            ) : (
              <ResponsiveContainer width="100%" height={Math.max(200, bucketBreakdown.length * 30)}>
                <BarChart
                  data={bucketBreakdown.map(e => ({ count: e.count, label: ATTEMPT_BUCKET_LABELS[e.bucket] }))}
                  layout="vertical" margin={{ top: 4, right: 24, left: 96, bottom: 0 }}
                >
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                  <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                  <YAxis type="category" dataKey="label" tick={{ fontSize: 10 }} width={96} />
                  <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Salite']} />
                  <Bar dataKey="count" radius={[0, 3, 3, 0]}>
                    {bucketBreakdown.map((e, i) => (
                      <Cell key={e.bucket} fill={i === 0 ? '#1a6e2c' : i <= 2 ? '#4a8a42' : i <= 4 ? '#e07b00' : '#c0392b'} />
                    ))}
                  </Bar>
                </BarChart>
              </ResponsiveContainer>
            )}
          </div>

          <div className="chart-section">
            <h2>Chiusure al 1° giro per grado</h2>
            <p className="chart-description">Quante vie del tiro sono state chiuse a OS o Flash.</p>
            {gradeDist.length === 0 ? (
              <div className="chart-empty">Nessun dato.</div>
            ) : (() => {
              const data = gradeDist.map(g => {
                const pyEntry = pyramidData.find(p => p.grade === g.grade)
                const firstGo = (pyEntry?.onsight ?? 0) + (pyEntry?.flash ?? 0)
                return { grade: g.grade, firstGo, other: g.count - firstGo }
              }).filter(d => d.grade)
              return (
                <ResponsiveContainer width="100%" height={Math.max(180, Math.min(data.length, 14) * 22)}>
                  <BarChart data={data} layout="vertical" margin={{ top: 4, right: 8, left: 36, bottom: 4 }}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                    <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                    <YAxis type="category" dataKey="grade" tick={{ fontSize: 10 }} width={36} />
                    <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} />
                    <Legend wrapperStyle={{ fontSize: 11 }} />
                    <Bar dataKey="firstGo" name="OS / Flash" stackId="a" fill="#1a6e2c" />
                    <Bar dataKey="other" name="Altro" stackId="a" fill="#e0e0d8" radius={[0, 3, 3, 0]} />
                  </BarChart>
                </ResponsiveContainer>
              )
            })()}
          </div>

          <div className="chart-section chart-placeholder">
            <h2>Tentativi medi per grado</h2>
            <div className="chart-empty chart-coming-soon">Disponibile con dati attempt_count sufficienti.</div>
          </div>

          <div className="chart-section chart-placeholder">
            <h2>Funnel: provate → progetti → chiuse</h2>
            <div className="chart-empty chart-coming-soon">Disponibile nella prossima fase.</div>
          </div>

        </div>
      )}

      {/* ────────────────────────────────────────────────────────────────────────
          Tab: Qualità dati
      ──────────────────────────────────────────────────────────────────────── */}
      {activeTab === 'qualita' && (
        <div className="analytics-tab-content" role="tabpanel">
          <div className="chart-section">
            <h2>Completezza dei dati</h2>
            <p className="chart-description">
              {dataQuality.total} ascensioni totali nel logbook (tutti i periodi).
            </p>
            {dataQuality.total === 0 ? (
              <div className="chart-empty">Nessuna ascensione registrata.</div>
            ) : (
              <div className="quality-panel">
                <QualityBar label="Con modalità di salita" value={dataQuality.withAscentStyle} total={dataQuality.total} />
                <QualityBar label="Con numero di tentativi" value={dataQuality.withAttemptCount} total={dataQuality.total} />
                <QualityBar label="Con grado registrato" value={dataQuality.withGrade} total={dataQuality.total} />
                <QualityBar label="4+ giro da revisionare" value={dataQuality.fourPlusLegacy} total={dataQuality.total} warn />
                <QualityBar label="Da revisionare" value={dataQuality.needsReview} total={dataQuality.total} warn />
                <QualityBar label="Senza info tentativi" value={dataQuality.missingAttemptInfo} total={dataQuality.total} warn />
              </div>
            )}
          </div>

          {dataQuality.needsReview > 0 && (
            <div className="chart-section" style={{ borderColor: '#f5c6cb', background: '#fff5f5' }}>
              <h2 style={{ color: '#c0392b' }}>Ascensioni da revisionare</h2>
              <p className="chart-description">
                {dataQuality.needsReview} ascensioni con <code>needs_review = true</code>.
                Apri ogni ascensione e inserisci il numero esatto di tentativi.
              </p>
              {dataQuality.fourPlusLegacy > 0 && (
                <p className="chart-description">
                  Di queste, {dataQuality.fourPlusLegacy} provengono dal vecchio valore <code>four_plus</code>
                  {' '}e il numero reale di giri non è noto.
                </p>
              )}
            </div>
          )}

          <div className="chart-section chart-placeholder">
            <h2>Completezza nel tempo</h2>
            <div className="chart-empty chart-coming-soon">Disponibile nella prossima fase.</div>
          </div>
        </div>
      )}
    </div>
  )
}
