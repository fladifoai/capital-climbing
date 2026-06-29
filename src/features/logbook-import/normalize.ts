import type { AttemptType } from '../../types/database'
import { normalizeKey } from '../import/utils'

export { normalizeKey }

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
// Mappa input liberi → enum DB. Ritorna { type, count, ambiguous }.
// enum reale: 'onsight' | 'flash' | 'second' | 'third' | 'four_plus' | 'redpoint'
export interface AttemptResult {
  type: AttemptType | null
  count: number | null
  ambiguous: boolean   // es. "4+" senza numero reale di giri → review
}

export function normalizeAttempt(raw: string): AttemptResult {
  const s = (raw ?? '').toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '').trim()
  if (!s || s === 'n.d.' || s === 'nd' || s === 'unknown' || s === 'sconosciuto') {
    return { type: null, count: null, ambiguous: false }
  }

  if (/(on[\s-]?sight|^os$|flash[\s-]?on)/.test(s)) return { type: 'onsight', count: null, ambiguous: false }
  if (/(^|\b)(flash|fl)(\b|$)/.test(s)) return { type: 'flash', count: null, ambiguous: false }
  if (/(red[\s-]?point|rotpunkt|^rp$)/.test(s)) return { type: 'redpoint', count: null, ambiguous: false }

  // estrai numero giri da "2° giro", "2nd go", "3rd", "7° giro", "5"
  const num = s.match(/(\d+)\s*(?:°|st|nd|rd|th|giro|go)?/)
  if (num) {
    const n = parseInt(num[1], 10)
    if (n === 1) return { type: 'flash', count: 1, ambiguous: false }   // 1° giro = flash effettivo
    if (n === 2) return { type: 'second', count: 2, ambiguous: false }
    if (n === 3) return { type: 'third', count: 3, ambiguous: false }
    if (n >= 4) return { type: 'four_plus', count: n, ambiguous: false }
  }

  // "4+" o "four_plus" senza numero reale → ambiguo, review
  if (/(4\+|four[\s_-]?plus)/.test(s)) return { type: 'four_plus', count: null, ambiguous: true }
  if (/second/.test(s)) return { type: 'second', count: 2, ambiguous: false }
  if (/third/.test(s)) return { type: 'third', count: 3, ambiguous: false }

  return { type: null, count: null, ambiguous: false }
}
