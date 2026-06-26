import { Navigate, Outlet } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'

export default function AdminGuard() {
  const { user, isAdmin, loading } = useAuth()

  if (loading) return (
    <div style={{ display: 'grid', placeItems: 'center', minHeight: '200px', color: '#6b7a67', fontSize: 14 }}>
      Caricamento…
    </div>
  )

  if (!user) return <Navigate to="/login" replace />
  if (!isAdmin) return <Navigate to="/dashboard" replace />

  return <Outlet />
}
