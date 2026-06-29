import { NavLink, Outlet, Link, useNavigate, useLocation } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'
import ErrorBoundary from './ErrorBoundary'
import './Layout.css'

const publicNavItems = [
  { to: '/explore', label: 'Falesie' },
]

const privateNavItems = [
  { to: '/dashboard', label: 'Dashboard' },
  { to: '/log/new', label: '+ Nuova salita' },
  { to: '/explore', label: 'Falesie' },
  { to: '/sessions', label: 'Sessioni' },
  { to: '/logbook/import', label: 'Importa logbook' },
  { to: '/projects', label: 'Progetti' },
  { to: '/profile', label: 'Il mio profilo' },
  { to: '/analytics', label: 'Analisi' },
  { to: '/settings', label: 'Impostazioni' },
]

const adminNavItems = [
  { to: '/admin', label: 'Admin' },
]

export default function Layout() {
  const { user, isAdmin, signOut } = useAuth()
  const navigate = useNavigate()
  const { pathname } = useLocation()

  async function handleSignOut() {
    await signOut()
    navigate('/login')
  }

  const displayName = user?.user_metadata?.display_name as string | undefined
  const label = displayName ?? user?.email ?? ''

  const navItems = user
    ? [...privateNavItems, ...(isAdmin ? adminNavItems : [])]
    : publicNavItems

  return (
    <div className="layout">
      <aside className="sidebar">
        <Link to={user ? '/dashboard' : '/'} className="brand" style={{ textDecoration: 'none' }} aria-label={user ? 'Vai alla dashboard' : 'Capital Climbing — home'}>
          <span className="brandmark">▲</span>
          <span className="brand-name">Capital Climbing</span>
        </Link>
        <nav>
          {navItems.map(({ to, label: navLabel }) => (
            <NavLink
              key={to}
              to={to}
              className={({ isActive }) => isActive ? 'nav-link active' : 'nav-link'}
            >
              {navLabel}
            </NavLink>
          ))}
        </nav>
        <div className="sidebar-footer">
          {user ? (
            <>
              <span className="sidebar-user">{label}</span>
              <button className="btn-signout" onClick={handleSignOut}>Esci</button>
            </>
          ) : (
            <Link to="/login" className="btn-signout" style={{ textAlign: 'center', display: 'block' }}>
              Accedi
            </Link>
          )}
        </div>
      </aside>
      <main className="main">
        <ErrorBoundary key={pathname}>
          <Outlet />
        </ErrorBoundary>
      </main>
    </div>
  )
}
