# Climbook Importer

Script Python per importare in Capital Climbing i dati delle falesie personali da Climbook.

## Scope

Scarica **solo** le falesie presenti nel logbook personale e le vie dei relativi settori.
Non fa scraping massivo. Non richiede login.

## Prerequisiti

```bash
cd capital-climbing/scripts/climbook_importer
pip install -r requirements.txt
```

Python 3.10+ richiesto.

## File di input richiesti

```
data/import/capital_climbing_falesie_settori.md
data/import/capital_climbing_vie_scalate.md
```

## Comandi

### Dry run (consigliato per iniziare)
```bash
python run.py --dry-run
```
Non fa richieste HTTP. Mostra i target, stima il numero di richieste, genera `climbook_targets.csv`.

### Importa 1 falesia di test
```bash
python run.py --crag "Pietrasecca"
```
Scarica solo la falesia Pietrasecca (Vena Cionca) con tutte le sue vie.

### Importa prime N falesie
```bash
python run.py --max-crags 3
```

### Importa tutto (con cache)
```bash
python run.py --use-cache
```

### Re-scarica senza cache
```bash
python run.py --refresh-cache
```

## Output

| File | Contenuto |
|---|---|
| `data/raw/climbook_targets.csv` | Lista falesie target estratta dai file Markdown |
| `data/raw/climbook_pages_cache/` | Cache HTML delle pagine scaricate |
| `data/raw/climbook_scrape_raw.json` | Dati grezzi JSON per falesia |
| `data/processed/climbook_crags_sectors_routes.csv` | CSV finale importabile |
| `data/processed/climbook_crags_sectors_routes.json` | JSON finale |
| `data/processed/climbook_import_report.md` | Report con statistiche e problemi |

## Struttura moduli

| File | Responsabilità |
|---|---|
| `config.py` | Costanti, path, ID noti |
| `parse_targets.py` | Parsing file Markdown di input |
| `climbook_client.py` | HTTP client educato (rate limit, cache, retry) |
| `parsers.py` | Parser HTML pagine Climbook |
| `normalizers.py` | Normalizzazione nomi per matching |
| `matcher.py` | Fuzzy matching falesie/vie |
| `export.py` | Scrittura CSV/JSON/report |
| `run.py` | Entry point CLI |

## Comportamento educato

- Delay 3-5s tra richieste
- Cache locale (evita doppi download)
- Max 2 retry su errore
- User-Agent: `CapitalClimbingPersonalImporter/0.1`
- Nessun login, nessun bypass, nessun proxy

## Note legali

Vedere `SCRAPING_NOTES.md` nella root del progetto.
