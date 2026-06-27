import { Fragment, useState } from 'react'
import { Link } from 'react-router-dom'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import type { Resolver } from 'react-hook-form'
import { useAuth } from '../features/auth/AuthContext'
import {
  useMyProjects, useCreateProject, useUpdateProject, useDeleteProject,
  type ProjectWithRoute, type ProjectUpdateValues,
} from '../features/projects/hooks'
import { useCreateAscent, useRouteSearch, type RouteSearchResult, type AscentFormValues } from '../features/logbook/hooks'
import AscentForm from '../features/logbook/AscentForm'
import '../styles/projects.css'
import '../styles/admin.css'
import '../styles/logbook.css'

type StatusFilter = 'all' | 'active' | 'paused' | 'completed' | 'abandoned'

const STATUS_LABELS: Record<string, string> = {
  active: 'Attivo', paused: 'In pausa', completed: 'Completato', abandoned: 'Abbandonato',
}
const PRIORITY_LABELS: Record<string, string> = {
  high: 'Alta', medium: 'Media', low: 'Bassa',
}

// ─── New project form ────────────────────────────────────────────────────────

const newProjectSchema = z.object({
  opened_date: z.union([z.string(), z.null(), z.undefined()]).transform(v => v || null),
  priority: z.enum(['high', 'medium', 'low']),
  visibility: z.enum(['public', 'private']),
})
type NewProjectSchema = z.infer<typeof newProjectSchema>

interface NewProjectFormProps {
  userId: string
  onDone: () => void
  onCancel: () => void
}

function NewProjectForm({ userId, onDone, onCancel }: NewProjectFormProps) {
  const [query, setQuery] = useState('')
  const [selectedRoute, setSelectedRoute] = useState<RouteSearchResult | null>(null)
  const [showDropdown, setShowDropdown] = useState(false)
  const [saveError, setSaveError] = useState('')
  const createProject = useCreateProject()
  const { data: results, isFetching } = useRouteSearch(query)

  const { register, handleSubmit, formState: { errors } } = useForm<NewProjectSchema>({
    resolver: zodResolver(newProjectSchema) as Resolver<NewProjectSchema>,
    defaultValues: {
      opened_date: new Date().toISOString().slice(0, 10),
      priority: 'medium',
      visibility: 'private',
    },
  })

  async function handleFormSubmit(data: NewProjectSchema) {
    if (!selectedRoute) return
    setSaveError('')
    try {
      await createProject.mutateAsync({
        userId,
        values: {
          route_id: selectedRoute.id,
          opened_date: data.opened_date,
          priority: data.priority,
          visibility: data.visibility,
        },
      })
      onDone()
    } catch (e) {
      setSaveError((e as Error).message)
    }
  }

  return (
    <div className="new-project-form">
      <h3>Nuovo progetto</h3>
      {saveError && <div className="admin-error" style={{ marginBottom: 10 }}>{saveError}</div>}

      {/* Route search */}
      <div className="form-group" style={{ marginBottom: 12, position: 'relative' }}>
        <label>Via *</label>
        <input
          value={query}
          onChange={e => { setQuery(e.target.value); setSelectedRoute(null); setShowDropdown(true) }}
          onFocus={() => query.length >= 2 && setShowDropdown(true)}
          placeholder="Cerca per nome via…"
          autoComplete="off"
        />
        {isFetching && <span style={{ fontSize: 11, color: 'var(--text-muted)' }}>Ricerca…</span>}
        {showDropdown && results && results.length > 0 && (
          <div style={{
            position: 'absolute', top: '100%', left: 0, right: 0, zIndex: 200,
            background: '#FFF9EF', border: '1px solid rgba(29,22,17,0.14)', borderRadius: 10,
            boxShadow: '0 8px 24px rgba(23,18,14,0.22)', maxHeight: 220, overflowY: 'auto',
          }}>
            {results.map(r => (
              <div
                key={r.id}
                onClick={() => { setSelectedRoute(r); setQuery(r.name); setShowDropdown(false) }}
                style={{ padding: '9px 12px', cursor: 'pointer', borderBottom: '1px solid rgba(29,22,17,0.08)', fontSize: 13 }}
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
          <div style={{ fontSize: 12, color: 'var(--text-muted)', marginTop: 4 }}>Nessuna via trovata.</div>
        )}
        {selectedRoute && (
          <div style={{ fontSize: 12, color: 'var(--accent)', fontWeight: 600, marginTop: 4 }}>
            ✓ {selectedRoute.crag_name} › {selectedRoute.sector_name} › {selectedRoute.name}
          </div>
        )}
      </div>

      <form onSubmit={handleSubmit(handleFormSubmit)}>
        <div className="form-grid" style={{ marginBottom: 12 }}>
          <div className={`form-group${errors.opened_date ? ' error' : ''}`}>
            <label>Data apertura</label>
            <input type="date" {...register('opened_date')} />
          </div>
          <div className="form-group">
            <label>Priorità</label>
            <select {...register('priority')}>
              <option value="high">Alta</option>
              <option value="medium">Media</option>
              <option value="low">Bassa</option>
            </select>
          </div>
          <div className="form-group">
            <label>Visibilità</label>
            <select {...register('visibility')}>
              <option value="private">Privata</option>
              <option value="public">Pubblica</option>
            </select>
          </div>
        </div>
        <div style={{ display: 'flex', gap: 8, justifyContent: 'flex-end' }}>
          <button type="button" className="btn-secondary" onClick={onCancel}>Annulla</button>
          <button type="submit" className="btn-primary" disabled={!selectedRoute || createProject.isPending}>
            {createProject.isPending ? 'Salvataggio…' : 'Aggiungi progetto'}
          </button>
        </div>
      </form>
    </div>
  )
}

// ─── Project edit form ────────────────────────────────────────────────────────

const editSchema = z.object({
  attempts_count: z.union([z.number(), z.nan(), z.null(), z.undefined()])
    .transform((v): number => (v == null || (typeof v === 'number' && isNaN(v))) ? 0 : v),
  progress: z.union([z.number(), z.nan(), z.null(), z.undefined()])
    .transform((v): number => {
      if (v == null || (typeof v === 'number' && isNaN(v))) return 0
      return Math.min(100, Math.max(0, v))
    }),
  last_session_date: z.union([z.string(), z.null(), z.undefined()]).transform(v => v || null),
  priority: z.enum(['high', 'medium', 'low']),
  visibility: z.enum(['public', 'private']),
  high_point: z.union([z.string(), z.null(), z.undefined()]).transform(v => v || null),
  moves_solved: z.union([z.string(), z.null(), z.undefined()]).transform(v => v || null),
  moves_missing: z.union([z.string(), z.null(), z.undefined()]).transform(v => v || null),
  next_strategy: z.union([z.string(), z.null(), z.undefined()]).transform(v => v || null),
  beta_notes: z.union([z.string(), z.null(), z.undefined()]).transform(v => v || null),
})
type EditSchema = z.infer<typeof editSchema>

interface ProjectEditFormProps {
  project: ProjectWithRoute
  userId: string
  onSaved: () => void
}

function ProjectEditForm({ project, userId, onSaved }: ProjectEditFormProps) {
  const updateProject = useUpdateProject()
  const [saveError, setSaveError] = useState('')

  const { register, handleSubmit } = useForm<EditSchema>({
    resolver: zodResolver(editSchema) as Resolver<EditSchema>,
    defaultValues: {
      attempts_count: project.attempts_count,
      progress: project.progress,
      last_session_date: project.last_session_date ?? '',
      priority: project.priority,
      visibility: project.visibility,
      high_point: project.high_point ?? '',
      moves_solved: project.moves_solved ?? '',
      moves_missing: project.moves_missing ?? '',
      next_strategy: project.next_strategy ?? '',
      beta_notes: project.beta_notes ?? '',
    },
  })

  async function onSubmit(data: EditSchema) {
    setSaveError('')
    try {
      const values: ProjectUpdateValues = {
        attempts_count: data.attempts_count,
        progress: data.progress,
        last_session_date: data.last_session_date,
        priority: data.priority,
        visibility: data.visibility,
        high_point: data.high_point,
        moves_solved: data.moves_solved,
        moves_missing: data.moves_missing,
        next_strategy: data.next_strategy,
        beta_notes: data.beta_notes,
      }
      await updateProject.mutateAsync({ id: project.id, userId, values })
      onSaved()
    } catch (e) {
      setSaveError((e as Error).message)
    }
  }

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      {saveError && <div className="admin-error" style={{ marginBottom: 10 }}>{saveError}</div>}

      <div className="project-notes-grid">
        <div className="form-group">
          <label>Tentativi</label>
          <input type="number" min={0} {...register('attempts_count', { valueAsNumber: true })} />
        </div>
        <div className="form-group">
          <label>Progresso (%)</label>
          <input type="number" min={0} max={100} {...register('progress', { valueAsNumber: true })} />
        </div>
        <div className="form-group">
          <label>Ultima sessione</label>
          <input type="date" {...register('last_session_date')} />
        </div>
        <div className="form-group">
          <label>Priorità</label>
          <select {...register('priority')}>
            <option value="high">Alta</option>
            <option value="medium">Media</option>
            <option value="low">Bassa</option>
          </select>
        </div>
        <div className="form-group">
          <label>High point</label>
          <input {...register('high_point')} placeholder="es. Passo 3" />
        </div>
        <div className="form-group">
          <label>Mosse risolte</label>
          <input {...register('moves_solved')} placeholder="es. Passi 1-4" />
        </div>
        <div className="form-group">
          <label>Mosse mancanti</label>
          <input {...register('moves_missing')} placeholder="es. Uscita in blocco" />
        </div>
        <div className="form-group">
          <label>Prossima strategia</label>
          <input {...register('next_strategy')} placeholder="es. Provare da sinistra" />
        </div>
      </div>

      <div className="project-notes-full form-group">
        <label>Note beta</label>
        <textarea {...register('beta_notes')} rows={3} placeholder="Note tecniche, sequenze, condizioni…" />
      </div>

      <div className="form-group" style={{ marginBottom: 0 }}>
        <label>Visibilità</label>
        <select {...register('visibility')} style={{ maxWidth: 160 }}>
          <option value="private">Privata</option>
          <option value="public">Pubblica</option>
        </select>
      </div>

      <div className="project-save-row">
        <button type="submit" className="btn-primary" disabled={updateProject.isPending}>
          {updateProject.isPending ? 'Salvataggio…' : 'Salva modifiche'}
        </button>
      </div>
    </form>
  )
}

// ─── Project card ─────────────────────────────────────────────────────────────

interface ProjectCardProps {
  project: ProjectWithRoute
  userId: string
  onConvert: (project: ProjectWithRoute) => void
}

function ProjectCard({ project, userId, onConvert }: ProjectCardProps) {
  const [expanded, setExpanded] = useState(false)
  const [confirming, setConfirming] = useState<'abandon' | 'delete' | null>(null)
  const updateProject = useUpdateProject()
  const deleteProject = useDeleteProject()

  const route = project.route
  const cragName = route?.sector?.crag?.name ?? ''
  const sectorName = route?.sector?.name ?? ''

  async function setStatus(status: 'active' | 'paused' | 'abandoned') {
    await updateProject.mutateAsync({ id: project.id, userId, values: { status } })
  }

  async function handleDelete() {
    await deleteProject.mutateAsync({ id: project.id, userId })
  }

  const isActive = project.status === 'active'
  const isPaused = project.status === 'paused'
  const isEditable = isActive || isPaused

  return (
    <div className="project-card">
      <div className="project-card-main" onClick={() => setExpanded(e => !e)}>
        <div className="project-route-info">
          <div className="project-route-name">
            <Link
              to={`/routes/${route?.id}`}
              style={{ color: 'inherit', textDecoration: 'none' }}
              onClick={e => e.stopPropagation()}
            >
              {route?.name ?? '—'}
            </Link>
          </div>
          <div className="project-route-sub">
            {cragName}{sectorName ? ` › ${sectorName}` : ''}
          </div>
        </div>

        <div className="project-badges">
          {route?.official_grade && <span className="grade-badge">{route.official_grade}</span>}
          <span className={`status-badge ${project.status}`}>{STATUS_LABELS[project.status]}</span>
          <span className={`priority-badge ${project.priority}`}>{PRIORITY_LABELS[project.priority]}</span>
        </div>

        <div className="project-stats">
          <div className="project-stat">
            <strong>{project.attempts_count}</strong>
            <span>tentativi</span>
          </div>
          <div className="project-stat">
            <div className="progress-bar-wrap" title={`${project.progress}%`}>
              <div className="progress-bar-fill" style={{ width: `${project.progress}%` }} />
            </div>
            <span>{project.progress}%</span>
          </div>
        </div>

        <span className={`expand-chevron${expanded ? ' open' : ''}`}>▼</span>
      </div>

      {expanded && (
        <div className="project-card-body">
          <div className="project-actions">
            {isActive && (
              <button
                className="btn-primary"
                style={{ background: '#2d8a3e' }}
                onClick={() => onConvert(project)}
              >
                Ho salito! 🎉
              </button>
            )}
            {isActive && (
              <button className="btn-secondary" onClick={() => setStatus('paused')} disabled={updateProject.isPending}>
                Metti in pausa
              </button>
            )}
            {isPaused && (
              <button className="btn-secondary" onClick={() => setStatus('active')} disabled={updateProject.isPending}>
                Riprendi
              </button>
            )}
            {isEditable && confirming === 'abandon' ? (
              <Fragment>
                <span style={{ fontSize: 12, color: '#c0392b', alignSelf: 'center' }}>Abbandonare?</span>
                <button className="btn-danger" onClick={() => setStatus('abandoned')} disabled={updateProject.isPending}>Sì, abbandona</button>
                <button className="btn-secondary" onClick={() => setConfirming(null)}>No</button>
              </Fragment>
            ) : isEditable ? (
              <button className="btn-secondary" style={{ color: '#c0392b' }} onClick={() => setConfirming('abandon')}>
                Abbandona
              </button>
            ) : null}
            {confirming === 'delete' ? (
              <Fragment>
                <span style={{ fontSize: 12, color: '#c0392b', alignSelf: 'center' }}>Eliminare?</span>
                <button className="btn-danger" onClick={handleDelete} disabled={deleteProject.isPending}>Sì, elimina</button>
                <button className="btn-secondary" onClick={() => setConfirming(null)}>No</button>
              </Fragment>
            ) : (
              <button
                className="btn-secondary"
                style={{ marginLeft: 'auto', color: '#c0392b' }}
                onClick={() => setConfirming('delete')}
              >
                Elimina
              </button>
            )}
          </div>

          {isEditable && (
            <ProjectEditForm
              project={project}
              userId={userId}
              onSaved={() => setExpanded(false)}
            />
          )}

          {!isEditable && (project.beta_notes || project.high_point) && (
            <div style={{ fontSize: 13, color: '#4a5a48', lineHeight: 1.6 }}>
              {project.high_point && <div><strong>High point:</strong> {project.high_point}</div>}
              {project.beta_notes && <div style={{ marginTop: 6 }}>{project.beta_notes}</div>}
            </div>
          )}
        </div>
      )}
    </div>
  )
}

// ─── Main page ────────────────────────────────────────────────────────────────

const FILTER_TABS: { key: StatusFilter; label: string }[] = [
  { key: 'all', label: 'Tutti' },
  { key: 'active', label: 'Attivi' },
  { key: 'paused', label: 'In pausa' },
  { key: 'completed', label: 'Completati' },
  { key: 'abandoned', label: 'Abbandonati' },
]

export default function ProjectsPage() {
  const { user } = useAuth()
  const { data: projects, isLoading } = useMyProjects(user?.id ?? '')
  const createAscent = useCreateAscent()
  const updateProject = useUpdateProject()

  const [statusFilter, setStatusFilter] = useState<StatusFilter>('active')
  const [addingNew, setAddingNew] = useState(false)
  const [convertingProject, setConvertingProject] = useState<ProjectWithRoute | null>(null)
  const [convertDone, setConvertDone] = useState(false)
  const [convertError, setConvertError] = useState('')

  if (!user) return null

  const filtered = (projects ?? []).filter(p =>
    statusFilter === 'all' || p.status === statusFilter
  )

  const activeCount = (projects ?? []).filter(p => p.status === 'active').length

  async function handleConvertSubmit(values: AscentFormValues) {
    if (!convertingProject || !user) return
    setConvertError('')
    const uid = user.id
    try {
      await createAscent.mutateAsync({ userId: uid, values })
      await updateProject.mutateAsync({
        id: convertingProject.id,
        userId: uid,
        values: { status: 'completed' },
      })
      setConvertingProject(null)
      setConvertDone(true)
    } catch (e) {
      setConvertError((e as Error).message)
    }
  }

  const preselectedForConvert: RouteSearchResult | undefined = convertingProject ? {
    id: convertingProject.route.id,
    name: convertingProject.route.name,
    official_grade: convertingProject.route.official_grade,
    grade_numeric: convertingProject.route.grade_numeric,
    route_type: convertingProject.route.route_type,
    sector_name: convertingProject.route.sector?.name ?? '',
    crag_name: convertingProject.route.sector?.crag?.name ?? '',
  } : undefined

  return (
    <div className="projects-page">
      <div className="projects-header">
        <h1>Progetti {activeCount > 0 && <span style={{ fontSize: 14, color: 'var(--text-on-dark-muted)', fontWeight: 400 }}>({activeCount} attivi)</span>}</h1>
        {!addingNew && !convertingProject && (
          <button className="btn-primary" onClick={() => setAddingNew(true)}>+ Nuovo progetto</button>
        )}
      </div>

      {convertDone && (
        <div style={{ background: '#DDF5E8', border: '1px solid #A8D5BE', borderRadius: 10, padding: '12px 16px', marginBottom: 16, fontSize: 13, color: '#176C42', fontWeight: 600 }}>
          ✓ Ascensione registrata e progetto completato!{' '}
          <button
            style={{ background: 'none', border: 'none', color: '#176C42', cursor: 'pointer', fontWeight: 600, textDecoration: 'underline', fontSize: 13 }}
            onClick={() => setConvertDone(false)}
          >
            Chiudi
          </button>
        </div>
      )}

      {addingNew && (
        <NewProjectForm
          userId={user.id}
          onDone={() => { setAddingNew(false); setStatusFilter('active') }}
          onCancel={() => setAddingNew(false)}
        />
      )}

      {convertingProject && (
        <div className="convert-panel">
          <h3>Registra ascensione — {convertingProject.route.name}</h3>
          {convertError && <div className="admin-error" style={{ marginBottom: 10 }}>{convertError}</div>}
          <AscentForm
            preselectedRoute={preselectedForConvert}
            onSubmit={handleConvertSubmit}
            onCancel={() => { setConvertingProject(null); setConvertError('') }}
            isLoading={createAscent.isPending || updateProject.isPending}
          />
        </div>
      )}

      <div className="status-tabs">
        {FILTER_TABS.map(tab => (
          <button
            key={tab.key}
            className={`status-tab${statusFilter === tab.key ? ' active' : ''}`}
            onClick={() => setStatusFilter(tab.key)}
          >
            {tab.label}
            {tab.key !== 'all' && (
              <span style={{ marginLeft: 5, opacity: 0.7 }}>
                ({(projects ?? []).filter(p => p.status === tab.key).length})
              </span>
            )}
          </button>
        ))}
      </div>

      {isLoading && <div className="loading-state">Caricamento progetti…</div>}

      {!isLoading && filtered.length === 0 && (
        <div className="empty-state">
          {statusFilter === 'active'
            ? 'Nessun progetto attivo. Aggiungine uno!'
            : 'Nessun progetto in questa categoria.'}
        </div>
      )}

      {filtered.map(project => (
        <ProjectCard
          key={project.id}
          project={project}
          userId={user.id}
          onConvert={p => { setConvertingProject(p); setConvertDone(false) }}
        />
      ))}
    </div>
  )
}
