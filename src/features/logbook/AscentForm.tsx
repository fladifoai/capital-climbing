import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { useRouteSearch, type AscentFormValues, type RouteSearchResult } from './hooks'
import '../../styles/admin.css'

const ATTEMPT_OPTIONS: { value: string; label: string }[] = [
  { value: 'onsight', label: 'On-sight' },
  { value: 'flash', label: 'Flash' },
  { value: 'redpoint', label: 'Redpoint' },
  { value: 'second', label: '2° giro' },
  { value: 'third', label: '3° giro' },
  { value: 'four_plus', label: '4+' },
]

const optStr = z
  .union([z.string(), z.null(), z.undefined()])
  .transform((v): string | null => (v == null || v === '' ? null : v))

const optNum = z
  .union([z.number(), z.nan(), z.null(), z.undefined()])
  .transform((v): number | null => {
    if (v == null || (typeof v === 'number' && isNaN(v))) return null
    return v
  })

const ascentSchema = z.object({
  date: z.string().min(1, 'Data richiesta'),
  status: z.enum(['completed', 'attempted']),
  attempt_type: optStr,
  grade_at_ascent: optStr,
  personal_grade: optStr,
  quality: optNum,
  kneepad_used: z.boolean().nullable().optional().transform(v => v ?? null),
  effort: optNum,
  notes: optStr,
  visibility: z.enum(['public', 'private']),
})

type AscentSchema = z.infer<typeof ascentSchema>

interface Props {
  preselectedRoute?: RouteSearchResult
  onSubmit: (values: AscentFormValues) => void
  onCancel: () => void
  isLoading?: boolean
}

export default function AscentForm({ preselectedRoute, onSubmit, onCancel, isLoading }: Props) {
  const [query, setQuery] = useState(preselectedRoute?.name ?? '')
  const [selectedRoute, setSelectedRoute] = useState<RouteSearchResult | null>(preselectedRoute ?? null)
  const [showDropdown, setShowDropdown] = useState(false)
  const [quality, setQuality] = useState<number | null>(null)
  const [hoverStar, setHoverStar] = useState<number | null>(null)

  const { data: results, isFetching } = useRouteSearch(preselectedRoute ? '' : query)

  const { register, handleSubmit, watch, setValue, formState: { errors } } = useForm<AscentSchema>({
    resolver: zodResolver(ascentSchema) as import('react-hook-form').Resolver<AscentSchema>,
    defaultValues: {
      date: new Date().toISOString().slice(0, 10),
      status: 'completed',
      attempt_type: 'onsight',
      visibility: 'public',
      grade_at_ascent: preselectedRoute?.official_grade ?? '',
    },
  })

  const status = watch('status')

  function handleRouteSelect(route: RouteSearchResult) {
    setSelectedRoute(route)
    setQuery(route.name)
    setShowDropdown(false)
    setValue('grade_at_ascent', route.official_grade ?? '')
  }

  function handleFormSubmit(data: AscentSchema) {
    if (!selectedRoute) return
    onSubmit({
      route_id: selectedRoute.id,
      date: data.date,
      status: data.status,
      attempt_type: (data.attempt_type as AscentFormValues['attempt_type']) ?? null,
      grade_at_ascent: data.grade_at_ascent ?? selectedRoute.official_grade,
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
      {/* Route: show read-only when preselected, search when free */}
      {preselectedRoute ? (
        <div style={{ marginBottom: 16, padding: '10px 14px', background: '#f5f7f4', borderRadius: 8, fontSize: 13, color: '#2d5a27', fontWeight: 600 }}>
          Via: {preselectedRoute.crag_name} › {preselectedRoute.sector_name} › {preselectedRoute.name}
          {preselectedRoute.official_grade && <span className="grade-badge" style={{ marginLeft: 10 }}>{preselectedRoute.official_grade}</span>}
        </div>
      ) : (
        <div className="form-group" style={{ marginBottom: 16, position: 'relative' }}>
          <label>Via * <span style={{ fontWeight: 400, textTransform: 'none', fontSize: 11, color: '#8a9a87' }}>(cerca per nome)</span></label>
          <input
            value={query}
            onChange={e => { setQuery(e.target.value); setSelectedRoute(null); setShowDropdown(true) }}
            onFocus={() => query.length >= 2 && setShowDropdown(true)}
            placeholder="es. Spigolo giallo…"
            autoComplete="off"
          />
          {isFetching && <span style={{ fontSize: 11, color: '#8a9a87', marginTop: 2 }}>Ricerca…</span>}

          {showDropdown && results && results.length > 0 && (
            <div style={{
              position: 'absolute', top: '100%', left: 0, right: 0, zIndex: 100,
              background: '#fff', border: '1px solid #e0e0d8', borderRadius: 8,
              boxShadow: '0 4px 16px rgba(0,0,0,0.1)', maxHeight: 260, overflowY: 'auto',
            }}>
              {results.map(r => (
                <div
                  key={r.id}
                  onClick={() => handleRouteSelect(r)}
                  style={{ padding: '10px 14px', cursor: 'pointer', borderBottom: '1px solid #f0f0e8', fontSize: 13 }}
                  onMouseEnter={e => (e.currentTarget.style.background = '#f5f7f4')}
                  onMouseLeave={e => (e.currentTarget.style.background = '')}
                >
                  <div style={{ fontWeight: 600 }}>{r.name}</div>
                  <div style={{ fontSize: 11, color: '#8a9a87' }}>
                    {r.crag_name} › {r.sector_name}
                    {r.official_grade && <span className="grade-badge" style={{ marginLeft: 8 }}>{r.official_grade}</span>}
                  </div>
                </div>
              ))}
            </div>
          )}

          {showDropdown && query.length >= 2 && results?.length === 0 && !isFetching && (
            <div style={{ marginTop: 4, fontSize: 12, color: '#8a9a87' }}>Nessuna via trovata. Controllare il catalogo.</div>
          )}

          {selectedRoute && (
            <div style={{ marginTop: 6, fontSize: 12, color: '#2d5a27', fontWeight: 600 }}>
              ✓ {selectedRoute.crag_name} › {selectedRoute.sector_name} › {selectedRoute.name}
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
          <label>Stato</label>
          <select {...register('status')}>
            <option value="completed">Salita</option>
            <option value="attempted">Tentativo</option>
          </select>
        </div>

        {status === 'completed' && (
          <div className="form-group">
            <label>Tipo</label>
            <select {...register('attempt_type')}>
              <option value="">—</option>
              {ATTEMPT_OPTIONS.map(o => (
                <option key={o.value} value={o.value}>{o.label}</option>
              ))}
            </select>
          </div>
        )}

        <div className="form-group">
          <label>Grado al momento</label>
          <input {...register('grade_at_ascent')} placeholder="es. 7a" />
        </div>

        <div className="form-group">
          <label>Grado personale</label>
          <input {...register('personal_grade')} placeholder="es. 7a+" />
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
