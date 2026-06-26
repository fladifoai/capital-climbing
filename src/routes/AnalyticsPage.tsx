import { useMemo, useState } from 'react'
import {
  ResponsiveContainer, BarChart, Bar, XAxis, YAxis,
  CartesianGrid, Tooltip, Cell, Legend,
  ScatterChart, Scatter, ZAxis,
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
} from '../analytics/metrics/ascents'
import { LineChart, Line } from 'recharts'
import { ASCENT_STYLE_LABELS, ASCENT_STYLE_COLORS, ASCENT_STYLE_ORDER } from '../analytics/calculations/ascent-style'
import { ATTEMPT_BUCKET_LABELS, type AttemptBucket } from '../analytics/calculations/attempt-buckets'
import type { AscentStyle } from '../analytics/calculations/ascent-style'
import '../styles/analytics.css'

type Tab = 'panoramica' | 'progressione' | 'volume' | 'profilo' | 'falesie' | 'qualita'

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

function KpiCard({ value, label }: { value: string | number; label: string }) {
  return (
    <div className="kpi-card">
      <div className="kpi-value">{value}</div>
      <div className="kpi-label">{label}</div>
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

  // Tab: Panoramica
  const progressionLineData = useMemo(
    () => computeGradeProgressionLine(filtered, filters.yearFilter),
    [filtered, filters.yearFilter]
  )

  // Tab: Progressione (scatter)
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

  // Tab: Volume
  const monthlyData = useMemo(
    () => computeMonthlyActivity(filtered, filters.yearFilter),
    [filtered, filters.yearFilter]
  )

  // Tab: Profilo tecnico
  const pyramidData = useMemo(() => computeGradePyramid(filtered), [filtered])
  const modeBreakdown = useMemo(() => computeAscentModeBreakdown(filtered), [filtered])
  const bucketBreakdown = useMemo(() => computeAttemptBucketBreakdown(filtered), [filtered])
  const modeByAttempt = useMemo(() => computeModeByAttempt(filtered), [filtered])

  // Tab: Falesie
  const topCrags = useMemo(() => computeTopCrags(filtered), [filtered])

  if (!user) return null
  if (loadingAscents) return <div className="loading-state">Caricamento analisi…</div>

  const activeStyleFilter = filters.ascentStyles === 'all' ? null : filters.ascentStyles

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
    { key: 'profilo',      label: 'Profilo tecnico' },
    { key: 'falesie',      label: 'Falesie' },
    { key: 'qualita',      label: 'Qualità dati' },
  ]

  return (
    <div className="analytics-page">
      {ascentsError && (
        <div className="chart-section" style={{ borderColor: '#f5c6cb', background: '#fff5f5', marginBottom: 16 }}>
          <h2 style={{ color: '#c0392b' }}>Errore caricamento dati</h2>
          <p className="chart-description">
            {ascentsQueryError instanceof Error ? ascentsQueryError.message : 'Errore sconosciuto dal server.'}
            {' '}Controlla la console (F12) per dettagli. Potrebbe mancare la migrazione 011 su Supabase.
          </p>
        </div>
      )}
      {!ascentsError && ascents?.length === 0 && (
        <div className="chart-section" style={{ borderColor: '#bee5eb', background: '#f0f8ff', marginBottom: 16 }}>
          <h2>Nessuna ascensione nel logbook</h2>
          <p className="chart-description">
            Non ci sono ascensioni nel database. Aggiungi le prime salite dal logbook oppure
            verifica che la migrazione <code>006_seed_catalog_and_logbook.sql</code> sia stata eseguita su Supabase <b>dopo</b> la registrazione.
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

      {/* KPI — gruppo attività */}
      <div className="kpi-section-label">Attività</div>
      <div className="kpi-grid">
        <KpiCard value={kpis.totalAscents} label="Salite" />
        <KpiCard value={kpis.uniqueRoutes} label="Vie uniche" />
        <KpiCard value={kpis.totalSessions} label="Sessioni" />
        <KpiCard value={kpis.activeDays} label="Giorni attivi" />
        <KpiCard value={kpis.totalCrags} label="Falesie" />
        <KpiCard value={kpis.activeProjects} label="Progetti" />
      </div>

      {/* KPI — gruppo prestazione */}
      <div className="kpi-section-label">Prestazione</div>
      <div className="kpi-grid">
        <KpiCard value={kpis.bestOnsightLabel} label="Max OS" />
        <KpiCard value={kpis.bestFlashLabel} label="Max Flash" />
        <KpiCard value={kpis.bestRedpointLabel} label="Max RP" />
        <KpiCard value={kpis.avgGradeLabel} label="Grado medio" />
        <KpiCard value={kpis.medianGradeLabel} label="Grado mediano" />
        <KpiCard value={`${kpis.osFlashPct}%`} label="OS + Flash" />
        <KpiCard value={kpis.within3} label="≤ 3 giri" />
        <KpiCard value={kpis.within5} label="≤ 5 giri" />
      </div>

      {/* Tab nav */}
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

      {/* ── Tab: Panoramica ── */}
      {activeTab === 'panoramica' && (
        <div className="analytics-tab-content" role="tabpanel">

          <div className="chart-section">
            <h2>Progressione grado nel tempo</h2>
            <p className="chart-description">Grado massimo e medio per periodo. {filtered.length} ascensioni.</p>
            {progressionLineData.length < 2 ? (
              <div className="chart-empty">Servono almeno 2 periodi con dati per mostrare la progressione.</div>
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

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}>

            <div className="chart-section" style={{ marginBottom: 0 }}>
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

            <div className="chart-section" style={{ marginBottom: 0 }}>
              <h2>Modalità di salita</h2>
              {modeBreakdown.length === 0 ? (
                <div className="chart-empty">Nessun dato.</div>
              ) : (
                <ResponsiveContainer width="100%" height={200}>
                  <BarChart
                    data={modeBreakdown.map(e => ({ ...e, label: ASCENT_STYLE_LABELS[e.style] }))}
                    layout="vertical" margin={{ top: 4, right: 16, left: 80, bottom: 0 }}
                  >
                    <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                    <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                    <YAxis type="category" dataKey="label" tick={{ fontSize: 10 }} width={80} />
                    <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Salite']} />
                    <Bar dataKey="count" radius={[0, 3, 3, 0]}>
                      {modeBreakdown.map(entry => (
                        <Cell key={entry.style} fill={ASCENT_STYLE_COLORS[entry.style]} />
                      ))}
                    </Bar>
                  </BarChart>
                </ResponsiveContainer>
              )}
            </div>

          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16, marginTop: 16 }}>

            <div className="chart-section" style={{ marginBottom: 0 }}>
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

            <div className="chart-section" style={{ marginBottom: 0 }}>
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

      {/* ── Tab: Progressione ── */}
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

          <div className="chart-section chart-placeholder">
            <h2>Massimo OS / Flash / Redpoint per anno</h2>
            <div className="chart-empty chart-coming-soon">Disponibile nella prossima fase.</div>
          </div>
        </div>
      )}

      {/* ── Tab: Volume ── */}
      {activeTab === 'volume' && (
        <div className="analytics-tab-content" role="tabpanel">
          <div className="chart-section">
            <h2>Attività nel tempo{filters.yearFilter !== 'all' ? ` — ${filters.yearFilter}` : ''}</h2>
            <p className="chart-description">{filtered.length} ascensioni nel periodo selezionato.</p>
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
          <div className="chart-section chart-placeholder">
            <h2>Calendario attività</h2>
            <div className="chart-empty chart-coming-soon">Disponibile nella prossima fase.</div>
          </div>
          <div className="chart-section chart-placeholder">
            <h2>Efficienza per grado</h2>
            <div className="chart-empty chart-coming-soon">Disponibile nella prossima fase.</div>
          </div>
        </div>
      )}

      {/* ── Tab: Profilo tecnico ── */}
      {activeTab === 'profilo' && (
        <div className="analytics-tab-content" role="tabpanel">

          <div className="chart-section">
            <h2>Piramide dei gradi</h2>
            <p className="chart-description">{pyramidData.length} gradi con ascensioni nel periodo.</p>
            {pyramidData.length === 0 ? (
              <div className="chart-empty">Nessun dato per i filtri selezionati.</div>
            ) : (
              <ResponsiveContainer width="100%" height={Math.max(200, pyramidData.length * 32)}>
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

          <div className="chart-section">
            <h2>Modalità di salita</h2>
            <p className="chart-description">second/third/four_plus classificati come Redpoint.</p>
            {modeBreakdown.length === 0 ? (
              <div className="chart-empty">Nessun dato.</div>
            ) : (
              <ResponsiveContainer width="100%" height={Math.max(140, modeBreakdown.length * 36)}>
                <BarChart
                  data={modeBreakdown.map(e => ({ ...e, label: ASCENT_STYLE_LABELS[e.style] }))}
                  layout="vertical" margin={{ top: 4, right: 24, left: 80, bottom: 0 }}
                >
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                  <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                  <YAxis type="category" dataKey="label" tick={{ fontSize: 10 }} width={80} />
                  <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} formatter={(v) => [v, 'Salite']} />
                  <Bar dataKey="count" radius={[0, 3, 3, 0]}>
                    {modeBreakdown.map(entry => (
                      <Cell key={entry.style} fill={ASCENT_STYLE_COLORS[entry.style]} />
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
                  data={bucketBreakdown.map(e => ({ ...e, label: ATTEMPT_BUCKET_LABELS[e.bucket] }))}
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

          <div className="chart-section chart-placeholder">
            <h2>Punti forti e anti-stile</h2>
            <div className="chart-empty chart-coming-soon">Disponibile nella prossima fase.</div>
          </div>

        </div>
      )}

      {/* ── Tab: Falesie ── */}
      {activeTab === 'falesie' && (
        <div className="analytics-tab-content" role="tabpanel">
          <div className="chart-section">
            <h2>Falesie più visitate</h2>
            <p className="chart-description">{topCrags.length} falesie nel periodo selezionato.</p>
            {topCrags.length === 0 ? (
              <div className="chart-empty">Nessun dato per i filtri selezionati.</div>
            ) : (
              <ResponsiveContainer width="100%" height={Math.max(160, topCrags.length * 32)}>
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
          <div className="chart-section chart-placeholder">
            <h2>Analisi condizioni</h2>
            <div className="chart-empty chart-coming-soon">Disponibile nella prossima fase.</div>
          </div>
        </div>
      )}

      {/* ── Tab: Qualità dati ── */}
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
        </div>
      )}
    </div>
  )
}
