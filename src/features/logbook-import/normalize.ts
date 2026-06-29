import { getAttemptBucket, type AttemptBucket } from '../../analytics/calculations/attempt-buckets'
import { normalizeKey } from '../import/utils'

export { normalizeKey }

// Pulisce il nome falesia: toglie i settori tra parentesi e spazi extra.
// Es. "Collepardo (Cueva, Cuevita)" → "Collepardo".
export function cleanCragName(raw: string): string {
  return (raw ?? '').replace(/\([^)]*\)/g, '').replace(/\s+/g, ' ').trim()
}

// ── Date ────────────────────────────────────────────────────────────────────
// Accetta: DD-MM-YYYY, DD/MM/YYYY, YYYY-MM-DD, DD.MM.YYYY. Ritorna ISO o null.
export function normalizeDate(raw: string): string | null {
  const s = (raw ?? '').trim()
  if (!s) return null

  // già ISO YYYY-MM-DD
  const iso = s.match(/^(\d{4})-(\d{2})-(\d{2})$/)
  if (iso) return `${iso[1]}-${iso[2]}-${iso[3]}`

  // DD[-/.]MM[-/.]YYYY
  const dmy = s.match(/^(\d{1,2})[-/.](\d{1,2})[-/.](\d{4})$/)
  if (dmy) {
    const d = dmy[1].padStart(2, '0')
    const m = dmy[2].padStart(2, '0')
    const y = dmy[3]
    if (+m >= 1 && +m <= 12 && +d >= 1 && +d <= 31) return `${y}-${m}-${d}`
  }

  // seriale Excel (numero giorni dal 1899-12-30)
  const serial = s.match(/^\d+(\.\d+)?$/)
  if (serial) {
    const n = parseFloat(s)
    if (n > 0 && n < 100000) {
      const ms = (n - 25569) * 86400 * 1000
      const dt = new Date(ms)
      if (!isNaN(dt.getTime())) return dt.toISOString().slice(0, 10)
    }
  }

  return null
}

// ── Grado ─────────────────────────────────────────────────────────────────
// Normalizza minuscolo, niente spazi. Es. "7A+" → "7a+", "6c " → "6c".
export function normalizeGrade(raw: string): string | null {
  const s = (raw ?? '').toLowerCase().replace(/\s+/g, '')
  if (!s) return null
  // grado francese valido tipo 5, 6a, 7a+, 8b, 9c. Tollerante.
  if (/^\d[abc]?[+]?$/.test(s) || /^\d+$/.test(s)) return s
  return s // sconosciuto ma lo teniamo, marcato altrove
}

// ── Modalità di salita ────────────────────────────────────────────────────
// Allineato al modello app: ascent_style + attempt_count + attempt_bucket.
// ascent_style: 'onsight' | 'flash' | 'redpoint' | null
// Giri 1-10 = bucket esatto, 11-20/21-30/.../50_plus = bucket aggregato.
export interface AttemptResult {
  ascent_style: string | null
  attempt_count: number | null
  attempt_bucket: AttemptBucket | null
  ambiguous: boolean   // es. "4+"/"redpoint" senza numero reale di giri → review
}

export function normalizeAttempt(raw: string): AttemptResult {
  const s = (raw ?? '').toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '').trim()
  const none = { ascent_style: null, attempt_count: null, attempt_bucket: null, ambiguous: false }
  if (!s || s === 'n.d.' || s === 'nd' || s === 'unknown' || s === 'sconosciuto') return none

  if (/(on[\s-]?sight|^os$|flash[\s-]?on)/.test(s))
    return { ascent_style: 'onsight', attempt_count: 1, attempt_bucket: '1', ambiguous: false }
  if (/(^|\b)(flash|fl)(\b|$)/.test(s))
    return { ascent_style: 'flash', attempt_count: 1, attempt_bucket: '1', ambiguous: false }

  // numero giri da "2° giro", "2nd go", "3rd", "15° giro", "5"
  const num = s.match(/(\d+)\s*(?:°|st|nd|rd|th|giro|go)?/)
  if (num) {
    const n = parseInt(num[1], 10)
    if (n === 1) return { ascent_style: 'flash', attempt_count: 1, attempt_bucket: '1', ambiguous: false }
    if (n >= 2) return { ascent_style: 'redpoint', attempt_count: n, attempt_bucket: getAttemptBucket(n), ambiguous: false }
  }

  // redpoint / "4+" senza numero reale → stile noto ma giri ignoti → review
  if (/(red[\s-]?point|rotpunkt|^rp$|4\+|four[\s_-]?plus)/.test(s))
    return { ascent_style: 'redpoint', attempt_count: null, attempt_bucket: null, ambiguous: true }

  return none
}
