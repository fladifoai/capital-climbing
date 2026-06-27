import { useMemo } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'
import { useMyAscents } from '../features/logbook/hooks'
import { useMyProjects } from '../features/projects/hooks'
import { useMySessions } from '../features/sessions/hooks'
import { filterAscents } from '../analytics/metrics/ascents'
import { DEFAULT_FILTERS } from '../analytics/types'
import { demoRecentAscents, demoActiveProjects } from '../data/demoLandingData'
import '../styles/analytics.css'
import '../styles/logbook.css'

const QUICK_ACTIONS = [
  { label: 'Esplora falesie', desc: 'Cerca falesie, settori e vie nel catalogo', to: '/explore', icon: '🗺️', accent: false },
  { label: 'Nuova sessione', desc: 'Registra una uscita in falesia', to: '/sessions', icon: '📅', accent: false },
  { label: '+ Ascensione', desc: 'Aggiungi una via salita', to: '/my-routes', icon: '🧗', accent: true },
  { label: 'Apri progetto', desc: 'Monitora un progetto attivo', to: '/projects', icon: '🎯', accent: false },
  { label: 'Analisi', desc: 'Grafici, gradi, progressione', to: '/analytics', icon: '📊', accent: false },
  { label: 'Profilo', desc: 'Impostazioni e account', to: '/settings', icon: '👤', accent: false },
]

const STYLE_COLORS: Record<string, string> = {
  'On-sight': '#28B487',
  'Flash': '#4C9BE8',
  'Redpoint': '#D9902F',
}

export default function HomePage() {
  const { user } = useAuth()
  const { data: ascents = [] } = useMyAscents(user?.id ?? '')
  const { data: projects = [] } = useMyProjects(user?.id ?? '')
  const { data: sessions = [] } = useMySessions(user?.id ?? '')

  const displayName = (user?.user_metadata?.display_name as string | undefined) ?? user?.email?.split('@')[0]

  const completed = useMemo(() => filterAscents(ascents, DEFAULT_FILTERS), [ascents])
  const recentAscents = useMemo(() => completed.slice(0, 5), [completed])
  const activeProjects = useMemo(() => projects.filter(p => p.status === 'active').slice(0, 3), [projects])
  const lastSession = sessions[0]

  const isLoggedIn = !!user

  return (
    <div className="analytics-page">

      {/* Header */}
      <div style={{
        background: 'linear-gradient(135deg, rgba(200,95,58,0.14), rgba(168,80,47,0.08))',
        border: '1px solid rgba(200,95,58,0.20)',
        borderRadius: 24,
        padding: '28px 32px',
        marginBottom: 24,
      }}>
        <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: 16, flexWrap: 'wrap' }}>
          <div>
            <h1 style={{
              fontFamily: '"Sora","Inter",system-ui,sans-serif',
              fontSize: 26, fontWeight: 900,
              color: 'var(--text-on-dark)',
              margin: '0 0 6px', letterSpacing: '-0.03em',
            }}>
              {isLoggedIn
                ? `Bentornato${displayName ? `, ${displayName}` : ''}`
                : 'Bentornato in Capital Climbing'}
            </h1>
            <p style={{ fontSize: 14, color: 'var(--text-on-dark-muted)', margin: 0 }}>
              {isLoggedIn
                ? lastSession
                  ? `Ultima sessione: ${lastSession.date}${lastSession.crag ? ` · ${lastSession.crag.name}` : ''}`
                  : 'Nessuna sessione registrata ancora.'
                : 'Esplora il catalogo o accedi per tracciare le tue salite.'}
            </p>
          </div>
          {!isLoggedIn && (
            <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
              <Link to="/register" style={{
                display: 'inline-flex', alignItems: 'center', height: 40, padding: '0 18px',
                borderRadius: 999,
                background: 'linear-gradient(135deg, #C85F3A, #A8502F)',
                color: '#FFF7EA', fontSize: 13, fontWeight: 800,
                textDecoration: 'none',
                boxShadow: '0 4px 14px rgba(200,95,58,0.38)',
              }}>
                Inizia ora
              </Link>
              <Link to="/login" style={{
                display: 'inline-flex', alignItems: 'center', height: 40, padding: '0 16px',
                borderRadius: 999,
                border: '1px solid rgba(255,247,234,0.26)',
                background: 'rgba(255,247,234,0.06)',
                color: 'var(--text-on-dark)', fontSize: 13, fontWeight: 600,
                textDecoration: 'none',
              }}>
                Accedi
              </Link>
            </div>
          )}
        </div>
      </div>

      {/* Quick actions */}
      <div style={{ marginBottom: 24 }}>
        <h2 style={{ fontSize: 14, fontWeight: 700, color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '0.08em', margin: '0 0 12px' }}>
          Azioni rapide
        </h2>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 10 }}>
          {QUICK_ACTIONS.map(a => (
            <Link
              key={a.to}
              to={!isLoggedIn && a.to !== '/explore' ? '/login' : a.to}
              style={{
                display: 'flex', alignItems: 'center', gap: 14,
                padding: '16px 18px', borderRadius: 16,
                background: a.accent
                  ? 'linear-gradient(135deg, rgba(200,95,58,0.18), rgba(168,80,47,0.12))'
                  : 'rgba(255,247,234,0.05)',
                border: a.accent
                  ? '1px solid rgba(200,95,58,0.32)'
                  : '1px solid rgba(255,247,234,0.09)',
                textDecoration: 'none',
                transition: 'background 0.15s, border-color 0.15s, transform 0.15s',
              }}
              onMouseEnter={e => { (e.currentTarget as HTMLElement).style.transform = 'translateY(-2px)' }}
              onMouseLeave={e => { (e.currentTarget as HTMLElement).style.transform = 'none' }}
            >
              <span style={{ fontSize: 22, lineHeight: 1, flexShrink: 0 }}>{a.icon}</span>
              <div>
                <div style={{ fontSize: 14, fontWeight: 700, color: a.accent ? 'var(--accent)' : 'var(--text-on-dark)', marginBottom: 2 }}>
                  {a.label}
                </div>
                <div style={{ fontSize: 11, color: 'var(--text-muted)', lineHeight: 1.4 }}>{a.desc}</div>
              </div>
            </Link>
          ))}
        </div>
      </div>

      {/* Recent ascents + active projects */}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 14, marginBottom: 14 }}>

        {/* Ultime ascensioni */}
        <div className="chart-section" style={{ marginBottom: 0 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 14 }}>
            <h2 style={{ margin: 0 }}>Ultime ascensioni</h2>
            {isLoggedIn && (
              <Link to="/my-routes" style={{ fontSize: 12, color: 'var(--accent)', textDecoration: 'none', fontWeight: 600 }}>
                Vedi tutte →
              </Link>
            )}
          </div>

          {isLoggedIn ? (
            recentAscents.length === 0 ? (
              <div style={{ textAlign: 'center', padding: '24px 0', color: 'var(--text-muted)', fontSize: 13 }}>
                Nessuna salita.{' '}
                <Link to="/my-routes" style={{ color: 'var(--accent)', fontWeight: 600 }}>Aggiungi →</Link>
              </div>
            ) : (
              <div style={{ display: 'flex', flexDirection: 'column' }}>
                {recentAscents.map((a, i) => (
                  <div key={a.id} style={{
                    display: 'flex', alignItems: 'center', gap: 10, padding: '9px 0',
                    borderBottom: i < recentAscents.length - 1 ? '1px solid rgba(247,243,234,0.10)' : 'none',
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
                  </div>
                ))}
              </div>
            )
          ) : (
            <div>
              {demoRecentAscents.map((a, i) => (
                <div key={a.name} style={{
                  display: 'flex', alignItems: 'center', gap: 10, padding: '9px 0',
                  borderBottom: i < demoRecentAscents.length - 1 ? '1px solid rgba(247,243,234,0.10)' : 'none',
                  opacity: 0.6,
                  filter: 'blur(0.5px)',
                }}>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontWeight: 700, fontSize: 13, color: 'var(--text)' }}>{a.name}</div>
                    <div style={{ fontSize: 11, color: 'var(--text-muted)', marginTop: 1 }}>{a.crag}</div>
                  </div>
                  <span className="grade-badge" style={{ flexShrink: 0 }}>{a.grade}</span>
                  <span style={{ fontSize: 11, fontWeight: 800, color: STYLE_COLORS[a.style] ?? 'var(--accent)', flexShrink: 0 }}>{a.style}</span>
                </div>
              ))}
              <div style={{ textAlign: 'center', marginTop: 14 }}>
                <Link to="/login" style={{ fontSize: 13, color: 'var(--accent)', fontWeight: 600, textDecoration: 'none' }}>
                  Accedi per vedere le tue ascensioni →
                </Link>
              </div>
            </div>
          )}
        </div>

        {/* Progetti attivi */}
        <div className="chart-section" style={{ marginBottom: 0 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 14 }}>
            <h2 style={{ margin: 0 }}>Progetti attivi</h2>
            {isLoggedIn && (
              <Link to="/projects" style={{ fontSize: 12, color: 'var(--accent)', textDecoration: 'none', fontWeight: 600 }}>
                Vedi tutti →
              </Link>
            )}
          </div>

          {isLoggedIn ? (
            activeProjects.length === 0 ? (
              <div style={{ textAlign: 'center', padding: '24px 0', color: 'var(--text-muted)', fontSize: 13 }}>
                Nessun progetto attivo.{' '}
                <Link to="/projects" style={{ color: 'var(--accent)', fontWeight: 600 }}>Aggiungi →</Link>
              </div>
            ) : (
              <div style={{ display: 'flex', flexDirection: 'column' }}>
                {activeProjects.map((p, i) => (
                  <div key={p.id} style={{
                    display: 'flex', alignItems: 'center', gap: 10, padding: '9px 0',
                    borderBottom: i < activeProjects.length - 1 ? '1px solid rgba(247,243,234,0.10)' : 'none',
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
                    </div>
                    {p.route?.official_grade && (
                      <span className="grade-badge" style={{ flexShrink: 0 }}>{p.route.official_grade}</span>
                    )}
                  </div>
                ))}
              </div>
            )
          ) : (
            <div>
              {demoActiveProjects.map((p, i) => (
                <div key={p.name} style={{
                  display: 'flex', alignItems: 'center', gap: 10, padding: '9px 0',
                  borderBottom: i < demoActiveProjects.length - 1 ? '1px solid rgba(247,243,234,0.10)' : 'none',
                  opacity: 0.6,
                  filter: 'blur(0.5px)',
                }}>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontWeight: 700, fontSize: 13, color: 'var(--text)' }}>{p.name}</div>
                    <div style={{ fontSize: 11, color: 'var(--text-muted)', marginTop: 1 }}>{p.crag} · {p.attempts} tent.</div>
                  </div>
                  <span className="grade-badge" style={{ flexShrink: 0 }}>{p.grade}</span>
                </div>
              ))}
              <div style={{ textAlign: 'center', marginTop: 14 }}>
                <Link to="/login" style={{ fontSize: 13, color: 'var(--accent)', fontWeight: 600, textDecoration: 'none' }}>
                  Accedi per i tuoi progetti →
                </Link>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Footer links */}
      <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap', marginTop: 8 }}>
        <Link to="/explore" style={{ fontSize: 13, color: 'var(--accent)', fontWeight: 600, textDecoration: 'none' }}>
          → Esplora il catalogo
        </Link>
        {isLoggedIn && (
          <>
            <Link to="/analytics" style={{ fontSize: 13, color: 'var(--accent)', fontWeight: 600, textDecoration: 'none' }}>
              → Analisi complete
            </Link>
            <Link to="/sessions" style={{ fontSize: 13, color: 'var(--accent)', fontWeight: 600, textDecoration: 'none' }}>
              → Sessioni
            </Link>
            <Link to="/dashboard" style={{ fontSize: 13, color: 'var(--text-muted)', fontWeight: 600, textDecoration: 'none' }}>
              → Dashboard KPI
            </Link>
          </>
        )}
      </div>
    </div>
  )
}
