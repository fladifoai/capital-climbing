import { NavLink, Outlet } from 'react-router-dom'
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
  return (
    <div className="layout">
      <aside className="sidebar">
        <div className="brand">
          <span className="brandmark">▲</span>
          <span className="brand-name">ClimbTrack</span>
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
      </aside>
      <main className="main">
        <Outlet />
      </main>
    </div>
  )
}
