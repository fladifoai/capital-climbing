# Import Conflicts

> Run `npm run import:crags-to-db --dry-run` to detect conflicts before writing to the database.

This file tracks known conflicts or ambiguities found during the PDF extraction and import process.

---

## Known Issues

### Missing route numbers (PDF gaps)

| Crag | Sector | Missing # | Notes |
|------|--------|-----------|-------|
| Petrella Liri | Petrella Alta | #7 | PDF numbering jumps 6→8, route simply absent |
| Collepardo | Cuevita | #54 | PDF numbering jumps 53→55, route simply absent |

### Duplicate route numbers (PDF ambiguity)

| Crag | Sector | Duplicate # | Resolution |
|------|--------|-------------|------------|
| Ulassai | Il Canyon | #94 | Two sub-entries both included as separate routes |
| Ulassai | Il Canyon | #97 | Two sub-entries both included as separate routes |

### Routes with null grade

Routes where grade is `null` in the JSON represent:
- Routes marked "Progetto" (project, not yet graded)
- Routes marked "N.D." (non disponibile)
- Routes marked "Sconosciuto"
- Multi-pitch combinations without an independent grade

These are imported with `grade: null` and will not appear in grade-filtered views.

### Sector detection notes

| Crag | PDF | Sector boundaries detected via |
|------|-----|-------------------------------|
| Collepardo | Collepardo.pdf | "Inizio settore Cueva" / "Inizio settore Cuevita" in Note column |
| Colle dell'Orso | ColleDelOrso.pdf | "Inizio Blocco P" / "Inizio Blocco Q" in Note column |
| Tagliacozzo | Tagliacozzo.pdf | "Inizio settore Estrema Sinistra" etc. in Note column |
| Ulassai | Ulassai_TheFrame_Opera.pdf | Two sectors in one PDF, detected by header row |
| Configni | Configni.pdf | 6 sectors (A/B/Placca Rossa/C/D/E/F) in one PDF |

---

## Resolved

No conflicts resolved yet. Run `npm run import:crags-to-db --dry-run` after installing dependencies to identify DB-level duplicates.
