-- ============================================================
-- 030_route_community_quickdraws.sql
-- Rinvii community per via = valore PIÙ FREQUENTE (moda, non media)
-- dei rinvii inseriti dagli utenti in user_route_notes.equipment_data.
-- Es. 10 utenti dicono 16 e 30 dicono 14 → 14.
-- Visibile a tutti: cache su routes.community_quickdraws (RLS routes = lettura pubblica).
-- Trigger ricalcola a ogni insert/update/delete delle note tecniche.
-- ============================================================

alter table public.routes
  add column if not exists community_quickdraws integer;

-- Ricalcola la moda per una via. SECURITY DEFINER per leggere le note
-- di tutti gli utenti aggirando la RLS owner-only su user_route_notes.
create or replace function public.recompute_route_quickdraws(p_route_id uuid)
returns void
language sql
security definer
set search_path = public
as $$
  update public.routes r
  set community_quickdraws = (
    select v from (
      select (coalesce(n.equipment_data->>'quickdraws_recommended',
                       n.equipment_data->>'quickdraws_min'))::int as v,
             count(*) as c
      from public.user_route_notes n
      where n.route_id = p_route_id
        and coalesce(n.equipment_data->>'quickdraws_recommended',
                     n.equipment_data->>'quickdraws_min') ~ '^[0-9]+$'
      group by 1
      order by c desc, v desc   -- moda; a parità di frequenza il valore più alto (più sicuro)
      limit 1
    ) m
  )
  where r.id = p_route_id;
$$;

create or replace function public.trg_route_quickdraws()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if (tg_op = 'DELETE') then
    perform public.recompute_route_quickdraws(old.route_id);
    return old;
  end if;
  perform public.recompute_route_quickdraws(new.route_id);
  if (tg_op = 'UPDATE' and new.route_id is distinct from old.route_id) then
    perform public.recompute_route_quickdraws(old.route_id);
  end if;
  return new;
end;
$$;

drop trigger if exists trg_user_route_notes_quickdraws on public.user_route_notes;
create trigger trg_user_route_notes_quickdraws
  after insert or update or delete on public.user_route_notes
  for each row execute function public.trg_route_quickdraws();

-- Backfill esistenti
do $$
declare rid uuid;
begin
  for rid in select distinct route_id from public.user_route_notes loop
    perform public.recompute_route_quickdraws(rid);
  end loop;
end $$;
