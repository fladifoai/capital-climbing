import { useState, useEffect } from 'react'
import { useSearchParams, Link } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'
import { useRoute } from '../features/catalog/hooks'
import {
  useCreateAscent,
  useUpsertRouteNotes,
  useRouteSearch,
  type AscentFormValues,
  type RouteSearchResult,
} from '../features/logbook/hooks'
import { useCreateSession, useSessionForDateCrag } from '../features/sessions/hooks'
import RouteNotesForm, {
  hasAnyData,
  toPayload,
  type RouteNotesValues,
} from '../features/logbook/RouteNotesForm'
import { GRADE_ORDER, gradeToNum } from '../analytics/normalizers/grades'
import { useVoteRoute } from '../features/routes/hooks'
import type { AttemptBucket } from '../analytics/calculations/attempt-buckets'
import '../styles/log-new.css'
import '../styles/admin.css'
import '../styles/logbook.css'

// ─── Constants ────────────────────────────────────────────────────────────────

const QUICK_MODES = [
  { value: 'onsight', label: 'On-sight', icon: '👁️' },
  { value: 'flash',   label: 'Flash',    icon: '⚡' },
]

const EXACT_TRIES = ['2','3','4','5','6','7','8','9','10']

// Decimale del grado proposto: .1–.9 (raffina il grado community)
const GRADE_DECIMALS = ['1','2','3','4','5','6','7','8','9']

const BUCKET_OPTIONS = [
  { value: '11_20',   label: '11-20' },
  { value: '21_30',   label: '21-30' },
  { value: '31_40',   label: '31-40' },
  { value: '41_50',   label: '41-50' },
  { value: '50_plus', label: '50+' },
]

const DIFFICULTY_FEEL_OPTIONS = [
  { value: 'soft',      label: 'Soft' },
  { value: 'fair',      label: 'Giusta' },
  { value: 'hard',      label: 'Hard' },
  { value: 'very_hard', label: 'Molto hard' },
]

const STYLE_FEEL_OPTIONS = [
  { value: 'my_style',   label: 'Mio stile' },
  { value: 'neutral',    label: 'Neutro' },
  { value: 'anti_style', label: 'Anti-stile' },
]

const STEPS = [
  { id: 1, label: 'Via & Salita' },
  { id: 2, label: 'Tecnica' },
  { id: 3, label: 'Beta' },
  { id: 4, label: 'Attrezzatura' },
]

function formatMode(opt: string, repeat: boolean): string {
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

const EMPTY_NOTES: RouteNotesValues = {
  hold_profile: {}, movement_profile: {}, style_profile: {},
  crux: '', rests: '', main_beta: '', alternative_beta: '',
  kneepad_used: false, kneepad_data: {}, equipment_data: {}, safety_notes: '',
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

function buildMapped(option: string, isRepeat: boolean): {
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

function getDateShortcuts(): { label: string; value: string }[] {
  const fmt = (d: Date) => d.toISOString().slice(0, 10)
  const today = new Date()
  const yesterday = new Date(today); yesterday.setDate(today.getDate() - 1)
  const daysSinceSat = (today.getDay() - 6 + 7) % 7 || 7
  const lastSat = new Date(today); lastSat.setDate(today.getDate() - daysSinceSat)
  const daysSinceSun = today.getDay() === 0 ? 7 : today.getDay()
  const lastSun = new Date(today); lastSun.setDate(today.getDate() - daysSinceSun)
  return [
    { label: 'Oggi', value: fmt(today) },
    { label: 'Ieri', value: fmt(yesterday) },
    { label: 'Sabato', value: fmt(lastSat) },
    { label: 'Domenica', value: fmt(lastSun) },
  ]
}

// ─── Main page ────────────────────────────────────────────────────────────────

export default function LogNewPage() {
  const { user } = useAuth()
  const [searchParams] = useSearchParams()
  const preRouteId = searchParams.get('routeId')

  const createAscent = useCreateAscent()
  const upsertNotes = useUpsertRouteNotes()
  const voteRoute = useVoteRoute()
  const createSession = useCreateSession()

  const { data: preRoute, isLoading: preRouteLoading } = useRoute(preRouteId ?? '')

  // ── Route search ──
  const [routeQuery, setRouteQuery] = useState('')
  const [selectedRoute, setSelectedRoute] = useState<RouteSearchResult | null>(null)
  const [showDropdown, setShowDropdown] = useState(false)
  const { data: searchResults, isFetching: searchFetching } = useRouteSearch(
    selectedRoute ? '' : routeQuery
  )

  // ── Ascent fields ──
  const [date, setDate] = useState(new Date().toISOString().slice(0, 10))
  const [selectedOption, setSelectedOption] = useState('onsight')
  const [drawsMode, setDrawsMode] = useState('unknown')
  const [isRepeat, setIsRepeat] = useState(false)
  const [effort, setEffort] = useState<number | ''>('')
  const dateShortcuts = getDateShortcuts()

  // ── Sessione automatica (utente, data, falesia) ──
  // Se forceNewSession è true la salita crea una sessione separata anche se
  // ne esiste già una per quella data+falesia (caso raro: due visite alla
  // stessa falesia nello stesso giorno).
  const [forceNewSession, setForceNewSession] = useState(false)
  const cragId = selectedRoute?.crag_id ?? ''
  const { data: existingSession } = useSessionForDateCrag(user?.id ?? '', date, cragId)

  // Info complete della via selezionata (grado community, note) per il pannello.
  const { data: routeInfo } = useRoute(selectedRoute?.id ?? '')

  // ── Evaluation ──
  const [quality, setQuality] = useState<number | null>(null)
  const [hoverStar, setHoverStar] = useState<number | null>(null)
  const [proposedBase, setProposedBase] = useState('')
  const [proposedDec, setProposedDec] = useState('')

  // Grado proposto = base + decimale (.1–.9), es. 6b + .8 → "6b.8"
  const proposedLabel = proposedBase
    ? (proposedDec && proposedDec !== '0' ? `${proposedBase}.${proposedDec}` : proposedBase)
    : ''
  const proposedNum = proposedBase
    ? (gradeToNum(proposedBase) ?? 0) + (proposedDec ? Number(proposedDec) : 0) / 10
    : null
  const [difficultyFeel, setDifficultyFeel] = useState('')
  const [styleFeel, setStyleFeel] = useState('')
  const [wantRepeat, setWantRepeat] = useState<boolean | null>(null)

  // ── Technical notes ──
  const [notesValues, setNotesValues] = useState<RouteNotesValues>(EMPTY_NOTES)

  // ── Meta ──
  const [visibility, setVisibility] = useState<'public' | 'private'>('public')
  const [notes, setNotes] = useState('')
  const [step, setStep] = useState(1)
  const [saved, setSaved] = useState(false)
  const [error, setError] = useState('')

  useEffect(() => {
    if (preRoute && !selectedRoute) {
      setSelectedRoute({
        id: preRoute.id,
        name: preRoute.name,
        official_grade: preRoute.official_grade,
        grade_numeric: preRoute.grade_numeric,
        route_type: preRoute.route_type,
        crag_id: preRoute.crag_id ?? preRoute.sector?.crag?.id ?? null,
        crag_name: preRoute.sector?.crag?.name ?? '',
        sector_name: preRoute.sector?.name ?? '',
      })
      setRouteQuery(preRoute.name)
      if (!proposedBase && preRoute.official_grade) setProposedBase(preRoute.official_grade)
    }
  }, [preRoute])

  function selectRoute(r: RouteSearchResult) {
    setSelectedRoute(r)
    setRouteQuery(r.name)
    setShowDropdown(false)
    setForceNewSession(false)
    if (r.official_grade) setProposedBase(r.official_grade)
  }

  function changeDate(v: string) {
    setDate(v)
    setForceNewSession(false)
  }

  // Risolve il session_id da passare all'ascensione:
  // - forceNewSession → crea una sessione separata e ne usa l'id;
  // - altrimenti null → il trigger DB trova/crea la sessione per
  //   (utente, data, falesia).
  async function resolveSessionId(): Promise<string | null> {
    if (!forceNewSession || !user) return null
    const s = await createSession.mutateAsync({
      userId: user.id,
      values: {
        date,
        crag_id: cragId || null,
        partner: null, conditions: null, rock_condition: null,
        temperature: null, session_rpe: null, rest_days: null,
        notes: null, visibility: 'private',
      },
    })
    return s.id
  }

  function buildValues(sessionId: string | null): AscentFormValues {
    const mapped = buildMapped(selectedOption, isRepeat)
    return {
      route_id: selectedRoute!.id,
      session_id: sessionId,
      date,
      attempt_type: null,
      ascent_style: mapped.ascent_style,
      attempt_count: mapped.attempt_count,
      attempt_bucket: mapped.attempt_bucket,
      is_repeat: isRepeat,
      grade_at_ascent: selectedRoute!.official_grade,
      grade_numeric_at_ascent: selectedRoute!.grade_numeric,
      draws_mode: isRepeat ? null : drawsMode,
      personal_grade: null,
      quality,
      difficulty_feel: difficultyFeel || null,
      style_feel: styleFeel || null,
      proposed_grade: proposedLabel || null,
      want_repeat: wantRepeat,
      kneepad_used: notesValues.kneepad_used || null,
      effort: effort !== '' ? Number(effort) : null,
      notes: notes || null,
      visibility,
    }
  }

  // Il grado proposto alimenta il voto community dell'utente (1 per utente,
  // upsert): più persone salgono la via, più la media community si affina.
  async function castGradeVote() {
    if (!user || !selectedRoute || !proposedBase || proposedNum == null) return
    await voteRoute.mutateAsync({
      routeId: selectedRoute.id,
      userId: user.id,
      perceived_grade: proposedLabel,
      grade_numeric: proposedNum,
      beauty: quality,
    })
  }

  async function saveBase() {
    if (!user || !selectedRoute) return
    setError('')
    try {
      const sessionId = await resolveSessionId()
      await createAscent.mutateAsync({ userId: user.id, values: buildValues(sessionId), routeId: selectedRoute.id })
      await castGradeVote()
      setSaved(true)
    } catch (e) {
      setError((e as Error).message)
    }
  }

  async function saveAll() {
    if (!user || !selectedRoute) return
    setError('')
    try {
      const sessionId = await resolveSessionId()
      await createAscent.mutateAsync({ userId: user.id, values: buildValues(sessionId), routeId: selectedRoute.id })
      await castGradeVote()
      if (hasAnyData(notesValues)) {
        await upsertNotes.mutateAsync(toPayload(notesValues, user.id, selectedRoute.id, visibility))
      }
      setSaved(true)
    } catch (e) {
      setError((e as Error).message)
    }
  }

  const isPending = createAscent.isPending || upsertNotes.isPending || voteRoute.isPending || createSession.isPending

  // ── Success screen ─────────────────────────────────────────────────────────
  if (saved) {
    return (
      <div className="log-new-page">
        <div className="log-step-card">
          <div className="log-success">
            <div className="log-success-icon">✓</div>
            <h2>Ascensione registrata!</h2>
            {hasAnyData(notesValues) && (
              <p>Anche i dati tecnici della via sono stati salvati nel tuo profilo.</p>
            )}
            <div className="log-success-btns">
              {selectedRoute && (
                <Link to={`/routes/${selectedRoute.id}`} className="btn-primary" style={{ textDecoration: 'none' }}>
                  Vai alla via
                </Link>
              )}
              <Link to="/profile" className="btn-secondary" style={{ textDecoration: 'none' }}>
                Il mio profilo
              </Link>
              <button className="btn-secondary" onClick={() => {
                setSaved(false); setSelectedRoute(null); setRouteQuery(''); setStep(1)
                setNotes(''); setQuality(null); setProposedBase(''); setProposedDec('')
                setDifficultyFeel(''); setStyleFeel(''); setWantRepeat(null); setEffort('')
                setIsRepeat(false); setSelectedOption('onsight')
                setForceNewSession(false)
                setNotesValues(EMPTY_NOTES)
              }}>
                Aggiungi un'altra
              </button>
            </div>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="log-new-page">
      <div className="log-new-header">
        <h1>Nuova salita</h1>
      </div>

      {/* ── Step tabs ── */}
      <div className="log-step-tabs">
        {STEPS.map(s => (
          <button
            key={s.id}
            className={`log-step-tab${step === s.id ? ' active' : ''}${step > s.id ? ' done' : ''}`}
            onClick={() => { if (s.id < step || selectedRoute) setStep(s.id) }}
          >
            {step > s.id ? '✓ ' : ''}{s.label}
          </button>
        ))}
      </div>

      <div className="log-step-card">

        {/* ═══════════ STEP 1 — Via & Salita + Valutazione ═══════════ */}
        {step === 1 && (
          <>
            {/* Route search */}
            {selectedRoute ? (
              <div className="log-route-preview">
                <div style={{ flex: 1 }}>
                  <div className="log-route-preview-name">{selectedRoute.name}</div>
                  <div className="log-route-preview-sub">
                    {selectedRoute.crag_name} › {selectedRoute.sector_name}
                    {selectedRoute.official_grade && (
                      <span className="grade-badge" style={{ marginLeft: 8 }}>
                        {selectedRoute.official_grade}
                      </span>
                    )}
                    {routeInfo?.community_grade_raw &&
                      routeInfo.community_grade_raw !== selectedRoute.official_grade && (
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
                <button type="button" className="btn-secondary" style={{ fontSize: 11, padding: '4px 10px' }}
                  onClick={() => { setSelectedRoute(null); setRouteQuery(''); setForceNewSession(false) }}>
                  Cambia
                </button>
              </div>
            ) : (
              <div className="form-group" style={{ position: 'relative', marginBottom: 20 }}>
                <label>Via * <span style={{ fontWeight: 400, fontSize: 11, color: 'var(--text-muted)', textTransform: 'none' }}>(cerca per nome)</span></label>
                <input
                  value={routeQuery}
                  onChange={e => { setRouteQuery(e.target.value); setShowDropdown(true) }}
                  onFocus={() => routeQuery.length >= 2 && setShowDropdown(true)}
                  placeholder="es. Spigolo giallo…"
                  autoComplete="off"
                />
                {searchFetching && <span style={{ fontSize: 11, color: 'var(--text-muted)', marginTop: 2 }}>Ricerca…</span>}
                {showDropdown && searchResults && searchResults.length > 0 && (
                  <div style={{
                    position: 'absolute', top: '100%', left: 0, right: 0, zIndex: 100,
                    background: '#2A3240', border: '1px solid rgba(247,243,234,0.14)',
                    borderRadius: 10, boxShadow: '0 8px 24px rgba(0,0,0,0.40)',
                    maxHeight: 260, overflowY: 'auto',
                  }}>
                    {searchResults.map(r => (
                      <div key={r.id} onClick={() => selectRoute(r)}
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
                {showDropdown && routeQuery.length >= 2 && searchResults?.length === 0 && !searchFetching && (
                  <div style={{ marginTop: 4, fontSize: 12, color: 'var(--text-muted)' }}>Nessuna via trovata.</div>
                )}
              </div>
            )}

            {/* Date */}
            <div className="log-q">Quando hai salito?</div>
            <input type="date" value={date} onChange={e => changeDate(e.target.value)}
              style={{ width: '100%', marginBottom: 4 }} />
            <div className="log-date-shortcuts">
              {dateShortcuts.map(s => (
                <button key={s.label} type="button"
                  className={`log-date-shortcut${date === s.value ? ' active' : ''}`}
                  onClick={() => changeDate(s.value)}>
                  {s.label}
                </button>
              ))}
            </div>

            {/* Avviso sessione automatica (utente, data, falesia) */}
            {selectedRoute && existingSession && !forceNewSession && (
              <div style={{
                marginTop: 12, marginBottom: 4, padding: '10px 12px', borderRadius: 8,
                background: 'rgba(232,93,53,0.10)', border: '1px solid rgba(232,93,53,0.30)',
                fontSize: 12.5, color: 'var(--text)', lineHeight: 1.5,
              }}>
                Verrà aggiunta alla sessione del <strong>{existingSession.date}</strong>
                {existingSession.crag?.name ? <> a <strong>{existingSession.crag.name}</strong></> : null}.
                {' '}Non è quella giusta?{' '}
                <button type="button"
                  onClick={() => setForceNewSession(true)}
                  style={{
                    background: 'none', border: 'none', padding: 0, cursor: 'pointer',
                    color: 'var(--accent, #E85D35)', fontWeight: 600, textDecoration: 'underline',
                    fontSize: 12.5,
                  }}>
                  Crea nuova sessione
                </button>
              </div>
            )}
            {selectedRoute && forceNewSession && (
              <div style={{
                marginTop: 12, marginBottom: 4, padding: '10px 12px', borderRadius: 8,
                background: 'rgba(76,175,80,0.10)', border: '1px solid rgba(76,175,80,0.30)',
                fontSize: 12.5, color: 'var(--text)', lineHeight: 1.5,
              }}>
                Verrà creata una <strong>nuova sessione</strong> separata.
                {' '}
                <button type="button"
                  onClick={() => setForceNewSession(false)}
                  style={{
                    background: 'none', border: 'none', padding: 0, cursor: 'pointer',
                    color: 'var(--accent, #E85D35)', fontWeight: 600, textDecoration: 'underline',
                    fontSize: 12.5,
                  }}>
                  Annulla
                </button>
              </div>
            )}

            {/* Ascent style */}
            <div className="log-q">Come hai salito?</div>

            {/* On-sight / Flash — grandi cerchi */}
            <div className="log-style-circles" style={{ justifyContent: 'center', gap: 32, marginBottom: 16 }}>
              {QUICK_MODES.map(m => (
                <button key={m.value} type="button"
                  className={`log-style-circle${selectedOption === m.value && !isRepeat ? ' active' : ''}`}
                  data-mode={m.value}
                  style={isRepeat ? { opacity: 0.35, cursor: 'not-allowed' } : {}}
                  onClick={() => { if (!isRepeat) setSelectedOption(m.value) }}>
                  <div className="log-style-circle-ring">
                    <span className="log-style-circle-icon">{m.icon}</span>
                  </div>
                  <span className="log-style-circle-label">{m.label}</span>
                </button>
              ))}
            </div>

            {/* Redpoint — numero giri */}
            <div className="log-redpoint-section" style={{ opacity: isRepeat ? 0.35 : 1, pointerEvents: isRepeat ? 'none' : undefined }}>
              <div className="log-redpoint-label">Redpoint — numero di giri</div>
              <div className="log-pill-group" style={{ justifyContent: 'center', marginBottom: 8 }}>
                {EXACT_TRIES.map(n => (
                  <button key={n} type="button"
                    className={`log-pill${selectedOption === n && !isRepeat ? ' active' : ''}`}
                    style={{ minWidth: 38, textAlign: 'center' }}
                    onClick={() => setSelectedOption(n)}>
                    {n}°
                  </button>
                ))}
              </div>
              <div className="log-pill-group" style={{ justifyContent: 'center' }}>
                {BUCKET_OPTIONS.map(b => (
                  <button key={b.value} type="button"
                    className={`log-pill${selectedOption === b.value && !isRepeat ? ' active' : ''}`}
                    onClick={() => setSelectedOption(b.value)}>
                    {b.label}
                  </button>
                ))}
              </div>
            </div>

            <div className="log-repeat-row" style={{ marginTop: 16 }}>
              <input type="checkbox" id="repeat-chk" checked={isRepeat}
                onChange={e => setIsRepeat(e.target.checked)} />
              <label htmlFor="repeat-chk">È una ripetizione</label>
            </div>

            {/* Montaggio via — incide sul bonus solo per l'on-sight */}
            {!isRepeat && (
              <>
                <div className="log-q">Montaggio via <span style={{ fontWeight: 400, fontSize: 11, color: 'var(--text-muted)', textTransform: 'none', letterSpacing: 0 }}>(hai messo tu i rinvii?)</span></div>
                <div className="log-pill-group" style={{ justifyContent: 'center' }}>
                  {[
                    { value: 'unknown', label: 'Non ricordo' },
                    { value: 'preplaced', label: 'Rinvii già presenti' },
                    { value: 'placed_by_user', label: 'Ho montato la via' },
                  ].map(m => (
                    <button key={m.value} type="button"
                      className={`log-pill${drawsMode === m.value ? ' active' : ''}`}
                      onClick={() => setDrawsMode(m.value)}>
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
                  className={`log-pill${effort === n ? ' active' : ''}`}
                  style={{ padding: '6px 11px', minWidth: 36, textAlign: 'center' }}
                  onClick={() => setEffort(effort === n ? '' : n)}>
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
                    onClick={() => setQuality(quality === n ? null : n)}
                    onMouseEnter={() => setHoverStar(n)}
                    onMouseLeave={() => setHoverStar(null)}
                    style={{
                      background: 'none', border: 'none', cursor: 'pointer', padding: 0,
                      fontSize: 26, lineHeight: 1,
                      color: n <= (hoverStar ?? quality ?? 0) ? '#f5a623' : 'rgba(247,243,234,0.18)',
                      transition: 'color 0.1s',
                    }}>★</button>
                ))}
                {quality && <span style={{ fontSize: 11, color: 'var(--text-muted)', marginLeft: 4 }}>{quality}/5</span>}
              </div>
            </div>

            <div className="log-eval-row">
              <span className="log-eval-label">Difficoltà</span>
              <div className="log-pill-group" style={{ margin: 0 }}>
                {DIFFICULTY_FEEL_OPTIONS.map(o => (
                  <button key={o.value} type="button"
                    className={`log-pill${difficultyFeel === o.value ? ' active' : ''}`}
                    onClick={() => setDifficultyFeel(difficultyFeel === o.value ? '' : o.value)}>
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
                    className={`log-pill${styleFeel === o.value ? ' active' : ''}`}
                    onClick={() => setStyleFeel(styleFeel === o.value ? '' : o.value)}>
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
                  value={proposedBase} onChange={e => setProposedBase(e.target.value)}>
                  <option value="">— Grado —</option>
                  {GRADE_ORDER.map(g => <option key={g} value={g}>{g}</option>)}
                </select>
                <select className="logbook-select" style={{ flex: '0 0 90px' }}
                  value={proposedDec}
                  onChange={e => setProposedDec(e.target.value)}
                  disabled={!proposedBase}>
                  <option value="">.0</option>
                  {GRADE_DECIMALS.map(d => <option key={d} value={d}>.{d}</option>)}
                </select>
                {proposedLabel && (
                  <span className="grade-badge grade-badge--lg" style={{ marginLeft: 4 }}>{proposedLabel}</span>
                )}
              </div>
            </div>

            <div className="log-repeat-row" style={{ justifyContent: 'flex-start', marginBottom: 20 }}>
              <input type="checkbox" id="want-repeat" checked={wantRepeat === true}
                onChange={e => setWantRepeat(e.target.checked ? true : null)} />
              <label htmlFor="want-repeat">Voglio ripeterla</label>
            </div>

            {preRouteId && preRouteLoading && !selectedRoute && (
              <div style={{ fontSize: 12, color: 'var(--text-muted)', textAlign: 'center', marginBottom: 8 }}>
                Caricamento via…
              </div>
            )}
            {!selectedRoute && !preRouteLoading && (
              <div style={{ fontSize: 12, color: 'var(--text-muted)', textAlign: 'center', marginBottom: 8 }}>
                Cerca e seleziona una via per continuare
              </div>
            )}
            {error && <div className="admin-error" style={{ marginBottom: 12 }}>{error}</div>}
            <div className="log-nav-btns">
              <button type="button" className="btn-secondary"
                disabled={isPending || !selectedRoute || !date}
                onClick={saveBase}
                title="Salva solo i dati base senza informazioni tecniche">
                {isPending ? 'Salvataggio…' : 'Salva base'}
              </button>
              <div className="log-nav-btns-right">
                <button type="button" className="btn-primary"
                  disabled={!selectedRoute || (!!preRouteId && preRouteLoading)}
                  onClick={() => setStep(2)}>
                  {preRouteId && preRouteLoading && !selectedRoute ? 'Caricamento…' : 'Avanti →'}
                </button>
              </div>
            </div>
          </>
        )}

        {/* ═══════════ STEP 2 — Tecnica (icon cards) ═══════════ */}
        {step === 2 && (
          <>
            <RouteNotesForm
              sections={['stile', 'prese', 'movimenti']}
              iconMode
              initialValues={notesValues}
              onChange={setNotesValues}
            />
            <div className="log-nav-btns">
              <button type="button" className="btn-secondary" onClick={() => setStep(1)}>← Indietro</button>
              <button type="button" className="btn-primary" onClick={() => setStep(3)}>Avanti →</button>
            </div>
          </>
        )}

        {/* ═══════════ STEP 3 — Beta & Sicurezza ═══════════ */}
        {step === 3 && (
          <>
            <RouteNotesForm
              sections={['beta', 'kneepad', 'safety']}
              initialValues={notesValues}
              onChange={setNotesValues}
            />
            <div className="log-nav-btns">
              <button type="button" className="btn-secondary" onClick={() => setStep(2)}>← Indietro</button>
              <button type="button" className="btn-primary" onClick={() => setStep(4)}>Avanti →</button>
            </div>
          </>
        )}

        {/* ═══════════ STEP 4 — Attrezzatura & Salva ═══════════ */}
        {step === 4 && (
          <>
            <RouteNotesForm
              sections={['equipment']}
              initialValues={notesValues}
              onChange={setNotesValues}
            />

            <div className="log-section-title" style={{ marginTop: 20 }}>Visibilità & Note</div>
            <div className="form-grid">
              <div className="form-group">
                <label>Visibilità</label>
                <select className="logbook-select" value={visibility}
                  onChange={e => setVisibility(e.target.value as 'public' | 'private')}>
                  <option value="public">Pubblica</option>
                  <option value="private">Privata</option>
                </select>
              </div>
              <div className="form-group form-full">
                <label>Note</label>
                <textarea value={notes} onChange={e => setNotes(e.target.value)}
                  placeholder="Note sulla salita, condizioni, sensazioni…" rows={3} />
              </div>
            </div>

            {selectedRoute && (
              <div className="log-route-preview" style={{ marginBottom: 16 }}>
                <div>
                  <div className="log-route-preview-name">{selectedRoute.name}</div>
                  <div className="log-route-preview-sub">
                    {selectedRoute.crag_name} · {date} · {formatMode(selectedOption, isRepeat)}
                    {hasAnyData(notesValues) && ' · Con dati tecnici'}
                  </div>
                </div>
                {selectedRoute.official_grade && (
                  <span className="grade-badge">{selectedRoute.official_grade}</span>
                )}
              </div>
            )}

            {error && <div className="admin-error" style={{ marginBottom: 16 }}>{error}</div>}

            <div className="log-nav-btns">
              <button type="button" className="btn-secondary" onClick={() => setStep(3)}>← Indietro</button>
              <div className="log-nav-btns-right">
                <button type="button" className="btn-primary"
                  disabled={isPending || !selectedRoute || !date}
                  onClick={saveAll}>
                  {isPending ? 'Salvataggio…' : '✓ Salva salita'}
                </button>
              </div>
            </div>
          </>
        )}
      </div>
    </div>
  )
}
