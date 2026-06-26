# ClimbTrack — Start Here

## Scopo

Questo pacchetto contiene le istruzioni operative per trasformare il prototipo attuale di ClimbTrack in una piattaforma web multiutente.

## Ordine di lettura

1. `CLAUDE.md`
2. `01_PRODUCT_REQUIREMENTS.md`
3. `02_TECH_ARCHITECTURE.md`
4. `03_DATABASE_SCHEMA.md`
5. `04_SECURITY_AND_RLS.md`
6. `05_AUTH_AND_USERS.md`
7. `06_CATALOG_AND_IMPORT.md`
8. `07_LOGBOOK_AND_SCORING.md`
9. `08_ANALYTICS.md`
10. `09_GITHUB_AND_DEPLOY.md`
11. `10_IMPLEMENTATION_ROADMAP.md`
12. `11_CLAUDE_CODE_PROMPTS.md`
13. `12_RELEASE_CHECKLIST.md`

## Primo comando per Claude Code

```text
Leggi CLAUDE.md e tutti i file Markdown numerati presenti nella root.

Esegui esclusivamente il BLOCCO 0 descritto in
10_IMPLEMENTATION_ROADMAP.md.

Non cancellare o sovrascrivere il prototipo esistente.
Non iniziare il blocco successivo.

Alla fine dammi:
1. riepilogo;
2. file modificati;
3. comandi eseguiti;
4. test;
5. passaggi manuali;
6. problemi rimasti.
```

## Regola di lavoro

Procedere un blocco alla volta.

Dopo ogni blocco Claude Code deve eseguire:

```bash
npm run lint
npm run typecheck
npm run test
npm run build
```

## Passaggi che richiedono intervento manuale

- creazione progetto Supabase;
- creazione repository GitHub;
- login Supabase CLI;
- login GitHub CLI o Git;
- inserimento variabili ambiente;
- assegnazione iniziale del ruolo admin;
- configurazione GitHub Pages;
- conferma importazioni reali.

## Segreti da non condividere

Non inserire in chat o nel repository:

- password;
- service role key;
- secret key;
- token GitHub;
- token Supabase;
- backup contenenti dati reali.
