import type { ParseResult } from '../logbook-import/parse'
import type { RawCragRow } from './types'

// Parser PDF dedicato ai topo "Capital Climbing" (uno per falesia):
//   riga 1 = nome falesia
//   header colonne = "# Nome Grado Proposto Ripetizioni Note Bellezza"
//   righe vie = "N <via> <grado> <proposto> <ripetizioni> [note] <stelle>"
//   le note "Inizio settore X" indicano l'inizio di un settore.
// Assegna ogni token alla colonna per posizione X → robusto al testo multi-parola.

interface Tok { x: number; s: string }

const COL_KEYS: Record<string, string> = {
  '#': 'num', nome: 'Via', grado: 'Grado', proposto: 'Proposto',
  ripetizioni: 'Ripetizioni', note: 'Note', bellezza: 'Bellezza',
}

export async function parseCragPdf(file: File): Promise<ParseResult> {
  const pdfjs = await import('pdfjs-dist')
  const workerUrl = (await import('pdfjs-dist/build/pdf.worker.min.mjs?url')).default
  pdfjs.GlobalWorkerOptions.workerSrc = workerUrl

  const buf = await file.arrayBuffer()
  const params = { data: buf, isEvalSupported: false } as Parameters<typeof pdfjs.getDocument>[0]
  const doc = await pdfjs.getDocument(params).promise

  // 1. estrai tutte le righe (gruppi per Y) di tutte le pagine, dall'alto al basso
  const allLines: Tok[][] = []
  for (let p = 1; p <= doc.numPages; p++) {
    const page = await doc.getPage(p)
    const content = await page.getTextContent()
    const byY = new Map<number, Tok[]>()
    for (const it of content.items as { str: string; transform: number[] }[]) {
      if (!it.str.trim()) continue
      const y = Math.round(it.transform[5])
      if (!byY.has(y)) byY.set(y, [])
      byY.get(y)!.push({ x: it.transform[4], s: it.str })
    }
    const ys = [...byY.keys()].sort((a, b) => b - a)
    for (const y of ys) allLines.push(byY.get(y)!.sort((a, b) => a.x - b.x))
  }
  if (allLines.length === 0) throw new Error('Nessun testo estratto dal PDF (forse è scansionato/immagine).')

  // 2. nome falesia = prima riga prima dell'header.
  //    La parte tra parentesi è il/i settore/i: se è UNO solo (niente virgola)
  //    lo usiamo come settore di default per tutte le vie (es. "Grotti (Grotti Alta)").
  //    Se sono più (es. "Collepardo (Cueva, Cuevita)") si ricava dalle note.
  const cragName = allLines[0].map(t => t.s).join(' ').trim()
  const paren = cragName.match(/\(([^)]*)\)/)?.[1]?.trim() ?? ''
  const defaultSector = paren && !paren.includes(',') ? paren : ''

  // 3. trova l'header colonne (contiene "Nome" e "Grado") + posizioni X
  let headerIdx = -1
  let columns: { key: string; x: number }[] = []
  for (let i = 0; i < allLines.length; i++) {
    const text = allLines[i].map(t => t.s.toLowerCase()).join(' ')
    if (text.includes('nome') && text.includes('grado')) {
      headerIdx = i
      columns = allLines[i]
        .map(t => ({ key: COL_KEYS[t.s.trim().toLowerCase()] ?? null, x: t.x }))
        .filter((c): c is { key: string; x: number } => c.key !== null)
        .sort((a, b) => a.x - b.x)
      break
    }
  }
  if (headerIdx === -1 || columns.length < 2) {
    throw new Error('Formato PDF non riconosciuto (manca l’intestazione "Nome / Grado").')
  }

  // colonna di appartenenza per una X = ultima colonna con x <= tokenX
  const colFor = (x: number): string => {
    let key = columns[0].key
    for (const c of columns) { if (x >= c.x - 4) key = c.key; else break }
    return key
  }

  const isStars = (s: string) => /^[★☆]+$/.test(s.trim())
  const headers = ['Falesia', 'Settore', 'Via', 'Grado', 'Proposto', 'Note', 'Bellezza']
  const rows: RawCragRow[] = []
  let currentSector = defaultSector

  // 4. righe dati: iniziano con un numero (#). Le righe senza numero sono
  //    continuazioni di nota → le ignoriamo (best-effort).
  for (let i = headerIdx + 1; i < allLines.length; i++) {
    const line = allLines[i]
    const first = line[0]?.s.trim() ?? ''
    if (!/^\d+$/.test(first)) continue   // non è una nuova via

    const cell: Record<string, string[]> = {}
    for (const t of line) {
      const key = isStars(t.s) ? 'Bellezza' : colFor(t.x)
      ;(cell[key] ??= []).push(t.s)
    }
    const join = (k: string) => (cell[k] ?? []).join(' ').trim()

    const note = join('Note')
    const m = note.match(/inizio settore\s+(.+)/i)
    if (m) currentSector = m[1].trim()

    const via = join('Via')
    if (!via) continue

    rows.push({
      Falesia: cragName,
      Settore: currentSector,
      Via: via,
      Grado: join('Grado'),
      Proposto: join('Proposto'),
      Note: note,
      Bellezza: join('Bellezza'),
    })
  }

  if (rows.length === 0) throw new Error('Nessuna via riconosciuta nel PDF.')
  return { headers, rows }
}
