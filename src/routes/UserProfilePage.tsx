import { Link, useParams } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'
import {
  useProfile, usePublicAscents, usePublicProjects,
  useIsFollowing, useFollowCounts, useFollowUser, useUnfollowUser,
} from '../features/users/hooks'
import type { Profile } from '../types/database'
import '../styles/users.css'
import '../styles/catalog.css'

function initials(profile: Profile): string {
  const name = profile.display_name || profile.username
  return name.slice(0, 2).toUpperCase()
}

const ATTEMPT_LABELS: Record<string, string> = {
  onsight: 'OS', flash: 'FL', redpoint: 'RP', second: 'RP', third: 'RP', four_plus: 'RP',
  repeat: 'Rip', unknown: '?',
}

export default function UserProfilePage() {
  const { username = '' } = useParams()
  const { user } = useAuth()
  const { data: profile, isLoading, error } = useProfile(username)
  const { data: ascents } = usePublicAscents(profile?.id ?? '')
  const { data: projects } = usePublicProjects(profile?.id ?? '')
  const { data: counts } = useFollowCounts(profile?.id ?? '')
  const { data: isFollowing } = useIsFollowing(user?.id ?? '', profile?.id ?? '')
  const followUser = useFollowUser()
  const unfollowUser = useUnfollowUser()

  if (isLoading) return <div className="loading-state">Caricamento profilo…</div>
  if (error || !profile) return <div className="error-state">Utente non trovato.</div>

  const isOwnProfile = user?.id === profile.id

  const bestGrade = ascents?.reduce((best, a) => {
    const n = a.grade_numeric_at_ascent ?? 0
    return n > best ? n : best
  }, 0)

  function handleFollow() {
    if (!user) return
    if (isFollowing) {
      unfollowUser.mutate({ followerId: user.id, followingId: profile!.id })
    } else {
      followUser.mutate({ followerId: user.id, followingId: profile!.id })
    }
  }

  return (
    <div className="profile-page">
      <div className="profile-header-card">
        <div className="profile-header-top">
          <div className="profile-avatar-lg">
            {profile.avatar_url
              ? <img src={profile.avatar_url} alt={profile.display_name} />
              : initials(profile)
            }
          </div>
          <div className="profile-names">
            <h1 className="profile-display-name">{profile.display_name || profile.username}</h1>
            <div className="profile-username">@{profile.username}</div>
            {counts && (
              <div className="follow-counts">
                <span><strong>{counts.followers}</strong> follower</span>
                <span><strong>{counts.following}</strong> seguiti</span>
              </div>
            )}
          </div>
          {isOwnProfile ? (
            <Link to="/settings" className="btn-secondary" style={{ flexShrink: 0, textDecoration: 'none', display: 'inline-block', padding: '6px 14px', fontSize: 12 }}>
              Modifica profilo
            </Link>
          ) : user && (
            <button
              className={isFollowing ? 'follow-btn following' : 'follow-btn'}
              onClick={handleFollow}
              disabled={followUser.isPending || unfollowUser.isPending}
            >
              {isFollowing ? 'Stai seguendo' : '+ Segui'}
            </button>
          )}
        </div>

        {profile.bio && <p className="profile-bio">{profile.bio}</p>}

        <div className="profile-details">
          {profile.city && <span className="profile-detail-item">📍 {profile.city}{profile.country ? `, ${profile.country}` : ''}</span>}
          {profile.climbing_since && <span className="profile-detail-item">🧗 Dal {profile.climbing_since}</span>}
          {profile.preferred_style && <span className="profile-detail-item">🎯 {profile.preferred_style}</span>}
          {(ascents?.length ?? 0) > 0 && (
            <span className="profile-detail-item">✓ {ascents!.length} salite pubbliche</span>
          )}
        </div>
      </div>

      {/* Public ascents */}
      {(ascents?.length ?? 0) > 0 && (
        <div className="profile-section">
          <h2>Salite pubbliche {bestGrade && bestGrade > 0 ? `— max ${ascents?.find(a => (a.grade_numeric_at_ascent ?? 0) === bestGrade)?.grade_at_ascent ?? ''}` : ''}</h2>
          {ascents!.map(a => (
            <div key={a.id} className="profile-ascent-row">
              <div>
                <div className="profile-ascent-name">
                  <Link to={`/routes/${a.route?.id}`} style={{ color: 'inherit', textDecoration: 'none' }}>
                    {a.route?.name}
                  </Link>
                </div>
                <div className="profile-ascent-sub">
                  <Link to={`/crags/${a.route?.sector?.crag?.id}`} style={{ color: 'inherit', textDecoration: 'none' }}>
                    {a.route?.sector?.crag?.name}
                  </Link>
                  {a.route?.sector?.name ? ` › ${a.route.sector.name}` : ''}
                </div>
              </div>
              <div style={{ marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: 8, flexShrink: 0 }}>
                {(a.grade_at_ascent ?? a.route?.official_grade) && (
                  <span className="grade-badge">{a.grade_at_ascent ?? a.route?.official_grade}</span>
                )}
                {(a.ascent_style ?? a.attempt_type) && (
                  <span style={{ fontSize: 11, fontWeight: 700, color: '#2d5a27' }}>
                    {ATTEMPT_LABELS[a.ascent_style ?? a.attempt_type ?? ''] ?? (a.ascent_style ?? a.attempt_type)}
                  </span>
                )}
                <span className="profile-ascent-date">{a.date}</span>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Public projects */}
      {(projects?.length ?? 0) > 0 && (
        <div className="profile-section">
          <h2>Progetti in corso</h2>
          {projects!.map(p => (
            <div key={p.id} className="profile-ascent-row">
              <div>
                <div className="profile-ascent-name">
                  <Link to={`/routes/${p.route?.id}`} style={{ color: 'inherit', textDecoration: 'none' }}>
                    {p.route?.name}
                  </Link>
                </div>
                <div className="profile-ascent-sub">
                  <Link to={`/crags/${p.route?.sector?.crag?.id}`} style={{ color: 'inherit', textDecoration: 'none' }}>
                    {p.route?.sector?.crag?.name}
                  </Link>
                </div>
              </div>
              <div style={{ marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: 8, flexShrink: 0 }}>
                {p.route?.official_grade && <span className="grade-badge">{p.route.official_grade}</span>}
                {p.attempts_count > 0 && (
                  <span style={{ fontSize: 11, color: '#8a9a87' }}>{p.attempts_count} tent.</span>
                )}
                {p.progress > 0 && (
                  <span style={{ fontSize: 11, color: '#8a9a87' }}>{p.progress}%</span>
                )}
              </div>
            </div>
          ))}
        </div>
      )}

      {(ascents?.length ?? 0) === 0 && (projects?.length ?? 0) === 0 && (
        <div className="empty-state">
          {isOwnProfile
            ? 'Nessuna salita o progetto pubblico. Cambia la visibilità da "Le mie vie" o "Progetti".'
            : 'Nessuna attività pubblica.'}
        </div>
      )}
    </div>
  )
}
