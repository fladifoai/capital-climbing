import type { AttemptType } from '../../types/database'

// Campi logbook personale (ascensioni), distinti dai campi catalogo dell'import admin.
export const LOGBOOK_REQUIRED_FIELDS = ['date', 'crag', 'route'] as const
export const LOGBOOK_ALL_FIELDS = [
  'date', 'crag', 'sector', 'route',
  'grade', 'proposed_grade', 'attempt_type', 'beauty', 'notes',
] as const

export type LogbookRequiredField = (typeof LOGBOOK_REQUIRED_FIELDS)[number]
export type LogbookField = (typeof LOGBOOK_ALL_FIELDS)[number]
export type LogbookColumnMap = Partial<Record<LogbookField, string>>

export type LogbookWizardStep = 'upload' | 'mapping' | 'preview' | 'confirm' | 'done'

// Riga grezza letta dal file (CSV/XLSX/PDF), valori già stringa.
export interface RawLogbookRow {
  [column: string]: string
}

// Riga dopo normalizzazione + validazione, prima dell'abbinamento al catalogo.
export interface ParsedLogbookRow {
  rowNum: number
  // valori originali
  raw_date: string
  raw_grade: string
  raw_attempt: string
  // valori normalizzati
  date: string | null              // ISO YYYY-MM-DD
  crag_name: string
  sector_name: string
  route_name: string
  grade: string | null             // grado ufficiale normalizzato (es. 7a+)
  proposed_grade: string | null    // grado proposto/personale
  attempt_type: AttemptType | null
  attempt_count: number | null     // numero giri se noto (es. 7° giro → 7)
  quality: number | null           // bellezza 1-5 (da "****" o numero)
  notes: string | null
  // chiavi normalizzate per dedup / match
  normalized_crag: string
  normalized_sector: string
  normalized_route: string
  // validazione
  warnings: string[]               // problemi che mandano in revisione, non bloccanti
  errors: string[]                 // problemi bloccanti (manca data/via)
  needsReview: boolean
  isValid: boolean
}

// Riga dopo l'abbinamento al catalogo (Fase 2/3).
export type MatchStatus = 'matched' | 'duplicate' | 'unmatched'

export interface ResolvedLogbookRow extends ParsedLogbookRow {
  matchStatus: MatchStatus
  routeId: string | null
  action: 'import' | 'skip'   // import: salva (ascensione o coda); skip: ignora
}

export interface LogbookImportReport {
  total: number
  imported: number      // ascensioni salvate subito (via in catalogo)
  queued: number        // ascensioni in coda (via mancante)
  skipped: number       // duplicati o saltate
  cragRequests: number  // richieste falesia create
  errors: { rowNum: number; message: string }[]
}
