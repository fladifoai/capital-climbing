-- ============================================================
-- 007_auto_session_trigger.sql
-- Trigger: crea/collega sessione automatica su ogni ascensione
-- Backfill: sessioni per ascensioni esistenti senza session_id
-- ============================================================

-- ─── Funzione trigger ────────────────────────────────────────
create or replace function public.auto_session_for_ascent()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  existing_session_id uuid;
  new_session_id      uuid;
  crag_id_val         uuid;
begin
  -- Già collegata a una sessione: niente da fare
  if NEW.session_id is not null then
    return NEW;
  end if;

  -- Cerca sessione esistente stesso utente + stessa data
  select id into existing_session_id
  from public.sessions
  where user_id = NEW.user_id
    and date    = NEW.date
  limit 1;

  if existing_session_id is not null then
    NEW.session_id := existing_session_id;
    return NEW;
  end if;

  -- Risali crag dalla via
  select sec.crag_id into crag_id_val
  from public.routes r
  join public.sectors sec on sec.id = r.sector_id
  where r.id = NEW.route_id;

  -- Crea nuova sessione
  insert into public.sessions (user_id, date, crag_id, visibility)
  values (NEW.user_id, NEW.date, crag_id_val, 'private')
  returning id into new_session_id;

  NEW.session_id := new_session_id;
  return NEW;
end;
$$;

-- ─── Trigger BEFORE INSERT su ascents ────────────────────────
drop trigger if exists trg_ascent_auto_session on public.ascents;

create trigger trg_ascent_auto_session
  before insert on public.ascents
  for each row
  execute function public.auto_session_for_ascent();

-- ─── Backfill: sessioni per ascensioni già presenti ──────────
do $$
declare
  rec      record;
  sess_id  uuid;
  crag_val uuid;
begin
  for rec in
    select distinct user_id, date
    from public.ascents
    where session_id is null
    order by user_id, date
  loop
    -- Crag della prima via di quella giornata
    select sec.crag_id into crag_val
    from public.ascents a
    join public.routes  r   on r.id   = a.route_id
    join public.sectors sec on sec.id = r.sector_id
    where a.user_id     = rec.user_id
      and a.date        = rec.date
      and a.session_id  is null
    limit 1;

    -- Crea sessione
    insert into public.sessions (user_id, date, crag_id, visibility)
    values (rec.user_id, rec.date, crag_val, 'private')
    returning id into sess_id;

    -- Collega tutte le ascensioni di quella giornata
    update public.ascents
    set session_id = sess_id
    where user_id    = rec.user_id
      and date       = rec.date
      and session_id is null;
  end loop;
end $$;
