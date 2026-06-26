# Requisiti di prodotto

## Visione

ClimbTrack è una piattaforma tecnica per registrare e analizzare l'arrampicata sportiva su falesia.

## Modello generale

```text
Catalogo globale
├── Falesie
├── Settori
└── Vie

Dati personali
├── Ascensioni
├── Sessioni
├── Tentativi
├── Progetti
├── Beta
└── Note tecniche
```

## Utente normale

Può:

- registrarsi;
- effettuare login;
- cercare utenti;
- visualizzare profili pubblici;
- esplorare il catalogo;
- registrare le proprie attività;
- modificare soltanto i propri dati;
- scegliere visibilità pubblica o privata.

Non può:

- modificare il catalogo globale;
- modificare dati altrui;
- importare cataloghi;
- assegnarsi privilegi.

## Amministratore

Può:

- creare e aggiornare falesie;
- creare settori;
- creare vie;
- importare CSV;
- gestire alias e duplicati;
- correggere il catalogo;
- gestire fonti e provenienza.

## Navigazione

- Dashboard
- Esplora
- Le mie vie
- Falesie
- Sessioni
- Progetti
- Analisi
- Utenti
- Profilo pubblico
- Impostazioni
- Amministrazione
- Importazione

## Regole funzionali

- il catalogo può contenere tutte le vie;
- il logbook personale mostra solo vie collegate a un'attività personale;
- i progetti non contribuiscono ai KPI prima della chiusura;
- ogni ascensione conserva uno snapshot del grado;
- i dati community restano separati da grado ufficiale e grado personale;
- nessuna funzione social tradizionale.
