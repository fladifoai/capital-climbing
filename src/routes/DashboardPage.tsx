import { useMemo } from 'react'
import { Link } from 'react-router-dom'
import {
  ResponsiveContainer, LineChart, Line, XAxis, YAxis,
  CartesianGrid, Tooltip,
} from 'recharts'
import { useAuth } from '../features/auth/AuthContext'
import { useMyAscents } from '../features/logbook/hooks'
import { useMyProjects } from '../features/projects/hooks'
import { useMySessions } from '../features/sessions/hooks'
import { computeKpis, computeCumulativeMax, filterAscents } from '../analytics/metrics/ascents'
import { DEFAULT_FILTERS } from '../analytics/types'
import '../styles/analytics.css'
import '../styles/logbook.css'
import '../styles/users.css'

const ATTEMPT_LABELS: Record<string, string> = {
  onsight: 'On-sight', flash: 'Flash', redpoint: 'Redpoint',
  second: '2° giro', third: '3° giro', four_plus: '4° giro+',
  repeat: 'Ripetizione', unknown: '?',
}

const STYLE_COLORS: Record<string, string> = {
  onsight: '#1a6e2c', flash: '#c47800', redpoint: '#c0392b',
  second: '#c0392b', third: '#c0392b', four_plus: '#c0392b',
  repeat: '#5a7ab8',
}

function styleLabel(a: { ascent_style?: string | null; attempt_type?: string | null }) {
  const k = a.ascent_style ?? a.attempt_type ?? ''
  return ATTEMPT_LABELS[k] ?? k
}

function styleColor(a: { ascent_style?: string | null; attempt_type?: string | null }) {
  const k = a.ascent_style ?? a.attempt_type ?? ''
  return STYLE_COLORS[k] ?? 'var(--accent)'
}

export default function DashboardPage() {
  const { user } = useAuth()
  const { data: ascents = [], isLoading } = useMyAscents(user?.id ?? '')
  const { data: projects = [] } = useMyProjects(user?.id ?? '')
  const { data: sessions = [] } = useMySessions(user?.id ?? '')

  if (!user) return null

  const displayName = (user.user_metadata?.display_name as string | undefined) ?? user.email?.split('@')[0] ?? 'Climber'
  const currentYear = new Date().getFullYear()

  const kpis = useMemo(
    () => computeKpis(ascents, projects, sessions, DEFAULT_FILTERS),
    [ascents, projects, sessions]
  )

  const completed = useMemo(
    () => filterAscents(ascents, DEFAULT_FILTERS),
    [ascents]
  )

  const cumulativeMax = useMemo(() => computeCumulativeMax(completed), [completed])

  const chartData = useMemo(() =>
    cumulativeMax.slice(-24).map(p => ({
      date: p.date.slice(0, 7),
      grade: p.gradeValue,
      label: p.gradeLabel,
    })),
    [cumulativeMax]
  )

  const recentAscents = useMemo(
    () => completed.slice(0, 6),
    [completed]
  )

  const activeProjects = useMemo(
    () => projects.filter(p => p.status === 'active').slice(0, 5),
    [projects]
  )

  const lastAscent = completed[0]
  const lastSession = sessions[0]

  const kpiCards = [
    { value: kpis.totalAscents, label: 'Vie completate', sub: 'ascensioni registrate' },
    { value: kpis.bestRedpointLabel, label: 'Grado massimo', sub: 'miglior redpoint' },
    { value: kpis.bestOnsightLabel, label: 'Max On-sight', sub: 'vista-punta' },
    { value: kpis.bestFlashLabel, label: 'Max Flash', sub: 'a flash' },
    { value: `${kpis.osFlashPct}%`, label: 'OS + Flash', sub: 'del totale' },
    { value: kpis.totalCrags, label: 'Falesie', sub: 'visitate' },
    { value: kpis.activeProjects, label: 'Progetti attivi', sub: 'in corso' },
    { value: kpis.totalSessions, label: 'Sessioni', sub: 'tutte le uscite' },
  ]

  if (isLoading) {
    return (
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', minHeight: '60vh', color: 'var(--text-on-dark-muted)', fontSize: 14 }}>
        Caricamento…
      </div>
    )
  }

  return (
    <div className="analytics-page">

      {/* 1. Hero */}
      <div style={{
        background: 'linear-gradient(135deg, rgba(232,93,53,0.14), rgba(168,80,47,0.10))',
        border: '1px solid rgba(232,93,53,0.18)',
        borderRadius: 24,
        padding: '28px 32px',
        marginBottom: 24,
      }}>
        <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: 16, flexWrap: 'wrap' }}>
          <div>
            <h1 style={{
              fontFamily: '"Sora","Inter",system-ui,sans-serif',
              fontSize: 26, fontWeight: 900, color: 'var(--text-on-dark)',
              margin: '0 0 4px', letterSpacing: '-0.03em',
            }}>
              Ciao, {displayName} 👋
            </h1>
            <p style={{ fontSize: 14, color: 'var(--text-on-dark-muted)', margin: '0 0 16px' }}>
              {currentYear} · stagione in corso
            </p>
            {(lastAscent || lastSession) && (
              <div style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
                {lastAscent && (
                  <span style={{ fontSize: 13, color: 'var(--text-on-dark-muted)' }}>
                    Ultima salita:{' '}
                    <Link to={`/routes/${lastAscent.route?.id}`} style={{ color: 'var(--text-on-dark)', fontWeight: 700, textDecoration: 'none' }}>
                      {lastAscent.route?.name}
                    </Link>
                    {lastAscent.grade_at_ascent && <span style={{ marginLeft: 6 }} className="grade-badge">{lastAscent.grade_at_ascent}</span>}
                    {lastAscent.route?.sector?.crag?.name && (
                      <span style={{ marginLeft: 6, color: 'var(--text-on-dark-muted)' }}>· {lastAscent.route.sector.crag.name}</span>
                    )}
                  </span>
                )}
                {lastSession && (
                  <span style={{ fontSize: 13, color: 'var(--text-on-dark-muted)' }}>
                    Ultima sessione:{' '}
                    <strong style={{ color: 'var(--text-on-dark)' }}>{lastSession.date}</strong>
                    {lastSession.crag && <span style={{ marginLeft: 4 }}>· {lastSession.crag.name}</span>}
                  </span>
                )}
              </div>
            )}
            {!lastAscent && !lastSession && (
              <p style={{ fontSize: 13, color: 'var(--text-on-dark-muted)', margin: 0 }}>
                Nessuna attività registrata ancora.
              </p>
            )}
          </div>
          <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', alignItems: 'flex-start' }}>
            <Link to="/my-routes" style={{
              display: 'inline-flex', alignItems: 'center', gap: 6,
              height: 40, padding: '0 18px', borderRadius: 999,
              background: 'linear-gradient(135deg, #E85D35, #B83B20)',
              color: '#FFF7EA', fontSize: 13, fontWeight: 800,
              textDecoration: 'none', boxShadow: '0 4px 14px rgba(232,93,53,0.38)',
            }}>
              + Aggiungi ascensione
            </Link>
            <Link to="/projects" style={{
              display: 'inline-flex', alignItems: 'center', gap: 6,
              height: 40, padding: '0 16px', borderRadius: 999,
              border: '1px solid rgba(255,247,234,0.26)',
              background: 'rgba(255,247,234,0.06)',
              color: 'var(--text-on-dark)', fontSize: 13, fontWeight: 600,
              textDecoration: 'none',
            }}>
              Nuovo progetto
            </Link>
            <Link to="/admin/import" style={{
              display: 'inline-flex', alignItems: 'center', gap: 6,
              height: 40, padding: '0 16px', borderRadius: 999,
              border: '1px solid rgba(255,247,234,0.18)',
              background: 'rgba(255,247,234,0.04)',
              color: 'var(--text-on-dark-muted)', fontSize: 13, fontWeight: 600,
              textDecoration: 'none',
            }}>
              Importa dati
            </Link>
          </div>
        </div>
      </div>

      {/* 2. KPI grid */}
      {ascents.length > 0 ? (
        <div className="kpi-grid" style={{ marginBottom: 24 }}>
          {kpiCards.map(k => (
            <div key={k.label} className="kpi-card">
              <div className="kpi-value">{k.value}</div>
              <div className="kpi-label">{k.label}</div>
              <div className="kpi-sub">{k.sub}</div>
            </div>
          ))}
        </div>
      ) : (
        <div className="chart-section" style={{ marginBottom: 24, textAlign: 'center', padding: '36px 24px' }}>
          <div style={{ fontSize: 32, marginBottom: 12 }}>🧗</div>
          <h2 style={{ color: 'var(--text)', margin: '0 0 8px' }}>Nessuna ascensione ancora</h2>
          <p className="chart-description" style={{ marginBottom: 16 }}>
            Registra la tua prima salita o importa il tuo logbook per vedere le statistiche.
          </p>
          <div style={{ display: 'flex', gap: 10, justifyContent: 'center', flexWrap: 'wrap' }}>
            <Link to="/my-routes" className="btn-primary" style={{ textDecoration: 'none', display: 'inline-flex', alignItems: 'center' }}>
              + Aggiungi ascensione
            </Link>
            <Link to="/explore" style={{ color: 'var(--accent)', fontWeight: 600, textDecoration: 'none', fontSize: 13, display: 'inline-flex', alignItems: 'center' }}>
              Esplora il catalogo →
            </Link>
          </div>
        </div>
      )}

      {/* 3. Grafico progressione */}
      {chartData.length > 1 && (
        <div className="chart-section" style={{ marginBottom: 16 }}>
          <h2>Progressione gradi</h2>
          <p className="chart-description">Grado massimo raggiunto nel tempo.</p>
          <ResponsiveContainer width="100%" height={260}>
            <LineChart data={chartData} margin={{ top: 4, right: 8, bottom: 0, left: -16 }}>
              <CartesianGrid strokeDasharray="3 3" stroke="rgba(29,22,17,0.10)" />
              <XAxis dataKey="date" tick={{ fontSize: 11, fill: 'var(--text-muted)' }} tickLine={false} />
              <YAxis tick={{ fontSize: 11, fill: 'var(--text-muted)' }} tickLine={false} tickFormatter={v => {
                const entry = chartData.find(d => d.grade === v)
                return entry?.label ?? ''
              }} />
              <Tooltip
                content={({ active, payload }) => {
                  if (!active || !payload?.[0]) return null
                  const d = payload[0].payload
                  return (
                    <div className="chart-tooltip">
                      <div className="chart-tooltip-title">{d.label}</div>
                      <div className="chart-tooltip-date">{d.date}</div>
                    </div>
                  )
                }}
              />
              <Line
                type="stepAfter"
                dataKey="grade"
                stroke="#E85D35"
                strokeWidth={2.5}
                dot={{ r: 3, fill: '#E85D35' }}
                activeDot={{ r: 5 }}
                name="Grado max"
              />
            </LineChart>
          </ResponsiveContainer>
        </div>
      )}

      {/* 4+5. Ultime ascensioni + Progetti attivi */}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14, marginBottom: 14 }}>
        {/* Ultime ascensioni */}
        <div className="chart-section" style={{ marginBottom: 0 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 14 }}>
            <h2 style={{ margin: 0 }}>Ultime ascensioni</h2>
            <Link to="/my-routes" style={{ fontSize: 12, color: 'var(--accent)', textDecoration: 'none', fontWeight: 600 }}>
              Vedi tutte →
            </Link>
          </div>

          {recentAscents.length === 0 ? (
            <div style={{ textAlign: 'center', padding: '24px 0', color: 'var(--text-muted)', fontSize: 13 }}>
              Nessuna salita.{' '}
              <Link to="/my-routes" style={{ color: 'var(--accent)', fontWeight: 600 }}>Aggiungi →</Link>
            </div>
          ) : (
            <div style={{ display: 'flex', flexDirection: 'column', gap: 0 }}>
              {recentAscents.map((a, i) => (
                <div key={a.id} style={{
                  display: 'flex', alignItems: 'center', gap: 10, padding: '9px 0',
                  borderBottom: i < recentAscents.length - 1 ? '1px solid rgba(29,22,17,0.10)' : 'none',
                }}>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontWeight: 700, fontSize: 13, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap', color: 'var(--text)' }}>
                      <Link to={`/routes/${a.route?.id}`} style={{ color: 'inherit', textDecoration: 'none' }}>
                        {a.route?.name}
                      </Link>
                    </div>
                    <div style={{ fontSize: 11, color: 'var(--text-muted)', marginTop: 1 }}>
                      {a.route?.sector?.crag?.name} · {a.date}
                    </div>
                  </div>
                  {a.grade_at_ascent && (
                    <span className="grade-badge" style={{ flexShrink: 0 }}>{a.grade_at_ascent}</span>
                  )}
                  <span style={{ fontSize: 11, fontWeight: 800, color: styleColor(a as never), flexShrink: 0 }}>
                    {styleLabel(a as never)}
                  </span>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Progetti attivi */}
        <div className="chart-section" style={{ marginBottom: 0 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 14 }}>
            <h2 style={{ margin: 0 }}>Progetti attivi</h2>
            <Link to="/projects" style={{ fontSize: 12, color: 'var(--accent)', textDecoration: 'none', fontWeight: 600 }}>
              Vedi tutti →
            </Link>
          </div>

          {activeProjects.length === 0 ? (
            <div style={{ textAlign: 'center', padding: '24px 0', color: 'var(--text-muted)', fontSize: 13 }}>
              Nessun progetto attivo.{' '}
              <Link to="/projects" style={{ color: 'var(--accent)', fontWeight: 600 }}>Aggiungi →</Link>
            </div>
          ) : (
            <div style={{ display: 'flex', flexDirection: 'column', gap: 0 }}>
              {activeProjects.map((p, i) => (
                <div key={p.id} style={{
                  display: 'flex', alignItems: 'center', gap: 10, padding: '9px 0',
                  borderBottom: i < activeProjects.length - 1 ? '1px solid rgba(29,22,17,0.10)' : 'none',
                }}>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontWeight: 700, fontSize: 13, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap', color: 'var(--text)' }}>
                      <Link to={`/routes/${p.route?.id}`} style={{ color: 'inherit', textDecoration: 'none' }}>
                        {p.route?.name}
                      </Link>
                    </div>
                    <div style={{ fontSize: 11, color: 'var(--text-muted)', marginTop: 1 }}>
                      {p.route?.sector?.crag?.name} · {p.attempts_count} tent.
                    </div>
                    {p.next_strategy && (
                      <div style={{ fontSize: 11, color: 'var(--accent)', marginTop: 2, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                        → {p.next_strategy}
                      </div>
                    )}
                  </div>
                  {p.route?.official_grade && (
                    <span className="grade-badge" style={{ flexShrink: 0 }}>{p.route.official_grade}</span>
                  )}
                  {p.progress > 0 && (
                    <span style={{ fontSize: 11, color: 'var(--text-muted)', flexShrink: 0 }}>{p.progress}%</span>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* 6. Quick links */}
      <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap', marginTop: 8 }}>
        <Link to="/analytics" style={{ fontSize: 13, color: 'var(--accent)', fontWeight: 600, textDecoration: 'none' }}>
          → Analisi complete
        </Link>
        <Link to="/explore" style={{ fontSize: 13, color: 'var(--accent)', fontWeight: 600, textDecoration: 'none' }}>
          → Esplora falesie
        </Link>
        <Link to="/sessions" style={{ fontSize: 13, color: 'var(--accent)', fontWeight: 600, textDecoration: 'none' }}>
          → Sessioni
        </Link>
      </div>
    </div>
  )
}
