# Stato corrente — Blocco 0 Audit

Data: 2026-06-26

## Repository

- URL: https://github.com/fladifoai/capital-climbing
- Visibilità: privato
- Branch: master (da rinominare in main)

## Prototipi esistenti

Conservati in `legacy/`:

| File | Descrizione |
|------|-------------|
| `legacy/index.html` | Prototipo principale, ~1500 righe, app completa in singolo file HTML. Dati in localStorage + Supabase magic-link aggiunto in fase di audit. |
| `legacy/climbtrack_v2.html` | Versione alternativa del prototipo. |

Il prototipo copre: dashboard KPI, vie, falesie, sessioni, progetti, analisi, archivio. Dati inizializzati da `SEED_DATA` hardcoded.

## Struttura attuale

```
capital-climbing/
├── legacy/
│   ├── index.html
│   └── climbtrack_v2.html
├── istruzioni/          # documentazione di progetto
├── docs/
│   └── current-state.md
├── .gitignore
└── (nessuna app React ancora)
```

## Credenziali / segreti

- La `VITE_SUPABASE_PUBLISHABLE_KEY` (anon key) è hardcoded in `legacy/index.html` — accettabile per il prototipo legacy, **non** da replicare nella nuova app.
- La nuova app userà variabili d'ambiente (`VITE_SUPABASE_URL`, `VITE_SUPABASE_PUBLISHABLE_KEY`) mai committate.
- Nessuna service role key nel repository. ✓

## Supabase

- Progetto: `apfyktdacsklnptcgjko`
- URL: `https://apfyktdacsklnptcgjko.supabase.co`
- Tabella `app_state` creata per il prototipo legacy (schema semplice, un blob JSON per utente).
- Schema definitivo da creare nel Blocco 2 con migrazioni versionate.

## Stack attuale (legacy)

- HTML + CSS + JavaScript vanilla
- Chart.js per i grafici
- localStorage per la persistenza
- Supabase JS SDK (aggiunto in audit) per auth e cloud sync

## Stack target

Vedi `istruzioni/02_TECH_ARCHITECTURE.md`.

## Prossimo passo

Blocco 1 — scaffold React + TypeScript + Vite.
