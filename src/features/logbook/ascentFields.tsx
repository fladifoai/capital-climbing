import { useState } from 'react'
import { useRouteSearch, type AscentFormValues, type AscentUpdateValues, type RouteSearchResult } from './hooks'
import { useRoute } from '../catalog/hooks'
import { GRADE_ORDER, gradeToNum } from '../../analytics/normalizers/grades'
import type { AttemptBucket } from '../../analytics/calculations/attempt-buckets'
import '../../styles/log-new.css'
import '../../styles/logbook.css'
import '../../styles/admin.css'

// ─── Costanti condivise ─────────────────────────────────────────────────────

export const QUICK_MODES = [
  { value: 'onsight',  label: 'On-sight', icon: '👁️' },
  { value: 'flash',    label: 'Flash',    icon: '⚡' },
  { value: 'redpoint', label: 'Redpoint', icon: '🔴' },
]

export const EXACT_TRIES = ['2', '3', '4', '5', '6', '7', '8', '9', '10']

// Un'opzione è "redpoint" se non è né on-sight né flash (numero giri o bucket).
export const isRedpointOption = (opt: string) => opt !== 'onsight' && opt !== 'flash'

// Opzioni della tendina "numero di giri": 2°…10° giro + bucket oltre il 10°.
export const REDPOINT_OPTIONS: { value: string; label: string }[] = [
  ...EXACT_TRIES.map(n => ({ value: n, label: `${n}° giro` })),
  { value: '11_20',   label: '11-20 giri' },
  { value: '21_30',   label: '21-30 giri' },
  { value: '31_40',   label: '31-40 giri' },
  { value: '41_50',   label: '41-50 giri' },
  { value: '50_plus', label: '50+ giri' },
]

// Decimale del grado proposto: .1–.9 (raffina il grado community)
export const GRADE_DECIMALS = ['1', '2', '3', '4', '5', '6', '7', '8', '9']

export const DIFFICULTY_FEEL_OPTIONS = [
  { value: 'soft',      label: 'Soft' },
  { value: 'fair',      label: 'Giusta' },
  { value: 'hard',      label: 'Hard' },
  { value: 'very_hard', label: 'Molto hard' },
]

export const STYLE_FEEL_OPTIONS = [
  { value: 'my_style',   label: 'Mio stile' },
  { value: 'neutral',    label: 'Neutro' },
  { value: 'anti_style', label: 'Anti-stile' },
]

const DRAWS_OPTIONS = [
  { value: 'unknown', label: 'Non ricordo' },
  { value: 'preplaced', label: 'Rinvii già presenti' },
  { value: 'placed_by_user', label: 'Ho montato la via' },
]

export function formatMode(opt: string, repeat: boolean): string {
  if (repeat) return 'Ripetizione'
  if (opt === 'onsight') return 'On-sight'
  if (opt === 'flash') return 'Flash'
  const bucketLabels: Record<string, string> = {
    '11_20': '11-20 giri', '21_30': '21-30 giri',
    '31_40': '31-40 giri', '41_50': '41-50 giri', '50_plus': '50+ giri',
  }
  if (bucketLabels[opt]) return `Redpoint (${bucketLabels[opt]})`
  return `Redpoint (${opt}° giro)`
}

// Mappa l'opzione stile scelta → ascent_style / attempt_count / attempt_bucket.
export function buildMapped(option: string, isRepeat: boolean): {
  ascent_style: string; attempt_count: number | null; attempt_bucket: AttemptBucket | null
} {
  if (isRepeat) return { ascent_style: 'repeat', attempt_count: null, attempt_bucket: null }
  if (option === 'onsight') return { ascent_style: 'onsight', attempt_count: 1, attempt_bucket: '1' }
  if (option === 'flash')   return { ascent_style: 'flash',   attempt_count: 1, attempt_bucket: '1' }
  if (EXACT_TRIES.includes(option)) {
    const n = parseInt(option)
    return { ascent_style: 'redpoint', attempt_count: n, attempt_bucket: option as AttemptBucket }
  }
  return { ascent_style: 'redpoint', attempt_count: null, attempt_bucket: option as AttemptBucket }
}

// Ricava l'opzione stile della UI da un record già salvato (per la modalità edit).
export function deriveOptionFromRecord(
  style: string | null,
  count: number | null,
  bucket: string | null,
): string {
  if (style === 'onsight') return 'onsight'
  if (style === 'flash') return 'flash'
  // redpoint (o storico): usa il bucket se valido, altrimenti il conteggio.
  if (bucket && bucket !== '1') return bucket
  if (count && count >= 2) return String(count)
  return '2'
}

// "6b.8" → { base: '6b', dec: '8' }; "6b" → { base: '6b', dec: '' }
export function parseProposed(g: string | null): { base: string; dec: string } {
  if (!g) return { base: '', dec: '' }
  const dot = g.indexOf('.')
  if (dot === -1) return { base: g, dec: '' }
  return { base: g.slice(0, dot), dec: g.slice(dot + 1) }
}

// ─── Hook controller ────────────────────────────────────────────────────────

export interface AscentFieldsInit {
  date?: string
  selectedOption?: string
  isRepeat?: boolean
  drawsMode?: string
  effort?: number | ''
  quality?: number | null
  difficultyFeel?: string
  styleFeel?: string
  proposedBase?: string
  proposedDec?: string
  wantRepeat?: boolean | null
  kneepad?: boolean
  notes?: string
  visibility?: 'public' | 'private'
}

export function useAscentFields(init: AscentFieldsInit = {}) {
  const [date, setDate] = useState(init.date ?? new Date().toISOString().slice(0, 10))
  const [selectedOption, setSelectedOption] = useState(init.selectedOption ?? 'onsight')
  const [isRepeat, setIsRepeat] = useState(init.isRepeat ?? false)
  const [drawsMode, setDrawsMode] = useState(init.drawsMode ?? 'unknown')
  const [effort, setEffort] = useState<number | ''>(init.effort ?? '')
  const [quality, setQuality] = useState<number | null>(init.quality ?? null)
  const [difficultyFeel, setDifficultyFeel] = useState(init.difficultyFeel ?? '')
  const [styleFeel, setStyleFeel] = useState(init.styleFeel ?? '')
  const [proposedBase, setProposedBase] = useState(init.proposedBase ?? '')
  const [proposedDec, setProposedDec] = useState(init.proposedDec ?? '')
  const [wantRepeat, setWantRepeat] = useState<boolean | null>(init.wantRepeat ?? null)
  const [kneepad, setKneepad] = useState(init.kneepad ?? false)
  const [notes, setNotes] = useState(init.notes ?? '')
  const [visibility, setVisibility] = useState<'public' | 'private'>(init.visibility ?? 'public')

  // Grado proposto = base + decimale (.1–.9), es. 6b + .8 → "6b.8"
  const proposedLabel = proposedBase
    ? (proposedDec && proposedDec !== '0' ? `${proposedBase}.${proposedDec}` : proposedBase)
    : ''
  const proposedNum = proposedBase
    ? (gradeToNum(proposedBase) ?? 0) + (proposedDec ? Number(proposedDec) : 0) / 10
    : null

  return {
    date, setDate,
    selectedOption, setSelectedOption,
    isRepeat, setIsRepeat,
    drawsMode, setDrawsMode,
    effort, setEffort,
    quality, setQuality,
    difficultyFeel, setDifficultyFeel,
    styleFeel, setStyleFeel,
    proposedBase, setProposedBase,
    proposedDec, setProposedDec,
    wantRepeat, setWantRepeat,
    kneepad, setKneepad,
    notes, setNotes,
    visibility, setVisibility,
    proposedLabel, proposedNum,
  }
}

export type AscentFieldsController = ReturnType<typeof useAscentFields>

// Route minimale che serve a costruire i valori (id + snapshot grado).
export interface AscentTargetRoute {
  id: string
  official_grade: string | null
  grade_numeric: number | null
}

// Costruisce l'AscentFormValues completo (INSERT). Fonte UNICA per tutti i form.
export function buildAscentValues(
  ctrl: AscentFieldsController,
  route: AscentTargetRoute,
  sessionId: string | null,
  opts?: { kneepadUsed?: boolean | null },
): AscentFormValues {
  const mapped = buildMapped(ctrl.selectedOption, ctrl.isRepeat)
  const kneepadUsed = opts && 'kneepadUsed' in opts
    ? (opts.kneepadUsed ?? null)
    : (ctrl.kneepad || null)
  return {
    route_id: route.id,
    session_id: sessionId,
    date: ctrl.date,
    attempt_type: null,
    ascent_style: mapped.ascent_style,
    attempt_count: mapped.attempt_count,
    attempt_bucket: mapped.attempt_bucket,
    is_repeat: ctrl.isRepeat,
    grade_at_ascent: route.official_grade,
    grade_numeric_at_ascent: route.grade_numeric,
    draws_mode: ctrl.isRepeat ? null : ctrl.drawsMode,
    personal_grade: null,
    quality: ctrl.quality,
    difficulty_feel: ctrl.difficultyFeel || null,
    style_feel: ctrl.styleFeel || null,
    proposed_grade: ctrl.proposedLabel || null,
    want_repeat: ctrl.wantRepeat,
    kneepad_used: kneepadUsed,
    effort: ctrl.effort !== '' ? Number(ctrl.effort) : null,
    notes: ctrl.notes || null,
    visibility: ctrl.visibility,
  }
}

// Deriva il payload UPDATE (sottoinsieme editabile) dai valori completi.
export function toUpdateValues(v: AscentFormValues): AscentUpdateValues {
  return {
    date: v.date,
    ascent_style: v.ascent_style,
    attempt_count: v.attempt_count,
    attempt_bucket: v.attempt_bucket,
    grade_at_ascent: v.grade_at_ascent,
    is_repeat: v.is_repeat,
    draws_mode: v.draws_mode,
    quality: v.quality,
    difficulty_feel: v.difficulty_feel,
    style_feel: v.style_feel,
    proposed_grade: v.proposed_grade,
    want_repeat: v.want_repeat,
    kneepad_used: v.kneepad_used,
    effort: v.effort,
    notes: v.notes,
    visibility: v.visibility,
  }
}

// ─── Ricerca via (create mode) ──────────────────────────────────────────────

interface RouteSelectProps {
  query: string
  onQueryChange: (q: string) => void
  onSelect: (r: RouteSearchResult) => void
  disabled?: boolean
}

export function RouteSelect({ query, onQueryChange, onSelect, disabled }: RouteSelectProps) {
  const [showDropdown, setShowDropdown] = useState(false)
  const { data: results, isFetching } = useRouteSearch(disabled ? '' : query)

  return (
    <div className="form-group" style={{ position: 'relative', marginBottom: 20 }}>
      <label>Via * <span style={{ fontWeight: 400, fontSize: 11, color: 'var(--text-muted)', textTransform: 'none' }}>(cerca per nome)</span></label>
      <input
        value={query}
        onChange={e => { onQueryChange(e.target.value); setShowDropdown(true) }}
        onFocus={() => query.length >= 2 && setShowDropdown(true)}
        placeholder="es. Spigolo giallo…"
        autoComplete="off"
      />
      {isFetching && <span style={{ fontSize: 11, color: 'var(--text-muted)', marginTop: 2 }}>Ricerca…</span>}
      {showDropdown && results && results.length > 0 && (
        <div style={{
          position: 'absolute', top: '100%', left: 0, right: 0, zIndex: 100,
          background: '#2A3240', border: '1px solid rgba(247,243,234,0.14)',
          borderRadius: 10, boxShadow: '0 8px 24px rgba(0,0,0,0.40)',
          maxHeight: 260, overflowY: 'auto',
        }}>
          {results.map(r => (
            <div key={r.id} onClick={() => { onSelect(r); setShowDropdown(false) }}
              style={{ padding: '10px 14px', cursor: 'pointer', borderBottom: '1px solid rgba(247,243,234,0.08)', fontSize: 13 }}
              onMouseEnter={e => (e.currentTarget.style.background = 'rgba(232,93,53,0.08)')}
              onMouseLeave={e => (e.currentTarget.style.background = '')}>
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
        <div style={{ marginTop: 4, fontSize: 12, color: 'var(--text-muted)' }}>Nessuna via trovata.</div>
      )}
    </div>
  )
}

// ─── Pannello info via (grado community + note pubbliche) ───────────────────

interface RouteInfoPanelProps {
  routeId: string
  name: string
  cragName?: string
  sectorName?: string
  officialGrade: string | null
  onChange?: () => void
}

export function RouteInfoPanel({ routeId, name, cragName, sectorName, officialGrade, onChange }: RouteInfoPanelProps) {
  const { data: routeInfo } = useRoute(routeId)
  return (
    <div className="log-route-preview">
      <div style={{ flex: 1 }}>
        <div className="log-route-preview-name">{name}</div>
        <div className="log-route-preview-sub">
          {[cragName, sectorName].filter(Boolean).join(' › ')}
          {officialGrade && (
            <span className="grade-badge" style={{ marginLeft: 8 }}>{officialGrade}</span>
          )}
          {routeInfo?.community_grade_raw &&
            routeInfo.community_grade_raw !== officialGrade && (
              <span style={{ marginLeft: 8, fontSize: 11, color: 'var(--text-muted)' }}>
                community: <strong>{routeInfo.community_grade_raw}</strong>
              </span>
            )}
        </div>
        {routeInfo?.notes_public && (
          <div style={{ marginTop: 6, fontSize: 12, color: 'var(--text-muted)', lineHeight: 1.4 }}>
            {routeInfo.notes_public}
          </div>
        )}
      </div>
      {onChange && (
        <button type="button" className="btn-secondary" style={{ fontSize: 11, padding: '4px 10px' }}
          onClick={onChange}>
          Cambia
        </button>
      )}
    </div>
  )
}

// ─── Campi ascensione (stile, montaggio, valutazione…) ──────────────────────

interface AscentFieldsProps {
  ctrl: AscentFieldsController
  showDate?: boolean
  showKneepad?: boolean
  showNotes?: boolean
  showVisibility?: boolean
}

export function AscentFields({
  ctrl, showDate, showKneepad, showNotes, showVisibility,
}: AscentFieldsProps) {
  const [hoverStar, setHoverStar] = useState<number | null>(null)

  return (
    <>
      {showDate && (
        <>
          <div className="log-q">Quando hai salito?</div>
          <input type="date" value={ctrl.date} onChange={e => ctrl.setDate(e.target.value)}
            style={{ width: '100%', marginBottom: 14 }} />
        </>
      )}

      {/* Ascent style — On-sight / Flash / Redpoint (radio esclusivo) */}
      <div className="log-q">Come hai salito?</div>
      <div className="log-style-circles" style={{ justifyContent: 'center', gap: 32, marginBottom: 16 }}>
        {QUICK_MODES.map(m => {
          const active = !ctrl.isRepeat && (
            m.value === 'redpoint' ? isRedpointOption(ctrl.selectedOption) : ctrl.selectedOption === m.value
          )
          return (
            <button key={m.value} type="button"
              className={`log-style-circle${active ? ' active' : ''}`}
              data-mode={m.value}
              style={ctrl.isRepeat ? { opacity: 0.35, cursor: 'not-allowed' } : {}}
              onClick={() => {
                if (ctrl.isRepeat) return
                if (m.value === 'redpoint') {
                  if (!isRedpointOption(ctrl.selectedOption)) ctrl.setSelectedOption('2')
                } else {
                  ctrl.setSelectedOption(m.value)
                }
              }}>
              <div className="log-style-circle-ring">
                <span className="log-style-circle-icon">{m.icon}</span>
              </div>
              <span className="log-style-circle-label">{m.label}</span>
            </button>
          )
        })}
      </div>

      {/* Redpoint — tendina numero giri */}
      {!ctrl.isRepeat && isRedpointOption(ctrl.selectedOption) && (
        <div className="log-redpoint-section">
          <div className="log-redpoint-label">Numero di giri</div>
          <div style={{ display: 'flex', justifyContent: 'center' }}>
            <select className="logbook-select" style={{ minWidth: 180 }}
              value={ctrl.selectedOption}
              onChange={e => ctrl.setSelectedOption(e.target.value)}>
              {REDPOINT_OPTIONS.map(o => (
                <option key={o.value} value={o.value}>{o.label}</option>
              ))}
            </select>
          </div>
        </div>
      )}

      <div className="log-repeat-row" style={{ marginTop: 16 }}>
        <input type="checkbox" id="af-repeat-chk" checked={ctrl.isRepeat}
          onChange={e => ctrl.setIsRepeat(e.target.checked)} />
        <label htmlFor="af-repeat-chk">È una ripetizione</label>
      </div>

      {/* Montaggio via */}
      {!ctrl.isRepeat && (
        <>
          <div className="log-q">Montaggio via <span style={{ fontWeight: 400, fontSize: 11, color: 'var(--text-muted)', textTransform: 'none', letterSpacing: 0 }}>(hai messo tu i rinvii?)</span></div>
          <div className="log-pill-group" style={{ justifyContent: 'center' }}>
            {DRAWS_OPTIONS.map(m => (
              <button key={m.value} type="button"
                className={`log-pill${ctrl.drawsMode === m.value ? ' active' : ''}`}
                onClick={() => ctrl.setDrawsMode(m.value)}>
                {m.label}
              </button>
            ))}
          </div>
        </>
      )}

      {/* Sforzo */}
      <div className="log-q">Sforzo percepito <span style={{ fontWeight: 400, fontSize: 11, color: 'var(--text-muted)', textTransform: 'none', letterSpacing: 0 }}>(opzionale)</span></div>
      <div className="log-pill-group" style={{ justifyContent: 'center' }}>
        {[1,2,3,4,5,6,7,8,9,10].map(n => (
          <button key={n} type="button"
            className={`log-pill${ctrl.effort === n ? ' active' : ''}`}
            style={{ padding: '6px 11px', minWidth: 36, textAlign: 'center' }}
            onClick={() => ctrl.setEffort(ctrl.effort === n ? '' : n)}>
            {n}
          </button>
        ))}
      </div>

      {/* Valutazione */}
      <div className="log-q">Valutazione</div>

      <div className="log-eval-row">
        <span className="log-eval-label">Bellezza</span>
        <div style={{ display: 'flex', gap: 2, alignItems: 'center' }}>
          {[1,2,3,4,5].map(n => (
            <button key={n} type="button"
              onClick={() => ctrl.setQuality(ctrl.quality === n ? null : n)}
              onMouseEnter={() => setHoverStar(n)}
              onMouseLeave={() => setHoverStar(null)}
              style={{
                background: 'none', border: 'none', cursor: 'pointer', padding: 0,
                fontSize: 26, lineHeight: 1,
                color: n <= (hoverStar ?? ctrl.quality ?? 0) ? '#f5a623' : 'rgba(247,243,234,0.18)',
                transition: 'color 0.1s',
              }}>★</button>
          ))}
          {ctrl.quality && <span style={{ fontSize: 11, color: 'var(--text-muted)', marginLeft: 4 }}>{ctrl.quality}/5</span>}
        </div>
      </div>

      <div className="log-eval-row">
        <span className="log-eval-label">Difficoltà</span>
        <div className="log-pill-group" style={{ margin: 0 }}>
          {DIFFICULTY_FEEL_OPTIONS.map(o => (
            <button key={o.value} type="button"
              className={`log-pill${ctrl.difficultyFeel === o.value ? ' active' : ''}`}
              onClick={() => ctrl.setDifficultyFeel(ctrl.difficultyFeel === o.value ? '' : o.value)}>
              {o.label}
            </button>
          ))}
        </div>
      </div>

      <div className="log-eval-row">
        <span className="log-eval-label">Stile</span>
        <div className="log-pill-group" style={{ margin: 0 }}>
          {STYLE_FEEL_OPTIONS.map(o => (
            <button key={o.value} type="button"
              className={`log-pill${ctrl.styleFeel === o.value ? ' active' : ''}`}
              onClick={() => ctrl.setStyleFeel(ctrl.styleFeel === o.value ? '' : o.value)}>
              {o.label}
            </button>
          ))}
        </div>
      </div>

      <div className="form-group form-full" style={{ marginTop: 14, marginBottom: 14 }}>
        <label>
          Grado proposto{' '}
          <span style={{ fontWeight: 400, fontSize: 11, color: 'var(--text-muted)', textTransform: 'none', letterSpacing: 0 }}>
            (grado + decimale: affina il grado community)
          </span>
        </label>
        <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
          <select className="logbook-select" style={{ flex: '0 0 110px' }}
            value={ctrl.proposedBase} onChange={e => ctrl.setProposedBase(e.target.value)}>
            <option value="">— Grado —</option>
            {GRADE_ORDER.map(g => <option key={g} value={g}>{g}</option>)}
          </select>
          <select className="logbook-select" style={{ flex: '0 0 90px' }}
            value={ctrl.proposedDec}
            onChange={e => ctrl.setProposedDec(e.target.value)}
            disabled={!ctrl.proposedBase}>
            <option value="">.0</option>
            {GRADE_DECIMALS.map(d => <option key={d} value={d}>.{d}</option>)}
          </select>
          {ctrl.proposedLabel && (
            <span className="grade-badge grade-badge--lg" style={{ marginLeft: 4 }}>{ctrl.proposedLabel}</span>
          )}
        </div>
      </div>

      <div className="log-repeat-row" style={{ justifyContent: 'flex-start', marginBottom: showKneepad || showNotes || showVisibility ? 14 : 4 }}>
        <input type="checkbox" id="af-want-repeat" checked={ctrl.wantRepeat === true}
          onChange={e => ctrl.setWantRepeat(e.target.checked ? true : null)} />
        <label htmlFor="af-want-repeat">Voglio ripeterla</label>
      </div>

      {showKneepad && (
        <div className="log-repeat-row" style={{ justifyContent: 'flex-start', marginBottom: 14 }}>
          <input type="checkbox" id="af-kneepad" checked={ctrl.kneepad}
            onChange={e => ctrl.setKneepad(e.target.checked)} />
          <label htmlFor="af-kneepad">Ginocchiera</label>
        </div>
      )}

      {showVisibility && (
        <div className="form-group form-full" style={{ marginBottom: 14 }}>
          <label>Visibilità</label>
          <select className="logbook-select" value={ctrl.visibility}
            onChange={e => ctrl.setVisibility(e.target.value as 'public' | 'private')}>
            <option value="public">Pubblica</option>
            <option value="private">Privata</option>
          </select>
        </div>
      )}

      {showNotes && (
        <div className="form-group form-full" style={{ marginBottom: 4 }}>
          <label>Note</label>
          <textarea value={ctrl.notes} onChange={e => ctrl.setNotes(e.target.value)}
            placeholder="Note sulla salita, condizioni, sensazioni…" rows={3} />
        </div>
      )}
    </>
  )
}
