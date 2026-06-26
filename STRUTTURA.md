# Struttura del progetto — Capital Climbing

> Aggiornato automaticamente. Esegui `npm run structure` per rigenerare.
> Ultimo aggiornamento: 26/06/2026, 10:59:36

## Come leggere questo file

Ogni riga mostra un file o una cartella con la sua funzione.
Le cartelle in **grassetto** contengono altri file.

---

```
Capital Climbing/
├── **.github/**
│   └── **workflows/**
│       └── deploy.yml
├── **istruzioni/**  — Tutta la documentazione e le specifiche del progetto
│   ├── 00_AUDIT_BLOCCO0.md  — Stato del progetto dopo il Blocco 0
│   ├── 00_START_HERE.md  — Punto di partenza e ordine di lettura
│   ├── 01_PRODUCT_REQUIREMENTS.md  — Requisiti funzionali del prodotto
│   ├── 02_TECH_ARCHITECTURE.md  — Architettura tecnica e stack
│   ├── 03_DATABASE_SCHEMA.md  — Schema completo del database
│   ├── 04_SECURITY_AND_RLS.md  — Sicurezza e Row Level Security
│   ├── 05_AUTH_AND_USERS.md  — Autenticazione e profili utente
│   ├── 06_CATALOG_AND_IMPORT.md  — Catalogo falesie e import CSV
│   ├── 07_LOGBOOK_AND_SCORING.md  — Logbook e sistema di punteggio
│   ├── 08_ANALYTICS.md  — Statistiche e grafici
│   ├── 09_GITHUB_AND_DEPLOY.md  — GitHub Pages e GitHub Actions
│   ├── 10_IMPLEMENTATION_ROADMAP.md  — Roadmap a blocchi (0→13)
│   ├── 11_CLAUDE_CODE_PROMPTS.md  — Prompt da usare con Claude Code
│   ├── 12_RELEASE_CHECKLIST.md  — Checklist pre-rilascio
│   ├── 13_DATA_SOURCES_AND_LEGAL.md  — Fonti dati e aspetti legali
│   ├── 14_CRAGS_PAGE_SPEC.md  — Specifica tecnica pagina Falesie
│   ├── CLAUDE.md  — Regole permanenti per Claude Code
│   └── crag_catalog_template.csv  — Template CSV per importare falesie
├── **public/**  — File statici serviti direttamente (icone, favicon)
│   ├── favicon.svg
│   └── icons.svg
├── **scripts/**  — Script di utilità per il progetto
│   └── update-structure.mjs  — Genera STRUTTURA.md aggiornato
├── **src/**  — Codice sorgente dell'app React
│   ├── **app/**  — Router principale e provider globali
│   │   └── App.tsx  — Entry point React: definisce tutte le route
│   ├── **assets/**
│   ├── **components/**  — Componenti UI riutilizzabili (sidebar, layout, bottoni)
│   │   ├── Layout.css
│   │   └── Layout.tsx  — Struttura pagina: sidebar + area principale
│   ├── **features/**  — Logica divisa per dominio funzionale
│   │   ├── **admin/**  — Pannello admin: CRUD catalogo e import CSV
│   │   ├── **analytics/**  — Grafici e statistiche personali
│   │   ├── **ascents/**  — Registrazione salite personali
│   │   ├── **auth/**  — Login, registrazione, logout, sessione
│   │   ├── **catalog/**  — Visualizzazione falesie, settori e vie
│   │   ├── **projects/**  — Vie in progetto (non ancora salite)
│   │   ├── **sessions/**  — Sessioni di allenamento
│   │   └── **users/**  — Profili utente pubblici e ricerca
│   ├── **hooks/**  — Custom React hooks riutilizzabili
│   ├── **lib/**  — Librerie e connessioni esterne
│   │   └── supabase.ts  — Client Supabase (usa variabili d'ambiente)
│   ├── **routes/**  — Una pagina per ogni schermata dell'app
│   │   ├── AdminImportPage.tsx  — Import CSV falesie
│   │   ├── AdminPage.tsx  — Pannello amministrazione
│   │   ├── AnalyticsPage.tsx  — Grafici e analisi
│   │   ├── CragDetailPage.tsx  — Dettaglio falesia con settori e vie
│   │   ├── DashboardPage.tsx  — Dashboard con KPI personali
│   │   ├── ExplorePage.tsx  — Esplora il catalogo falesie
│   │   ├── LoginPage.tsx  — Pagina login
│   │   ├── MyRoutesPage.tsx  — Le mie vie (logbook personale)
│   │   ├── ProjectsPage.tsx  — Vie in progetto attive
│   │   ├── RegisterPage.tsx  — Pagina registrazione
│   │   ├── RouteDetailPage.tsx  — Dettaglio via con storico personale
│   │   ├── SessionsPage.tsx  — Sessioni di allenamento
│   │   ├── SettingsPage.tsx  — Impostazioni account
│   │   ├── UserProfilePage.tsx  — Profilo pubblico di un utente
│   │   └── UsersPage.tsx  — Ricerca utenti
│   ├── **schemas/**  — Schemi di validazione Zod
│   ├── **services/**  — Funzioni di accesso al database Supabase
│   ├── **styles/**  — CSS globale
│   │   └── global.css  — Reset e variabili CSS globali
│   ├── **test/**  — Test automatici con Vitest
│   │   ├── app.test.tsx  — Test base dell'app
│   │   └── setup.ts  — Configurazione ambiente di test
│   ├── **types/**  — Definizioni TypeScript condivise
│   │   └── database.ts
│   └── main.tsx
├── **supabase/**  — Configurazione database Supabase
│   └── **migrations/**  — Migrazioni SQL versionate (una per ogni modifica al DB)
│       ├── 001_schema.sql
│       ├── 002_rls.sql
│       └── 003_seed_demo.sql
├── .gitignore  — File e cartelle esclusi da GitHub
├── .oxlintrc.json  — Configurazione linter (Oxlint)
├── index.html  — Pagina HTML base dell'app React
├── package.json  — Dipendenze npm e script di sviluppo
├── README.md  — Panoramica del progetto per i collaboratori
├── STRUTTURA.md  — Questo file — mappa aggiornata del progetto
├── tsconfig.app.json  — Configurazione TypeScript per il codice app
├── tsconfig.json  — Configurazione TypeScript (root)
├── tsconfig.node.json  — Configurazione TypeScript per Vite/Node
└── vite.config.ts  — Configurazione Vite e Vitest
```

---

## Dove guardare per cosa

| Voglio… | Vado in… |
|---------|----------|
| Modificare una pagina | `src/routes/` |
| Aggiungere logica (es. salvataggio dati) | `src/features/<area>/` |
| Creare un componente grafico | `src/components/` |
| Cambiare il database | `supabase/migrations/` |
| Leggere le specifiche | `istruzioni/` |
| Vedere il prototipo originale | `legacy/` |
| Aggiungere un tipo TypeScript | `src/types/` |
| Aggiungere una chiamata API | `src/services/` |
| Scrivere un test | `src/test/` |

## Blocchi di sviluppo completati

- [x] Blocco 0 — Audit e setup repository
- [x] Blocco 1 — Scaffold React + TypeScript + Vite
- [ ] Blocco 2 — Schema database Supabase
- [ ] Blocco 3 — Autenticazione
- [ ] Blocco 4 — Catalogo falesie
- [ ] Blocco 5 — Admin CRUD
- [ ] Blocco 6 — Import CSV
- [ ] Blocco 7 — Ascensioni
- [ ] Blocco 8 — Progetti
- [ ] Blocco 9 — Utenti e profili
- [ ] Blocco 10 — Analisi e grafici
- [ ] Blocco 11 — Migrazione logbook
- [ ] Blocco 12 — Deploy GitHub Pages
- [ ] Blocco 13 — Audit finale
