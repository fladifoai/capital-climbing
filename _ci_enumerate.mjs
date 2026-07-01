// Enumera falesie per regione dalle region page HTML di Climbook.
// Output: out/crags.json = [{id, slug, name, region, url, printUrl}]
import { readFile, writeFile } from 'node:fs/promises'

const W = process.argv[2]
const REGIONS = [
  { id: 1, key: 'lazio', name: 'Lazio' },
  { id: 2, key: 'umbria', name: 'Umbria' },
  { id: 3, key: 'abruzzo', name: 'Abruzzo' },
  { id: 4, key: 'molise', name: 'Molise' },
]

const decode = (s) => s
  .replace(/&#0?39;/g, "'").replace(/&amp;/g, '&')
  .replace(/&quot;/g, '"').replace(/&agrave;/g, 'à').replace(/&egrave;/g, 'è')
  .replace(/&eacute;/g, 'é').replace(/&igrave;/g, 'ì').replace(/&ograve;/g, 'ò')
  .replace(/&ugrave;/g, 'ù').replace(/&lt;/g, '<').replace(/&gt;/g, '>')
  .replace(/&nbsp;/g, ' ').trim()

const all = []
const seen = new Set()
for (const reg of REGIONS) {
  const html = await readFile(`${W}/regions/${reg.key}.html`, 'utf-8')
  // ogni riga: <a href=".../falesie/ID/SLUG" class="text-lg">NAME</a>
  const re = /href="https:\/\/climbook\.com\/falesie\/(\d+)\/([a-z0-9-]+)"[^>]*class="text-lg"[^>]*>([^<]*)</g
  let m, n = 0
  while ((m = re.exec(html))) {
    const [, id, slug, rawName] = m
    if (slug.match(/\/(vie|ripetizioni|classifica)/)) continue
    if (seen.has(id)) continue
    seen.add(id)
    all.push({
      id: Number(id), slug, name: decode(rawName), region: reg.name,
      url: `https://climbook.com/falesie/${id}/${slug}`,
      printUrl: `https://climbook.com/falesie/${id}/${slug}/vie/print`,
    })
    n++
  }
  console.log(`${reg.name}: ${n} falesie`)
}
all.sort((a, b) => a.region.localeCompare(b.region) || a.name.localeCompare(b.name))
await writeFile(`${W}/out/crags.json`, JSON.stringify(all, null, 2))
console.log(`TOTALE: ${all.length} falesie -> out/crags.json`)
