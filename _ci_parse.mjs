// Parsa tutti i PDF Climbook /vie/print scaricati -> JSON + CSV + report.
// Porta la logica di src/features/crag-import/pdf.ts (stesso layout colonne).
import { readFile, writeFile } from 'node:fs/promises'
import { existsSync } from 'node:fs'
import { getDocument } from 'pdfjs-dist/legacy/build/pdf.mjs'

const W = process.argv[2]
const crags = JSON.parse(await readFile(`${W}/out/crags.json`, 'utf-8'))

const COL_KEYS = {
  '#': 'num', nome: 'Via', grado: 'Grado', proposto: 'Proposto',
  ripetizioni: 'Ripetizioni', note: 'Note', bellezza: 'Bellezza',
}
const isStars = (s) => /^[★☆]+$/.test(s.trim())

async function extractLines(buf) {
  const doc = await getDocument({ data: buf, isEvalSupported: false }).promise
  const allLines = []
  for (let p = 1; p <= doc.numPages; p++) {
    const page = await doc.getPage(p)
    const content = await page.getTextContent()
    const byY = new Map()
    for (const it of content.items) {
      if (!it.str.trim()) continue
      const y = Math.round(it.transform[5])
      if (!byY.has(y)) byY.set(y, [])
      byY.get(y).push({ x: it.transform[4], s: it.str })
    }
    const ys = [...byY.keys()].sort((a, b) => b - a)
    for (const y of ys) allLines.push(byY.get(y).sort((a, b) => a.x - b.x))
  }
  return allLines
}

function parseLines(allLines) {
  if (!allLines.length) throw new Error('vuoto')
  const cragLine = allLines[0].map(t => t.s).join(' ').trim()
  const paren = cragLine.match(/\(([^)]*)\)/)?.[1]?.trim() ?? ''
  const defaultSector = paren && !paren.includes(',') ? paren : ''

  let headerIdx = -1, columns = []
  for (let i = 0; i < allLines.length; i++) {
    const text = allLines[i].map(t => t.s.toLowerCase()).join(' ')
    if (text.includes('nome') && text.includes('grado')) {
      headerIdx = i
      columns = allLines[i]
        .map(t => ({ key: COL_KEYS[t.s.trim().toLowerCase()] ?? null, x: t.x }))
        .filter(c => c.key !== null).sort((a, b) => a.x - b.x)
      break
    }
  }
  if (headerIdx === -1 || columns.length < 2) throw new Error('header non trovato')

  const colFor = (x) => {
    let key = columns[0].key
    for (const c of columns) { if (x >= c.x - 4) key = c.key; else break }
    return key
  }

  const routes = []
  let currentSector = defaultSector
  for (let i = headerIdx + 1; i < allLines.length; i++) {
    const line = allLines[i]
    const first = line[0]?.s.trim() ?? ''
    if (!/^\d+$/.test(first)) continue
    const cell = {}
    for (const t of line) {
      const key = isStars(t.s) ? 'Bellezza' : colFor(t.x)
      ;(cell[key] ??= []).push(t.s)
    }
    const join = (k) => (cell[k] ?? []).join(' ').trim()
    const note = join('Note')
    const m = note.match(/inizio settore\s+(.+)/i)
    if (m) currentSector = m[1].trim()
    const via = join('Via')
    if (!via) continue
    const grado = join('Grado')
    routes.push({
      name: via,
      sector: currentSector || '',
      grade: grado === 'N.D.' ? '' : grado,
      proposed: join('Proposto') === 'N.D.' ? '' : join('Proposto'),
      note,
      stars: (join('Bellezza').match(/[★]/g) || []).length,
    })
  }
  return { cragLine, routes }
}

const outCrags = []
const csv = ['region,crag_id,crag_name,sector,route_name,grade,proposed,stars']
const report = { total: crags.length, parsed: 0, noPdf: 0, parseFail: 0, zeroRoutes: 0,
  totalRoutes: 0, byRegion: {}, fails: [], empties: [] }
const esc = (s) => `"${String(s ?? '').replace(/"/g, '""')}"`

for (const c of crags) {
  const path = `${W}/pdfs/${c.id}.pdf`
  const R = (report.byRegion[c.region] ??= { crags: 0, routes: 0 })
  if (!existsSync(path)) { report.noPdf++; report.fails.push(`${c.region} | ${c.name} (${c.id}) | NO PDF`); continue }
  let parsed
  try {
    const buf = new Uint8Array(await readFile(path))
    const lines = await extractLines(buf)
    parsed = parseLines(lines)
  } catch (e) {
    report.parseFail++; report.fails.push(`${c.region} | ${c.name} (${c.id}) | PARSE: ${e.message}`); continue
  }
  report.parsed++
  const sectors = {}
  for (const r of parsed.routes) (sectors[r.sector] ??= []).push(r)
  outCrags.push({ ...c, cragLinePdf: parsed.cragLine,
    sectorCount: Object.keys(sectors).length, routeCount: parsed.routes.length,
    sectors: Object.entries(sectors).map(([name, rs]) => ({ name, routes: rs })) })
  report.totalRoutes += parsed.routes.length
  R.crags++; R.routes += parsed.routes.length
  if (parsed.routes.length === 0) { report.zeroRoutes++; report.empties.push(`${c.region} | ${c.name} (${c.id})`) }
  for (const r of parsed.routes)
    csv.push([esc(c.region), c.id, esc(c.name), esc(r.sector), esc(r.name), esc(r.grade), esc(r.proposed), r.stars].join(','))
}

await writeFile(`${W}/out/crags_full.json`, JSON.stringify(outCrags, null, 2))
await writeFile(`${W}/out/routes.csv`, csv.join('\n'))
const md = [
  '# Report scraping falesie Centro Italia', '',
  `Generato: ${new Date().toISOString()}`, '',
  `- Falesie totali (enumerate): **${report.total}**`,
  `- Falesie parsate: **${report.parsed}**`,
  `- Vie totali: **${report.totalRoutes}**`,
  `- Senza PDF: ${report.noPdf}`,
  `- Parse falliti: ${report.parseFail}`,
  `- Falesie con 0 vie: ${report.zeroRoutes}`, '',
  '## Per regione', '',
  '| Regione | Falesie | Vie |', '|---|---|---|',
  ...Object.entries(report.byRegion).map(([k, v]) => `| ${k} | ${v.crags} | ${v.routes} |`), '',
  '## Falesie con 0 vie', '', ...(report.empties.length ? report.empties.map(e => `- ${e}`) : ['(nessuna)']), '',
  '## Falliti / senza PDF', '', ...(report.fails.length ? report.fails.map(e => `- ${e}`) : ['(nessuno)']),
].join('\n')
await writeFile(`${W}/out/report.md`, md)
console.log(`Parsate ${report.parsed}/${report.total}, vie ${report.totalRoutes}. Fail ${report.parseFail}, noPdf ${report.noPdf}, zero ${report.zeroRoutes}`)
