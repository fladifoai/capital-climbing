import { Navigate } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'

export default function AuthGuard({ children }: { children: React.ReactNode }) {
  const { user, loading } = useAuth()

  if (loading) return (
    <div style={{ display: 'grid', placeItems: 'center', minHeight: '100vh', color: '#6b7a67', fontSize: 14 }}>
      Caricamento…
    </div>
  )

  if (!user) return <Navigate to="/login" replace />

  return <>{children}</>
}
