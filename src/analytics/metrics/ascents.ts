import { numToGrade } from '../normalizers/grades'
import type { AnalyticsFilters, KpiData, GradeProgressionPoint, GradePyramidEntry, MonthlyActivity, CragStat } from '../types'
import type { AscentWithRoute } from '../../features/logbook/hooks'
import { normalizeAscentStyle, ASCENT_STYLE_ORDER, type AscentStyle } from '../calculations/ascent-style'
import { getAttemptBucket, ATTEMPT_BUCKET_ORDER, type AttemptBucket } from '../calculations/attempt-buckets'

const MONTHS_IT = ['Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu', 'Lug', 'Ago', 'Set', 'Ott', 'Nov', 'Dic']

export function filterAscents(
  ascents: AscentWithRoute[],
  filters: Pick<AnalyticsFilters, 'yearFilter' | 'attemptTypes' | 'gradeMin' | 'gradeMax'>
): AscentWithRoute[] {
  return ascents
    .filter(a => a.status === 'completed')
    .filter(a => filters.yearFilter === 'all' || a.date.startsWith(String(filters.yearFilter)))
    .filter(a => filters.attemptTypes === 'all' || filters.attemptTypes.includes(a.attempt_type as never))
    .filter(a => filters.gradeMin === null || (a.grade_numeric_at_ascent ?? 0) >= filters.gradeMin)
    .filter(a => filters.gradeMax === null || (a.grade_numeric_at_ascent ?? 0) <= filters.gradeMax)
}

function maxGradeLabel(ascents: AscentWithRoute[], type: string): string {
  const grades = ascents
    .filter(a => a.attempt_type === type)
    .map(a => a.grade_numeric_at_ascent ?? 0)
    .filter(n => n > 0)
  if (!grades.length) return '—'
  const mx = Math.max(...grades)
  return ascents.find(a => a.attempt_type === type && (a.grade_numeric_at_ascent ?? 0) === mx)
    ?.grade_at_ascent ?? numToGrade(mx)
}

export function computeKpis(
  ascents: AscentWithRoute[],
  projects: Array<{ id: string; status: string }>,
  sessions: Array<{ id: string; date: string }>,
  filters: AnalyticsFilters
): KpiData {
  const filtered = filterAscents(ascents, filters)
  const total = filtered.length
  const osFl = filtered.filter(a => a.attempt_type === 'onsight' || a.attempt_type === 'flash').length
  const uniqueCrags = new Set(filtered.map(a => a.route?.sector?.crag?.id).filter(Boolean))
  const filteredSessions = filters.yearFilter === 'all'
    ? sessions
    : sessions.filter(s => s.date.startsWith(String(filters.yearFilter)))

  return {
    totalAscents: total,
    totalSessions: filteredSessions.length,
    totalCrags: uniqueCrags.size,
    bestOnsightLabel: maxGradeLabel(filtered, 'onsight'),
    bestFlashLabel: maxGradeLabel(filtered, 'flash'),
    bestRedpointLabel: maxGradeLabel(filtered, 'redpoint'),
    osFlashPct: total > 0 ? Math.round((osFl / total) * 100) : 0,
    activeProjects: projects.filter(p => p.status === 'active').length,
  }
}

export function computeGradeProgression(ascents: AscentWithRoute[]): GradeProgressionPoint[] {
  return ascents
    .filter(a => a.grade_numeric_at_ascent && a.grade_numeric_at_ascent > 0)
    .map(a => ({
      date: a.date,
      dateTs: new Date(a.date).getTime(),
      gradeValue: a.grade_numeric_at_ascent ?? 0,
      gradeLabel: a.grade_at_ascent ?? numToGrade(a.grade_numeric_at_ascent ?? 0),
      routeName: a.route?.name ?? '—',
      cragName: a.route?.sector?.crag?.name ?? '—',
      sectorName: a.route?.sector?.name ?? '—',
      attemptType: a.attempt_type,
    }))
    .sort((a, b) => a.dateTs - b.dateTs)
}

export function computeGradePyramid(ascents: AscentWithRoute[]): GradePyramidEntry[] {
  const map = new Map<string, GradePyramidEntry>()
  ascents.forEach(a => {
    const grade = a.grade_at_ascent ?? a.route?.official_grade ?? null
    if (!grade) return
    const entry = map.get(grade) ?? {
      grade, numeric: a.grade_numeric_at_ascent ?? 0,
      onsight: 0, flash: 0, second: 0, third: 0, four_plus: 0, redpoint: 0, other: 0, total: 0,
    }
    map.set(grade, entry)
    entry.total++
    const t = a.attempt_type
    if (t === 'onsight') entry.onsight++
    else if (t === 'flash') entry.flash++
    else if (t === 'second') entry.second++
    else if (t === 'third') entry.third++
    else if (t === 'four_plus') entry.four_plus++
    else if (t === 'redpoint') entry.redpoint++
    else entry.other++
  })
  // Descending order: highest grade at top (pyramid shape)
  return Array.from(map.values()).sort((a, b) => b.numeric - a.numeric)
}

export function computeMonthlyActivity(
  ascents: AscentWithRoute[],
  yearFilter: number | 'all'
): MonthlyActivity[] {
  const map = new Map<string, number>()
  if (yearFilter !== 'all') {
    for (let m = 0; m < 12; m++) {
      map.set(`${yearFilter}-${String(m + 1).padStart(2, '0')}`, 0)
    }
  }
  ascents.forEach(a => {
    const key = a.date.slice(0, 7)
    map.set(key, (map.get(key) ?? 0) + 1)
  })
  return Array.from(map.entries())
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([key, count]) => {
      const [y, m] = key.split('-')
      const monthIdx = parseInt(m) - 1
      return {
        label: yearFilter === 'all' ? key : (MONTHS_IT[monthIdx] ?? key),
        count,
        year: y,
      }
    })
}

export function computeTopCrags(ascents: AscentWithRoute[], limit = 10): CragStat[] {
  const map = new Map<string, CragStat>()
  ascents.forEach(a => {
    const id = a.route?.sector?.crag?.id
    const name = a.route?.sector?.crag?.name
    if (!id || !name) return
    const existing = map.get(id)
    if (existing) existing.count++
    else map.set(id, { id, name, count: 1 })
  })
  return Array.from(map.values()).sort((a, b) => b.count - a.count).slice(0, limit)
}

export interface AscentModeEntry {
  style: AscentStyle
  label: string
  count: number
}

// Groups ascents by normalized style (second/third/four_plus → redpoint)
export function computeAscentModeBreakdown(ascents: AscentWithRoute[]): AscentModeEntry[] {
  const map = new Map<AscentStyle, number>()
  ASCENT_STYLE_ORDER.forEach(s => map.set(s, 0))
  ascents.forEach(a => {
    // Priority: ascent_style (new field) → attempt_type (legacy)
    const raw = (a as unknown as { ascent_style?: string | null }).ascent_style ?? a.attempt_type
    const style = normalizeAscentStyle(raw)
    map.set(style, (map.get(style) ?? 0) + 1)
  })
  return ASCENT_STYLE_ORDER
    .map(style => ({ style, label: style, count: map.get(style) ?? 0 }))
    .filter(e => e.count > 0)
}

export interface AttemptBucketEntry {
  bucket: AttemptBucket
  label: string
  count: number
  onsight: number
  flash: number
}

function resolveDisplayBucket(a: AscentWithRoute): AttemptBucket {
  const ext = a as unknown as {
    attempt_count?: number | null
    attempt_bucket?: string | null
    legacy_attempt_type?: string | null
  }
  // Priority: attempt_count → attempt_bucket → legacy_attempt_type
  if (ext.attempt_count != null) return getAttemptBucket(ext.attempt_count)
  if (ext.attempt_bucket) return ext.attempt_bucket as AttemptBucket
  if (ext.legacy_attempt_type === 'four_plus') return 'unknown'
  // Fallback to attempt_type for records not yet migrated
  if (a.attempt_type === 'onsight' || a.attempt_type === 'flash') return '1'
  if (a.attempt_type === 'second') return '2'
  if (a.attempt_type === 'third') return '3'
  return 'unknown'
}

export function computeAttemptBucketBreakdown(ascents: AscentWithRoute[]): AttemptBucketEntry[] {
  const map = new Map<AttemptBucket, AttemptBucketEntry>()
  ascents.forEach(a => {
    const bucket = resolveDisplayBucket(a)
    const entry = map.get(bucket) ?? { bucket, label: bucket, count: 0, onsight: 0, flash: 0 }
    entry.count++
    const style = normalizeAscentStyle(
      (a as unknown as { ascent_style?: string | null }).ascent_style ?? a.attempt_type
    )
    if (style === 'onsight') entry.onsight++
    if (style === 'flash') entry.flash++
    map.set(bucket, entry)
  })
  return ATTEMPT_BUCKET_ORDER
    .map(b => map.get(b))
    .filter((e): e is AttemptBucketEntry => e != null && e.count > 0)
}

export interface ModeByAttemptEntry {
  bucket: string
  label: string
  onsight: number
  flash: number
  redpoint: number
  repeat: number
  unknown: number
}

export function computeModeByAttempt(ascents: AscentWithRoute[]): ModeByAttemptEntry[] {
  const map = new Map<AttemptBucket, ModeByAttemptEntry>()
  ascents.forEach(a => {
    const bucket = resolveDisplayBucket(a)
    const entry = map.get(bucket) ?? { bucket, label: bucket, onsight: 0, flash: 0, redpoint: 0, repeat: 0, unknown: 0 }
    const style = normalizeAscentStyle(
      (a as unknown as { ascent_style?: string | null }).ascent_style ?? a.attempt_type
    )
    entry[style]++
    map.set(bucket, entry)
  })
  return ATTEMPT_BUCKET_ORDER
    .map(b => map.get(b))
    .filter((e): e is ModeByAttemptEntry => e != null)
}

export function computeAvailableYears(ascents: AscentWithRoute[]): number[] {
  const years = new Set<number>()
  ascents.forEach(a => {
    const y = parseInt(a.date.slice(0, 4))
    if (!isNaN(y)) years.add(y)
  })
  return Array.from(years).sort((a, b) => b - a)
}
