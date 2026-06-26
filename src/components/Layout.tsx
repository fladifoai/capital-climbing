import { NavLink, Outlet, useNavigate } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'
import './Layout.css'

const navItems = [
  { to: '/dashboard', label: 'Dashboard' },
  { to: '/explore', label: 'Esplora' },
  { to: '/my-routes', label: 'Le mie vie' },
  { to: '/sessions', label: 'Sessioni' },
  { to: '/projects', label: 'Progetti' },
  { to: '/analytics', label: 'Analisi' },
  { to: '/users', label: 'Utenti' },
  { to: '/settings', label: 'Impostazioni' },
  { to: '/admin', label: 'Admin' },
]

export default function Layout() {
  const { user, signOut } = useAuth()
  const navigate = useNavigate()

  async function handleSignOut() {
    await signOut()
    navigate('/login')
  }

  const displayName = user?.user_metadata?.display_name as string | undefined
  const label = displayName ?? user?.email ?? ''

  return (
    <div className="layout">
      <aside className="sidebar">
        <div className="brand">
          <span className="brandmark">▲</span>
          <span className="brand-name">Capital Climbing</span>
        </div>
        <nav>
          {navItems.map(({ to, label }) => (
            <NavLink
              key={to}
              to={to}
              className={({ isActive }) => isActive ? 'nav-link active' : 'nav-link'}
            >
              {label}
            </NavLink>
          ))}
        </nav>
        <div className="sidebar-footer">
          <span className="sidebar-user">{label}</span>
          <button className="btn-signout" onClick={handleSignOut}>Esci</button>
        </div>
      </aside>
      <main className="main">
        <Outlet />
      </main>
    </div>
  )
}
