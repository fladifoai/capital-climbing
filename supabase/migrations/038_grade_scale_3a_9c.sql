-- ============================================================
-- 038_grade_scale_3a_9c.sql
-- Nuova scala gradi Capital Climbing: 3a → 9c.
--   - Sotto il 6a NIENTE "+" (3a…5c).
--   - Dal 6a in poi i "+" fino a 9c (grado massimo).
--   - Nessun grado slash (es. 6c+/7a) è valido.
-- Sync con src/analytics/normalizers/grades.ts (GRADE_SCALE, numerazione 1…32)
-- e src/lib/scoring.ts (GRADE_MAP, 5c=0 … 9c=23).
--
-- Policy dati esistenti = "arrotonda al valido":
--   5a+/5b+/5c+ → 5a/5b/5c ; slash → grado più alto (6c+/7a → 7a ;
--   slash sotto il 6a → grado base). Riscrive le STRINGHE poi ricalcola i numeric.
--
-- NB: 6a→9c mantengono la stessa numerazione precedente (10…32): i grade_numeric
-- di quei gradi NON cambiano. Cambia solo la parte sotto il 6a (era 4a=1…5c+=9).
-- Ricalcolo da stringa (fonte di verità) → reversibile.
-- ============================================================

-- ── 1. Funzione Capital Score: aggiungi 9c (=23), togli gli slash ─────────────
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
    when '6b' then 3    when '6b+' then 4    when '6c' then 5
    when '6c+' then 6   when '7a' then 7     when '7a+' then 8
    when '7b' then 9    when '7b+' then 10   when '7c' then 11
    when '7c+' then 12  when '8a' then 13    when '8a+' then 14
    when '8b' then 15   when '8b+' then 16   when '8c' then 17
    when '8c+' then 18  when '9a' then 19    when '9a+' then 20
    when '9b' then 21   when '9b+' then 22   when '9c' then 23
    else null
  end;

  if gnum is null then
    return null;
  end if;

  bonus := case
    when p_style = 'onsight' then 290 + case when p_draws_mode = 'placed_by_user' then 10 else 0 end
    when p_style = 'flash'   then 90
    when p_count = 2         then 30
    else 0
  end;

  return round(700 + 100 * gnum + bonus);
end;
$$;

-- ── 2. Riscrittura stringhe non valide → grado valido (arrotonda) ─────────────
-- Mappa riusabile: chiave = stringa non valida normalizzata, valore = grado valido.
-- Match su lower(replace(col,' ','')) così copre casing/spazi; scrive la forma canonica.

-- routes.official_grade
with fix(bad, good) as (values
  ('5a+','5a'),('5b+','5b'),('5c+','5c'),
  ('4a+/4b','4b'),('4c+/5a','5a'),
  ('5a/5a+','5a'),('5a+/5b','5b'),('5b/5b+','5b'),('5b+/5c','5c'),
  ('5c/5c+','5c'),('5c+/6a','6a'),
  ('6a/6a+','6a+'),('6a+/6b','6b'),('6b/6b+','6b+'),('6b+/6c','6c'),
  ('6c/6c+','6c+'),('6c+/7a','7a'),
  ('7a/7a+','7a+'),('7a+/7b','7b'),('7b/7b+','7b+'),('7b+/7c','7c'),
  ('7c/7c+','7c+'),('7c+/8a','8a'),
  ('8a/8a+','8a+'),('8a+/8b','8b'),('8b/8b+','8b+'),('8b+/8c','8c'),
  ('8c/8c+','8c+'),('8c+/9a','9a'),
  ('9a/9a+','9a+'),('9b/9b+','9b+')
)
update public.routes r
set official_grade = f.good
from fix f
where r.official_grade is not null
  and lower(replace(r.official_grade, ' ', '')) = f.bad;

-- routes.community_grade_raw
with fix(bad, good) as (values
  ('5a+','5a'),('5b+','5b'),('5c+','5c'),
  ('4a+/4b','4b'),('4c+/5a','5a'),
  ('5a/5a+','5a'),('5a+/5b','5b'),('5b/5b+','5b'),('5b+/5c','5c'),
  ('5c/5c+','5c'),('5c+/6a','6a'),
  ('6a/6a+','6a+'),('6a+/6b','6b'),('6b/6b+','6b+'),('6b+/6c','6c'),
  ('6c/6c+','6c+'),('6c+/7a','7a'),
  ('7a/7a+','7a+'),('7a+/7b','7b'),('7b/7b+','7b+'),('7b+/7c','7c'),
  ('7c/7c+','7c+'),('7c+/8a','8a'),
  ('8a/8a+','8a+'),('8a+/8b','8b'),('8b/8b+','8b+'),('8b+/8c','8c'),
  ('8c/8c+','8c+'),('8c+/9a','9a'),
  ('9a/9a+','9a+'),('9b/9b+','9b+')
)
update public.routes r
set community_grade_raw = f.good
from fix f
where r.community_grade_raw is not null
  and lower(replace(r.community_grade_raw, ' ', '')) = f.bad;

-- ascents.grade_at_ascent (il trigger BEFORE UPDATE ricalcola lo score)
with fix(bad, good) as (values
  ('5a+','5a'),('5b+','5b'),('5c+','5c'),
  ('4a+/4b','4b'),('4c+/5a','5a'),
  ('5a/5a+','5a'),('5a+/5b','5b'),('5b/5b+','5b'),('5b+/5c','5c'),
  ('5c/5c+','5c'),('5c+/6a','6a'),
  ('6a/6a+','6a+'),('6a+/6b','6b'),('6b/6b+','6b+'),('6b+/6c','6c'),
  ('6c/6c+','6c+'),('6c+/7a','7a'),
  ('7a/7a+','7a+'),('7a+/7b','7b'),('7b/7b+','7b+'),('7b+/7c','7c'),
  ('7c/7c+','7c+'),('7c+/8a','8a'),
  ('8a/8a+','8a+'),('8a+/8b','8b'),('8b/8b+','8b+'),('8b+/8c','8c'),
  ('8c/8c+','8c+'),('8c+/9a','9a'),
  ('9a/9a+','9a+'),('9b/9b+','9b+')
)
update public.ascents a
set grade_at_ascent = f.good
from fix f
where a.grade_at_ascent is not null
  and lower(replace(a.grade_at_ascent, ' ', '')) = f.bad;

-- ascents.grade_snapshot
with fix(bad, good) as (values
  ('5a+','5a'),('5b+','5b'),('5c+','5c'),
  ('4a+/4b','4b'),('4c+/5a','5a'),
  ('5a/5a+','5a'),('5a+/5b','5b'),('5b/5b+','5b'),('5b+/5c','5c'),
  ('5c/5c+','5c'),('5c+/6a','6a'),
  ('6a/6a+','6a+'),('6a+/6b','6b'),('6b/6b+','6b+'),('6b+/6c','6c'),
  ('6c/6c+','6c+'),('6c+/7a','7a'),
  ('7a/7a+','7a+'),('7a+/7b','7b'),('7b/7b+','7b+'),('7b+/7c','7c'),
  ('7c/7c+','7c+'),('7c+/8a','8a'),
  ('8a/8a+','8a+'),('8a+/8b','8b'),('8b/8b+','8b+'),('8b+/8c','8c'),
  ('8c/8c+','8c+'),('8c+/9a','9a'),
  ('9a/9a+','9a+'),('9b/9b+','9b+')
)
update public.ascents a
set grade_snapshot = f.good
from fix f
where a.grade_snapshot is not null
  and lower(replace(a.grade_snapshot, ' ', '')) = f.bad;

-- ascents.community_grade_snapshot
with fix(bad, good) as (values
  ('5a+','5a'),('5b+','5b'),('5c+','5c'),
  ('4a+/4b','4b'),('4c+/5a','5a'),
  ('5a/5a+','5a'),('5a+/5b','5b'),('5b/5b+','5b'),('5b+/5c','5c'),
  ('5c/5c+','5c'),('5c+/6a','6a'),
  ('6a/6a+','6a+'),('6a+/6b','6b'),('6b/6b+','6b+'),('6b+/6c','6c'),
  ('6c/6c+','6c+'),('6c+/7a','7a'),
  ('7a/7a+','7a+'),('7a+/7b','7b'),('7b/7b+','7b+'),('7b+/7c','7c'),
  ('7c/7c+','7c+'),('7c+/8a','8a'),
  ('8a/8a+','8a+'),('8a+/8b','8b'),('8b/8b+','8b+'),('8b+/8c','8c'),
  ('8c/8c+','8c+'),('8c+/9a','9a'),
  ('9a/9a+','9a+'),('9b/9b+','9b+')
)
update public.ascents a
set community_grade_snapshot = f.good
from fix f
where a.community_grade_snapshot is not null
  and lower(replace(a.community_grade_snapshot, ' ', '')) = f.bad;

-- ── 3. Ricalcolo grade_numeric con la nuova numerazione (3a=1 … 9c=32) ────────
-- Da stringa (ora tutte valide). Slash inclusi per sicurezza → stesso numero.

-- routes.grade_numeric
with grade_map(g, num) as (values
  ('3a',1),('3b',2),('3c',3),
  ('4a',4),('4b',5),('4c',6),
  ('5a',7),('5b',8),('5c',9),
  ('6a',10),('6a+',11),('6b',12),('6b+',13),('6c',14),('6c+',15),
  ('7a',16),('7a+',17),('7b',18),('7b+',19),('7c',20),('7c+',21),
  ('8a',22),('8a+',23),('8b',24),('8b+',25),('8c',26),('8c+',27),
  ('9a',28),('9a+',29),('9b',30),('9b+',31),('9c',32),
  ('6a/6a+',11),('6b/6b+',13),('6c/6c+',15),('6c+/7a',16),
  ('7a/7a+',17),('7b/7b+',19),('7c/7c+',21),
  ('8a/8a+',23),('8b/8b+',25),('8c/8c+',27),
  ('9a/9a+',29),('9b/9b+',31)
)
update public.routes r
set grade_numeric = gm.num
from grade_map gm
where r.official_grade is not null
  and lower(replace(r.official_grade, ' ', '')) = gm.g;

-- routes.community_grade_numeric
with grade_map(g, num) as (values
  ('3a',1),('3b',2),('3c',3),
  ('4a',4),('4b',5),('4c',6),
  ('5a',7),('5b',8),('5c',9),
  ('6a',10),('6a+',11),('6b',12),('6b+',13),('6c',14),('6c+',15),
  ('7a',16),('7a+',17),('7b',18),('7b+',19),('7c',20),('7c+',21),
  ('8a',22),('8a+',23),('8b',24),('8b+',25),('8c',26),('8c+',27),
  ('9a',28),('9a+',29),('9b',30),('9b+',31),('9c',32),
  ('6a/6a+',11),('6b/6b+',13),('6c/6c+',15),('6c+/7a',16),
  ('7a/7a+',17),('7b/7b+',19),('7c/7c+',21),
  ('8a/8a+',23),('8b/8b+',25),('8c/8c+',27),
  ('9a/9a+',29),('9b/9b+',31)
)
update public.routes r
set community_grade_numeric = gm.num
from grade_map gm
where r.community_grade_raw is not null
  and lower(replace(r.community_grade_raw, ' ', '')) = gm.g;

-- ascents.grade_numeric_at_ascent
with grade_map(g, num) as (values
  ('3a',1),('3b',2),('3c',3),
  ('4a',4),('4b',5),('4c',6),
  ('5a',7),('5b',8),('5c',9),
  ('6a',10),('6a+',11),('6b',12),('6b+',13),('6c',14),('6c+',15),
  ('7a',16),('7a+',17),('7b',18),('7b+',19),('7c',20),('7c+',21),
  ('8a',22),('8a+',23),('8b',24),('8b+',25),('8c',26),('8c+',27),
  ('9a',28),('9a+',29),('9b',30),('9b+',31),('9c',32),
  ('6a/6a+',11),('6b/6b+',13),('6c/6c+',15),('6c+/7a',16),
  ('7a/7a+',17),('7b/7b+',19),('7c/7c+',21),
  ('8a/8a+',23),('8b/8b+',25),('8c/8c+',27),
  ('9a/9a+',29),('9b/9b+',31)
)
update public.ascents a
set grade_numeric_at_ascent = gm.num
from grade_map gm
where a.grade_at_ascent is not null
  and lower(replace(a.grade_at_ascent, ' ', '')) = gm.g;

-- ── 4. Ricalcolo score su tutto lo storico (copre i 9c, prima → null) ─────────
update public.ascents
set score = public.compute_capital_score(
      grade_at_ascent, ascent_style, attempt_count, is_repeat, status, draws_mode
    ),
    score_version = case
      when public.compute_capital_score(grade_at_ascent, ascent_style, attempt_count, is_repeat, status, draws_mode) is null
      then null else 'capital_score_v1'
    end;
