-- ============================================================
-- 036_countries_layer.sql — Nazioni Francia + regioni estere mancanti
-- Abilita lo strato Nazioni nel catalogo (Italia › Francia › Spagna).
-- Idempotente: rilanciabile senza errori.
-- ============================================================

-- Paese: Francia
insert into public.countries (id, name, iso2, slug)
values ('00000000-0000-0000-0001-000000000003', 'Francia', 'FR', 'france')
on conflict (id) do nothing;

-- Regioni estere mancanti (nome bilingue: italiano + nativo)
insert into public.regions (id, country_id, name, normalized_name, slug) values
  ('00000000-0000-0000-0002-000000000101',
   '00000000-0000-0000-0001-000000000003',
   'Alte Alpi (Hautes-Alpes)', 'alte-alpi', 'alte-alpi'),
  ('00000000-0000-0000-0002-000000000102',
   '00000000-0000-0000-0001-000000000002',
   'Comunità Valenciana (Comunidad Valenciana)', 'comunita-valenciana', 'comunita-valenciana')
on conflict (id) do nothing;
