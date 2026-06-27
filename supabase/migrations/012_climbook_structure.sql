-- ============================================================
-- 012_climbook_structure.sql
-- Struttura falesie ispirata a Climbook:
-- Paese > Regione > Area > Falesia > Settore > Sottosettore > Via
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- SLUGIFY helper
-- ────────────────────────────────────────────────────────────

create extension if not exists unaccent;

create or replace function public.slugify(input text)
returns text as $$
  select trim(both '-' from regexp_replace(
    lower(unaccent(input)),
    '[^a-z0-9]+', '-', 'g'
  ));
$$ language sql immutable;

-- ────────────────────────────────────────────────────────────
-- CRAGS — aggiungi slug e aliases
-- ────────────────────────────────────────────────────────────

alter table public.crags
  add column if not exists slug    text,
  add column if not exists aliases text[] not null default '{}';

update public.crags set slug = public.slugify(normalized_name) where slug is null;

create index if not exists idx_crags_slug on public.crags(slug);

-- ────────────────────────────────────────────────────────────
-- SECTORS — aggiungi parent_sector_id, slug, aliases
-- ────────────────────────────────────────────────────────────

alter table public.sectors
  add column if not exists parent_sector_id uuid references public.sectors(id),
  add column if not exists slug             text,
  add column if not exists aliases          text[] not null default '{}';

update public.sectors set slug = public.slugify(normalized_name) where slug is null;

create index if not exists idx_sectors_parent_id on public.sectors(parent_sector_id);
create index if not exists idx_sectors_slug       on public.sectors(crag_id, slug);

-- ────────────────────────────────────────────────────────────
-- ROUTES — crag_id diretto, sector_id opzionale, campi community
-- ────────────────────────────────────────────────────────────

alter table public.routes
  add column if not exists crag_id                  uuid references public.crags(id),
  add column if not exists slug                     text,
  add column if not exists community_grade_raw      text,
  add column if not exists community_grade_numeric  numeric(4,1),
  add column if not exists notes_public             text,
  add column if not exists safety_notes             text,
  add column if not exists beauty_avg               numeric(3,2),
  add column if not exists repetitions_count        integer not null default 0,
  add column if not exists source                   text,
  add column if not exists source_url               text;

-- Rende sector_id opzionale (era NOT NULL)
alter table public.routes
  alter column sector_id drop not null;

-- Backfill crag_id da sector -> crag
update public.routes r
  set crag_id = s.crag_id
  from public.sectors s
  where r.sector_id = s.id
    and r.crag_id is null;

-- Constraint: almeno uno tra crag_id e sector_id deve essere valorizzato
alter table public.routes
  add constraint routes_crag_or_sector_check
    check (crag_id is not null or sector_id is not null);

update public.routes set slug = public.slugify(normalized_name) where slug is null;

create index if not exists idx_routes_crag_id on public.routes(crag_id);
create index if not exists idx_routes_slug     on public.routes(crag_id, slug);

-- ────────────────────────────────────────────────────────────
-- ASCENTS — snapshot dei dati catalogo al momento dell'ascensione
-- ────────────────────────────────────────────────────────────

alter table public.ascents
  add column if not exists route_name_snapshot          text,
  add column if not exists crag_name_snapshot           text,
  add column if not exists sector_name_snapshot         text,
  add column if not exists grade_snapshot               text,
  add column if not exists community_grade_snapshot     text;

-- ────────────────────────────────────────────────────────────
-- IMPORT ROWS — flag per revisione admin
-- ────────────────────────────────────────────────────────────

alter table public.import_rows
  add column if not exists needs_review boolean not null default false;

-- ────────────────────────────────────────────────────────────
-- EXTERNAL SOURCES — traccia fonte dati per crag/sector/route
-- ────────────────────────────────────────────────────────────

create table if not exists public.external_sources (
  id           uuid primary key default gen_random_uuid(),
  entity_type  text not null check (entity_type in ('crag', 'sector', 'route')),
  entity_id    uuid not null,
  source_name  text not null,
  source_url   text,
  external_id  text,
  raw_name     text,
  raw_payload  jsonb,
  imported_at  timestamptz not null default now()
);

create index if not exists idx_external_sources_entity
  on public.external_sources(entity_type, entity_id);

alter table public.external_sources enable row level security;

create policy "external_sources_select_all" on public.external_sources
  for select using (true);

create policy "external_sources_admin_write" on public.external_sources
  for all using (public.is_admin()) with check (public.is_admin());
