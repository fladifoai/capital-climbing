-- ============================================================
-- 029_regrade_full_scale.sql
-- Riallinea grade_numeric alla nuova scala completa 4a→9c
-- (src/analytics/normalizers/grades.ts). Numerazione sequenziale:
--   4a=1 … 9c=32.  Slash grade → grado più alto.
-- Ricalcola da stringa (fonte di verità preservata) → reversibile.
-- Aggiorna: routes.grade_numeric, routes.community_grade_numeric,
--           ascents.grade_numeric_at_ascent.
-- ============================================================

-- Mapping canonico (scala + alias slash), riusabile via CTE
with grade_map(g, num) as (values
  ('4a',1),('4b',2),('4c',3),
  ('5a',4),('5a+',5),('5b',6),('5b+',7),('5c',8),('5c+',9),
  ('6a',10),('6a+',11),('6b',12),('6b+',13),('6c',14),('6c+',15),
  ('7a',16),('7a+',17),('7b',18),('7b+',19),('7c',20),('7c+',21),
  ('8a',22),('8a+',23),('8b',24),('8b+',25),('8c',26),('8c+',27),
  ('9a',28),('9a+',29),('9b',30),('9b+',31),('9c',32),
  -- slash → grado più alto
  ('5a/5a+',5),('5b/5b+',7),('5c/5c+',9),
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

with grade_map(g, num) as (values
  ('4a',1),('4b',2),('4c',3),
  ('5a',4),('5a+',5),('5b',6),('5b+',7),('5c',8),('5c+',9),
  ('6a',10),('6a+',11),('6b',12),('6b+',13),('6c',14),('6c+',15),
  ('7a',16),('7a+',17),('7b',18),('7b+',19),('7c',20),('7c+',21),
  ('8a',22),('8a+',23),('8b',24),('8b+',25),('8c',26),('8c+',27),
  ('9a',28),('9a+',29),('9b',30),('9b+',31),('9c',32),
  ('5a/5a+',5),('5b/5b+',7),('5c/5c+',9),
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

with grade_map(g, num) as (values
  ('4a',1),('4b',2),('4c',3),
  ('5a',4),('5a+',5),('5b',6),('5b+',7),('5c',8),('5c+',9),
  ('6a',10),('6a+',11),('6b',12),('6b+',13),('6c',14),('6c+',15),
  ('7a',16),('7a+',17),('7b',18),('7b+',19),('7c',20),('7c+',21),
  ('8a',22),('8a+',23),('8b',24),('8b+',25),('8c',26),('8c+',27),
  ('9a',28),('9a+',29),('9b',30),('9b+',31),('9c',32),
  ('5a/5a+',5),('5b/5b+',7),('5c/5c+',9),
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
