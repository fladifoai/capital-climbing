# Logbook e punteggio

## Le mie vie

Una via appare nel logbook personale se esiste almeno uno dei seguenti:

- ascensione;
- progetto;
- tentativo;
- nota personale.

## Nuova salita

Campi:

- falesia;
- settore;
- via;
- data;
- tentativo;
- grado snapshot;
- kneepad;
- sforzo;
- note;
- visibilità.

La via deve esistere nel catalogo.

## Tipi di tentativo

Chiavi tecniche:

```text
onsight
flash
second
third
four_plus
```

Etichette UI:

```text
On-sight
Flash
2° giro
3° giro
4+
```

## Formula

```text
score = 100 × 1.35 ^ (grade_numeric + attempt_bonus)
```

Bonus:

```text
onsight   +2.0
flash     +1.5
second    +0.5
third      0.0
four_plus -0.3
```

## Scala iniziale

```text
5c       0
6a       1
6a+      2
6b       3
6b/6b+   3.5
6b+      4
6c       5
6c/6c+   5.5
6c+      6
6c+/7a   6.5
7a       7
7a+      8
7b       9
7b+      10
7c       11
7c+      12
8a       13
8a+      14
8b       15
```

## Snapshot del grado

Ogni ascensione deve salvare:

- `grade_at_ascent`;
- `grade_numeric_at_ascent`.

La modifica successiva del catalogo non deve cambiare il punteggio storico.

## Progetti

I progetti:

- non danno punti;
- non modificano il grado massimo;
- non entrano nelle percentuali;
- diventano ascensioni solo dopo la chiusura.

## Test

Verificare almeno:

- 7a On-sight;
- 7a+ 2° giro;
- 6c+ On-sight;
- 7a+ 4+;
- grado non riconosciuto.
