import { Navigate, Outlet } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'

export default function AuthGuard() {
  const { user, loading } = useAuth()

  if (loading) return (
    <div style={{ display: 'grid', placeItems: 'center', minHeight: '100vh', color: 'var(--text-on-dark-muted)', fontSize: 14 }}>
      Caricamento…
    </div>
  )

  if (!user) return <Navigate to="/login" replace />

  return <Outlet />
}
