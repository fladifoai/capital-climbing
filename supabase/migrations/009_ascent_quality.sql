-- ============================================================
-- 009_ascent_quality.sql — Aggiunge valutazione qualità via (1-5 stelle)
-- ============================================================

alter table public.ascents
  add column if not exists quality smallint
  check (quality between 1 and 5);
