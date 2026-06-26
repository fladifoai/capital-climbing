import { REQUIRED_FIELDS, type AppField, type ColumnMap, type ValidatedRow } from './types'

export const FIELD_LABELS: Record<AppField, string> = {
  crag_name: 'Nome falesia',
  sector_name: 'Nome settore',
  route_name: 'Nome via',
  official_grade: 'Grado ufficiale',
  crag_country: 'Paese',
  crag_municipality: 'Comune',
  crag_province: 'Provincia',
  source_name: 'Fonte',
  permission_status: 'Stato permesso',
  route_type: 'Tipo via',
  length_m: 'Lunghezza (m)',
  pitches: 'Tiri',
  bolts: 'Spit',
  angle: 'Angolo',
  first_ascent: 'Prima salita',
  description: 'Descrizione',
  line_order: 'Ordine',
}

const FIELD_ALIASES: Record<AppField, string[]> = {
  crag_name: ['crag_name', 'falesia', 'nome_falesia', 'nome falesia', 'crag'],
  sector_name: ['sector_name', 'settore', 'nome_settore', 'nome settore', 'sector'],
  route_name: ['route_name', 'via', 'nome_via', 'nome via', 'route', 'nome', 'name'],
  official_grade: ['official_grade', 'grado', 'grade', 'livello', 'difficolta'],
  crag_country: ['crag_country', 'paese', 'country', 'nazione'],
  crag_municipality: ['crag_municipality', 'comune', 'municipality', 'citta'],
  crag_province: ['crag_province', 'provincia', 'province'],
  source_name: ['source_name', 'fonte', 'source', 'sorgente'],
  permission_status: ['permission_status', 'permesso', 'permission', 'autorizzazione'],
  route_type: ['route_type', 'tipo', 'type', 'stile', 'style'],
  length_m: ['length_m', 'lunghezza', 'length', 'metri', 'mt', 'altezza'],
  pitches: ['pitches', 'tiri', 'lunghezze', 'tratti'],
  bolts: ['bolts', 'spit', 'fix', 'protezioni', 'chiodi'],
  angle: ['angle', 'angolo', 'inclinazione'],
  first_ascent: ['first_ascent', 'prima_salita', 'prima salita', 'fa', 'first'],
  description: ['description', 'descrizione', 'note', 'notes', 'info'],
  line_order: ['line_order', 'ordine', 'order', 'numero', 'num'],
}

export function normalizeKey(name: string): string {
  return name
    .toLowerCase()
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .replace(/[^a-z0-9]+/g, ' ')
    .trim()
    .replace(/\s+/g, ' ')
}

export function slugFromNorm(norm: string): string {
  return norm.replace(/ /g, '-')
}

export function autoDetectColumns(headers: string[]): ColumnMap {
  const map: ColumnMap = {}
  const lowerHeaders = headers.map(h => h.toLowerCase().trim())

  for (const [field, aliases] of Object.entries(FIELD_ALIASES) as [AppField, string[]][]) {
    for (const alias of aliases) {
      const idx = lowerHeaders.indexOf(alias)
      if (idx !== -1) {
        map[field] = headers[idx]
        break
      }
    }
  }

  return map
}

export function validateRow(
  rowNum: number,
  raw: Record<string, string>,
  map: ColumnMap
): ValidatedRow {
  const get = (field: AppField) => (map[field] ? raw[map[field]] ?? '' : '').trim()
  const errors: string[] = []

  for (const field of REQUIRED_FIELDS) {
    if (!get(field)) {
      errors.push(`"${FIELD_LABELS[field]}" mancante`)
    }
  }

  const crag_name = get('crag_name')
  const sector_name = get('sector_name')
  const route_name = get('route_name')
  const official_grade = get('official_grade').toLowerCase().replace(/\s+/g, '')

  const rawLm = get('length_m')
  const rawPitches = get('pitches')
  const rawBolts = get('bolts')
  const rawOrder = get('line_order')

  return {
    rowNum,
    crag_name,
    sector_name,
    route_name,
    official_grade,
    source_name: get('source_name'),
    permission_status: get('permission_status'),
    route_type: get('route_type') || 'sport',
    length_m: rawLm ? (parseFloat(rawLm) || null) : null,
    pitches: parseInt(rawPitches) || 1,
    bolts: rawBolts ? (parseInt(rawBolts) || null) : null,
    angle: get('angle') || null,
    crag_municipality: get('crag_municipality') || null,
    crag_province: get('crag_province') || null,
    first_ascent: get('first_ascent') || null,
    description: get('description') || null,
    line_order: rawOrder ? (parseInt(rawOrder) || null) : null,
    normalized_crag: normalizeKey(crag_name),
    normalized_sector: normalizeKey(sector_name),
    normalized_route: normalizeKey(route_name),
    errors,
    isValid: errors.length === 0,
    action: 'import',
  }
}
