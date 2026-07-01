import { getDocument } from 'pdfjs-dist/legacy/build/pdf.mjs'
const buf = new Uint8Array(await (await import('node:fs/promises')).readFile(process.argv[2]))
const doc = await getDocument({ data: buf, isEvalSupported:false }).promise
console.log('pages', doc.numPages)
for (let p=1;p<=Math.min(doc.numPages,2);p++){
  const page=await doc.getPage(p); const c=await page.getTextContent()
  const byY=new Map()
  for(const it of c.items){ if(!it.str.trim())continue; const y=Math.round(it.transform[5]); (byY.get(y)??byY.set(y,[]).get(y)).push({x:Math.round(it.transform[4]),s:it.str}) }
  const ys=[...byY.keys()].sort((a,b)=>b-a)
  for(const y of ys){ const line=byY.get(y).sort((a,b)=>a.x-b.x); console.log(y, JSON.stringify(line.map(t=>`${t.x}:${t.s}`))) }
}
