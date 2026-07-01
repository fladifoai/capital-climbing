-- Migration 033: Capital Score autoritativo via trigger + bonus montaggio onsight.
-- Motivi:
--  1) l'import (e l'auto-import da pending) inseriva ascensioni SENZA score →
--     un trigger BEFORE INSERT/UPDATE garantisce lo score su OGNI percorso.
--  2) policy v1.0: ogni a-vista conta come "onsight montando" → onsight +10
--     (max che rispetta "7a onsight montando NON supera 7b+ redpoint").
-- grade_numeric Capital: 5c = 0 (scala specifica, diversa da grade_numeric_at_ascent).

create or replace function public.compute_capital_score(
  p_grade text,
  p_style text,
  p_count integer,
  p_is_repeat boolean,
  p_status text
) returns numeric
language plpgsql
immutable
as $$
declare
  g    text;
  gnum numeric;
  bonus integer;
begin
  -- ripetizioni e non-completate non generano punteggio
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

  -- style bonus. onsight = 290 + 10 (montando) = 300.
  bonus := case
    when p_style = 'onsight' then 300
    when p_style = 'flash'   then 90
    when p_count = 2         then 30   -- second_go
    else 0                              -- redpoint 3°+
  end;

  return round(700 + 100 * gnum + bonus);
end;
$$;

create or replace function public.set_capital_score()
returns trigger
language plpgsql
as $$
begin
  new.score := public.compute_capital_score(
    new.grade_at_ascent, new.ascent_style, new.attempt_count, new.is_repeat, new.status
  );
  new.score_version := case when new.score is null then null else 'capital_score_v1' end;

  -- ogni a-vista = "onsight montando" se non specificato diversamente
  if new.ascent_style = 'onsight' and new.draws_mode is null then
    new.draws_mode := 'placed_by_user';
  end if;

  return new;
end;
$$;

drop trigger if exists trg_set_capital_score on public.ascents;
create trigger trg_set_capital_score
  before insert or update on public.ascents
  for each row execute function public.set_capital_score();

-- ── Backfill storico ────────────────────────────────────────────────────────
update public.ascents
set draws_mode = 'placed_by_user'
where ascent_style = 'onsight' and draws_mode is null;

update public.ascents
set score = public.compute_capital_score(
      grade_at_ascent, ascent_style, attempt_count, is_repeat, status
    ),
    score_version = case
      when public.compute_capital_score(grade_at_ascent, ascent_style, attempt_count, is_repeat, status) is null
      then null else 'capital_score_v1'
    end;
