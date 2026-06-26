# Catalogo e importazione

## Gerarchia

```text
Falesia
  └── Settore
        └── Via
```

## Catalogo globale

Tutti possono leggere.

Solo gli amministratori possono:

- creare;
- aggiornare;
- eliminare;
- importare;
- gestire alias;
- gestire fonti.

## Import CSV

Flusso:

1. selezione file;
2. parsing;
3. mapping colonne;
4. anteprima;
5. validazione;
6. normalizzazione;
7. errori per riga;
8. controllo duplicati;
9. possibili alias;
10. scelta azione;
11. conferma;
12. importazione;
13. report.

## Azioni sui conflitti

```text
update
keep
alias
ignore
```

## Campi obbligatori

```text
crag_name
crag_country
sector_name
route_name
official_grade
source_name
permission_status
```

## Normalizzazione

Nomi:

- lowercase per chiave di confronto;
- rimozione accenti;
- rimozione punteggiatura non significativa;
- spazi compressi;
- nome originale sempre conservato.

Gradi:

- lowercase;
- rimozione spazi;
- mappatura varianti;
- errore se non riconosciuto.

## Regole legali e di provenienza

Ogni record deve conservare:

```text
source_name
source_url
source_license
permission_status
```

Non importare automaticamente:

- commenti;
- fotografie;
- topos;
- descrizioni protette;
- dati da fonti non autorizzate.

## Idempotenza

Ricaricare lo stesso file non deve creare duplicati.

## Revisione

I record ambigui non devono essere uniti automaticamente.
Devono essere marcati per revisione.
