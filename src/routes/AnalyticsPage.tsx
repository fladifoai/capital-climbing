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
  computeGradeProgression,
  computeGradePyramid,
  computeMonthlyActivity,
  computeTopCrags,
  computeAvailableYears,
  computeAscentModeBreakdown,
  computeAttemptBucketBreakdown,
  computeModeByAttempt,
} from '../analytics/metrics/ascents'
import { ASCENT_STYLE_LABELS, ASCENT_STYLE_COLORS } from '../analytics/calculations/ascent-style'
import { ATTEMPT_BUCKET_LABELS, type AttemptBucket } from '../analytics/calculations/attempt-buckets'
import '../styles/analytics.css'

type Tab = 'progressione' | 'volume' | 'profilo' | 'falesie'

const ATTEMPT_COLORS: Record<string, string> = {
  onsight: '#1a6e2c',
  flash: '#e07b00',
  second: '#4a8a42',
  third: '#7aaa40',
  four_plus: '#8a9a87',
  redpoint: '#c0392b',
  other: '#aac0a7',
}

const ATTEMPT_LABELS: Record<string, string> = {
  onsight: 'On-sight', flash: 'Flash', second: '2° giro',
  third: '3° giro', four_plus: '4+ giro', redpoint: 'Redpoint', other: 'Altro',
}

const SCATTER_TYPES = ['onsight', 'flash', 'second', 'third', 'four_plus', 'redpoint', 'other'] as const

function ScatterTooltipContent({ active, payload }: { active?: boolean; payload?: Array<{ payload: Record<string, unknown> }> }) {
  if (!active || !payload?.length) return null
  const d = payload[0]?.payload
  if (!d) return null
  return (
    <div className="chart-tooltip">
      <div className="chart-tooltip-title">{String(d.routeName ?? '—')}</div>
      <div className="chart-tooltip-sub">{String(d.cragName ?? '')}{d.sectorName ? ` · ${String(d.sectorName)}` : ''}</div>
      <div className="chart-tooltip-row">
        <b>{String(d.gradeLabel ?? '')}</b>
        <span>{ATTEMPT_LABELS[String(d.attemptType ?? '')] ?? String(d.attemptType ?? '—')}</span>
      </div>
      <div className="chart-tooltip-date">{String(d.date ?? '')}</div>
    </div>
  )
}

export default function AnalyticsPage() {
  const { user } = useAuth()
  const { data: ascents, isLoading: loadingAscents } = useMyAscents(user?.id ?? '')
  const { data: projects } = useMyProjects(user?.id ?? '')
  const { data: sessions } = useMySessions(user?.id ?? '')
  const { filters, setYear, reset, isDefault } = useAnalyticsFilters()
  const [activeTab, setActiveTab] = useState<Tab>('progressione')

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

  // Tab: Progressione
  const progressionPoints = useMemo(() => computeGradeProgression(filtered), [filtered])

  const scatterByType = useMemo(() => {
    return SCATTER_TYPES.reduce<Record<string, typeof progressionPoints>>((acc, t) => {
      const pts = t === 'other'
        ? progressionPoints.filter(p => !p.attemptType || !SCATTER_TYPES.slice(0, -1).includes(p.attemptType as never))
        : progressionPoints.filter(p => p.attemptType === t)
      if (pts.length > 0) acc[t] = pts
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

  const years = availableYears

  return (
    <div className="analytics-page">
      <div className="analytics-header">
        <h1>Analisi</h1>
        <div className="analytics-filter-bar">
          <div className="year-filter">
            <button
              className={`year-btn${filters.yearFilter === 'all' ? ' active' : ''}`}
              onClick={() => setYear('all')}
            >
              Tutti
            </button>
            {years.map(y => (
              <button
                key={y}
                className={`year-btn${filters.yearFilter === y ? ' active' : ''}`}
                onClick={() => setYear(y)}
              >
                {y}
              </button>
            ))}
          </div>
          {!isDefault && (
            <button className="filter-reset-btn" onClick={reset} aria-label="Azzera filtri">
              ✕ Reset
            </button>
          )}
        </div>
      </div>

      <div className="kpi-grid">
        <div className="kpi-card"><div className="kpi-value">{kpis.totalAscents}</div><div className="kpi-label">Salite</div></div>
        <div className="kpi-card"><div className="kpi-value">{kpis.totalSessions}</div><div className="kpi-label">Sessioni</div></div>
        <div className="kpi-card"><div className="kpi-value">{kpis.totalCrags}</div><div className="kpi-label">Falesie</div></div>
        <div className="kpi-card"><div className="kpi-value">{kpis.bestOnsightLabel}</div><div className="kpi-label">Max OS</div></div>
        <div className="kpi-card"><div className="kpi-value">{kpis.bestFlashLabel}</div><div className="kpi-label">Max Flash</div></div>
        <div className="kpi-card"><div className="kpi-value">{kpis.bestRedpointLabel}</div><div className="kpi-label">Max RP</div></div>
        <div className="kpi-card"><div className="kpi-value">{kpis.osFlashPct}%</div><div className="kpi-label">OS + Flash</div></div>
        <div className="kpi-card"><div className="kpi-value">{kpis.activeProjects}</div><div className="kpi-label">Progetti</div></div>
      </div>

      <div className="analytics-tabs" role="tablist">
        {(['progressione', 'volume', 'profilo', 'falesie'] as Tab[]).map(tab => (
          <button
            key={tab}
            role="tab"
            aria-selected={activeTab === tab}
            className={`analytics-tab${activeTab === tab ? ' active' : ''}`}
            onClick={() => setActiveTab(tab)}
          >
            {tab === 'progressione' ? 'Progressione'
              : tab === 'volume' ? 'Volume'
              : tab === 'profilo' ? 'Profilo tecnico'
              : 'Falesie'}
          </button>
        ))}
      </div>

      {/* ── Tab: Progressione ── */}
      {activeTab === 'progressione' && (
        <div className="analytics-tab-content" role="tabpanel">

          <div className="chart-section">
            <h2>Ascensioni nel tempo</h2>
            <p className="chart-description">Ogni punto è una via completata. {filtered.length} ascensioni nel periodo.</p>
            {progressionPoints.length === 0 ? (
              <div className="chart-empty">Nessuna ascensione disponibile per questo periodo.</div>
            ) : (
              <ResponsiveContainer width="100%" height={320}>
                <ScatterChart margin={{ top: 8, right: 16, bottom: 8, left: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" />
                  <XAxis
                    dataKey="dateTs"
                    type="number"
                    domain={['auto', 'auto']}
                    scale="time"
                    tick={{ fontSize: 10 }}
                    tickFormatter={(ts: number) => {
                      const d = new Date(ts)
                      return `${String(d.getFullYear()).slice(2)}/${String(d.getMonth() + 1).padStart(2, '0')}`
                    }}
                    name="Data"
                  />
                  <YAxis
                    dataKey="gradeValue"
                    type="number"
                    domain={['auto', 'auto']}
                    tick={{ fontSize: 10 }}
                    tickFormatter={(n: number) => numToGrade(n)}
                    name="Grado"
                    width={36}
                  />
                  <ZAxis range={[45, 45]} />
                  <Tooltip content={<ScatterTooltipContent />} />
                  <Legend wrapperStyle={{ fontSize: 11 }} formatter={(v: string) => ATTEMPT_LABELS[v] ?? v} />
                  {Object.entries(scatterByType).map(([type, points]) => (
                    <Scatter
                      key={type}
                      name={type}
                      data={points}
                      fill={ATTEMPT_COLORS[type] ?? '#aac0a7'}
                      fillOpacity={0.85}
                    />
                  ))}
                </ScatterChart>
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
                  <Tooltip
                    contentStyle={{ fontSize: 11, borderRadius: 8 }}
                    formatter={(v) => [v, 'Salite']}
                  />
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
            <p className="chart-description">
              Distribuzione per grado e tipo di salita. {pyramidData.length} gradi con ascensioni.
            </p>
            {pyramidData.length === 0 ? (
              <div className="chart-empty">Nessun dato disponibile per i filtri selezionati.</div>
            ) : (
              <ResponsiveContainer width="100%" height={Math.max(200, pyramidData.length * 32)}>
                <BarChart
                  data={pyramidData}
                  layout="vertical"
                  margin={{ top: 4, right: 16, left: 44, bottom: 4 }}
                >
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                  <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                  <YAxis type="category" dataKey="grade" tick={{ fontSize: 11 }} width={44} />
                  <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} />
                  <Legend wrapperStyle={{ fontSize: 11 }} />
                  <Bar dataKey="onsight" name="On-sight" stackId="a" fill="#1a6e2c" />
                  <Bar dataKey="flash" name="Flash" stackId="a" fill="#e07b00" />
                  <Bar dataKey="second" name="2° giro" stackId="a" fill="#4a8a42" />
                  <Bar dataKey="third" name="3° giro" stackId="a" fill="#7aaa40" />
                  <Bar dataKey="four_plus" name="4+ giro" stackId="a" fill="#8a9a87" />
                  <Bar dataKey="redpoint" name="Redpoint" stackId="a" fill="#c0392b" />
                  <Bar dataKey="other" name="Altro" stackId="a" fill="#aac0a7" radius={[0, 3, 3, 0]} />
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
                  layout="vertical"
                  margin={{ top: 4, right: 24, left: 80, bottom: 0 }}
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
            <p className="chart-description">1° giro include OS e Flash. Barre grigie = non specificato.</p>
            {bucketBreakdown.length === 0 ? (
              <div className="chart-empty">Nessun dato con numero di giri registrato.</div>
            ) : (
              <ResponsiveContainer width="100%" height={Math.max(200, bucketBreakdown.length * 30)}>
                <BarChart
                  data={bucketBreakdown.map(e => ({ ...e, label: ATTEMPT_BUCKET_LABELS[e.bucket] }))}
                  layout="vertical"
                  margin={{ top: 4, right: 24, left: 96, bottom: 0 }}
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
            <p className="chart-description">Distribuzione modale per fascia di tentativi.</p>
            {modeByAttempt.length === 0 ? (
              <div className="chart-empty">Nessun dato.</div>
            ) : (
              <ResponsiveContainer width="100%" height={Math.max(200, modeByAttempt.length * 30)}>
                <BarChart
                  data={modeByAttempt.map(e => ({ ...e, label: ATTEMPT_BUCKET_LABELS[e.bucket as AttemptBucket] ?? e.bucket }))}
                  layout="vertical"
                  margin={{ top: 4, right: 16, left: 96, bottom: 4 }}
                >
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                  <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                  <YAxis type="category" dataKey="label" tick={{ fontSize: 10 }} width={96} />
                  <Tooltip contentStyle={{ fontSize: 11, borderRadius: 8 }} />
                  <Legend wrapperStyle={{ fontSize: 11 }} />
                  <Bar dataKey="onsight"  name="On-sight"   stackId="a" fill="#1a6e2c" />
                  <Bar dataKey="flash"    name="Flash"      stackId="a" fill="#e07b00" />
                  <Bar dataKey="redpoint" name="Redpoint"   stackId="a" fill="#c0392b" />
                  <Bar dataKey="repeat"   name="Ripetizione" stackId="a" fill="#5a7ab8" />
                  <Bar dataKey="unknown"  name="Non spec."  stackId="a" fill="#aac0a7" radius={[0, 3, 3, 0]} />
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
              <div className="chart-empty">Nessun dato disponibile per i filtri selezionati.</div>
            ) : (
              <ResponsiveContainer width="100%" height={Math.max(160, topCrags.length * 32)}>
                <BarChart
                  data={topCrags}
                  layout="vertical"
                  margin={{ top: 4, right: 24, left: 8, bottom: 0 }}
                >
                  <CartesianGrid strokeDasharray="3 3" stroke="#f0f0e8" horizontal={false} />
                  <XAxis type="number" allowDecimals={false} tick={{ fontSize: 10 }} />
                  <YAxis type="category" dataKey="name" tick={{ fontSize: 10 }} width={110} />
                  <Tooltip
                    contentStyle={{ fontSize: 11, borderRadius: 8 }}
                    formatter={(v) => [v, 'Salite']}
                  />
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
    </div>
  )
}
