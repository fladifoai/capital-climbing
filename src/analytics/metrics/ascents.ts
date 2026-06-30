import { numToGrade } from '../normalizers/grades'
import type {
  AnalyticsFilters, KpiData, DataQualityStats,
  GradeProgressionPoint, GradePyramidEntry, MonthlyActivity, CragStat,
  MaxByStylePeriodEntry, CumulativeMaxPoint, UniqueVsRepeatEntry, DayOfWeekEntry, GradeDistEntry, CragStatExtended,
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
  // is_repeat è autoritativo: una ripetizione conta sempre come 'repeat',
  // anche se importata con ascent_style reale (es. redpoint).
  if (a.is_repeat) return 'repeat'
  return normalizeAscentStyle((a as AscentExt).ascent_style ?? a.attempt_type)
}

// Una ripetizione non genera punteggio e non incide sui KPI di performance.
function isRepeat(a: AscentExt): boolean {
  return getStyle(a) === 'repeat'
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

  // Performance: solo salite valide (le ripetizioni NON contano per grado
  // max, miglior salita, % OS/Flash, grado medio, tentativi-per-chiusura).
  const sends = filtered.filter(a => !isRepeat(a))
  const sendTotal = sends.length

  const grades = sends.map(a => a.grade_numeric_at_ascent ?? 0).filter(n => n > 0)
  const avgGrade = grades.length ? Math.round(grades.reduce((s, n) => s + n, 0) / grades.length) : null
  const medGrade = grades.length ? median(grades) : null

  const osFl = sends.filter(a => getStyle(a) === 'onsight' || getStyle(a) === 'flash').length
  const osCount = sends.filter(a => getStyle(a) === 'onsight').length
  const flCount = sends.filter(a => getStyle(a) === 'flash').length
  const rpCount = sends.filter(a => getStyle(a) === 'redpoint').length

  // Volume: le ripetizioni contano (vie uniche, giornate, falesie, attività).
  const uniqueRoutes = new Set(filtered.map(a => a.route_id)).size
  const uniqueCrags = new Set(filtered.map(a => a.route?.sector?.crag?.id).filter(Boolean)).size
  const activeDays = new Set(filtered.map(a => a.date)).size
  const repeatCount = filtered.filter(a => isRepeat(a)).length

  const within = (n: number) =>
    sends.filter(a => {
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

  const sortedSessionDates = [...filteredSessions].map(s => s.date).sort()
  const lastSessionDate = sortedSessionDates[sortedSessionDates.length - 1]
  const lastSessionDaysAgo = lastSessionDate
    ? Math.floor((Date.now() - new Date(lastSessionDate).getTime()) / 86_400_000)
    : null

  const w1 = within(1)
  const w10 = within(10)

  return {
    totalAscents: total,
    totalSessions: filteredSessions.length,
    totalCrags: uniqueCrags,
    uniqueRoutes,
    activeDays,
    repeatCount,
    bestOnsightLabel: maxGradeLabel(sends, 'onsight'),
    bestFlashLabel: maxGradeLabel(sends, 'flash'),
    bestRedpointLabel: maxGradeLabel(sends, 'redpoint'),
    avgGradeLabel: avgGrade != null ? (sends.find(a => (a.grade_numeric_at_ascent ?? 0) === avgGrade)?.grade_at_ascent ?? numToGrade(avgGrade)) : '—',
    medianGradeLabel: medGrade != null ? numToGrade(medGrade) : '—',
    osFlashPct: sendTotal > 0 ? Math.round((osFl / sendTotal) * 100) : 0,
    osPct: sendTotal > 0 ? Math.round((osCount / sendTotal) * 100) : 0,
    flashPct: sendTotal > 0 ? Math.round((flCount / sendTotal) * 100) : 0,
    rpPct: sendTotal > 0 ? Math.round((rpCount / sendTotal) * 100) : 0,
    repeatPct: total > 0 ? Math.round((repeatCount / total) * 100) : 0,
    within1: w1,
    within3: within(3),
    within5: within(5),
    within10: w10,
    beyond10: total - w10,
    activeProjects: projects.filter(p => p.status === 'active').length,
    lastSessionDaysAgo,
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
    .filter(a => !isRepeat(a))
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
  ;(ascents as AscentExt[]).forEach(a => {
    if (isRepeat(a)) return
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
  ascentStyle: AscentStyle
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
    .map(style => ({ ascentStyle: style, label: style, count: map.get(style) ?? 0 }))
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

// ── Max OS/Flash/Redpoint per periodo ─────────────────────────────────────────

export function computeMaxByStylePerPeriod(
  ascents: AscentWithRoute[],
  yearFilter: number | 'all'
): MaxByStylePeriodEntry[] {
  const map = new Map<string, { onsight: number; flash: number; redpoint: number }>()
  ;(ascents as AscentExt[]).forEach(a => {
    const n = a.grade_numeric_at_ascent ?? 0
    if (!n) return
    const style = getStyle(a)
    if (style !== 'onsight' && style !== 'flash' && style !== 'redpoint') return
    const key = yearFilter === 'all' ? a.date.slice(0, 4) : a.date.slice(0, 7)
    const entry = map.get(key) ?? { onsight: 0, flash: 0, redpoint: 0 }
    if (style === 'onsight' && n > entry.onsight) entry.onsight = n
    if (style === 'flash' && n > entry.flash) entry.flash = n
    if (style === 'redpoint' && n > entry.redpoint) entry.redpoint = n
    map.set(key, entry)
  })
  return Array.from(map.entries())
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([key, { onsight, flash, redpoint }]) => {
      const [, m] = key.split('-')
      const monthIdx = m ? parseInt(m) - 1 : -1
      const label = yearFilter === 'all' ? key : (MONTHS_IT[monthIdx] ?? key)
      return {
        label,
        onsight: onsight || null,
        flash: flash || null,
        redpoint: redpoint || null,
        onsightLabel: onsight ? numToGrade(onsight) : '—',
        flashLabel: flash ? numToGrade(flash) : '—',
        redpointLabel: redpoint ? numToGrade(redpoint) : '—',
      }
    })
}

// ── Massimo storico progressivo ───────────────────────────────────────────────

export function computeCumulativeMax(ascents: AscentWithRoute[]): CumulativeMaxPoint[] {
  const sorted = (ascents as AscentExt[])
    .filter(a => (a.grade_numeric_at_ascent ?? 0) > 0)
    .sort((a, b) => a.date.localeCompare(b.date))
  const result: CumulativeMaxPoint[] = []
  let max = 0
  sorted.forEach(a => {
    const n = a.grade_numeric_at_ascent ?? 0
    if (n > max) {
      max = n
      result.push({
        date: a.date,
        dateTs: new Date(a.date).getTime(),
        gradeValue: max,
        gradeLabel: a.grade_at_ascent ?? numToGrade(max),
      })
    }
  })
  return result
}

// ── Vie uniche vs ripetizioni per mese ───────────────────────────────────────

export function computeUniqueVsRepeatPerMonth(
  ascents: AscentWithRoute[],
  yearFilter: number | 'all'
): UniqueVsRepeatEntry[] {
  const map = new Map<string, UniqueVsRepeatEntry>()
  if (yearFilter !== 'all') {
    for (let m = 0; m < 12; m++) {
      const key = `${yearFilter}-${String(m + 1).padStart(2, '0')}`
      map.set(key, { label: MONTHS_IT[m], unique: 0, repeat: 0 })
    }
  }
  const seenRoutes = new Set<string>()
  const sorted = [...ascents].sort((a, b) => a.date.localeCompare(b.date))
  sorted.forEach(a => {
    const key = a.date.slice(0, 7)
    const [, m] = key.split('-')
    const monthIdx = parseInt(m) - 1
    const label = yearFilter === 'all' ? key : (MONTHS_IT[monthIdx] ?? key)
    if (!map.has(key)) map.set(key, { label, unique: 0, repeat: 0 })
    const entry = map.get(key)!
    if (!seenRoutes.has(a.route_id)) {
      seenRoutes.add(a.route_id)
      entry.unique++
    } else {
      entry.repeat++
    }
  })
  return Array.from(map.entries())
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([, entry]) => entry)
}

// ── Distribuzione per giorno della settimana ──────────────────────────────────

const DAYS_IT = ['Dom', 'Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab']

export function computeDayOfWeekDistribution(ascents: AscentWithRoute[]): DayOfWeekEntry[] {
  const counts = [0, 0, 0, 0, 0, 0, 0]
  ascents.forEach(a => {
    const d = new Date(a.date + 'T12:00:00')
    counts[d.getDay()]++
  })
  return DAYS_IT.map((day, i) => ({ day, count: counts[i] }))
}

// ── Distribuzione stagionale (per mese, tutti gli anni aggregati) ─────────────

export function computeSeasonalDistribution(ascents: AscentWithRoute[]): { month: string; count: number }[] {
  const counts = new Array<number>(12).fill(0)
  ascents.forEach(a => {
    const m = parseInt(a.date.slice(5, 7)) - 1
    if (m >= 0 && m < 12) counts[m]++
  })
  return MONTHS_IT.map((month, i) => ({ month, count: counts[i] }))
}

// ── Distribuzione vie per grado ───────────────────────────────────────────────

export function computeGradeDistribution(ascents: AscentWithRoute[]): GradeDistEntry[] {
  const map = new Map<string, GradeDistEntry>()
  ascents.forEach(a => {
    const grade = a.grade_at_ascent ?? a.route?.official_grade ?? null
    if (!grade) return
    const entry = map.get(grade) ?? { grade, numeric: a.grade_numeric_at_ascent ?? 0, count: 0 }
    entry.count++
    map.set(grade, entry)
  })
  return Array.from(map.values()).sort((a, b) => a.numeric - b.numeric)
}

// ── Piramide vie uniche (prima volta per via) ─────────────────────────────────

export function computeUniquePyramid(ascents: AscentWithRoute[]): GradePyramidEntry[] {
  const firstAscent = new Map<string, AscentWithRoute>()
  ;[...ascents].sort((a, b) => a.date.localeCompare(b.date)).forEach(a => {
    if (!firstAscent.has(a.route_id)) firstAscent.set(a.route_id, a)
  })
  return computeGradePyramid(Array.from(firstAscent.values()))
}

// ── Max OS/Flash/RP per anno ──────────────────────────────────────────────────

export interface MaxByStyleYear {
  year: string
  onsight: number | null
  flash: number | null
  redpoint: number | null
  onsightLabel: string
  flashLabel: string
  redpointLabel: string
}

export function computeMaxByStyleByYear(ascents: AscentWithRoute[]): MaxByStyleYear[] {
  const map = new Map<string, { onsight: number; flash: number; redpoint: number }>()
  ;(ascents as AscentExt[]).forEach(a => {
    const n = a.grade_numeric_at_ascent ?? 0
    if (!n) return
    const style = getStyle(a)
    if (style !== 'onsight' && style !== 'flash' && style !== 'redpoint') return
    const year = a.date.slice(0, 4)
    const entry = map.get(year) ?? { onsight: 0, flash: 0, redpoint: 0 }
    if (style === 'onsight' && n > entry.onsight) entry.onsight = n
    if (style === 'flash' && n > entry.flash) entry.flash = n
    if (style === 'redpoint' && n > entry.redpoint) entry.redpoint = n
    map.set(year, entry)
  })
  return Array.from(map.entries())
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([year, { onsight, flash, redpoint }]) => ({
      year,
      onsight: onsight || null,
      flash: flash || null,
      redpoint: redpoint || null,
      onsightLabel: onsight ? numToGrade(onsight) : '—',
      flashLabel: flash ? numToGrade(flash) : '—',
      redpointLabel: redpoint ? numToGrade(redpoint) : '—',
    }))
}

// ── Top falesie per vie uniche ────────────────────────────────────────────────

export function computeTopCragsByUniqueRoutes(ascents: AscentWithRoute[], limit = 10): CragStat[] {
  const map = new Map<string, { name: string; routes: Set<string> }>()
  ascents.forEach(a => {
    const id = a.route?.sector?.crag?.id
    const name = a.route?.sector?.crag?.name
    if (!id || !name) return
    const entry = map.get(id) ?? { name, routes: new Set<string>() }
    entry.routes.add(a.route_id)
    map.set(id, entry)
  })
  return Array.from(map.entries())
    .map(([id, { name, routes }]) => ({ id, name, count: routes.size }))
    .sort((a, b) => b.count - a.count)
    .slice(0, limit)
}

// ── Top falesie per grado medio ───────────────────────────────────────────────

export function computeTopCragsByAvgGrade(ascents: AscentWithRoute[], limit = 8): CragStatExtended[] {
  const map = new Map<string, { name: string; total: number; count: number }>()
  ascents.forEach(a => {
    const id = a.route?.sector?.crag?.id
    const name = a.route?.sector?.crag?.name
    const n = a.grade_numeric_at_ascent ?? 0
    if (!id || !name || !n) return
    const entry = map.get(id) ?? { name, total: 0, count: 0 }
    entry.total += n
    entry.count++
    map.set(id, entry)
  })
  return Array.from(map.entries())
    .filter(([, { count }]) => count >= 2)
    .map(([id, { name, total, count }]) => {
      const avg = Math.round(total / count)
      return { id, name, count: avg, avgGradeLabel: numToGrade(avg) }
    })
    .sort((a, b) => b.count - a.count)
    .slice(0, limit)
}

// ── Sessioni per mese ─────────────────────────────────────────────────────────

export function computeSessionsPerMonth(
  sessions: Array<{ id: string; date: string }>,
  yearFilter: number | 'all'
): MonthlyActivity[] {
  const map = new Map<string, number>()
  if (yearFilter !== 'all') {
    for (let m = 0; m < 12; m++) {
      map.set(`${yearFilter}-${String(m + 1).padStart(2, '0')}`, 0)
    }
  }
  sessions.forEach(s => {
    if (yearFilter !== 'all' && !s.date.startsWith(String(yearFilter))) return
    const key = s.date.slice(0, 7)
    map.set(key, (map.get(key) ?? 0) + 1)
  })
  return Array.from(map.entries())
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([key, count]) => {
      const [y, m] = key.split('-')
      const monthIdx = parseInt(m) - 1
      return { label: yearFilter === 'all' ? key : (MONTHS_IT[monthIdx] ?? key), count, year: y }
    })
}
