-- Migration 031: Capital Score v1.0
-- Riusa ascents.score come capital_score. Aggiunge score_version + draws_mode.
-- Backfill dello score sulle salite esistenti con la formula:
--   700 + 100 * grade_numeric_capital + style_bonus
-- dove grade_numeric_capital ha 5c = 0 (scala SPECIFICA del Capital Score,
-- diversa da grade_numeric_at_ascent che usa 4a = 1).
-- Bonus montaggio rinvii predisposto ma DISATTIVATO (draws_mode non incide).

alter table public.ascents
  add column if not exists score_version text,
  add column if not exists draws_mode    text;

alter table public.ascents
  drop constraint if exists ascents_draws_mode_check;

alter table public.ascents
  add constraint ascents_draws_mode_check check (
    draws_mode is null or draws_mode in ('unknown', 'preplaced', 'placed_by_user')
  );

-- Mappa grado → grade_numeric Capital (5c = 0).
with grade_map(grade, num) as (
  values
    ('5c', 0.0), ('6a', 1.0), ('6a+', 2.0), ('6b', 3.0), ('6b/6b+', 3.5),
    ('6b+', 4.0), ('6c', 5.0), ('6c/6c+', 5.5), ('6c+', 6.0), ('6c+/7a', 6.5),
    ('7a', 7.0), ('7a+', 8.0), ('7b', 9.0), ('7b+', 10.0), ('7c', 11.0),
    ('7c+', 12.0), ('8a', 13.0), ('8a+', 14.0), ('8b', 15.0), ('8b+', 16.0),
    ('8c', 17.0), ('8c+', 18.0), ('9a', 19.0), ('9a+', 20.0), ('9b', 21.0),
    ('9b+', 22.0)
)
update public.ascents a
set
  score = round(
    700
    + 100 * gm.num
    + case
        when a.ascent_style = 'onsight' then 290
        when a.ascent_style = 'flash'   then 90
        when a.attempt_count = 2        then 30  -- second_go
        else 0                                    -- redpoint 3°+
      end
  ),
  score_version = 'capital_score_v1'
from grade_map gm
where a.status = 'completed'
  and a.score is null
  and gm.grade = lower(regexp_replace(coalesce(a.grade_at_ascent, ''), '\s+', '', 'g'));
