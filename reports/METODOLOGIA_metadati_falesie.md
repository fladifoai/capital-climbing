# Metodologia metadati falesie — accuratezza & reperimento dati

**Progetto:** Capital Climbing
**Data:** 2026-07-01
**Ambito:** esposizione, orario sole, stagione/periodo migliore, coordinate, quota — catalogo falesie/settori (prod Supabase `apfyktdacsklnptcgjko`).

---

## 0. Sintesi

Partiti da esposizione al 33% (stima DEM), portata all'**80% verificata da fonti reali** + aggiunti orario del sole e periodo migliore da temperatura reale. Tutto automatico (nessun inserimento manuale), tracciabile e reversibile.

| Campo | Copertura | Note accuratezza |
|---|---|---|
| Coordinate | 460/474 (97%) | corrette ma livello-AREA (~200m dalla parete) |
| Quota (m) | 460/474 (97%) | deriva dalla coord |
| Esposizione | 509/595 (86%) | 475 (80%) da web reale, resto stima DEM |
| Stagione | 593/595 (99%) | derivata esposizione+quota |
| Orario sole | 518/595 (87%) | 195 reale, 323 derivato da esposizione |
| Best_months (temp) | in scrittura | modello Open-Meteo, ~1h (attesa quota) |

---

## 1. VERIFICA ACCURATEZZA (come abbiamo controllato)

### 1.1 Coordinate / quota (dati preesistenti)
- Query prod: range lat/lon dentro il bounding box della nazione → **0 falesie fuori regione**.
- Spot-check contro coordinate reali note: Sperlonga, Collepardo, Norma, Ferentillo, Ulassai, Caimari, Cala Magraner, Pizzoferrato, Miollet → **tutte corrette**.
- Altitudine: range 15–2347 m, **0 valori assurdi** (<0 o >3500).
- **Limite individuato:** coordinate a livello-AREA, non per-settore. 221 falesie condividono 48 punti (tutti i settori di un'area sullo stesso punto). Precisione ~200 m dalla parete. La quota eredita lo stesso livello.

### 1.2 Esposizione / stagione / sole
- Validazione dominio: solo valori cardinali validi (N/S/E/O/NE/SE/NO/SO + `varie`), **0 spazzatura**.
- Coerenza incrociata: esposizione ↔ orario sole ↔ stagione devono combaciare (es. S → sole 11→tramonto → invernale a bassa quota).
- **Falesie multi-parete** (gole, canyon, campi di massi, anfiteatri) riconosciute e marcate `varie` invece di forzare un orientamento unico falso (Colle dell'Orso, Ulassai, Roccamorice, Pennadomo, Lisciano, Amelia Blocchi Poligonali, ...).
- **Correzioni al vecchio DEM** trovate incrociando con fonti reali:
  - Oratino La Rocca: SW → **N** (mai sole, muro W usabile)
  - Ovindoli: estate → **mezze stagioni** ("bolle d'estate" malgrado 1390 m)
  - + decine di stime DEM sostituite con dati reali.
- Campo `orientation_verified` (bool): **true** = dato da web reale, **null** = stima DEM. Distingue accurato da stima.

### 1.3 Best_months (temperatura)
- Modello validato su **campione** prima del write completo: Sperlonga=inverno, alta quota=estate, Ferentillo=mezze → coerente col reale.

---

## 2. COME ABBIAMO TROVATO I DATI (reperimento)

### 2.1 Fonti esposizione — la scoperta chiave
- **Bloccate al fetch diretto (HTTP 403):** falesia.it, planetmountain.com, gulliver.it, thecrag.com — le più ricche.
- **Aggiramento:** lo **snippet di Google** riporta comunque il contenuto di quelle pagine → si legge dai risultati ricerca, non dalla pagina bloccata.
- **Fetchabili diretti:** thetopo.com (ex-27crags), abruzzoverticale.it — strutturati e per-settore.
- **climbook** (lo scraper del progetto): NON contiene esposizione, solo l'elenco vie → ecco perché il dato mancava.
- **Regola permessi utente:** nessun nome di sito salvato in DB — solo "web/google" generico.

### 2.2 Metodo esposizione (~200 falesie, provincia per provincia)
1. `WebSearch "<falesia> arrampicata esposizione settori orientamento"` per ogni falesia.
2. Estrazione da snippet: orientamento + orario sole + stagione.
3. Regola morfologica (senza cercare): gola/canyon/grotta/boulder/anfiteatro → `varie`.
4. Regola quota: alta (>1000 m) → estate anche se soleggiata; bassa S/SW → inverno.
5. Scrittura in DB con **backup pre-scrittura** (`_orientation_backup`) per rollback.
- Ordine lavorazione: Molise → Umbria → Abruzzo → Lazio (province: Roma, Viterbo, Rieti, Frosinone, Latina) → Sardegna/Baleari/estero.

### 2.3 Metodo orario sole (`sun_notes`)
- **195 settori** con **orario reale** dalle ricerche. Esempi:
  - Grotti: "estate ombra fino ~12; estrema sx fino 13:30"
  - Norma: "sole dalle 11 al tramonto"
  - Tagliacozzo: "sole mattino, ombra dopo le 15"
  - Roccamorice: "sole mattino, ombra sera salvo Giallon/Buconi/Ghaza/Placche"
  - Ulassai: "estate ombra da 13, inverno sole da 10:30; Torre dei Venti fresca per brezza"
- **323 settori** con timing **derivato** dall'esposizione (deterministico), taggati "(da esposizione)":
  - E/SE/NE = mattino, S = 11→tramonto, W/SW = pomeriggio, N = ombra, varie = qualche settore al sole a ogni ora.

### 2.4 Metodo best_months (periodo migliore da temperatura)
- Script Node + **Open-Meteo** (API storica meteo, gratuita, senza chiave, dati aperti ERA5).
- Per la coordinata di ogni falesia: temperatura giornaliera max/min + radiazione solare, 2022–2024.
- **Temp diurna** (ore di arrampicata) = 0.66·max + 0.34·min — non la media 24h (che sottostima di ~5°C).
- **Boost solare da radiazione reale** × fattore esposizione = temperatura **percepita dal climber** sulla parete.
- **Comfort** per mese: ideale ~12°C percepito, buono 4–20°C, caldo penalizzato più del freddo.
- Output: mesi con comfort ≥ 0.6 = `best_months` (csv 1–12).
- Note tecniche: TLS-off solo in run locale su dati aperti; rate-limit Open-Meteo gestito con batch multi-coordinata + backoff.

---

## 3. CAMPI DB (prod Supabase)

Tabella `public.sectors`:
- `orientation` — N/S/E/O/NE/SE/NO/SO/varie
- `sun_morning`, `sun_afternoon` — si/no/parziale
- `best_season` — estate/inverno/mezze stagioni
- `orientation_verified` (NUOVO) — bool: true=web reale, null=stima DEM
- `sun_notes` (NUOVO) — testo orario sole (reale o "(da esposizione)")
- `best_months` (NUOVO) — mesi migliori csv, da temperatura Open-Meteo

Tabella `public.crags`: `latitude`, `longitude`, `altitude_m`.

Backup: `public._orientation_backup` — valori pre-scrittura per rollback.

Migration correlata: `039_sector_season_metadata.sql` (sun/season score su sectors).

---

## 4. LIMITI NOTI / MIGLIORABILE
- **Coord livello-area** (non per-parete): migliorabile solo con GPS per-settore → non automatizzabile senza intervento manuale/OSM.
- **~86 esposizioni mancanti**: falesie minori + estero senza dato pubblico online.
- **Estero debole**: Comunità Valenciana (0/11), Hautes-Alpes (0/12 web).
- **323 orari "derivati"** non hanno l'ora pubblicata: migliorabili ri-cercando falesia per falesia (automatico, molti turni).
- Grandi falesie multi-settore (Ulassai 22, Configni 12) hanno esposizione crag-level, non per-singolo-settore.

---

## 5. SCRIPT / FILE
- `data/crags-metadata/` — pipeline arricchimento (gitignored).
- Script best_months: Node + Open-Meteo (scratchpad di sessione).
- Memoria progetto: `OneDrive\Desktop\Claude\Capital climbing\Memoria\AI_PROJECT_MEMORY.md`.

---

## 6. IDEE UI (prossimo)
- Badge "verificato ✓ / stima" da `orientation_verified`.
- Mostrare `sun_notes` e `best_months` nella pagina falesia (es. barra mesi colorata per comfort).
