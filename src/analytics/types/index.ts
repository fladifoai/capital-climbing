import type { AttemptType } from '../../types/database'

export interface AnalyticsFilters {
  yearFilter: number | 'all'
  attemptTypes: AttemptType[] | 'all'
  gradeMin: number | null
  gradeMax: number | null
}

export const DEFAULT_FILTERS: AnalyticsFilters = {
  yearFilter: 'all',
  attemptTypes: 'all',
  gradeMin: null,
  gradeMax: null,
}

export interface KpiData {
  totalAscents: number
  totalSessions: number
  totalCrags: number
  bestOnsightLabel: string
  bestFlashLabel: string
  bestRedpointLabel: string
  osFlashPct: number
  activeProjects: number
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
  second: number
  third: number
  four_plus: number
  redpoint: number
  other: number
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
