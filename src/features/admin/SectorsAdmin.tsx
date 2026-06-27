import { useState } from 'react'
import { type Resolver, useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import type { Sector, Route } from '../../types/database'
import {
  useAdminSectors, useAdminRoutes,
  useCreateSector, useUpdateSector, useDeleteSector,
  useCreateRoute, useUpdateRoute, useDeleteRoute,
  type SectorFormValues, type RouteFormValues,
} from './hooks'

// ── Zod helpers ─────────────────────────────────────────────────────────

const optNum = z
  .union([z.number(), z.nan(), z.null(), z.undefined()])
  .transform((v): number | null => {
    if (v == null || (typeof v === 'number' && isNaN(v))) return null
    return v
  })

const optStr = z
  .union([z.string(), z.null(), z.undefined()])
  .transform((v): string | null => (v == null || v === '' ? null : v))

// ── Sector form ──────────────────────────────────────────────────────────

const sectorSchema = z.object({
  name: z.string().min(1, 'Nome richiesto'),
  description: optStr,
  orientation: optStr,
  approach_notes: optStr,
  sort_order: z
    .union([z.number(), z.nan(), z.null(), z.undefined()])
    .transform((v): number => {
      if (v == null || (typeof v === 'number' && isNaN(v))) return 0
      return v
    }),
})

function SectorForm({
  defaultValues,
  onSubmit,
  onCancel,
  isLoading,
}: {
  defaultValues?: Partial<SectorFormValues>
  onSubmit: (v: SectorFormValues) => void
  onCancel: () => void
  isLoading?: boolean
}) {
  const { register, handleSubmit, formState: { errors } } = useForm<SectorFormValues>({
    resolver: zodResolver(sectorSchema) as Resolver<SectorFormValues>,
    defaultValues: {
      name: defaultValues?.name ?? '',
      description: defaultValues?.description ?? '',
      orientation: defaultValues?.orientation ?? '',
      approach_notes: defaultValues?.approach_notes ?? '',
      sort_order: defaultValues?.sort_order ?? 0,
    },
  })

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="inline-form">
      <div className="form-grid">
        <div className={`form-group${errors.name ? ' error' : ''}`}>
          <label>Nome *</label>
          <input {...register('name')} placeholder="es. Settore A" />
          {errors.name && <span className="form-error">{errors.name.message}</span>}
        </div>
        <div className="form-group">
          <label>Orientamento</label>
          <input {...register('orientation')} placeholder="es. Sud" />
        </div>
        <div className="form-group">
          <label>Ordine</label>
          <input type="number" {...register('sort_order', { valueAsNumber: true })} placeholder="0" />
        </div>
      </div>
      <div className="form-full form-group">
        <label>Descrizione</label>
        <textarea {...register('description')} placeholder="Breve descrizione del settore…" />
      </div>
      <div className="form-full form-group">
        <label>Note avvicinamento</label>
        <textarea {...register('approach_notes')} placeholder="Come raggiungere il settore…" />
      </div>
      <div className="form-actions">
        <button type="button" className="btn-secondary" onClick={onCancel}>Annulla</button>
        <button type="submit" className="btn-primary" disabled={isLoading}>
          {isLoading ? 'Salvataggio…' : 'Salva settore'}
        </button>
      </div>
    </form>
  )
}

// ── Route form ───────────────────────────────────────────────────────────

const routeSchema = z.object({
  name: z.string().min(1, 'Nome richiesto'),
  official_grade: optStr,
  length_m: optNum,
  pitches: z
    .union([z.number(), z.nan(), z.null(), z.undefined()])
    .transform((v): number => {
      if (v == null || (typeof v === 'number' && isNaN(v))) return 1
      return v
    }),
  bolts: optNum,
  angle: optStr,
  route_type: z.string().min(1),
  first_ascent: optStr,
  bolter: optStr,
  description: optStr,
  line_order: optNum,
})

function RouteForm({
  defaultValues,
  onSubmit,
  onCancel,
  isLoading,
}: {
  defaultValues?: Partial<RouteFormValues>
  onSubmit: (v: RouteFormValues) => void
  onCancel: () => void
  isLoading?: boolean
}) {
  const { register, handleSubmit, formState: { errors } } = useForm<RouteFormValues>({
    resolver: zodResolver(routeSchema) as Resolver<RouteFormValues>,
    defaultValues: {
      name: defaultValues?.name ?? '',
      official_grade: defaultValues?.official_grade ?? '',
      length_m: defaultValues?.length_m ?? undefined,
      pitches: defaultValues?.pitches ?? 1,
      bolts: defaultValues?.bolts ?? undefined,
      angle: defaultValues?.angle ?? '',
      route_type: defaultValues?.route_type ?? 'sport',
      first_ascent: defaultValues?.first_ascent ?? '',
      bolter: defaultValues?.bolter ?? '',
      description: defaultValues?.description ?? '',
      line_order: defaultValues?.line_order ?? undefined,
    },
  })

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="inline-form">
      <div className="form-grid-3">
        <div className={`form-group${errors.name ? ' error' : ''}`}>
          <label>Nome *</label>
          <input {...register('name')} placeholder="es. Spigolo giallo" />
          {errors.name && <span className="form-error">{errors.name.message}</span>}
        </div>
        <div className="form-group">
          <label>Grado</label>
          <input {...register('official_grade')} placeholder="es. 7a+" />
        </div>
        <div className="form-group">
          <label>Tipo</label>
          <select {...register('route_type')}>
            <option value="sport">Sport</option>
            <option value="trad">Trad</option>
            <option value="boulder">Boulder</option>
            <option value="deep_water">Deep Water</option>
          </select>
        </div>
        <div className="form-group">
          <label>Lunghezza (m)</label>
          <input type="number" {...register('length_m', { valueAsNumber: true })} placeholder="es. 25" />
        </div>
        <div className="form-group">
          <label>Tiri</label>
          <input type="number" {...register('pitches', { valueAsNumber: true })} placeholder="1" />
        </div>
        <div className="form-group">
          <label>Spit</label>
          <input type="number" {...register('bolts', { valueAsNumber: true })} placeholder="es. 10" />
        </div>
        <div className="form-group">
          <label>Angolo</label>
          <select {...register('angle')}>
            <option value="">—</option>
            <option value="slab">Slab</option>
            <option value="verticale">Verticale</option>
            <option value="strapiombo">Strapiombo</option>
            <option value="tetto">Tetto</option>
          </select>
        </div>
        <div className="form-group">
          <label>Ordine</label>
          <input type="number" {...register('line_order', { valueAsNumber: true })} placeholder="es. 1" />
        </div>
        <div className="form-group">
          <label>Prima salita</label>
          <input {...register('first_ascent')} placeholder="es. Mario Rossi, 2005" />
        </div>
      </div>
      <div className="form-full form-group">
        <label>Descrizione</label>
        <textarea {...register('description')} placeholder="Note sulla via…" />
      </div>
      <div className="form-actions">
        <button type="button" className="btn-secondary" onClick={onCancel}>Annulla</button>
        <button type="submit" className="btn-primary" disabled={isLoading}>
          {isLoading ? 'Salvataggio…' : 'Salva via'}
        </button>
      </div>
    </form>
  )
}

// ── Routes admin (per sector) ────────────────────────────────────────────

function RoutesAdmin({ sectorId }: { sectorId: string }) {
  const { data: routes, isLoading } = useAdminRoutes(sectorId)
  const createRoute = useCreateRoute()
  const updateRoute = useUpdateRoute()
  const deleteRoute = useDeleteRoute()

  const [creating, setCreating] = useState(false)
  const [editingId, setEditingId] = useState<string | null>(null)

  async function handleCreate(values: RouteFormValues) {
    await createRoute.mutateAsync({ sectorId, values })
    setCreating(false)
  }

  async function handleUpdate(route: Route, values: RouteFormValues) {
    await updateRoute.mutateAsync({ id: route.id, sectorId, values })
    setEditingId(null)
  }

  async function handleDelete(route: Route) {
    if (!confirm(`Eliminare la via "${route.name}"? L'operazione è irreversibile.`)) return
    await deleteRoute.mutateAsync({ id: route.id, sectorId })
  }

  if (isLoading) return <div className="admin-routes-loading">Caricamento vie…</div>

  return (
    <div className="admin-routes">
      {routes && routes.length > 0 && (
        <table className="admin-table" style={{ marginBottom: 10 }}>
          <thead>
            <tr>
              <th>#</th>
              <th>Nome</th>
              <th>Grado</th>
              <th>Tipo</th>
              <th>Lungh.</th>
              <th>Azioni</th>
            </tr>
          </thead>
          <tbody>
            {routes.map((route) =>
              editingId === route.id ? (
                <tr key={route.id}>
                  <td colSpan={6} style={{ padding: '8px 0' }}>
                    <RouteForm
                      defaultValues={route}
                      onSubmit={(v) => handleUpdate(route, v)}
                      onCancel={() => setEditingId(null)}
                      isLoading={updateRoute.isPending}
                    />
                  </td>
                </tr>
              ) : (
                <tr key={route.id}>
                  <td style={{ color: '#8a9a87' }}>{route.line_order ?? '—'}</td>
                  <td>{route.name}</td>
                  <td>
                    {route.official_grade
                      ? <span className="grade-badge">{route.official_grade}</span>
                      : '—'}
                  </td>
                  <td style={{ color: 'var(--text-muted)' }}>{route.route_type}</td>
                  <td style={{ color: 'var(--text-muted)' }}>{route.length_m ? `${route.length_m}m` : '—'}</td>
                  <td>
                    <div className="actions">
                      <button className="btn-edit" onClick={() => setEditingId(route.id)}>Modifica</button>
                      <button className="btn-danger" onClick={() => handleDelete(route)}>Elimina</button>
                    </div>
                  </td>
                </tr>
              )
            )}
          </tbody>
        </table>
      )}

      {creating ? (
        <RouteForm
          onSubmit={handleCreate}
          onCancel={() => setCreating(false)}
          isLoading={createRoute.isPending}
        />
      ) : (
        <button className="btn-secondary" style={{ fontSize: 12 }} onClick={() => setCreating(true)}>
          + Nuova via
        </button>
      )}

      {(createRoute.isError || updateRoute.isError || deleteRoute.isError) && (
        <div className="admin-error">
          {((createRoute.error || updateRoute.error || deleteRoute.error) as Error)?.message}
        </div>
      )}
    </div>
  )
}

// ── Sectors admin ────────────────────────────────────────────────────────

export default function SectorsAdmin({ cragId }: { cragId: string }) {
  const { data: sectors, isLoading, error } = useAdminSectors(cragId)
  const createSector = useCreateSector()
  const updateSector = useUpdateSector()
  const deleteSector = useDeleteSector()

  const [creating, setCreating] = useState(false)
  const [editingId, setEditingId] = useState<string | null>(null)
  const [expandedId, setExpandedId] = useState<string | null>(null)

  async function handleCreate(values: SectorFormValues) {
    await createSector.mutateAsync({ cragId, values })
    setCreating(false)
  }

  async function handleUpdate(sector: Sector, values: SectorFormValues) {
    await updateSector.mutateAsync({ id: sector.id, cragId, values })
    setEditingId(null)
  }

  async function handleDelete(sector: Sector) {
    if (!confirm(`Eliminare il settore "${sector.name}" e tutte le sue vie? L'operazione è irreversibile.`)) return
    await deleteSector.mutateAsync({ id: sector.id, cragId })
  }

  if (isLoading) return <div className="loading-state">Caricamento settori…</div>
  if (error) return <div className="error-state">Errore nel caricamento dei settori.</div>

  return (
    <div className="admin-section">
      <div className="admin-section-header">
        <span className="admin-section-title">Settori ({sectors?.length ?? 0})</span>
        {!creating && (
          <button className="btn-primary" onClick={() => setCreating(true)}>+ Nuovo settore</button>
        )}
      </div>

      {creating && (
        <SectorForm
          onSubmit={handleCreate}
          onCancel={() => setCreating(false)}
          isLoading={createSector.isPending}
        />
      )}

      {sectors?.length === 0 && !creating && (
        <div className="empty-state">Nessun settore. Aggiungine uno per iniziare.</div>
      )}

      {sectors?.map((sector) => (
        <div key={sector.id} className="admin-sector-block">
          {editingId === sector.id ? (
            <div style={{ padding: '12px 16px' }}>
              <SectorForm
                defaultValues={sector}
                onSubmit={(v) => handleUpdate(sector, v)}
                onCancel={() => setEditingId(null)}
                isLoading={updateSector.isPending}
              />
            </div>
          ) : (
            <>
              <div className="admin-sector-header">
                <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                  <button
                    className="admin-sector-toggle"
                    onClick={() => setExpandedId(expandedId === sector.id ? null : sector.id)}
                    title={expandedId === sector.id ? 'Nascondi vie' : 'Mostra vie'}
                  >
                    {expandedId === sector.id ? '▾' : '▸'}
                  </button>
                  <span className="admin-sector-name">{sector.name}</span>
                  {sector.orientation && (
                    <span className="sector-badge">{sector.orientation}</span>
                  )}
                </div>
                <div className="actions">
                  <button className="btn-edit" onClick={() => setEditingId(sector.id)}>Modifica</button>
                  <button className="btn-danger" onClick={() => handleDelete(sector)}>Elimina</button>
                </div>
              </div>

              {expandedId === sector.id && (
                <div className="admin-sector-body">
                  <RoutesAdmin sectorId={sector.id} />
                </div>
              )}
            </>
          )}
        </div>
      ))}

      {(createSector.isError || updateSector.isError || deleteSector.isError) && (
        <div className="admin-error">
          {((createSector.error || updateSector.error || deleteSector.error) as Error)?.message}
        </div>
      )}
    </div>
  )
}
