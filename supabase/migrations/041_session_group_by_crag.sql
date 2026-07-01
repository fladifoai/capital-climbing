-- ============================================================
-- 041_session_group_by_crag.sql
-- Raggruppamento sessione automatica per (utente, data, FALESIA)
-- invece che solo (utente, data).
--
-- Bug corretto: due falesie diverse nello stesso giorno finivano
-- nella STESSA sessione (il trigger 007 prendeva la prima sessione
-- della giornata ignorando la crag). Ora una sessione = una falesia.
-- Più settori della stessa falesia restano nella stessa sessione.
-- ============================================================

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
  -- Già collegata a una sessione (es. il client ha forzato una nuova
  -- sessione passando session_id): niente da fare.
  if NEW.session_id is not null then
    return NEW;
  end if;

  -- Risali la crag dalla via: prima il campo diretto routes.crag_id,
  -- fallback sul settore (dati vecchi senza crag_id popolato).
  select coalesce(r.crag_id, sec.crag_id) into crag_id_val
  from public.routes r
  left join public.sectors sec on sec.id = r.sector_id
  where r.id = NEW.route_id;

  -- Cerca sessione esistente stesso utente + stessa data + STESSA falesia.
  -- `is not distinct from` così crag null combacia con crag null.
  select id into existing_session_id
  from public.sessions
  where user_id = NEW.user_id
    and date    = NEW.date
    and crag_id is not distinct from crag_id_val
  limit 1;

  if existing_session_id is not null then
    NEW.session_id := existing_session_id;
    return NEW;
  end if;

  -- Nessuna sessione per quella (data, falesia): creane una.
  insert into public.sessions (user_id, date, crag_id, visibility)
  values (NEW.user_id, NEW.date, crag_id_val, 'private')
  returning id into new_session_id;

  NEW.session_id := new_session_id;
  return NEW;
end;
$$;

-- Il trigger trg_ascent_auto_session (007) resta invariato: punta a questa
-- funzione aggiornata. Nessuna modifica di schema.
