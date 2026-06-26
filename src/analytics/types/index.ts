import type { AscentStyle } from '../calculations/ascent-style'
import type { AttemptBucket } from '../calculations/attempt-buckets'

export interface AnalyticsFilters {
  yearFilter: number | 'all'
  ascentStyles: AscentStyle[] | 'all'
  attemptBuckets: AttemptBucket[] | 'all'
  gradeMin: number | null
  gradeMax: number | null
}

export const DEFAULT_FILTERS: AnalyticsFilters = {
  yearFilter: 'all',
  ascentStyles: 'all',
  attemptBuckets: 'all',
  gradeMin: null,
  gradeMax: null,
}

export interface KpiData {
  totalAscents: number
  totalSessions: number
  totalCrags: number
  uniqueRoutes: number
  activeDays: number
  bestOnsightLabel: string
  bestFlashLabel: string
  bestRedpointLabel: string
  avgGradeLabel: string
  medianGradeLabel: string
  osFlashPct: number
  osPct: number
  flashPct: number
  rpPct: number
  within3: number
  within5: number
  within10: number
  activeProjects: number
}

export interface DataQualityStats {
  total: number
  withAscentStyle: number
  withAttemptCount: number
  withGrade: number
  needsReview: number
  fourPlusLegacy: number
  missingAttemptInfo: number
}

export interface GradeProgressionPoint {
  date: string
  dateTs: number
  gradeValue: number
  gradeLabel: string
  routeName: string
  cragName: string
  sectorName: string
  attemptType: string | null
}

export interface GradePyramidEntry {
  grade: string
  numeric: number
  onsight: number
  flash: number
  redpoint: number
  repeat: number
  unknown: number
  total: number
}

export interface MonthlyActivity {
  label: string
  count: number
  year: string
}

export interface CragStat {
  id: string
  name: string
  count: number
}
