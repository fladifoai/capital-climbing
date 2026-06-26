-- ============================================================
-- 001_schema.sql — Tabelle, funzioni e trigger
-- ============================================================

-- Funzione riutilizzabile per aggiornare updated_at
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- ────────────────────────────────────────────────────────────
-- UTENTI
-- ────────────────────────────────────────────────────────────

create table public.profiles (
  id              uuid primary key references auth.users(id) on delete cascade,
  username        text unique not null,
  display_name    text not null default '',
  avatar_url      text,
  bio             text,
  country         text,
  city            text,
  climbing_since  integer check (climbing_since >= 1900 and climbing_since <= 2100),
  preferred_style text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create trigger trg_profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

create index idx_profiles_username on public.profiles(username);

-- ────────────────────────────────────────────────────────────

create table public.user_roles (
  user_id    uuid not null references auth.users(id) on delete cascade,
  role       text not null check (role in ('user', 'admin')),
  created_at timestamptz not null default now(),
  primary key (user_id, role)
);

-- Funzione is_admin() — usata nelle policy RLS
create or replace function public.is_admin()
returns boolean as $$
  select exists (
    select 1 from public.user_roles
    where user_id = auth.uid() and role = 'admin'
  );
$$ language sql security definer stable;

-- Trigger: crea profilo e ruolo utente automaticamente alla registrazione
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, username, display_name)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'username', split_part(new.email, '@', 1)),
    coalesce(new.raw_user_meta_data->>'display_name', split_part(new.email, '@', 1))
  );
  insert into public.user_roles (user_id, role)
  values (new.id, 'user');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ────────────────────────────────────────────────────────────
-- CATALOGO
-- ────────────────────────────────────────────────────────────

create table public.sources (
  id                     uuid primary key default gen_random_uuid(),
  name                   text not null,
  url                    text,
  license                text,
  permission_status      text default 'unknown',
  can_publish            boolean default false,
  can_use_for_statistics boolean default true,
  attribution            text,
  notes                  text,
  created_at             timestamptz not null default now()
);

-- ────────────────────────────────────────────────────────────

create table public.crags (
  id                   uuid primary key default gen_random_uuid(),
  name                 text not null,
  normalized_name      text not null,
  country              text not null default 'Italy',
  region               text,
  province             text,
  latitude             numeric(9,6),
  longitude            numeric(9,6),
  altitude_m           integer,
  rock_type            text,
  parking_notes        text,
  access_notes         text,
  approach_minutes     integer,
  approach_distance_km numeric(5,2),
  orientation          text,
  best_seasons         text[],
  rainproof            boolean default false,
  services             jsonb default '{}',
  access_status        text default 'open',
  last_verified_at     timestamptz,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now()
);

create trigger trg_crags_updated_at
  before update on public.crags
  for each row execute function public.set_updated_at();

create index idx_crags_normalized_name on public.crags(normalized_name);
create index idx_crags_country_region  on public.crags(country, region);

-- ────────────────────────────────────────────────────────────

create table public.sectors (
  id              uuid primary key default gen_random_uuid(),
  crag_id         uuid not null references public.crags(id) on delete cascade,
  name            text not null,
  normalized_name text not null,
  description     text,
  orientation     text,
  approach_notes  text,
  sort_order      integer default 0,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create trigger trg_sectors_updated_at
  before update on public.sectors
  for each row execute function public.set_updated_at();

create index idx_sectors_crag_id on public.sectors(crag_id);

-- ────────────────────────────────────────────────────────────

create table public.routes (
  id              uuid primary key default gen_random_uuid(),
  sector_id       uuid not null references public.sectors(id) on delete cascade,
  name            text not null,
  normalized_name text not null,
  official_grade  text,
  grade_numeric   numeric(4,1),
  length_m        integer,
  pitches         integer default 1,
  bolts           integer,
  angle           text,
  route_type      text default 'sport',
  rock_type       text,
  first_ascent    text,
  bolter          text,
  description     text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

create trigger trg_routes_updated_at
  before update on public.routes
  for each row execute function public.set_updated_at();

create index idx_routes_sector_id      on public.routes(sector_id);
create index idx_routes_normalized_name on public.routes(normalized_name);
create index idx_routes_grade_numeric  on public.routes(grade_numeric);

-- ────────────────────────────────────────────────────────────

create table public.route_aliases (
  id               uuid primary key default gen_random_uuid(),
  route_id         uuid not null references public.routes(id) on delete cascade,
  alias            text not null,
  normalized_alias text not null,
  source_id        uuid references public.sources(id),
  created_at       timestamptz not null default now()
);

create index idx_route_aliases_route_id on public.route_aliases(route_id);

-- ────────────────────────────────────────────────────────────

create table public.route_sources (
  route_id    uuid not null references public.routes(id) on delete cascade,
  source_id   uuid not null references public.sources(id) on delete cascade,
  external_id text,
  source_url  text,
  retrieved_at timestamptz,
  created_at  timestamptz not null default now(),
  primary key (route_id, source_id)
);

-- ────────────────────────────────────────────────────────────
-- DATI PERSONALI
-- ────────────────────────────────────────────────────────────

create table public.sessions (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references auth.users(id) on delete cascade,
  crag_id        uuid references public.crags(id),
  sector_id      uuid references public.sectors(id),
  date           date not null,
  temperature    integer,
  humidity       integer,
  wind           text,
  conditions     text,
  rock_condition text,
  partner        text,
  sleep_quality  integer check (sleep_quality between 1 and 5),
  rest_days      integer,
  session_rpe    integer check (session_rpe between 1 and 10),
  notes          text,
  visibility     text not null default 'private' check (visibility in ('public', 'private')),
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now()
);

create trigger trg_sessions_updated_at
  before update on public.sessions
  for each row execute function public.set_updated_at();

create index idx_sessions_user_id on public.sessions(user_id);
create index idx_sessions_date    on public.sessions(date);

-- ────────────────────────────────────────────────────────────

create table public.ascents (
  id                     uuid primary key default gen_random_uuid(),
  user_id                uuid not null references auth.users(id) on delete cascade,
  route_id               uuid not null references public.routes(id),
  session_id             uuid references public.sessions(id),
  date                   date not null,
  status                 text not null check (status in ('completed', 'attempted', 'project')),
  attempt_type           text check (attempt_type in ('onsight', 'flash', 'second', 'third', 'four_plus', 'redpoint')),
  grade_at_ascent        text,
  grade_numeric_at_ascent numeric(4,1),
  score                  numeric(8,2),
  personal_grade         text,
  kneepad_used           boolean,
  effort                 integer check (effort between 1 and 10),
  notes                  text,
  visibility             text not null default 'private' check (visibility in ('public', 'private')),
  created_at             timestamptz not null default now(),
  updated_at             timestamptz not null default now()
);

create trigger trg_ascents_updated_at
  before update on public.ascents
  for each row execute function public.set_updated_at();

create index idx_ascents_user_id  on public.ascents(user_id);
create index idx_ascents_route_id on public.ascents(route_id);
create index idx_ascents_date     on public.ascents(date);

-- ────────────────────────────────────────────────────────────

create table public.projects (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid not null references auth.users(id) on delete cascade,
  route_id          uuid not null references public.routes(id),
  opened_date       date,
  last_session_date date,
  priority          text default 'medium' check (priority in ('high', 'medium', 'low')),
  status            text not null default 'active' check (status in ('active', 'paused', 'completed', 'abandoned')),
  sessions_count    integer default 0,
  attempts_count    integer default 0,
  progress          integer default 0 check (progress between 0 and 100),
  high_point        text,
  moves_solved      text,
  moves_missing     text,
  next_strategy     text,
  beta_notes        text,
  visibility        text not null default 'private' check (visibility in ('public', 'private')),
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

create trigger trg_projects_updated_at
  before update on public.projects
  for each row execute function public.set_updated_at();

create index idx_projects_user_id  on public.projects(user_id);
create index idx_projects_route_id on public.projects(route_id);

-- ────────────────────────────────────────────────────────────

create table public.attempts (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references auth.users(id) on delete cascade,
  session_id     uuid references public.sessions(id),
  route_id       uuid not null references public.routes(id),
  attempt_number integer default 1,
  result         text check (result in ('send', 'attempt', 'top_rope')),
  high_point     text,
  fall_move      text,
  beta_used      text,
  kneepad_used   boolean,
  shoes          text,
  effort         integer check (effort between 1 and 10),
  rest_minutes   integer,
  notes          text,
  visibility     text not null default 'private' check (visibility in ('public', 'private')),
  created_at     timestamptz not null default now()
);

create index idx_attempts_user_id    on public.attempts(user_id);
create index idx_attempts_session_id on public.attempts(session_id);
create index idx_attempts_route_id   on public.attempts(route_id);

-- ────────────────────────────────────────────────────────────

create table public.user_route_notes (
  id               uuid primary key default gen_random_uuid(),
  user_id          uuid not null references auth.users(id) on delete cascade,
  route_id         uuid not null references public.routes(id) on delete cascade,
  hold_profile     jsonb default '{}',
  movement_profile jsonb default '{}',
  style_profile    jsonb default '{}',
  crux             text,
  rests            text,
  main_beta        text,
  alternative_beta text,
  kneepad_data     jsonb default '{}',
  equipment_data   jsonb default '{}',
  safety_notes     text,
  visibility       text not null default 'private' check (visibility in ('public', 'private')),
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),
  unique (user_id, route_id)
);

create trigger trg_user_route_notes_updated_at
  before update on public.user_route_notes
  for each row execute function public.set_updated_at();

-- ────────────────────────────────────────────────────────────
-- IMPORT
-- ────────────────────────────────────────────────────────────

create table public.import_jobs (
  id           uuid primary key default gen_random_uuid(),
  created_by   uuid not null references auth.users(id),
  filename     text not null,
  status       text not null default 'pending' check (status in ('pending', 'processing', 'completed', 'failed')),
  total_rows   integer default 0,
  valid_rows   integer default 0,
  invalid_rows integer default 0,
  created_at   timestamptz not null default now(),
  completed_at timestamptz
);

create table public.import_rows (
  id               uuid primary key default gen_random_uuid(),
  import_job_id    uuid not null references public.import_jobs(id) on delete cascade,
  row_number       integer not null,
  raw_data         jsonb not null default '{}',
  normalized_data  jsonb default '{}',
  status           text not null default 'pending' check (status in ('pending', 'valid', 'invalid', 'imported')),
  errors           jsonb default '[]',
  created_at       timestamptz not null default now()
);

create index idx_import_rows_job_id on public.import_rows(import_job_id);
