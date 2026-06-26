-- ============================================================
-- 006_seed_catalog_and_logbook.sql
-- Seed: Spagna + Isole Baleari, 22 falesie, 35 settori,
-- 80 vie, 80 ascensioni canoniche — Flavio DiFoggia
-- ============================================================

-- ─── Paese: Spagna ──────────────────────────────────────────
insert into public.countries (id, name, iso2, slug)
values ('00000000-0000-0000-0001-000000000002', 'Spagna', 'ES', 'spain')
on conflict (id) do nothing;

-- ─── Regione: Isole Baleari ─────────────────────────────────
insert into public.regions (id, country_id, name, normalized_name, slug)
values (
  '00000000-0000-0000-0002-000000000021',
  '00000000-0000-0000-0001-000000000002',
  'Isole Baleari', 'isole-baleari', 'isole-baleari'
)
on conflict (id) do nothing;

-- ─── Falesie (22) ────────────────────────────────────────────
insert into public.crags
  (id, country_id, region_id, country, region, province, municipality, name, normalized_name, rock_type, access_status)
values
  ('00000000-0000-0000-0010-000000000001','00000000-0000-0000-0001-000000000002','00000000-0000-0000-0002-000000000021',
   'Spain','Isole Baleari',null,'Selva','Caimari','caimari','calcare','open'),
  ('00000000-0000-0000-0010-000000000002','00000000-0000-0000-0001-000000000002','00000000-0000-0000-0002-000000000021',
   'Spain','Isole Baleari',null,'Manacor','Cala Magraner','cala-magraner','calcare','open'),
  ('00000000-0000-0000-0010-000000000003','00000000-0000-0000-0001-000000000001','00000000-0000-0000-0002-000000000007',
   'Italy','Lazio','Frosinone','Roccasecca','Caprile','caprile','calcare','open'),
  ('00000000-0000-0000-0010-000000000004','00000000-0000-0000-0001-000000000001','00000000-0000-0000-0002-000000000011',
   'Italy','Molise','Isernia','Frosolone','Colle dell''Orso','colle-dell-orso','calcare','open'),
  ('00000000-0000-0000-0010-000000000005','00000000-0000-0000-0001-000000000001','00000000-0000-0000-0002-000000000007',
   'Italy','Lazio','Frosinone','Collepardo','Collepardo','collepardo','calcare','open'),
  ('00000000-0000-0000-0010-000000000006','00000000-0000-0000-0001-000000000001','00000000-0000-0000-0002-000000000007',
   'Italy','Lazio','Rieti','Configni','Configni','configni','calcare','open'),
  ('00000000-0000-0000-0010-000000000007','00000000-0000-0000-0001-000000000002','00000000-0000-0000-0002-000000000021',
   'Spain','Isole Baleari',null,'Artà','Ermita de Betlem','ermita-de-betlem','calcare','open'),
  ('00000000-0000-0000-0010-000000000008','00000000-0000-0000-0001-000000000001','00000000-0000-0000-0002-000000000018',
   'Italy','Umbria','Terni','Ferentillo','Ferentillo','ferentillo','calcare','open'),
  ('00000000-0000-0000-0010-000000000009','00000000-0000-0000-0001-000000000001','00000000-0000-0000-0002-000000000007',
   'Italy','Lazio','Frosinone','Roccasecca','Fraioli','fraioli','calcare','open'),
  ('00000000-0000-0000-0010-000000000010','00000000-0000-0000-0001-000000000001','00000000-0000-0000-0002-000000000007',
   'Italy','Lazio','Rieti','Cittaducale','Grotti','grotti','calcare','open'),
  ('00000000-0000-0000-0010-000000000011','00000000-0000-0000-0001-000000000001','00000000-0000-0000-0002-000000000007',
   'Italy','Lazio','Rieti',null,'La Fortezza','la-fortezza','calcare','open'),
  ('00000000-0000-0000-0010-000000000012','00000000-0000-0000-0001-000000000001','00000000-0000-0000-0002-000000000019',
   'Italy','Valle d''Aosta','Aosta','Valgrisenche','Miollet','miollet','granito','open'),
  ('00000000-0000-0000-0010-000000000013','00000000-0000-0000-0001-000000000001','00000000-0000-0000-0002-000000000007',
   'Italy','Lazio','Latina','Norma','Norma','norma','calcare','open'),
  ('00000000-0000-0000-0010-000000000014','00000000-0000-0000-0001-000000000001','00000000-0000-0000-0002-000000000001',
   'Italy','Abruzzo','L''Aquila','Ovindoli','Ovindoli','ovindoli','calcare','open'),
  ('00000000-0000-0000-0010-000000000015','00000000-0000-0000-0001-000000000001','00000000-0000-0000-0002-000000000001',
   'Italy','Abruzzo','L''Aquila','Cappadocia','Petrella Liri','petrella-liri','calcare','open'),
  ('00000000-0000-0000-0010-000000000016','00000000-0000-0000-0001-000000000001','00000000-0000-0000-0002-000000000001',
   'Italy','Abruzzo','L''Aquila','Carsoli','Pietrasecca','pietrasecca','calcare','open'),
  ('00000000-0000-0000-0010-000000000017','00000000-0000-0000-0001-000000000001','00000000-0000-0000-0002-000000000001',
   'Italy','Abruzzo','Chieti','Pizzoferrato','Pizzoferrato','pizzoferrato','calcare','open'),
  ('00000000-0000-0000-0010-000000000018','00000000-0000-0000-0001-000000000001','00000000-0000-0000-0002-000000000007',
   'Italy','Lazio','Roma','Allumiere','Ripa Majala','ripa-majala','trachite','open'),
  ('00000000-0000-0000-0010-000000000019','00000000-0000-0000-0001-000000000001','00000000-0000-0000-0002-000000000007',
   'Italy','Lazio','Roma','Subiaco','Subiaco','subiaco','calcare','open'),
  ('00000000-0000-0000-0010-000000000020','00000000-0000-0000-0001-000000000001','00000000-0000-0000-0002-000000000001',
   'Italy','Abruzzo','L''Aquila','Tagliacozzo','Tagliacozzo','tagliacozzo','calcare','open'),
  ('00000000-0000-0000-0010-000000000021','00000000-0000-0000-0001-000000000002','00000000-0000-0000-0002-000000000021',
   'Spain','Isole Baleari',null,null,'Tijuana','tijuana','calcare','open'),
  ('00000000-0000-0000-0010-000000000022','00000000-0000-0000-0001-000000000001','00000000-0000-0000-0002-000000000014',
   'Italy','Sardegna','Nuoro','Ulassai','Ulassai','ulassai','calcare','open')
on conflict (id) do nothing;

-- ─── Settori (35) ────────────────────────────────────────────
insert into public.sectors (id, crag_id, name, normalized_name, sort_order)
values
  -- Caimari (CRAG-001) — 4 settori candidati
  ('00000000-0000-0000-0020-000000000001','00000000-0000-0000-0010-000000000001','Adalt','adalt',1),
  ('00000000-0000-0000-0020-000000000002','00000000-0000-0000-0010-000000000001','Adalt de Tot','adalt-de-tot',2),
  ('00000000-0000-0000-0020-000000000003','00000000-0000-0000-0010-000000000001','Es Raconet','es-raconet',3),
  ('00000000-0000-0000-0020-000000000004','00000000-0000-0000-0010-000000000001','Placa Rotja','placa-rotja',4),
  -- Cala Magraner (CRAG-002) — 4 settori candidati
  ('00000000-0000-0000-0020-000000000005','00000000-0000-0000-0010-000000000002','Estrema Sinistra','estrema-sinistra',1),
  ('00000000-0000-0000-0020-000000000006','00000000-0000-0000-0010-000000000002','Pipiricot','pipiricot',2),
  ('00000000-0000-0000-0020-000000000007','00000000-0000-0000-0010-000000000002','Sense Voler','sense-voler',3),
  ('00000000-0000-0000-0020-000000000008','00000000-0000-0000-0010-000000000002','Xorics','xorics',4),
  -- Caprile (CRAG-003)
  ('00000000-0000-0000-0020-000000000009','00000000-0000-0000-0010-000000000003','I Gradoni','i-gradoni',1),
  ('00000000-0000-0000-0020-000000000010','00000000-0000-0000-0010-000000000003','Le Grandi Panze','le-grandi-panze',2),
  -- Colle dell'Orso (CRAG-004)
  ('00000000-0000-0000-0020-000000000011','00000000-0000-0000-0010-000000000004','Blocco P, Q - Morgia Quadra','blocco-p-q-morgia-quadra',1),
  -- Collepardo (CRAG-005)
  ('00000000-0000-0000-0020-000000000012','00000000-0000-0000-0010-000000000005','Cueva','cueva',1),
  ('00000000-0000-0000-0020-000000000013','00000000-0000-0000-0010-000000000005','Cuevita','cuevita',2),
  -- Configni (CRAG-006)
  ('00000000-0000-0000-0020-000000000014','00000000-0000-0000-0010-000000000006','Principale','principale',1),
  -- Ermita de Betlem (CRAG-007)
  ('00000000-0000-0000-0020-000000000015','00000000-0000-0000-0010-000000000007','Principale','principale',1),
  -- Ferentillo (CRAG-008)
  ('00000000-0000-0000-0020-000000000016','00000000-0000-0000-0010-000000000008','Gabbio','gabbio',1),
  -- Fraioli (CRAG-009)
  ('00000000-0000-0000-0020-000000000017','00000000-0000-0000-0010-000000000009','Principale','principale',1),
  -- Grotti (CRAG-010)
  ('00000000-0000-0000-0020-000000000018','00000000-0000-0000-0010-000000000010','Grotti Bassa - Nuovo Settore','grotti-bassa-nuovo-settore',1),
  -- La Fortezza (CRAG-011)
  ('00000000-0000-0000-0020-000000000019','00000000-0000-0000-0010-000000000011','Principale','principale',1),
  -- Miollet (CRAG-012)
  ('00000000-0000-0000-0020-000000000020','00000000-0000-0000-0010-000000000012','Destro','destro',1),
  -- Norma (CRAG-013)
  ('00000000-0000-0000-0020-000000000021','00000000-0000-0000-0010-000000000013','Placche Rosse','placche-rosse',1),
  -- Ovindoli (CRAG-014)
  ('00000000-0000-0000-0020-000000000022','00000000-0000-0000-0010-000000000014','Val d''Arano','val-d-arano',1),
  -- Petrella Liri (CRAG-015)
  ('00000000-0000-0000-0020-000000000023','00000000-0000-0000-0010-000000000015','Petrella Alta','petrella-alta',1),
  ('00000000-0000-0000-0020-000000000024','00000000-0000-0000-0010-000000000015','Placche di Bini','placche-di-bini',2),
  -- Pietrasecca (CRAG-016)
  ('00000000-0000-0000-0020-000000000025','00000000-0000-0000-0010-000000000016','Vena Cionca','vena-cionca',1),
  -- Pizzoferrato (CRAG-017)
  ('00000000-0000-0000-0020-000000000026','00000000-0000-0000-0010-000000000017','Principale','principale',1),
  -- Ripa Majala (CRAG-018)
  ('00000000-0000-0000-0020-000000000027','00000000-0000-0000-0010-000000000018','Principale','principale',1),
  -- Subiaco (CRAG-019)
  ('00000000-0000-0000-0020-000000000028','00000000-0000-0000-0010-000000000019','Regno dei Ragni','regno-dei-ragni',1),
  -- Tagliacozzo (CRAG-020) — 4 settori candidati; vie in Scudo centrale
  ('00000000-0000-0000-0020-000000000029','00000000-0000-0000-0010-000000000020','Estrema destra','estrema-destra',4),
  ('00000000-0000-0000-0020-000000000030','00000000-0000-0000-0010-000000000020','Estrema sinistra','estrema-sinistra',1),
  ('00000000-0000-0000-0020-000000000031','00000000-0000-0000-0010-000000000020','Grande tetto','grande-tetto',2),
  ('00000000-0000-0000-0020-000000000032','00000000-0000-0000-0010-000000000020','Scudo centrale','scudo-centrale',3),
  -- Tijuana (CRAG-021)
  ('00000000-0000-0000-0020-000000000033','00000000-0000-0000-0010-000000000021','Principale','principale',1),
  -- Ulassai (CRAG-022)
  ('00000000-0000-0000-0020-000000000034','00000000-0000-0000-0010-000000000022','Il Canyon','il-canyon',1),
  ('00000000-0000-0000-0020-000000000035','00000000-0000-0000-0010-000000000022','Torre dei Venti','torre-dei-venti',2)
on conflict (id) do nothing;

-- ─── Vie (80) ────────────────────────────────────────────────
-- Collepardo / Cueva (SECTOR-012) — vie in settore candidato
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000001','00000000-0000-0000-0020-000000000012','Donkey kong','donkey-kong','7a+',11.0,'sport'),
  ('00000000-0000-0000-0030-000000000002','00000000-0000-0000-0020-000000000012','Traverso della muerte L1','traverso-della-muerte-l1','7a',10.0,'sport'),
  ('00000000-0000-0000-0030-000000000003','00000000-0000-0000-0020-000000000012','Madonnazinonvedol''ora','madonnazinonvedol-ora','6b',6.0,'sport'),
  ('00000000-0000-0000-0030-000000000004','00000000-0000-0000-0020-000000000012','L''assassino L1','l-assassino-l1','6c+/7a',9.0,'sport'),
  ('00000000-0000-0000-0030-000000000005','00000000-0000-0000-0020-000000000012','Riabassa la pinna','riabassa-la-pinna','6b',6.0,'sport'),
  ('00000000-0000-0000-0030-000000000006','00000000-0000-0000-0020-000000000012','Felix','felix','6c',8.0,'sport'),
  ('00000000-0000-0000-0030-000000000007','00000000-0000-0000-0020-000000000012','Come piace a me','come-piace-a-me','6c/6c+',8.0,'sport')
on conflict (id) do nothing;

-- Petrella Liri / Placche di Bini (SECTOR-024)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000008','00000000-0000-0000-0020-000000000024','Cubalibre','cubalibre','6c+',9.0,'sport'),
  ('00000000-0000-0000-0030-000000000009','00000000-0000-0000-0020-000000000024','Mirco','mirco','6b+',7.0,'sport'),
  ('00000000-0000-0000-0030-000000000010','00000000-0000-0000-0020-000000000024','La mia nemesi','la-mia-nemesi','6b+',7.0,'sport'),
  ('00000000-0000-0000-0030-000000000011','00000000-0000-0000-0020-000000000024','Taglio e cucito','taglio-e-cucito','6c',8.0,'sport')
on conflict (id) do nothing;

-- Petrella Liri / Petrella Alta (SECTOR-023)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000012','00000000-0000-0000-0020-000000000023','Aghetti','aghetti','6c+',9.0,'sport'),
  ('00000000-0000-0000-0030-000000000013','00000000-0000-0000-0020-000000000023','Opopomoz L2','opopomoz-l2','6a+',5.0,'sport'),
  ('00000000-0000-0000-0030-000000000014','00000000-0000-0000-0020-000000000023','Il canto della gabbianella','il-canto-della-gabbianella','6a',4.0,'sport'),
  ('00000000-0000-0000-0030-000000000015','00000000-0000-0000-0020-000000000023','Snikefinger L1','snikefinger-l1','6b+',7.0,'sport')
on conflict (id) do nothing;

-- Tagliacozzo / Scudo centrale (SECTOR-032) — settore candidato
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000016','00000000-0000-0000-0020-000000000032','La spagnola L1','la-spagnola-l1','6b',6.0,'sport'),
  ('00000000-0000-0000-0030-000000000017','00000000-0000-0000-0020-000000000032','Toto bang','toto-bang','6a+',5.0,'sport'),
  ('00000000-0000-0000-0030-000000000018','00000000-0000-0000-0020-000000000032','L''arte di giudicare','l-arte-di-giudicare','7a+',11.0,'sport'),
  ('00000000-0000-0000-0030-000000000019','00000000-0000-0000-0020-000000000032','Inglese','inglese','6b+',7.0,'sport'),
  ('00000000-0000-0000-0030-000000000020','00000000-0000-0000-0020-000000000032','Miky Mouse','miky-mouse','6b+',7.0,'sport'),
  ('00000000-0000-0000-0030-000000000021','00000000-0000-0000-0020-000000000032','Ah Toto','ah-toto','6b',6.0,'sport')
on conflict (id) do nothing;

-- Colle dell'Orso / Blocco P, Q - Morgia Quadra (SECTOR-011)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000022','00000000-0000-0000-0020-000000000011','Charriba','charriba','6c',8.0,'sport'),
  ('00000000-0000-0000-0030-000000000023','00000000-0000-0000-0020-000000000011','Olive fritte L1','olive-fritte-l1','6b',6.0,'sport'),
  ('00000000-0000-0000-0030-000000000024','00000000-0000-0000-0020-000000000011','Fagian Club','fagian-club','6b+',7.0,'sport'),
  ('00000000-0000-0000-0030-000000000025','00000000-0000-0000-0020-000000000011','Socrate','socrate','6a+',5.0,'sport'),
  ('00000000-0000-0000-0030-000000000026','00000000-0000-0000-0020-000000000011','Cardine sinistro','cardine-sinistro','6b',6.0,'sport'),
  ('00000000-0000-0000-0030-000000000027','00000000-0000-0000-0020-000000000011','Pantera nera','pantera-nera','6a+',5.0,'sport')
on conflict (id) do nothing;

-- Grotti / Grotti Bassa - Nuovo Settore (SECTOR-018)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000028','00000000-0000-0000-0020-000000000018','Gli invidiosi','gli-invidiosi','7a',10.0,'sport'),
  ('00000000-0000-0000-0030-000000000029','00000000-0000-0000-0020-000000000018','Il Droga','il-droga','6a',4.0,'sport')
on conflict (id) do nothing;

-- La Fortezza / Principale (SECTOR-019)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000030','00000000-0000-0000-0020-000000000019','La montagna è cultura','la-montagna-e-cultura','6b',6.0,'sport'),
  ('00000000-0000-0000-0030-000000000031','00000000-0000-0000-0020-000000000019','Le scelte','le-scelte','6b',6.0,'sport'),
  ('00000000-0000-0000-0030-000000000032','00000000-0000-0000-0020-000000000019','Negli occhi','negli-occhi','6b',6.0,'sport'),
  ('00000000-0000-0000-0030-000000000033','00000000-0000-0000-0020-000000000019','Albedo','albedo','6c',8.0,'sport'),
  ('00000000-0000-0000-0030-000000000034','00000000-0000-0000-0020-000000000019','La Giggiata','la-giggiata','6b+',7.0,'sport'),
  ('00000000-0000-0000-0030-000000000035','00000000-0000-0000-0020-000000000019','Avanguardia','avanguardia','6b+',7.0,'sport')
on conflict (id) do nothing;

-- Caprile / Le Grandi Panze (SECTOR-010)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000036','00000000-0000-0000-0020-000000000010','Buccia d''arancia','buccia-d-arancia','6a',4.0,'sport')
on conflict (id) do nothing;

-- Caprile / I Gradoni (SECTOR-009)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000037','00000000-0000-0000-0020-000000000009','Collaborazione','collaborazione','6b/6b+',6.0,'sport'),
  ('00000000-0000-0000-0030-000000000038','00000000-0000-0000-0020-000000000009','Senza nome 1','senza-nome-1','6b',6.0,'sport')
on conflict (id) do nothing;

-- Ferentillo / Gabbio (SECTOR-016)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000039','00000000-0000-0000-0020-000000000016','Bombardamentos L1+L2','bombardamentos-l1-l2','6b+',7.0,'sport'),
  ('00000000-0000-0000-0030-000000000040','00000000-0000-0000-0020-000000000016','Alfredo Alfredo L1','alfredo-alfredo-l1','6a',4.0,'sport')
on conflict (id) do nothing;

-- Pietrasecca / Vena Cionca (SECTOR-025)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000041','00000000-0000-0000-0020-000000000025','Auguri Veronica','auguri-veronica','6c',8.0,'sport'),
  ('00000000-0000-0000-0030-000000000042','00000000-0000-0000-0020-000000000025','A sinistra del televisore L1','a-sinistra-del-televisore-l1','6a',4.0,'sport'),
  ('00000000-0000-0000-0030-000000000043','00000000-0000-0000-0020-000000000025','Nasce Lollo','nasce-lollo','6b+',7.0,'sport'),
  ('00000000-0000-0000-0030-000000000044','00000000-0000-0000-0020-000000000025','Rick e Tack','rick-e-tack','6a',4.0,'sport'),
  ('00000000-0000-0000-0030-000000000045','00000000-0000-0000-0020-000000000025','Mannaggia all''ortolano L2','mannaggia-all-ortolano-l2','6b',6.0,'sport'),
  ('00000000-0000-0000-0030-000000000046','00000000-0000-0000-0020-000000000025','Lama non lama L1','lama-non-lama-l1','6a',4.0,'sport'),
  ('00000000-0000-0000-0030-000000000047','00000000-0000-0000-0020-000000000025','Se vi va! L2','se-vi-va-l2','6a',4.0,'sport')
on conflict (id) do nothing;

-- Norma / Placche Rosse (SECTOR-021)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000048','00000000-0000-0000-0020-000000000021','Licantropia','licantropia','7a',10.0,'sport'),
  ('00000000-0000-0000-0030-000000000049','00000000-0000-0000-0020-000000000021','Little frog','little-frog','6b+',7.0,'sport'),
  ('00000000-0000-0000-0030-000000000050','00000000-0000-0000-0020-000000000021','Belfagor','belfagor','6c',8.0,'sport')
on conflict (id) do nothing;

-- Configni / Principale (SECTOR-014)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000051','00000000-0000-0000-0020-000000000014','Rino','rino','6b+',7.0,'sport'),
  ('00000000-0000-0000-0030-000000000052','00000000-0000-0000-0020-000000000014','Il calderone celtico','il-calderone-celtico','6a',4.0,'sport'),
  ('00000000-0000-0000-0030-000000000053','00000000-0000-0000-0020-000000000014','Ai Configni della Realtà','ai-configni-della-realta','6a+',5.0,'sport'),
  ('00000000-0000-0000-0030-000000000054','00000000-0000-0000-0020-000000000014','Pilastrino','pilastrino','6b',6.0,'sport')
on conflict (id) do nothing;

-- Miollet / Destro (SECTOR-020)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000055','00000000-0000-0000-0020-000000000020','Il porco','il-porco','6b',6.0,'sport')
on conflict (id) do nothing;

-- Fraioli / Principale (SECTOR-017)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000056','00000000-0000-0000-0020-000000000017','Schiavo della pietra','schiavo-della-pietra','6b',6.0,'sport')
on conflict (id) do nothing;

-- Subiaco / Regno dei Ragni (SECTOR-028)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000057','00000000-0000-0000-0020-000000000028','Gommolo','gommolo','7a+',11.0,'sport')
on conflict (id) do nothing;

-- Caimari / Adalt (SECTOR-001) — settore candidato
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000058','00000000-0000-0000-0020-000000000001','Relaya la Raya L1','relaya-la-raya-l1','6b',6.0,'sport'),
  ('00000000-0000-0000-0030-000000000059','00000000-0000-0000-0020-000000000001','Cachinochalgo left','cachinochalgo-left','7a',10.0,'sport')
on conflict (id) do nothing;

-- Cala Magraner / Xorics (SECTOR-008) + Estrema Sinistra (SECTOR-005) — settori candidati
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000060','00000000-0000-0000-0020-000000000008','Xorics','xorics','6b+',7.0,'sport'),
  ('00000000-0000-0000-0030-000000000061','00000000-0000-0000-0020-000000000005','Not dangerous','not-dangerous','6b+',7.0,'sport'),
  ('00000000-0000-0000-0030-000000000062','00000000-0000-0000-0020-000000000005','Nautilus','nautilus','6a',4.0,'sport')
on conflict (id) do nothing;

-- Ulassai / Torre dei Venti (SECTOR-035)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000063','00000000-0000-0000-0020-000000000035','Curiosape','curiosape','6c+',9.0,'sport'),
  ('00000000-0000-0000-0030-000000000064','00000000-0000-0000-0020-000000000035','La fuga della capretta','la-fuga-della-capretta','6b+',7.0,'sport')
on conflict (id) do nothing;

-- Ulassai / Il Canyon (SECTOR-034)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000065','00000000-0000-0000-0020-000000000034','Fruttolo L1+L2','fruttolo-l1-l2','6c+',9.0,'sport'),
  ('00000000-0000-0000-0030-000000000066','00000000-0000-0000-0020-000000000034','Arcipelaghi L1','arcipelaghi-l1','6b',6.0,'sport'),
  ('00000000-0000-0000-0030-000000000067','00000000-0000-0000-0020-000000000034','Non luogo','non-luogo','6c',8.0,'sport'),
  ('00000000-0000-0000-0030-000000000068','00000000-0000-0000-0020-000000000034','Vision Crack','vision-crack','6a+',5.0,'sport'),
  ('00000000-0000-0000-0030-000000000069','00000000-0000-0000-0020-000000000034','Educanza L1','educanza-l1','6b+',7.0,'sport')
on conflict (id) do nothing;

-- Ripa Majala / Principale (SECTOR-027)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000070','00000000-0000-0000-0020-000000000027','Il mestiere di vivere','il-mestiere-di-vivere','6c',8.0,'sport'),
  ('00000000-0000-0000-0030-000000000071','00000000-0000-0000-0020-000000000027','Mea culpa','mea-culpa','6a',4.0,'sport'),
  ('00000000-0000-0000-0030-000000000072','00000000-0000-0000-0020-000000000027','Ore perse','ore-perse','6b+',7.0,'sport'),
  ('00000000-0000-0000-0030-000000000073','00000000-0000-0000-0020-000000000027','Regina della notte','regina-della-notte','6b+',7.0,'sport'),
  ('00000000-0000-0000-0030-000000000074','00000000-0000-0000-0020-000000000027','Gola profonda L2','gola-profonda-l2','6b',6.0,'sport'),
  ('00000000-0000-0000-0030-000000000075','00000000-0000-0000-0020-000000000027','Eskimo','eskimo','6a',4.0,'sport'),
  ('00000000-0000-0000-0030-000000000076','00000000-0000-0000-0020-000000000027','Un grammo di paura','un-grammo-di-paura','6b',6.0,'sport'),
  ('00000000-0000-0000-0030-000000000077','00000000-0000-0000-0020-000000000027','Ottobre rosso','ottobre-rosso','6a',4.0,'sport')
on conflict (id) do nothing;

-- Ovindoli / Val d'Arano (SECTOR-022)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000078','00000000-0000-0000-0020-000000000022','Tormentilla','tormentilla','6c',8.0,'sport'),
  ('00000000-0000-0000-0030-000000000079','00000000-0000-0000-0020-000000000022','Forse accadde così','forse-accadde-cosi','6c',8.0,'sport')
on conflict (id) do nothing;

-- Pizzoferrato / Principale (SECTOR-026)
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, route_type)
values
  ('00000000-0000-0000-0030-000000000080','00000000-0000-0000-0020-000000000026','Passione','passione','6b',6.0,'sport')
on conflict (id) do nothing;

-- ─── Ascensioni (80 canonical) — Flavio DiFoggia ─────────────
do $$
declare
  uid uuid;
begin
  select id into uid from auth.users where email = 'flavioaugusto.difoggia@gmail.com';
  if uid is null then
    raise exception 'Utente flavioaugusto.difoggia@gmail.com non trovato in auth.users. Eseguire il seed dopo la registrazione.';
  end if;

  insert into public.ascents
    (id, user_id, route_id, date, status, attempt_type,
     grade_at_ascent, grade_numeric_at_ascent, visibility, notes)
  values
    -- 2026
    ('00000000-0000-0000-0050-000000000001',uid,'00000000-0000-0000-0030-000000000001','2026-06-20','completed','second','7a+',11.0,'private',null),
    ('00000000-0000-0000-0050-000000000002',uid,'00000000-0000-0000-0030-000000000002','2026-06-20','completed','four_plus','7a',10.0,'private',null),
    ('00000000-0000-0000-0050-000000000003',uid,'00000000-0000-0000-0030-000000000008','2026-06-01','completed','onsight','6c+',9.0,'private','Potrei aver aggirato il primo passo passando da dx.'),
    ('00000000-0000-0000-0050-000000000004',uid,'00000000-0000-0000-0030-000000000009','2026-06-01','completed','onsight','6b+',7.0,'private',null),
    ('00000000-0000-0000-0050-000000000005',uid,'00000000-0000-0000-0030-000000000016','2026-05-31','completed','onsight','6b',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000006',uid,'00000000-0000-0000-0030-000000000017','2026-05-31','completed','onsight','6a+',5.0,'private',null),
    ('00000000-0000-0000-0050-000000000007',uid,'00000000-0000-0000-0030-000000000018','2026-05-23','completed','second','7a+',11.0,'private',null),
    ('00000000-0000-0000-0050-000000000008',uid,'00000000-0000-0000-0030-000000000019','2026-05-23','completed','onsight','6b+',7.0,'private',null),
    ('00000000-0000-0000-0050-000000000009',uid,'00000000-0000-0000-0030-000000000022','2026-05-03','completed','flash','6c',8.0,'private',null),
    ('00000000-0000-0000-0050-000000000010',uid,'00000000-0000-0000-0030-000000000023','2026-05-03','completed','onsight','6b',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000011',uid,'00000000-0000-0000-0030-000000000024','2026-05-03','completed','onsight','6b+',7.0,'private',null),
    ('00000000-0000-0000-0050-000000000012',uid,'00000000-0000-0000-0030-000000000025','2026-05-03','completed','second','6a+',5.0,'private',null),
    ('00000000-0000-0000-0050-000000000013',uid,'00000000-0000-0000-0030-000000000026','2026-05-02','completed','onsight','6b',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000014',uid,'00000000-0000-0000-0030-000000000027','2026-05-02','completed','onsight','6a+',5.0,'private',null),
    ('00000000-0000-0000-0050-000000000015',uid,'00000000-0000-0000-0030-000000000028','2026-04-26','completed','third','7a',10.0,'private',null),
    ('00000000-0000-0000-0050-000000000016',uid,'00000000-0000-0000-0030-000000000003','2026-04-19','completed','flash','6b',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000017',uid,'00000000-0000-0000-0030-000000000004','2026-04-19','completed','second','6c+/7a',9.0,'private',null),
    ('00000000-0000-0000-0050-000000000018',uid,'00000000-0000-0000-0030-000000000005','2026-04-11','completed','flash','6b',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000019',uid,'00000000-0000-0000-0030-000000000006','2026-04-11','completed','second','6c',8.0,'private',null),
    ('00000000-0000-0000-0050-000000000020',uid,'00000000-0000-0000-0030-000000000007','2026-04-11','completed','onsight','6c/6c+',8.0,'private',null),
    ('00000000-0000-0000-0050-000000000021',uid,'00000000-0000-0000-0030-000000000030','2026-03-29','completed','flash','6b',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000022',uid,'00000000-0000-0000-0030-000000000041','2026-03-21','completed','second','6c',8.0,'private',null),
    ('00000000-0000-0000-0050-000000000023',uid,'00000000-0000-0000-0030-000000000031','2026-03-01','completed','onsight','6b',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000024',uid,'00000000-0000-0000-0030-000000000032','2026-03-01','completed','onsight','6b',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000025',uid,'00000000-0000-0000-0030-000000000036','2026-02-17','completed','onsight','6a',4.0,'private',null),
    ('00000000-0000-0000-0050-000000000026',uid,'00000000-0000-0000-0030-000000000037','2026-02-15','completed','second','6b/6b+',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000027',uid,'00000000-0000-0000-0030-000000000038','2026-02-15','completed','second','6b',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000028',uid,'00000000-0000-0000-0030-000000000039','2026-01-18','completed','second','6b+',7.0,'private',null),
    ('00000000-0000-0000-0050-000000000029',uid,'00000000-0000-0000-0030-000000000040','2026-01-18','completed','onsight','6a',4.0,'private',null),
    -- 2025
    ('00000000-0000-0000-0050-000000000030',uid,'00000000-0000-0000-0030-000000000042','2025-12-26','completed','onsight','6a',4.0,'private',null),
    ('00000000-0000-0000-0050-000000000031',uid,'00000000-0000-0000-0030-000000000043','2025-12-26','completed','onsight','6b+',7.0,'private',null),
    ('00000000-0000-0000-0050-000000000032',uid,'00000000-0000-0000-0030-000000000044','2025-12-26','completed','onsight','6a',4.0,'private',null),
    ('00000000-0000-0000-0050-000000000033',uid,'00000000-0000-0000-0030-000000000045','2025-12-26','completed','onsight','6b',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000034',uid,'00000000-0000-0000-0030-000000000046','2025-12-20','completed','onsight','6a',4.0,'private',null),
    ('00000000-0000-0000-0050-000000000035',uid,'00000000-0000-0000-0030-000000000047','2025-12-19','completed','onsight','6a',4.0,'private',null),
    -- 2024
    ('00000000-0000-0000-0050-000000000036',uid,'00000000-0000-0000-0030-000000000048','2024-09-28','completed','onsight','7a',10.0,'private',null),
    ('00000000-0000-0000-0050-000000000037',uid,'00000000-0000-0000-0030-000000000049','2024-09-28','completed','onsight','6b+',7.0,'private',null),
    ('00000000-0000-0000-0050-000000000038',uid,'00000000-0000-0000-0030-000000000050','2024-09-28','completed','flash','6c',8.0,'private',null),
    ('00000000-0000-0000-0050-000000000039',uid,'00000000-0000-0000-0030-000000000012','2024-08-21','completed','second','6c+',9.0,'private',null),
    ('00000000-0000-0000-0050-000000000040',uid,'00000000-0000-0000-0030-000000000051','2024-08-21','completed','onsight','6b+',7.0,'private',null),
    ('00000000-0000-0000-0050-000000000041',uid,'00000000-0000-0000-0030-000000000055','2024-08-09','completed','onsight','6b',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000042',uid,'00000000-0000-0000-0030-000000000020','2024-07-25','completed','four_plus','6b+',7.0,'private',null),
    ('00000000-0000-0000-0050-000000000043',uid,'00000000-0000-0000-0030-000000000021','2024-07-24','completed','onsight','6b',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000044',uid,'00000000-0000-0000-0030-000000000013','2024-07-14','completed','onsight','6a+',5.0,'private',null),
    ('00000000-0000-0000-0050-000000000045',uid,'00000000-0000-0000-0030-000000000014','2024-06-23','completed','onsight','6a',4.0,'private',null),
    ('00000000-0000-0000-0050-000000000046',uid,'00000000-0000-0000-0030-000000000056','2024-06-09','completed','onsight','6b',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000047',uid,'00000000-0000-0000-0030-000000000063','2024-05-29','completed','second','6c+',9.0,'private',null),
    ('00000000-0000-0000-0050-000000000048',uid,'00000000-0000-0000-0030-000000000065','2024-05-28','completed','onsight','6c+',9.0,'private',null),
    ('00000000-0000-0000-0050-000000000049',uid,'00000000-0000-0000-0030-000000000064','2024-05-27','completed','onsight','6b+',7.0,'private',null),
    ('00000000-0000-0000-0050-000000000050',uid,'00000000-0000-0000-0030-000000000066','2024-05-26','completed','flash','6b',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000051',uid,'00000000-0000-0000-0030-000000000067','2024-05-26','completed','second','6c',8.0,'private',null),
    ('00000000-0000-0000-0050-000000000052',uid,'00000000-0000-0000-0030-000000000068','2024-05-26','completed','onsight','6a+',5.0,'private',null),
    ('00000000-0000-0000-0050-000000000053',uid,'00000000-0000-0000-0030-000000000069','2024-05-26','completed','flash','6b+',7.0,'private',null),
    ('00000000-0000-0000-0050-000000000054',uid,'00000000-0000-0000-0030-000000000057','2024-04-14','completed','four_plus','7a+',11.0,'private',null),
    ('00000000-0000-0000-0050-000000000055',uid,'00000000-0000-0000-0030-000000000029','2024-04-12','completed','onsight','6a',4.0,'private',null),
    ('00000000-0000-0000-0050-000000000056',uid,'00000000-0000-0000-0030-000000000058','2024-04-05','completed','onsight','6b',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000057',uid,'00000000-0000-0000-0030-000000000059','2024-04-05','completed','second','7a',10.0,'private',null),
    ('00000000-0000-0000-0050-000000000058',uid,'00000000-0000-0000-0030-000000000060','2024-04-04','completed','onsight','6b+',7.0,'private',null),
    ('00000000-0000-0000-0050-000000000059',uid,'00000000-0000-0000-0030-000000000061','2024-04-04','completed','second','6b+',7.0,'private',null),
    ('00000000-0000-0000-0050-000000000060',uid,'00000000-0000-0000-0030-000000000062','2024-04-04','completed','onsight','6a',4.0,'private',null),
    ('00000000-0000-0000-0050-000000000061',uid,'00000000-0000-0000-0030-000000000033','2024-03-31','completed','second','6c',8.0,'private',null),
    ('00000000-0000-0000-0050-000000000062',uid,'00000000-0000-0000-0030-000000000034','2024-03-31','completed','flash','6b+',7.0,'private',null),
    ('00000000-0000-0000-0050-000000000063',uid,'00000000-0000-0000-0030-000000000035','2024-03-26','completed','flash','6b+',7.0,'private',null),
    -- 2023
    ('00000000-0000-0000-0050-000000000064',uid,'00000000-0000-0000-0030-000000000070','2023-12-24','completed','third','6c',8.0,'private',null),
    ('00000000-0000-0000-0050-000000000065',uid,'00000000-0000-0000-0030-000000000071','2023-12-24','completed','onsight','6a',4.0,'private',null),
    ('00000000-0000-0000-0050-000000000066',uid,'00000000-0000-0000-0030-000000000072','2023-09-15','completed','second','6b+',7.0,'private',null),
    ('00000000-0000-0000-0050-000000000067',uid,'00000000-0000-0000-0030-000000000078','2023-09-14','completed','second','6c',8.0,'private',null),
    ('00000000-0000-0000-0050-000000000068',uid,'00000000-0000-0000-0030-000000000079','2023-09-14','completed','third','6c',8.0,'private',null),
    ('00000000-0000-0000-0050-000000000069',uid,'00000000-0000-0000-0030-000000000052','2023-09-12','completed','onsight','6a',4.0,'private',null),
    ('00000000-0000-0000-0050-000000000070',uid,'00000000-0000-0000-0030-000000000053','2023-09-12','completed','onsight','6a+',5.0,'private',null),
    ('00000000-0000-0000-0050-000000000071',uid,'00000000-0000-0000-0030-000000000054','2023-09-12','completed','onsight','6b',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000072',uid,'00000000-0000-0000-0030-000000000010','2023-09-08','completed','onsight','6b+',7.0,'private',null),
    ('00000000-0000-0000-0050-000000000073',uid,'00000000-0000-0000-0030-000000000011','2023-09-07','completed','second','6c',8.0,'private',null),
    ('00000000-0000-0000-0050-000000000074',uid,'00000000-0000-0000-0030-000000000015','2023-09-05','completed','four_plus','6b+',7.0,'private',null),
    ('00000000-0000-0000-0050-000000000075',uid,'00000000-0000-0000-0030-000000000080','2023-08-15','completed','second','6b',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000076',uid,'00000000-0000-0000-0030-000000000073','2023-07-29','completed','third','6b+',7.0,'private',null),
    ('00000000-0000-0000-0050-000000000077',uid,'00000000-0000-0000-0030-000000000074','2023-07-22','completed','third','6b',6.0,'private',null),
    -- 2022
    ('00000000-0000-0000-0050-000000000078',uid,'00000000-0000-0000-0030-000000000075','2022-12-17','completed','onsight','6a',4.0,'private',null),
    ('00000000-0000-0000-0050-000000000079',uid,'00000000-0000-0000-0030-000000000076','2022-10-09','completed','second','6b',6.0,'private',null),
    ('00000000-0000-0000-0050-000000000080',uid,'00000000-0000-0000-0030-000000000077','2022-09-30','completed','onsight','6a',4.0,'private',null)
  on conflict (id) do nothing;
end $$;
