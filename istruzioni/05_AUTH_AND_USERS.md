# Autenticazione e utenti

## Registrazione

Campi:

- username;
- display name;
- email;
- password.

## Funzioni

- registrazione;
- conferma email;
- login;
- logout;
- recupero password;
- cambio password;
- sessione persistente;
- modifica profilo.

## Profilo pubblico

URL:

```text
#/u/:username
```

Dati visibili:

- avatar;
- username;
- nome;
- bio;
- città e paese;
- anno di inizio;
- stile preferito;
- ascensioni pubbliche;
- progetti pubblici;
- statistiche pubbliche.

Dati non visibili:

- email;
- password;
- peso;
- sonno;
- note private;
- backup;
- media privati.

## Ricerca utenti

Pagina:

```text
#/users
```

Ricerca per:

- username;
- display name.

## Regole

- username univoco e case-insensitive;
- l'utente modifica soltanto il proprio profilo;
- nessun follower;
- nessun like;
- nessun messaggio;
- nessun commento social.
