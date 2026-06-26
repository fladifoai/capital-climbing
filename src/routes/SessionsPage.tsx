import { useState } from 'react'
import { Link } from 'react-router-dom'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import type { Resolver } from 'react-hook-form'
import { useAuth } from '../features/auth/AuthContext'
import {
  useMySessions, useCreateSession, useDeleteSession,
  useCragSearch,
  type CragSearchResult, type SessionWithCrag,
} from '../features/sessions/hooks'
import '../styles/sessions.css'
import '../styles/admin.css'
import '../styles/logbook.css'

const ATTEMPT_LABELS: Record<string, string> = {
  onsight: 'OS', flash: 'FL', second: '2G', third: '3G', four_plus: '4+', redpoint: 'RP',
}

const optStr = z
  .union([z.string(), z.null(), z.undefined()])
  .transform((v): string | null => (v == null || v === '' ? null : v))

const optNum = z
  .union([z.number(), z.nan(), z.null(), z.undefined()])
  .transform((v): number | null =>
    v == null || (typeof v === 'number' && isNaN(v)) ? null : v
  )

const sessionSchema = z.object({
  date: z.string().min(1, 'Data richiesta'),
  partner: optStr,
  conditions: optStr,
  rock_condition: optStr,
  temperature: optNum,
  session_rpe: optNum,
  rest_days: optNum,
  notes: optStr,
  visibility: z.enum(['public', 'private']),
})
type SessionSchema = z.infer<typeof sessionSchema>

function rpeBadgeClass(rpe: number | null): string {
  if (!rpe) return 'rpe-badge'
  if (rpe >= 8) return 'rpe-badge hard'
  if (rpe >= 5) return 'rpe-badge medium'
  return 'rpe-badge'
}

interface SessionCardProps {
  session: SessionWithCrag
  confirmDelete: string | null
  setConfirmDelete: (id: string | null) => void
  onDelete: (id: string) => void
}

function SessionCard({ session, confirmDelete, setConfirmDelete, onDelete }: SessionCardProps) {
  const [expanded, setExpanded] = useState(false)
  const routeCount = session.ascents?.length ?? 0

  return (
    <div className="session-card">
      <div
        className="session-card-header"
        onClick={() => routeCount > 0 && setExpanded(e => !e)}
        style={{ cursor: routeCount > 0 ? 'pointer' : 'default' }}
      >
        <div className="session-card-left">
          <span className="session-date">{session.date}</span>
          {session.crag && <span className="session-crag-name">{session.crag.name}</span>}
        </div>

        <div className="session-card-meta">
          {session.partner && (
            <span className="session-meta-item">👤 {session.partner}</span>
          )}
          {session.session_rpe != null && (
            <span className={rpeBadgeClass(session.session_rpe)}>{session.session_rpe}/10</span>
          )}
          {routeCount > 0 && (
            <span className="session-route-count">
              {routeCount} {routeCount === 1 ? 'via' : 'vie'} {expanded ? '▲' : '▼'}
            </span>
          )}
          {confirmDelete === session.id ? (
            <span style={{ display: 'flex', gap: 4 }}>
              <button
                className="btn-danger"
                style={{ padding: '3px 8px', fontSize: 11 }}
                onClick={e => { e.stopPropagation(); onDelete(session.id) }}
              >Sì</button>
              <button
                className="btn-secondary"
                style={{ padding: '3px 8px', fontSize: 11 }}
                onClick={e => { e.stopPropagation(); setConfirmDelete(null) }}
              >No</button>
            </span>
          ) : (
            <button
              className="btn-secondary"
              style={{ padding: '3px 8px', fontSize: 11, color: '#c0392b' }}
              onClick={e => { e.stopPropagation(); setConfirmDelete(session.id) }}
            >✕</button>
          )}
        </div>
      </div>

      {session.notes && (
        <div className="session-notes">{session.notes}</div>
      )}

      {expanded && routeCount > 0 && (
        <div className="session-routes-list">
          {session.ascents.map(a => (
            <div key={a.id} className="session-route-row">
              <Link to={`/routes/${a.route?.id}`} className="session-route-name">
                {a.route?.name ?? '—'}
              </Link>
              <div style={{ display: 'flex', gap: 8, alignItems: 'center', flexShrink: 0 }}>
                {a.grade_at_ascent && (
                  <span className="grade-badge">{a.grade_at_ascent}</span>
                )}
                {a.attempt_type && (
                  <span style={{ fontSize: 11, fontWeight: 700, color: '#2d5a27' }}>
                    {ATTEMPT_LABELS[a.attempt_type] ?? a.attempt_type}
                  </span>
                )}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

export default function SessionsPage() {
  const { user } = useAuth()
  const { data: sessions, isLoading } = useMySessions(user?.id ?? '')
  const createSession = useCreateSession()
  const deleteSession = useDeleteSession()

  const [adding, setAdding] = useState(false)
  const [confirmDelete, setConfirmDelete] = useState<string | null>(null)
  const [saveError, setSaveError] = useState('')

  const [cragQuery, setCragQuery] = useState('')
  const [selectedCrag, setSelectedCrag] = useState<CragSearchResult | null>(null)
  const [showCragDropdown, setShowCragDropdown] = useState(false)
  const { data: cragResults, isFetching: cragFetching } = useCragSearch(cragQuery)

  const { register, handleSubmit, reset, formState: { errors } } = useForm<SessionSchema>({
    resolver: zodResolver(sessionSchema) as Resolver<SessionSchema>,
    defaultValues: { date: new Date().toISOString().slice(0, 10), visibility: 'private' },
  })

  if (!user) return null

  async function onSubmit(data: SessionSchema) {
    setSaveError('')
    try {
      await createSession.mutateAsync({
        userId: user!.id,
        values: {
          date: data.date,
          crag_id: selectedCrag?.id ?? null,
          partner: data.partner,
          conditions: data.conditions,
          rock_condition: data.rock_condition,
          temperature: data.temperature,
          session_rpe: data.session_rpe,
          rest_days: data.rest_days,
          notes: data.notes,
          visibility: data.visibility,
        },
      })
      reset()
      setSelectedCrag(null)
      setCragQuery('')
      setAdding(false)
    } catch (e) {
      setSaveError((e as Error).message)
    }
  }

  async function handleDelete(id: string) {
    await deleteSession.mutateAsync({ id, userId: user!.id })
    setConfirmDelete(null)
  }

  return (
    <div className="sessions-page">
      <div className="sessions-header">
        <h1>Sessioni</h1>
        {!adding && (
          <button className="btn-primary" onClick={() => setAdding(true)}>+ Nuova sessione</button>
        )}
      </div>

      {adding && (
        <div className="new-session-form">
          <h3>Nuova sessione</h3>
          {saveError && <div className="admin-error" style={{ marginBottom: 10 }}>{saveError}</div>}
          <form onSubmit={handleSubmit(onSubmit)}>
            <div className="form-grid">
              <div className={`form-group${errors.date ? ' error' : ''}`}>
                <label>Data *</label>
                <input type="date" {...register('date')} />
                {errors.date && <span className="form-error">{errors.date.message}</span>}
              </div>

              <div className="form-group" style={{ position: 'relative' }}>
                <label>Falesia</label>
                <input
                  value={cragQuery}
                  onChange={e => { setCragQuery(e.target.value); setSelectedCrag(null); setShowCragDropdown(true) }}
                  onFocus={() => cragQuery.length >= 2 && setShowCragDropdown(true)}
                  placeholder="Cerca falesia…"
                  autoComplete="off"
                />
                {cragFetching && <span style={{ fontSize: 11, color: '#8a9a87' }}>Ricerca…</span>}
                {showCragDropdown && (cragResults?.length ?? 0) > 0 && (
                  <div style={{
                    position: 'absolute', top: '100%', left: 0, right: 0, zIndex: 200,
                    background: '#fff', border: '1px solid #e0e0d8', borderRadius: 8,
                    boxShadow: '0 4px 12px rgba(0,0,0,0.08)', maxHeight: 180, overflowY: 'auto',
                  }}>
                    {cragResults!.map(c => (
                      <div
                        key={c.id}
                        onClick={() => { setSelectedCrag(c); setCragQuery(c.name); setShowCragDropdown(false) }}
                        style={{ padding: '9px 12px', cursor: 'pointer', fontSize: 13, borderBottom: '1px solid #f0f0e8' }}
                        onMouseEnter={e => (e.currentTarget.style.background = '#f5f7f4')}
                        onMouseLeave={e => (e.currentTarget.style.background = '')}
                      >
                        {c.name}
                      </div>
                    ))}
                  </div>
                )}
                {selectedCrag && (
                  <span style={{ fontSize: 11, color: '#2d5a27', fontWeight: 600 }}>✓ {selectedCrag.name}</span>
                )}
              </div>

              <div className="form-group">
                <label>Partner</label>
                <input {...register('partner')} placeholder="es. Marco" />
              </div>
              <div className="form-group">
                <label>Condizioni</label>
                <input {...register('conditions')} placeholder="es. Sole, vento leggero" />
              </div>
              <div className="form-group">
                <label>Roccia</label>
                <select {...register('rock_condition')}>
                  <option value="">—</option>
                  <option value="asciutta">Asciutta</option>
                  <option value="umida">Umida</option>
                  <option value="bagnata">Bagnata</option>
                  <option value="con polvere">Con polvere</option>
                </select>
              </div>
              <div className="form-group">
                <label>Temperatura (°C)</label>
                <input type="number" {...register('temperature', { valueAsNumber: true })} placeholder="18" />
              </div>
              <div className="form-group">
                <label>RPE sessione (1–10)</label>
                <input type="number" min={1} max={10} {...register('session_rpe', { valueAsNumber: true })} />
              </div>
              <div className="form-group">
                <label>Giorni di riposo</label>
                <input type="number" min={0} {...register('rest_days', { valueAsNumber: true })} />
              </div>
              <div className="form-group">
                <label>Visibilità</label>
                <select {...register('visibility')}>
                  <option value="private">Privata</option>
                  <option value="public">Pubblica</option>
                </select>
              </div>
            </div>
            <div className="form-full form-group">
              <label>Note</label>
              <textarea {...register('notes')} rows={2} placeholder="Come è andata…" />
            </div>
            <div style={{ display: 'flex', gap: 8, justifyContent: 'flex-end' }}>
              <button type="button" className="btn-secondary" onClick={() => { setAdding(false); setSaveError('') }}>Annulla</button>
              <button type="submit" className="btn-primary" disabled={createSession.isPending}>
                {createSession.isPending ? 'Salvataggio…' : 'Salva sessione'}
              </button>
            </div>
          </form>
        </div>
      )}

      {isLoading && <div className="loading-state">Caricamento sessioni…</div>}

      {!isLoading && (sessions?.length ?? 0) === 0 && (
        <div className="empty-state">Nessuna sessione registrata.</div>
      )}

      {sessions?.map(s => (
        <SessionCard
          key={s.id}
          session={s}
          confirmDelete={confirmDelete}
          setConfirmDelete={setConfirmDelete}
          onDelete={handleDelete}
        />
      ))}
    </div>
  )
}
