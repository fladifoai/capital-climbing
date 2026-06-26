-- Migration 011: Separate ascent_style from attempt_count
-- ascent_style: the climbing style (onsight/flash/redpoint/repeat/unknown)
-- attempt_count: exact number of attempts (nullable)
-- attempt_bucket: bucketed count when exact is unknown
-- legacy_attempt_type: original attempt_type value preserved
-- needs_review: flags records that need manual review (e.g. four_plus)

ALTER TABLE public.ascents
  ADD COLUMN IF NOT EXISTS ascent_style       text,
  ADD COLUMN IF NOT EXISTS attempt_count      integer,
  ADD COLUMN IF NOT EXISTS attempt_bucket     text,
  ADD COLUMN IF NOT EXISTS legacy_attempt_type text,
  ADD COLUMN IF NOT EXISTS needs_review       boolean NOT NULL DEFAULT false;

ALTER TABLE public.ascents
  DROP CONSTRAINT IF EXISTS ascents_ascent_style_check,
  DROP CONSTRAINT IF EXISTS ascents_attempt_count_check,
  DROP CONSTRAINT IF EXISTS ascents_attempt_bucket_check;

ALTER TABLE public.ascents
  ADD CONSTRAINT ascents_ascent_style_check CHECK (
    ascent_style IS NULL OR ascent_style IN ('onsight','flash','redpoint','repeat','unknown')
  ),
  ADD CONSTRAINT ascents_attempt_count_check CHECK (
    attempt_count IS NULL OR attempt_count >= 1
  ),
  ADD CONSTRAINT ascents_attempt_bucket_check CHECK (
    attempt_bucket IS NULL OR attempt_bucket IN (
      '1','2','3','4','5','6','7','8','9','10',
      '11_15','16_20','21_30','31_40','41_50','50_plus','unknown'
    )
  );

-- Migrate existing attempt_type values
UPDATE public.ascents SET
  legacy_attempt_type = attempt_type,
  ascent_style = CASE attempt_type
    WHEN 'onsight'   THEN 'onsight'
    WHEN 'flash'     THEN 'flash'
    WHEN 'redpoint'  THEN 'redpoint'
    WHEN 'second'    THEN 'redpoint'
    WHEN 'third'     THEN 'redpoint'
    WHEN 'four_plus' THEN 'redpoint'
    ELSE 'unknown'
  END,
  attempt_count = CASE attempt_type
    WHEN 'onsight' THEN 1
    WHEN 'flash'   THEN 1
    WHEN 'second'  THEN 2
    WHEN 'third'   THEN 3
    ELSE NULL
  END,
  attempt_bucket = CASE attempt_type
    WHEN 'onsight' THEN '1'
    WHEN 'flash'   THEN '1'
    WHEN 'second'  THEN '2'
    WHEN 'third'   THEN '3'
    -- four_plus: count unknown, needs manual review
    ELSE NULL
  END,
  needs_review = CASE WHEN attempt_type = 'four_plus' THEN true ELSE false END
WHERE attempt_type IS NOT NULL;
