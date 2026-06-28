-- Migration 014: Expand attempts.result to include 'repeat' and 'project'
-- Old enum: send | attempt | top_rope
-- New enum: send | attempt | repeat | project

ALTER TABLE public.attempts
  DROP CONSTRAINT IF EXISTS attempts_result_check;

-- Migrate 'top_rope' to 'attempt' before re-constraining
UPDATE public.attempts
  SET result = 'attempt'
  WHERE result = 'top_rope';

ALTER TABLE public.attempts
  ADD CONSTRAINT attempts_result_check
    CHECK (result IN ('send', 'attempt', 'repeat', 'project'));
