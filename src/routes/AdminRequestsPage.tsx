import { useState } from 'react'
import { useCragRequests, useSetCragRequestStatus, type CragRequest } from '../features/logbook-import/adminHooks'
import '../styles/admin.css'

const STATUS_LABEL: Record<CragRequest['status'], string> = {
  pending: 'In attesa',
  resolved: 'Risolta',
  rejected: 'Rifiutata',
}

export default function AdminRequestsPage() {
  const [filter, setFilter] = useState<CragRequest['status'] | 'all'>('pending')
  const { data: requests, isLoading, error } = useCragRequests(filter === 'all' ? undefined : filter)
  const setStatus = useSetCragRequestStatus()
  const [actionError, setActionError] = useState('')

  async function handleStatus(id: string, status: CragRequest['status']) {
    setActionError('')
    try {
      await setStatus.mutateAsync({ id, status })
    } catch (e) {
      setActionError((e as Error).message)
    }
  }

  return (
    <div className="admin-page">
      <div className="admin-header">
        <h1 className="admin-title">Richieste falesia mancante</h1>
      </div>

      <p style={{ fontSize: 13, color: 'var(--text-muted)', marginBottom: 16 }}>
        Vie richieste dagli utenti durante l'import del logbook. Aggiungi la via al catalogo:
        le ascensioni in coda verranno importate automaticamente e la richiesta chiusa.
      </p>

      <div className="import-actions" style={{ justifyContent: 'flex-start', gap: 8, marginBottom: 16 }}>
        {(['pending', 'resolved', 'rejected', 'all'] as const).map(s => (
          <button
            key={s}
            className={filter === s ? 'btn-primary' : 'btn-secondary'}
            onClick={() => setFilter(s)}
          >
            {s === 'all' ? 'Tutte' : STATUS_LABEL[s]}
          </button>
        ))}
      </div>

      {actionError && <div className="admin-error">{actionError}</div>}
      {isLoading && <div className="loading-state">Caricamento…</div>}
      {error && <div className="error-state">Errore nel caricamento delle richieste.</div>}

      {requests && requests.length === 0 && (
        <div className="empty-state">Nessuna richiesta.</div>
      )}

      {requests && requests.length > 0 && (
        <table className="admin-table">
          <thead>
            <tr>
              <th>Falesia</th><th>Settore</th><th>Via</th><th>Grado</th>
              <th>In coda</th><th>Stato</th><th>Azioni</th>
            </tr>
          </thead>
          <tbody>
            {requests.map(r => (
              <tr key={r.id}>
                <td style={{ fontWeight: 600 }}>{r.crag_name}</td>
                <td style={{ color: 'var(--text-muted)' }}>{r.sector_name ?? '—'}</td>
                <td>{r.route_name}</td>
                <td>{r.raw_grade ?? '—'}</td>
                <td>{r.count}</td>
                <td>
                  <span className={`access-badge ${r.status === 'pending' ? 'limited' : r.status === 'resolved' ? 'open' : 'closed'}`}>
                    {STATUS_LABEL[r.status]}
                  </span>
                </td>
                <td>
                  <div className="actions">
                    {r.status !== 'rejected' && (
                      <button className="btn-danger" disabled={setStatus.isPending}
                        onClick={() => handleStatus(r.id, 'rejected')}>Rifiuta</button>
                    )}
                    {r.status !== 'pending' && (
                      <button className="btn-edit" disabled={setStatus.isPending}
                        onClick={() => handleStatus(r.id, 'pending')}>Riapri</button>
                    )}
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  )
}
