---
dataset: capital_climbing_crags_and_sectors
version: 1
generated_at: 2026-06-26
crag_count: 22
sector_records: 35
---

# Capital Climbing — Falesie e settori

Catalogo geografico normalizzato delle falesie presenti nel logbook. È strutturato per essere usato come seed del catalogo globale `crags -> sectors -> routes`.

## Regole di importazione

- `crag_id` e `sector_id` sono identificativi stabili suggeriti per il seed.
- `sector_status = exact` indica che il settore è associato esplicitamente alle ascensioni.
- `sector_status = candidate` indica che la sorgente elenca più settori senza dire in quale si trovi la singola via.
- `sector_status = unknown` indica che il settore non è disponibile.
- I campi con `da verificare` non devono essere trasformati in dati definitivi senza controllo.
- Il catalogo contiene soltanto le falesie presenti nelle ascensioni dell'utente; non è il catalogo completo di tutte le vie della falesia.

## Falesie

| crag_id | country | region | province_or_island | municipality | crag_name | aliases | sectors | ascent_records | unique_routes_climbed | canonical_records | review_records | geo_confidence |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| CRAG-001 | Spagna | Isole Baleari | Mallorca | Selva (località Caimari) | Caimari | Les Perxes; Comuna de Caimari | Adalt; Adalt de Tot; Es Raconet; Placa Rotja | 3 | 3 | 2 | 1 | media |
| CRAG-002 | Spagna | Isole Baleari | Mallorca | Manacor | Cala Magraner | — | Estrema Sinistra; Pipiricot; Sense Voler; Xorics | 3 | 3 | 3 | 0 | alta |
| CRAG-003 | Italia | Lazio | Frosinone | Roccasecca (frazione Caprile) | Caprile | Braciere dei Poveri | I Gradoni; Le Grandi Panze | 3 | 3 | 3 | 0 | alta |
| CRAG-004 | Italia | Molise | Isernia | Frosolone | Colle dell'Orso | Morgia Quadra; Falesia di Frosolone | Blocco P, Q - Morgia Quadra | 6 | 6 | 6 | 0 | alta |
| CRAG-005 | Italia | Lazio | Frosinone | Collepardo | Collepardo | — | Cueva; Cuevita | 7 | 7 | 7 | 0 | alta |
| CRAG-006 | Italia | Lazio | Rieti | Configni | Configni | — | Non specificato | 4 | 4 | 4 | 0 | alta |
| CRAG-007 | Spagna | Isole Baleari | Mallorca | Artà | Ermita de Betlem | Ermita de Belén | Non specificato | 1 | 1 | 0 | 1 | alta |
| CRAG-008 | Italia | Umbria | Terni | Ferentillo | Ferentillo | — | Gabbio | 2 | 2 | 2 | 0 | alta |
| CRAG-009 | Italia | Lazio | Frosinone | Roccasecca (da verificare) | Fraioli | — | Non specificato | 1 | 1 | 1 | 0 | media |
| CRAG-010 | Italia | Lazio | Rieti | Cittaducale (località Grotti) | Grotti | Grotti Bassa | Grotti Bassa - Nuovo Settore | 2 | 2 | 2 | 0 | alta |
| CRAG-011 | Italia | Lazio | Rieti | da verificare | La Fortezza | — | Non specificato | 7 | 6 | 6 | 1 | media |
| CRAG-012 | Italia | Valle d'Aosta | Aosta | Valgrisenche (La Béthaz) | Miollet | Miollet Alta; Bethaz alta | Destro | 1 | 1 | 1 | 0 | alta |
| CRAG-013 | Italia | Lazio | Latina | Norma | Norma | — | Placche Rosse | 3 | 3 | 3 | 0 | alta |
| CRAG-014 | Italia | Abruzzo | L'Aquila | Ovindoli | Ovindoli | — | Val d'Arano | 2 | 2 | 2 | 0 | alta |
| CRAG-015 | Italia | Abruzzo | L'Aquila | Cappadocia (frazione Petrella Liri) | Petrella Liri | — | Petrella Alta; Placche di Bini | 8 | 8 | 8 | 0 | alta |
| CRAG-016 | Italia | Abruzzo | L'Aquila | Carsoli (frazione Pietrasecca) | Pietrasecca | — | Vena Cionca | 8 | 8 | 7 | 1 | alta |
| CRAG-017 | Italia | Abruzzo | Chieti | Pizzoferrato | Pizzoferrato | — | Non specificato | 1 | 1 | 1 | 0 | alta |
| CRAG-018 | Italia | Lazio | Roma | Allumiere | Ripa Majala | Ripa Maiale | Non specificato | 8 | 8 | 8 | 0 | alta |
| CRAG-019 | Italia | Lazio | Roma | Subiaco | Subiaco | — | Regno dei Ragni | 1 | 1 | 1 | 0 | alta |
| CRAG-020 | Italia | Abruzzo | L'Aquila | Tagliacozzo | Tagliacozzo | — | Estrema destra; Estrema sinistra; Grande tetto; Scudo centrale | 6 | 6 | 6 | 0 | alta |
| CRAG-021 | Spagna | Isole Baleari | Mallorca | da verificare | Tijuana | — | Non specificato | 3 | 3 | 0 | 3 | media |
| CRAG-022 | Italia | Sardegna | Nuoro | Ulassai | Ulassai | — | Il Canyon; Torre dei Venti | 7 | 7 | 7 | 0 | alta |

## Settori

| sector_id | crag_id | crag_name | sector_name | sector_status | exact_ascent_records | import_note |
|---|---|---|---|---|---|---|
| SECTOR-001 | CRAG-001 | Caimari | Adalt | candidate | 0 | Settore presente nella lista della falesia; via non ancora collegata al settore preciso. |
| SECTOR-002 | CRAG-001 | Caimari | Adalt de Tot | candidate | 0 | Settore presente nella lista della falesia; via non ancora collegata al settore preciso. |
| SECTOR-003 | CRAG-001 | Caimari | Es Raconet | candidate | 0 | Settore presente nella lista della falesia; via non ancora collegata al settore preciso. |
| SECTOR-004 | CRAG-001 | Caimari | Placa Rotja | candidate | 0 | Settore presente nella lista della falesia; via non ancora collegata al settore preciso. |
| SECTOR-005 | CRAG-002 | Cala Magraner | Estrema Sinistra | candidate | 0 | Settore presente nella lista della falesia; via non ancora collegata al settore preciso. |
| SECTOR-006 | CRAG-002 | Cala Magraner | Pipiricot | candidate | 0 | Settore presente nella lista della falesia; via non ancora collegata al settore preciso. |
| SECTOR-007 | CRAG-002 | Cala Magraner | Sense Voler | candidate | 0 | Settore presente nella lista della falesia; via non ancora collegata al settore preciso. |
| SECTOR-008 | CRAG-002 | Cala Magraner | Xorics | candidate | 0 | Settore presente nella lista della falesia; via non ancora collegata al settore preciso. |
| SECTOR-009 | CRAG-003 | Caprile | I Gradoni | exact | 2 | Settore esplicitamente presente nella sorgente dell'ascensione. |
| SECTOR-010 | CRAG-003 | Caprile | Le Grandi Panze | exact | 1 | Settore esplicitamente presente nella sorgente dell'ascensione. |
| SECTOR-011 | CRAG-004 | Colle dell'Orso | Blocco P, Q - Morgia Quadra | exact | 6 | Settore esplicitamente presente nella sorgente dell'ascensione. |
| SECTOR-012 | CRAG-005 | Collepardo | Cueva | candidate | 0 | Settore presente nella lista della falesia; via non ancora collegata al settore preciso. |
| SECTOR-013 | CRAG-005 | Collepardo | Cuevita | candidate | 0 | Settore presente nella lista della falesia; via non ancora collegata al settore preciso. |
| SECTOR-014 | CRAG-006 | Configni | Non specificato | unknown | 0 | Settore non specificato nel logbook. |
| SECTOR-015 | CRAG-007 | Ermita de Betlem | Non specificato | unknown | 0 | Settore non specificato nel logbook. |
| SECTOR-016 | CRAG-008 | Ferentillo | Gabbio | exact | 2 | Settore esplicitamente presente nella sorgente dell'ascensione. |
| SECTOR-017 | CRAG-009 | Fraioli | Non specificato | unknown | 0 | Settore non specificato nel logbook. |
| SECTOR-018 | CRAG-010 | Grotti | Grotti Bassa - Nuovo Settore | exact | 2 | Settore esplicitamente presente nella sorgente dell'ascensione. |
| SECTOR-019 | CRAG-011 | La Fortezza | Non specificato | unknown | 0 | Settore non specificato nel logbook. |
| SECTOR-020 | CRAG-012 | Miollet | Destro | exact | 1 | Settore esplicitamente presente nella sorgente dell'ascensione. |
| SECTOR-021 | CRAG-013 | Norma | Placche Rosse | exact | 3 | Settore esplicitamente presente nella sorgente dell'ascensione. |
| SECTOR-022 | CRAG-014 | Ovindoli | Val d'Arano | exact | 2 | Settore esplicitamente presente nella sorgente dell'ascensione. |
| SECTOR-023 | CRAG-015 | Petrella Liri | Petrella Alta | exact | 4 | Settore esplicitamente presente nella sorgente dell'ascensione. |
| SECTOR-024 | CRAG-015 | Petrella Liri | Placche di Bini | exact | 4 | Settore esplicitamente presente nella sorgente dell'ascensione. |
| SECTOR-025 | CRAG-016 | Pietrasecca | Vena Cionca | exact | 8 | Settore esplicitamente presente nella sorgente dell'ascensione. |
| SECTOR-026 | CRAG-017 | Pizzoferrato | Non specificato | unknown | 0 | Settore non specificato nel logbook. |
| SECTOR-027 | CRAG-018 | Ripa Majala | Non specificato | unknown | 0 | Settore non specificato nel logbook. |
| SECTOR-028 | CRAG-019 | Subiaco | Regno dei Ragni | exact | 1 | Settore esplicitamente presente nella sorgente dell'ascensione. |
| SECTOR-029 | CRAG-020 | Tagliacozzo | Estrema destra | candidate | 0 | Settore presente nella lista della falesia; via non ancora collegata al settore preciso. |
| SECTOR-030 | CRAG-020 | Tagliacozzo | Estrema sinistra | candidate | 0 | Settore presente nella lista della falesia; via non ancora collegata al settore preciso. |
| SECTOR-031 | CRAG-020 | Tagliacozzo | Grande tetto | candidate | 0 | Settore presente nella lista della falesia; via non ancora collegata al settore preciso. |
| SECTOR-032 | CRAG-020 | Tagliacozzo | Scudo centrale | candidate | 0 | Settore presente nella lista della falesia; via non ancora collegata al settore preciso. |
| SECTOR-033 | CRAG-021 | Tijuana | Non specificato | unknown | 0 | Settore non specificato nel logbook. |
| SECTOR-034 | CRAG-022 | Ulassai | Il Canyon | exact | 5 | Settore esplicitamente presente nella sorgente dell'ascensione. |
| SECTOR-035 | CRAG-022 | Ulassai | Torre dei Venti | exact | 2 | Settore esplicitamente presente nella sorgente dell'ascensione. |

## Normalizzazioni principali

| Nome sorgente | Nome canonico | Nota |
|---|---|---|
| Frosolone, Colle dell'Orso | Colle dell'Orso | `Frosolone` è il comune; `Colle dell'Orso` è la falesia. |
| Valgrisenche / Miollet | Miollet | `Valgrisenche` è il comune/area; `Destro` è il settore. |
| Mallorca, Caimari | Caimari | Località di Mallorca; i settori sono registrati separatamente. |
| Mallorca, Cala Magraner | Cala Magraner | Falesia costiera con più settori. |
| Grotti bassa | Grotti | `Grotti Bassa - Nuovo Settore` è il settore/area interna. |
| Placche di Bini | Petrella Liri | `Placche di Bini` è trattato come settore della falesia Petrella Liri. |
| Canyon Sa Tappara | Ulassai | Normalizzato come settore `Il Canyon`, mantenendo il nome locale come alias futuro. |

## Campi geografici da ricontrollare

- **La Fortezza:** regione e provincia sono identificate come Lazio/Rieti; il comune resta da verificare.
- **Fraioli:** associata provvisoriamente a Roccasecca, con confidenza media.
- **Tijuana:** falesia di Mallorca; il comune esatto non è stato determinato.
