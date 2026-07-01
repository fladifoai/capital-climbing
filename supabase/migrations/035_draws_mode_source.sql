-- Migration 035: draws_mode deciso dalla SORGENTE, non forzato dal trigger.
--  - Import (client + auto-import da pending): onsight → 'placed_by_user' (montato).
--  - Inserimento manuale da piattaforma: l'utente sceglie draws_mode (il form
--    passa il valore). Il trigger NON forza più onsight→montato, così la scelta
--    manuale ("non ho montato") viene rispettata.
-- Il bonus montaggio (+10) si applica SOLO se draws_mode = 'placed_by_user'.

-- compute_capital_score ora considera draws_mode.
create or replace function public.compute_capital_score(
  p_grade text,
  p_style text,
  p_count integer,
  p_is_repeat boolean,
  p_status text,
  p_draws_mode text
) returns numeric
language plpgsql
immutable
as $$
declare
  g    text;
  gnum numeric;
  bonus integer;
begin
  if coalesce(p_is_repeat, false) or coalesce(p_status, '') <> 'completed' then
    return null;
  end if;

  g := lower(regexp_replace(coalesce(p_grade, ''), '\s+', '', 'g'));

  gnum := case g
    when '5c' then 0    when '6a' then 1     when '6a+' then 2
    when '6b' then 3    when '6b/6b+' then 3.5 when '6b+' then 4
    when '6c' then 5    when '6c/6c+' then 5.5 when '6c+' then 6
    when '6c+/7a' then 6.5 when '7a' then 7   when '7a+' then 8
    when '7b' then 9    when '7b+' then 10    when '7c' then 11
    when '7c+' then 12  when '8a' then 13     when '8a+' then 14
    when '8b' then 15   when '8b+' then 16    when '8c' then 17
    when '8c+' then 18  when '9a' then 19     when '9a+' then 20
    when '9b' then 21   when '9b+' then 22
    else null
  end;

  if gnum is null then
    return null;
  end if;

  -- style bonus. onsight 290 (+10 montaggio SOLO se draws_mode = placed_by_user).
  bonus := case
    when p_style = 'onsight' then 290 + case when p_draws_mode = 'placed_by_user' then 10 else 0 end
    when p_style = 'flash'   then 90
    when p_count = 2         then 30
    else 0
  end;

  return round(700 + 100 * gnum + bonus);
end;
$$;

-- Trigger: calcola lo score dal draws_mode reale. NIENTE più forcing.
create or replace function public.set_capital_score()
returns trigger
language plpgsql
as $$
begin
  new.score := public.compute_capital_score(
    new.grade_at_ascent, new.ascent_style, new.attempt_count,
    new.is_repeat, new.status, new.draws_mode
  );
  new.score_version := case when new.score is null then null else 'capital_score_v1' end;
  return new;
end;
$$;
-- il trigger trg_set_capital_score (034) resta, ora usa la nuova funzione.

-- Vecchia firma a 5 argomenti non più usata: rimuovila per evitare ambiguità.
drop function if exists public.compute_capital_score(text, text, integer, boolean, text);

-- Auto-import da pending: onsight → montato (import = montaggio automatico).
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
    if exists (
      select 1 from public.ascents a
      where a.user_id = rec.user_id and a.route_id = NEW.id and a.date = rec.date
    ) then
      update public.pending_ascents set status='imported', imported_at=now() where id=rec.id;
      continue;
    end if;

    insert into public.ascents (
      user_id, route_id, date, status,
      attempt_type, ascent_style, attempt_count, attempt_bucket, needs_review,
      grade_at_ascent, grade_snapshot, proposed_grade, quality,
      route_name_snapshot, crag_name_snapshot, sector_name_snapshot,
      notes, visibility, draws_mode
    ) values (
      rec.user_id, NEW.id, rec.date, 'completed',
      null, rec.ascent_style, rec.attempt_count, rec.attempt_bucket,
      (rec.ascent_style is null or rec.grade is null),
      rec.grade, rec.grade, rec.proposed_grade, rec.quality,
      rec.route_name, rec.crag_name, rec.sector_name,
      rec.notes, 'public',
      case when rec.ascent_style = 'onsight' then 'placed_by_user' else null end
    )
    returning id into new_asc;

    update public.pending_ascents set status='imported', imported_at=now(), ascent_id=new_asc where id=rec.id;
  end loop;

  update public.crag_requests
    set status='resolved', resolved_at=now()
    where status='pending' and normalized_crag=crag_norm and normalized_route=NEW.normalized_name;

  return NEW;
end;
$$;

-- Ricalcolo score sullo storico con la nuova funzione (draws_mode invariato).
update public.ascents
set score = public.compute_capital_score(
      grade_at_ascent, ascent_style, attempt_count, is_repeat, status, draws_mode
    ),
    score_version = case
      when public.compute_capital_score(grade_at_ascent, ascent_style, attempt_count, is_repeat, status, draws_mode) is null
      then null else 'capital_score_v1'
    end;
