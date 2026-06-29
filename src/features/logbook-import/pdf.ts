import type { ParseResult } from './parse'
import type { RawLogbookRow } from './types'

// Estrazione best-effort da PDF: i PDF non hanno struttura tabellare garantita,
// quindi ricostruiamo le righe per posizione verticale e spezziamo in colonne
// sui blocchi di spazi. L'utente poi mappa le colonne come per CSV/XLSX.
export async function parsePdf(file: File): Promise<ParseResult> {
  const pdfjs = await import('pdfjs-dist')
  const workerUrl = (await import('pdfjs-dist/build/pdf.worker.min.mjs?url')).default
  pdfjs.GlobalWorkerOptions.workerSrc = workerUrl

  const buf = await file.arrayBuffer()
  const doc = await pdfjs.getDocument({ data: buf }).promise

  const lines: string[] = []
  for (let p = 1; p <= doc.numPages; p++) {
    const page = await doc.getPage(p)
    const content = await page.getTextContent()
    // raggruppa gli item per coordinata Y (riga visiva)
    const byRow = new Map<number, { x: number; s: string }[]>()
    for (const item of content.items as { str: string; transform: number[] }[]) {
      if (!item.str.trim()) continue
      const y = Math.round(item.transform[5])
      if (!byRow.has(y)) byRow.set(y, [])
      byRow.get(y)!.push({ x: item.transform[4], s: item.str })
    }
    // Y decrescente = dall'alto al basso
    const ys = [...byRow.keys()].sort((a, b) => b - a)
    for (const y of ys) {
      const parts = byRow.get(y)!.sort((a, b) => a.x - b.x)
      // unisci item adiacenti con separatore tab così resta la struttura colonne
      const line = parts.map(p => p.s.trim()).filter(Boolean).join('\t')
      if (line.trim()) lines.push(line)
    }
  }

  if (lines.length === 0) throw new Error('Nessun testo estratto dal PDF (forse è scansionato/immagine).')

  // Spezza ogni riga in colonne su tab o run di 2+ spazi
  const split = (l: string) => l.split(/\t|\s{2,}/).map(c => c.trim()).filter(Boolean)
  const matrix = lines.map(split)
  const maxCols = Math.max(...matrix.map(r => r.length))

  if (maxCols < 2) {
    // niente colonne riconoscibili: una sola colonna "Testo", l'utente non potrà mappare bene
    const headers = ['Testo']
    const rows: RawLogbookRow[] = lines.map(l => ({ Testo: l }))
    return { headers, rows }
  }

  // intestazioni sintetiche: l'utente le mappa nello step Colonne
  const headers = Array.from({ length: maxCols }, (_, i) => `Colonna ${i + 1}`)
  const rows: RawLogbookRow[] = matrix.map(cols => {
    const row: RawLogbookRow = {}
    headers.forEach((h, i) => { row[h] = cols[i] ?? '' })
    return row
  })
  return { headers, rows }
}
