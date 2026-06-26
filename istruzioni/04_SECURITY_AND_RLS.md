# Sicurezza e Row Level Security

## Regola fondamentale

La UI non è una protezione sufficiente. Il controllo definitivo deve essere nel database.

## Profili

```text
SELECT: tutti
INSERT: tramite trigger di registrazione
UPDATE: solo proprietario
DELETE: proprietario o amministratore
```

## Catalogo

Per:

- sources;
- crags;
- sectors;
- routes;
- route_aliases;
- route_sources.

```text
SELECT: tutti
INSERT: solo admin
UPDATE: solo admin
DELETE: solo admin
```

## Dati personali

Per:

- ascents;
- projects;
- sessions;
- attempts;
- user_route_notes.

```text
SELECT:
visibility = 'public'
OR user_id = auth.uid()

INSERT:
user_id = auth.uid()

UPDATE:
user_id = auth.uid()

DELETE:
user_id = auth.uid()
```

## Ruoli

Creare:

```sql
is_admin()
```

La funzione deve controllare `user_roles` senza consentire escalation di privilegi.

Gli utenti normali non devono poter:

- inserire un ruolo;
- aggiornare un ruolo;
- cancellare un ruolo;
- cambiare il proprio ruolo.

## Segreti

Consentiti nel frontend:

```text
VITE_SUPABASE_URL
VITE_SUPABASE_PUBLISHABLE_KEY
```

Vietati:

```text
SUPABASE_SERVICE_ROLE_KEY
database password
secret key
personal access token
```

## Test obbligatori

Creare:

- visitatore anonimo;
- utente A;
- utente B;
- admin.

Verificare che:

- A vede dati pubblici di B;
- A non vede dati privati di B;
- A non modifica dati di B;
- utente normale non modifica il catalogo;
- admin modifica il catalogo;
- nessuno può autoassegnarsi admin.
