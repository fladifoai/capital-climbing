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

// ─── Key definitions (with icons) ────────────────────────────────────────────

const STYLE_KEYS = [
  { key: 'technical',   label: 'Tecnica',       icon: '🎯' },
  { key: 'powerful',    label: 'Potente',        icon: '💪' },
  { key: 'endurance',   label: 'Resistenza',     icon: '🔋' },
  { key: 'sustained',   label: 'Continuità',     icon: '〰️' },
  { key: 'boulderish',  label: 'Boulderosa',     icon: '🪨' },
  { key: 'physical',    label: 'Fisica',         icon: '⚡' },
  { key: 'balance',     label: 'Equilibrio',     icon: '⚖️' },
  { key: 'reading',     label: 'Lettura',        icon: '👁️' },
  { key: 'finger',      label: 'Dita',           icon: '✌️' },
  { key: 'footwork',    label: 'Piedi',          icon: '👣' },
  { key: 'pumpy',       label: 'Pompante',       icon: '🔥' },
  { key: 'mental',      label: 'Mentale',        icon: '🧠' },
  { key: 'single_crux', label: 'Crux singolo',   icon: '🔺' },
  { key: 'hard_start',  label: 'Partenza dura',  icon: '🚀' },
  { key: 'hard_finish', label: 'Finale duro',    icon: '🏁' },
  { key: 'consistent',  label: 'Omogenea',       icon: '📊' },
  { key: 'overhang',    label: 'Strapiombo',     icon: '↙️' },
  { key: 'slab',        label: 'Placca',         icon: '↗️' },
  { key: 'wall',        label: 'Verticale',      icon: '⬜' },
  { key: 'diedre',      label: 'Diedro',         icon: '📐' },
  { key: 'crack',       label: 'Fessura',        icon: '〓' },
  { key: 'roof',        label: 'Tetto',          icon: '🏛️' },
]

const HOLD_KEYS = [
  { key: 'crimp_sharp',    label: 'Tacche nette',    icon: '✂️' },
  { key: 'crimp_rounded',  label: 'Tacche tonde',    icon: '🔘' },
  { key: 'mono',           label: 'Monoditi',        icon: '☝️' },
  { key: 'two_finger',     label: 'Biditi',          icon: '✌️' },
  { key: 'three_finger',   label: 'Triditi',         icon: '🤟' },
  { key: 'sloper',         label: 'Svasi',           icon: '🌙' },
  { key: 'pinch',          label: 'Pinze',           icon: '🤏' },
  { key: 'jug',            label: 'Maniglie',        icon: '🪝' },
  { key: 'barrel',         label: 'Canne',           icon: '🪵' },
  { key: 'sidepull',       label: 'Laterali',        icon: '↔️' },
  { key: 'gaston',         label: 'Gaston',          icon: '↩️' },
  { key: 'undercling',     label: 'Sottoprese',      icon: '⬆️' },
  { key: 'crack',          label: 'Fessure',         icon: '〓' },
  { key: 'foothold_large', label: 'Appoggi grandi',  icon: '🟫' },
  { key: 'foothold_small', label: 'Appoggi piccoli', icon: '🔴' },
  { key: 'slick',          label: 'Lucide',          icon: '💧' },
  { key: 'sharp',          label: 'Taglienti',       icon: '🪒' },
  { key: 'morphological',  label: 'Morfologiche',    icon: '🔮' },
]

const MOVEMENT_KEYS = [
  { key: 'static',       label: 'Statico',       icon: '🗿' },
  { key: 'dynamic',      label: 'Dinamico',      icon: '💥' },
  { key: 'jump',         label: 'Lancio',        icon: '🦘' },
  { key: 'long_reach',   label: 'Allungo',       icon: '🤸' },
  { key: 'cross',        label: 'Incrocio',      icon: '✖️' },
  { key: 'hand_swap',    label: 'Cambio mano',   icon: '🔄' },
  { key: 'foot_swap',    label: 'Cambio piedi',  icon: '👣' },
  { key: 'flag',         label: 'Bandiera',      icon: '🚩' },
  { key: 'bicycle',      label: 'Bicicletta',    icon: '🚲' },
  { key: 'lolotte',      label: 'Lolotte',       icon: '🦵' },
  { key: 'dulfer',       label: 'Dülfer',        icon: '↕️' },
  { key: 'compression',  label: 'Compressione',  icon: '🤲' },
  { key: 'opposition',   label: 'Opposizione',   icon: '↩️' },
  { key: 'heel_hook',    label: 'Tallonaggio',   icon: '🦶' },
  { key: 'toe_hook',     label: 'Toe hook',      icon: '🩰' },
  { key: 'kneebar',      label: 'Kneebar',       icon: '🦿' },
  { key: 'campus',       label: 'Campus',        icon: '🪜' },
  { key: 'coordination', label: 'Coordinazione', icon: '🎲' },
  { key: 'mandatory',    label: 'Obbligato',     icon: '⚠️' },
  { key: 'mantle',       label: 'Ristabilim.',   icon: '⬆️' },
  { key: 'traverse',     label: 'Traverso',      icon: '⬅️' },
  { key: 'rock_over',    label: 'Ribaltamento',  icon: '🔃' },
  { key: 'jam',          label: 'Incastro',      icon: '✊' },
  { key: 'drop_knee',    label: 'Drop knee',     icon: '⬇️' },
  { key: 'deadpoint',    label: 'Deadpoint',     icon: '⭕' },
]

const LEVEL_CYCLE: ProfileLevel[] = ['none', 'secondary', 'important', 'dominant']

type SectionColor = 'orange' | 'blue' | 'teal'
const SECTION_COLORS: Record<string, SectionColor> = {
  stile: 'orange',
  prese: 'blue',
  movimenti: 'teal',
}

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

// ─── ProfileSection ───────────────────────────────────────────────────────────

function ProfileSection({
  title, sectionKey, keys, profile, onChange, iconMode,
}: {
  title: string
  sectionKey: string
  keys: { key: string; label: string; icon: string }[]
  profile: Profile
  onChange: (key: string, val: ProfileLevel) => void
  iconMode?: boolean
}) {
  const color: SectionColor = SECTION_COLORS[sectionKey] ?? 'orange'

  if (iconMode) {
    return (
      <>
        <div className={`log-section-icon-header pic-${color}`}>{title}</div>
        <div className="profile-icon-grid">
          {keys.map(({ key, label, icon }) => {
            const isActive = (profile[key] ?? 'none') !== 'none'
            return (
              <button
                key={key}
                type="button"
                className={`profile-icon-card pic--${color}${isActive ? ' pic-active' : ''}`}
                onClick={() => onChange(key, isActive ? 'none' : 'dominant')}
                title={label}
              >
                <span className="pic-icon">{icon}</span>
                <span className="pic-label">{label}</span>
              </button>
            )
          })}
        </div>
      </>
    )
  }

  function cycle(key: string) {
    const cur = profile[key] ?? 'none'
    const next = LEVEL_CYCLE[(LEVEL_CYCLE.indexOf(cur) + 1) % LEVEL_CYCLE.length]
    onChange(key, next)
  }

  return (
    <>
      <div className="log-section-title">
        {title}{' '}
        <span style={{ fontWeight: 400, fontSize: 10, textTransform: 'none', letterSpacing: 0, color: 'var(--text-muted)', marginLeft: 4 }}>
          clicca per aggiungere / aumentare livello
        </span>
      </div>
      <div className="profile-toggle-grid">
        {keys.map(({ key, label }) => {
          const val = profile[key] ?? 'none'
          return (
            <button
              key={key}
              type="button"
              className="profile-toggle-card"
              data-level={val}
              onClick={() => cycle(key)}
              title={val === 'none' ? 'Clicca per aggiungere' : `Livello: ${val} — clicca per cambiare`}
            >
              <span className="profile-toggle-dot" />
              {label}
            </button>
          )
        })}
      </div>
    </>
  )
}

// ─── Props ────────────────────────────────────────────────────────────────────

interface Props {
  sections?: ('stile' | 'prese' | 'movimenti' | 'beta' | 'kneepad' | 'equipment' | 'safety')[]
  initialNote?: UserRouteNote | null
  /** Pass current accumulated values when mounting a new step to preserve cross-step state */
  initialValues?: RouteNotesValues
  /** Renders large icon cards with ON/OFF toggle instead of pill levels */
  iconMode?: boolean
  onChange: (values: RouteNotesValues) => void
}

// ─── Main component ───────────────────────────────────────────────────────────

export default function RouteNotesForm({ sections, initialNote, initialValues, iconMode, onChange }: Props) {
  const show = sections ?? ['stile', 'prese', 'movimenti', 'beta', 'kneepad', 'equipment', 'safety']
  const [v, setV] = useState<RouteNotesValues>(() => initialValues ?? fromExisting(initialNote ?? null))

  useEffect(() => {
    if (initialValues === undefined) {
      setV(fromExisting(initialNote ?? null))
    }
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
      {show.includes('stile') && (
        <ProfileSection
          title="Stile via"
          sectionKey="stile"
          keys={STYLE_KEYS}
          profile={v.style_profile}
          onChange={(k, val) => setProfile('style_profile', k, val)}
          iconMode={iconMode}
        />
      )}

      {show.includes('prese') && (
        <ProfileSection
          title="Prese"
          sectionKey="prese"
          keys={HOLD_KEYS}
          profile={v.hold_profile}
          onChange={(k, val) => setProfile('hold_profile', k, val)}
          iconMode={iconMode}
        />
      )}

      {show.includes('movimenti') && (
        <ProfileSection
          title="Movimenti"
          sectionKey="movimenti"
          keys={MOVEMENT_KEYS}
          profile={v.movement_profile}
          onChange={(k, val) => setProfile('movement_profile', k, val)}
          iconMode={iconMode}
        />
      )}

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
              <input type="text" value={v.crux}
                onChange={e => update({ crux: e.target.value })}
                placeholder="Descrizione del crux…" />
            </div>
            <div className="form-group">
              <label>Riposi</label>
              <input type="text" value={v.rests}
                onChange={e => update({ rests: e.target.value })}
                placeholder="Posizioni di riposo, no-hand rest…" />
            </div>
          </div>
        </>
      )}

      {show.includes('kneepad') && (
        <>
          <div className="log-section-title">Kneepad & Kneebar</div>
          <div className="form-grid">
            <div className="form-group" style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingTop: 4 }}>
              <input type="checkbox" id="kp-used" checked={v.kneepad_used}
                onChange={e => update({ kneepad_used: e.target.checked })} style={{ width: 'auto' }} />
              <label htmlFor="kp-used" style={{ textTransform: 'none', fontSize: 13, letterSpacing: 0 }}>
                Kneepad usato in questa salita
              </label>
            </div>
            <div className="form-group" style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingTop: 4 }}>
              <input type="checkbox" id="kp-possible" checked={!!kd.kneepad_possible}
                onChange={e => setKneepad({ kneepad_possible: e.target.checked })} style={{ width: 'auto' }} />
              <label htmlFor="kp-possible" style={{ textTransform: 'none', fontSize: 13, letterSpacing: 0 }}>
                Kneepad possibile su questa via
              </label>
            </div>
            <div className="form-group">
              <label>Utilità kneepad</label>
              <select className="logbook-select" value={kd.usefulness ?? ''}
                onChange={e => setKneepad({ usefulness: e.target.value as KneepadData['usefulness'] })}>
                <option value="">— Non specificato —</option>
                <option value="not_needed">Non necessario</option>
                <option value="useful">Utile</option>
                <option value="very_useful">Molto utile</option>
                <option value="essential">Indispensabile</option>
              </select>
            </div>
            <div className="form-group">
              <label>Ginocchio</label>
              <select className="logbook-select" value={kd.knee ?? ''}
                onChange={e => setKneepad({ knee: e.target.value as KneepadData['knee'] })}>
                <option value="">— Non specificato —</option>
                <option value="left">Sinistro</option>
                <option value="right">Destro</option>
                <option value="both">Entrambi</option>
              </select>
            </div>
            <div className="form-group">
              <label>N° kneebar</label>
              <input type="number" min={0} value={kd.kneebar_count ?? ''}
                onChange={e => setKneepad({ kneebar_count: e.target.value ? Number(e.target.value) : null })}
                placeholder="0" />
            </div>
            <div className="form-group form-full">
              <label>Note kneepad</label>
              <input type="text" value={kd.notes ?? ''}
                onChange={e => setKneepad({ notes: e.target.value })}
                placeholder="Posizione, metodo, differenza percepita…" />
            </div>
          </div>
        </>
      )}

      {show.includes('equipment') && (
        <>
          <div className="log-section-title">Attrezzatura</div>
          <div className="form-grid">
            <div className="form-group">
              <label>Scarpette usate</label>
              <input type="text" value={eq.shoes ?? ''}
                onChange={e => setEquipment({ shoes: e.target.value })}
                placeholder="Modello scarpette…" />
            </div>
            <div className="form-group">
              <label>Corda min.</label>
              <input type="text" value={eq.rope_min ?? ''}
                onChange={e => setEquipment({ rope_min: e.target.value })}
                placeholder="es. 70m" />
            </div>
            <div className="form-group">
              <label>Rinvii minimi</label>
              <input type="number" min={0} value={eq.quickdraws_min ?? ''}
                onChange={e => setEquipment({ quickdraws_min: e.target.value ? Number(e.target.value) : null })}
                placeholder="12" />
            </div>
            <div className="form-group">
              <label>Rinvii consigliati</label>
              <input type="number" min={0} value={eq.quickdraws_recommended ?? ''}
                onChange={e => setEquipment({ quickdraws_recommended: e.target.value ? Number(e.target.value) : null })}
                placeholder="14" />
            </div>
            <div className="form-group" style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingTop: 4 }}>
              <input type="checkbox" id="eq-stick" checked={!!eq.stick_clip}
                onChange={e => setEquipment({ stick_clip: e.target.checked })} style={{ width: 'auto' }} />
              <label htmlFor="eq-stick" style={{ textTransform: 'none', fontSize: 13, letterSpacing: 0 }}>
                Stick clip consigliato
              </label>
            </div>
            <div className="form-group" style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingTop: 4 }}>
              <input type="checkbox" id="eq-helmet" checked={!!eq.helmet}
                onChange={e => setEquipment({ helmet: e.target.checked })} style={{ width: 'auto' }} />
              <label htmlFor="eq-helmet" style={{ textTransform: 'none', fontSize: 13, letterSpacing: 0 }}>
                Casco consigliato
              </label>
            </div>
            <div className="form-group form-full">
              <label>Note attrezzatura</label>
              <input type="text" value={eq.notes ?? ''}
                onChange={e => setEquipment({ notes: e.target.value })}
                placeholder="Materiale aggiuntivo, chalk, spazzola…" />
            </div>
          </div>
        </>
      )}

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
