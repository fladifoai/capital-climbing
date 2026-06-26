import { numToGrade } from '../normalizers/grades'
import type {
  AnalyticsFilters, KpiData, DataQualityStats,
  GradeProgressionPoint, GradePyramidEntry, MonthlyActivity, CragStat,
} from '../types'
import type { AscentWithRoute } from '../../features/logbook/hooks'
import { normalizeAscentStyle, ASCENT_STYLE_ORDER, type AscentStyle } from '../calculations/ascent-style'
import { getAttemptBucket, ATTEMPT_BUCKET_ORDER, type AttemptBucket } from '../calculations/attempt-buckets'

const MONTHS_IT = ['Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu', 'Lug', 'Ago', 'Set', 'Ott', 'Nov', 'Dic']

type AscentExt = AscentWithRoute & {
  ascent_style?: string | null
  attempt_count?: number | null
  attempt_bucket?: string | null
  legacy_attempt_type?: string | null
  needs_review?: boolean
}

function getStyle(a: AscentExt): AscentStyle {
  return normalizeAscentStyle((a as AscentExt).ascent_style ?? a.attempt_type)
}

function getBucket(a: AscentExt): AttemptBucket {
  if (a.attempt_count != null) return getAttemptBucket(a.attempt_count)
  if (a.attempt_bucket) return a.attempt_bucket as AttemptBucket
  if (a.legacy_attempt_type === 'four_plus') return 'unknown'
  if (a.attempt_type === 'onsight' || a.attempt_type === 'flash') return '1'
  if (a.attempt_type === 'second') return '2'
  if (a.attempt_type === 'third') return '3'
  return 'unknown'
}

export function filterAscents(
  ascents: AscentWithRoute[],
  filters: AnalyticsFilters
): AscentWithRoute[] {
  return (ascents as AscentExt[])
    .filter(a => a.status === 'completed')
    .filter(a => filters.yearFilter === 'all' || a.date.startsWith(String(filters.yearFilter)))
    .filter(a => {
      if (filters.ascentStyles === 'all') return true
      return filters.ascentStyles.includes(getStyle(a))
    })
    .filter(a => {
      if (filters.attemptBuckets === 'all') return true
      return filters.attemptBuckets.includes(getBucket(a))
    })
    .filter(a => filters.gradeMin === null || (a.grade_numeric_at_ascent ?? 0) >= filters.gradeMin)
    .filter(a => filters.gradeMax === null || (a.grade_numeric_at_ascent ?? 0) <= filters.gradeMax)
}

function maxGradeLabel(ascents: AscentExt[], style: AscentStyle): string {
  const grades = ascents
    .filter(a => getStyle(a) === style)
    .map(a => a.grade_numeric_at_ascent ?? 0)
    .filter(n => n > 0)
  if (!grades.length) return '—'
  const mx = Math.max(...grades)
  return ascents.find(a => getStyle(a) === style && (a.grade_numeric_at_ascent ?? 0) === mx)
    ?.grade_at_ascent ?? numToGrade(mx)
}

function median(nums: number[]): number {
  if (!nums.length) return 0
  const sorted = [...nums].sort((a, b) => a - b)
  const mid = Math.floor(sorted.length / 2)
  return sorted.length % 2 !== 0 ? sorted[mid] : Math.round((sorted[mid - 1] + sorted[mid]) / 2)
}

export function computeKpis(
  ascents: AscentWithRoute[],
  projects: Array<{ id: string; status: string }>,
  sessions: Array<{ id: string; date: string }>,
  filters: AnalyticsFilters
): KpiData {
  const filtered = filterAscents(ascents, filters) as AscentExt[]
  const total = filtered.length

  const grades = filtered.map(a => a.grade_numeric_at_ascent ?? 0).filter(n => n > 0)
  const avgGrade = grades.length ? Math.round(grades.reduce((s, n) => s + n, 0) / grades.length) : null
  const medGrade = grades.length ? median(grades) : null

  const osFl = filtered.filter(a => getStyle(a) === 'onsight' || getStyle(a) === 'flash').length
  const osCount = filtered.filter(a => getStyle(a) === 'onsight').length
  const flCount = filtered.filter(a => getStyle(a) === 'flash').length
  const rpCount = filtered.filter(a => getStyle(a) === 'redpoint').length

  const uniqueRoutes = new Set(filtered.map(a => a.route_id)).size
  const uniqueCrags = new Set(filtered.map(a => a.route?.sector?.crag?.id).filter(Boolean)).size
  const activeDays = new Set(filtered.map(a => a.date)).size

  const within = (n: number) =>
    filtered.filter(a => {
      const count = a.attempt_count
      if (count != null) return count <= n
      const bucket = getBucket(a)
      if (bucket === 'unknown') return false
      const bucketNum = parseInt(bucket.split('_')[0])
      return !isNaN(bucketNum) && bucketNum <= n
    }).length

  const filteredSessions = filters.yearFilter === 'all'
    ? sessions
    : sessions.filter(s => s.date.startsWith(String(filters.yearFilter)))

  return {
    totalAscents: total,
    totalSessions: filteredSessions.length,
    totalCrags: uniqueCrags,
    uniqueRoutes,
    activeDays,
    bestOnsightLabel: maxGradeLabel(filtered, 'onsight'),
    bestFlashLabel: maxGradeLabel(filtered, 'flash'),
    bestRedpointLabel: maxGradeLabel(filtered, 'redpoint'),
    avgGradeLabel: avgGrade != null ? (filtered.find(a => (a.grade_numeric_at_ascent ?? 0) === avgGrade)?.grade_at_ascent ?? numToGrade(avgGrade)) : '—',
    medianGradeLabel: medGrade != null ? numToGrade(medGrade) : '—',
    osFlashPct: total > 0 ? Math.round((osFl / total) * 100) : 0,
    osPct: total > 0 ? Math.round((osCount / total) * 100) : 0,
    flashPct: total > 0 ? Math.round((flCount / total) * 100) : 0,
    rpPct: total > 0 ? Math.round((rpCount / total) * 100) : 0,
    within3: within(3),
    within5: within(5),
    within10: within(10),
    activeProjects: projects.filter(p => p.status === 'active').length,
  }
}

export function computeDataQuality(ascents: AscentWithRoute[]): DataQualityStats {
  const ext = ascents as AscentExt[]
  const total = ext.length
  return {
    total,
    withAscentStyle: ext.filter(a => a.ascent_style != null || a.attempt_type != null).length,
    withAttemptCount: ext.filter(a => a.attempt_count != null).length,
    withGrade: ext.filter(a => (a.grade_at_ascent ?? a.route?.official_grade) != null).length,
    needsReview: ext.filter(a => a.needs_review === true).length,
    fourPlusLegacy: ext.filter(a => a.legacy_attempt_type === 'four_plus').length,
    missingAttemptInfo: ext.filter(a => {
      const hasInfo = a.attempt_count != null || a.attempt_bucket != null
      const isLegacyKnown = a.attempt_type != null && a.attempt_type !== 'four_plus'
      return !hasInfo && !isLegacyKnown
    }).length,
  }
}

export function computeGradeProgression(ascents: AscentWithRoute[]): GradeProgressionPoint[] {
  return (ascents as AscentExt[])
    .filter(a => a.grade_numeric_at_ascent && a.grade_numeric_at_ascent > 0)
    .map(a => ({
      date: a.date,
      dateTs: new Date(a.date).getTime(),
      gradeValue: a.grade_numeric_at_ascent ?? 0,
      gradeLabel: a.grade_at_ascent ?? numToGrade(a.grade_numeric_at_ascent ?? 0),
      routeName: a.route?.name ?? '—',
      cragName: a.route?.sector?.crag?.name ?? '—',
      sectorName: a.route?.sector?.name ?? '—',
      attemptType: (a as AscentExt).ascent_style ?? a.attempt_type,
    }))
    .sort((a, b) => a.dateTs - b.dateTs)
}

export function computeGradePyramid(ascents: AscentWithRoute[]): GradePyramidEntry[] {
  const map = new Map<string, GradePyramidEntry>()
  ;(ascents as AscentExt[]).forEach(a => {
    const grade = a.grade_at_ascent ?? a.route?.official_grade ?? null
    if (!grade) return
    const entry = map.get(grade) ?? {
      grade, numeric: a.grade_numeric_at_ascent ?? 0,
      onsight: 0, flash: 0, redpoint: 0, repeat: 0, unknown: 0, total: 0,
    }
    map.set(grade, entry)
    entry.total++
    const style = getStyle(a)
    entry[style]++
  })
  return Array.from(map.values()).sort((a, b) => b.numeric - a.numeric)
}

export interface GradeProgressionLine {
  label: string
  best: number
  avg: number
  bestLabel: string
  avgLabel: string
}

export function computeGradeProgressionLine(
  ascents: AscentWithRoute[],
  yearFilter: number | 'all'
): GradeProgressionLine[] {
  const map = new Map<string, { best: number; total: number; count: number }>()
  ascents.forEach(a => {
    const key = yearFilter === 'all' ? a.date.slice(0, 4) : a.date.slice(0, 7)
    const n = a.grade_numeric_at_ascent ?? 0
    if (!n) return
    const entry = map.get(key)
    if (entry) {
      if (n > entry.best) entry.best = n
      entry.total += n
      entry.count++
    } else {
      map.set(key, { best: n, total: n, count: 1 })
    }
  })
  return Array.from(map.entries())
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([key, { best, total, count }]) => {
      const [, m] = key.split('-')
      const monthIdx = m ? parseInt(m) - 1 : -1
      const label = yearFilter === 'all' ? key : (MONTHS_IT[monthIdx] ?? key)
      const avgN = Math.round(total / count)
      return { label, best, avg: Math.round((total / count) * 10) / 10, bestLabel: numToGrade(best), avgLabel: numToGrade(avgN) }
    })
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

export function computeAvailableYears(ascents: AscentWithRoute[]): number[] {
  const years = new Set<number>()
  ascents.forEach(a => {
    const y = parseInt(a.date.slice(0, 4))
    if (!isNaN(y)) years.add(y)
  })
  return Array.from(years).sort((a, b) => b - a)
}

// ── Attempt mode / bucket breakdowns ──────────────────────────────────────────

export interface AscentModeEntry {
  style: AscentStyle
  label: string
  count: number
}

export function computeAscentModeBreakdown(ascents: AscentWithRoute[]): AscentModeEntry[] {
  const map = new Map<AscentStyle, number>()
  ASCENT_STYLE_ORDER.forEach(s => map.set(s, 0))
  ;(ascents as AscentExt[]).forEach(a => {
    const style = getStyle(a)
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

export function computeAttemptBucketBreakdown(ascents: AscentWithRoute[]): AttemptBucketEntry[] {
  const map = new Map<AttemptBucket, AttemptBucketEntry>()
  ;(ascents as AscentExt[]).forEach(a => {
    const bucket = getBucket(a)
    const entry = map.get(bucket) ?? { bucket, label: bucket, count: 0, onsight: 0, flash: 0 }
    entry.count++
    const style = getStyle(a)
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
  ;(ascents as AscentExt[]).forEach(a => {
    const bucket = getBucket(a)
    const entry = map.get(bucket) ?? { bucket, label: bucket, onsight: 0, flash: 0, redpoint: 0, repeat: 0, unknown: 0 }
    const style = getStyle(a)
    entry[style]++
    map.set(bucket, entry)
  })
  return ATTEMPT_BUCKET_ORDER
    .map(b => map.get(b))
    .filter((e): e is ModeByAttemptEntry => e != null)
}
