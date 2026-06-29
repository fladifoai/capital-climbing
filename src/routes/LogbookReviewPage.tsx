import { useState } from 'react'
import { Link } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'
import {
  useNeedsReviewAscents, useUpdateAscentReview, type ReviewAscent,
} from '../features/logbook-import/reviewHooks'
import {
  ATTEMPT_SELECTOR_OPTIONS, getAttemptBucket, type AttemptBucket,
} from '../analytics/calculations/attempt-buckets'
import '../styles/admin.css'
import '../styles/import.css'

// Opzioni modalità per la revisione: onsight/flash + giri esatti/bucket.
const STYLE_OPTIONS: { value: string; label: string }[] = [
  { value: '', label: '— scegli —' },
  { value: 'onsight', label: 'On-sight' },
  { value: 'flash', label: 'Flash' },
  ...ATTEMPT_SELECTOR_OPTIONS.map(o => ({ value: o.value, label: o.label })),
]

function resolveStyle(value: string): {
  ascent_style: string | null; attempt_count: number | null; attempt_bucket: AttemptBucket | null
} {
  if (value === 'onsight') return { ascent_style: 'onsight', attempt_count: 1, attempt_bucket: '1' }
  if (value === 'flash') return { ascent_style: 'flash', attempt_count: 1, attempt_bucket: '1' }
  if (!value) return { ascent_style: null, attempt_count: null, attempt_bucket: null }
  // valori numerici esatti '2'..'10'
  if (/^\d+$/.test(value)) {
    const n = parseInt(value, 10)
    return { ascent_style: 'redpoint', attempt_count: n, attempt_bucket: getAttemptBucket(n) }
  }
  // bucket aggregato '11_20'..'50_plus'
  return { ascent_style: 'redpoint', attempt_count: null, attempt_bucket: value as AttemptBucket }
}

function ReviewRow({ ascent, userId }: { ascent: ReviewAscent; userId: string }) {
  const update = useUpdateAscentReview(userId)
  const [style, setStyle] = useState('')
  const [grade, setGrade] = useState(ascent.grade_at_ascent ?? '')
  const [err, setErr] = useState('')

  async function save() {
    setErr('')
    if (!style) { setErr('Scegli la modalità'); return }
    const s = resolveStyle(style)
    try {
      await update.mutateAsync({
        id: ascent.id,
        grade_at_ascent: grade.trim() || null,
        ...s,
      })
    } catch (e) { setErr((e as Error).message) }
  }

  return (
    <tr>
      <td>{ascent.date}</td>
      <td style={{ color: 'var(--text-muted)' }}>{ascent.crag_name_snapshot ?? '—'}</td>
      <td>
        {ascent.route
          ? <Link to={`/routes/${ascent.route.id}`} style={{ color: 'var(--text)', textDecoration: 'none' }}>{ascent.route.name}</Link>
          : (ascent.route_name_snapshot ?? '—')}
      </td>
      <td>
        <input
          className="mapping-select"
          style={{ minWidth: 70, width: 70 }}
          value={grade}
          onChange={e => setGrade(e.target.value)}
          placeholder="grado"
        />
      </td>
      <td>
        <select className="mapping-select" style={{ minWidth: 130 }} value={style} onChange={e => setStyle(e.target.value)}>
          {STYLE_OPTIONS.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
        </select>
      </td>
      <td>
        <button className="btn-primary" style={{ padding: '5px 14px', fontSize: 12 }} onClick={save} disabled={update.isPending}>
          {update.isPending ? '…' : 'Salva'}
        </button>
        {err && <div className="row-errors-cell">{err}</div>}
      </td>
    </tr>
  )
}

export default function LogbookReviewPage() {
  const { user } = useAuth()
  const userId = user?.id ?? ''
  const { data: ascents, isLoading, error } = useNeedsReviewAscents(userId)

  return (
    <div className="admin-page import-page">
      <div className="admin-header">
        <h1 className="admin-title">Ascensioni da revisionare</h1>
      </div>

      <p style={{ fontSize: 13, color: 'var(--text-muted)', marginBottom: 16 }}>
        Salite importate senza modalità o grado certi (es. Tentativi “N.D.”).
        Completa modalità e grado, poi salva: escono dalla revisione ed entrano nelle statistiche complete.
      </p>

      {isLoading && <div className="loading-state">Caricamento…</div>}
      {error && <div className="admin-error">Errore nel caricamento.</div>}

      {ascents && ascents.length === 0 && (
        <div className="import-report">
          <div className="import-report-icon">✅</div>
          <div className="import-report-title">Niente da revisionare</div>
          <Link to="/profile" className="btn-primary" style={{ textDecoration: 'none' }}>Vai al profilo</Link>
        </div>
      )}

      {ascents && ascents.length > 0 && (
        <table className="import-table">
          <thead>
            <tr><th>Data</th><th>Falesia</th><th>Via</th><th>Grado</th><th>Modalità</th><th></th></tr>
          </thead>
          <tbody>
            {ascents.map(a => <ReviewRow key={a.id} ascent={a} userId={userId} />)}
          </tbody>
        </table>
      )}
    </div>
  )
}
