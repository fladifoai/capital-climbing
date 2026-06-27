import { Link } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'
import { useMyAscents } from '../features/logbook/hooks'
import { useMyProjects } from '../features/projects/hooks'
import { useMySessions } from '../features/sessions/hooks'
import { useFeedAscents, type FeedAscent } from '../features/users/hooks'
import '../styles/analytics.css'
import '../styles/logbook.css'
import '../styles/users.css'

const ATTEMPT_LABELS: Record<string, string> = {
  onsight: 'OS', flash: 'FL', redpoint: 'RP', second: 'RP', third: 'RP', four_plus: 'RP',
  repeat: 'Rip', unknown: '?',
}

function feedInitials(a: FeedAscent): string {
  const name = a.profile?.display_name || a.profile?.username || '?'
  return name.slice(0, 2).toUpperCase()
}

export default function DashboardPage() {
  const { user } = useAuth()
  const { data: ascents, isLoading: loadingAscents } = useMyAscents(user?.id ?? '')
  const { data: projects } = useMyProjects(user?.id ?? '')
  const { data: sessions } = useMySessions(user?.id ?? '')
  const { data: feedAscents } = useFeedAscents(user?.id ?? '')

  if (!user) return null

  const displayName = (user.user_metadata?.display_name as string | undefined) ?? user.email ?? ''

  const currentYear = new Date().getFullYear()
  const yearAscents = (ascents ?? []).filter(a => a.status === 'completed' && a.date.startsWith(String(currentYear)))
  const allCompleted = (ascents ?? []).filter(a => a.status === 'completed')

  const bestGradeLabel = allCompleted.length > 0
    ? allCompleted.reduce((best, a) => {
        const n = a.grade_numeric_at_ascent ?? 0
        const bn = best.grade_numeric_at_ascent ?? 0
        return n > bn ? a : best
      }).grade_at_ascent ?? '?'
    : '—'

  const activeProjects = (projects ?? []).filter(p => p.status === 'active')
  const recentAscents = (ascents ?? []).filter(a => a.status === 'completed').slice(0, 5)
  const thisYearSessions = (sessions ?? []).filter(s => s.date.startsWith(String(currentYear)))

  return (
    <div className="analytics-page">
      <div style={{ marginBottom: 24 }}>
        <h1 style={{ fontFamily: '"Sora", "Inter", system-ui, sans-serif', fontSize: 22, fontWeight: 800, color: 'var(--text-on-dark)', margin: '0 0 4px', letterSpacing: '-0.02em' }}>
          Ciao, {displayName.split('@')[0]} 👋
        </h1>
        <p style={{ fontSize: 13, color: 'var(--text-on-dark-muted)', margin: 0 }}>{currentYear} · in progresso</p>
      </div>

      {/* Quick KPIs */}
      <div className="kpi-grid" style={{ marginBottom: 24 }}>
        <div className="kpi-card">
          <div className="kpi-value">{yearAscents.length}</div>
          <div className="kpi-label">Salite {currentYear}</div>
        </div>
        <div className="kpi-card">
          <div className="kpi-value">{bestGradeLabel}</div>
          <div className="kpi-label">Grado max</div>
        </div>
        <div className="kpi-card">
          <div className="kpi-value">{activeProjects.length}</div>
          <div className="kpi-label">Progetti attivi</div>
        </div>
        <div className="kpi-card">
          <div className="kpi-value">{thisYearSessions.length}</div>
          <div className="kpi-label">Sessioni {currentYear}</div>
        </div>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}>
        {/* Recent ascents */}
        <div className="chart-section" style={{ marginBottom: 0 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 }}>
            <h2 style={{ margin: 0 }}>Ultime salite</h2>
            <Link to="/my-routes" style={{ fontSize: 12, color: 'var(--accent)', textDecoration: 'none', fontWeight: 600 }}>
              Vedi tutte →
            </Link>
          </div>
          {loadingAscents && <div style={{ fontSize: 13, color: 'var(--text-muted)' }}>Caricamento…</div>}
          {!loadingAscents && recentAscents.length === 0 && (
            <div style={{ fontSize: 13, color: 'var(--text-muted)', textAlign: 'center', padding: '20px 0' }}>
              Nessuna salita ancora.{' '}
              <Link to="/explore" style={{ color: 'var(--accent)', fontWeight: 600 }}>Cerca vie →</Link>
            </div>
          )}
          {recentAscents.map(a => (
            <div key={a.id} style={{
              display: 'flex', alignItems: 'center', gap: 8, padding: '7px 0',
              borderBottom: '1px solid rgba(29,22,17,0.10)', fontSize: 13,
            }}>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontWeight: 600, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                  <Link to={`/routes/${a.route?.id}`} style={{ color: 'inherit', textDecoration: 'none' }}>
                    {a.route?.name}
                  </Link>
                </div>
                <div style={{ fontSize: 11, color: 'var(--text-muted)' }}>{a.date}</div>
              </div>
              {(a.grade_at_ascent ?? a.route?.official_grade) && (
                <span className="grade-badge">{a.grade_at_ascent ?? a.route?.official_grade}</span>
              )}
              {(a.ascent_style ?? a.attempt_type) && (
                <span style={{ fontSize: 11, fontWeight: 700, color: 'var(--accent)' }}>
                  {ATTEMPT_LABELS[a.ascent_style ?? a.attempt_type ?? ''] ?? (a.ascent_style ?? a.attempt_type)}
                </span>
              )}
            </div>
          ))}
        </div>

        {/* Active projects */}
        <div className="chart-section" style={{ marginBottom: 0 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 }}>
            <h2 style={{ margin: 0 }}>Progetti attivi</h2>
            <Link to="/projects" style={{ fontSize: 12, color: 'var(--accent)', textDecoration: 'none', fontWeight: 600 }}>
              Vedi tutti →
            </Link>
          </div>
          {activeProjects.length === 0 && (
            <div style={{ fontSize: 13, color: 'var(--text-muted)', textAlign: 'center', padding: '20px 0' }}>
              Nessun progetto attivo.{' '}
              <Link to="/projects" style={{ color: 'var(--accent)', fontWeight: 600 }}>Aggiungi →</Link>
            </div>
          )}
          {activeProjects.slice(0, 5).map(p => (
            <div key={p.id} style={{
              display: 'flex', alignItems: 'center', gap: 8, padding: '7px 0',
              borderBottom: '1px solid rgba(29,22,17,0.10)', fontSize: 13,
            }}>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontWeight: 600, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                  <Link to={`/routes/${p.route?.id}`} style={{ color: 'inherit', textDecoration: 'none' }}>
                    {p.route?.name}
                  </Link>
                </div>
                <div style={{ fontSize: 11, color: 'var(--text-muted)' }}>
                  {p.route?.sector?.crag?.name} · {p.attempts_count} tent.
                </div>
              </div>
              {p.route?.official_grade && (
                <span className="grade-badge">{p.route.official_grade}</span>
              )}
              {p.progress > 0 && (
                <span style={{ fontSize: 11, color: 'var(--text-muted)' }}>{p.progress}%</span>
              )}
            </div>
          ))}
        </div>
      </div>

      {/* Friend activity feed */}
      <div className="chart-section" style={{ marginTop: 16 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 }}>
          <h2 style={{ margin: 0 }}>Attività amici</h2>
          <Link to="/users" style={{ fontSize: 12, color: 'var(--accent)', textDecoration: 'none', fontWeight: 600 }}>
            Cerca utenti →
          </Link>
        </div>
        {(feedAscents?.length ?? 0) === 0 && (
          <div style={{ fontSize: 13, color: 'var(--text-muted)', textAlign: 'center', padding: '20px 0' }}>
            Nessuna attività. Segui altri arrampicatori per vedere le loro salite.
          </div>
        )}
        {feedAscents?.map(a => (
          <div key={a.id} className="feed-item">
            <div className="feed-avatar">
              {a.profile?.avatar_url
                ? <img src={a.profile.avatar_url} alt="" />
                : feedInitials(a)
              }
            </div>
            <div className="feed-body">
              <div className="feed-top">
                <Link to={`/users/${a.profile?.username}`} className="feed-username">
                  {a.profile?.display_name || a.profile?.username}
                </Link>
                <span className="feed-date">{a.date}</span>
              </div>
              <div className="feed-route">
                <Link to={`/routes/${a.route?.id}`} style={{ color: 'inherit', textDecoration: 'none', fontWeight: 600 }}>
                  {a.route?.name}
                </Link>
                {a.route?.sector?.crag?.name && (
                  <span className="feed-crag">@ {a.route.sector.crag.name}</span>
                )}
              </div>
              <div style={{ display: 'flex', gap: 8, alignItems: 'center', marginTop: 2 }}>
                {a.grade_at_ascent && <span className="grade-badge">{a.grade_at_ascent}</span>}
                {a.attempt_type && (
                  <span style={{ fontSize: 11, fontWeight: 700, color: 'var(--accent)' }}>
                    {ATTEMPT_LABELS[a.attempt_type] ?? a.attempt_type}
                  </span>
                )}
              </div>
            </div>
          </div>
        ))}
      </div>

      <div style={{ marginTop: 20, display: 'flex', gap: 10, flexWrap: 'wrap' }}>
        <Link to="/analytics" style={{ fontSize: 13, color: 'var(--accent)', fontWeight: 600, textDecoration: 'none' }}>
          → Analisi complete
        </Link>
        <Link to="/explore" style={{ fontSize: 13, color: 'var(--accent)', fontWeight: 600, textDecoration: 'none' }}>
          → Esplora falesie
        </Link>
        <Link to="/sessions" style={{ fontSize: 13, color: 'var(--accent)', fontWeight: 600, textDecoration: 'none' }}>
          → Aggiungi sessione
        </Link>
      </div>
    </div>
  )
}
