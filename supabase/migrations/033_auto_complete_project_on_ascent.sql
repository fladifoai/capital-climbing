-- ============================================================
-- 033_auto_complete_project_on_ascent.sql
-- Collega progetti e sessioni/logbook in modo bidirezionale.
--
-- Direzione progetto -> sessione: già gestita dal trigger 007
--   (ogni ascensione crea/collega la sessione del giorno).
-- Direzione sessione/logbook -> progetto: QUESTA migration.
--   Quando salvi un'ascensione (da sessione, da logbook, da import)
--   su una via che hai come progetto attivo o in pausa, il progetto
--   viene automaticamente segnato "completato" e ne aggiorna la data.
--
-- Le ripetizioni (is_repeat = true) NON chiudono progetti:
--   se è una ripetizione la via era già stata chiusa in precedenza.
-- ============================================================

-- ─── Funzione trigger ────────────────────────────────────────
create or replace function public.auto_complete_project_for_ascent()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  -- Solo ascensioni completate e non ripetizioni chiudono un progetto.
  if NEW.status is distinct from 'completed' then
    return NEW;
  end if;
  if coalesce(NEW.is_repeat, false) then
    return NEW;
  end if;

  update public.projects
  set status            = 'completed',
      last_session_date = NEW.date,
      updated_at        = now()
  where user_id  = NEW.user_id
    and route_id = NEW.route_id
    and status in ('active', 'paused');

  return NEW;
end;
$$;

-- ─── Trigger AFTER INSERT su ascents ─────────────────────────
drop trigger if exists trg_ascent_auto_complete_project on public.ascents;

create trigger trg_ascent_auto_complete_project
  after insert on public.ascents
  for each row
  execute function public.auto_complete_project_for_ascent();

-- ─── Backfill: chiudi i progetti già saliti in passato ───────
-- Progetti ancora attivi/in pausa la cui via ha già un'ascensione
-- completata non-ripetizione dello stesso utente.
update public.projects p
set status            = 'completed',
    last_session_date = coalesce(sub.max_date, p.last_session_date),
    updated_at        = now()
from (
  select a.user_id, a.route_id, max(a.date) as max_date
  from public.ascents a
  where a.status = 'completed'
    and coalesce(a.is_repeat, false) = false
  group by a.user_id, a.route_id
) sub
where p.user_id  = sub.user_id
  and p.route_id = sub.route_id
  and p.status in ('active', 'paused');
