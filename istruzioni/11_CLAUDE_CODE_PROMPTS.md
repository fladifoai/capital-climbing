# Prompt per Claude Code

## Prompt generico

```text
Leggi CLAUDE.md e tutti i file Markdown numerati.

Esegui esclusivamente il BLOCCO X di 10_IMPLEMENTATION_ROADMAP.md.

Prima:
- ispeziona il repository;
- preserva il prototipo;
- controlla Git;
- spiega cosa modificherai.

Durante:
- modifica solo quanto richiesto;
- aggiungi test;
- evita refactoring non necessari.

Dopo:
- esegui lint;
- esegui typecheck;
- esegui test;
- esegui build;
- riporta file modificati;
- riporta passaggi manuali;
- fermati.

Non iniziare il blocco successivo.
```

## Blocco 0

```text
Esegui esclusivamente il Blocco 0.
Non creare ancora la nuova applicazione.
Non cancellare file.
Crea docs/current-state.md e .gitignore.
```

## Blocco 1

```text
Esegui esclusivamente il Blocco 1.
Crea React + TypeScript + Vite.
Usa HashRouter.
Preserva legacy/.
Non collegare ancora Supabase.
```

## Blocco 2

```text
Esegui esclusivamente il Blocco 2.
Crea migrazioni Supabase, schema, trigger, funzione is_admin,
RLS e seed inventato.
Non inserire dati reali.
```

## Blocco 6

```text
Esegui esclusivamente il Blocco 6.
Usa crag_catalog_template.csv.
Crea importazione idempotente con preview, validazione,
duplicati, alias e report finale.
```

## Blocco 11

```text
Esegui esclusivamente il Blocco 11.
Crea uno script locale di dry-run per logbook_completo.md.
Non importare ancora.
Non committare dati personali o credenziali.
```

## Controllo errori

```text
Esegui:
npm run lint
npm run typecheck
npm run test
npm run build

Non nascondere gli errori.
Per ogni errore indicami:
- file;
- causa;
- correzione;
- stato finale.
```
