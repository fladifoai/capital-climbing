# ClimbTrack — Architettura della pagina Falesie ispirata alla logica di Climbook

> Specifica funzionale e tecnica per Claude Code  
> Obiettivo: adottare i punti forti della gerarchia di consultazione di Climbook senza copiarne grafica, testi, codice, dati o contenuti.

---

## 1. Principio generale

ClimbTrack deve avere una pagina principale chiamata:

```text
Falesie
```

Percorso:

```text
#/crags
```

La navigazione del catalogo deve seguire questa gerarchia:

```text
Falesie
└── Nazione
    └── Regione
        └── Area territoriale
            └── Falesia
                └── Settore
                    └── Via
```

Per la prima versione è presente una sola nazione:

```text
Italia
```

La struttura del database e del frontend deve comunque permettere di aggiungere altre nazioni in futuro.

---

## 2. Elementi osservati in Climbook da usare come ispirazione

Dall'analisi funzionale di Climbook risultano particolarmente efficaci:

1. una pagina generale che raggruppa il catalogo per Paese e Regione;
2. conteggi sintetici accanto a ogni livello territoriale;
3. una pagina regionale suddivisa in aree territoriali;
4. elenchi compatti delle falesie con numero di vie e attività;
5. breadcrumb che mostrano sempre la posizione nel catalogo;
6. una pagina dedicata alla singola falesia;
7. indicatori numerici immediatamente visibili;
8. una tabella ordinata delle vie;
9. separazione della pagina della falesia in sezioni o schede.

Questi principi possono essere adottati perché rappresentano normali soluzioni di organizzazione dell'informazione.

Non devono essere copiati:

- logo;
- nome;
- colori;
- tipografia;
- CSS;
- struttura HTML;
- testi;
- descrizioni;
- commenti;
- fotografie;
- dati;
- ordinamento proprietario;
- etichette identiche;
- interfaccia pixel per pixel.

ClimbTrack deve avere una propria identità grafica e una struttura dati più rigorosa.

---

## 3. Miglioramento fondamentale rispetto alla struttura osservata

In alcuni elenchi di Climbook il nome della falesia e i nomi dei settori vengono accorpati:

```text
Collepardo (Cueva, Cuevita)
Norma (Placche Rosse)
Massone (A, B, C, D)
```

ClimbTrack non deve usare questa soluzione come struttura interna.

La separazione corretta è:

```text
Falesia: Collepardo
├── Settore: Cueva
├── Settore: Cuevita
├── Settore: Classica
└── Settore: La Pala
```

Ogni livello deve avere:

- un proprio ID;
- un proprio nome;
- una propria pagina;
- propri dati;
- proprie relazioni;
- propri conteggi.

Il nome visualizzato della falesia non deve contenere l'elenco dei settori.

---

# 4. Pagina principale Falesie

Percorso:

```text
#/crags
```

## 4.1 Contenuto iniziale

Poiché nella prima versione esiste soltanto Italia, la pagina deve mostrare:

```text
Falesie
Nazione selezionata: Italia
```

Subito sotto deve essere mostrata la griglia o lista di tutte le regioni italiane.

Non è necessario obbligare l'utente ad aprire una card “Italia” prima di vedere le regioni.

Il selettore della nazione resta comunque visibile e pronto per l'espansione futura.

## 4.2 Intestazione

Mostrare:

- titolo “Falesie”;
- selettore nazione;
- ricerca globale;
- numero totale di regioni;
- numero totale di aree;
- numero totale di falesie;
- numero totale di settori;
- numero totale di vie.

Esempio:

```text
Italia

20 regioni
145 aree
1.240 falesie
4.870 settori
72.500 vie
```

I numeri devono provenire dal database e non essere inseriti manualmente.

## 4.3 Ricerca globale

La ricerca deve trovare:

- regioni;
- aree;
- falesie;
- settori;
- vie.

Ogni risultato deve specificare il tipo e il percorso.

Esempi:

```text
Collepardo
Falesia · Italia > Lazio > Frosinone

La Cueva
Settore · Italia > Lazio > Frosinone > Collepardo

Donkey Kong
Via · 7a+ · Italia > Lazio > Frosinone > Collepardo > La Cueva
```

La ricerca globale non sostituisce la navigazione gerarchica.

---

# 5. Elenco delle regioni italiane

Le regioni devono essere pre-caricate nel database:

```text
Abruzzo
Basilicata
Calabria
Campania
Emilia-Romagna
Friuli-Venezia Giulia
Lazio
Liguria
Lombardia
Marche
Molise
Piemonte
Puglia
Sardegna
Sicilia
Toscana
Trentino-Alto Adige
Umbria
Valle d'Aosta
Veneto
```

Ogni regione deve essere mostrata come card o riga.

## Dati della card regione

- nome;
- numero aree territoriali;
- numero falesie;
- numero settori;
- numero vie;
- eventuale tipo di roccia prevalente;
- eventuale grado minimo e massimo complessivo.

Esempio:

```text
Lazio

11 aree
192 falesie
430 settori
5.620 vie
Gradi: 3a–9a
```

## Ordinamenti

- alfabetico;
- più falesie;
- più vie;
- aggiornate recentemente.

L'ordinamento predefinito è alfabetico.

---

# 6. Pagina Regione

Percorso:

```text
#/crags/italy/regions/:regionSlug
```

Esempio:

```text
#/crags/italy/regions/lazio
```

## 6.1 Breadcrumb

```text
Falesie > Italia > Lazio
```

## 6.2 Raggruppamento per area territoriale

All'interno della regione, le falesie devono essere raggruppate in aree territoriali.

Esempi possibili:

```text
Agro Pontino
Frosinone
Roma
Rieti
Viterbo
```

L'area non deve essere obbligatoriamente una provincia amministrativa.

Può rappresentare:

- provincia;
- valle;
- isola;
- comprensorio;
- area di arrampicata;
- macrozona locale.

Per questo motivo la tabella deve chiamarsi genericamente:

```text
areas
```

e deve contenere anche:

```text
area_type
```

Valori possibili:

```text
province
climbing_area
valley
island
municipality_group
custom
```

## 6.3 Presentazione della regione

La pagina deve mantenere la chiarezza degli elenchi compatti osservati, ma con un'identità propria.

Ogni area deve essere una sezione espandibile:

```text
Frosinone
32 falesie · 85 settori · 1.240 vie

[elenco falesie]
```

## 6.4 Riga o card falesia

Mostrare:

- nome falesia;
- comune;
- numero settori;
- numero vie;
- intervallo gradi;
- tipo di roccia;
- numero di ascensioni pubbliche ClimbTrack;
- stato accesso;
- data ultima verifica.

Esempio:

```text
Collepardo
Comune: Collepardo
8 settori
142 vie
5c–8c
Calcare
1.820 ascensioni pubbliche
Accesso aperto
```

Non usare il numero di commenti come metrica primaria.

---

# 7. Pagina Area territoriale

Percorso facoltativo ma consigliato:

```text
#/crags/italy/regions/:regionSlug/areas/:areaSlug
```

Esempio:

```text
#/crags/italy/regions/lazio/areas/frosinone
```

## Breadcrumb

```text
Falesie > Italia > Lazio > Frosinone
```

## Contenuto

- descrizione sintetica dell'area;
- numero falesie;
- numero settori;
- numero vie;
- mappa futura;
- filtri;
- elenco falesie.

## Filtri

- nome;
- comune;
- roccia;
- esposizione;
- stagione;
- grado minimo;
- grado massimo;
- numero minimo di vie;
- avvicinamento;
- accesso aperto/limitato/chiuso.

---

# 8. Pagina della singola falesia

Percorso:

```text
#/crags/:cragSlug
```

oppure, se necessario per evitare collisioni:

```text
#/crags/:cragId/:cragSlug
```

## 8.1 Breadcrumb

```text
Falesie > Italia > Lazio > Frosinone > Collepardo
```

## 8.2 Intestazione

Mostrare:

- nome falesia;
- area;
- regione;
- nazione;
- comune;
- provincia;
- coordinate;
- altitudine;
- roccia;
- stato accesso;
- ultima verifica.

## 8.3 Indicatori sintetici

Ispirarsi al principio dei contatori immediati, ma usare metriche proprie:

```text
Settori
Vie
Ascensioni pubbliche
Utenti che hanno scalato qui
Progetti attivi pubblici
Ultimo aggiornamento
```

Esempio:

```text
8 settori
142 vie
3.850 ascensioni
620 climber
78 progetti pubblici
Aggiornata 12/06/2026
```

## 8.4 Schede della pagina

Usare schede proprie:

```text
Panoramica
Settori e vie
Attività
Statistiche
Sicurezza e accesso
Fonti
```

Non copiare esattamente le schede di Climbook.

## 8.5 Panoramica

Contiene:

- descrizione originale o autorizzata;
- accesso;
- parcheggio;
- avvicinamento;
- esposizione;
- stagioni;
- pioggia;
- servizi;
- coordinate;
- stato accesso;
- restrizioni;
- fonte e licenza;
- ultima verifica.

## 8.6 Settori e vie

Mostrare prima i settori.

Ogni settore deve avere:

- nome;
- ordine;
- orientamento;
- numero vie;
- grado minimo;
- grado massimo;
- lunghezza media;
- stile prevalente;
- accesso specifico.

Esempio:

```text
La Cueva
28 vie
6a–8a
Sud
Prevalenza strapiombo
```

Il click apre la pagina del settore.

---

# 9. Pagina del settore

Percorso:

```text
#/crags/:cragSlug/sectors/:sectorSlug
```

## Breadcrumb

```text
Falesie > Italia > Lazio > Frosinone > Collepardo > La Cueva
```

## Intestazione

- nome settore;
- falesia;
- orientamento;
- descrizione;
- accesso;
- numero vie;
- grado minimo e massimo;
- lunghezza minima e massima;
- ultima verifica.

## Tabella vie

La tabella deve mantenere la leggibilità compatta delle tabelle di catalogo, ma utilizzare campi propri.

Colonne MVP:

```text
Ordine
Via
Grado
Lunghezza
Spit
Inclinazione
Stile
Ascensioni
Azioni
```

Colonne future:

```text
Grado community
Bellezza community
Sicurezza
Kneepad
Prima salita
```

Esempio:

```text
1 | Via A       | 6a  | 18 m | 8  | Verticale   | Tecnica     | 42
2 | Via B       | 6b+ | 22 m | 10 | Strapiombo  | Resistenza  | 31
3 | Donkey Kong | 7a+ | 25 m | 11 | Strapiombo  | Potente     | 18
```

## Ordine fisico delle vie

Aggiungere in `routes`:

```text
line_order integer
```

Il campo rappresenta l'ordine fisico delle vie nel settore, per esempio da sinistra a destra.

L'ordine predefinito della tabella deve essere:

```text
line_order ASC
```

L'utente può cambiare ordinamento per:

- nome;
- grado;
- lunghezza;
- popolarità.

---

# 10. Pagina della via

Percorso:

```text
#/routes/:routeId/:routeSlug
```

Mostrare:

- nome;
- falesia;
- settore;
- ordine fisico;
- grado ufficiale;
- grado personale dell'utente;
- grado community futuro;
- lunghezza;
- spit;
- inclinazione;
- stile;
- prima salita;
- chiodatore;
- note autorizzate;
- fonti;
- attività pubbliche;
- pulsanti “Aggiungi salita” e “Aggiungi progetto”.

Non importare commenti o descrizioni di Climbook.

---

# 11. Database territoriale

## countries

```text
id uuid primary key
name text not null
iso2 text unique not null
slug text unique not null
created_at timestamptz
updated_at timestamptz
```

## regions

```text
id uuid primary key
country_id uuid references countries(id)
name text not null
normalized_name text not null
slug text not null
created_at timestamptz
updated_at timestamptz
```

Vincolo:

```text
unique(country_id, normalized_name)
unique(country_id, slug)
```

## areas

```text
id uuid primary key
region_id uuid references regions(id)
name text not null
normalized_name text not null
slug text not null
area_type text not null
description text
created_at timestamptz
updated_at timestamptz
```

Vincolo:

```text
unique(region_id, normalized_name)
unique(region_id, slug)
```

## crags

Campi territoriali:

```text
country_id uuid references countries(id)
region_id uuid references regions(id)
area_id uuid references areas(id)
province text
municipality text
```

`country_id`, `region_id` e `area_id` devono essere relazioni reali, non testi liberi.

## sectors

Aggiungere:

```text
sort_order integer
```

## routes

Aggiungere:

```text
line_order integer
position_label text
```

`line_order` determina l'ordine fisico delle vie nel settore.

---

# 12. Conteggi

I conteggi mostrati nelle pagine devono essere calcolati da query o viste.

Creare viste o query dedicate per:

```text
country_catalog_counts
region_catalog_counts
area_catalog_counts
crag_catalog_counts
sector_catalog_counts
```

Esempio dati regione:

```text
area_count
crag_count
sector_count
route_count
public_ascent_count
```

Non salvare manualmente conteggi che possono diventare incoerenti, salvo uso consapevole di viste materializzate aggiornate.

---

# 13. Importazione a blocchi di una falesia completa

L'unità di importazione non è la singola via.

L'unità è:

```text
Crag Import Package
```

Contiene:

```text
Nazione
Regione
Area
Falesia
Settori
Vie
Fonte
Permessi
```

Ogni caricamento amministrativo deve riguardare una falesia completa.

## Esempio logico

```text
Italia
└── Lazio
    └── Frosinone
        └── Collepardo
            ├── La Cueva
            │   ├── Via 1
            │   ├── Via 2
            │   └── Via 3
            ├── Cuevita
            │   ├── Via 1
            │   └── Via 2
            └── La Pala
                ├── Via 1
                └── Via 2
```

---

# 14. Formato consigliato per l'importazione

Per l'importazione di blocchi complessi, il formato consigliato è JSON gerarchico.

Esempio:

```json
{
  "country": {
    "name": "Italia",
    "iso2": "IT"
  },
  "region": {
    "name": "Lazio"
  },
  "area": {
    "name": "Frosinone",
    "type": "province"
  },
  "crag": {
    "name": "Collepardo",
    "municipality": "Collepardo",
    "province": "Frosinone",
    "latitude": null,
    "longitude": null,
    "altitude_m": null,
    "rock_type": "Calcare",
    "access_status": "open",
    "parking_notes": null,
    "access_notes": null,
    "approach_minutes": null,
    "orientation": null,
    "best_seasons": []
  },
  "sectors": [
    {
      "name": "La Cueva",
      "sort_order": 1,
      "orientation": null,
      "description": null,
      "routes": [
        {
          "name": "Via esempio",
          "official_grade": "6c",
          "line_order": 1,
          "length_m": null,
          "bolts": null,
          "angle": null,
          "route_type": "sport"
        }
      ]
    }
  ],
  "source": {
    "name": "Inserimento amministratore",
    "url": null,
    "license": null,
    "permission_status": "manual-original"
  }
}
```

## Perché JSON

Il JSON rappresenta chiaramente:

- una falesia;
- più settori;
- più vie in ogni settore;
- metadati comuni;
- fonte comune;
- gerarchia.

Un CSV piatto può restare disponibile come alternativa, ma richiede la ripetizione dei dati della falesia su ogni riga.

---

# 15. Import wizard

Percorso:

```text
#/admin/import/crag
```

Fasi:

```text
1. Seleziona file
2. Leggi struttura
3. Valida nazione e regione
4. Valida area
5. Valida falesia
6. Valida settori
7. Valida vie
8. Cerca duplicati
9. Mostra anteprima ad albero
10. Risolvi conflitti
11. Conferma
12. Importa in transazione
13. Mostra report
```

## Anteprima

```text
Italia
└── Lazio
    └── Frosinone
        └── Collepardo
            ├── La Cueva — 28 vie
            ├── Cuevita — 14 vie
            └── La Pala — 31 vie

Totale settori: 3
Totale vie: 73
Nuove vie: 68
Vie esistenti: 3
Possibili alias: 2
Errori: 0
```

## Transazione

L'importazione deve essere atomica:

```text
tutto importato
oppure
nessun dato pubblicato
```

In caso di errore:

```text
ROLLBACK
```

---

# 16. Duplicati

## Regione

Chiave logica:

```text
country_id + normalized_name
```

## Area

Chiave logica:

```text
region_id + normalized_name
```

## Falesia

Chiave logica:

```text
area_id + normalized_name
```

Aggiungere un controllo geografico se esistono coordinate.

## Settore

Chiave logica:

```text
crag_id + normalized_name
```

## Via

Chiave logica:

```text
sector_id + normalized_name
```

Per le vie usare anche:

- grado;
- line_order;
- lunghezza;
- alias;
- fonte.

Non unire automaticamente record ambigui.

---

# 17. Identità grafica ClimbTrack

La pagina deve essere ispirata alla chiarezza informativa, non alla grafica di Climbook.

Usare:

- card leggere;
- tipografia moderna;
- breadcrumb evidente;
- conteggi con badge;
- tabelle responsive;
- filtri laterali o superiori;
- colori ClimbTrack;
- ottima resa mobile;
- skeleton loading;
- empty state;
- error state.

Non riprodurre:

- layout identico;
- menu identico;
- tab identici;
- colori identici;
- tabelle identiche;
- testi identici.

---

# 18. Componenti React

Creare componenti riutilizzabili:

```text
CountrySelector
RegionGrid
RegionCard
AreaSection
AreaCard
CragList
CragCard
CragHeader
CragStats
CragTabs
SectorList
SectorCard
SectorHeader
RouteTable
RouteRow
CatalogBreadcrumbs
CatalogGlobalSearch
CragImportWizard
CragImportTreePreview
ImportConflictResolver
```

---

# 19. Query TanStack Query

Chiavi consigliate:

```text
['countries']
['regions', countryId]
['areas', regionId]
['crags', areaId, filters]
['crag', cragId]
['sectors', cragId]
['sector', sectorId]
['routes', sectorId, filters]
['catalog-search', searchText]
['catalog-counts', entityType, entityId]
```

Le query figlie devono essere abilitate solo dopo la disponibilità dell'ID padre.

---

# 20. Permessi

Lettura pubblica:

```text
countries
regions
areas
crags
sectors
routes
route_aliases
route_sources
```

Scrittura:

```text
solo admin
```

L'importazione:

```text
solo admin autenticato
```

La UI deve nascondere i comandi amministrativi agli utenti normali, ma la protezione definitiva deve essere RLS.

---

# 21. Criteri di accettazione

## Pagina Falesie

- [ ] Esiste `#/crags`.
- [ ] Italia è selezionata nella prima versione.
- [ ] Sono mostrate tutte le regioni italiane.
- [ ] Ogni regione mostra conteggi reali.
- [ ] La ricerca globale trova falesie, settori e vie.
- [ ] I risultati mostrano il percorso territoriale.

## Regione

- [ ] Le falesie sono raggruppate per area.
- [ ] Ogni area mostra conteggi.
- [ ] Ogni falesia mostra settori e vie.
- [ ] Sono disponibili filtri.
- [ ] Il breadcrumb è corretto.

## Falesia

- [ ] Falesia e settore sono entità separate.
- [ ] La pagina mostra indicatori sintetici.
- [ ] La pagina mostra tutti i settori.
- [ ] Ogni settore mostra conteggi e intervallo gradi.
- [ ] Accesso e sicurezza sono separati dai dati delle vie.

## Settore

- [ ] La pagina mostra tutte le vie.
- [ ] Le vie sono ordinate per `line_order`.
- [ ] La tabella è filtrabile e responsive.
- [ ] Ogni via apre una pagina dedicata.

## Importazione

- [ ] Si importa una falesia completa alla volta.
- [ ] Il file può contenere più settori.
- [ ] Ogni settore può contenere più vie.
- [ ] L'anteprima è gerarchica.
- [ ] I duplicati sono controllati a ogni livello.
- [ ] L'import è atomico.
- [ ] Gli errori producono rollback.
- [ ] Fonte e permessi vengono conservati.
- [ ] Nessun dato viene pubblicato prima della conferma.

---

# 22. Prompt finale per Claude Code

```text
Leggi CLAUDE.md e questo file.

Analizza il repository esistente e preserva il prototipo.

Implementa esclusivamente la nuova architettura della pagina Falesie
descritta in questo documento.

Prima crea un piano e mostra quali migrazioni, pagine, componenti,
query e test saranno necessari.

Implementa:

1. countries;
2. regions;
3. areas;
4. relazioni territoriali di crags;
5. seed Italia;
6. seed delle 20 regioni italiane;
7. pagina Falesie con Italia e tutte le regioni;
8. pagina Regione raggruppata per aree territoriali;
9. pagina Area con elenco falesie;
10. pagina Falesia con indicatori e settori;
11. pagina Settore con tabella vie ordinata;
12. breadcrumb completo;
13. conteggi reali;
14. ricerca globale;
15. importazione JSON di una falesia completa;
16. anteprima ad albero;
17. rilevamento duplicati;
18. importazione transazionale;
19. RLS di lettura pubblica e scrittura admin;
20. test.

Non copiare codice, testi, CSS, dati, commenti o grafica di Climbook.
Usa soltanto i principi generali di organizzazione dell'informazione.

Esegui:

npm run lint
npm run typecheck
npm run test
npm run build

Alla fine riporta:

1. file creati e modificati;
2. migrazioni;
3. componenti;
4. rotte;
5. test;
6. comandi eseguiti;
7. passaggi manuali;
8. problemi rimasti.

Non iniziare altri blocchi.
```
