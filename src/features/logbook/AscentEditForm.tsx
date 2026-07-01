import type { AscentUpdateValues } from './hooks'
import {
  useAscentFields, buildAscentValues, toUpdateValues,
  deriveOptionFromRecord, parseProposed,
  RouteInfoPanel, AscentFields,
} from './ascentFields'
import '../../styles/admin.css'

// Ascensione già salvata, precompila la modalità edit. Include TUTTI i campi del
// modulo condiviso (draws_mode/difficulty_feel/style_feel/proposed_grade), non
// più il sottoinsieme povero di prima.
export interface EditableAscent {
  id: string
  date: string
  ascent_style: string | null
  attempt_count: number | null
  attempt_bucket: string | null
  grade_at_ascent: string | null
  is_repeat: boolean
  draws_mode: string | null
  quality: number | null
  difficulty_feel: string | null
  style_feel: string | null
  proposed_grade: string | null
  want_repeat: boolean | null
  effort: number | null
  kneepad_used: boolean | null
  notes: string | null
  visibility: 'public' | 'private'
  route: { id: string; name: string; official_grade: string | null } | null
}

interface Props {
  ascent: EditableAscent
  onSubmit: (values: AscentUpdateValues) => void
  onCancel: () => void
  isLoading?: boolean
}

// Modificare NON è un form diverso: è lo stesso modulo condiviso, aperto in edit,
// senza step di ricerca via (via già fissata), che al salvataggio fa UPDATE.
export default function AscentEditForm({ ascent, onSubmit, onCancel, isLoading }: Props) {
  const proposed = parseProposed(ascent.proposed_grade)

  const ctrl = useAscentFields({
    date: ascent.date,
    selectedOption: deriveOptionFromRecord(ascent.ascent_style, ascent.attempt_count, ascent.attempt_bucket),
    isRepeat: ascent.is_repeat,
    drawsMode: ascent.draws_mode ?? 'unknown',
    effort: ascent.effort ?? '',
    quality: ascent.quality,
    difficultyFeel: ascent.difficulty_feel ?? '',
    styleFeel: ascent.style_feel ?? '',
    proposedBase: proposed.base,
    proposedDec: proposed.dec,
    wantRepeat: ascent.want_repeat,
    kneepad: ascent.kneepad_used ?? false,
    notes: ascent.notes ?? '',
    visibility: ascent.visibility,
  })

  function submit() {
    // grade_at_ascent resta lo snapshot originale, non il grado corrente.
    const values = buildAscentValues(
      ctrl,
      { id: ascent.route?.id ?? '', official_grade: ascent.grade_at_ascent, grade_numeric: null },
      null,
    )
    onSubmit(toUpdateValues(values))
  }

  return (
    <div className="inline-form">
      {ascent.route && (
        <RouteInfoPanel
          routeId={ascent.route.id}
          name={ascent.route.name}
          officialGrade={ascent.route.official_grade}
        />
      )}

      <AscentFields ctrl={ctrl} showDate showKneepad showVisibility showNotes />

      <div className="form-actions">
        <button type="button" className="btn-secondary" onClick={onCancel}>Annulla</button>
        <button type="button" className="btn-primary" onClick={submit} disabled={isLoading}>
          {isLoading ? 'Salvataggio…' : 'Salva modifiche'}
        </button>
      </div>
    </div>
  )
}
