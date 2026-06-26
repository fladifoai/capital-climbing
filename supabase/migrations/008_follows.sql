-- ============================================================
-- 008_follows.sql — Sistema di follow tra utenti
-- ============================================================

create table public.follows (
  follower_id  uuid not null references auth.users(id) on delete cascade,
  following_id uuid not null references auth.users(id) on delete cascade,
  created_at   timestamptz not null default now(),
  primary key (follower_id, following_id),
  check (follower_id <> following_id)
);

create index idx_follows_follower  on public.follows(follower_id);
create index idx_follows_following on public.follows(following_id);

alter table public.follows enable row level security;

create policy "Segui: visibili a tutti"
  on public.follows for select using (true);

create policy "Segui: solo il proprietario può seguire"
  on public.follows for insert with check (auth.uid() = follower_id);

create policy "Segui: solo il proprietario può smettere"
  on public.follows for delete using (auth.uid() = follower_id);
