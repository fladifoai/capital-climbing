-- ============================================================
-- 005_seed_territories.sql — Italia, regioni, aree demo
-- ============================================================

-- Paese: Italia
insert into public.countries (id, name, iso2, slug)
values ('00000000-0000-0000-0001-000000000001', 'Italia', 'IT', 'italy');

-- 20 regioni italiane
insert into public.regions (id, country_id, name, normalized_name, slug) values
  ('00000000-0000-0000-0002-000000000001', '00000000-0000-0000-0001-000000000001', 'Abruzzo',               'abruzzo',               'abruzzo'),
  ('00000000-0000-0000-0002-000000000002', '00000000-0000-0000-0001-000000000001', 'Basilicata',            'basilicata',            'basilicata'),
  ('00000000-0000-0000-0002-000000000003', '00000000-0000-0000-0001-000000000001', 'Calabria',              'calabria',              'calabria'),
  ('00000000-0000-0000-0002-000000000004', '00000000-0000-0000-0001-000000000001', 'Campania',              'campania',              'campania'),
  ('00000000-0000-0000-0002-000000000005', '00000000-0000-0000-0001-000000000001', 'Emilia-Romagna',        'emilia-romagna',        'emilia-romagna'),
  ('00000000-0000-0000-0002-000000000006', '00000000-0000-0000-0001-000000000001', 'Friuli-Venezia Giulia', 'friuli-venezia-giulia', 'friuli-venezia-giulia'),
  ('00000000-0000-0000-0002-000000000007', '00000000-0000-0000-0001-000000000001', 'Lazio',                 'lazio',                 'lazio'),
  ('00000000-0000-0000-0002-000000000008', '00000000-0000-0000-0001-000000000001', 'Liguria',               'liguria',               'liguria'),
  ('00000000-0000-0000-0002-000000000009', '00000000-0000-0000-0001-000000000001', 'Lombardia',             'lombardia',             'lombardia'),
  ('00000000-0000-0000-0002-000000000010', '00000000-0000-0000-0001-000000000001', 'Marche',                'marche',                'marche'),
  ('00000000-0000-0000-0002-000000000011', '00000000-0000-0000-0001-000000000001', 'Molise',                'molise',                'molise'),
  ('00000000-0000-0000-0002-000000000012', '00000000-0000-0000-0001-000000000001', 'Piemonte',              'piemonte',              'piemonte'),
  ('00000000-0000-0000-0002-000000000013', '00000000-0000-0000-0001-000000000001', 'Puglia',                'puglia',                'puglia'),
  ('00000000-0000-0000-0002-000000000014', '00000000-0000-0000-0001-000000000001', 'Sardegna',              'sardegna',              'sardegna'),
  ('00000000-0000-0000-0002-000000000015', '00000000-0000-0000-0001-000000000001', 'Sicilia',               'sicilia',               'sicilia'),
  ('00000000-0000-0000-0002-000000000016', '00000000-0000-0000-0001-000000000001', 'Toscana',               'toscana',               'toscana'),
  ('00000000-0000-0000-0002-000000000017', '00000000-0000-0000-0001-000000000001', 'Trentino-Alto Adige',  'trentino-alto-adige',   'trentino-alto-adige'),
  ('00000000-0000-0000-0002-000000000018', '00000000-0000-0000-0001-000000000001', 'Umbria',                'umbria',                'umbria'),
  ('00000000-0000-0000-0002-000000000019', '00000000-0000-0000-0001-000000000001', 'Valle d''Aosta',        'valle-d-aosta',         'valle-d-aosta'),
  ('00000000-0000-0000-0002-000000000020', '00000000-0000-0000-0001-000000000001', 'Veneto',                'veneto',                'veneto');

-- Aree demo
insert into public.areas (id, region_id, name, normalized_name, slug, area_type) values
  ('00000000-0000-0000-0003-000000000001', '00000000-0000-0000-0002-000000000007', 'L''Aquila',  'l-aquila',  'l-aquila',  'province'),
  ('00000000-0000-0000-0003-000000000002', '00000000-0000-0000-0002-000000000008', 'La Spezia',  'la-spezia', 'la-spezia', 'province');

-- Collega le falesie demo alle entità territoriali
update public.crags set
  country_id   = '00000000-0000-0000-0001-000000000001',
  region_id    = '00000000-0000-0000-0002-000000000007',
  area_id      = '00000000-0000-0000-0003-000000000001',
  municipality = 'Pietrasecca'
where id = '00000000-0000-0000-0000-000000000010';

update public.crags set
  country_id   = '00000000-0000-0000-0001-000000000001',
  region_id    = '00000000-0000-0000-0002-000000000008',
  area_id      = '00000000-0000-0000-0003-000000000002',
  municipality = 'Porto Venere'
where id = '00000000-0000-0000-0000-000000000011';

-- Aggiunge line_order alle vie demo
update public.routes set line_order = 1 where id = '00000000-0000-0000-0000-000000000030';
update public.routes set line_order = 2 where id = '00000000-0000-0000-0000-000000000031';
update public.routes set line_order = 3 where id = '00000000-0000-0000-0000-000000000032';
update public.routes set line_order = 1 where id = '00000000-0000-0000-0000-000000000033';
update public.routes set line_order = 2 where id = '00000000-0000-0000-0000-000000000034';
