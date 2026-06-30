import { useState } from 'react'
import type { AttemptBucket } from '../../analytics/calculations/attempt-buckets'
import type { AscentUpdateValues } from './hooks'
import '../../styles/admin.css'

const ATTEMPT_TYPE_OPTIONS = [
  { value: 'onsight',   label: 'On-sight' },
  { value: 'flash',     label: 'Flash' },
  { value: 'second_go', label: '2° giro' },
  { value: 'third_go',  label: '3° giro' },
  { value: 'four_plus', label: '4+' },
  { value: 'unknown',   label: 'Non specificato' },
]

function mapAttemptType(type: string): {
  ascent_style: string
  attempt_count: number | null
  attempt_bucket: AttemptBucket | null
} {
  switch (type) {
    case 'onsight':   return { ascent_style: 'onsight',  attempt_count: 1, attempt_bucket: '1' }
    case 'flash':     return { ascent_style: 'flash',    attempt_count: 1, attempt_bucket: '1' }
    case 'second_go': return { ascent_style: 'redpoint', attempt_count: 2, attempt_bucket: '2' }
    case 'third_go':  return { ascent_style: 'redpoint', attempt_count: 3, attempt_bucket: '3' }
    case 'four_plus': return { ascent_style: 'redpoint', attempt_count: null, attempt_bucket: null }
    default:          return { ascent_style: 'unknown',  attempt_count: null, attempt_bucket: null }
  }
}

// Ricava la selezione iniziale dal record salvato
function deriveType(style: string | null, count: number | null): string {
  if (style === 'onsight') return 'onsight'
  if (style === 'flash') return 'flash'
  if (style === 'redpoint') {
    if (count === 2) return 'second_go'
    if (count === 3) return 'third_go'
    return 'four_plus'
  }
  return 'unknown'
}

export interface EditableAscent {
  id: string
  date: string
  ascent_style: string | null
  attempt_count: number | null
  is_repeat: boolean
  personal_grade: string | null
  quality: number | null
  effort: number | null
  kneepad_used: boolean | null
  notes: string | null
  visibility: 'public' | 'private'
  route: { id: string; name: string; official_grade: string | null } | null
}

interface Props {
  ascent: EditableAscent
  onSubmit: (values: AscentUpdateValues) => void
  onCancel: () => void
  isLoading?: boolean
}

export default function AscentEditForm({ ascent, onSubmit, onCancel, isLoading }: Props) {
  const [date, setDate] = useState(ascent.date)
  const [attemptType, setAttemptType] = useState(deriveType(ascent.ascent_style, ascent.attempt_count))
  const [isRepeat, setIsRepeat] = useState(ascent.is_repeat)
  const [quality, setQuality] = useState<number | null>(ascent.quality)
  const [hoverStar, setHoverStar] = useState<number | null>(null)
  const [effort, setEffort] = useState<number | ''>(ascent.effort ?? '')
  const [kneepad, setKneepad] = useState(ascent.kneepad_used ?? false)
  const [personalGrade, setPersonalGrade] = useState(ascent.personal_grade ?? '')
  const [notes, setNotes] = useState(ascent.notes ?? '')
  const [visibility, setVisibility] = useState<'public' | 'private'>(ascent.visibility)

  function submit() {
    const mapped = isRepeat
      ? { ascent_style: 'repeat', attempt_count: null as number | null, attempt_bucket: null as AttemptBucket | null }
      : mapAttemptType(attemptType)
    onSubmit({
      date,
      ascent_style: mapped.ascent_style,
      attempt_count: mapped.attempt_count,
      attempt_bucket: mapped.attempt_bucket,
      is_repeat: isRepeat,
      personal_grade: personalGrade || null,
      quality,
      effort: effort !== '' ? Number(effort) : null,
      kneepad_used: kneepad,
      notes: notes || null,
      visibility,
    })
  }

  return (
    <div className="inline-form">
      <div style={{ marginBottom: 14, padding: '8px 12px', background: 'rgba(232,93,53,0.10)', border: '1px solid rgba(232,93,53,0.22)', borderRadius: 10, fontSize: 13, color: 'var(--accent)', fontWeight: 600 }}>
        {ascent.route?.name ?? '—'}
        {ascent.route?.official_grade && <span className="grade-badge" style={{ marginLeft: 8 }}>{ascent.route.official_grade}</span>}
      </div>

      <div className="form-grid">
        <div className="form-group">
          <label>Data</label>
          <input type="date" value={date} onChange={e => setDate(e.target.value)} />
        </div>

        <div className="form-group">
          <label>Tipo salita</label>
          <select value={attemptType} onChange={e => setAttemptType(e.target.value)} disabled={isRepeat} style={isRepeat ? { opacity: 0.4 } : {}}>
            {ATTEMPT_TYPE_OPTIONS.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
          </select>
        </div>

        <div className="form-group">
          <label>Grado personale</label>
          <input value={personalGrade} onChange={e => setPersonalGrade(e.target.value)} placeholder="es. 6b" />
        </div>

        <div className="form-group">
          <label>Sforzo (1–10)</label>
          <input type="number" min={1} max={10} value={effort} onChange={e => setEffort(e.target.value === '' ? '' : Number(e.target.value))} placeholder="8" />
        </div>

        <div className="form-group">
          <label>Visibilità</label>
          <select value={visibility} onChange={e => setVisibility(e.target.value as 'public' | 'private')}>
            <option value="public">Pubblica</option>
            <option value="private">Privata</option>
          </select>
        </div>

        <div className="form-group">
          <label>Bellezza (stelle)</label>
          <div style={{ display: 'flex', gap: 4, paddingTop: 4 }}>
            {[1, 2, 3, 4, 5].map(n => (
              <button key={n} type="button"
                onClick={() => setQuality(quality === n ? null : n)}
                onMouseEnter={() => setHoverStar(n)}
                onMouseLeave={() => setHoverStar(null)}
                style={{
                  background: 'none', border: 'none', cursor: 'pointer', padding: 0,
                  fontSize: 22, lineHeight: 1,
                  color: n <= (hoverStar ?? quality ?? 0) ? '#f5a623' : 'rgba(247,243,234,0.18)',
                  transition: 'color 0.1s',
                }}>★</button>
            ))}
            {quality && <span style={{ fontSize: 11, color: 'var(--text-muted)', alignSelf: 'center', marginLeft: 4 }}>{quality}/5</span>}
          </div>
        </div>

        <div className="form-group" style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingTop: 16 }}>
          <input type="checkbox" id={`edit-repeat-${ascent.id}`} checked={isRepeat} onChange={e => setIsRepeat(e.target.checked)} style={{ width: 'auto' }} />
          <label htmlFor={`edit-repeat-${ascent.id}`} style={{ textTransform: 'none', fontSize: 13, color: 'var(--text)', letterSpacing: 0 }}>È una ripetizione</label>
        </div>

        <div className="form-group" style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingTop: 16 }}>
          <input type="checkbox" id={`edit-kneepad-${ascent.id}`} checked={kneepad} onChange={e => setKneepad(e.target.checked)} style={{ width: 'auto' }} />
          <label htmlFor={`edit-kneepad-${ascent.id}`} style={{ textTransform: 'none', fontSize: 13, color: 'var(--text)', letterSpacing: 0 }}>Ginocchiera</label>
        </div>
      </div>

      <div className="form-full form-group">
        <label>Note</label>
        <textarea value={notes} onChange={e => setNotes(e.target.value)} placeholder="Note sulla salita…" />
      </div>

      <div className="form-actions">
        <button type="button" className="btn-secondary" onClick={onCancel}>Annulla</button>
        <button type="button" className="btn-primary" onClick={submit} disabled={isLoading}>
          {isLoading ? 'Salvataggio…' : 'Salva modifiche'}
        </button>
      </div>
    </div>
  )
}
