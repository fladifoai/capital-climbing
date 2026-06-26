# CLAUDE.md — Istruzioni permanenti

## Comportamento

Prima di modificare il progetto:

1. ispeziona il repository;
2. leggi tutti i file Markdown numerati;
3. preserva il prototipo;
4. verifica lo stato Git;
5. esegui solo il blocco richiesto;
6. aggiungi test;
7. esegui lint, typecheck, test e build;
8. fermati.

Non procedere automaticamente al blocco seguente.

## Obiettivo

ClimbTrack deve offrire:

- catalogo globale di falesie, settori e vie;
- importazione CSV;
- utenti multipli;
- profili pubblici e ricercabili;
- dati personali modificabili solo dal proprietario;
- catalogo modificabile solo dagli amministratori;
- ascensioni, progetti, sessioni, tentativi e beta;
- statistiche e grafici;
- deploy tramite GitHub.

Non implementare:

- follower;
- feed;
- like;
- messaggi;
- commenti social;
- ranking globale.

## Stack obbligatorio

- React;
- TypeScript strict;
- Vite;
- React Router con HashRouter;
- TanStack Query;
- React Hook Form;
- Zod;
- Recharts;
- Papa Parse;
- Supabase Auth;
- Supabase PostgreSQL;
- Row Level Security;
- GitHub Pages;
- GitHub Actions.

Non creare FastAPI nell'MVP.

## Sicurezza

- mai service role key nel frontend;
- mai password o token nel repository;
- RLS su tutte le tabelle esposte;
- usare `auth.uid()` nelle policy;
- non fidarsi di `user_id` inviato dal browser;
- ruolo admin in tabella separata;
- catalogo leggibile da tutti e modificabile solo dagli admin;
- dati personali pubblici solo se `visibility = 'public'`;
- dati personali modificabili solo dal proprietario;
- email non pubblica;
- ogni modifica DB in una migrazione SQL.

## Qualità

- evitare `any`;
- componenti piccoli;
- validazione Zod;
- loading, error ed empty states;
- test per scoring, normalizzazione, import e autorizzazioni;
- testi UI in italiano;
- nomi tecnici in inglese;
- README aggiornato.
