---
dataset: capital_climbing_ascents
version: 1
generated_at: 2026-06-26
total_records: 87
canonical_records: 80
records_needing_review: 7
unique_crag_route_pairs: 86
primary_source: ascents.xlsx
secondary_source: user_pasted_8a_nu_log_and_logbook_completo.md
---

# Capital Climbing — Vie scalate e ascensioni

Questo file è pensato per essere caricato direttamente in Claude Code come dataset iniziale.

## Regole di importazione

- Le **80 righe `canonical`** provengono dal file strutturato `ascents.xlsx` e hanno priorità.
- Le **7 righe `needs_review`** compaiono nel testo/registro 8a.nu ma non nel file Excel.
- La chiave consigliata per evitare duplicati è: `(date, crag, normalized_route_name)`.
- `attempt_key` usa le chiavi tecniche: `onsight`, `flash`, `second`, `third`, `four_plus`, `unknown`.
- Il valore UI corrispondente a `four_plus` è **`4+`**.
- Quando `sector` è vuoto ma `sector_candidates` è compilato, il settore preciso della via non è noto: non assegnarlo automaticamente.
- `grade` è lo snapshot del grado registrato al momento dell'ascensione.
- Le righe `needs_review` non devono essere importate come confermate finché non vengono verificate.

## Ascensioni

| ascent_id | date | country | region | province | municipality | crag | sector | sector_candidates | route | route_aliases | grade | proposed_grade | attempt_key | attempt_label | beauty_1_5 | perception | notes | source | status |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| ASC-002 | 2026-06-20 | Italia | Lazio | Frosinone | Collepardo | Collepardo | — | Cueva; Cuevita | Donkey kong | — | 7a+ | 7a.7 | second | 2° giro | 4 | — | — | ascents.xlsx | canonical |
| ASC-001 | 2026-06-20 | Italia | Lazio | Frosinone | Collepardo | Collepardo | — | Cueva; Cuevita | Traverso della muerte L1 | — | 7a | 7a.9 | four_plus | 4+ | 4 | — | — | ascents.xlsx | canonical |
| ASC-004 | 2026-06-01 | Italia | Abruzzo | L'Aquila | Cappadocia (frazione Petrella Liri) | Petrella Liri | Placche di Bini | — | Cubalibre | Cuba Libre | 6c+ | 6c+.2 | onsight | On-sight | 4 | — | Potrei aver aggirato il primo passo passando da dx. | ascents.xlsx | canonical |
| ASC-003 | 2026-06-01 | Italia | Abruzzo | L'Aquila | Cappadocia (frazione Petrella Liri) | Petrella Liri | Placche di Bini | — | Mirco | — | 6b+ | 6b+.6 | onsight | On-sight | 4 | — | — | ascents.xlsx | canonical |
| ASC-006 | 2026-05-31 | Italia | Abruzzo | L'Aquila | Tagliacozzo | Tagliacozzo | — | Estrema sinistra; Grande tetto; Scudo centrale; Estrema destra | La spagnola L1 | — | 6b | 6b.2 | onsight | On-sight | 4 | — | — | ascents.xlsx | canonical |
| ASC-005 | 2026-05-31 | Italia | Abruzzo | L'Aquila | Tagliacozzo | Tagliacozzo | — | Estrema sinistra; Grande tetto; Scudo centrale; Estrema destra | Toto bang | — | 6a+ | 6a+.6 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-008 | 2026-05-23 | Italia | Abruzzo | L'Aquila | Tagliacozzo | Tagliacozzo | — | Estrema sinistra; Grande tetto; Scudo centrale; Estrema destra | L'arte di giudicare | — | 7a+ | 7a.6 | second | 2° giro | 4 | — | — | ascents.xlsx | canonical |
| ASC-007 | 2026-05-23 | Italia | Abruzzo | L'Aquila | Tagliacozzo | Tagliacozzo | — | Estrema sinistra; Grande tetto; Scudo centrale; Estrema destra | Inglese | — | 6b+ | 6b+.2 | onsight | On-sight | 4 | — | — | ascents.xlsx | canonical |
| ASC-012 | 2026-05-03 | Italia | Molise | Isernia | Frosolone | Colle dell'Orso | Blocco P, Q - Morgia Quadra | — | Charriba | — | 6c | 6c.6 | flash | Flash | 3 | — | — | ascents.xlsx | canonical |
| ASC-011 | 2026-05-03 | Italia | Molise | Isernia | Frosolone | Colle dell'Orso | Blocco P, Q - Morgia Quadra | — | Olive fritte L1 | — | 6b | 6b.4 | onsight | On-sight | 4 | — | — | ascents.xlsx | canonical |
| ASC-010 | 2026-05-03 | Italia | Molise | Isernia | Frosolone | Colle dell'Orso | Blocco P, Q - Morgia Quadra | — | Fagian Club | — | 6b+ | 6c.3 | onsight | On-sight | 4 | — | — | ascents.xlsx | canonical |
| ASC-009 | 2026-05-03 | Italia | Molise | Isernia | Frosolone | Colle dell'Orso | Blocco P, Q - Morgia Quadra | — | Socrate | — | 6a+ | 6b.2 | second | 2° giro | 3 | — | — | ascents.xlsx | canonical |
| ASC-014 | 2026-05-02 | Italia | Molise | Isernia | Frosolone | Colle dell'Orso | Blocco P, Q - Morgia Quadra | — | Cardine sinistro | — | 6b | 6b+.2 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-013 | 2026-05-02 | Italia | Molise | Isernia | Frosolone | Colle dell'Orso | Blocco P, Q - Morgia Quadra | — | Pantera nera (Latte e caffe') | Pantera nera | 6a+ | 6a+.2 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-015 | 2026-04-26 | Italia | Lazio | Rieti | Cittaducale (località Grotti) | Grotti | Grotti Bassa - Nuovo Settore | — | Gli invidiosi | — | 7a | 7a.4 | third | 3° giro | 4 | — | — | ascents.xlsx | canonical |
| ASC-017 | 2026-04-19 | Italia | Lazio | Frosinone | Collepardo | Collepardo | — | Cueva; Cuevita | Madonnazinonvedol’ora | — | 6b | 6b+.1 | flash | Flash | 3 | — | — | ascents.xlsx | canonical |
| ASC-016 | 2026-04-19 | Italia | Lazio | Frosinone | Collepardo | Collepardo | — | Cueva; Cuevita | L’assassino L1 | — | 6c+/7a | 7a.2 | second | 2° giro | 4 | — | — | ascents.xlsx | canonical |
| ASC-020 | 2026-04-11 | Italia | Lazio | Frosinone | Collepardo | Collepardo | — | Cueva; Cuevita | Riabassa la pinna | — | 6b | 6b.5 | flash | Flash | 3 | — | — | ascents.xlsx | canonical |
| ASC-019 | 2026-04-11 | Italia | Lazio | Frosinone | Collepardo | Collepardo | — | Cueva; Cuevita | Felix | — | 6c | 6c.5 | second | 2° giro | 4 | — | — | ascents.xlsx | canonical |
| ASC-018 | 2026-04-11 | Italia | Lazio | Frosinone | Collepardo | Collepardo | — | Cueva; Cuevita | Come piace a me | — | 6c/6c+ | 6c/6c+ | onsight | On-sight | 4 | — | — | ascents.xlsx | canonical |
| ASC-021 | 2026-03-29 | Italia | Lazio | Rieti | da verificare | La Fortezza | — | — | La montagna è cultura | — | 6b | 6b.1 | flash | Flash | 3 | — | — | ascents.xlsx | canonical |
| ASC-022 | 2026-03-21 | Italia | Abruzzo | L'Aquila | Carsoli (frazione Pietrasecca) | Pietrasecca | Vena Cionca | — | Auguri Veronica | Aguri Veronica | 6c | 6c.6 | second | 2° giro | 4 | — | — | ascents.xlsx | canonical |
| ASC-024 | 2026-03-01 | Italia | Lazio | Rieti | da verificare | La Fortezza | — | — | Le scelte | — | 6b | 6b.2 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-023 | 2026-03-01 | Italia | Lazio | Rieti | da verificare | La Fortezza | — | — | Negli occhi | — | 6b | 6b.4 | onsight | On-sight | 4 | — | — | ascents.xlsx | canonical |
| ASC-025 | 2026-02-17 | Italia | Lazio | Frosinone | Roccasecca (frazione Caprile) | Caprile | Le Grandi Panze | — | Buccia d'arancia | — | 6a | 6a.5 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-027 | 2026-02-15 | Italia | Lazio | Frosinone | Roccasecca (frazione Caprile) | Caprile | I Gradoni | — | Collaborazione | — | 6b/6b+ | 6b.9 | second | 2° giro | 4 | — | — | ascents.xlsx | canonical |
| ASC-026 | 2026-02-15 | Italia | Lazio | Frosinone | Roccasecca (frazione Caprile) | Caprile | I Gradoni | — | Senza nome 1 | N.N. 8 | 6b | 6b.2 | second | 2° giro | 3 | — | — | ascents.xlsx | canonical |
| ASC-029 | 2026-01-18 | Italia | Umbria | Terni | Ferentillo | Ferentillo | Gabbio | — | Bombardamentos L1+L2 | Bombardamentos lunga | 6b+ | 6b+.6 | second | 2° giro | 4 | — | — | ascents.xlsx | canonical |
| ASC-028 | 2026-01-18 | Italia | Umbria | Terni | Ferentillo | Ferentillo | Gabbio | — | Alfredo Alfredo L1 | Alfredo Alfredo | 6a | 6a.2 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-087 | 2025-12-26 | Italia | Abruzzo | L'Aquila | Carsoli (frazione Pietrasecca) | Pietrasecca | Vena Cionca | — | Trick e tak | — | 6a | — | unknown | Sconosciuto | — | — | Presente nel testo/8a.nu ma non in ascents.xlsx; verificare che non sia un alias di Rick e Tack. | testo utente / 8a.nu | needs_review |
| ASC-033 | 2025-12-26 | Italia | Abruzzo | L'Aquila | Carsoli (frazione Pietrasecca) | Pietrasecca | Vena Cionca | — | A sinistra del televisore L1 | — | 6a | 6a.5 | onsight | On-sight | 4 | — | — | ascents.xlsx | canonical |
| ASC-032 | 2025-12-26 | Italia | Abruzzo | L'Aquila | Carsoli (frazione Pietrasecca) | Pietrasecca | Vena Cionca | — | Nasce Lollo | — | 6b+ | 6b+.5 | onsight | On-sight | 5 | — | — | ascents.xlsx | canonical |
| ASC-031 | 2025-12-26 | Italia | Abruzzo | L'Aquila | Carsoli (frazione Pietrasecca) | Pietrasecca | Vena Cionca | — | Rick e Tack | — | 6a | 6a.3 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-030 | 2025-12-26 | Italia | Abruzzo | L'Aquila | Carsoli (frazione Pietrasecca) | Pietrasecca | Vena Cionca | — | Mannaggia all'ortolano L2 | mannaggia all'ortolano | 6b | 6b.5 | onsight | On-sight | 4 | — | — | ascents.xlsx | canonical |
| ASC-034 | 2025-12-20 | Italia | Abruzzo | L'Aquila | Carsoli (frazione Pietrasecca) | Pietrasecca | Vena Cionca | — | Lama non lama L1 | — | 6a | 6a.5 | onsight | On-sight | 4 | — | — | ascents.xlsx | canonical |
| ASC-035 | 2025-12-19 | Italia | Abruzzo | L'Aquila | Carsoli (frazione Pietrasecca) | Pietrasecca | Vena Cionca | — | Se vi va! L2 | — | 6a | 6a.3 | onsight | On-sight | 4 | — | — | ascents.xlsx | canonical |
| ASC-038 | 2024-09-28 | Italia | Lazio | Latina | Norma | Norma | Placche Rosse | — | Licantropia | — | 7a | 7a.1 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-037 | 2024-09-28 | Italia | Lazio | Latina | Norma | Norma | Placche Rosse | — | Little frog | — | 6b+ | 6b+.5 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-036 | 2024-09-28 | Italia | Lazio | Latina | Norma | Norma | Placche Rosse | — | Belfagor | — | 6c | 6c.3 | flash | Flash | 3 | — | — | ascents.xlsx | canonical |
| ASC-040 | 2024-08-21 | Italia | Abruzzo | L'Aquila | Cappadocia (frazione Petrella Liri) | Petrella Liri | Petrella Alta | — | Aghetti | — | 6c+ | 6c+.5 | second | 2° giro | 3 | — | — | ascents.xlsx | canonical |
| ASC-039 | 2024-08-21 | Italia | Lazio | Rieti | Configni | Configni | — | — | Rino | — | 6b+ | 6b+.5 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-041 | 2024-08-09 | Italia | Valle d'Aosta | Aosta | Valgrisenche (La Béthaz) | Miollet | Destro | — | Il porco | — | 6b | 6b.5 | onsight | On-sight | 4 | — | — | ascents.xlsx | canonical |
| ASC-042 | 2024-07-25 | Italia | Abruzzo | L'Aquila | Tagliacozzo | Tagliacozzo | — | Estrema sinistra; Grande tetto; Scudo centrale; Estrema destra | Miky Mouse | — | 6b+ | 6b+.5 | four_plus | 4+ | 4 | — | Tipo di tentativo originale N.D.; mappato provvisoriamente a four_plus secondo le specifiche del progetto. | ascents.xlsx | canonical |
| ASC-043 | 2024-07-24 | Italia | Abruzzo | L'Aquila | Tagliacozzo | Tagliacozzo | — | Estrema sinistra; Grande tetto; Scudo centrale; Estrema destra | Ah Toto | — | 6b | 6b.5 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-044 | 2024-07-14 | Italia | Abruzzo | L'Aquila | Cappadocia (frazione Petrella Liri) | Petrella Liri | Petrella Alta | — | Opopomoz L2 | — | 6a+ | 6a+.5 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-045 | 2024-06-23 | Italia | Abruzzo | L'Aquila | Cappadocia (frazione Petrella Liri) | Petrella Liri | Petrella Alta | — | Il canto della gabbianella | — | 6a | 6a.5 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-046 | 2024-06-09 | Italia | Lazio | Frosinone | Roccasecca (da verificare) | Fraioli | — | — | Schiavo della pietra | — | 6b | 6b.3 | onsight | On-sight | 2 | — | — | ascents.xlsx | canonical |
| ASC-047 | 2024-05-29 | Italia | Sardegna | Nuoro | Ulassai | Ulassai | Torre dei Venti | — | Curiosape | — | 6c+ | 6c+.5 | second | 2° giro | 3 | — | — | ascents.xlsx | canonical |
| ASC-048 | 2024-05-28 | Italia | Sardegna | Nuoro | Ulassai | Ulassai | Il Canyon | — | Fruttolo L1+L2 | Fruttolo (1st pitch); Fruttolo (2nd pitch) | 6c+ | 6c+.4 | onsight | On-sight | 5 | — | — | ascents.xlsx | canonical |
| ASC-049 | 2024-05-27 | Italia | Sardegna | Nuoro | Ulassai | Ulassai | Torre dei Venti | — | La fuga della capretta | — | 6b+ | 6b+.3 | onsight | On-sight | 4 | — | — | ascents.xlsx | canonical |
| ASC-053 | 2024-05-26 | Italia | Sardegna | Nuoro | Ulassai | Ulassai | Il Canyon | — | Arcipelaghi L1 | Arcipelaghi | 6b | 6b.1 | flash | Flash | 4 | — | — | ascents.xlsx | canonical |
| ASC-052 | 2024-05-26 | Italia | Sardegna | Nuoro | Ulassai | Ulassai | Il Canyon | — | Non luogo | — | 6c | 6c.2 | second | 2° giro | 3 | — | — | ascents.xlsx | canonical |
| ASC-051 | 2024-05-26 | Italia | Sardegna | Nuoro | Ulassai | Ulassai | Il Canyon | — | Vision Crack | — | 6a+ | 6a+.8 | onsight | On-sight | 4 | — | — | ascents.xlsx | canonical |
| ASC-050 | 2024-05-26 | Italia | Sardegna | Nuoro | Ulassai | Ulassai | Il Canyon | — | Educanza L1 | Educanza | 6b+ | 6b+.3 | flash | Flash | 4 | — | — | ascents.xlsx | canonical |
| ASC-054 | 2024-04-14 | Italia | Lazio | Roma | Subiaco | Subiaco | Regno dei Ragni | — | Gommolo | — | 7a+ | 7a+.5 | four_plus | 4+ | 2 | — | — | ascents.xlsx | canonical |
| ASC-055 | 2024-04-12 | Italia | Lazio | Rieti | Cittaducale (località Grotti) | Grotti | Grotti Bassa - Nuovo Settore | — | Il Droga | — | 6a | 6a.5 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-086 | 2024-04-08 | Spagna | Isole Baleari | Mallorca | da verificare | Tijuana | — | — | Tapas | — | 6a+ | — | unknown | Sconosciuto | — | — | Presente nel testo/8a.nu; da verificare tipo di tentativo e settore. | testo utente / 8a.nu | needs_review |
| ASC-085 | 2024-04-06 | Spagna | Isole Baleari | Mallorca | da verificare | Tijuana | — | — | Colesterol Party | — | 6a+ | — | unknown | Sconosciuto | — | a bit scary | Presente nel testo/8a.nu; da verificare tipo di tentativo e settore. | testo utente / 8a.nu | needs_review |
| ASC-084 | 2024-04-06 | Spagna | Isole Baleari | Mallorca | da verificare | Tijuana | — | — | Es diedro | — | 5c | — | unknown | Sconosciuto | — | — | Presente nel testo/8a.nu; da verificare tipo di tentativo e settore. | testo utente / 8a.nu | needs_review |
| ASC-083 | 2024-04-05 | Spagna | Isole Baleari | Mallorca | Selva (località Caimari) | Caimari | — | Adalt de Tot; Adalt; Es Raconet; Placa Rotja | Pa Torrat | — | 5c | — | unknown | Sconosciuto | — | — | Presente nel testo/8a.nu; da verificare tipo di tentativo e settore esatto. | testo utente / 8a.nu | needs_review |
| ASC-057 | 2024-04-05 | Spagna | Isole Baleari | Mallorca | Selva (località Caimari) | Caimari | — | Adalt de Tot; Adalt; Es Raconet; Placa Rotja | Relaya la Raya L1 | Relaja la Raja L1 | 6b | 6b.5 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-056 | 2024-04-05 | Spagna | Isole Baleari | Mallorca | Selva (località Caimari) | Caimari | — | Adalt de Tot; Adalt; Es Raconet; Placa Rotja | Cachinochalgo left | — | 7a | 6c+.5 | second | 2° giro | 3 | — | — | ascents.xlsx | canonical |
| ASC-060 | 2024-04-04 | Spagna | Isole Baleari | Mallorca | Manacor | Cala Magraner | — | Estrema Sinistra; Sense Voler; Pipiricot; Xorics | Xorics | — | 6b+ | 6b+.3 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-059 | 2024-04-04 | Spagna | Isole Baleari | Mallorca | Manacor | Cala Magraner | — | Estrema Sinistra; Sense Voler; Pipiricot; Xorics | Not dangerous | — | 6b+ | 6b.5 | second | 2° giro | 3 | — | — | ascents.xlsx | canonical |
| ASC-058 | 2024-04-04 | Spagna | Isole Baleari | Mallorca | Manacor | Cala Magraner | — | Estrema Sinistra; Sense Voler; Pipiricot; Xorics | Nautilus | — | 6a | 6a.3 | onsight | On-sight | 2 | — | — | ascents.xlsx | canonical |
| ASC-082 | 2024-04-03 | Spagna | Isole Baleari | Mallorca | Artà | Ermita de Betlem | — | — | belle epoque | — | 6b+ | — | unknown | Sconosciuto | — | Loose rock | Presente nel testo/8a.nu; da verificare tipo di tentativo e settore. | testo utente / 8a.nu | needs_review |
| ASC-081 | 2024-03-31 | Italia | Lazio | Rieti | da verificare | La Fortezza | — | — | Negli occhi | — | 6b | — | unknown | Sconosciuto | — | Soft | Presente nel testo/8a.nu come sessione distinta; non presente in ascents.xlsx. | testo utente / 8a.nu | needs_review |
| ASC-062 | 2024-03-31 | Italia | Lazio | Rieti | da verificare | La Fortezza | — | — | Albedo | — | 6c | 6c.4 | second | 2° giro | 3 | — | — | ascents.xlsx | canonical |
| ASC-061 | 2024-03-31 | Italia | Lazio | Rieti | da verificare | La Fortezza | — | — | La Giggiata | — | 6b+ | 6b+.4 | flash | Flash | 3 | — | — | ascents.xlsx | canonical |
| ASC-063 | 2024-03-26 | Italia | Lazio | Rieti | da verificare | La Fortezza | — | — | Avanguardia | — | 6b+ | 6b+.1 | flash | Flash | 3 | — | — | ascents.xlsx | canonical |
| ASC-065 | 2023-12-24 | Italia | Lazio | Roma | Allumiere | Ripa Majala | — | — | Il mestiere di vivere | — | 6c | 6c.4 | third | 3° giro | 3 | — | — | ascents.xlsx | canonical |
| ASC-064 | 2023-12-24 | Italia | Lazio | Roma | Allumiere | Ripa Majala | — | — | Mea culpa | — | 6a | 6a.3 | onsight | On-sight | 2 | — | — | ascents.xlsx | canonical |
| ASC-066 | 2023-09-15 | Italia | Lazio | Roma | Allumiere | Ripa Majala | — | — | Ore perse | — | 6b+ | 6b+.3 | second | 2° giro | 4 | — | — | ascents.xlsx | canonical |
| ASC-068 | 2023-09-14 | Italia | Abruzzo | L'Aquila | Ovindoli | Ovindoli | Val d'Arano | — | Tormentilla | — | 6c | 6c/6c+ | second | 2° giro | 3 | — | — | ascents.xlsx | canonical |
| ASC-067 | 2023-09-14 | Italia | Abruzzo | L'Aquila | Ovindoli | Ovindoli | Val d'Arano | — | Forse accadde così | — | 6c | 6c.3 | third | 3° giro | 3 | — | — | ascents.xlsx | canonical |
| ASC-071 | 2023-09-12 | Italia | Lazio | Rieti | Configni | Configni | — | — | Il calderone celtico | — | 6a | 6a.3 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-070 | 2023-09-12 | Italia | Lazio | Rieti | Configni | Configni | — | — | Ai Configni della Realtà | — | 6a+ | 6a+.7 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-069 | 2023-09-12 | Italia | Lazio | Rieti | Configni | Configni | — | — | Pilastrino | — | 6b | 6b.5 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-072 | 2023-09-08 | Italia | Abruzzo | L'Aquila | Cappadocia (frazione Petrella Liri) | Petrella Liri | Placche di Bini | — | La mia nemesi | — | 6b+ | 6b.4 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-073 | 2023-09-07 | Italia | Abruzzo | L'Aquila | Cappadocia (frazione Petrella Liri) | Petrella Liri | Placche di Bini | — | Taglio e cucito | — | 6c | 6c.4 | second | 2° giro | 2 | — | — | ascents.xlsx | canonical |
| ASC-074 | 2023-09-05 | Italia | Abruzzo | L'Aquila | Cappadocia (frazione Petrella Liri) | Petrella Liri | Petrella Alta | — | Snikefinger L1 | — | 6b+ | 6b+.6 | four_plus | 4+ | 2 | — | — | ascents.xlsx | canonical |
| ASC-075 | 2023-08-15 | Italia | Abruzzo | Chieti | Pizzoferrato | Pizzoferrato | — | — | Passione | — | 6b | 6b.5 | second | 2° giro | 3 | — | — | ascents.xlsx | canonical |
| ASC-076 | 2023-07-29 | Italia | Lazio | Roma | Allumiere | Ripa Majala | — | — | Regina della notte | — | 6b+ | 6b+.1 | third | 3° giro | 3 | — | — | ascents.xlsx | canonical |
| ASC-077 | 2023-07-22 | Italia | Lazio | Roma | Allumiere | Ripa Majala | — | — | Gola profonda L2 | Gola Profonda | 6b | 6b.6 | third | 3° giro | 4 | — | — | ascents.xlsx | canonical |
| ASC-078 | 2022-12-17 | Italia | Lazio | Roma | Allumiere | Ripa Majala | — | — | Eskimo | — | 6a | 6a.2 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |
| ASC-079 | 2022-10-09 | Italia | Lazio | Roma | Allumiere | Ripa Majala | — | — | Un grammo di paura | — | 6b | 6b.5 | second | 2° giro | 3 | — | — | ascents.xlsx | canonical |
| ASC-080 | 2022-09-30 | Italia | Lazio | Roma | Allumiere | Ripa Majala | — | — | Ottobre rosso | — | 6a | 6a.4 | onsight | On-sight | 3 | — | — | ascents.xlsx | canonical |

## Alias e casi da gestire

| Caso | Record principale | Alias / record secondario | Azione consigliata |
|---|---|---|---|
| Nome differente | Cubalibre | Cuba Libre | Conservare `Cubalibre` come nome sorgente Excel e aggiungere alias `Cuba Libre`. |
| Refuso | Auguri Veronica | Aguri Veronica | Usare `Auguri Veronica` come canonico, mantenendo l'alias. |
| Nome provvisorio | Senza nome 1 | N.N. 8 | Trattare come possibile alias finché non verificato sulla guida. |
| Multipitch | Bombardamentos L1+L2 | Bombardamentos lunga | Stessa salita, alias confermato. |
| Multipitch | Fruttolo L1+L2 | Fruttolo (1st pitch); Fruttolo (2nd pitch) | L'ascensione è unica; il catalogo può contenere i due tiri come componenti. |
| Ortografia | Relaya la Raya L1 | Relaja la Raja L1 | Alias confermato tra piattaforme. |
| Suffisso tiro | Gola profonda L2 | Gola Profonda | Mantenere il suffisso nel canonico e il nome breve come alias. |
| Possibile duplicato | Rick e Tack | Trick e tak | Non unire automaticamente: la riga `Trick e tak` resta `needs_review`. |
| Data discordante | A sinistra del televisore L1 | 20-12-2025 su 8a.nu; 26-12-2025 su Excel | Usare provvisoriamente la data Excel e segnalare il conflitto. |

## Controlli consigliati prima del seed definitivo

1. Verificare i 7 record `needs_review`.
2. Confermare il grado ufficiale delle vie con differenze tra le piattaforme.
3. Collegare le vie ai settori esatti nei casi in cui il dato contiene soltanto una lista di settori candidati.
4. Decidere se rappresentare i multipitch come una sola via composta o come più tiri collegati.
