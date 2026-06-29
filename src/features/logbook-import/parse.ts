import Papa from 'papaparse'
import * as XLSX from 'xlsx'
import {
  LOGBOOK_ALL_FIELDS, LOGBOOK_REQUIRED_FIELDS,
  type LogbookColumnMap, type LogbookField, type ParsedLogbookRow, type RawLogbookRow,
} from './types'
import { cleanCragName, normalizeAttempt, normalizeDate, normalizeGrade, normalizeKey } from './normalize'

export interface ParseResult {
  headers: string[]
  rows: RawLogbookRow[]
}

// ── Lettura file ──────────────────────────────────────────────────────────
export async function parseLogbookFile(file: File): Promise<ParseResult> {
  const name = file.name.toLowerCase()
  if (name.endsWith('.csv')) return parseCsv(file)
  if (name.endsWith('.xlsx') || name.endsWith('.xls')) return parseXlsx(file)
  if (name.endsWith('.pdf')) {
    const { parsePdf } = await import('./pdf')
    return parsePdf(file)
  }
  throw new Error('Formato non supportato. Usa .csv, .xlsx o .pdf.')
}

function parseCsv(file: File): Promise<ParseResult> {
  return new Promise((resolve, reject) => {
    Papa.parse<RawLogbookRow>(file, {
      header: true,
      skipEmptyLines: true,
      complete(results) {
        const headers = results.meta.fields ?? []
        if (headers.length === 0) return reject(new Error('File vuoto o senza intestazione'))
        resolve({ headers, rows: results.data })
      },
      error: (err) => reject(new Error(`Errore parsing CSV: ${err.message}`)),
    })
  })
}

async function parseXlsx(file: File): Promise<ParseResult> {
  const buf = await file.arrayBuffer()
  const wb = XLSX.read(buf, { type: 'array' })
  const sheet = wb.Sheets[wb.SheetNames[0]]
  if (!sheet) throw new Error('Foglio Excel vuoto')
  // defval: '' così le celle vuote restano stringhe; raw:false formatta le date come testo
  const json = XLSX.utils.sheet_to_json<RawLogbookRow>(sheet, { defval: '', raw: false })
  if (json.length === 0) throw new Error('Nessuna riga nel foglio Excel')
  const headers = Object.keys(json[0])
  return { headers, rows: json }
}

// ── Auto-detect colonne ─────────────────────────────────────────────────────
const FIELD_ALIASES: Record<LogbookField, string[]> = {
  date: ['date', 'data', 'giorno', 'when'],
  crag: ['crag', 'falesia', 'nome_falesia', 'nome falesia', 'spot', 'zona', 'luogo'],
  sector: ['sector', 'settore', 'nome_settore', 'nome settore', 'area'],
  route: ['route', 'via', 'nome_via', 'nome via', 'nome', 'name', 'percorso'],
  grade: ['grade', 'grado', 'difficolta', 'livello', 'grado_ufficiale'],
  proposed_grade: ['proposed_grade', 'grado_proposto', 'grado proposto', 'personal_grade', 'suggested'],
  attempt_type: ['attempt_type', 'modalita', 'modalità', 'stile', 'style', 'tentativo', 'tentativo', 'tipo', 'go', 'ascent'],
  notes: ['notes', 'note', 'commento', 'comment', 'descrizione', 'info'],
}

export function autoDetectLogbookColumns(headers: string[]): LogbookColumnMap {
  const map: LogbookColumnMap = {}
  const lower = headers.map(h => h.toLowerCase().trim())
  for (const [field, aliases] of Object.entries(FIELD_ALIASES) as [LogbookField, string[]][]) {
    for (const alias of aliases) {
      const idx = lower.indexOf(alias)
      if (idx !== -1) { map[field] = headers[idx]; break }
    }
  }
  return map
}

// ── Normalizzazione + validazione riga ──────────────────────────────────────
export function parseLogbookRow(
  rowNum: number,
  raw: RawLogbookRow,
  map: LogbookColumnMap,
): ParsedLogbookRow {
  const get = (f: LogbookField) => (map[f] ? String(raw[map[f]!] ?? '') : '').trim()

  const errors: string[] = []
  const warnings: string[] = []

  const raw_date = get('date')
  const raw_grade = get('grade')
  const raw_attempt = get('attempt_type')

  const date = normalizeDate(raw_date)
  const crag_name = cleanCragName(get('crag'))
  const sector_name = get('sector')
  const route_name = get('route')
  const grade = normalizeGrade(raw_grade)
  const proposed_grade = normalizeGrade(get('proposed_grade'))
  const attempt = normalizeAttempt(raw_attempt)
  const notes = get('notes') || null

  // bloccanti
  if (!raw_date) errors.push('Data mancante')
  else if (!date) errors.push(`Data non valida: "${raw_date}"`)
  if (!route_name) errors.push('Via mancante')
  if (!crag_name) errors.push('Falesia mancante')

  // revisione (non bloccanti)
  if (!grade) warnings.push('Grado mancante')
  if (!attempt.type) warnings.push('Modalità mancante o sconosciuta')
  if (attempt.ambiguous) warnings.push('Modalità "4+" senza numero reale di giri')

  const errorsBlock = errors.length > 0
  const needsReview = !errorsBlock && warnings.length > 0

  return {
    rowNum,
    raw_date, raw_grade, raw_attempt,
    date,
    crag_name, sector_name, route_name,
    grade, proposed_grade,
    attempt_type: attempt.type,
    attempt_count: attempt.count,
    notes,
    normalized_crag: normalizeKey(crag_name),
    normalized_sector: normalizeKey(sector_name),
    normalized_route: normalizeKey(route_name),
    warnings, errors,
    needsReview,
    isValid: !errorsBlock,
  }
}

export const LOGBOOK_FIELD_LABELS: Record<LogbookField, string> = {
  date: 'Data',
  crag: 'Falesia',
  sector: 'Settore',
  route: 'Via',
  grade: 'Grado',
  proposed_grade: 'Grado proposto',
  attempt_type: 'Modalità',
  notes: 'Note',
}

export { LOGBOOK_ALL_FIELDS, LOGBOOK_REQUIRED_FIELDS }
