import { useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'
import { useMyAscents, useCreateAscent, useDeleteAscent, type AscentFormValues } from '../features/logbook/hooks'
import AscentForm from '../features/logbook/AscentForm'
import '../styles/admin.css'
import '../styles/catalog.css'
import '../styles/logbook.css'

const ATTEMPT_LABELS: Record<string, string> = {
  onsight: 'On-sight',
  flash: 'Flash',
  second: '2° giro',
  third: '3° giro',
  four_plus: '4+',
}

export default function MyRoutesPage() {
  const { user } = useAuth()
  const { data: ascents, isLoading, error } = useMyAscents(user?.id ?? '')
  const createAscent = useCreateAscent()
  const deleteAscent = useDeleteAscent()

  const [adding, setAdding] = useState(false)
  const [actionError, setActionError] = useState('')

  async function handleCreate(values: AscentFormValues) {
    if (!user) return
    setActionError('')
    try {
      await createAscent.mutateAsync({ userId: user.id, values })
      setAdding(false)
    } catch (e) {
      setActionError((e as Error).message)
    }
  }

  async function handleDelete(id: string, name: string) {
    if (!user) return
    if (!confirm(`Eliminare l'ascensione su "${name}"?`)) return
    try {
      await deleteAscent.mutateAsync({ id, userId: user.id })
    } catch (e) {
      setActionError((e as Error).message)
    }
  }

  return (
    <div className="logbook-page">
      <div className="logbook-header">
        <h1 className="logbook-title">Le mie vie</h1>
        {!adding && (
          <button className="btn-primary" onClick={() => { setAdding(true); setActionError('') }}>
            + Nuova ascensione
          </button>
        )}
      </div>

      {adding && (
        <AscentForm
          onSubmit={handleCreate}
          onCancel={() => { setAdding(false); setActionError('') }}
          isLoading={createAscent.isPending}
        />
      )}

      {actionError && <div className="admin-error">{actionError}</div>}

      {isLoading && <div className="loading-state">Caricamento…</div>}
      {error && <div className="error-state">Errore nel caricamento delle ascensioni.</div>}

      {ascents && ascents.length === 0 && !adding && (
        <div className="empty-state">
          Nessuna ascensione registrata. Aggiungi la prima!
        </div>
      )}

      {ascents && ascents.length > 0 && (
        <table className="ascent-table">
          <thead>
            <tr>
              <th>Data</th>
              <th>Via</th>
              <th>Falesia › Settore</th>
              <th>Grado</th>
              <th>Tipo</th>
              <th>Note</th>
              <th>Visib.</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {ascents.map(a => (
              <tr key={a.id}>
                <td style={{ whiteSpace: 'nowrap', color: '#6b7a67' }}>
                  {new Date(a.date).toLocaleDateString('it-IT')}
                </td>
                <td style={{ fontWeight: 600 }}>
                  <Link to={`/routes/${a.route.id}`} style={{ color: 'var(--text)', textDecoration: 'none' }}>
                    {a.route.name}
                  </Link>
                </td>
                <td style={{ color: '#6b7a67', fontSize: 12 }}>
                  <Link to={`/crags/${a.route.sector.crag.id}`} style={{ color: '#2d5a27', textDecoration: 'none' }}>
                    {a.route.sector.crag.name}
                  </Link>
                  {' › '}
                  {a.route.sector.name}
                </td>
                <td>
                  {a.grade_at_ascent
                    ? <span className="grade-badge">{a.grade_at_ascent}</span>
                    : a.route.official_grade
                    ? <span className="grade-badge">{a.route.official_grade}</span>
                    : '—'}
                </td>
                <td>
                  {a.status === 'completed' && a.attempt_type ? (
                    <span className="attempt-badge">{ATTEMPT_LABELS[a.attempt_type] ?? a.attempt_type}</span>
                  ) : a.status === 'attempted' ? (
                    <span className="attempt-badge attempted">Tentativo</span>
                  ) : '—'}
                </td>
                <td style={{ color: '#6b7a67', fontSize: 12, maxWidth: 200 }}>
                  {a.notes ? (
                    <span title={a.notes}>{a.notes.slice(0, 60)}{a.notes.length > 60 ? '…' : ''}</span>
                  ) : '—'}
                </td>
                <td>
                  <span className={`visibility-badge${a.visibility === 'private' ? ' private' : ''}`}>
                    {a.visibility === 'public' ? 'pub' : 'priv'}
                  </span>
                </td>
                <td>
                  <button
                    className="btn-danger"
                    style={{ fontSize: 11, padding: '3px 8px' }}
                    onClick={() => handleDelete(a.id, a.route.name)}
                    disabled={deleteAscent.isPending}
                  >
                    ×
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  )
}
