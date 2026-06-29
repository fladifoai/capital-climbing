-- Merge '11_15' and '16_20' buckets into '11_20' for simpler UX
-- Step 1: drop old constraint
ALTER TABLE public.ascents
  DROP CONSTRAINT IF EXISTS ascents_attempt_bucket_check;

-- Step 2: migrate existing data
UPDATE public.ascents
  SET attempt_bucket = '11_20'
  WHERE attempt_bucket IN ('11_15', '16_20');

-- Step 3: add new constraint with updated bucket list
ALTER TABLE public.ascents
  ADD CONSTRAINT ascents_attempt_bucket_check CHECK (
    attempt_bucket IS NULL OR attempt_bucket IN (
      '1','2','3','4','5','6','7','8','9','10',
      '11_20','21_30','31_40','41_50','50_plus','unknown'
    )
  );
