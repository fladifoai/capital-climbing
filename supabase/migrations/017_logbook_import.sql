-- ============================================================
-- 017_logbook_import.sql
-- Import logbook personale:
--   - crag_requests: richieste falesia/via mancante (notifica admin)
--   - pending_ascents: ascensioni in coda finché la via non esiste in catalogo
--   - trigger: quando una via viene aggiunta al catalogo, importa
--     automaticamente le pending_ascents corrispondenti.
-- ============================================================

-- ─── Tabella richieste falesia/via mancante ─────────────────
create table if not exists public.crag_requests (
  id              uuid primary key default gen_random_uuid(),
  requester_id    uuid not null references auth.users(id) on delete cascade,
  crag_name       text not null,
  sector_name     text,
  route_name      text not null,
  raw_grade       text,
  normalized_crag text not null,
  normalized_route text not null,
  status          text not null default 'pending'
                    check (status in ('pending', 'resolved', 'rejected')),
  count           integer not null default 1,   -- quante ascensioni in attesa di questa via
  notes           text,
  created_at      timestamptz not null default now(),
  resolved_at     timestamptz
);

create index if not exists idx_crag_requests_status on public.crag_requests(status);
create index if not exists idx_crag_requests_match
  on public.crag_requests(normalized_crag, normalized_route);

-- ─── Tabella ascensioni in coda ─────────────────────────────
create table if not exists public.pending_ascents (
  id               uuid primary key default gen_random_uuid(),
  user_id          uuid not null references auth.users(id) on delete cascade,
  crag_name        text not null,
  sector_name      text,
  route_name       text not null,
  normalized_crag  text not null,
  normalized_sector text,
  normalized_route text not null,
  date             date not null,
  grade            text,
  proposed_grade   text,
  attempt_type     text,
  attempt_count    integer,
  notes            text,
  crag_request_id  uuid references public.crag_requests(id) on delete set null,
  status           text not null default 'pending'
                     check (status in ('pending', 'imported', 'discarded')),
  ascent_id        uuid references public.ascents(id) on delete set null,
  created_at       timestamptz not null default now(),
  imported_at      timestamptz
);

create index if not exists idx_pending_ascents_user on public.pending_ascents(user_id);
create index if not exists idx_pending_ascents_status on public.pending_ascents(status);
create index if not exists idx_pending_ascents_match
  on public.pending_ascents(normalized_crag, normalized_route);

-- ─── RLS ────────────────────────────────────────────────────
alter table public.crag_requests  enable row level security;
alter table public.pending_ascents enable row level security;

-- crag_requests: il richiedente vede/crea le proprie; admin vede tutto.
drop policy if exists crag_requests_select_own on public.crag_requests;
create policy crag_requests_select_own on public.crag_requests
  for select using (requester_id = auth.uid() or public.is_admin());

drop policy if exists crag_requests_insert_own on public.crag_requests;
create policy crag_requests_insert_own on public.crag_requests
  for insert with check (requester_id = auth.uid());

drop policy if exists crag_requests_admin_update on public.crag_requests;
create policy crag_requests_admin_update on public.crag_requests
  for update using (public.is_admin());

-- pending_ascents: ognuno vede/gestisce solo le proprie.
drop policy if exists pending_ascents_select_own on public.pending_ascents;
create policy pending_ascents_select_own on public.pending_ascents
  for select using (user_id = auth.uid());

drop policy if exists pending_ascents_insert_own on public.pending_ascents;
create policy pending_ascents_insert_own on public.pending_ascents
  for insert with check (user_id = auth.uid());

drop policy if exists pending_ascents_delete_own on public.pending_ascents;
create policy pending_ascents_delete_own on public.pending_ascents
  for delete using (user_id = auth.uid());

-- ─── Auto-import: nuova via in catalogo → svuota la coda ─────
create or replace function public.import_pending_for_route()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  crag_norm text;
  rec       record;
  new_asc   uuid;
begin
  -- normalized_name della falesia della nuova via (via sector → crag)
  select c.normalized_name into crag_norm
  from public.sectors s
  join public.crags   c on c.id = s.crag_id
  where s.id = NEW.sector_id;

  if crag_norm is null then
    return NEW;
  end if;

  for rec in
    select * from public.pending_ascents
    where status = 'pending'
      and normalized_crag  = crag_norm
      and normalized_route = NEW.normalized_name
  loop
    -- evita duplicati: stessa via+utente+data già presente
    if exists (
      select 1 from public.ascents a
      where a.user_id = rec.user_id and a.route_id = NEW.id and a.date = rec.date
    ) then
      update public.pending_ascents
        set status = 'imported', imported_at = now()
        where id = rec.id;
      continue;
    end if;

    insert into public.ascents (
      user_id, route_id, date, status,
      attempt_type, attempt_count, needs_review,
      grade_at_ascent, grade_snapshot, proposed_grade,
      route_name_snapshot, crag_name_snapshot, sector_name_snapshot,
      notes, visibility
    ) values (
      rec.user_id, NEW.id, rec.date, 'completed',
      rec.attempt_type, rec.attempt_count,
      (rec.attempt_type is null or rec.grade is null),
      rec.grade, rec.grade, rec.proposed_grade,
      rec.route_name, rec.crag_name, rec.sector_name,
      rec.notes, 'public'
    )
    returning id into new_asc;

    update public.pending_ascents
      set status = 'imported', imported_at = now(), ascent_id = new_asc
      where id = rec.id;
  end loop;

  -- chiudi eventuali richieste falesia ora soddisfatte
  update public.crag_requests
    set status = 'resolved', resolved_at = now()
    where status = 'pending'
      and normalized_crag  = crag_norm
      and normalized_route = NEW.normalized_name;

  return NEW;
end;
$$;

drop trigger if exists trg_import_pending_for_route on public.routes;
create trigger trg_import_pending_for_route
  after insert on public.routes
  for each row
  execute function public.import_pending_for_route();
