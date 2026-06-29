import { parseLogbookFile, type ParseResult } from '../logbook-import/parse'
import { cleanCragName, normalizeGrade, normalizeKey } from '../logbook-import/normalize'
import {
  CRAG_ALL_FIELDS, CRAG_REQUIRED_FIELDS,
  type CragColumnMap, type CragField, type ParsedCragRow, type RawCragRow,
} from './types'

// ── Lettura file ──────────────────────────────────────────────────────────
export async function parseCragFile(file: File): Promise<ParseResult> {
  const name = file.name.toLowerCase()
  if (name.endsWith('.md') || name.endsWith('.markdown')) {
    const text = await file.text()
    return parseMarkdownTable(text)
  }
  if (name.endsWith('.pdf')) {
    const { parseCragPdf } = await import('./pdf')
    return parseCragPdf(file)
  }
  // CSV/XLSX: riusa il lettore del logbook
  return parseLogbookFile(file)
}

// Parser tabella Markdown (| col | col |). Prende la prima tabella trovata.
export function parseMarkdownTable(text: string): ParseResult {
  const lines = text.split(/\r?\n/)
  const tableLines = lines.filter(l => l.trim().startsWith('|') && l.includes('|'))
  if (tableLines.length < 2) throw new Error('Nessuna tabella Markdown trovata nel file.')

  const cells = (l: string) => l.replace(/^\s*\|/, '').replace(/\|\s*$/, '').split('|').map(c => c.trim())
  const headers = cells(tableLines[0])
  // riga 1 = separatore (---). Le righe dati partono dalla 2.
  const rows: RawCragRow[] = []
  for (let i = 2; i < tableLines.length; i++) {
    const vals = cells(tableLines[i])
    if (vals.every(v => /^[-:\s]*$/.test(v))) continue
    const row: RawCragRow = {}
    headers.forEach((h, j) => { row[h] = vals[j] ?? '' })
    rows.push(row)
  }
  if (rows.length === 0) throw new Error('Tabella Markdown senza righe dati.')
  return { headers, rows }
}

// ── Auto-detect colonne ─────────────────────────────────────────────────────
const FIELD_ALIASES: Record<CragField, string[]> = {
  crag: ['crag', 'crag_name', 'falesia', 'nome_falesia', 'nome falesia', 'spot', 'zona', 'crag_name_clean'],
  sector: ['sector', 'sector_name', 'settore', 'nome_settore', 'nome settore', 'area', 'sectors'],
  route: ['route', 'route_name', 'via', 'nome_via', 'nome via', 'nome', 'name', 'percorso'],
  grade: ['grade', 'official_grade', 'grado', 'difficolta', 'livello'],
  route_type: ['route_type', 'tipo', 'type', 'stile'],
  region: ['region', 'regione', 'regione_o_isola', 'region_or_island'],
  province: ['province', 'provincia', 'province_or_island', 'province_or_island_name', 'provincia_o_isola'],
  municipality: ['municipality', 'comune', 'citta', 'localita', 'località'],
  country: ['country', 'paese', 'nazione', 'stato'],
}

export function autoDetectCragColumns(headers: string[]): CragColumnMap {
  const map: CragColumnMap = {}
  const lower = headers.map(h => h.toLowerCase().trim())
  for (const [field, aliases] of Object.entries(FIELD_ALIASES) as [CragField, string[]][]) {
    for (const alias of aliases) {
      const idx = lower.indexOf(alias)
      if (idx !== -1) { map[field] = headers[idx]; break }
    }
  }
  return map
}

export const CRAG_FIELD_LABELS: Record<CragField, string> = {
  crag: 'Falesia', sector: 'Settore', route: 'Via', grade: 'Grado',
  route_type: 'Tipo via', region: 'Regione', province: 'Provincia',
  municipality: 'Comune', country: 'Paese',
}

// ── Normalizzazione riga ────────────────────────────────────────────────────
export function parseCragRow(rowNum: number, raw: RawCragRow, map: CragColumnMap): ParsedCragRow {
  const get = (f: CragField) => (map[f] ? String(raw[map[f]!] ?? '') : '').trim()
  const errors: string[] = []

  const crag_name = cleanCragName(get('crag'))
  const sector_name = get('sector')
  const route_name = get('route')
  const grade = normalizeGrade(get('grade'))

  if (!crag_name) errors.push('Falesia mancante')
  if (!route_name) errors.push('Via mancante')
  if (!grade) errors.push('Grado mancante')

  return {
    rowNum,
    crag_name, sector_name, route_name, grade,
    route_type: get('route_type') || 'sport',
    region: get('region'),
    province: get('province'),
    municipality: get('municipality'),
    country: get('country') || 'Italia',
    normalized_crag: normalizeKey(crag_name),
    normalized_sector: normalizeKey(sector_name),
    normalized_route: normalizeKey(route_name),
    errors,
    isValid: errors.length === 0,
  }
}

export { CRAG_ALL_FIELDS, CRAG_REQUIRED_FIELDS }
