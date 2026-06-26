-- ============================================================
-- 004_territories.sql — Tabelle territoriali e aggiornamento schema
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- PAESI
-- ────────────────────────────────────────────────────────────

create table public.countries (
  id         uuid primary key default gen_random_uuid(),
  name       text not null,
  iso2       text unique not null,
  slug       text unique not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger trg_countries_updated_at
  before update on public.countries
  for each row execute function public.set_updated_at();

-- ────────────────────────────────────────────────────────────
-- REGIONI
-- ────────────────────────────────────────────────────────────

create table public.regions (
  id              uuid primary key default gen_random_uuid(),
  country_id      uuid not null references public.countries(id) on delete cascade,
  name            text not null,
  normalized_name text not null,
  slug            text not null,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  unique (country_id, normalized_name),
  unique (country_id, slug)
);

create trigger trg_regions_updated_at
  before update on public.regions
  for each row execute function public.set_updated_at();

create index idx_regions_country_id on public.regions(country_id);

-- ────────────────────────────────────────────────────────────
-- AREE TERRITORIALI
-- ────────────────────────────────────────────────────────────

create table public.areas (
  id              uuid primary key default gen_random_uuid(),
  region_id       uuid not null references public.regions(id) on delete cascade,
  name            text not null,
  normalized_name text not null,
  slug            text not null,
  area_type       text not null default 'custom'
    check (area_type in ('province', 'climbing_area', 'valley', 'island', 'municipality_group', 'custom')),
  description     text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  unique (region_id, normalized_name),
  unique (region_id, slug)
);

create trigger trg_areas_updated_at
  before update on public.areas
  for each row execute function public.set_updated_at();

create index idx_areas_region_id on public.areas(region_id);

-- ────────────────────────────────────────────────────────────
-- AGGIORNAMENTO TABELLA CRAGS
-- ────────────────────────────────────────────────────────────

alter table public.crags
  add column country_id   uuid references public.countries(id),
  add column region_id    uuid references public.regions(id),
  add column area_id      uuid references public.areas(id),
  add column municipality text;

create index idx_crags_country_id on public.crags(country_id);
create index idx_crags_region_id  on public.crags(region_id);
create index idx_crags_area_id    on public.crags(area_id);

-- ────────────────────────────────────────────────────────────
-- AGGIORNAMENTO TABELLA ROUTES
-- ────────────────────────────────────────────────────────────

alter table public.routes
  add column line_order     integer,
  add column position_label text;

create index idx_routes_line_order on public.routes(sector_id, line_order);

-- ────────────────────────────────────────────────────────────
-- RLS
-- ────────────────────────────────────────────────────────────

alter table public.countries enable row level security;
alter table public.regions   enable row level security;
alter table public.areas     enable row level security;

-- Lettura pubblica
create policy "countries_select_all" on public.countries for select using (true);
create policy "regions_select_all"   on public.regions   for select using (true);
create policy "areas_select_all"     on public.areas     for select using (true);

-- Scrittura solo admin
create policy "countries_admin_write" on public.countries
  for all using (public.is_admin()) with check (public.is_admin());

create policy "regions_admin_write" on public.regions
  for all using (public.is_admin()) with check (public.is_admin());

create policy "areas_admin_write" on public.areas
  for all using (public.is_admin()) with check (public.is_admin());
