// Pannello admin: stato coda arricchimento falesie + backfill + review.
import { useState } from 'react'
import {
  useEnqueueMissing, useEnrichmentReview, useEnrichmentSummary, useRunEnrichmentNow,
} from './enrichment'

export default function EnrichmentPanel() {
  const { data: sum } = useEnrichmentSummary()
  const enqueue = useEnqueueMissing()
  const runNow = useRunEnrichmentNow()
  const [showReview, setShowReview] = useState(false)
  const [msg, setMsg] = useState('')

  async function backfill() {
    setMsg('')
    try {
      const n = await enqueue.mutateAsync()
      setMsg(n > 0 ? `${n} falesie accodate. Il completamento avviene in background.` : 'Nessuna falesia da accodare: tutto già completo o in coda.')
    } catch (e) { setMsg('Errore: ' + (e as Error).message) }
  }

  const working = (sum?.pending ?? 0) + (sum?.running ?? 0)

  return (
    <div className="admin-section">
      <div className="admin-section-header">
        <span className="admin-section-title">Arricchimento falesie 🛰️</span>
        <div className="actions">
          <button className="btn-secondary" onClick={() => runNow.mutate()} disabled={runNow.isPending}>
            {runNow.isPending ? '…' : 'Elabora ora'}
          </button>
          <button className="btn-primary" onClick={backfill} disabled={enqueue.isPending}>
            {enqueue.isPending ? 'Accodo…' : 'Completa tutte le mancanti'}
          </button>
        </div>
      </div>

      <p style={{ fontSize: 13, color: 'var(--text-muted)', margin: '0 0 12px' }}>
        Coordinate, quota, orientamento, stagione, mesi migliori e parcheggio cercati automaticamente
        da fonti aperte (OpenStreetMap, Open-Meteo). Riempie solo i campi vuoti, non tocca i dati esistenti.
        Gira in background e riprende da solo finché la coda non è vuota.
      </p>

      <div className="enrichment-stats" style={{ display: 'flex', gap: 16, flexWrap: 'wrap', marginBottom: 12 }}>
        <Stat label="In coda" value={sum?.pending ?? 0} />
        <Stat label="In corso" value={sum?.running ?? 0} />
        <Stat label="Completate" value={sum?.done ?? 0} tone="ok" />
        <Stat label="Da rivedere" value={sum?.needsReview ?? 0} tone="warn" />
        <Stat label="Errori" value={sum?.error ?? 0} tone={(sum?.error ?? 0) > 0 ? 'warn' : undefined} />
      </div>

      {working > 0 && (
        <div style={{ fontSize: 13, color: 'var(--text-muted)', marginBottom: 8 }}>
          ⏳ {working} falesie in lavorazione. Puoi lasciare la pagina: continua da solo.
        </div>
      )}
      {msg && <div style={{ fontSize: 13, marginBottom: 8 }}>{msg}</div>}

      {(sum?.needsReview ?? 0) > 0 || (sum?.error ?? 0) > 0 ? (
        <button className="btn-edit" onClick={() => setShowReview(v => !v)}>
          {showReview ? 'Nascondi' : 'Mostra'} da rivedere / errori
        </button>
      ) : null}

      {showReview && <ReviewList />}
    </div>
  )
}

function Stat({ label, value, tone }: { label: string; value: number; tone?: 'ok' | 'warn' }) {
  const color = tone === 'ok' ? '#7BD88F' : tone === 'warn' ? '#FFB0A5' : 'var(--text)'
  return (
    <div style={{ minWidth: 90 }}>
      <div style={{ fontSize: 24, fontWeight: 700, color }}>{value}</div>
      <div style={{ fontSize: 12, color: 'var(--text-muted)' }}>{label}</div>
    </div>
  )
}

function ReviewList() {
  const { data: items = [], isLoading } = useEnrichmentReview()
  if (isLoading) return <div className="loading-state">Caricamento…</div>
  if (items.length === 0) return <div className="empty-state">Niente da rivedere.</div>
  return (
    <table className="admin-table" style={{ marginTop: 12 }}>
      <thead><tr><th>Falesia</th><th>Stato</th><th>Motivo</th></tr></thead>
      <tbody>
        {items.map(it => (
          <tr key={it.crag_id}>
            <td style={{ fontWeight: 600 }}>{it.crag_name}</td>
            <td>{it.status}</td>
            <td style={{ fontSize: 12, color: 'var(--text-muted)' }}>
              {it.last_error
                ? `Errore: ${it.last_error}`
                : it.review && Object.keys(it.review).length > 0
                  ? Object.entries(it.review).map(([k, v]) => `${k}: ${JSON.stringify(v)}`).join(' · ')
                  : `coord: ${(it.result as Record<string, unknown>)?.coordStatus ?? '—'}`}
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  )
}
