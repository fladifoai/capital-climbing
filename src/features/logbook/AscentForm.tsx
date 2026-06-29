import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { useRouteSearch, type AscentFormValues, type RouteSearchResult } from './hooks'
import type { AttemptBucket } from '../../analytics/calculations/attempt-buckets'
import '../../styles/admin.css'

const ATTEMPT_TYPE_OPTIONS = [
  { value: 'onsight',   label: 'On-sight' },
  { value: 'flash',     label: 'Flash' },
  { value: 'second_go', label: '2° giro' },
  { value: 'third_go',  label: '3° giro' },
  { value: 'four_plus', label: '4+' },
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

const optStr = z.preprocess(
  (v) => (v === '' || v == null ? null : String(v)),
  z.string().nullable()
)

const optNum = z.preprocess(
  (v) => {
    if (v === '' || v == null) return null
    const n = Number(v)
    return isNaN(n) ? null : n
  },
  z.number().nullable()
)

const ascentSchema = z.object({
  date: z.string().min(1, 'Data richiesta'),
  personal_grade: optStr,
  quality: optNum,
  kneepad_used: z.preprocess((v) => v ?? null, z.boolean().nullable()),
  effort: optNum,
  notes: optStr,
  visibility: z.enum(['public', 'private']),
})

type AscentSchema = z.infer<typeof ascentSchema>

interface Props {
  preselectedRoute?: RouteSearchResult
  defaultDate?: string
  sessionId?: string | null
  onSubmit: (values: AscentFormValues) => void
  onCancel: () => void
  isLoading?: boolean
}

export default function AscentForm({ preselectedRoute, defaultDate, sessionId, onSubmit, onCancel, isLoading }: Props) {
  const [query, setQuery] = useState(preselectedRoute?.name ?? '')
  const [selectedRoute, setSelectedRoute] = useState<RouteSearchResult | null>(preselectedRoute ?? null)
  const [showDropdown, setShowDropdown] = useState(false)
  const [quality, setQuality] = useState<number | null>(null)
  const [hoverStar, setHoverStar] = useState<number | null>(null)
  const [attemptType, setAttemptType] = useState('onsight')
  const [isRepeat, setIsRepeat] = useState(false)

  const { data: results, isFetching } = useRouteSearch(preselectedRoute ? '' : query)

  const { register, handleSubmit, formState: { errors } } = useForm<AscentSchema>({
    resolver: zodResolver(ascentSchema) as import('react-hook-form').Resolver<AscentSchema>,
    defaultValues: {
      date: defaultDate ?? new Date().toISOString().slice(0, 10),
      visibility: 'public',
    },
  })

  function handleRouteSelect(route: RouteSearchResult) {
    setSelectedRoute(route)
    setQuery(route.name)
    setShowDropdown(false)
  }

  function handleFormSubmit(data: AscentSchema) {
    console.log('[AscentForm] handleFormSubmit', { selectedRoute: selectedRoute?.id, isRepeat, attemptType, data })
    if (!selectedRoute) {
      console.warn('[AscentForm] no selectedRoute — aborting')
      return
    }

    const mapped = isRepeat
      ? { ascent_style: 'repeat', attempt_count: null as number | null, attempt_bucket: null as AttemptBucket | null }
      : mapAttemptType(attemptType)

    onSubmit({
      route_id: selectedRoute.id,
      session_id: sessionId ?? null,
      date: data.date,
      attempt_type: null,
      ascent_style: mapped.ascent_style,
      attempt_count: mapped.attempt_count,
      attempt_bucket: mapped.attempt_bucket,
      is_repeat: isRepeat,
      grade_at_ascent: selectedRoute.official_grade,
      grade_numeric_at_ascent: selectedRoute.grade_numeric,
      personal_grade: data.personal_grade ?? null,
      quality,
      kneepad_used: data.kneepad_used ?? null,
      effort: data.effort ?? null,
      notes: data.notes ?? null,
      visibility: data.visibility,
    })
  }

  return (
    <form onSubmit={handleSubmit(handleFormSubmit)} className="inline-form">
      {/* Route selector */}
      {preselectedRoute ? (
        <div style={{ marginBottom: 16, padding: '10px 14px', background: 'rgba(232,93,53,0.10)', border: '1px solid rgba(232,93,53,0.22)', borderRadius: 10, fontSize: 13, color: 'var(--accent)', fontWeight: 600 }}>
          Via: {preselectedRoute.crag_name} › {preselectedRoute.sector_name} › {preselectedRoute.name}
          {preselectedRoute.official_grade && <span className="grade-badge" style={{ marginLeft: 10 }}>{preselectedRoute.official_grade}</span>}
        </div>
      ) : (
        <div className="form-group" style={{ marginBottom: 16, position: 'relative' }}>
          <label>Via * <span style={{ fontWeight: 400, textTransform: 'none', fontSize: 11, color: 'var(--text-muted)' }}>(cerca per nome)</span></label>
          <input
            value={query}
            onChange={e => { setQuery(e.target.value); setSelectedRoute(null); setShowDropdown(true) }}
            onFocus={() => query.length >= 2 && setShowDropdown(true)}
            placeholder="es. Spigolo giallo…"
            autoComplete="off"
          />
          {isFetching && <span style={{ fontSize: 11, color: 'var(--text-muted)', marginTop: 2 }}>Ricerca…</span>}
          {showDropdown && results && results.length > 0 && (
            <div style={{
              position: 'absolute', top: '100%', left: 0, right: 0, zIndex: 100,
              background: '#2A3240', border: '1px solid rgba(247,243,234,0.14)', borderRadius: 10,
              boxShadow: '0 8px 24px rgba(0,0,0,0.40)', maxHeight: 260, overflowY: 'auto',
            }}>
              {results.map(r => (
                <div
                  key={r.id}
                  onClick={() => handleRouteSelect(r)}
                  style={{ padding: '10px 14px', cursor: 'pointer', borderBottom: '1px solid rgba(247,243,234,0.08)', fontSize: 13 }}
                  onMouseEnter={e => (e.currentTarget.style.background = 'rgba(232,93,53,0.08)')}
                  onMouseLeave={e => (e.currentTarget.style.background = '')}
                >
                  <div style={{ fontWeight: 600, color: 'var(--text)' }}>{r.name}</div>
                  <div style={{ fontSize: 11, color: 'var(--text-muted)' }}>
                    {r.crag_name} › {r.sector_name}
                    {r.official_grade && <span className="grade-badge" style={{ marginLeft: 8 }}>{r.official_grade}</span>}
                  </div>
                </div>
              ))}
            </div>
          )}
          {showDropdown && query.length >= 2 && results?.length === 0 && !isFetching && (
            <div style={{ marginTop: 4, fontSize: 12, color: 'var(--text-muted)' }}>Nessuna via trovata. Controllare il catalogo.</div>
          )}
          {selectedRoute && (
            <div style={{ marginTop: 6, fontSize: 12, color: 'var(--accent)', fontWeight: 600 }}>
              ✓ {selectedRoute.crag_name} › {selectedRoute.sector_name} › {selectedRoute.name}
              {selectedRoute.official_grade && (
                <span className="grade-badge" style={{ marginLeft: 8 }}>{selectedRoute.official_grade}</span>
              )}
            </div>
          )}
        </div>
      )}

      <div className="form-grid">
        <div className={`form-group${errors.date ? ' error' : ''}`}>
          <label>Data *</label>
          <input type="date" {...register('date')} />
          {errors.date && <span className="form-error">{errors.date.message}</span>}
        </div>

        <div className="form-group">
          <label>Tipo salita</label>
          <select
            value={attemptType}
            onChange={e => setAttemptType(e.target.value)}
            disabled={isRepeat}
            style={isRepeat ? { opacity: 0.4 } : {}}
          >
            {ATTEMPT_TYPE_OPTIONS.map(o => (
              <option key={o.value} value={o.value}>{o.label}</option>
            ))}
          </select>
        </div>

        <div className="form-group">
          <label>Sforzo (1–10)</label>
          <input type="number" min={1} max={10} {...register('effort', { valueAsNumber: true })} placeholder="8" />
        </div>

        <div className="form-group">
          <label>Visibilità</label>
          <select {...register('visibility')}>
            <option value="public">Pubblica</option>
            <option value="private">Privata</option>
          </select>
        </div>

        <div className="form-group">
          <label>Bellezza (stelle)</label>
          <div style={{ display: 'flex', gap: 4, paddingTop: 4 }}>
            {[1, 2, 3, 4, 5].map(n => (
              <button
                key={n}
                type="button"
                onClick={() => setQuality(quality === n ? null : n)}
                onMouseEnter={() => setHoverStar(n)}
                onMouseLeave={() => setHoverStar(null)}
                style={{
                  background: 'none', border: 'none', cursor: 'pointer', padding: 0,
                  fontSize: 22, lineHeight: 1,
                  color: n <= (hoverStar ?? quality ?? 0) ? '#f5a623' : '#d0d0c8',
                  transition: 'color 0.1s',
                }}
              >
                ★
              </button>
            ))}
            {quality && (
              <span style={{ fontSize: 11, color: '#8a9a87', alignSelf: 'center', marginLeft: 4 }}>
                {quality}/5
              </span>
            )}
          </div>
        </div>

        <div className="form-group" style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingTop: 16 }}>
          <input
            type="checkbox"
            id="repeat-chk"
            checked={isRepeat}
            onChange={e => setIsRepeat(e.target.checked)}
            style={{ width: 'auto' }}
          />
          <label htmlFor="repeat-chk" style={{ textTransform: 'none', fontSize: 13, color: 'var(--text)', letterSpacing: 0 }}>
            È una ripetizione
          </label>
        </div>

        <div className="form-group" style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingTop: 16 }}>
          <input type="checkbox" id="kneepad-chk" {...register('kneepad_used')} style={{ width: 'auto' }} />
          <label htmlFor="kneepad-chk" style={{ textTransform: 'none', fontSize: 13, color: 'var(--text)', letterSpacing: 0 }}>
            Ginocchiera
          </label>
        </div>
      </div>

      <div className="form-full form-group">
        <label>Note</label>
        <textarea {...register('notes')} placeholder="Note sulla salita…" />
      </div>

      <div className="form-actions">
        <button type="button" className="btn-secondary" onClick={onCancel}>Annulla</button>
        <button type="submit" className="btn-primary" disabled={isLoading || !selectedRoute}>
          {isLoading ? 'Salvataggio…' : 'Salva ascensione'}
        </button>
      </div>
    </form>
  )
}
