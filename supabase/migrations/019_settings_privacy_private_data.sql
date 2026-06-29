-- ============================================================
-- 019_settings_privacy_private_data.sql
-- Blocco 7 — Impostazioni account: privacy, dati privati,
-- periodi di infortunio, soft delete profilo.
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- PROFILES — colonne privacy + soft delete
-- ────────────────────────────────────────────────────────────

alter table public.profiles
  add column if not exists is_public           boolean not null default true,
  add column if not exists show_ascents        boolean not null default true,
  add column if not exists show_projects       boolean not null default true,
  add column if not exists show_stats          boolean not null default true,
  add column if not exists show_charts         boolean not null default true,
  add column if not exists show_visited_crags  boolean not null default true,
  add column if not exists show_max_grade      boolean not null default true,
  add column if not exists is_deleted          boolean not null default false,
  add column if not exists deleted_at          timestamptz,
  add column if not exists delete_requested_at timestamptz;

-- ────────────────────────────────────────────────────────────
-- USER_PRIVATE_SETTINGS — dati personali NON pubblici
-- ────────────────────────────────────────────────────────────

create table if not exists public.user_private_settings (
  id                    uuid primary key default gen_random_uuid(),
  user_id               uuid not null unique references auth.users(id) on delete cascade,
  height_cm             integer check (height_cm is null or (height_cm between 100 and 250)),
  weight_kg             numeric check (weight_kg is null or (weight_kg between 20 and 250)),
  ape_index_cm          numeric,
  dominant_hand         text check (dominant_hand is null or dominant_hand in ('left','right','ambi')),
  main_shoes            text,
  uses_kneepad          boolean,
  private_training_notes text,
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now()
);

create trigger trg_user_private_settings_updated_at
  before update on public.user_private_settings
  for each row execute function public.set_updated_at();

-- ────────────────────────────────────────────────────────────
-- INJURY_PERIODS — periodi di infortunio (privati)
-- ────────────────────────────────────────────────────────────

create table if not exists public.injury_periods (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users(id) on delete cascade,
  start_date  date not null,
  end_date    date,
  label       text,
  notes       text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create trigger trg_injury_periods_updated_at
  before update on public.injury_periods
  for each row execute function public.set_updated_at();

create index if not exists idx_injury_periods_user on public.injury_periods(user_id);

-- ────────────────────────────────────────────────────────────
-- RLS
-- ────────────────────────────────────────────────────────────

alter table public.user_private_settings enable row level security;
alter table public.injury_periods         enable row level security;

-- profiles: i profili eliminati spariscono per gli altri, ma il
-- proprietario vede sempre il proprio profilo.
drop policy if exists "Profili visibili a tutti" on public.profiles;
create policy "Profili pubblici non eliminati o proprio profilo"
  on public.profiles for select
  using (
    (is_deleted = false and is_public = true)
    or auth.uid() = id
    or public.is_admin()
  );

-- user_private_settings: solo proprietario
create policy "Private settings: solo proprietario seleziona"
  on public.user_private_settings for select using (auth.uid() = user_id);
create policy "Private settings: solo proprietario inserisce"
  on public.user_private_settings for insert with check (auth.uid() = user_id);
create policy "Private settings: solo proprietario modifica"
  on public.user_private_settings for update using (auth.uid() = user_id);
create policy "Private settings: solo proprietario elimina"
  on public.user_private_settings for delete using (auth.uid() = user_id);

-- injury_periods: solo proprietario
create policy "Injury: solo proprietario seleziona"
  on public.injury_periods for select using (auth.uid() = user_id);
create policy "Injury: solo proprietario inserisce"
  on public.injury_periods for insert with check (auth.uid() = user_id);
create policy "Injury: solo proprietario modifica"
  on public.injury_periods for update using (auth.uid() = user_id);
create policy "Injury: solo proprietario elimina"
  on public.injury_periods for delete using (auth.uid() = user_id);
