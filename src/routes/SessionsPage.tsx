import { useState, Fragment } from 'react'
import { Link } from 'react-router-dom'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import type { Resolver } from 'react-hook-form'
import { useAuth } from '../features/auth/AuthContext'
import {
  useMySessions, useCreateSession, useUpdateSession, useDeleteSession,
  useCragSearch, useLogProjectWork, useDeleteAttempt,
  type CragSearchResult, type SessionWithCrag, type SessionAscent, type SessionAttempt, type SessionFormValues,
} from '../features/sessions/hooks'
import {
  useCreateAscent, useUpdateAscent, useDeleteAscent,
  type AscentFormValues, type AscentUpdateValues, type RouteSearchResult,
} from '../features/logbook/hooks'
import { useMyProjects, type ProjectWithRoute } from '../features/projects/hooks'
import AscentForm from '../features/logbook/AscentForm'
import AscentEditForm from '../features/logbook/AscentEditForm'
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

// ─── Staged route (vie aggiunte in fase di creazione, prima del salvataggio) ───
interface StagedRoute {
  key: string
  values: AscentFormValues
  routeName: string
  grade: string | null
}

// ═══════════════════════ Session form (crea + modifica) ═══════════════════════
interface SessionFormProps {
  title: string
  initialValues?: Partial<SessionFormValues>
  initialCrag?: CragSearchResult | null
  isLoading?: boolean
  saveError?: string
  submitLabel: string
  onSubmit: (values: SessionFormValues) => void
  onCancel: () => void
  routesSection?: React.ReactNode
}

function SessionForm({
  title, initialValues, initialCrag, isLoading, saveError, submitLabel, onSubmit, onCancel, routesSection,
}: SessionFormProps) {
  const [cragQuery, setCragQuery] = useState(initialCrag?.name ?? '')
  const [selectedCrag, setSelectedCrag] = useState<CragSearchResult | null>(initialCrag ?? null)
  const [showCragDropdown, setShowCragDropdown] = useState(false)
  const { data: cragResults, isFetching: cragFetching } = useCragSearch(cragQuery)

  const { register, handleSubmit, formState: { errors } } = useForm<SessionSchema>({
    resolver: zodResolver(sessionSchema) as Resolver<SessionSchema>,
    defaultValues: {
      date: initialValues?.date ?? new Date().toISOString().slice(0, 10),
      partner: initialValues?.partner ?? null,
      conditions: initialValues?.conditions ?? null,
      rock_condition: initialValues?.rock_condition ?? null,
      temperature: initialValues?.temperature ?? null,
      session_rpe: initialValues?.session_rpe ?? null,
      rest_days: initialValues?.rest_days ?? null,
      notes: initialValues?.notes ?? null,
      visibility: initialValues?.visibility ?? 'private',
    },
  })

  function submit(data: SessionSchema) {
    onSubmit({
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
    })
  }

  return (
    <div className="new-session-form">
      <h3 style={{ marginBottom: 16 }}>{title}</h3>
      {saveError && <div className="admin-error" style={{ marginBottom: 12 }}>{saveError}</div>}

      <form onSubmit={handleSubmit(submit)}>
        {/* Info principali */}
        <div className="form-section-label">Info</div>
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

        {/* Condizioni */}
        <div className="form-section-label">Condizioni</div>
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

        {/* Stato personale */}
        <div className="form-section-label">Personale</div>
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

        {/* Note */}
        <div className="form-section-label">Note private 🔒</div>
        <div className="form-full form-group">
          <textarea
            {...register('notes')}
            rows={4}
            placeholder="Come ti sei sentito, cosa hai imparato, cosa migliorare…"
          />
          <span style={{ fontSize: 11, color: 'var(--text-muted)', marginTop: 4 }}>
            Le note sono private e non appaiono sul profilo pubblico.
          </span>
        </div>

        {/* Vie salite (solo creazione) */}
        {routesSection}

        <div style={{ display: 'flex', gap: 8, justifyContent: 'space-between', marginTop: 16 }}>
          <button type="button" className="btn-secondary" onClick={onCancel}>Annulla</button>
          <button type="submit" className="btn-primary" disabled={isLoading}>
            {isLoading ? 'Salvataggio…' : submitLabel}
          </button>
        </div>
      </form>
    </div>
  )
}

// ═══════════════ Form "Lavorato su progetto" (tentativo, non chiusura) ═════════
interface ProjectWorkFormProps {
  activeProjects: ProjectWithRoute[]
  isLoading: boolean
  onSave: (vars: { projectId: string; routeId: string; currentAttempts: number; highPoint: string | null; effort: number | null; notes: string | null }) => void
  onCancel: () => void
}

function ProjectWorkForm({ activeProjects, isLoading, onSave, onCancel }: ProjectWorkFormProps) {
  const [projectId, setProjectId] = useState('')
  const [highPoint, setHighPoint] = useState('')
  const [effort, setEffort] = useState('')
  const [notes, setNotes] = useState('')

  if (activeProjects.length === 0) {
    return (
      <div style={{ fontSize: 12, color: 'var(--text-muted)' }}>
        Nessun progetto attivo. Aggiungine uno dalla pagina <Link to="/projects" style={{ color: 'var(--accent)' }}>Progetti</Link>.
      </div>
    )
  }

  const selected = activeProjects.find(p => p.id === projectId)

  function submit() {
    if (!selected) return
    onSave({
      projectId: selected.id,
      routeId: selected.route.id,
      currentAttempts: selected.attempts_count,
      highPoint: highPoint.trim() || null,
      effort: effort ? Number(effort) : null,
      notes: notes.trim() || null,
    })
  }

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
      <div className="form-group" style={{ margin: 0 }}>
        <label>Progetto *</label>
        <select value={projectId} onChange={e => setProjectId(e.target.value)}>
          <option value="">— Scegli progetto —</option>
          {activeProjects.map(p => (
            <option key={p.id} value={p.id}>
              {p.route.name}{p.route.official_grade ? ` (${p.route.official_grade})` : ''} — {p.attempts_count} tent.
            </option>
          ))}
        </select>
      </div>
      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        <div className="form-group" style={{ margin: 0, flex: 1, minWidth: 140 }}>
          <label>High point</label>
          <input value={highPoint} onChange={e => setHighPoint(e.target.value)} placeholder="es. Passo 5" />
        </div>
        <div className="form-group" style={{ margin: 0, width: 110 }}>
          <label>Sforzo (1–10)</label>
          <input type="number" min={1} max={10} value={effort} onChange={e => setEffort(e.target.value)} placeholder="7" />
        </div>
      </div>
      <div className="form-group" style={{ margin: 0 }}>
        <label>Note</label>
        <input value={notes} onChange={e => setNotes(e.target.value)} placeholder="Come è andato il lavoro sul progetto…" />
      </div>
      <div style={{ display: 'flex', gap: 8, justifyContent: 'flex-end' }}>
        <button type="button" className="btn-secondary" onClick={onCancel}>Annulla</button>
        <button type="button" className="btn-primary" disabled={!selected || isLoading} onClick={submit}>
          {isLoading ? 'Salvataggio…' : 'Salva lavoro'}
        </button>
      </div>
    </div>
  )
}

// ═══════════════════════════════ Session card ═════════════════════════════════
interface SessionCardProps {
  session: SessionWithCrag
  confirmDelete: string | null
  setConfirmDelete: (id: string | null) => void
  onDelete: (id: string) => void
  onEdit: () => void
  onAddAscent: () => void
  editingAscentId: string | null
  onStartEditAscent: (id: string) => void
  onCancelEditAscent: () => void
  onSaveEditAscent: (a: SessionAscent, values: AscentUpdateValues) => void
  onRemoveAscent: (a: SessionAscent) => void
  savingAscentEdit: boolean
  removingAscentId: string | null
  projectRouteIds: Set<string>
  activeProjects: ProjectWithRoute[]
  onLogWork: (sessionId: string, sessionDate: string, vars: { projectId: string; routeId: string; currentAttempts: number; highPoint: string | null; effort: number | null; notes: string | null }) => void
  logWorkPending: boolean
  onDeleteAttempt: (a: SessionAttempt) => void
}

function SessionCard({
  session, confirmDelete, setConfirmDelete, onDelete, onEdit, onAddAscent,
  editingAscentId, onStartEditAscent, onCancelEditAscent, onSaveEditAscent, onRemoveAscent,
  savingAscentEdit, removingAscentId, projectRouteIds,
  activeProjects, onLogWork, logWorkPending, onDeleteAttempt,
}: SessionCardProps) {
  const [showNotes, setShowNotes] = useState(false)
  const [showWorkForm, setShowWorkForm] = useState(false)
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
          {routeCount > 0 && (
            <span className="session-route-count">
              {routeCount} {routeCount === 1 ? 'via' : 'vie'}
              {closedCount > 0 && <span style={{ marginLeft: 4, opacity: 0.75 }}>· {closedCount} chiuse</span>}
            </span>
          )}
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
          {/* Edit session */}
          <button
            className="btn-secondary"
            style={{ padding: '3px 10px', fontSize: 11 }}
            onClick={onEdit}
          >Modifica</button>
          {/* Delete session */}
          {confirmDelete === session.id ? (
            <span style={{ display: 'flex', gap: 4 }}>
              <button className="btn-danger" style={{ padding: '3px 8px', fontSize: 11 }}
                onClick={e => { e.stopPropagation(); onDelete(session.id) }}>Sì</button>
              <button className="btn-secondary" style={{ padding: '3px 8px', fontSize: 11 }}
                onClick={e => { e.stopPropagation(); setConfirmDelete(null) }}>No</button>
            </span>
          ) : (
            <button className="btn-secondary" style={{ padding: '3px 8px', fontSize: 11, color: '#FFB0A5' }}
              onClick={e => { e.stopPropagation(); setConfirmDelete(session.id) }}>✕</button>
          )}
        </div>
      </div>

      {/* Day info chips */}
      {hasInfo && (
        <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', padding: '8px 18px', borderTop: '1px solid rgba(247,243,234,0.08)' }}>
          {session.partner && <span style={{ fontSize: 12, color: 'var(--text-muted)' }}>👤 {session.partner}</span>}
          {session.temperature != null && <span style={{ fontSize: 12, color: 'var(--text-muted)' }}>🌡️ {session.temperature}°C</span>}
          {session.conditions && <span style={{ fontSize: 12, color: 'var(--text-muted)' }}>🌤️ {session.conditions}</span>}
          {session.rock_condition && <span style={{ fontSize: 12, color: 'var(--text-muted)' }}>🪨 {session.rock_condition}</span>}
          {session.rest_days != null && <span style={{ fontSize: 12, color: 'var(--text-muted)' }}>😴 {session.rest_days}gg riposo</span>}
        </div>
      )}

      {/* Private notes */}
      {hasNotes && (
        <div style={{ padding: '10px 18px', borderTop: '1px solid rgba(247,243,234,0.08)' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 6 }}>
            <span style={{ fontSize: 10, fontWeight: 700, textTransform: 'uppercase', letterSpacing: '0.07em', color: 'var(--text-muted)' }}>Note private</span>
            <span style={{ fontSize: 10, fontWeight: 700, padding: '2px 7px', borderRadius: 999, background: 'rgba(247,243,234,0.10)', color: 'var(--text-muted)', textTransform: 'uppercase', letterSpacing: '0.05em' }}>🔒 Privato</span>
            <button style={{ background: 'none', border: 'none', fontSize: 11, color: 'var(--accent)', cursor: 'pointer', padding: 0, fontWeight: 600 }}
              onClick={() => setShowNotes(v => !v)}>{showNotes ? 'Nascondi' : 'Mostra'}</button>
          </div>
          {showNotes && <p style={{ fontSize: 13, color: 'var(--text-2)', lineHeight: 1.6, margin: 0, fontStyle: 'italic' }}>{session.notes}</p>}
        </div>
      )}

      {/* Routes list */}
      {routeCount > 0 && (
        <div className="session-routes-list">
          {session.ascents.map(a => {
            if (editingAscentId === a.id) {
              return (
                <div key={a.id} style={{ padding: '12px 14px', borderBottom: '1px solid rgba(247,243,234,0.06)' }}>
                  <AscentEditForm
                    ascent={{
                      id: a.id, date: a.date,
                      ascent_style: a.ascent_style, attempt_count: a.attempt_count,
                      grade_at_ascent: a.grade_at_ascent,
                      is_repeat: a.is_repeat, personal_grade: a.personal_grade,
                      quality: a.quality, effort: a.effort, kneepad_used: a.kneepad_used,
                      notes: a.notes, visibility: a.visibility,
                      route: a.route ? { id: a.route.id, name: a.route.name, official_grade: a.route.official_grade } : null,
                    }}
                    onSubmit={values => onSaveEditAscent(a, values)}
                    onCancel={onCancelEditAscent}
                    isLoading={savingAscentEdit}
                  />
                </div>
              )
            }
            const repeat = a.is_repeat === true || (a.ascent_style ?? a.attempt_type) === 'repeat'
            const style = repeat ? 'repeat' : (a.ascent_style ?? a.attempt_type ?? '')
            const styleLabel = repeat ? 'Ripetizione' : (ATTEMPT_LABELS[style] ?? style)
            const color = repeat ? '#A78BFA' : (STYLE_COLORS[style] ?? 'var(--text-muted)')
            return (
              <div key={a.id} className="session-route-row">
                <Link to={`/routes/${a.route?.id}`} className="session-route-name">
                  {a.route?.name ?? '—'}
                  {a.route?.id && projectRouteIds.has(a.route.id) && (
                    <span
                      title="Questa via è un tuo progetto"
                      style={{ fontSize: 11, fontWeight: 700, color: '#C85F3A', border: '1px solid rgba(200,95,58,0.45)', padding: '1px 7px', borderRadius: 999, marginLeft: 8 }}
                    >
                      🎯 Progetto
                    </span>
                  )}
                </Link>
                <div style={{ display: 'flex', gap: 8, alignItems: 'center', flexShrink: 0 }}>
                  {a.grade_at_ascent && <span className="grade-badge">{a.grade_at_ascent}</span>}
                  {style && (
                    <span style={{ fontSize: 11, fontWeight: 800, color, background: `${color}18`, border: `1px solid ${color}44`, padding: '2px 8px', borderRadius: 999 }}>
                      {styleLabel}
                    </span>
                  )}
                  {repeat && (
                    <span style={{ fontSize: 10, fontWeight: 700, color: '#A78BFA', border: '1px solid rgba(167,139,250,0.4)', padding: '1px 6px', borderRadius: 999 }}>
                      Nessun punteggio
                    </span>
                  )}
                  <button className="btn-secondary" style={{ fontSize: 11, padding: '2px 7px' }}
                    title="Modifica via" onClick={() => onStartEditAscent(a.id)}>✎</button>
                  <button className="btn-secondary" style={{ fontSize: 11, padding: '2px 7px', color: '#FFB0A5' }}
                    title="Togli dalla sessione" disabled={removingAscentId === a.id}
                    onClick={() => onRemoveAscent(a)}>×</button>
                </div>
              </div>
            )
          })}
        </div>
      )}

      {/* Lavoro sui progetti (tentativi) */}
      {session.attempts?.length > 0 && (
        <div className="session-routes-list">
          {session.attempts.map(a => (
            <div key={a.id} className="session-route-row">
              <Link to={`/routes/${a.route?.id}`} className="session-route-name">
                {a.route?.name ?? '—'}
                <span
                  title="Lavorato sul progetto (tentativo, non chiuso)"
                  style={{ fontSize: 11, fontWeight: 700, color: '#D9902F', border: '1px solid rgba(217,144,47,0.45)', padding: '1px 7px', borderRadius: 999, marginLeft: 8 }}
                >
                  🎯 Lavorato
                </span>
              </Link>
              <div style={{ display: 'flex', gap: 8, alignItems: 'center', flexShrink: 0 }}>
                {a.route?.official_grade && <span className="grade-badge">{a.route.official_grade}</span>}
                {a.high_point && <span style={{ fontSize: 12, color: 'var(--text-muted)' }}>⛰️ {a.high_point}</span>}
                {a.effort != null && <span style={{ fontSize: 12, color: 'var(--text-muted)' }}>💪 {a.effort}/10</span>}
                <button className="btn-secondary" style={{ fontSize: 11, padding: '2px 7px', color: '#FFB0A5' }}
                  title="Rimuovi lavoro" onClick={() => onDeleteAttempt(a)}>×</button>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Add ascent / log project work */}
      <div style={{ padding: '10px 18px', borderTop: '1px solid rgba(247,243,234,0.08)', display: 'flex', gap: 8, flexWrap: 'wrap' }}>
        <button className="btn-secondary" style={{ fontSize: 12, padding: '5px 14px' }} onClick={onAddAscent}>
          + Aggiungi via
        </button>
        {!showWorkForm && (
          <button className="btn-secondary" style={{ fontSize: 12, padding: '5px 14px' }} onClick={() => setShowWorkForm(true)}>
            🎯 Lavorato su progetto
          </button>
        )}
      </div>

      {showWorkForm && (
        <div style={{ padding: '0 18px 14px' }}>
          <ProjectWorkForm
            activeProjects={activeProjects}
            isLoading={logWorkPending}
            onSave={vars => { onLogWork(session.id, session.date, vars); setShowWorkForm(false) }}
            onCancel={() => setShowWorkForm(false)}
          />
        </div>
      )}
    </div>
  )
}

// ════════════════════════════════ Page ════════════════════════════════════════
export default function SessionsPage() {
  const { user } = useAuth()
  const { data: sessions, isLoading } = useMySessions(user?.id ?? '')
  const { data: projects } = useMyProjects(user?.id ?? '')
  const createSession = useCreateSession()
  const updateSession = useUpdateSession()
  const deleteSession = useDeleteSession()

  const createAscent = useCreateAscent()
  const updateAscent = useUpdateAscent()
  const deleteAscent = useDeleteAscent()
  const logProjectWork = useLogProjectWork()
  const deleteAttempt = useDeleteAttempt()

  const [adding, setAdding] = useState(false)
  const [editingSessionId, setEditingSessionId] = useState<string | null>(null)
  const [confirmDelete, setConfirmDelete] = useState<string | null>(null)
  const [saveError, setSaveError] = useState('')

  // Vie staged in fase di creazione
  const [staged, setStaged] = useState<StagedRoute[]>([])
  const [addingStaged, setAddingStaged] = useState(false)

  // Add / edit / remove ascent dentro le card esistenti
  const [addingAscentTo, setAddingAscentTo] = useState<string | null>(null)
  const [ascentSaveError, setAscentSaveError] = useState('')
  const [savedAscentFor, setSavedAscentFor] = useState<string | null>(null)
  const [editingAscentId, setEditingAscentId] = useState<string | null>(null)
  const [removingAscentId, setRemovingAscentId] = useState<string | null>(null)

  if (!user) return null

  function resetCreate() {
    setAdding(false)
    setStaged([])
    setAddingStaged(false)
    setSaveError('')
  }

  async function handleCreateSession(values: SessionFormValues) {
    setSaveError('')
    try {
      const session = await createSession.mutateAsync({ userId: user!.id, values })
      // Salva le vie staged collegandole alla nuova sessione
      for (const s of staged) {
        await createAscent.mutateAsync({
          userId: user!.id,
          values: { ...s.values, session_id: session.id, date: values.date },
          routeId: s.values.route_id,
        })
      }
      resetCreate()
    } catch (e) {
      setSaveError((e as Error).message)
    }
  }

  async function handleUpdateSession(values: SessionFormValues) {
    if (!editingSessionId) return
    setSaveError('')
    try {
      await updateSession.mutateAsync({ id: editingSessionId, userId: user!.id, values })
      setEditingSessionId(null)
    } catch (e) {
      setSaveError((e as Error).message)
    }
  }

  async function handleDelete(id: string) {
    await deleteSession.mutateAsync({ id, userId: user!.id })
    setConfirmDelete(null)
  }

  async function handleCreateAscent(values: AscentFormValues) {
    setAscentSaveError('')
    const sessionId = addingAscentTo
    try {
      await createAscent.mutateAsync({ userId: user!.id, values, routeId: values.route_id })
      setAddingAscentTo(null)
      setSavedAscentFor(sessionId)
    } catch (e) {
      setAscentSaveError((e as Error).message)
    }
  }

  async function handleSaveEditAscent(a: SessionAscent, values: AscentUpdateValues) {
    try {
      await updateAscent.mutateAsync({ id: a.id, userId: user!.id, values, routeId: a.route?.id })
      setEditingAscentId(null)
    } catch (e) {
      setAscentSaveError((e as Error).message)
    }
  }

  async function handleRemoveAscent(a: SessionAscent) {
    if (!confirm(`Togliere "${a.route?.name ?? 'questa via'}" dalla sessione? L'ascensione verrà eliminata.`)) return
    setRemovingAscentId(a.id)
    try {
      await deleteAscent.mutateAsync({ id: a.id, userId: user!.id })
    } finally {
      setRemovingAscentId(null)
    }
  }

  // Aggiunge una via alla lista staged (durante la creazione)
  function stageRoute(values: AscentFormValues, route?: RouteSearchResult) {
    setStaged(prev => [...prev, {
      key: `${values.route_id}-${Date.now()}`,
      values,
      routeName: route?.name ?? 'Via',
      grade: values.grade_at_ascent,
    }])
    setAddingStaged(false)
  }

  const editingSession = sessions?.find(s => s.id === editingSessionId) ?? null
  const projectRouteIds = new Set((projects ?? []).map(p => p.route_id))
  const activeProjects = (projects ?? []).filter(p => p.status === 'active' || p.status === 'paused')

  function handleLogWork(
    sessionId: string,
    sessionDate: string,
    vars: { projectId: string; routeId: string; currentAttempts: number; highPoint: string | null; effort: number | null; notes: string | null },
  ) {
    logProjectWork.mutate({ userId: user!.id, sessionId, sessionDate, ...vars })
  }

  async function handleDeleteAttempt(a: SessionAttempt) {
    if (!confirm(`Rimuovere il lavoro su "${a.route?.name ?? 'questo progetto'}"?`)) return
    await deleteAttempt.mutateAsync({ id: a.id, userId: user!.id })
  }

  const stagedSection = (
    <>
      <div className="form-section-label">Vie salite ({staged.length})</div>
      {staged.length > 0 && (
        <div style={{ display: 'flex', flexDirection: 'column', gap: 6, marginBottom: 10 }}>
          {staged.map(s => (
            <div key={s.key} style={{
              display: 'flex', alignItems: 'center', gap: 8, padding: '8px 12px',
              background: 'rgba(247,243,234,0.05)', border: '1px solid rgba(247,243,234,0.10)', borderRadius: 8,
            }}>
              <span style={{ fontSize: 13, color: 'var(--text)', fontWeight: 600, flex: 1 }}>
                {s.routeName} {s.grade && <span className="grade-badge" style={{ marginLeft: 6 }}>{s.grade}</span>}
              </span>
              <span style={{ fontSize: 11, color: 'var(--text-muted)' }}>{s.values.ascent_style}</span>
              <button type="button" className="btn-secondary" style={{ fontSize: 11, padding: '2px 7px', color: '#FFB0A5' }}
                onClick={() => setStaged(prev => prev.filter(x => x.key !== s.key))}>×</button>
            </div>
          ))}
        </div>
      )}
      {addingStaged ? (
        <div style={{ border: '1px solid rgba(247,243,234,0.12)', borderRadius: 10, padding: 14, marginBottom: 10 }}>
          <AscentForm
            onSubmit={stageRoute}
            onCancel={() => setAddingStaged(false)}
          />
        </div>
      ) : (
        <button type="button" className="btn-secondary" style={{ fontSize: 12, padding: '5px 14px', marginBottom: 6 }}
          onClick={() => setAddingStaged(true)}>
          + Aggiungi via salita
        </button>
      )}
      <p style={{ fontSize: 11, color: 'var(--text-muted)', margin: '2px 0 0' }}>
        Le vie usano la data della sessione e vengono salvate insieme alla sessione.
      </p>
    </>
  )

  return (
    <div className="sessions-page">
      <div className="sessions-header">
        <div>
          <h1>Sessioni</h1>
          <p style={{ fontSize: 13, color: 'var(--text-on-dark-muted)', margin: '4px 0 0' }}>
            Rivedi le giornate in falesia, le condizioni, le vie provate e le note private.
          </p>
        </div>
        {!adding && !editingSession && (
          <button className="btn-primary" onClick={() => { setAdding(true); setSaveError('') }}>+ Nuova sessione</button>
        )}
      </div>

      {/* Create */}
      {adding && (
        <SessionForm
          title="Nuova sessione"
          submitLabel="Salva sessione"
          isLoading={createSession.isPending || createAscent.isPending}
          saveError={saveError}
          onSubmit={handleCreateSession}
          onCancel={resetCreate}
          routesSection={stagedSection}
        />
      )}

      {/* Edit */}
      {editingSession && (
        <SessionForm
          title="Modifica sessione"
          submitLabel="Salva modifiche"
          isLoading={updateSession.isPending}
          saveError={saveError}
          initialValues={{
            date: editingSession.date,
            crag_id: editingSession.crag_id,
            partner: editingSession.partner,
            conditions: editingSession.conditions,
            rock_condition: editingSession.rock_condition,
            temperature: editingSession.temperature,
            session_rpe: editingSession.session_rpe,
            rest_days: editingSession.rest_days,
            notes: editingSession.notes,
            visibility: editingSession.visibility,
          }}
          initialCrag={editingSession.crag ? { id: editingSession.crag.id, name: editingSession.crag.name, region: null, province: null } : null}
          onSubmit={handleUpdateSession}
          onCancel={() => { setEditingSessionId(null); setSaveError('') }}
        />
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
          background: 'rgba(255,247,234,0.05)', border: '2px dashed rgba(255,247,234,0.14)',
          borderRadius: 20, padding: '56px 32px', textAlign: 'center', marginTop: 8,
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
        <div style={{ display: 'flex', flexDirection: 'column', gap: 12, marginTop: (adding || editingSession) ? 20 : 0 }}>
          {sessions!.map(s => (
            <Fragment key={s.id}>
              {editingSessionId !== s.id && (
                <SessionCard
                  session={s}
                  confirmDelete={confirmDelete}
                  setConfirmDelete={setConfirmDelete}
                  onDelete={handleDelete}
                  onEdit={() => { setEditingSessionId(s.id); setAdding(false); setSaveError('') }}
                  onAddAscent={() => { setAddingAscentTo(s.id); setAscentSaveError(''); setSavedAscentFor(null) }}
                  editingAscentId={editingAscentId}
                  onStartEditAscent={setEditingAscentId}
                  onCancelEditAscent={() => setEditingAscentId(null)}
                  onSaveEditAscent={handleSaveEditAscent}
                  onRemoveAscent={handleRemoveAscent}
                  savingAscentEdit={updateAscent.isPending}
                  removingAscentId={removingAscentId}
                  projectRouteIds={projectRouteIds}
                  activeProjects={activeProjects}
                  onLogWork={handleLogWork}
                  logWorkPending={logProjectWork.isPending}
                  onDeleteAttempt={handleDeleteAttempt}
                />
              )}
              {savedAscentFor === s.id && addingAscentTo !== s.id && (
                <div style={{
                  display: 'flex', alignItems: 'center', gap: 10, padding: '10px 16px', marginTop: -4,
                  background: 'rgba(40,180,135,0.12)', border: '1px solid rgba(40,180,135,0.30)',
                  borderRadius: 10, fontSize: 13, color: '#28B487', fontWeight: 600,
                }}>
                  <span>✓ Via aggiunta alla sessione!</span>
                  <button style={{ background: 'none', border: 'none', marginLeft: 'auto', fontSize: 12, color: '#28B487', opacity: 0.8, cursor: 'pointer' }}
                    onClick={() => setSavedAscentFor(null)}>✕</button>
                </div>
              )}
              {addingAscentTo === s.id && (
                <div className="new-session-form" style={{ marginTop: -4 }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 14 }}>
                    <h3 style={{ margin: 0, fontSize: 15 }}>Aggiungi via — {formatDate(s.date)}</h3>
                  </div>
                  {ascentSaveError && <div className="admin-error" style={{ marginBottom: 10 }}>{ascentSaveError}</div>}
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
