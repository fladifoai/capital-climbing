import { readdirSync, statSync, writeFileSync } from 'fs'
import { join, relative } from 'path'

const ROOT = process.cwd()

const IGNORE = new Set([
  'node_modules', '.git', 'dist', 'dist-ssr', 'coverage',
  '.env.local', 'package-lock.json',
])

const DESCRIPTIONS = {
  'src':                    'Codice sorgente dell\'app React',
  'src/app':                'Router principale e provider globali',
  'src/app/App.tsx':        'Entry point React: definisce tutte le route',
  'src/components':         'Componenti UI riutilizzabili (sidebar, layout, bottoni)',
  'src/components/Layout.tsx': 'Struttura pagina: sidebar + area principale',
  'src/features':           'Logica divisa per dominio funzionale',
  'src/features/auth':      'Login, registrazione, logout, sessione',
  'src/features/catalog':   'Visualizzazione falesie, settori e vie',
  'src/features/ascents':   'Registrazione salite personali',
  'src/features/projects':  'Vie in progetto (non ancora salite)',
  'src/features/sessions':  'Sessioni di allenamento',
  'src/features/users':     'Profili utente pubblici e ricerca',
  'src/features/analytics': 'Grafici e statistiche personali',
  'src/features/admin':     'Pannello admin: CRUD catalogo e import CSV',
  'src/routes':             'Una pagina per ogni schermata dell\'app',
  'src/routes/LoginPage.tsx':      'Pagina login',
  'src/routes/RegisterPage.tsx':   'Pagina registrazione',
  'src/routes/DashboardPage.tsx':  'Dashboard con KPI personali',
  'src/routes/ExplorePage.tsx':    'Esplora il catalogo falesie',
  'src/routes/CragDetailPage.tsx': 'Dettaglio falesia con settori e vie',
  'src/routes/RouteDetailPage.tsx':'Dettaglio via con storico personale',
  'src/routes/MyRoutesPage.tsx':   'Le mie vie (logbook personale)',
  'src/routes/SessionsPage.tsx':   'Sessioni di allenamento',
  'src/routes/ProjectsPage.tsx':   'Vie in progetto attive',
  'src/routes/AnalyticsPage.tsx':  'Grafici e analisi',
  'src/routes/UsersPage.tsx':      'Ricerca utenti',
  'src/routes/UserProfilePage.tsx':'Profilo pubblico di un utente',
  'src/routes/SettingsPage.tsx':   'Impostazioni account',
  'src/routes/AdminPage.tsx':      'Pannello amministrazione',
  'src/routes/AdminImportPage.tsx':'Import CSV falesie',
  'src/lib':                'Librerie e connessioni esterne',
  'src/lib/supabase.ts':    'Client Supabase (usa variabili d\'ambiente)',
  'src/hooks':              'Custom React hooks riutilizzabili',
  'src/schemas':            'Schemi di validazione Zod',
  'src/services':           'Funzioni di accesso al database Supabase',
  'src/styles':             'CSS globale',
  'src/styles/global.css':  'Reset e variabili CSS globali',
  'src/types':              'Definizioni TypeScript condivise',
  'src/test':               'Test automatici con Vitest',
  'src/test/setup.ts':      'Configurazione ambiente di test',
  'src/test/app.test.tsx':  'Test base dell\'app',
  'supabase':               'Configurazione database Supabase',
  'supabase/migrations':    'Migrazioni SQL versionate (una per ogni modifica al DB)',
  'public':                 'File statici serviti direttamente (icone, favicon)',
  'legacy':                 'Prototipo HTML originale (conservato, non usato)',
  'legacy/index.html':      'Prototipo completo con Supabase auth integrato',
  'legacy/climbtrack_v2.html': 'Versione alternativa del prototipo',
  'istruzioni':             'Tutta la documentazione e le specifiche del progetto',
  'istruzioni/CLAUDE.md':   'Regole permanenti per Claude Code',
  'istruzioni/00_AUDIT_BLOCCO0.md': 'Stato del progetto dopo il Blocco 0',
  'istruzioni/00_START_HERE.md':    'Punto di partenza e ordine di lettura',
  'istruzioni/01_PRODUCT_REQUIREMENTS.md': 'Requisiti funzionali del prodotto',
  'istruzioni/02_TECH_ARCHITECTURE.md':    'Architettura tecnica e stack',
  'istruzioni/03_DATABASE_SCHEMA.md':      'Schema completo del database',
  'istruzioni/04_SECURITY_AND_RLS.md':     'Sicurezza e Row Level Security',
  'istruzioni/05_AUTH_AND_USERS.md':       'Autenticazione e profili utente',
  'istruzioni/06_CATALOG_AND_IMPORT.md':   'Catalogo falesie e import CSV',
  'istruzioni/07_LOGBOOK_AND_SCORING.md':  'Logbook e sistema di punteggio',
  'istruzioni/08_ANALYTICS.md':            'Statistiche e grafici',
  'istruzioni/09_GITHUB_AND_DEPLOY.md':    'GitHub Pages e GitHub Actions',
  'istruzioni/10_IMPLEMENTATION_ROADMAP.md':'Roadmap a blocchi (0→13)',
  'istruzioni/11_CLAUDE_CODE_PROMPTS.md':  'Prompt da usare con Claude Code',
  'istruzioni/12_RELEASE_CHECKLIST.md':    'Checklist pre-rilascio',
  'istruzioni/13_DATA_SOURCES_AND_LEGAL.md':'Fonti dati e aspetti legali',
  'istruzioni/14_CRAGS_PAGE_SPEC.md':      'Specifica tecnica pagina Falesie',
  'istruzioni/crag_catalog_template.csv':  'Template CSV per importare falesie',
  'scripts':                'Script di utilità per il progetto',
  'scripts/update-structure.mjs': 'Genera STRUTTURA.md aggiornato',
  'index.html':             'Pagina HTML base dell\'app React',
  'package.json':           'Dipendenze npm e script di sviluppo',
  'vite.config.ts':         'Configurazione Vite e Vitest',
  'tsconfig.json':          'Configurazione TypeScript (root)',
  'tsconfig.app.json':      'Configurazione TypeScript per il codice app',
  'tsconfig.node.json':     'Configurazione TypeScript per Vite/Node',
  '.gitignore':             'File e cartelle esclusi da GitHub',
  '.oxlintrc.json':         'Configurazione linter (Oxlint)',
  'README.md':              'Panoramica del progetto per i collaboratori',
  'STRUTTURA.md':           'Questo file — mappa aggiornata del progetto',
}

function getDesc(relPath) {
  return DESCRIPTIONS[relPath] ?? ''
}

function buildTree(dir, prefix = '', relBase = '') {
  const entries = readdirSync(dir)
    .filter(n => !IGNORE.has(n) && !n.startsWith('.env'))
    .sort((a, b) => {
      const aIsDir = statSync(join(dir, a)).isDirectory()
      const bIsDir = statSync(join(dir, b)).isDirectory()
      if (aIsDir !== bIsDir) return aIsDir ? -1 : 1
      return a.localeCompare(b)
    })

  let out = ''
  entries.forEach((name, i) => {
    const fullPath = join(dir, name)
    const relPath = relBase ? `${relBase}/${name}` : name
    const isLast = i === entries.length - 1
    const connector = isLast ? '└── ' : '├── '
    const childPrefix = isLast ? '    ' : '│   '
    const isDir = statSync(fullPath).isDirectory()
    const desc = getDesc(relPath)
    const label = isDir ? `**${name}/**` : name
    out += `${prefix}${connector}${label}${desc ? `  — ${desc}` : ''}\n`
    if (isDir) {
      out += buildTree(fullPath, prefix + childPrefix, relPath)
    }
  })
  return out
}

const now = new Date().toLocaleString('it-IT', { timeZone: 'Europe/Rome' })
const tree = buildTree(ROOT)

const content = `# Struttura del progetto — Capital Climbing

> Aggiornato automaticamente. Esegui \`npm run structure\` per rigenerare.
> Ultimo aggiornamento: ${now}

## Come leggere questo file

Ogni riga mostra un file o una cartella con la sua funzione.
Le cartelle in **grassetto** contengono altri file.

---

\`\`\`
Capital Climbing/
${tree}\`\`\`

---

## Dove guardare per cosa

| Voglio… | Vado in… |
|---------|----------|
| Modificare una pagina | \`src/routes/\` |
| Aggiungere logica (es. salvataggio dati) | \`src/features/<area>/\` |
| Creare un componente grafico | \`src/components/\` |
| Cambiare il database | \`supabase/migrations/\` |
| Leggere le specifiche | \`istruzioni/\` |
| Vedere il prototipo originale | \`legacy/\` |
| Aggiungere un tipo TypeScript | \`src/types/\` |
| Aggiungere una chiamata API | \`src/services/\` |
| Scrivere un test | \`src/test/\` |

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
`

writeFileSync(join(ROOT, 'STRUTTURA.md'), content, 'utf8')
console.log(`STRUTTURA.md aggiornato (${now})`)
