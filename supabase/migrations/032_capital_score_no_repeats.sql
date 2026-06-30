-- Migration 032: le ripetizioni NON generano Capital Score.
-- La 031 aveva assegnato uno score anche alle ripetizioni (is_repeat = true):
-- le azzera per coerenza con la logica applicativa (useCreateAscent/useUpdateAscent).

update public.ascents
set score = null,
    score_version = null
where is_repeat = true
  and score is not null;
