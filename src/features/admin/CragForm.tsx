import { type Resolver, useForm, useWatch } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import type { CragFormValues } from './hooks'
import { useAllAreas, useAllRegions } from './hooks'

const optNum = z
  .union([z.number(), z.nan(), z.null(), z.undefined()])
  .transform((v): number | null => {
    if (v == null || (typeof v === 'number' && isNaN(v))) return null
    return v
  })

const optStr = z
  .union([z.string(), z.null(), z.undefined()])
  .transform((v): string | null => (v == null || v === '' ? null : v))

const cragSchema = z.object({
  name: z.string().min(1, 'Nome richiesto'),
  region_id: z.string().min(1, 'Seleziona una regione'),
  area_id: optStr,
  municipality: optStr,
  province: optStr,
  latitude: optNum,
  longitude: optNum,
  altitude_m: optNum,
  rock_type: optStr,
  access_status: z.enum(['open', 'limited', 'closed']),
  approach_minutes: optNum,
  orientation: optStr,
  rainproof: z.boolean().optional().transform((v) => v ?? false),
  access_notes: optStr,
  parking_notes: optStr,
})

interface Props {
  defaultValues?: Partial<CragFormValues>
  onSubmit: (values: CragFormValues) => void
  onCancel: () => void
  isLoading?: boolean
}

export default function CragForm({ defaultValues, onSubmit, onCancel, isLoading }: Props) {
  const { data: regions } = useAllRegions()

  const { register, handleSubmit, control, formState: { errors } } = useForm<CragFormValues>({
    resolver: zodResolver(cragSchema) as Resolver<CragFormValues>,
    defaultValues: {
      name: defaultValues?.name ?? '',
      region_id: defaultValues?.region_id ?? '',
      municipality: defaultValues?.municipality ?? '',
      province: defaultValues?.province ?? '',
      latitude: defaultValues?.latitude ?? undefined,
      longitude: defaultValues?.longitude ?? undefined,
      altitude_m: defaultValues?.altitude_m ?? undefined,
      rock_type: defaultValues?.rock_type ?? '',
      access_status: (defaultValues?.access_status as 'open' | 'limited' | 'closed') ?? 'open',
      approach_minutes: defaultValues?.approach_minutes ?? undefined,
      orientation: defaultValues?.orientation ?? '',
      rainproof: defaultValues?.rainproof ?? false,
      access_notes: defaultValues?.access_notes ?? '',
      parking_notes: defaultValues?.parking_notes ?? '',
    },
  })

  const selectedRegionId = useWatch({ control, name: 'region_id' })
  const { data: areas } = useAllAreas(selectedRegionId ?? '')

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="inline-form">
      <div className="form-grid">
        <div className={`form-group${errors.name ? ' error' : ''}`}>
          <label>Nome *</label>
          <input {...register('name')} placeholder="es. Finale Ligure" />
          {errors.name && <span className="form-error">{errors.name.message}</span>}
        </div>
        <div className={`form-group${errors.region_id ? ' error' : ''}`}>
          <label>Regione *</label>
          <select {...register('region_id')}>
            <option value="">Seleziona regione…</option>
            {regions?.map((r) => (
              <option key={r.id} value={r.id}>{r.name}</option>
            ))}
          </select>
          {errors.region_id && <span className="form-error">{errors.region_id.message}</span>}
        </div>
        <div className="form-group">
          <label>Area territoriale</label>
          <select {...register('area_id')} disabled={!selectedRegionId || !areas?.length}>
            <option value="">— Nessuna area —</option>
            {areas?.map((a) => (
              <option key={a.id} value={a.id}>{a.name}</option>
            ))}
          </select>
        </div>
        <div className="form-group">
          <label>Comune</label>
          <input {...register('municipality')} placeholder="es. Finale Ligure" />
        </div>
        <div className="form-group">
          <label>Provincia</label>
          <input {...register('province')} placeholder="es. SV" />
        </div>
        <div className="form-group">
          <label>Latitudine</label>
          <input type="number" step="any" {...register('latitude', { valueAsNumber: true })} placeholder="es. 44.1667" />
        </div>
        <div className="form-group">
          <label>Longitudine</label>
          <input type="number" step="any" {...register('longitude', { valueAsNumber: true })} placeholder="es. 8.3500" />
        </div>
        <div className="form-group">
          <label>Altitudine (m)</label>
          <input type="number" {...register('altitude_m', { valueAsNumber: true })} placeholder="es. 250" />
        </div>
        <div className="form-group">
          <label>Tipo roccia</label>
          <input {...register('rock_type')} placeholder="es. calcare" />
        </div>
        <div className="form-group">
          <label>Accesso *</label>
          <select {...register('access_status')}>
            <option value="open">Aperta</option>
            <option value="limited">Limitata</option>
            <option value="closed">Chiusa</option>
          </select>
        </div>
        <div className="form-group">
          <label>Avvicinamento (min)</label>
          <input type="number" {...register('approach_minutes', { valueAsNumber: true })} placeholder="es. 15" />
        </div>
        <div className="form-group">
          <label>Orientamento</label>
          <input {...register('orientation')} placeholder="es. Sud, Sud-Ovest" />
        </div>
        <div className="form-group" style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingTop: 16 }}>
          <input type="checkbox" id="rainproof-chk" {...register('rainproof')} style={{ width: 'auto' }} />
          <label htmlFor="rainproof-chk" style={{ textTransform: 'none', fontSize: 13, color: 'var(--text)', letterSpacing: 0 }}>
            Pioggia OK
          </label>
        </div>
      </div>
      <div className="form-full form-group">
        <label>Note accesso</label>
        <textarea {...register('access_notes')} placeholder="Informazioni sull'accesso alla falesia…" />
      </div>
      <div className="form-full form-group">
        <label>Note parcheggio</label>
        <textarea {...register('parking_notes')} placeholder="Dove parcheggiare…" />
      </div>
      <div className="form-actions">
        <button type="button" className="btn-secondary" onClick={onCancel}>Annulla</button>
        <button type="submit" className="btn-primary" disabled={isLoading}>
          {isLoading ? 'Salvataggio…' : 'Salva falesia'}
        </button>
      </div>
    </form>
  )
}
