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
import RouteNotesForm, {
  hasAnyData,
  toPayload,
  type RouteNotesValues,
} from '../features/logbook/RouteNotesForm'
import { GRADE_ORDER } from '../analytics/normalizers/grades'
import type { AttemptBucket } from '../analytics/calculations/attempt-buckets'
import '../styles/log-new.css'
import '../styles/admin.css'
import '../styles/logbook.css'

// ─── Constants ────────────────────────────────────────────────────────────────

const ASCENT_MODES = [
  { value: 'onsight', label: 'On-sight' },
  { value: 'flash',   label: 'Flash' },
  { value: 'redpoint', label: 'Redpoint' },
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
  { id: 1, label: '1 Via & Salita' },
  { id: 2, label: '2 Stile & Prese' },
  { id: 3, label: '3 Movimenti & Beta' },
  { id: 4, label: '4 Kneepad & Equip.' },
  { id: 5, label: '5 Sicurezza & Val.' },
  { id: 6, label: '6 Visibilità' },
]

function triesBucket(n: number): AttemptBucket | null {
  if (n <= 10) return String(n) as AttemptBucket
  if (n <= 15) return '11_15'
  if (n <= 20) return '16_20'
  if (n <= 30) return '21_30'
  if (n <= 40) return '31_40'
  if (n <= 50) return '41_50'
  return '50_plus'
}

function buildMapped(mode: string, tries: number, isRepeat: boolean): {
  ascent_style: string; attempt_count: number | null; attempt_bucket: AttemptBucket | null
} {
  if (isRepeat) return { ascent_style: 'repeat', attempt_count: null, attempt_bucket: null }
  if (mode === 'onsight') return { ascent_style: 'onsight', attempt_count: 1, attempt_bucket: '1' }
  if (mode === 'flash')   return { ascent_style: 'flash',   attempt_count: 1, attempt_bucket: '1' }
  return { ascent_style: 'redpoint', attempt_count: tries, attempt_bucket: triesBucket(tries) }
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

  // ── Pre-load route from URL param ──
  const { data: preRoute, isLoading: preRouteLoading } = useRoute(preRouteId ?? '')

  // ── Route search state ──
  const [routeQuery, setRouteQuery] = useState('')
  const [selectedRoute, setSelectedRoute] = useState<RouteSearchResult | null>(null)
  const [showDropdown, setShowDropdown] = useState(false)
  const { data: searchResults, isFetching: searchFetching } = useRouteSearch(
    selectedRoute ? '' : routeQuery
  )

  // ── Ascent fields ──
  const [date, setDate] = useState(new Date().toISOString().slice(0, 10))
  const [ascentMode, setAscentMode] = useState<'onsight' | 'flash' | 'redpoint'>('onsight')
  const [triesCount, setTriesCount] = useState(2)
  const [isRepeat, setIsRepeat] = useState(false)
  const [effort, setEffort] = useState<number | ''>('')
  const dateShortcuts = getDateShortcuts()
  const [quality, setQuality] = useState<number | null>(null)
  const [hoverStar, setHoverStar] = useState<number | null>(null)
  const [personalGrade, setPersonalGrade] = useState('')
  const [proposedGrade, setProposedGrade] = useState('')
  const [difficultyFeel, setDifficultyFeel] = useState('')
  const [styleFeel, setStyleFeel] = useState('')
  const [wantRepeat, setWantRepeat] = useState<boolean | null>(null)

  // ── Notes (route technical data) ──
  const [notesValues, setNotesValues] = useState<RouteNotesValues>({
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
  })

  // ── Form state ──
  const [visibility, setVisibility] = useState<'public' | 'private'>('public')
  const [notes, setNotes] = useState('')
  const [step, setStep] = useState(1)
  const [saved, setSaved] = useState(false)
  const [error, setError] = useState('')

  // Pre-select route when loaded from URL param
  useEffect(() => {
    if (preRoute && !selectedRoute) {
      setSelectedRoute({
        id: preRoute.id,
        name: preRoute.name,
        official_grade: preRoute.official_grade,
        grade_numeric: preRoute.grade_numeric,
        route_type: preRoute.route_type,
        sector_name: preRoute.sector?.name ?? '',
        crag_name: preRoute.sector?.crag?.name ?? '',
      })
      setRouteQuery(preRoute.name)
    }
  }, [preRoute])

  function selectRoute(r: RouteSearchResult) {
    setSelectedRoute(r)
    setRouteQuery(r.name)
    setShowDropdown(false)
  }

  async function saveBase() {
    if (!user || !selectedRoute) return
    setError('')
    const mapped = buildMapped(ascentMode, triesCount, isRepeat)

    const values: AscentFormValues = {
      route_id: selectedRoute.id,
      session_id: null,
      date,
      attempt_type: null,
      ascent_style: mapped.ascent_style,
      attempt_count: mapped.attempt_count,
      attempt_bucket: mapped.attempt_bucket,
      is_repeat: isRepeat,
      grade_at_ascent: selectedRoute.official_grade,
      grade_numeric_at_ascent: selectedRoute.grade_numeric,
      personal_grade: personalGrade || null,
      quality,
      difficulty_feel: difficultyFeel || null,
      style_feel: styleFeel || null,
      proposed_grade: proposedGrade || null,
      want_repeat: wantRepeat,
      kneepad_used: notesValues.kneepad_used || null,
      effort: effort !== '' ? Number(effort) : null,
      notes: notes || null,
      visibility,
    }

    try {
      await createAscent.mutateAsync({ userId: user.id, values, routeId: selectedRoute.id })
      setSaved(true)
    } catch (e) {
      setError((e as Error).message)
    }
  }

  async function saveAll() {
    if (!user || !selectedRoute) return
    setError('')
    const mapped = buildMapped(ascentMode, triesCount, isRepeat)

    const values: AscentFormValues = {
      route_id: selectedRoute.id,
      session_id: null,
      date,
      attempt_type: null,
      ascent_style: mapped.ascent_style,
      attempt_count: mapped.attempt_count,
      attempt_bucket: mapped.attempt_bucket,
      is_repeat: isRepeat,
      grade_at_ascent: selectedRoute.official_grade,
      grade_numeric_at_ascent: selectedRoute.grade_numeric,
      personal_grade: personalGrade || null,
      quality,
      difficulty_feel: difficultyFeel || null,
      style_feel: styleFeel || null,
      proposed_grade: proposedGrade || null,
      want_repeat: wantRepeat,
      kneepad_used: notesValues.kneepad_used || null,
      effort: effort !== '' ? Number(effort) : null,
      notes: notes || null,
      visibility,
    }

    try {
      await createAscent.mutateAsync({ userId: user.id, values, routeId: selectedRoute.id })
      if (hasAnyData(notesValues)) {
        const payload = toPayload(notesValues, user.id, selectedRoute.id, visibility)
        await upsertNotes.mutateAsync(payload)
      }
      setSaved(true)
    } catch (e) {
      setError((e as Error).message)
    }
  }

  const isPending = createAscent.isPending || upsertNotes.isPending

  // ── Success screen ────────────────────────────────────────────────────────
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
                setSaved(false)
                setSelectedRoute(null)
                setRouteQuery('')
                setStep(1)
                setNotes('')
                setQuality(null)
                setPersonalGrade('')
                setProposedGrade('')
                setDifficultyFeel('')
                setStyleFeel('')
                setWantRepeat(null)
                setEffort('')
                setIsRepeat(false)
                setAscentMode('onsight')
                setTriesCount(2)
                setNotesValues({
                  hold_profile: {},
                  movement_profile: {},
                  style_profile: {},
                  crux: '', rests: '', main_beta: '', alternative_beta: '',
                  kneepad_used: false, kneepad_data: {}, equipment_data: {}, safety_notes: '',
                })
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

      {/* ── Step card ── */}
      <div className="log-step-card">

        {/* ═══════════ STEP 1 ═══════════ */}
        {step === 1 && (
          <>
            {/* ── Route search ── */}
            {selectedRoute ? (
              <div className="log-route-preview">
                <div style={{ flex: 1 }}>
                  <div className="log-route-preview-name">{selectedRoute.name}</div>
                  <div className="log-route-preview-sub">
                    {selectedRoute.crag_name} › {selectedRoute.sector_name}
                    {selectedRoute.official_grade && (
                      <span className="grade-badge" style={{ marginLeft: 8 }}>{selectedRoute.official_grade}</span>
                    )}
                  </div>
                </div>
                <button type="button" className="btn-secondary" style={{ fontSize: 11, padding: '4px 10px' }}
                  onClick={() => { setSelectedRoute(null); setRouteQuery('') }}>
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

            {/* ── Quando? ── */}
            <div className="log-q">Quando hai salito?</div>
            <input type="date" value={date} onChange={e => setDate(e.target.value)}
              style={{ width: '100%', marginBottom: 4 }} />
            <div className="log-date-shortcuts">
              {dateShortcuts.map(s => (
                <button key={s.label} type="button"
                  className={`log-date-shortcut${date === s.value ? ' active' : ''}`}
                  onClick={() => setDate(s.value)}>
                  {s.label}
                </button>
              ))}
            </div>

            {/* ── Come? ── */}
            <div className="log-q">Come hai salito?</div>
            <div className="log-style-circles">
              {ASCENT_MODES.map(m => (
                <button key={m.value} type="button"
                  className={`log-style-circle${ascentMode === m.value && !isRepeat ? ' active' : ''}`}
                  style={isRepeat ? { opacity: 0.35, cursor: 'not-allowed' } : {}}
                  onClick={() => { if (!isRepeat) { setAscentMode(m.value as typeof ascentMode); if (m.value !== 'redpoint') setTriesCount(2) } }}>
                  <div className="log-style-circle-ring">
                    <div className="log-style-circle-inner" />
                  </div>
                  <span className="log-style-circle-label">{m.label}</span>
                </button>
              ))}
            </div>

            {/* Tries stepper (solo redpoint) */}
            {ascentMode === 'redpoint' && !isRepeat && (
              <div className="log-tries-row">
                <button type="button" className="log-tries-btn"
                  disabled={triesCount <= 2}
                  onClick={() => setTriesCount(n => Math.max(2, n - 1))}>−</button>
                <div className="log-tries-count">
                  <span className="log-tries-count-num">{triesCount}</span>
                  <span className="log-tries-count-label">{triesCount === 1 ? 'tentativo' : 'tentativi'}</span>
                </div>
                <button type="button" className="log-tries-btn"
                  onClick={() => setTriesCount(n => n + 1)}>+</button>
              </div>
            )}

            {/* Repeat toggle */}
            <div className="log-repeat-row">
              <input type="checkbox" id="repeat-chk" checked={isRepeat}
                onChange={e => setIsRepeat(e.target.checked)} />
              <label htmlFor="repeat-chk">È una ripetizione</label>
            </div>

            {/* ── Sforzo ── */}
            <div className="log-q" style={{ marginTop: 24 }}>Sforzo percepito <span style={{ fontWeight: 400, fontSize: 11, color: 'var(--text-muted)', textTransform: 'none', letterSpacing: 0 }}>(opzionale)</span></div>
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

            {/* ── Nav buttons ── */}
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
                  {preRouteId && preRouteLoading && !selectedRoute ? 'Caricamento…' : 'Continua →'}
                </button>
              </div>
            </div>
          </>
        )}

        {/* ═══════════ STEP 2 ═══════════ */}
        {step === 2 && (
          <>
            <h2>Stile & Prese</h2>
            <RouteNotesForm
              sections={['stile', 'prese']}
              onChange={setNotesValues}
            />
            <div className="log-nav-btns">
              <button type="button" className="btn-secondary" onClick={() => setStep(1)}>← Indietro</button>
              <button type="button" className="btn-primary" onClick={() => setStep(3)}>Avanti →</button>
            </div>
          </>
        )}

        {/* ═══════════ STEP 3 ═══════════ */}
        {step === 3 && (
          <>
            <h2>Movimenti & Beta</h2>
            <RouteNotesForm
              sections={['movimenti', 'beta']}
              onChange={setNotesValues}
            />
            <div className="log-nav-btns">
              <button type="button" className="btn-secondary" onClick={() => setStep(2)}>← Indietro</button>
              <button type="button" className="btn-primary" onClick={() => setStep(4)}>Avanti →</button>
            </div>
          </>
        )}

        {/* ═══════════ STEP 4 ═══════════ */}
        {step === 4 && (
          <>
            <h2>Kneepad & Attrezzatura</h2>
            <RouteNotesForm
              sections={['kneepad', 'equipment']}
              onChange={setNotesValues}
            />
            <div className="log-nav-btns">
              <button type="button" className="btn-secondary" onClick={() => setStep(3)}>← Indietro</button>
              <button type="button" className="btn-primary" onClick={() => setStep(5)}>Avanti →</button>
            </div>
          </>
        )}

        {/* ═══════════ STEP 5 ═══════════ */}
        {step === 5 && (
          <>
            <h2>Sicurezza & Valutazione</h2>

            <RouteNotesForm
              sections={['safety']}
              onChange={setNotesValues}
            />

            <div className="log-section-title" style={{ marginTop: 20 }}>Valutazione personale</div>

            {/* Bellezza stelle */}
            <div className="form-group" style={{ marginBottom: 16 }}>
              <label>Bellezza</label>
              <div style={{ display: 'flex', gap: 4, paddingTop: 4 }}>
                {[1, 2, 3, 4, 5].map(n => (
                  <button key={n} type="button"
                    onClick={() => setQuality(quality === n ? null : n)}
                    onMouseEnter={() => setHoverStar(n)}
                    onMouseLeave={() => setHoverStar(null)}
                    style={{
                      background: 'none', border: 'none', cursor: 'pointer', padding: 0,
                      fontSize: 28, lineHeight: 1,
                      color: n <= (hoverStar ?? quality ?? 0) ? '#f5a623' : 'rgba(247,243,234,0.18)',
                      transition: 'color 0.1s',
                    }}>★</button>
                ))}
                {quality && <span style={{ fontSize: 11, color: 'var(--text-muted)', alignSelf: 'center', marginLeft: 6 }}>{quality}/5</span>}
              </div>
            </div>

            {/* Difficoltà percepita */}
            <div className="form-group" style={{ marginBottom: 16 }}>
              <label>Difficoltà percepita</label>
              <div className="log-pill-group" style={{ marginTop: 8 }}>
                {DIFFICULTY_FEEL_OPTIONS.map(o => (
                  <button key={o.value} type="button"
                    className={`log-pill${difficultyFeel === o.value ? ' active' : ''}`}
                    onClick={() => setDifficultyFeel(difficultyFeel === o.value ? '' : o.value)}>
                    {o.label}
                  </button>
                ))}
              </div>
            </div>

            {/* Stile feel */}
            <div className="form-group" style={{ marginBottom: 16 }}>
              <label>Stile</label>
              <div className="log-pill-group" style={{ marginTop: 8 }}>
                {STYLE_FEEL_OPTIONS.map(o => (
                  <button key={o.value} type="button"
                    className={`log-pill${styleFeel === o.value ? ' active' : ''}`}
                    onClick={() => setStyleFeel(styleFeel === o.value ? '' : o.value)}>
                    {o.label}
                  </button>
                ))}
              </div>
            </div>

            {/* Gradi */}
            <div className="form-grid">
              <div className="form-group">
                <label>Grado percepito</label>
                <select className="logbook-select" value={personalGrade} onChange={e => setPersonalGrade(e.target.value)}>
                  <option value="">— Non specificato —</option>
                  {GRADE_ORDER.map(g => <option key={g} value={g}>{g}</option>)}
                </select>
              </div>
              <div className="form-group">
                <label>Grado proposto</label>
                <select className="logbook-select" value={proposedGrade} onChange={e => setProposedGrade(e.target.value)}>
                  <option value="">— Non specificato —</option>
                  {GRADE_ORDER.map(g => <option key={g} value={g}>{g}</option>)}
                </select>
              </div>
            </div>

            {/* Voglio ripeterla */}
            <div className="log-repeat-row" style={{ justifyContent: 'flex-start', marginTop: 8 }}>
              <input type="checkbox" id="want-repeat" checked={wantRepeat === true}
                onChange={e => setWantRepeat(e.target.checked ? true : null)} />
              <label htmlFor="want-repeat">Voglio ripeterla</label>
            </div>

            <div className="log-nav-btns">
              <button type="button" className="btn-secondary" onClick={() => setStep(4)}>← Indietro</button>
              <button type="button" className="btn-primary" onClick={() => setStep(6)}>Avanti →</button>
            </div>
          </>
        )}

        {/* ═══════════ STEP 6 ═══════════ */}
        {step === 6 && (
          <>
            <h2>Visibilità & Salvataggio</h2>

            <div className="form-grid">
              <div className="form-group">
                <label>Visibilità</label>
                <select
                  className="logbook-select"
                  value={visibility}
                  onChange={e => setVisibility(e.target.value as 'public' | 'private')}
                >
                  <option value="public">Pubblica</option>
                  <option value="private">Privata</option>
                </select>
              </div>

              <div className="form-group form-full">
                <label>Note</label>
                <textarea
                  value={notes}
                  onChange={e => setNotes(e.target.value)}
                  placeholder="Note sulla salita, condizioni, sensazioni…"
                  rows={3}
                />
              </div>
            </div>

            {/* Summary */}
            {selectedRoute && (
              <div className="log-route-preview" style={{ marginBottom: 16 }}>
                <div>
                  <div className="log-route-preview-name">{selectedRoute.name}</div>
                  <div className="log-route-preview-sub">
                    {selectedRoute.crag_name} · {date} ·{' '}
                    {isRepeat ? 'Ripetizione' : ascentMode === 'onsight' ? 'On-sight' : ascentMode === 'flash' ? 'Flash' : `Redpoint (${triesCount})`}
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
              <button type="button" className="btn-secondary" onClick={() => setStep(5)}>← Indietro</button>
              <div className="log-nav-btns-right">
                <button
                  type="button"
                  className="btn-primary"
                  disabled={isPending || !selectedRoute || !date}
                  onClick={saveAll}
                >
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
