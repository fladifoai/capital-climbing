import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import CragForm from '../features/admin/CragForm'
import { useAdminCrags, useCreateCrag, useDeleteCrag, type CragFormValues } from '../features/admin/hooks'
import '../styles/admin.css'
import '../styles/catalog.css'

export default function AdminPage() {
  const navigate = useNavigate()
  const { data: crags, isLoading, error } = useAdminCrags()
  const createCrag = useCreateCrag()
  const deleteCrag = useDeleteCrag()

  const [creating, setCreating] = useState(false)
  const [actionError, setActionError] = useState('')

  async function handleCreate(values: CragFormValues) {
    setActionError('')
    try {
      await createCrag.mutateAsync(values)
      setCreating(false)
    } catch (e) {
      setActionError((e as Error).message)
    }
  }

  async function handleDelete(id: string, name: string) {
    if (!confirm(`Eliminare la falesia "${name}"? Verranno eliminati anche tutti i settori e le vie. L'operazione è irreversibile.`)) return
    setActionError('')
    try {
      await deleteCrag.mutateAsync(id)
    } catch (e) {
      setActionError((e as Error).message)
    }
  }

  return (
    <div className="admin-page">
      <div className="admin-header">
        <h1 className="admin-title">Amministrazione</h1>
        <div className="actions">
          <button className="btn-secondary" onClick={() => navigate('/admin/import-crag')}>Importa falesia</button>
          <button className="btn-secondary" onClick={() => navigate('/admin/import')}>Import catalogo CSV</button>
          <button className="btn-secondary" onClick={() => navigate('/admin/requests')}>Richieste falesia</button>
        </div>
      </div>

      <div className="admin-section">
        <div className="admin-section-header">
          <span className="admin-section-title">
            Falesie {crags ? `(${crags.length})` : ''}
          </span>
          {!creating && (
            <button className="btn-primary" onClick={() => { setCreating(true); setActionError('') }}>
              + Nuova falesia
            </button>
          )}
        </div>

        {creating && (
          <CragForm
            onSubmit={handleCreate}
            onCancel={() => { setCreating(false); setActionError('') }}
            isLoading={createCrag.isPending}
          />
        )}

        {actionError && <div className="admin-error">{actionError}</div>}

        {isLoading && <div className="loading-state">Caricamento falesie…</div>}
        {error && <div className="error-state">Errore nel caricamento delle falesie.</div>}

        {crags && crags.length === 0 && (
          <div className="empty-state">Nessuna falesia. Aggiungine una per iniziare.</div>
        )}

        {crags && crags.length > 0 && (
          <table className="admin-table">
            <thead>
              <tr>
                <th>Nome</th>
                <th>Regione</th>
                <th>Comune</th>
                <th>Accesso</th>
                <th>Azioni</th>
              </tr>
            </thead>
            <tbody>
              {crags.map((crag) => (
                <tr key={crag.id}>
                  <td style={{ fontWeight: 600 }}>{crag.name}</td>
                  <td style={{ color: 'var(--text-muted)' }}>{crag.region?.name ?? '—'}</td>
                  <td style={{ color: 'var(--text-muted)' }}>{crag.municipality ?? '—'}</td>
                  <td>
                    <span className={`access-badge ${crag.access_status}`}>
                      {crag.access_status === 'open' ? 'Aperta'
                        : crag.access_status === 'limited' ? 'Limitata'
                        : 'Chiusa'}
                    </span>
                  </td>
                  <td>
                    <div className="actions">
                      <button
                        className="btn-edit"
                        onClick={() => navigate(`/admin/crags/${crag.id}`)}
                      >
                        Gestisci →
                      </button>
                      <button
                        className="btn-danger"
                        onClick={() => handleDelete(crag.id, crag.name)}
                        disabled={deleteCrag.isPending}
                      >
                        Elimina
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  )
}
