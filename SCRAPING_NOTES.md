# Scraping Notes — Climbook Personal Importer

## Cosa viene scaricato

Solo i dati pubblici di Climbook strettamente necessari per ricostruire il catalogo personale:

1. **Pagine falesia** (`/falesie/{id}/{slug}/vie`) — elenco completo vie con grado
2. **Pagine ricerca route** (`/vie?q={query}`) — per scoprire l'URL di una falesia dato il nome
3. **Pagine singola via** (`/vie/{id}/{slug}`) — solo se necessario per ottenere grado ufficiale

## Perché lo scope è limitato

Questo importer serve esclusivamente per inizializzare il catalogo personale di Capital Climbing con i dati delle falesie già frequentate dall'utente. Non è una copia di Climbook.

Il principio fondamentale: **falesie presenti nel logbook → settori → vie di quei settori**.

Non vengono scaricati:
- Falesie non presenti nel logbook personale
- Commenti e note degli utenti
- Foto e topo
- Profili utente
- Logbook di altri utenti
- Ranking e classifiche
- Contenuti premium
- Descrizioni avanzate protette da copyright

## URL interrogati

```
https://www.climbook.com/vie?q={crag_name}        # discovery URL falesia
https://www.climbook.com/falesie/{id}/{slug}/vie  # tutte le vie della falesia
https://www.climbook.com/vie/{id}/{slug}          # dettaglio via (opzionale)
```

Nessun login. Nessuna sessione autenticata.

## robots.txt

Verificato il `2026-06-27`:

```
User-agent: *
Disallow:
```

Nessun percorso vietato. Nessun Crawl-delay specificato.

## Rate limit usato

- **Delay tra richieste**: 3–5 secondi (randomizzato)
- **Max retry**: 2 per URL fallito
- **Timeout**: 15 secondi
- **User-Agent**: `CapitalClimbingPersonalImporter/0.1`
- **Cache locale**: sì, in `data/raw/climbook_pages_cache/` per evitare doppi download

## Dati esclusi

| Categoria | Motivo |
|---|---|
| Commenti utenti | Dati personali di terzi |
| Note su vie | Copyright potenziale, non strutturate |
| Foto | Copyright |
| Topo | Copyright |
| Profili utente | GDPR, non necessari |
| Logbook altrui | Dati personali di terzi |
| Ranking | Non necessari |
| Aree geografiche fuori logbook | Fuori scope |

## Dubbi legali e tecnici

1. **Termini di servizio**: Climbook non espone una pagina TOS o Privacy Policy pubblica raggiungibile dall'homepage. Sono disponibili solo due email di contatto (`aggiornamenti.climbook@gmail.com`, `assistenza.climbook@gmail.com`). In assenza di TOS che vietino il crawling personale, il `robots.txt` permissivo è il riferimento principale.

2. **Copyright sui nomi di vie**: I nomi di falesie, settori e vie sono denominazioni geografiche e/o creative dei chiodatori. L'uso per un catalogo personale non commerciale è generalmente coperto dall'uso personale. I gradi sono dati tecnici/fattuali.

3. **Rate limiting**: Lo scraper usa delay conservativi (3-5s) e cache locale per minimizzare il carico sul server. Non simula comportamento umano.

4. **Raccomandazione**: Prima di pubblicare il catalogo risultante, verificare con Climbook tramite email se hanno obiezioni all'uso dei dati per un catalogo personale non commerciale.

5. **Non redistribuzione**: I dati raccolti sono destinati esclusivamente all'uso personale nell'applicazione Capital Climbing dell'utente. Non vengono ridistribuiti pubblicamente come copia di Climbook.
