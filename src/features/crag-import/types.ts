// Import falesia (admin): un file con le vie di una o più falesie →
// crea/merge crags > sectors > routes nel catalogo, nella regione giusta.

export const CRAG_REQUIRED_FIELDS = ['crag', 'route', 'grade'] as const
export const CRAG_ALL_FIELDS = [
  'crag', 'sector', 'route', 'grade', 'route_type',
  'region', 'province', 'municipality', 'country',
] as const

export type CragRequiredField = (typeof CRAG_REQUIRED_FIELDS)[number]
export type CragField = (typeof CRAG_ALL_FIELDS)[number]
export type CragColumnMap = Partial<Record<CragField, string>>

export type CragWizardStep = 'upload' | 'mapping' | 'confirm' | 'done'

export interface RawCragRow { [column: string]: string }

// Riga normalizzata (una via).
export interface ParsedCragRow {
  rowNum: number
  crag_name: string
  sector_name: string
  route_name: string
  grade: string | null
  route_type: string
  region: string
  province: string
  municipality: string
  country: string
  normalized_crag: string
  normalized_sector: string
  normalized_route: string
  errors: string[]
  isValid: boolean
}

// Aggregato per falesia (per lo step geo + preview + execute).
export interface CragGroup {
  normalized_crag: string
  crag_name: string
  // geo (modificabile dall'admin)
  region: string            // nome regione (es. "Abruzzo")
  region_id: string | null  // risolto
  province: string
  municipality: string
  geoSource: 'file' | 'auto' | 'manual' | 'none'
  // stato catalogo
  existingCragId: string | null
  sectors: { name: string; normalized: string; existing: boolean }[]
  routesNew: number
  routesExisting: number
  rows: ParsedCragRow[]
}

export interface CragImportReport {
  cragsCreated: number
  cragsMerged: number
  sectorsCreated: number
  routesCreated: number
  routesSkipped: number
  enrichmentQueued: number   // falesie messe in coda di arricchimento (coord/quota/stagione/...)
  errors: { crag: string; message: string }[]
}
