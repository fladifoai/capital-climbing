-- Migration 013: Add is_repeat column to ascents
-- Tracks whether an ascent is a repetition of a previously sent route.

ALTER TABLE public.ascents
  ADD COLUMN IF NOT EXISTS is_repeat boolean NOT NULL DEFAULT false;

-- Backfill from existing ascent_style = 'repeat'
UPDATE public.ascents
  SET is_repeat = true
  WHERE ascent_style = 'repeat';

CREATE INDEX IF NOT EXISTS idx_ascents_is_repeat ON public.ascents(user_id, is_repeat);
