-- Migration 016: Extra evaluation fields on ascents
-- difficulty_feel, style_feel, proposed_grade, want_repeat

ALTER TABLE public.ascents
  ADD COLUMN IF NOT EXISTS difficulty_feel text
    CHECK (difficulty_feel IS NULL OR difficulty_feel IN ('soft', 'fair', 'hard', 'very_hard')),
  ADD COLUMN IF NOT EXISTS style_feel text
    CHECK (style_feel IS NULL OR style_feel IN ('my_style', 'neutral', 'anti_style')),
  ADD COLUMN IF NOT EXISTS proposed_grade text,
  ADD COLUMN IF NOT EXISTS want_repeat boolean;
