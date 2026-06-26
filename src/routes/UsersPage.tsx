import { useState } from 'react'
import { Link } from 'react-router-dom'
import { useSearchUsers } from '../features/users/hooks'
import type { Profile } from '../types/database'
import '../styles/users.css'

function initials(profile: Profile): string {
  const name = profile.display_name || profile.username
  return name.slice(0, 2).toUpperCase()
}

function userMeta(profile: Profile): string {
  const parts: string[] = []
  if (profile.city) parts.push(profile.city)
  if (profile.country) parts.push(profile.country)
  if (profile.climbing_since) parts.push(`scala dal ${profile.climbing_since}`)
  return parts.join(' · ')
}

export default function UsersPage() {
  const [query, setQuery] = useState('')
  const { data: users, isLoading } = useSearchUsers(query)

  return (
    <div className="users-page">
      <h1>Utenti</h1>

      <div className="user-search-bar">
        <input
          value={query}
          onChange={e => setQuery(e.target.value)}
          placeholder="Cerca per nome utente…"
          autoComplete="off"
        />
      </div>

      {isLoading && <div className="loading-state">Ricerca…</div>}

      {!isLoading && users?.length === 0 && (
        <div className="empty-state">Nessun utente trovato.</div>
      )}

      {users?.map(u => (
        <Link key={u.id} to={`/u/${u.username}`} className="user-card">
          <div className="user-avatar">
            {u.avatar_url
              ? <img src={u.avatar_url} alt={u.display_name} />
              : initials(u)
            }
          </div>
          <div className="user-info">
            <div className="user-display-name">{u.display_name || u.username}</div>
            <div className="user-username">@{u.username}</div>
            {userMeta(u) && <div className="user-meta">{userMeta(u)}</div>}
          </div>
          {u.preferred_style && (
            <span style={{ fontSize: 11, color: '#8a9a87', flexShrink: 0 }}>{u.preferred_style}</span>
          )}
        </Link>
      ))}
    </div>
  )
}
