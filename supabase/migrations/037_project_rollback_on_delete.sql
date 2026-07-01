-- Migration 037: rollback progetti sui delete.
--  1) Cancellare un tentativo (attempts, result='attempt') decrementa
--     projects.attempts_count (simmetrico al +1 di useLogProjectWork).
--  2) Cancellare un'ascensione che aveva chiuso un progetto lo RIAPRE
--     (status → 'active'), se non resta nessun'altra salita valida su quella via.

-- 1) Decremento contatore tentativi ────────────────────────────────────────
create or replace function public.dec_project_attempts_on_delete()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if OLD.result = 'attempt' then
    update public.projects
      set attempts_count = greatest(coalesce(attempts_count, 0) - 1, 0)
      where user_id = OLD.user_id
        and route_id = OLD.route_id
        and status in ('active', 'paused', 'completed');
  end if;
  return OLD;
end;
$$;

drop trigger if exists trg_dec_project_attempts on public.attempts;
create trigger trg_dec_project_attempts
  after delete on public.attempts
  for each row execute function public.dec_project_attempts_on_delete();

-- 2) Riapertura progetto se si cancella la salita che l'aveva chiuso ─────────
create or replace function public.reopen_project_on_ascent_delete()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if OLD.status = 'completed' and coalesce(OLD.is_repeat, false) = false then
    -- resta ancora una salita valida su questa via? se no, riapri il progetto
    if not exists (
      select 1 from public.ascents
      where user_id = OLD.user_id
        and route_id = OLD.route_id
        and status = 'completed'
        and coalesce(is_repeat, false) = false
        and id <> OLD.id
    ) then
      update public.projects
        set status = 'active'
        where user_id = OLD.user_id
          and route_id = OLD.route_id
          and status = 'completed';
    end if;
  end if;
  return OLD;
end;
$$;

drop trigger if exists trg_reopen_project_on_ascent_delete on public.ascents;
create trigger trg_reopen_project_on_ascent_delete
  after delete on public.ascents
  for each row execute function public.reopen_project_on_ascent_delete();
