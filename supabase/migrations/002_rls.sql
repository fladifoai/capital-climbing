-- ============================================================
-- 002_rls.sql — Row Level Security
-- ============================================================

-- Abilita RLS su tutte le tabelle
alter table public.profiles         enable row level security;
alter table public.user_roles       enable row level security;
alter table public.sources          enable row level security;
alter table public.crags            enable row level security;
alter table public.sectors          enable row level security;
alter table public.routes           enable row level security;
alter table public.route_aliases    enable row level security;
alter table public.route_sources    enable row level security;
alter table public.ascents          enable row level security;
alter table public.projects         enable row level security;
alter table public.sessions         enable row level security;
alter table public.attempts         enable row level security;
alter table public.user_route_notes enable row level security;
alter table public.import_jobs      enable row level security;
alter table public.import_rows      enable row level security;

-- ────────────────────────────────────────────────────────────
-- PROFILES
-- ────────────────────────────────────────────────────────────

create policy "Profili visibili a tutti"
  on public.profiles for select
  using (true);

create policy "Profilo modificabile solo dal proprietario"
  on public.profiles for update
  using (auth.uid() = id);

create policy "Profilo eliminabile da proprietario o admin"
  on public.profiles for delete
  using (auth.uid() = id or public.is_admin());

-- ────────────────────────────────────────────────────────────
-- USER_ROLES — solo admin può vedere e gestire i ruoli
-- ────────────────────────────────────────────────────────────

create policy "Ruoli visibili solo agli admin"
  on public.user_roles for select
  using (public.is_admin() or auth.uid() = user_id);

-- Nessun utente può inserire/modificare/eliminare ruoli dal frontend

-- ────────────────────────────────────────────────────────────
-- CATALOGO — lettura pubblica, scrittura solo admin
-- ────────────────────────────────────────────────────────────

create policy "Sources: lettura pubblica"
  on public.sources for select using (true);
create policy "Sources: solo admin può scrivere"
  on public.sources for insert with check (public.is_admin());
create policy "Sources: solo admin può modificare"
  on public.sources for update using (public.is_admin());
create policy "Sources: solo admin può eliminare"
  on public.sources for delete using (public.is_admin());

create policy "Crags: lettura pubblica"
  on public.crags for select using (true);
create policy "Crags: solo admin può scrivere"
  on public.crags for insert with check (public.is_admin());
create policy "Crags: solo admin può modificare"
  on public.crags for update using (public.is_admin());
create policy "Crags: solo admin può eliminare"
  on public.crags for delete using (public.is_admin());

create policy "Sectors: lettura pubblica"
  on public.sectors for select using (true);
create policy "Sectors: solo admin può scrivere"
  on public.sectors for insert with check (public.is_admin());
create policy "Sectors: solo admin può modificare"
  on public.sectors for update using (public.is_admin());
create policy "Sectors: solo admin può eliminare"
  on public.sectors for delete using (public.is_admin());

create policy "Routes: lettura pubblica"
  on public.routes for select using (true);
create policy "Routes: solo admin può scrivere"
  on public.routes for insert with check (public.is_admin());
create policy "Routes: solo admin può modificare"
  on public.routes for update using (public.is_admin());
create policy "Routes: solo admin può eliminare"
  on public.routes for delete using (public.is_admin());

create policy "Route aliases: lettura pubblica"
  on public.route_aliases for select using (true);
create policy "Route aliases: solo admin può scrivere"
  on public.route_aliases for insert with check (public.is_admin());
create policy "Route aliases: solo admin può modificare"
  on public.route_aliases for update using (public.is_admin());
create policy "Route aliases: solo admin può eliminare"
  on public.route_aliases for delete using (public.is_admin());

create policy "Route sources: lettura pubblica"
  on public.route_sources for select using (true);
create policy "Route sources: solo admin può scrivere"
  on public.route_sources for insert with check (public.is_admin());
create policy "Route sources: solo admin può modificare"
  on public.route_sources for update using (public.is_admin());
create policy "Route sources: solo admin può eliminare"
  on public.route_sources for delete using (public.is_admin());

-- ────────────────────────────────────────────────────────────
-- DATI PERSONALI
-- ────────────────────────────────────────────────────────────

create policy "Ascents: visibili se pubblici o propri"
  on public.ascents for select
  using (visibility = 'public' or auth.uid() = user_id);
create policy "Ascents: inserimento solo proprio"
  on public.ascents for insert
  with check (auth.uid() = user_id);
create policy "Ascents: modifica solo propria"
  on public.ascents for update
  using (auth.uid() = user_id);
create policy "Ascents: eliminazione solo propria"
  on public.ascents for delete
  using (auth.uid() = user_id);

create policy "Projects: visibili se pubblici o propri"
  on public.projects for select
  using (visibility = 'public' or auth.uid() = user_id);
create policy "Projects: inserimento solo proprio"
  on public.projects for insert
  with check (auth.uid() = user_id);
create policy "Projects: modifica solo propria"
  on public.projects for update
  using (auth.uid() = user_id);
create policy "Projects: eliminazione solo propria"
  on public.projects for delete
  using (auth.uid() = user_id);

create policy "Sessions: visibili se pubbliche o proprie"
  on public.sessions for select
  using (visibility = 'public' or auth.uid() = user_id);
create policy "Sessions: inserimento solo proprio"
  on public.sessions for insert
  with check (auth.uid() = user_id);
create policy "Sessions: modifica solo propria"
  on public.sessions for update
  using (auth.uid() = user_id);
create policy "Sessions: eliminazione solo propria"
  on public.sessions for delete
  using (auth.uid() = user_id);

create policy "Attempts: visibili se pubblici o propri"
  on public.attempts for select
  using (visibility = 'public' or auth.uid() = user_id);
create policy "Attempts: inserimento solo proprio"
  on public.attempts for insert
  with check (auth.uid() = user_id);
create policy "Attempts: modifica solo propria"
  on public.attempts for update
  using (auth.uid() = user_id);
create policy "Attempts: eliminazione solo propria"
  on public.attempts for delete
  using (auth.uid() = user_id);

create policy "Note via: visibili se pubbliche o proprie"
  on public.user_route_notes for select
  using (visibility = 'public' or auth.uid() = user_id);
create policy "Note via: inserimento solo proprio"
  on public.user_route_notes for insert
  with check (auth.uid() = user_id);
create policy "Note via: modifica solo propria"
  on public.user_route_notes for update
  using (auth.uid() = user_id);
create policy "Note via: eliminazione solo propria"
  on public.user_route_notes for delete
  using (auth.uid() = user_id);

-- ────────────────────────────────────────────────────────────
-- IMPORT — solo admin
-- ────────────────────────────────────────────────────────────

create policy "Import jobs: solo admin"
  on public.import_jobs for all
  using (public.is_admin());

create policy "Import rows: solo admin"
  on public.import_rows for all
  using (public.is_admin());
