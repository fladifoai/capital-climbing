import { useState } from 'react'
import { Link, useNavigate, useParams } from 'react-router-dom'
import { useCrag } from '../features/catalog/hooks'
import CragForm from '../features/admin/CragForm'
import SectorsAdmin from '../features/admin/SectorsAdmin'
import { useUpdateCrag, useDeleteCrag, type CragFormValues } from '../features/admin/hooks'
import '../styles/admin.css'
import '../styles/catalog.css'

export default function AdminCragPage() {
  const { cragId } = useParams<{ cragId: string }>()
  const navigate = useNavigate()

  const { data: crag, isLoading, error } = useCrag(cragId!)
  const updateCrag = useUpdateCrag()
  const deleteCrag = useDeleteCrag()

  const [editingCrag, setEditingCrag] = useState(false)
  const [saveError, setSaveError] = useState('')

  async function handleUpdateCrag(values: CragFormValues) {
    setSaveError('')
    try {
      await updateCrag.mutateAsync({ id: cragId!, values })
      setEditingCrag(false)
    } catch (e) {
      setSaveError((e as Error).message)
    }
  }

  async function handleDeleteCrag() {
    if (!confirm(`Eliminare la falesia "${crag?.name}"? Verranno eliminati anche tutti i settori e le vie. L'operazione è irreversibile.`)) return
    try {
      await deleteCrag.mutateAsync(cragId!)
      navigate('/admin')
    } catch (e) {
      setSaveError((e as Error).message)
    }
  }

  if (isLoading) return <div className="loading-state">Caricamento…</div>
  if (error || !crag) return <div className="error-state">Falesia non trovata.</div>

  return (
    <div className="admin-page">
      <div className="breadcrumb">
        <Link to="/admin">Admin</Link>
        <span className="breadcrumb-sep">›</span>
        <span>{crag.name}</span>
      </div>

      {/* Crag info */}
      <div className="admin-section">
        <div className="admin-section-header">
          <span className="admin-section-title">Falesia: {crag.name}</span>
          {!editingCrag && (
            <div className="actions" style={{ display: 'flex', gap: 8 }}>
              <button className="btn-edit" onClick={() => setEditingCrag(true)}>Modifica info</button>
              <button className="btn-danger" onClick={handleDeleteCrag}>Elimina falesia</button>
            </div>
          )}
        </div>

        {saveError && <div className="admin-error">{saveError}</div>}

        {editingCrag ? (
          <CragForm
            defaultValues={{
              name: crag.name,
              region_id: crag.region_id ?? '',
              area_id: crag.area_id,
              municipality: crag.municipality,
              province: crag.province,
              latitude: crag.latitude,
              longitude: crag.longitude,
              altitude_m: crag.altitude_m,
              rock_type: crag.rock_type,
              access_status: crag.access_status,
              approach_minutes: crag.approach_minutes,
              orientation: crag.orientation,
              rainproof: crag.rainproof,
              access_notes: crag.access_notes,
              parking_notes: crag.parking_notes,
            }}
            onSubmit={handleUpdateCrag}
            onCancel={() => { setEditingCrag(false); setSaveError('') }}
            isLoading={updateCrag.isPending}
          />
        ) : (
          <div className="crag-header-card">
            <div className="crag-meta-row">
              {crag.region && <span className="crag-meta-item"><span className="crag-meta-label">Regione:</span> {crag.region}</span>}
              {crag.municipality && <span className="crag-meta-item"><span className="crag-meta-label">Comune:</span> {crag.municipality}</span>}
              {crag.rock_type && <span className="crag-meta-item"><span className="crag-meta-label">Roccia:</span> {crag.rock_type}</span>}
              {crag.altitude_m && <span className="crag-meta-item"><span className="crag-meta-label">Alt.:</span> {crag.altitude_m}m</span>}
              {crag.approach_minutes && <span className="crag-meta-item"><span className="crag-meta-label">Avvic.:</span> {crag.approach_minutes} min</span>}
              <span className="crag-meta-item">
                <span className={`access-badge ${crag.access_status}`}>{crag.access_status}</span>
              </span>
              {crag.rainproof && <span className="crag-meta-item" style={{ color: 'var(--accent)' }}>Pioggia OK</span>}
            </div>
          </div>
        )}
      </div>

      {/* Sectors + routes */}
      <SectorsAdmin cragId={cragId!} />
    </div>
  )
}
