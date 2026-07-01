// Capital Score v1.0 — sistema punti ufficiale di Capital Climbing.
// Formula: 700 + 100 × grade_numeric + style_bonus.
// La scala grade_numeric qui (5c = 0) è SPECIFICA del Capital Score e NON
// coincide con grade_numeric_at_ascent del DB (scala 4a = 1, vedi
// src/analytics/normalizers/grades.ts). Tenerle separate è voluto.
// Bonus montaggio rinvii predisposto ma disattivato (MOUNT_BONUS_ACTIVE = false).

export const SCORE_VERSION = 'capital_score_v1' as const

export type CapitalAttemptType = 'onsight' | 'flash' | 'second_go' | 'redpoint'
export type DrawsMode = 'unknown' | 'preplaced' | 'placed_by_user'

export const BASE_SCORE = 700
export const GRADE_STEP = 100

// grade_numeric Capital: 5c = 0, +1 per gradino. Slash = mezzo gradino.
export const GRADE_MAP: Record<string, number> = {
  '5c': 0,
  '6a': 1,
  '6a+': 2,
  '6b': 3,
  '6b/6b+': 3.5,
  '6b+': 4,
  '6c': 5,
  '6c/6c+': 5.5,
  '6c+': 6,
  '6c+/7a': 6.5,
  '7a': 7,
  '7a+': 8,
  '7b': 9,
  '7b+': 10,
  '7c': 11,
  '7c+': 12,
  '8a': 13,
  '8a+': 14,
  '8b': 15,
  '8b+': 16,
  '8c': 17,
  '8c+': 18,
  '9a': 19,
  '9a+': 20,
  '9b': 21,
  '9b+': 22,
}

export const STYLE_BONUS: Record<CapitalAttemptType, number> = {
  onsight: 290,
  flash: 90,
  second_go: 30,
  redpoint: 0,
}

// Bonus montaggio via ATTIVO (v1.0): per ora ogni a-vista è considerata
// "onsight montando". Il bonus è un micro-bonus (+10) — il massimo che
// preserva la regola di spec "7a onsight montando NON supera 7b+ redpoint"
// (7a onsight 1690, 7b+ redpoint 1700 → margine 10). Non deve mai diventare
// un cambio di categoria.
export const MOUNT_BONUS_ACTIVE = true

export const MOUNT_BONUS: Record<CapitalAttemptType, number> = {
  onsight: 10,
  flash: 0,
  second_go: 0,
  redpoint: 0,
}

// Normalizza una stringa grado in una chiave compatibile con GRADE_MAP.
// '7A' → '7a', '6B+' → '6b+', '6c / 6c+' → '6c/6c+', '7 a' → '7a'.
export function normalizeGrade(input: string): string {
  return input.trim().toLowerCase().replace(/\s+/g, '')
}

// Mappa label UI/stringhe libere → chiave tecnica Capital.
// Dal 3° giro in poi tutto è redpoint (stesso punteggio). Default: redpoint.
export function normalizeAttemptType(input: string): CapitalAttemptType {
  const value = input.trim().toLowerCase()

  const map: Record<string, CapitalAttemptType> = {
    onsight: 'onsight',
    'on-sight': 'onsight',
    'on sight': 'onsight',
    'a vista': 'onsight',
    flash: 'flash',
    '2° giro': 'second_go',
    '2 giro': 'second_go',
    'second go': 'second_go',
    'second_go': 'second_go',
    'secondo giro': 'second_go',
    '2nd go': 'second_go',
    '2nd': 'second_go',
    second: 'second_go',
    '3° giro': 'redpoint',
    '3 giro': 'redpoint',
    'third go': 'redpoint',
    '3rd go': 'redpoint',
    '3rd': 'redpoint',
    third: 'redpoint',
    '4° giro': 'redpoint',
    '4 giro': 'redpoint',
    '4+': 'redpoint',
    '4th+': 'redpoint',
    four_plus: 'redpoint',
    redpoint: 'redpoint',
    rp: 'redpoint',
    'n.d.': 'redpoint',
    nd: 'redpoint',
  }

  return map[value] ?? 'redpoint'
}

// Calcolo Capital Score. Ritorna null se il grado non è riconosciuto.
export function calculateCapitalScore(params: {
  grade: string
  attemptType: string
  drawsMode?: DrawsMode
}): number | null {
  const grade = normalizeGrade(params.grade)
  const gradeNumeric = GRADE_MAP[grade]

  if (gradeNumeric === undefined) {
    return null
  }

  const attemptType = normalizeAttemptType(params.attemptType)

  let score = BASE_SCORE + GRADE_STEP * gradeNumeric + STYLE_BONUS[attemptType]

  if (MOUNT_BONUS_ACTIVE && params.drawsMode === 'placed_by_user') {
    score += MOUNT_BONUS[attemptType]
  }

  return Math.round(score)
}

// ── Adapter dal modello salita dell'app ────────────────────────────────────
// L'app salva ascent_style (onsight/flash/redpoint/repeat/unknown) +
// attempt_count + legacy attempt_type. Da questi deriviamo l'attempt type
// Capital (che distingue il 2° giro dal redpoint 3°+).
export function capitalAttemptTypeFromAscent(input: {
  ascent_style?: string | null
  attempt_count?: number | null
  attempt_type?: string | null // legacy
}): CapitalAttemptType {
  const style = (input.ascent_style ?? '').toLowerCase()

  if (style === 'onsight') return 'onsight'
  if (style === 'flash') return 'flash'

  // redpoint/repeat/unknown: il 2° giro vale di più del redpoint 3°+.
  if (input.attempt_count === 2) return 'second_go'
  if (typeof input.attempt_count === 'number' && input.attempt_count >= 3) {
    return 'redpoint'
  }

  // Nessun conteggio: ricadi sul legacy attempt_type.
  if (input.attempt_type) return normalizeAttemptType(input.attempt_type)

  return 'redpoint'
}

// Calcolo Capital Score direttamente da una salita dell'app.
export function capitalScoreFromAscent(input: {
  grade?: string | null
  ascent_style?: string | null
  attempt_count?: number | null
  attempt_type?: string | null
  draws_mode?: DrawsMode | null
}): number | null {
  if (!input.grade) return null
  const attemptType = capitalAttemptTypeFromAscent(input)
  // Il bonus montaggio dipende dal draws_mode reale della salita.
  // Import → 'placed_by_user' (montato); inserimento manuale → scelta utente.
  return calculateCapitalScore({
    grade: input.grade,
    attemptType,
    drawsMode: input.draws_mode ?? undefined,
  })
}

// ── Livelli utente (basati sul Lifetime Score) ─────────────────────────────
export interface ClimberLevel {
  key: string
  label: string
  minScore: number
}

export const PUBLIC_LEVELS: ClimberLevel[] = [
  { key: 'prime_vie', label: 'Prime vie', minScore: 5_000 },
  { key: 'climber_attivo', label: 'Climber attivo', minScore: 10_000 },
  { key: 'falesista', label: 'Falesista', minScore: 25_000 },
  { key: 'local_climber', label: 'Local climber', minScore: 50_000 },
  { key: 'strong_climber', label: 'Strong climber', minScore: 100_000 },
  { key: 'expert', label: 'Expert', minScore: 250_000 },
  { key: 'master', label: 'Master', minScore: 500_000 },
]

// Elite nascosto finché lifetime_score < 1.000.000.
export const HIDDEN_LEVELS: ClimberLevel[] = [
  { key: 'elite', label: 'Elite', minScore: 1_000_000 },
]

export const ELITE_THRESHOLD = 1_000_000

export interface LevelInfo {
  level: ClimberLevel | null // livello attuale raggiunto (null se sotto la prima soglia)
  nextLevel: ClimberLevel | null // prossimo livello visibile (Elite escluso se non sbloccato)
  pointsToNext: number | null
  progress: number // 0..1 verso il prossimo livello visibile
  eliteUnlocked: boolean
}

// Determina livello attuale + prossimo a partire dal lifetime score.
// Elite non compare mai come next_level finché score < ELITE_THRESHOLD.
export function getLevelInfo(lifetimeScore: number): LevelInfo {
  const eliteUnlocked = lifetimeScore >= ELITE_THRESHOLD

  const allLevels = eliteUnlocked
    ? [...PUBLIC_LEVELS, ...HIDDEN_LEVELS]
    : PUBLIC_LEVELS

  let level: ClimberLevel | null = null
  for (const l of allLevels) {
    if (lifetimeScore >= l.minScore) level = l
    else break
  }

  const nextLevel = allLevels.find((l) => l.minScore > lifetimeScore) ?? null

  const floor = level?.minScore ?? 0
  const pointsToNext = nextLevel ? nextLevel.minScore - lifetimeScore : null
  const span = nextLevel ? nextLevel.minScore - floor : 0
  const progress = nextLevel && span > 0 ? (lifetimeScore - floor) / span : 1

  return { level, nextLevel, pointsToNext, progress, eliteUnlocked }
}
