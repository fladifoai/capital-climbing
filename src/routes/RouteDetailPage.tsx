import { useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { useRoute } from '../features/catalog/hooks'
import { useAuth } from '../features/auth/AuthContext'
import { useCreateAscent, type AscentFormValues, type RouteSearchResult } from '../features/logbook/hooks'
import AscentForm from '../features/logbook/AscentForm'
import '../styles/catalog.css'
import '../styles/admin.css'
import '../styles/logbook.css'

export default function RouteDetailPage() {
  const { routeId = '' } = useParams()
  const { user } = useAuth()
  const { data: route, isLoading, error } = useRoute(routeId)
  const createAscent = useCreateAscent()

  const [adding, setAdding] = useState(false)
  const [done, setDone] = useState(false)
  const [saveError, setSaveError] = useState('')

  if (isLoading) return <div className="loading-state">Caricamento via…</div>
  if (error || !route) return <div className="error-state">Via non trovata.</div>

  const preselected: RouteSearchResult = {
    id: route.id,
    name: route.name,
    official_grade: route.official_grade,
    grade_numeric: route.grade_numeric,
    route_type: route.route_type,
    sector_name: route.sector?.name ?? '',
    crag_name: route.sector?.crag?.name ?? '',
  }

  async function handleSubmit(values: AscentFormValues) {
    if (!user) return
    setSaveError('')
    try {
      await createAscent.mutateAsync({ userId: user.id, values })
      setAdding(false)
      setDone(true)
    } catch (e) {
      setSaveError((e as Error).message)
    }
  }

  return (
    <div className="catalog-page">
      <nav className="breadcrumb">
        <Link to="/explore">Falesie</Link>
        {route.sector?.crag && (
          <>
            <span className="breadcrumb-sep">›</span>
            <Link to={`/crags/${route.sector.crag.id}`}>{route.sector.crag.name}</Link>
          </>
        )}
        {route.sector && (
          <>
            <span className="breadcrumb-sep">›</span>
            <span>{route.sector.name}</span>
          </>
        )}
        <span className="breadcrumb-sep">›</span>
        <span>{route.name}</span>
      </nav>

      <div className="crag-header-card">
        <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: 16 }}>
          <div>
            <h1 className="crag-name">{route.name}</h1>
            <div className="crag-meta-row" style={{ marginTop: 10 }}>
              {route.official_grade && (
                <div className="crag-meta-item">
                  <span className="grade-badge" style={{ fontSize: 16, padding: '4px 12px' }}>
                    {route.official_grade}
                  </span>
                </div>
              )}
              {route.route_type && (
                <div className="crag-meta-item">
                  <span className="crag-meta-label">Tipo:</span> {route.route_type}
                </div>
              )}
              {route.length_m && (
                <div className="crag-meta-item">
                  <span className="crag-meta-label">Lunghezza:</span> {route.length_m} m
                </div>
              )}
              {route.bolts && (
                <div className="crag-meta-item">
                  <span className="crag-meta-label">Spit:</span> {route.bolts}
                </div>
              )}
              {route.pitches > 1 && (
                <div className="crag-meta-item">
                  <span className="crag-meta-label">Tiri:</span> {route.pitches}
                </div>
              )}
              {route.angle && (
                <div className="crag-meta-item">
                  <span className="crag-meta-label">Angolo:</span> {route.angle}
                </div>
              )}
              {route.first_ascent && (
                <div className="crag-meta-item">
                  <span className="crag-meta-label">Prima salita:</span> {route.first_ascent}
                </div>
              )}
            </div>
          </div>

          {user && !done && (
            <button
              className="btn-primary"
              style={{ whiteSpace: 'nowrap', flexShrink: 0 }}
              onClick={() => { setAdding(a => !a); setSaveError('') }}
            >
              {adding ? '✕ Annulla' : '+ Registra ascensione'}
            </button>
          )}
        </div>

        {done && (
          <div style={{ marginTop: 16, padding: '10px 14px', background: '#e8f5e4', borderRadius: 6, fontSize: 13, color: '#2d5a27', fontWeight: 600 }}>
            ✓ Ascensione registrata!{' '}
            <button
              style={{ background: 'none', border: 'none', color: '#2d5a27', cursor: 'pointer', fontWeight: 600, textDecoration: 'underline', fontSize: 13 }}
              onClick={() => setDone(false)}
            >
              Aggiungine un'altra
            </button>
          </div>
        )}
      </div>

      {route.description && (
        <div style={{ background: '#fff', border: '1px solid #e0e0d8', borderRadius: 10, padding: '16px 20px', marginBottom: 16, fontSize: 13, color: '#4a5a48', lineHeight: 1.6 }}>
          {route.description}
        </div>
      )}

      {adding && (
        <div style={{ marginBottom: 16 }}>
          {saveError && <div className="admin-error" style={{ marginBottom: 12 }}>{saveError}</div>}
          <AscentForm
            preselectedRoute={preselected}
            onSubmit={handleSubmit}
            onCancel={() => { setAdding(false); setSaveError('') }}
            isLoading={createAscent.isPending}
          />
        </div>
      )}

      {!user && (
        <div style={{ textAlign: 'center', padding: '20px', color: '#8a9a87', fontSize: 13 }}>
          <Link to="/login" style={{ color: '#2d5a27', fontWeight: 600 }}>Accedi</Link> per registrare un'ascensione su questa via.
        </div>
      )}
    </div>
  )
}
