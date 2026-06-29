import { useState, useEffect } from 'react'
import type { UserRouteNote } from '../../types/database'
import type { RouteNotesPayload } from './hooks'
import '../../styles/log-new.css'

// ─── Types ───────────────────────────────────────────────────────────────────

export type ProfileLevel = 'none' | 'secondary' | 'important' | 'dominant'
type Profile = Record<string, ProfileLevel>

interface KneepadData {
  kneepad_possible?: boolean
  usefulness?: '' | 'not_needed' | 'useful' | 'very_useful' | 'essential'
  knee?: '' | 'left' | 'right' | 'both'
  kneebar_count?: number | null
  notes?: string
}

interface EquipmentData {
  shoes?: string
  rope_min?: string
  quickdraws_min?: number | null
  quickdraws_recommended?: number | null
  stick_clip?: boolean
  helmet?: boolean
  notes?: string
}

export interface RouteNotesValues {
  hold_profile: Profile
  movement_profile: Profile
  style_profile: Profile
  crux: string
  rests: string
  main_beta: string
  alternative_beta: string
  kneepad_used: boolean
  kneepad_data: KneepadData
  equipment_data: EquipmentData
  safety_notes: string
}

// ─── Key definitions ─────────────────────────────────────────────────────────

const STYLE_KEYS = [
  { key: 'technical', label: 'Tecnica' }, { key: 'powerful', label: 'Potente' },
  { key: 'endurance', label: 'Resistenza' }, { key: 'sustained', label: 'Continuità' },
  { key: 'boulderish', label: 'Boulderosa' }, { key: 'physical', label: 'Fisica' },
  { key: 'balance', label: 'Equilibrio' }, { key: 'reading', label: 'Lettura' },
  { key: 'finger', label: 'Dita' }, { key: 'footwork', label: 'Piedi' },
  { key: 'pumpy', label: 'Pompante' }, { key: 'mental', label: 'Mentale' },
  { key: 'single_crux', label: 'Crux singolo' }, { key: 'hard_start', label: 'Partenza dura' },
  { key: 'hard_finish', label: 'Finale duro' }, { key: 'consistent', label: 'Omogenea' },
  { key: 'overhang', label: 'Strapiombante' }, { key: 'slab', label: 'Placca' },
  { key: 'wall', label: 'Verticale' }, { key: 'diedre', label: 'Diedro' },
  { key: 'crack', label: 'Fessura' }, { key: 'roof', label: 'Tetto' },
]

const HOLD_KEYS = [
  { key: 'crimp_sharp', label: 'Tacche nette' }, { key: 'crimp_rounded', label: 'Tacche arrotondate' },
  { key: 'mono', label: 'Monoditi' }, { key: 'two_finger', label: 'Biditi' },
  { key: 'three_finger', label: 'Triditi' }, { key: 'sloper', label: 'Svasi' },
  { key: 'pinch', label: 'Pinze' }, { key: 'jug', label: 'Maniglie' },
  { key: 'barrel', label: 'Canne' }, { key: 'sidepull', label: 'Laterali' },
  { key: 'gaston', label: 'Gaston' }, { key: 'undercling', label: 'Sottoprese' },
  { key: 'crack', label: 'Fessure' }, { key: 'foothold_large', label: 'Appoggi grandi' },
  { key: 'foothold_small', label: 'Appoggi piccoli' }, { key: 'slick', label: 'Lucide' },
  { key: 'sharp', label: 'Taglienti' }, { key: 'morphological', label: 'Morfologiche' },
]

const MOVEMENT_KEYS = [
  { key: 'static', label: 'Statico' }, { key: 'dynamic', label: 'Dinamico' },
  { key: 'jump', label: 'Lancio' }, { key: 'long_reach', label: 'Allungo' },
  { key: 'cross', label: 'Incrocio' }, { key: 'hand_swap', label: 'Cambio mano' },
  { key: 'foot_swap', label: 'Cambio piedi' }, { key: 'flag', label: 'Bandiera' },
  { key: 'bicycle', label: 'Bicicletta' }, { key: 'lolotte', label: 'Lolotte' },
  { key: 'dulfer', label: 'Dülfer' }, { key: 'compression', label: 'Compressione' },
  { key: 'opposition', label: 'Opposizione' }, { key: 'heel_hook', label: 'Tallonaggio' },
  { key: 'toe_hook', label: 'Toe hook' }, { key: 'kneebar', label: 'Kneebar' },
  { key: 'campus', label: 'Campus' }, { key: 'coordination', label: 'Coordinazione' },
  { key: 'mandatory', label: 'Obbligato' }, { key: 'mantle', label: 'Ristabilimento' },
  { key: 'traverse', label: 'Traverso' }, { key: 'rock_over', label: 'Ribaltamento' },
  { key: 'jam', label: 'Incastro' }, { key: 'drop_knee', label: 'Drop knee' },
  { key: 'deadpoint', label: 'Deadpoint' },
]

const LEVEL_OPTIONS: { value: ProfileLevel; label: string }[] = [
  { value: 'none', label: '—' },
  { value: 'secondary', label: 'Sec.' },
  { value: 'important', label: 'Imp.' },
  { value: 'dominant', label: 'Dom.' },
]

// ─── Helpers ─────────────────────────────────────────────────────────────────

function emptyValues(): RouteNotesValues {
  return {
    hold_profile: {},
    movement_profile: {},
    style_profile: {},
    crux: '',
    rests: '',
    main_beta: '',
    alternative_beta: '',
    kneepad_used: false,
    kneepad_data: {},
    equipment_data: {},
    safety_notes: '',
  }
}

function fromExisting(note: UserRouteNote | null | undefined): RouteNotesValues {
  if (!note) return emptyValues()
  const kd = (note.kneepad_data ?? {}) as KneepadData
  return {
    hold_profile: (note.hold_profile ?? {}) as Profile,
    movement_profile: (note.movement_profile ?? {}) as Profile,
    style_profile: (note.style_profile ?? {}) as Profile,
    crux: note.crux ?? '',
    rests: note.rests ?? '',
    main_beta: note.main_beta ?? '',
    alternative_beta: note.alternative_beta ?? '',
    kneepad_used: !!(note.kneepad_data as { kneepad_used?: boolean } | null)?.kneepad_used,
    kneepad_data: kd,
    equipment_data: (note.equipment_data ?? {}) as EquipmentData,
    safety_notes: note.safety_notes ?? '',
  }
}

export function toPayload(
  values: RouteNotesValues,
  userId: string,
  routeId: string,
  visibility: 'public' | 'private' = 'private'
): RouteNotesPayload {
  const kd: Record<string, unknown> = {
    ...values.kneepad_data,
    kneepad_used: values.kneepad_used,
  }
  return {
    user_id: userId,
    route_id: routeId,
    hold_profile: values.hold_profile,
    movement_profile: values.movement_profile,
    style_profile: values.style_profile,
    crux: values.crux || null,
    rests: values.rests || null,
    main_beta: values.main_beta || null,
    alternative_beta: values.alternative_beta || null,
    kneepad_data: kd,
    equipment_data: values.equipment_data as Record<string, unknown>,
    safety_notes: values.safety_notes || null,
    visibility,
  }
}

export function hasAnyData(values: RouteNotesValues): boolean {
  return (
    Object.values(values.hold_profile).some(v => v !== 'none') ||
    Object.values(values.movement_profile).some(v => v !== 'none') ||
    Object.values(values.style_profile).some(v => v !== 'none') ||
    !!values.crux || !!values.rests || !!values.main_beta || !!values.alternative_beta ||
    values.kneepad_used ||
    !!(values.equipment_data as EquipmentData).shoes ||
    !!values.safety_notes
  )
}

// ─── Sub-components ───────────────────────────────────────────────────────────

function ProfileSection({
  title, keys, profile,
  onChange,
}: {
  title: string
  keys: { key: string; label: string }[]
  profile: Profile
  onChange: (key: string, val: ProfileLevel) => void
}) {
  return (
    <>
      <div className="log-section-title">{title}</div>
      <div className="profile-edit-grid">
        {keys.map(({ key, label }) => {
          const val = profile[key] ?? 'none'
          return (
            <div key={key} className="profile-edit-item">
              <span className="profile-edit-label">{label}</span>
              <select
                className={`profile-edit-select${val !== 'none' ? ' has-value' : ''}`}
                value={val}
                onChange={e => onChange(key, e.target.value as ProfileLevel)}
              >
                {LEVEL_OPTIONS.map(o => (
                  <option key={o.value} value={o.value}>{o.label}</option>
                ))}
              </select>
            </div>
          )
        })}
      </div>
    </>
  )
}

// ─── Props ────────────────────────────────────────────────────────────────────

interface Props {
  /** Which sections to show. Default: all */
  sections?: ('stile' | 'prese' | 'movimenti' | 'beta' | 'kneepad' | 'equipment' | 'safety')[]
  initialNote?: UserRouteNote | null
  onChange: (values: RouteNotesValues) => void
}

// ─── Main component ───────────────────────────────────────────────────────────

export default function RouteNotesForm({ sections, initialNote, onChange }: Props) {
  const show = sections ?? ['stile', 'prese', 'movimenti', 'beta', 'kneepad', 'equipment', 'safety']
  const [v, setV] = useState<RouteNotesValues>(() => fromExisting(initialNote))

  useEffect(() => {
    setV(fromExisting(initialNote))
  }, [initialNote])

  function update(partial: Partial<RouteNotesValues>) {
    setV(prev => {
      const next = { ...prev, ...partial }
      onChange(next)
      return next
    })
  }

  function setProfile(type: 'hold_profile' | 'movement_profile' | 'style_profile', key: string, val: ProfileLevel) {
    setV(prev => {
      const next = { ...prev, [type]: { ...prev[type], [key]: val } }
      onChange(next)
      return next
    })
  }

  function setKneepad(partial: Partial<KneepadData>) {
    setV(prev => {
      const next = { ...prev, kneepad_data: { ...prev.kneepad_data, ...partial } }
      onChange(next)
      return next
    })
  }

  function setEquipment(partial: Partial<EquipmentData>) {
    setV(prev => {
      const next = { ...prev, equipment_data: { ...prev.equipment_data, ...partial } }
      onChange(next)
      return next
    })
  }

  const kd = v.kneepad_data as KneepadData
  const eq = v.equipment_data as EquipmentData

  return (
    <div>
      {/* ── Stile via ── */}
      {show.includes('stile') && (
        <ProfileSection
          title="Stile via"
          keys={STYLE_KEYS}
          profile={v.style_profile}
          onChange={(k, val) => setProfile('style_profile', k, val)}
        />
      )}

      {/* ── Prese ── */}
      {show.includes('prese') && (
        <ProfileSection
          title="Prese"
          keys={HOLD_KEYS}
          profile={v.hold_profile}
          onChange={(k, val) => setProfile('hold_profile', k, val)}
        />
      )}

      {/* ── Movimenti ── */}
      {show.includes('movimenti') && (
        <ProfileSection
          title="Movimenti"
          keys={MOVEMENT_KEYS}
          profile={v.movement_profile}
          onChange={(k, val) => setProfile('movement_profile', k, val)}
        />
      )}

      {/* ── Beta ── */}
      {show.includes('beta') && (
        <>
          <div className="log-section-title">Beta & Crux</div>
          <div className="form-grid">
            <div className="form-group form-full">
              <label>Beta principale</label>
              <textarea
                value={v.main_beta}
                onChange={e => update({ main_beta: e.target.value })}
                placeholder="Sequenza o metodo principale per chiudere la via…"
                rows={3}
              />
            </div>
            <div className="form-group form-full">
              <label>Beta alternativa</label>
              <textarea
                value={v.alternative_beta}
                onChange={e => update({ alternative_beta: e.target.value })}
                placeholder="Metodo alternativo, variante…"
                rows={2}
              />
            </div>
            <div className="form-group">
              <label>Crux</label>
              <input
                type="text"
                value={v.crux}
                onChange={e => update({ crux: e.target.value })}
                placeholder="Descrizione del crux…"
              />
            </div>
            <div className="form-group">
              <label>Riposi</label>
              <input
                type="text"
                value={v.rests}
                onChange={e => update({ rests: e.target.value })}
                placeholder="Posizioni di riposo, no-hand rest…"
              />
            </div>
          </div>
        </>
      )}

      {/* ── Kneepad ── */}
      {show.includes('kneepad') && (
        <>
          <div className="log-section-title">Kneepad & Kneebar</div>
          <div className="form-grid">
            <div className="form-group" style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingTop: 4 }}>
              <input
                type="checkbox"
                id="kp-used"
                checked={v.kneepad_used}
                onChange={e => update({ kneepad_used: e.target.checked })}
                style={{ width: 'auto' }}
              />
              <label htmlFor="kp-used" style={{ textTransform: 'none', fontSize: 13, letterSpacing: 0 }}>
                Kneepad usato in questa salita
              </label>
            </div>
            <div className="form-group" style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingTop: 4 }}>
              <input
                type="checkbox"
                id="kp-possible"
                checked={!!kd.kneepad_possible}
                onChange={e => setKneepad({ kneepad_possible: e.target.checked })}
                style={{ width: 'auto' }}
              />
              <label htmlFor="kp-possible" style={{ textTransform: 'none', fontSize: 13, letterSpacing: 0 }}>
                Kneepad possibile su questa via
              </label>
            </div>
            <div className="form-group">
              <label>Utilità kneepad</label>
              <select
                className="logbook-select"
                value={kd.usefulness ?? ''}
                onChange={e => setKneepad({ usefulness: e.target.value as KneepadData['usefulness'] })}
              >
                <option value="">— Non specificato —</option>
                <option value="not_needed">Non necessario</option>
                <option value="useful">Utile</option>
                <option value="very_useful">Molto utile</option>
                <option value="essential">Indispensabile</option>
              </select>
            </div>
            <div className="form-group">
              <label>Ginocchio</label>
              <select
                className="logbook-select"
                value={kd.knee ?? ''}
                onChange={e => setKneepad({ knee: e.target.value as KneepadData['knee'] })}
              >
                <option value="">— Non specificato —</option>
                <option value="left">Sinistro</option>
                <option value="right">Destro</option>
                <option value="both">Entrambi</option>
              </select>
            </div>
            <div className="form-group">
              <label>N° kneebar</label>
              <input
                type="number"
                min={0}
                value={kd.kneebar_count ?? ''}
                onChange={e => setKneepad({ kneebar_count: e.target.value ? Number(e.target.value) : null })}
                placeholder="0"
              />
            </div>
            <div className="form-group form-full">
              <label>Note kneepad</label>
              <input
                type="text"
                value={kd.notes ?? ''}
                onChange={e => setKneepad({ notes: e.target.value })}
                placeholder="Posizione, metodo, differenza percepita…"
              />
            </div>
          </div>
        </>
      )}

      {/* ── Attrezzatura ── */}
      {show.includes('equipment') && (
        <>
          <div className="log-section-title">Attrezzatura</div>
          <div className="form-grid">
            <div className="form-group">
              <label>Scarpette usate</label>
              <input
                type="text"
                value={eq.shoes ?? ''}
                onChange={e => setEquipment({ shoes: e.target.value })}
                placeholder="Modello scarpette…"
              />
            </div>
            <div className="form-group">
              <label>Corda min.</label>
              <input
                type="text"
                value={eq.rope_min ?? ''}
                onChange={e => setEquipment({ rope_min: e.target.value })}
                placeholder="es. 70m"
              />
            </div>
            <div className="form-group">
              <label>Rinvii minimi</label>
              <input
                type="number"
                min={0}
                value={eq.quickdraws_min ?? ''}
                onChange={e => setEquipment({ quickdraws_min: e.target.value ? Number(e.target.value) : null })}
                placeholder="12"
              />
            </div>
            <div className="form-group">
              <label>Rinvii consigliati</label>
              <input
                type="number"
                min={0}
                value={eq.quickdraws_recommended ?? ''}
                onChange={e => setEquipment({ quickdraws_recommended: e.target.value ? Number(e.target.value) : null })}
                placeholder="14"
              />
            </div>
            <div className="form-group" style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingTop: 4 }}>
              <input
                type="checkbox"
                id="eq-stick"
                checked={!!eq.stick_clip}
                onChange={e => setEquipment({ stick_clip: e.target.checked })}
                style={{ width: 'auto' }}
              />
              <label htmlFor="eq-stick" style={{ textTransform: 'none', fontSize: 13, letterSpacing: 0 }}>
                Stick clip consigliato
              </label>
            </div>
            <div className="form-group" style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingTop: 4 }}>
              <input
                type="checkbox"
                id="eq-helmet"
                checked={!!eq.helmet}
                onChange={e => setEquipment({ helmet: e.target.checked })}
                style={{ width: 'auto' }}
              />
              <label htmlFor="eq-helmet" style={{ textTransform: 'none', fontSize: 13, letterSpacing: 0 }}>
                Casco consigliato
              </label>
            </div>
            <div className="form-group form-full">
              <label>Note attrezzatura</label>
              <input
                type="text"
                value={eq.notes ?? ''}
                onChange={e => setEquipment({ notes: e.target.value })}
                placeholder="Materiale aggiuntivo, chalk, spazzola…"
              />
            </div>
          </div>
        </>
      )}

      {/* ── Sicurezza ── */}
      {show.includes('safety') && (
        <>
          <div className="log-section-title">Sicurezza</div>
          <div className="form-group">
            <label>Note sicurezza</label>
            <textarea
              value={v.safety_notes}
              onChange={e => update({ safety_notes: e.target.value })}
              placeholder="Qualità catena/chiodatura, roccia instabile, primo spit alto, rischio terra, casco consigliato…"
              rows={3}
            />
          </div>
        </>
      )}
    </div>
  )
}
