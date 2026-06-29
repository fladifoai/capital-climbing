import { useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { useAuth } from '../features/auth/AuthContext'
import { useRoute } from '../features/catalog/hooks'
import {
  useRouteFeatures,
  useRoutePersonalHistory,
  useCommunityRating,
  useMyRouteRating,
  useVoteRoute,
  type RouteFeatures,
  type ProfileLevel,
} from '../features/routes/hooks'
import {
  useCreateAscent,
  type AscentFormValues,
  type RouteSearchResult,
} from '../features/logbook/hooks'
import AscentForm from '../features/logbook/AscentForm'
import SpoilerGuard from '../features/routes/SpoilerGuard'
import { numToGrade, GRADE_SCALE, GRADE_TO_NUM } from '../analytics/normalizers/grades'
import type { Ascent } from '../types/database'
import '../styles/catalog.css'
import '../styles/admin.css'
import '../styles/logbook.css'
import '../styles/route-detail.css'

// ─── Label maps ──────────────────────────────────────────────────────────────

const HOLD_LABELS: Record<string, string> = {
  crimp_sharp: 'Tacche nette', crimp_rounded: 'Tacche arrotondate',
  mono: 'Monoditi', two_finger: 'Biditi', three_finger: 'Triditi',
  sloper: 'Svasi', pinch: 'Pinze', jug: 'Maniglie', barrel: 'Canne',
  sidepull: 'Laterali', gaston: 'Gaston', undercling: 'Sottoprese',
  crack: 'Fessure', foothold_large: 'Appoggi grandi', foothold_small: 'Appoggi piccoli',
  slick: 'Lucide', sharp: 'Taglienti', morphological: 'Morfologiche',
}

const MOVEMENT_LABELS: Record<string, string> = {
  static: 'Statico', dynamic: 'Dinamico', jump: 'Lancio',
  long_reach: 'Allungo', cross: 'Incrocio', hand_swap: 'Cambio mano',
  foot_swap: 'Cambio piedi', flag: 'Bandiera', bicycle: 'Bicicletta',
  lolotte: 'Lolotte', dulfer: 'Dülfer', compression: 'Compressione',
  opposition: 'Opposizione', heel_hook: 'Tallonaggio', toe_hook: 'Toe hook',
  kneebar: 'Kneebar', campus: 'Campus', coordination: 'Coordinazione',
  mandatory: 'Obbligato', mantle: 'Ristabilimento', traverse: 'Traverso',
  rock_over: 'Ribaltamento', jam: 'Incastro',
}

const STYLE_LABELS: Record<string, string> = {
  technical: 'Tecnica', powerful: 'Potente', endurance: 'Resistenza',
  sustained: 'Continuità', boulderish: 'Boulderosa', physical: 'Fisica',
  balance: 'Equilibrio', reading: 'Lettura', finger: 'Dita',
  footwork: 'Piedi', pumpy: 'Pompante', mental: 'Mentale',
  morphological: 'Morfologica', single_crux: 'Crux singolo',
  hard_start: 'Partenza dura', hard_mid: 'Sezione centrale dura',
  hard_finish: 'Finale duro', consistent: 'Omogenea',
  overhang: 'Strapiombante', slab: 'Placca', wall: 'Verticale',
  diedre: 'Diedro', crack: 'Fessura', roof: 'Tetto',
}

const LEVEL_LABEL: Record<ProfileLevel, string> = {
  none: 'Assente', secondary: 'Secondario', important: 'Importante', dominant: 'Dominante',
}

const ATTEMPT_LABEL: Record<string, string> = {
  onsight: 'On-sight', flash: 'Flash', second: '2° giro',
  third: '3° giro', four_plus: '4+ giro', redpoint: 'Redpoint',
  repeat: 'Ripetizione',
}

const SAFETY_STATUS_LABEL: Record<string, string> = {
  verified: '✓ Verificato', unverified: 'Da verificare',
  flagged: '⚠ Segnalato', outdated: '⏰ Obsoleto',
}

interface MyRatingRow {
  perceived_grade: string | null
  grade_numeric: number | null
  beauty: number | null
}

// ─── Sub-components ───────────────────────────────────────────────────────────

function ProfileItem({ label, level }: { label: string; level: ProfileLevel }) {
  if (level === 'none') return null
  return (
    <div className={`profile-item profile-item--${level}`}>
      <span className="profile-item-label">{label}</span>
      <span className="profile-item-level">{LEVEL_LABEL[level]}</span>
    </div>
  )
}

function ProfileGrid({
  profile,
  labelMap,
}: {
  profile: Record<string, ProfileLevel>
  labelMap: Record<string, string>
}) {
  const visible = Object.entries(profile).filter(([, lv]) => lv !== 'none')
  if (visible.length === 0) return <p className="route-empty-hint">Nessun dato inserito.</p>
  return (
    <div className="profile-grid">
      {visible.map(([key, lv]) => (
        <ProfileItem key={key} label={labelMap[key] ?? key} level={lv} />
      ))}
    </div>
  )
}

function QuickFact({ label, value }: { label: string; value: React.ReactNode }) {
  if (value === null || value === undefined || value === '') return null
  return (
    <div className="quick-fact">
      <div className="quick-fact-value">{value}</div>
      <div className="quick-fact-label">{label}</div>
    </div>
  )
}

function RouteSafetyPanel({ safety }: { safety: RouteFeatures['safety_data'] }) {
  const flags = [
    { key: 'first_bolt_high', label: 'Primo spit alto', value: safety.first_bolt_high },
    { key: 'ground_fall_risk', label: 'Rischio terra', value: safety.ground_fall_risk },
    { key: 'ledge_fall_risk', label: 'Rischio cengia', value: safety.ledge_fall_risk },
    { key: 'unstable_rock', label: 'Roccia instabile', value: safety.unstable_rock },
    { key: 'problematic_anchor', label: 'Catena da verificare', value: safety.problematic_anchor },
    { key: 'helmet_recommended', label: 'Casco consigliato', value: safety.helmet_recommended },
  ].filter(f => f.value === true)

  const hasData =
    flags.length > 0 ||
    safety.minimum_rope ||
    safety.minimum_draws != null ||
    safety.notes ||
    safety.status

  if (!hasData) return null

  return (
    <div className="route-section">
      <h2 className="route-section-title">Sicurezza</h2>
      {flags.length > 0 && (
        <div className="safety-flags">
          {flags.map(f => (
            <span key={f.key} className="safety-flag">⚠ {f.label}</span>
          ))}
        </div>
      )}
      {(safety.minimum_rope || safety.minimum_draws != null) && (
        <div className="safety-gear">
          {safety.minimum_rope && <span>Corda min. {safety.minimum_rope}</span>}
          {safety.minimum_draws != null && <span>Rinvii min. {safety.minimum_draws}</span>}
        </div>
      )}
      {safety.status && (
        <div className={`safety-status safety-status--${safety.status}`}>
          {SAFETY_STATUS_LABEL[safety.status] ?? safety.status}
          {safety.verified_at
            ? ` · ${new Date(safety.verified_at).toLocaleDateString('it-IT')}`
            : ''}
        </div>
      )}
      {safety.notes && <p className="safety-notes">{safety.notes}</p>}
    </div>
  )
}

function RouteEquipmentPanel({ equip }: { equip: RouteFeatures['equipment_data'] }) {
  const items: string[] = [
    equip.minimum_rope ? `Corda min. ${equip.minimum_rope}` : '',
    equip.recommended_rope ? `Corda cons. ${equip.recommended_rope}` : '',
    equip.minimum_draws != null ? `${equip.minimum_draws} rinvii min.` : '',
    equip.recommended_draws != null ? `${equip.recommended_draws} rinvii cons.` : '',
    equip.stick_clip ? 'Stick clip consigliato' : '',
    equip.helmet ? 'Casco consigliato' : '',
  ].filter(Boolean)

  if (items.length === 0 && !equip.notes) return null

  return (
    <div className="route-section">
      <h2 className="route-section-title">Attrezzatura</h2>
      {items.length > 0 && (
        <div className="equipment-items">
          {items.map((item, i) => (
            <span key={i} className="equipment-item">{item}</span>
          ))}
        </div>
      )}
      {equip.notes && <p className="equipment-notes">{equip.notes}</p>}
    </div>
  )
}

function BeautyStars({ value, onChange }: { value: number; onChange?: (n: number) => void }) {
  const [hover, setHover] = useState(0)
  const display = hover || value
  return (
    <div className="beauty-stars" aria-label={`${value} stelle su 5`}>
      {[1, 2, 3, 4, 5].map(n => (
        <button
          key={n}
          type="button"
          className={`star-btn${display >= n ? ' star-btn--active' : ''}`}
          onClick={() => onChange?.(n === value ? 0 : n)}
          onMouseEnter={() => onChange && setHover(n)}
          onMouseLeave={() => onChange && setHover(0)}
          aria-label={`${n} ${n === 1 ? 'stella' : 'stelle'}`}
          disabled={!onChange}
        >
          ★
        </button>
      ))}
    </div>
  )
}

function RouteCommunityGrade({
  rating,
  myRating,
  routeId,
  userId,
  officialGrade,
}: {
  rating: ReturnType<typeof useCommunityRating>['data']
  myRating: MyRatingRow | null
  routeId: string
  userId: string | null
  officialGrade: string | null
}) {
  const [editing, setEditing] = useState(false)
  const [selGrade, setSelGrade] = useState<string>(myRating?.perceived_grade ?? '')
  const [selBeauty, setSelBeauty] = useState<number>(myRating?.beauty ?? 0)
  const voteRoute = useVoteRoute()

  async function submitVote() {
    if (!userId) return
    const gn = GRADE_TO_NUM[selGrade] ?? null
    await voteRoute.mutateAsync({
      routeId,
      userId,
      perceived_grade: selGrade || null,
      grade_numeric: gn,
      beauty: selBeauty || null,
    })
    setEditing(false)
  }

  const communityGradeLabel =
    rating?.avg_grade_numeric != null
      ? numToGrade(Math.round(rating.avg_grade_numeric))
      : null

  return (
    <div className="route-section">
      <h2 className="route-section-title">Grado community</h2>
      <div className="community-grade-row">
        <div className="community-grade-block">
          <span className="community-grade-label">Ufficiale</span>
          <span className="grade-badge grade-badge--lg">{officialGrade ?? '—'}</span>
        </div>
        <div className="community-grade-block">
          <span className="community-grade-label">
            Community {rating?.rating_count ? `(${rating.rating_count} voti)` : ''}
          </span>
          <span className="grade-badge grade-badge--lg grade-badge--community">
            {communityGradeLabel ?? '—'}
          </span>
        </div>
        {rating?.avg_beauty != null && (
          <div className="community-grade-block">
            <span className="community-grade-label">Bellezza media</span>
            <BeautyStars value={Math.round(rating.avg_beauty)} />
          </div>
        )}
      </div>

      {userId && !editing && (
        <button className="vote-toggle-btn" onClick={() => setEditing(true)}>
          {myRating ? 'Modifica il tuo voto' : '+ Aggiungi il tuo voto'}
        </button>
      )}

      {editing && (
        <div className="vote-form">
          <div className="vote-form-row">
            <label className="vote-label">Grado percepito</label>
            <select
              className="logbook-select"
              value={selGrade}
              onChange={e => setSelGrade(e.target.value)}
            >
              <option value="">— Non specificato —</option>
              {Object.values(GRADE_SCALE).map(g => (
                <option key={g} value={g}>{g}</option>
              ))}
            </select>
          </div>
          <div className="vote-form-row">
            <label className="vote-label">Bellezza</label>
            <BeautyStars value={selBeauty} onChange={setSelBeauty} />
          </div>
          <div className="vote-form-btns">
            <button className="btn-secondary" onClick={() => setEditing(false)}>Annulla</button>
            <button
              className="btn-primary"
              onClick={submitVote}
              disabled={voteRoute.isPending}
            >
              Salva voto
            </button>
          </div>
        </div>
      )}
    </div>
  )
}

function CruxSection({ crux }: { crux: RouteFeatures['crux_data'] }) {
  const rows: Array<{ label: string; value: React.ReactNode }> = [
    { label: 'Posizione', value: crux.position },
    { label: 'Tipo', value: crux.crux_type },
    { label: 'Movimenti', value: crux.moves_count != null ? `${crux.moves_count} mosse` : null },
    { label: 'Lettura', value: crux.reading_difficulty },
    { label: 'Note', value: crux.notes },
  ].filter(r => r.value)
  if (rows.length === 0) return <p className="route-empty-hint">Nessun dato sul crux.</p>
  return (
    <div className="crux-grid">
      {rows.map(r => (
        <div key={String(r.label)} className="crux-row">
          <span className="crux-label">{r.label}</span>
          <span className="crux-value">{r.value}</span>
        </div>
      ))}
    </div>
  )
}

function RestSection({ rest }: { rest: RouteFeatures['rest_data'] }) {
  const rows: Array<{ label: string; value: React.ReactNode }> = [
    { label: 'Numero riposi', value: rest.rest_count != null ? rest.rest_count : null },
    { label: 'No-hand rest', value: rest.has_no_hand_rest ? 'Sì' : null },
    { label: 'Kneebar rest', value: rest.has_kneebar_rest ? 'Sì' : null },
    { label: 'Note', value: rest.notes },
  ].filter(r => r.value != null)
  if (rows.length === 0) return <p className="route-empty-hint">Nessun dato sui riposi.</p>
  return (
    <div className="crux-grid">
      {rows.map(r => (
        <div key={String(r.label)} className="crux-row">
          <span className="crux-label">{r.label}</span>
          <span className="crux-value">{r.value}</span>
        </div>
      ))}
    </div>
  )
}

function KneepadSection({ kneepad }: { kneepad: RouteFeatures['kneepad_data'] }) {
  if (!kneepad.kneepad_possible) {
    return <p className="route-empty-hint">Kneepad non applicabile per questa via.</p>
  }
  const USEFUL_LABEL: Record<string, string> = {
    not_needed: 'Non necessario', useful: 'Utile',
    very_useful: 'Molto utile', essential: 'Indispensabile',
  }
  const KNEE_LABEL: Record<string, string> = { left: 'Sinistro', right: 'Destro', both: 'Entrambi' }
  const rows: Array<{ label: string; value: React.ReactNode }> = [
    { label: 'Utilità', value: kneepad.kneepad_useful ? USEFUL_LABEL[kneepad.kneepad_useful] : null },
    { label: 'Ginocchio', value: kneepad.knee ? KNEE_LABEL[kneepad.knee] : null },
    { label: 'Numero kneebar', value: kneepad.kneebar_count != null ? kneepad.kneebar_count : null },
    { label: 'Note', value: kneepad.notes },
  ].filter(r => r.value != null)
  if (rows.length === 0) return <p className="route-empty-hint">Kneepad possibile ma nessun dettaglio inserito.</p>
  return (
    <div className="crux-grid">
      {rows.map(r => (
        <div key={String(r.label)} className="crux-row">
          <span className="crux-label">{r.label}</span>
          <span className="crux-value">{r.value}</span>
        </div>
      ))}
    </div>
  )
}

function RoutePersonalHistory({
  ascents,
  onAddClick,
}: {
  ascents: Ascent[]
  onAddClick: () => void
}) {
  const best = ascents.find(a => a.status === 'completed')
  return (
    <div className="route-section">
      <div className="personal-history-header">
        <h2 className="route-section-title">La mia storia</h2>
        <button className="btn-primary btn-sm" onClick={onAddClick}>
          + Registra ascensione
        </button>
      </div>
      {best && (
        <div className="personal-best">
          <span className="personal-best-label">Completata</span>
          <span className="attempt-badge">{ATTEMPT_LABEL[best.ascent_style ?? best.attempt_type ?? ''] ?? best.ascent_style ?? best.attempt_type ?? '—'}</span>
          {best.grade_at_ascent && <span className="grade-badge">{best.grade_at_ascent}</span>}
          <span className="personal-best-date">{new Date(best.date).toLocaleDateString('it-IT')}</span>
        </div>
      )}
      {ascents.length === 0 ? (
        <p className="route-empty-hint">Non hai ancora registrato ascensioni su questa via.</p>
      ) : (
        <div className="personal-history-list">
          {ascents.map(a => (
            <div key={a.id} className="history-row">
              <span className="history-date">{new Date(a.date).toLocaleDateString('it-IT')}</span>
              <span className={`attempt-badge${a.status !== 'completed' ? ' attempted' : ''}`}>
                {a.status === 'completed'
                  ? (ATTEMPT_LABEL[a.ascent_style ?? a.attempt_type ?? ''] ?? a.ascent_style ?? a.attempt_type ?? 'Salita')
                  : 'Tentativo'}
              </span>
              {a.grade_at_ascent && <span className="grade-badge">{a.grade_at_ascent}</span>}
              {a.quality != null && (
                <span className="history-quality">
                  {'★'.repeat(a.quality)}{'☆'.repeat(5 - a.quality)}
                </span>
              )}
              {a.notes && <span className="history-notes">{a.notes}</span>}
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

// ─── Main page ────────────────────────────────────────────────────────────────

export default function RouteDetailPage() {
  const { routeId = '' } = useParams()
  const { user } = useAuth()

  const { data: route, isLoading, error } = useRoute(routeId)
  const { data: features } = useRouteFeatures(routeId)
  const { data: communityRating } = useCommunityRating(routeId)
  const { data: personalHistory } = useRoutePersonalHistory(routeId, user?.id ?? '')
  const { data: myRatingRaw } = useMyRouteRating(routeId, user?.id ?? '')
  const createAscent = useCreateAscent()

  const [showForm, setShowForm] = useState(false)
  const [formDone, setFormDone] = useState(false)
  const [formError, setFormError] = useState('')

  if (isLoading) return <div className="loading-state">Caricamento via…</div>
  if (error || !route) return <div className="error-state">Via non trovata.</div>

  const myRating: MyRatingRow | null = myRatingRaw as MyRatingRow | null

  const preselected: RouteSearchResult = {
    id: route.id,
    name: route.name,
    official_grade: route.official_grade,
    grade_numeric: route.grade_numeric,
    route_type: route.route_type,
    sector_name: route.sector?.name ?? '',
    crag_name: route.sector?.crag?.name ?? '',
  }

  async function handleSubmit(values: AscentFormValues) {
    if (!user) return
    setFormError('')
    console.log('[RouteDetailPage] handleSubmit called', { routeId, userId: user.id })
    try {
      await createAscent.mutateAsync({ userId: user.id, values, routeId })
      setShowForm(false)
      setFormDone(true)
    } catch (e) {
      console.error('[RouteDetailPage] handleSubmit error', e)
      setFormError((e as Error).message || String(e))
    }
  }

  const safetyData = features?.safety_data ?? {}
  const equipData = features?.equipment_data ?? {}
  const holdProfile = features?.hold_profile ?? {}
  const movementProfile = features?.movement_profile ?? {}
  const styleProfile = features?.style_profile ?? {}
  const cruxData = features?.crux_data ?? {}
  const restData = features?.rest_data ?? {}
  const kneepadData = features?.kneepad_data ?? {}

  const routeType = route.route_type === 'sport' ? 'Sport' : route.route_type

  return (
    <div className="route-detail-page">

      {/* ── Breadcrumb ── */}
      <nav className="breadcrumb" aria-label="Percorso">
        <Link to="/explore">Falesie</Link>
        {route.sector?.crag && (
          <>
            <span className="breadcrumb-sep" aria-hidden="true">›</span>
            <Link to={`/crags/${route.sector.crag.id}`}>{route.sector.crag.name}</Link>
          </>
        )}
        {route.sector && (
          <>
            <span className="breadcrumb-sep" aria-hidden="true">›</span>
            <span>{route.sector.name}</span>
          </>
        )}
        <span className="breadcrumb-sep" aria-hidden="true">›</span>
        <span>{route.name}</span>
      </nav>

      {/* ── Header ── */}
      <div className="route-header-card">
        <div className="route-header-top">
          <div className="route-header-info">
            <h1 className="route-name">{route.name}</h1>
            <div className="route-header-meta">
              {route.sector?.crag && (
                <Link to={`/crags/${route.sector.crag.id}`} className="route-crag-link">
                  {route.sector.crag.name}
                </Link>
              )}
              {route.sector && (
                <span className="route-header-sep">· {route.sector.name}</span>
              )}
              {route.sector?.crag?.region && (
                <span className="route-header-sep">· {route.sector.crag.region}</span>
              )}
            </div>
          </div>
          <div className="route-header-actions">
            {route.official_grade && (
              <span className="grade-badge route-grade-badge">{route.official_grade}</span>
            )}
          </div>
        </div>

        <div className="route-action-btns">
          {user && !formDone && (
            <button
              className="btn-primary"
              onClick={() => { setShowForm(f => !f); setFormError('') }}
            >
              {showForm ? '✕ Annulla' : '+ Registra ascensione'}
            </button>
          )}
          {!user && (
            <Link to="/login" className="btn-primary" style={{ textDecoration: 'none', display: 'inline-block' }}>
              Accedi per registrare
            </Link>
          )}
        </div>

        {formDone && (
          <div className="form-success">
            ✓ Ascensione registrata!{' '}
            <button className="link-btn" onClick={() => setFormDone(false)}>
              Aggiungine un'altra
            </button>
          </div>
        )}
      </div>

      {/* ── Log ascent form ── */}
      {showForm && (
        <div className="route-form-section">
          {formError && <div className="admin-error">{formError}</div>}
          <AscentForm
            preselectedRoute={preselected}
            onSubmit={handleSubmit}
            onCancel={() => { setShowForm(false); setFormError('') }}
            isLoading={createAscent.isPending}
          />
        </div>
      )}

      {/* ── Quick facts ── */}
      <div className="quick-facts-grid">
        <QuickFact label="Grado" value={route.official_grade} />
        <QuickFact label="Lunghezza" value={route.length_m ? `${route.length_m} m` : null} />
        <QuickFact label="Spit" value={route.bolts} />
        <QuickFact label="Tipo" value={routeType} />
        <QuickFact label="Tiri" value={route.pitches > 1 ? route.pitches : null} />
        <QuickFact label="Inclinazione" value={route.angle} />
        <QuickFact label="Roccia" value={route.rock_type} />
        {route.first_ascent && <QuickFact label="Prima salita" value={route.first_ascent} />}
      </div>

      {/* ── Description ── */}
      {route.description && (
        <div className="route-section route-description">
          <p>{route.description}</p>
        </div>
      )}

      {/* ── Safety (always visible) ── */}
      <RouteSafetyPanel safety={safetyData as RouteFeatures['safety_data']} />

      {/* ── Equipment essential (always visible) ── */}
      <RouteEquipmentPanel equip={equipData as RouteFeatures['equipment_data']} />

      {/* ── Community grade (always visible) ── */}
      <RouteCommunityGrade
        rating={communityRating}
        myRating={myRating}
        routeId={routeId}
        userId={user?.id ?? null}
        officialGrade={route.official_grade}
      />

      {/* ── Spoiler: Prese e movimenti ── */}
      <div className="route-section">
        <h2 className="route-section-title">Prese e movimenti</h2>
        <SpoilerGuard routeId={routeId} userId={user?.id ?? null} title="Prese e movimenti">
          <div className="spoiler-content">
            {features ? (
              <>
                <div className="profile-block">
                  <h3 className="profile-block-title">Prese</h3>
                  <ProfileGrid profile={holdProfile as Record<string, ProfileLevel>} labelMap={HOLD_LABELS} />
                </div>
                <div className="profile-block">
                  <h3 className="profile-block-title">Movimenti</h3>
                  <ProfileGrid profile={movementProfile as Record<string, ProfileLevel>} labelMap={MOVEMENT_LABELS} />
                </div>
                <div className="profile-block">
                  <h3 className="profile-block-title">Stile</h3>
                  <ProfileGrid profile={styleProfile as Record<string, ProfileLevel>} labelMap={STYLE_LABELS} />
                </div>
              </>
            ) : (
              <p className="route-empty-hint">Nessun dato tecnico disponibile per questa via.</p>
            )}
          </div>
        </SpoilerGuard>
      </div>

      {/* ── Spoiler: Crux e riposi ── */}
      <div className="route-section">
        <h2 className="route-section-title">Crux e riposi</h2>
        <SpoilerGuard routeId={routeId} userId={user?.id ?? null} title="Crux e riposi">
          <div className="spoiler-content">
            {features ? (
              <>
                <div className="profile-block">
                  <h3 className="profile-block-title">Crux</h3>
                  <CruxSection crux={cruxData as RouteFeatures['crux_data']} />
                </div>
                <div className="profile-block">
                  <h3 className="profile-block-title">Riposi</h3>
                  <RestSection rest={restData as RouteFeatures['rest_data']} />
                </div>
              </>
            ) : (
              <p className="route-empty-hint">Nessun dato tecnico disponibile per questa via.</p>
            )}
          </div>
        </SpoilerGuard>
      </div>

      {/* ── Spoiler: Kneepad ── */}
      <div className="route-section">
        <h2 className="route-section-title">Kneepad e kneebar</h2>
        <SpoilerGuard routeId={routeId} userId={user?.id ?? null} title="Kneepad e kneebar">
          <div className="spoiler-content">
            {features ? (
              <KneepadSection kneepad={kneepadData as RouteFeatures['kneepad_data']} />
            ) : (
              <p className="route-empty-hint">Nessun dato disponibile.</p>
            )}
          </div>
        </SpoilerGuard>
      </div>

      {/* ── Personal history ── */}
      {user && (
        <RoutePersonalHistory
          ascents={personalHistory ?? []}
          onAddClick={() => { setShowForm(true); setFormDone(false); window.scrollTo({ top: 0, behavior: 'smooth' }) }}
        />
      )}

    </div>
  )
}
