// Aggregazioni Capital Score calcolate lato client da useMyAscents.
// Architettura coerente con src/analytics (nessun backend REST, query Supabase
// + calcolo client). Conta solo salite con score valido (ripetizioni e progetti
// hanno score null → automaticamente esclusi).
import type { AscentWithRoute } from '../logbook/hooks'
import {
  capitalAttemptTypeFromAscent,
  getLevelInfo,
  GRADE_MAP,
  normalizeGrade,
  type CapitalAttemptType,
  type LevelInfo,
} from '../../lib/scoring'

const MONTH_LABELS = [
  'Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu',
  'Lug', 'Ago', 'Set', 'Ott', 'Nov', 'Dic',
]

export const ATTEMPT_ORDER: CapitalAttemptType[] = [
  'onsight', 'flash', 'second_go', 'redpoint',
]

export const ATTEMPT_LABEL: Record<CapitalAttemptType, string> = {
  onsight: 'On-sight',
  flash: 'Flash',
  second_go: '2° giro',
  redpoint: 'Redpoint',
}

export const ATTEMPT_COLOR: Record<CapitalAttemptType, string> = {
  onsight: '#28B487',
  flash: '#4C9BE8',
  second_go: '#D9902F',
  redpoint: '#9AA0A6',
}

// Salita con punteggio valido, normalizzata per i calcoli.
export interface ScoredAscent {
  date: string
  year: number
  month: number // 1..12
  score: number
  attemptType: CapitalAttemptType
  routeName: string
  cragName: string
  grade: string
}

function toScored(ascents: AscentWithRoute[]): ScoredAscent[] {
  const out: ScoredAscent[] = []
  for (const a of ascents) {
    if (a.score == null || a.is_repeat || a.status !== 'completed') continue
    const d = new Date(a.date)
    if (Number.isNaN(d.getTime())) continue
    out.push({
      date: a.date,
      year: d.getFullYear(),
      month: d.getMonth() + 1,
      score: a.score,
      attemptType: capitalAttemptTypeFromAscent(a),
      routeName: a.route?.name ?? a.route_name_snapshot ?? '—',
      cragName: a.route?.sector?.crag?.name ?? a.crag_name_snapshot ?? '',
      grade: a.grade_at_ascent ?? a.route?.official_grade ?? '',
    })
  }
  return out
}

export interface BestRoute {
  route_name: string
  crag_name: string
  grade: string
  attempt_type: CapitalAttemptType
  capital_score: number
  date: string
}

function bestRoute(rows: ScoredAscent[]): BestRoute | null {
  if (rows.length === 0) return null
  const b = rows.reduce((m, r) => (r.score > m.score ? r : m))
  return {
    route_name: b.routeName,
    crag_name: b.cragName,
    grade: b.grade,
    attempt_type: b.attemptType,
    capital_score: b.score,
    date: b.date,
  }
}

// Formattazione numeri stile italiano: 85950 → "85.950".
export const fmtScore = (n: number | null | undefined): string =>
  n == null ? '—' : Math.round(n).toLocaleString('it-IT')

const sum = (rows: ScoredAscent[]) => rows.reduce((s, r) => s + r.score, 0)
const avg = (rows: ScoredAscent[]) =>
  rows.length ? Math.round(sum(rows) / rows.length) : 0

// ── Overview ───────────────────────────────────────────────────────────────
export interface ScoreOverview {
  lifetime_score: number
  season_score: number
  last_12_months_score: number
  avg_score_per_route: number
  route_count: number
  best_route: BestRoute | null
  level: LevelInfo
  season_year: number
}

export function computeOverview(
  ascents: AscentWithRoute[],
  now: Date = new Date(),
): ScoreOverview {
  const rows = toScored(ascents)
  const year = now.getFullYear()
  const cutoff = new Date(now)
  cutoff.setFullYear(cutoff.getFullYear() - 1)
  const cutoffStr = cutoff.toISOString().slice(0, 10)

  const lifetime = sum(rows)
  return {
    lifetime_score: lifetime,
    season_score: sum(rows.filter((r) => r.year === year)),
    last_12_months_score: sum(rows.filter((r) => r.date >= cutoffStr)),
    avg_score_per_route: avg(rows),
    route_count: rows.length,
    best_route: bestRoute(rows),
    level: getLevelInfo(lifetime),
    season_year: year,
  }
}

// ── Cumulativo nel tempo ─────────────────────────────────────────────────────
export interface CumulativePoint {
  date: string
  route_name: string
  capital_score: number
  cumulative_score: number
}

export function computeCumulative(ascents: AscentWithRoute[]): CumulativePoint[] {
  const rows = toScored(ascents).sort((a, b) => a.date.localeCompare(b.date))
  let acc = 0
  return rows.map((r) => {
    acc += r.score
    return {
      date: r.date,
      route_name: r.routeName,
      capital_score: r.score,
      cumulative_score: acc,
    }
  })
}

// ── Per anno ─────────────────────────────────────────────────────────────────
export interface YearScore {
  year: number
  route_count: number
  season_score: number
  avg_score_per_route: number
}

export function computeByYear(ascents: AscentWithRoute[]): YearScore[] {
  const byYear = new Map<number, ScoredAscent[]>()
  for (const r of toScored(ascents)) {
    const arr = byYear.get(r.year) ?? []
    arr.push(r)
    byYear.set(r.year, arr)
  }
  return [...byYear.entries()]
    .sort((a, b) => a[0] - b[0])
    .map(([year, arr]) => ({
      year,
      route_count: arr.length,
      season_score: sum(arr),
      avg_score_per_route: avg(arr),
    }))
}

// ── Per mese (anno dato) ─────────────────────────────────────────────────────
export interface MonthScore {
  month: number
  month_label: string
  route_count: number
  monthly_score: number
  avg_score_per_route: number
}

export function computeByMonth(
  ascents: AscentWithRoute[],
  year: number,
): MonthScore[] {
  const byMonth = new Map<number, ScoredAscent[]>()
  for (const r of toScored(ascents)) {
    if (r.year !== year) continue
    const arr = byMonth.get(r.month) ?? []
    arr.push(r)
    byMonth.set(r.month, arr)
  }
  return [...byMonth.entries()]
    .sort((a, b) => a[0] - b[0])
    .map(([month, arr]) => ({
      month,
      month_label: MONTH_LABELS[month - 1],
      route_count: arr.length,
      monthly_score: sum(arr),
      avg_score_per_route: avg(arr),
    }))
}

// ── Last 12 months ───────────────────────────────────────────────────────────
export interface Last12Months {
  last_12_months_score: number
  route_count: number
  avg_score_per_route: number
  best_route: BestRoute | null
}

export function computeLast12Months(
  ascents: AscentWithRoute[],
  now: Date = new Date(),
): Last12Months {
  const cutoff = new Date(now)
  cutoff.setFullYear(cutoff.getFullYear() - 1)
  const cutoffStr = cutoff.toISOString().slice(0, 10)
  const rows = toScored(ascents).filter((r) => r.date >= cutoffStr)
  return {
    last_12_months_score: sum(rows),
    route_count: rows.length,
    avg_score_per_route: avg(rows),
    best_route: bestRoute(rows),
  }
}

// ── Per stile ────────────────────────────────────────────────────────────────
export interface StyleScore {
  attempt_type: CapitalAttemptType
  route_count: number
  total_score: number
  avg_score: number
}

export function computeByStyle(ascents: AscentWithRoute[]): StyleScore[] {
  const rows = toScored(ascents)
  return ATTEMPT_ORDER.map((t) => {
    const arr = rows.filter((r) => r.attemptType === t)
    return {
      attempt_type: t,
      route_count: arr.length,
      total_score: sum(arr),
      avg_score: avg(arr),
    }
  }).filter((s) => s.route_count > 0)
}

// ── Per grado e stile (piramide punti) ──────────────────────────────────────
export interface GradeStyleScore {
  grade: string
  grade_numeric: number
  onsight_score: number
  flash_score: number
  second_go_score: number
  redpoint_score: number
  total_score: number
}

export function computeByGradeStyle(ascents: AscentWithRoute[]): GradeStyleScore[] {
  const byGrade = new Map<string, ScoredAscent[]>()
  for (const r of toScored(ascents)) {
    const key = normalizeGrade(r.grade)
    if (GRADE_MAP[key] === undefined) continue
    const arr = byGrade.get(key) ?? []
    arr.push(r)
    byGrade.set(key, arr)
  }
  return [...byGrade.entries()]
    .sort((a, b) => GRADE_MAP[a[0]] - GRADE_MAP[b[0]])
    .map(([grade, arr]) => {
      const byType = (t: CapitalAttemptType) =>
        sum(arr.filter((r) => r.attemptType === t))
      return {
        grade,
        grade_numeric: GRADE_MAP[grade],
        onsight_score: byType('onsight'),
        flash_score: byType('flash'),
        second_go_score: byType('second_go'),
        redpoint_score: byType('redpoint'),
        total_score: sum(arr),
      }
    })
}

// ── Top vie per punti ────────────────────────────────────────────────────────
export interface TopRoute extends BestRoute {
  rank: number
}

export function computeTopRoutes(
  ascents: AscentWithRoute[],
  limit = 10,
): TopRoute[] {
  return toScored(ascents)
    .sort((a, b) => b.score - a.score)
    .slice(0, limit)
    .map((r, i) => ({
      rank: i + 1,
      route_name: r.routeName,
      crag_name: r.cragName,
      grade: r.grade,
      attempt_type: r.attemptType,
      capital_score: r.score,
      date: r.date,
    }))
}

export function computeAvailableScoreYears(ascents: AscentWithRoute[]): number[] {
  return [...new Set(toScored(ascents).map((r) => r.year))].sort((a, b) => b - a)
}

// ── Rolling last-12-months per ogni mese (forma recente) ────────────────────
export interface RollingPoint {
  key: string // 'YYYY-MM'
  label: string // 'Mag 24'
  rolling_score: number
}

export function computeRolling12(ascents: AscentWithRoute[]): RollingPoint[] {
  const rows = toScored(ascents)
  if (rows.length === 0) return []

  // Totale punti per mese 'YYYY-MM'.
  const monthly = new Map<string, number>()
  for (const r of rows) {
    const key = `${r.year}-${String(r.month).padStart(2, '0')}`
    monthly.set(key, (monthly.get(key) ?? 0) + r.score)
  }

  const sorted = [...rows].sort((a, b) => a.date.localeCompare(b.date))
  const first = sorted[0]
  const last = sorted[sorted.length - 1]

  const out: RollingPoint[] = []
  let y = first.year
  let m = first.month
  while (y < last.year || (y === last.year && m <= last.month)) {
    let acc = 0
    // somma i 12 mesi che finiscono a (y, m)
    let yy = y
    let mm = m
    for (let i = 0; i < 12; i++) {
      const key = `${yy}-${String(mm).padStart(2, '0')}`
      acc += monthly.get(key) ?? 0
      mm--
      if (mm === 0) { mm = 12; yy-- }
    }
    out.push({
      key: `${y}-${String(m).padStart(2, '0')}`,
      label: `${MONTH_LABELS[m - 1]} ${String(y).slice(2)}`,
      rolling_score: acc,
    })
    m++
    if (m === 13) { m = 1; y++ }
  }
  return out
}
