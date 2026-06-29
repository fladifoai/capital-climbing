-- ============================================================
-- 028_backfill_grade_numeric.sql
-- Popola grade_numeric_at_ascent (null) dalle stringhe grade_at_ascent,
-- usando la stessa scala dell'app (src/analytics/normalizers/grades.ts).
-- Slash grades → il grado più alto. Sicuro: aggiorna solo righe con numeric null.
-- ============================================================

update public.ascents a
set grade_numeric_at_ascent = m.num
from (values
  ('5a',1),('5b',2),('5c',3),
  ('6a',4),('6a+',5),('6b',6),('6b+',7),('6c',8),('6c+',9),
  ('7a',10),('7a+',11),('7b',12),('7b+',13),('7c',14),('7c+',15),
  ('8a',16),('8a+',17),('8b',18),('8b+',19),('8c',20),('8c+',21),('9a',22),
  -- slash → grado più alto
  ('6b/6b+',7),('6c/6c+',9),('6c+/7a',10),('7a/7a+',11),
  ('7b/7b+',13),('7c/7c+',15),('8a/8a+',17),('8b/8b+',19)
) as m(g, num)
where a.grade_numeric_at_ascent is null
  and a.grade_at_ascent is not null
  and lower(replace(a.grade_at_ascent, ' ', '')) = m.g;
