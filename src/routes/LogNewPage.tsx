import { useState, useEffect } from 'react'
import { useSearchParams, Link } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'
import { useRoute } from '../features/catalog/hooks'
import {
  useCreateAscent,
  useUpsertRouteNotes,
  type AscentFormValues,
  type RouteSearchResult,
} from '../features/logbook/hooks'
import {
  useAscentFields, buildAscentValues, formatMode,
  RouteSelect, AscentFields,
} from '../features/logbook/ascentFields'
import { useCreateSession, useSessionForDateCrag } from '../features/sessions/hooks'
import RouteNotesForm, {
  hasAnyData,
  toPayload,
  type RouteNotesValues,
} from '../features/logbook/RouteNotesForm'
import { useVoteRoute } from '../features/routes/hooks'
import '../styles/log-new.css'
import '../styles/admin.css'
import '../styles/logbook.css'

// ─── Constants ────────────────────────────────────────────────────────────────
// Costanti/helper stile-salita (QUICK_MODES, REDPOINT_OPTIONS, formatMode,
// buildMapped, gradi proposti…) vivono ora nel modulo condiviso ascentFields.

const STEPS = [
  { id: 1, label: 'Via & Salita' },
  { id: 2, label: 'Tecnica' },
  { id: 3, label: 'Beta' },
  { id: 4, label: 'Attrezzatura' },
]

const EMPTY_NOTES: RouteNotesValues = {
  hold_profile: {}, movement_profile: {}, style_profile: {},
  crux: '', rests: '', main_beta: '', alternative_beta: '',
  kneepad_used: false, kneepad_data: {}, equipment_data: {}, safety_notes: '',
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

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

  // ── Route search (la ricerca vive nel componente condiviso RouteSelect) ──
  const [routeQuery, setRouteQuery] = useState('')
  const [selectedRoute, setSelectedRoute] = useState<RouteSearchResult | null>(null)

  // ── Ascent fields (modulo condiviso ascentFields) ──
  const ctrl = useAscentFields()
  const dateShortcuts = getDateShortcuts()

  // ── Sessione automatica (utente, data, falesia) ──
  // Se forceNewSession è true la salita crea una sessione separata anche se
  // ne esiste già una per quella data+falesia (caso raro: due visite alla
  // stessa falesia nello stesso giorno).
  const [forceNewSession, setForceNewSession] = useState(false)
  const cragId = selectedRoute?.crag_id ?? ''
  const { data: existingSession } = useSessionForDateCrag(user?.id ?? '', ctrl.date, cragId)

  // Info complete della via selezionata (grado community, note) per il pannello.
  const { data: routeInfo } = useRoute(selectedRoute?.id ?? '')

  // ── Technical notes ──
  const [notesValues, setNotesValues] = useState<RouteNotesValues>(EMPTY_NOTES)

  // ── Meta ──
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
      if (!ctrl.proposedBase && preRoute.official_grade) ctrl.setProposedBase(preRoute.official_grade)
    }
  }, [preRoute])

  function selectRoute(r: RouteSearchResult) {
    setSelectedRoute(r)
    setRouteQuery(r.name)
    setForceNewSession(false)
    if (r.official_grade) ctrl.setProposedBase(r.official_grade)
  }

  function changeDate(v: string) {
    ctrl.setDate(v)
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
        date: ctrl.date,
        crag_id: cragId || null,
        partner: null, conditions: null, rock_condition: null,
        temperature: null, session_rpe: null, rest_days: null,
        notes: null, visibility: 'private',
      },
    })
    return s.id
  }

  // Il modulo condiviso costruisce l'AscentFormValues; la ginocchiera qui viene
  // dal pannello note tecniche (RouteNotesForm), non dal campo standard.
  function buildValues(sessionId: string | null): AscentFormValues {
    return buildAscentValues(ctrl, selectedRoute!, sessionId, {
      kneepadUsed: notesValues.kneepad_used || null,
    })
  }

  // Il grado proposto alimenta il voto community dell'utente (1 per utente,
  // upsert): più persone salgono la via, più la media community si affina.
  async function castGradeVote() {
    if (!user || !selectedRoute || !ctrl.proposedBase || ctrl.proposedNum == null) return
    await voteRoute.mutateAsync({
      routeId: selectedRoute.id,
      userId: user.id,
      perceived_grade: ctrl.proposedLabel,
      grade_numeric: ctrl.proposedNum,
      beauty: ctrl.quality,
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
        await upsertNotes.mutateAsync(toPayload(notesValues, user.id, selectedRoute.id, ctrl.visibility))
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
                ctrl.setNotes(''); ctrl.setQuality(null); ctrl.setProposedBase(''); ctrl.setProposedDec('')
                ctrl.setDifficultyFeel(''); ctrl.setStyleFeel(''); ctrl.setWantRepeat(null); ctrl.setEffort('')
                ctrl.setIsRepeat(false); ctrl.setSelectedOption('onsight'); ctrl.setDrawsMode('unknown')
                ctrl.setVisibility('public'); ctrl.setDate(new Date().toISOString().slice(0, 10))
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
              <RouteSelect
                query={routeQuery}
                onQueryChange={q => { setRouteQuery(q); setSelectedRoute(null) }}
                onSelect={selectRoute}
              />
            )}

            {/* Date */}
            <div className="log-q">Quando hai salito?</div>
            <input type="date" value={ctrl.date} onChange={e => changeDate(e.target.value)}
              style={{ width: '100%', marginBottom: 4 }} />
            <div className="log-date-shortcuts">
              {dateShortcuts.map(s => (
                <button key={s.label} type="button"
                  className={`log-date-shortcut${ctrl.date === s.value ? ' active' : ''}`}
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

            {/* Campi salita (modulo condiviso) — stile, montaggio, sforzo, valutazione */}
            <AscentFields ctrl={ctrl} />

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
                disabled={isPending || !selectedRoute || !ctrl.date}
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
                <select className="logbook-select" value={ctrl.visibility}
                  onChange={e => ctrl.setVisibility(e.target.value as 'public' | 'private')}>
                  <option value="public">Pubblica</option>
                  <option value="private">Privata</option>
                </select>
              </div>
              <div className="form-group form-full">
                <label>Note</label>
                <textarea value={ctrl.notes} onChange={e => ctrl.setNotes(e.target.value)}
                  placeholder="Note sulla salita, condizioni, sensazioni…" rows={3} />
              </div>
            </div>

            {selectedRoute && (
              <div className="log-route-preview" style={{ marginBottom: 16 }}>
                <div>
                  <div className="log-route-preview-name">{selectedRoute.name}</div>
                  <div className="log-route-preview-sub">
                    {selectedRoute.crag_name} · {ctrl.date} · {formatMode(ctrl.selectedOption, ctrl.isRepeat)}
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
                  disabled={isPending || !selectedRoute || !ctrl.date}
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
