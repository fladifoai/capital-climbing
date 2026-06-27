# PDF Import Report

Generated: 2026-06-27 (manual extraction from PDFs)
Source: `C:\Users\fladi\OneDrive\Desktop\Claude\Capital climbing\Lista Falesie\`

> This report is a static summary of the manual PDF extraction process.
> Run `npm run import:pdf-crags` to regenerate dynamically from the JSON files.

---

## Summary

| Crag | Region | Province | Sectors | Routes |
|------|--------|----------|---------|--------|
| Caprile | Lazio | Frosinone | 4 | 98 |
| Collepardo | Lazio | Frosinone | 2 | 58 |
| Configni | Lazio | Rieti | 6 | 53 |
| La Fortezza | Lazio | Rieti | 1 | 66 |
| Grotti | Lazio | Rieti | 1 | 27 |
| Norma | Lazio | Latina | 1 | 92 |
| Ferentillo | Umbria | Terni | 1 | 44 |
| Tagliacozzo | Abruzzo | L'Aquila | 4 | 74 |
| Pietrasecca | Abruzzo | L'Aquila | 1 | 104 |
| Petrella Liri | Abruzzo | L'Aquila | 2 | 194 |
| Colle dell'Orso | Molise | Isernia | 2 | 59 |
| Miollet | Valle d'Aosta | Aosta | 1 | 20 |
| Ulassai | Sardegna | Nuoro | 20 | 777 |
| Ussassai | Sardegna | Nuoro | 3 | 71 |

**Total: 14 crags, 49 sectors, 1741 routes**

---

## Files Generated

All JSON files written to `src/data/crags/italia/` following the structure:
`{region}/{province}/{crag}/{crag}_{sector-slug}.json`

### Lazio / Frosinone / Caprile
- `caprile/caprile_le-canne.json` — 15 routes
- `caprile/caprile_i-gradoni.json` — 26 routes
- `caprile/caprile_eremo.json` — 37 routes
- `caprile/caprile_le-grandi-panze.json` — 20 routes

### Lazio / Frosinone / Collepardo
- `collepardo/collepardo_cueva.json` — 40 routes
- `collepardo/collepardo_cuevita.json` — 18 routes

### Lazio / Rieti / Configni
- `configni/configni_settore-a.json` — 20 routes
- `configni/configni_settore-b.json` — 5 routes
- `configni/configni_placca-rossa.json` — 10 routes
- `configni/configni_settore-c.json` — 13 routes
- `configni/configni_settore-d.json` — 3 routes
- `configni/configni_settore-e.json` — 5 routes
- `configni/configni_settore-f.json` — 2 routes

### Lazio / Rieti / La Fortezza
- `la-fortezza/la-fortezza_principale.json` — 66 routes

### Lazio / Rieti / Grotti
- `grotti/grotti_grotti-bassa-nuovo-settore.json` — 27 routes

### Lazio / Latina / Norma
- `norma/norma_placche-rosse.json` — 92 routes

### Umbria / Terni / Ferentillo
- `ferentillo/ferentillo_gabbio.json` — 44 routes

### Abruzzo / L'Aquila / Tagliacozzo
- `tagliacozzo/tagliacozzo_estrema-sinistra.json` — 8 routes
- `tagliacozzo/tagliacozzo_grande-tetto.json` — 38 routes
- `tagliacozzo/tagliacozzo_scudo-centrale.json` — 22 routes
- `tagliacozzo/tagliacozzo_estrema-destra.json` — 6 routes

### Abruzzo / L'Aquila / Pietrasecca
- `pietrasecca/pietrasecca_vena-cionca.json` — 104 routes

### Abruzzo / L'Aquila / Petrella Liri
- `petrella-liri/petrella-liri_petrella-alta.json` — 144 routes
- `petrella-liri/petrella-liri_placche-di-bini.json` — 50 routes

### Molise / Isernia / Colle dell'Orso
- `colle-dellorso/colle-dellorso_blocco-p.json` — 24 routes
- `colle-dellorso/colle-dellorso_blocco-q.json` — 35 routes

### Valle d'Aosta / Aosta / Miollet
- `miollet/miollet_destro.json` — 20 routes

### Sardegna / Nuoro / Ulassai
- `ulassai/ulassai_il-canyon.json` — 156 routes
- `ulassai/ulassai_torre-dei-venti.json` — 45 routes
- `ulassai/ulassai_su-casteddu.json` — 104 routes
- `ulassai/ulassai_vivendum.json` — 21 routes
- `ulassai/ulassai_the-frame.json` — 27 routes
- `ulassai/ulassai_opera.json` — 22 routes
- `ulassai/ulassai_scala-e-predi.json` — 25 routes
- `ulassai/ulassai_the-cave-theleme.json` — 14 routes
- `ulassai/ulassai_inquietudini.json` — 4 routes
- `ulassai/ulassai_is-janas.json` — 33 routes
- `ulassai/ulassai_el-dorado.json` — 20 routes
- `ulassai/ulassai_sopravento.json` — 12 routes
- `ulassai/ulassai_sa-matta-prana.json` — 27 routes
- `ulassai/ulassai_scala-ussassa.json` — 28 routes
- `ulassai/ulassai_baccili.json` — 28 routes
- `ulassai/ulassai_s-assa-bella.json` — 31 routes
- `ulassai/ulassai_su-fundu.json` — 63 routes
- `ulassai/ulassai_cave-of-dreams.json` — 34 routes
- `ulassai/ulassai_marosini.json` — 27 routes
- `ulassai/ulassai_wallstreet.json` — 19 routes
- `ulassai/ulassai_la-piramide.json` — 6 routes
- `ulassai/ulassai_lecorci.json` — 84 routes

### Sardegna / Nuoro / Ussassai
- `ussassai/ussassai_guglie-di-niala.json` — 8 routes
- `ussassai/ussassai_irtzioni.json` — 33 routes
- `ussassai/ussassai_fundu-e-s-unturgiu.json` — 30 routes

---

## Extraction Notes

- **Only `name` and `grade` extracted** — no stars, repetitions, comments, beauty, descriptions, personal data
- **Grade column used**: Grado column only (not Proposto/community grades)
- **Grade normalization**: "Progetto", "N.D.", "Sconosciuto" → null; decimal grades (e.g. 6c.3) skipped; slash grades (6c+/7a) kept as-is
- **Sector detection**: "Inizio settore X" or "Inizio Blocco X" in Note column
- **Missing route numbers**: preserved as-is (some PDFs have gaps, e.g. Petrella Alta #7, Cuevita #54)
- **Duplicate route numbers**: all sub-entries included as separate routes (e.g. Ulassai Il Canyon #94, #97)
