-- ============================================================
-- 003_seed_demo.sql — Dati demo (inventati, non reali)
-- Eseguire solo in sviluppo, non in produzione
-- ============================================================

-- Fonte demo
insert into public.sources (id, name, permission_status, can_publish, attribution)
values (
  '00000000-0000-0000-0000-000000000001',
  'Demo seed',
  'internal',
  false,
  'Capital Climbing demo data'
);

-- Falesia demo: Pietrasecca
insert into public.crags (id, name, normalized_name, country, region, province, rock_type, approach_minutes, access_status)
values (
  '00000000-0000-0000-0000-000000000010',
  'Pietrasecca',
  'pietrasecca',
  'Italy',
  'Lazio',
  'L''Aquila',
  'Limestone',
  20,
  'open'
);

-- Settori Pietrasecca
insert into public.sectors (id, crag_id, name, normalized_name, sort_order)
values
  ('00000000-0000-0000-0000-000000000020', '00000000-0000-0000-0000-000000000010', 'Vena Cionca', 'vena-cionca', 1),
  ('00000000-0000-0000-0000-000000000021', '00000000-0000-0000-0000-000000000010', 'Settore Centrale', 'settore-centrale', 2);

-- Vie demo
insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, pitches, route_type)
values
  ('00000000-0000-0000-0000-000000000030', '00000000-0000-0000-0000-000000000020', 'Via Lattea', 'via-lattea', '6a', 1, 1, 'sport'),
  ('00000000-0000-0000-0000-000000000031', '00000000-0000-0000-0000-000000000020', 'Notte Fonda', 'notte-fonda', '6c', 5, 1, 'sport'),
  ('00000000-0000-0000-0000-000000000032', '00000000-0000-0000-0000-000000000021', 'Alba Rossa', 'alba-rossa', '7a', 7, 1, 'sport');

-- Falesia demo: Muzzerone
insert into public.crags (id, name, normalized_name, country, region, province, rock_type, approach_minutes, access_status)
values (
  '00000000-0000-0000-0000-000000000011',
  'Muzzerone',
  'muzzerone',
  'Italy',
  'Liguria',
  'La Spezia',
  'Granite',
  40,
  'open'
);

insert into public.sectors (id, crag_id, name, normalized_name, sort_order)
values
  ('00000000-0000-0000-0000-000000000022', '00000000-0000-0000-0000-000000000011', 'Settore Mare', 'settore-mare', 1);

insert into public.routes (id, sector_id, name, normalized_name, official_grade, grade_numeric, pitches, route_type)
values
  ('00000000-0000-0000-0000-000000000033', '00000000-0000-0000-0000-000000000022', 'Mare Mosso', 'mare-mosso', '6b+', 4, 1, 'sport'),
  ('00000000-0000-0000-0000-000000000034', '00000000-0000-0000-0000-000000000022', 'Tramontana', 'tramontana', '7b', 10, 1, 'sport');
