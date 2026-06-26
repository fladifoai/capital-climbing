-- ============================================================
-- 010_route_features.sql
-- Dati tecnici via, unlock anti-spoiler, voti community
-- ============================================================

-- ─── route_features: un record per via, gestito dagli admin ──
create table public.route_features (
  id             uuid primary key default gen_random_uuid(),
  route_id       uuid not null references public.routes(id) on delete cascade,
  hold_profile   jsonb not null default '{}'::jsonb,
  movement_profile jsonb not null default '{}'::jsonb,
  style_profile  jsonb not null default '{}'::jsonb,
  crux_data      jsonb not null default '{}'::jsonb,
  rest_data      jsonb not null default '{}'::jsonb,
  kneepad_data   jsonb not null default '{}'::jsonb,
  equipment_data jsonb not null default '{}'::jsonb,
  safety_data    jsonb not null default '{}'::jsonb,
  verified       boolean not null default false,
  verified_by    uuid references auth.users(id),
  verified_at    timestamptz,
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  unique(route_id)
);

alter table public.route_features enable row level security;

create policy "Route features: lettura pubblica"
  on public.route_features for select using (true);

-- ─── route_spoiler_unlocks: sblocco permanente per via ───────
create table public.route_spoiler_unlocks (
  user_id    uuid not null references auth.users(id) on delete cascade,
  route_id   uuid not null references public.routes(id) on delete cascade,
  unlocked_at timestamptz not null default now(),
  primary key (user_id, route_id)
);

alter table public.route_spoiler_unlocks enable row level security;

create policy "Spoiler unlock: proprietario legge"
  on public.route_spoiler_unlocks for select using (auth.uid() = user_id);
create policy "Spoiler unlock: proprietario inserisce"
  on public.route_spoiler_unlocks for insert with check (auth.uid() = user_id);
create policy "Spoiler unlock: proprietario elimina"
  on public.route_spoiler_unlocks for delete using (auth.uid() = user_id);

-- ─── community_route_ratings: voto grado + bellezza ──────────
create table public.community_route_ratings (
  id              uuid primary key default gen_random_uuid(),
  route_id        uuid not null references public.routes(id) on delete cascade,
  user_id         uuid not null references auth.users(id) on delete cascade,
  perceived_grade text,
  grade_numeric   numeric,
  beauty          smallint check (beauty between 1 and 5),
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  unique(route_id, user_id)
);

alter table public.community_route_ratings enable row level security;

create policy "Voti community: lettura pubblica"
  on public.community_route_ratings for select using (true);
create policy "Voti community: proprietario inserisce"
  on public.community_route_ratings for insert with check (auth.uid() = user_id);
create policy "Voti community: proprietario aggiorna"
  on public.community_route_ratings for update using (auth.uid() = user_id);
create policy "Voti community: proprietario elimina"
  on public.community_route_ratings for delete using (auth.uid() = user_id);
