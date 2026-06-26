# Release checklist

## Codice

- [ ] lint superato
- [ ] typecheck superato
- [ ] test superati
- [ ] build superata
- [ ] nessun `any` non giustificato
- [ ] error state presenti
- [ ] loading state presenti
- [ ] empty state presenti

## Sicurezza

- [ ] RLS attiva su tutte le tabelle
- [ ] nessuna service role key nel frontend
- [ ] nessuna password nel repository
- [ ] utente A non modifica B
- [ ] dati privati non visibili
- [ ] admin non autoassegnabile
- [ ] catalogo scrivibile solo dagli admin

## Catalogo

- [ ] import idempotente
- [ ] duplicati rilevati
- [ ] alias revisionabili
- [ ] fonti conservate
- [ ] licenza conservata
- [ ] permesso conservato
- [ ] nessun commento o topo non autorizzato

## Logbook

- [ ] snapshot grado
- [ ] scoring testato
- [ ] progetti esclusi dai KPI
- [ ] visibilità pubblica/privata
- [ ] modifica solo proprietario

## Utenti

- [ ] registrazione
- [ ] conferma email
- [ ] login
- [ ] logout
- [ ] recupero password
- [ ] ricerca utenti
- [ ] profili pubblici
- [ ] email mai pubblica

## Deploy

- [ ] workflow GitHub Actions
- [ ] GitHub Pages configurato
- [ ] HashRouter funzionante
- [ ] asset corretti
- [ ] variabili configurate
- [ ] repository senza dati personali
