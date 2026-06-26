export type WizardStep = 'upload' | 'mapping' | 'validation' | 'confirm' | 'done'

export const REQUIRED_FIELDS = ['crag_name', 'sector_name', 'route_name', 'official_grade'] as const
export const ALL_APP_FIELDS = [
  'crag_name', 'sector_name', 'route_name', 'official_grade',
  'crag_country', 'crag_municipality', 'crag_province',
  'source_name', 'permission_status',
  'route_type', 'length_m', 'pitches', 'bolts', 'angle',
  'first_ascent', 'description', 'line_order',
] as const

export type RequiredField = (typeof REQUIRED_FIELDS)[number]
export type AppField = (typeof ALL_APP_FIELDS)[number]
export type ColumnMap = Partial<Record<AppField, string>>

export interface ValidatedRow {
  rowNum: number
  // Mapped values
  crag_name: string
  sector_name: string
  route_name: string
  official_grade: string
  source_name: string
  permission_status: string
  route_type: string
  length_m: number | null
  pitches: number
  bolts: number | null
  angle: string | null
  crag_municipality: string | null
  crag_province: string | null
  first_ascent: string | null
  description: string | null
  line_order: number | null
  // Normalized keys for dedup
  normalized_crag: string
  normalized_sector: string
  normalized_route: string
  // Validation
  errors: string[]
  isValid: boolean
  // Duplicate info (filled in confirm step)
  existingCragId?: string
  existingSectorId?: string
  existingRouteId?: string
  // User action
  action: 'import' | 'update' | 'skip'
}

export interface ImportReport {
  total: number
  imported: number
  updated: number
  skipped: number
  errors: { rowNum: number; message: string }[]
}
