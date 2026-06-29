import { useState, Fragment } from 'react'
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
import { useCreateAscent, type AscentFormValues } from '../features/logbook/hooks'
import AscentForm from '../features/logbook/AscentForm'
import '../styles/sessions.css'
import '../styles/admin.css'

const ATTEMPT_LABELS: Record<string, string> = {
  onsight: 'OS', flash: 'FL', redpoint: 'RP', second: '2°', third: '3°', four_plus: '4+',
  repeat: 'Rip', unknown: '?',
}

const STYLE_COLORS: Record<string, string> = {
  onsight: '#28B487', flash: '#4C9BE8', redpoint: '#D9902F',
  second: '#D9902F', third: '#D9902F', four_plus: '#D9902F',
  repeat: '#A78BFA',
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

function rpeColor(rpe: number): string {
  if (rpe >= 9) return '#E06455'
  if (rpe >= 7) return '#D9902F'
  return '#28B487'
}

function formatDate(dateStr: string): string {
  const d = new Date(dateStr + 'T00:00:00')
  return d.toLocaleDateString('it-IT', { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' })
}

interface SessionCardProps {
  session: SessionWithCrag
  confirmDelete: string | null
  setConfirmDelete: (id: string | null) => void
  onDelete: (id: string) => void
  onAddAscent: () => void
}

function SessionCard({ session, confirmDelete, setConfirmDelete, onDelete, onAddAscent }: SessionCardProps) {
  const [showNotes, setShowNotes] = useState(false)
  const routeCount = session.ascents?.length ?? 0
  const closedCount = session.ascents?.filter(a =>
    ['onsight','flash','redpoint','second','third','four_plus'].includes(a.ascent_style ?? a.attempt_type ?? '')
  ).length ?? 0

  const hasNotes = !!session.notes
  const hasInfo = session.partner || session.conditions || session.temperature != null ||
                  session.session_rpe != null || session.rest_days != null || session.rock_condition

  return (
    <div className="session-card">
      {/* Card header */}
      <div className="session-card-header" style={{ cursor: 'default', paddingBottom: 14 }}>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{
            fontFamily: '"Sora","Inter",system-ui,sans-serif',
            fontSize: 17, fontWeight: 800, color: 'var(--text)',
            margin: '0 0 2px', letterSpacing: '-0.02em',
          }}>
            {formatDate(session.date)}
          </div>
          {session.crag && (
            <div style={{ fontSize: 13, color: 'var(--text-2)', fontWeight: 600 }}>
              <Link to={`/crags/${session.crag.id}`} style={{ color: 'var(--accent)', textDecoration: 'none' }}>
                {session.crag.name}
              </Link>
            </div>
          )}
        </div>
        <div style={{ display: 'flex', gap: 6, alignItems: 'center', flexShrink: 0, flexWrap: 'wrap' }}>
          {/* Route count badge */}
          {routeCount > 0 && (
            <span className="session-route-count">
              {routeCount} {routeCount === 1 ? 'via' : 'vie'}
              {closedCount > 0 && <span style={{ marginLeft: 4, opacity: 0.75 }}>· {closedCount} chiuse</span>}
            </span>
          )}
          {/* RPE badge */}
          {session.session_rpe != null && (
            <span style={{
              display: 'inline-flex', alignItems: 'center', height: 24,
              padding: '0 10px', borderRadius: 999, fontSize: 11, fontWeight: 800,
              background: `${rpeColor(session.session_rpe)}18`,
              color: rpeColor(session.session_rpe),
              border: `1px solid ${rpeColor(session.session_rpe)}44`,
            }}>
              RPE {session.session_rpe}/10
            </span>
          )}
          {/* Delete */}
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
              style={{ padding: '3px 8px', fontSize: 11, color: '#FFB0A5' }}
              onClick={e => { e.stopPropagation(); setConfirmDelete(session.id) }}
            >✕</button>
          )}
        </div>
      </div>

      {/* Day info chips */}
      {hasInfo && (
        <div style={{
          display: 'flex', gap: 8, flexWrap: 'wrap',
          padding: '8px 18px', borderTop: '1px solid rgba(247,243,234,0.08)',
        }}>
          {session.partner && (
            <span style={{ fontSize: 12, color: 'var(--text-muted)' }}>👤 {session.partner}</span>
          )}
          {session.temperature != null && (
            <span style={{ fontSize: 12, color: 'var(--text-muted)' }}>🌡️ {session.temperature}°C</span>
          )}
          {session.conditions && (
            <span style={{ fontSize: 12, color: 'var(--text-muted)' }}>🌤️ {session.conditions}</span>
          )}
          {session.rock_condition && (
            <span style={{ fontSize: 12, color: 'var(--text-muted)' }}>🪨 {session.rock_condition}</span>
          )}
          {session.rest_days != null && (
            <span style={{ fontSize: 12, color: 'var(--text-muted)' }}>😴 {session.rest_days}gg riposo</span>
          )}
        </div>
      )}

      {/* Private notes */}
      {hasNotes && (
        <div style={{ padding: '10px 18px', borderTop: '1px solid rgba(247,243,234,0.08)' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 6 }}>
            <span style={{ fontSize: 10, fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.07em', color: 'var(--text-muted)' }}>
              Note private
            </span>
            <span style={{
              fontSize: 10, fontWeight: 700, padding: '2px 7px', borderRadius: 999,
              background: 'rgba(247,243,234,0.10)', color: 'var(--text-muted)',
              textTransform: 'uppercase', letterSpacing: '0.05em',
            }}>
              🔒 Privato
            </span>
            <button
              style={{ background: 'none', border: 'none', fontSize: 11, color: 'var(--accent)', cursor: 'pointer', padding: 0, fontWeight: 600 }}
              onClick={() => setShowNotes(v => !v)}
            >
              {showNotes ? 'Nascondi' : 'Mostra'}
            </button>
          </div>
          {showNotes && (
            <p style={{ fontSize: 13, color: 'var(--text-2)', lineHeight: 1.6, margin: 0, fontStyle: 'italic' }}>
              {session.notes}
            </p>
          )}
        </div>
      )}

      {/* Routes list */}
      {routeCount > 0 && (
        <div className="session-routes-list">
          {session.ascents.map(a => {
            const style = a.ascent_style ?? a.attempt_type ?? ''
            const styleLabel = ATTEMPT_LABELS[style] ?? style
            const color = STYLE_COLORS[style] ?? 'var(--text-muted)'
            return (
              <div key={a.id} className="session-route-row">
                <Link to={`/routes/${a.route?.id}`} className="session-route-name">
                  {a.route?.name ?? '—'}
                </Link>
                <div style={{ display: 'flex', gap: 8, alignItems: 'center', flexShrink: 0 }}>
                  {a.grade_at_ascent && (
                    <span className="grade-badge">{a.grade_at_ascent}</span>
                  )}
                  {style && (
                    <span style={{
                      fontSize: 11, fontWeight: 800, color,
                      background: `${color}18`,
                      border: `1px solid ${color}44`,
                      padding: '2px 8px', borderRadius: 999,
                    }}>
                      {styleLabel}
                    </span>
                  )}
                </div>
              </div>
            )
          })}
        </div>
      )}

      {/* Add ascent to session */}
      <div style={{ padding: '10px 18px', borderTop: '1px solid rgba(247,243,234,0.08)' }}>
        <button
          className="btn-secondary"
          style={{ fontSize: 12, padding: '5px 14px' }}
          onClick={onAddAscent}
        >
          + Aggiungi via
        </button>
      </div>
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
  const [formSection, setFormSection] = useState<'info' | 'conditions' | 'personal' | 'notes'>('info')

  const createAscent = useCreateAscent()
  const [addingAscentTo, setAddingAscentTo] = useState<string | null>(null)
  const [ascentSaveError, setAscentSaveError] = useState('')

  async function handleCreateAscent(values: AscentFormValues) {
    if (!user) return
    setAscentSaveError('')
    try {
      await createAscent.mutateAsync({ userId: user.id, values })
      setAddingAscentTo(null)
    } catch (e) {
      setAscentSaveError((e as Error).message)
    }
  }

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
      setFormSection('info')
    } catch (e) {
      setSaveError((e as Error).message)
    }
  }

  async function handleDelete(id: string) {
    await deleteSession.mutateAsync({ id, userId: user!.id })
    setConfirmDelete(null)
  }

  const formSections = [
    { key: 'info', label: '1 Info' },
    { key: 'conditions', label: '2 Condizioni' },
    { key: 'personal', label: '3 Personale' },
    { key: 'notes', label: '4 Note' },
  ] as const

  return (
    <div className="sessions-page">
      {/* Page header */}
      <div className="sessions-header">
        <div>
          <h1>Sessioni</h1>
          <p style={{ fontSize: 13, color: 'var(--text-on-dark-muted)', margin: '4px 0 0' }}>
            Rivedi le giornate in falesia, le condizioni, le vie provate e le note private.
          </p>
        </div>
        {!adding && (
          <button className="btn-primary" onClick={() => setAdding(true)}>+ Nuova sessione</button>
        )}
      </div>

      {/* New session form */}
      {adding && (
        <div className="new-session-form">
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 16 }}>
            <h3>Nuova sessione</h3>
            {/* Section tabs */}
            <div style={{ display: 'flex', gap: 4, background: 'rgba(247,243,234,0.08)', borderRadius: 999, padding: 4 }}>
              {formSections.map(s => (
                <button
                  key={s.key}
                  type="button"
                  onClick={() => setFormSection(s.key)}
                  style={{
                    padding: '4px 12px', borderRadius: 999, border: 'none', cursor: 'pointer',
                    fontSize: 11, fontWeight: 700, fontFamily: 'inherit',
                    background: formSection === s.key ? 'var(--surface)' : 'transparent',
                    color: formSection === s.key ? 'var(--text)' : 'var(--text-muted)',
                    boxShadow: formSection === s.key ? '0 2px 8px rgba(0,0,0,0.12)' : 'none',
                  }}
                >
                  {s.label}
                </button>
              ))}
            </div>
          </div>

          {saveError && <div className="admin-error" style={{ marginBottom: 12 }}>{saveError}</div>}

          <form onSubmit={handleSubmit(onSubmit)}>
            {/* Sezione 1 — Info principali */}
            {formSection === 'info' && (
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
                  {cragFetching && <span style={{ fontSize: 11, color: 'var(--text-muted)' }}>Ricerca…</span>}
                  {showCragDropdown && (cragResults?.length ?? 0) > 0 && (
                    <div style={{
                      position: 'absolute', top: '100%', left: 0, right: 0, zIndex: 200,
                      background: '#2A3240', border: '1px solid rgba(247,243,234,0.14)', borderRadius: 10,
                      boxShadow: '0 8px 24px rgba(0,0,0,0.40)', maxHeight: 180, overflowY: 'auto',
                    }}>
                      {cragResults!.map(c => (
                        <div
                          key={c.id}
                          onClick={() => { setSelectedCrag(c); setCragQuery(c.name); setShowCragDropdown(false) }}
                          style={{ padding: '9px 12px', cursor: 'pointer', fontSize: 13, borderBottom: '1px solid rgba(247,243,234,0.08)', color: 'var(--text)' }}
                          onMouseEnter={e => (e.currentTarget.style.background = 'rgba(232,93,53,0.08)')}
                          onMouseLeave={e => (e.currentTarget.style.background = '')}
                        >
                          {c.name}
                        </div>
                      ))}
                    </div>
                  )}
                  {selectedCrag && (
                    <span style={{ fontSize: 11, color: 'var(--accent)', fontWeight: 600 }}>✓ {selectedCrag.name}</span>
                  )}
                </div>
                <div className="form-group">
                  <label>Partner</label>
                  <input {...register('partner')} placeholder="es. Marco, Sara" />
                </div>
                <div className="form-group">
                  <label>Visibilità</label>
                  <select {...register('visibility')}>
                    <option value="private">🔒 Privata</option>
                    <option value="public">🌍 Pubblica</option>
                  </select>
                </div>
              </div>
            )}

            {/* Sezione 2 — Condizioni */}
            {formSection === 'conditions' && (
              <div className="form-grid">
                <div className="form-group">
                  <label>Condizioni meteo</label>
                  <input {...register('conditions')} placeholder="es. Sole, vento leggero" />
                </div>
                <div className="form-group">
                  <label>Condizione roccia</label>
                  <select {...register('rock_condition')}>
                    <option value="">—</option>
                    <option value="asciutta">Asciutta</option>
                    <option value="umida">Umida</option>
                    <option value="bagnata">Bagnata</option>
                    <option value="con polvere">Con polvere</option>
                    <option value="verde">Verde / alghe</option>
                  </select>
                </div>
                <div className="form-group">
                  <label>Temperatura (°C)</label>
                  <input type="number" {...register('temperature', { valueAsNumber: true })} placeholder="18" />
                </div>
              </div>
            )}

            {/* Sezione 3 — Stato personale */}
            {formSection === 'personal' && (
              <div className="form-grid">
                <div className="form-group">
                  <label>RPE sessione (1–10)</label>
                  <input type="number" min={1} max={10} {...register('session_rpe', { valueAsNumber: true })} placeholder="7" />
                </div>
                <div className="form-group">
                  <label>Giorni di riposo precedenti</label>
                  <input type="number" min={0} {...register('rest_days', { valueAsNumber: true })} placeholder="2" />
                </div>
              </div>
            )}

            {/* Sezione 4 — Note private */}
            {formSection === 'notes' && (
              <div className="form-full form-group">
                <label>Note private 🔒</label>
                <textarea
                  {...register('notes')}
                  rows={5}
                  placeholder="Come ti sei sentito, cosa hai imparato, cosa migliorare…"
                />
                <span style={{ fontSize: 11, color: 'var(--text-muted)', marginTop: 4 }}>
                  Le note sono private e non appaiono sul profilo pubblico.
                </span>
              </div>
            )}

            <div style={{ display: 'flex', gap: 8, justifyContent: 'space-between', marginTop: 16 }}>
              <button type="button" className="btn-secondary" onClick={() => { setAdding(false); setSaveError(''); setFormSection('info') }}>
                Annulla
              </button>
              <div style={{ display: 'flex', gap: 8 }}>
                {formSection !== 'info' && (
                  <button type="button" className="btn-secondary" onClick={() => {
                    const idx = formSections.findIndex(s => s.key === formSection)
                    if (idx > 0) setFormSection(formSections[idx - 1].key)
                  }}>
                    ← Indietro
                  </button>
                )}
                {formSection !== 'notes' ? (
                  <button type="button" className="btn-primary" onClick={() => {
                    const idx = formSections.findIndex(s => s.key === formSection)
                    setFormSection(formSections[idx + 1].key)
                  }}>
                    Avanti →
                  </button>
                ) : (
                  <button type="submit" className="btn-primary" disabled={createSession.isPending}>
                    {createSession.isPending ? 'Salvataggio…' : 'Salva sessione'}
                  </button>
                )}
              </div>
            </div>
          </form>
        </div>
      )}

      {/* Loading */}
      {isLoading && (
        <div style={{ textAlign: 'center', padding: '60px 0', color: 'var(--text-on-dark-muted)', fontSize: 14 }}>
          Caricamento sessioni…
        </div>
      )}

      {/* Empty state */}
      {!isLoading && (sessions?.length ?? 0) === 0 && !adding && (
        <div style={{
          background: 'rgba(255,247,234,0.05)',
          border: '2px dashed rgba(255,247,234,0.14)',
          borderRadius: 20,
          padding: '56px 32px',
          textAlign: 'center',
          marginTop: 8,
        }}>
          <div style={{ fontSize: 40, marginBottom: 16 }}>📅</div>
          <h2 style={{ color: 'var(--text-on-dark)', fontFamily: '"Sora","Inter",system-ui,sans-serif', fontWeight: 800, fontSize: 20, margin: '0 0 8px' }}>
            Nessuna sessione registrata
          </h2>
          <p style={{ color: 'var(--text-on-dark-muted)', fontSize: 14, lineHeight: 1.6, margin: '0 0 24px', maxWidth: 400, marginLeft: 'auto', marginRight: 'auto' }}>
            Crea una sessione per tenere traccia della giornata, delle condizioni, delle vie provate e delle note private.
          </p>
          <button className="btn-primary" onClick={() => setAdding(true)}>+ Nuova sessione</button>
        </div>
      )}

      {/* Sessions list */}
      {!isLoading && (sessions?.length ?? 0) > 0 && (
        <div style={{ display: 'flex', flexDirection: 'column', gap: 12, marginTop: adding ? 20 : 0 }}>
          {sessions!.map(s => (
            <Fragment key={s.id}>
              <SessionCard
                session={s}
                confirmDelete={confirmDelete}
                setConfirmDelete={setConfirmDelete}
                onDelete={handleDelete}
                onAddAscent={() => { setAddingAscentTo(s.id); setAscentSaveError('') }}
              />
              {addingAscentTo === s.id && (
                <div className="new-session-form" style={{ marginTop: -4 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 14 }}>
                    <h3 style={{ margin: 0, fontSize: 15 }}>
                      Aggiungi via — {formatDate(s.date)}
                    </h3>
                  </div>
                  {ascentSaveError && (
                    <div className="admin-error" style={{ marginBottom: 10 }}>{ascentSaveError}</div>
                  )}
                  <AscentForm
                    defaultDate={s.date}
                    sessionId={s.id}
                    onSubmit={handleCreateAscent}
                    onCancel={() => { setAddingAscentTo(null); setAscentSaveError('') }}
                    isLoading={createAscent.isPending}
                  />
                </div>
              )}
            </Fragment>
          ))}
        </div>
      )}
    </div>
  )
}
