-- 039_sector_season_metadata.sql
-- Metadati stagionali a livello SETTORE (scelta "misto"):
--   coord/quota/parcheggio/roccia restano su `crags` (condivisi per la falesia);
--   esposizione/sole/stagione stanno su `sectors` perche variano da settore a settore.
-- `orientation` esiste gia su sectors (001_schema). Qui aggiungo sole e stagionalita.
-- Gli score 0-100 sono STIME interne (internal_calc): vedi data/crags-metadata/.

alter table public.sectors
  add column if not exists sun_morning   text,     -- 'si' | 'no' | 'parziale' | null
  add column if not exists sun_afternoon text,     -- 'si' | 'no' | 'parziale' | null
  add column if not exists summer_score  integer,  -- 0..100 stima idoneita estiva
  add column if not exists winter_score  integer,  -- 0..100 stima idoneita invernale
  add column if not exists best_season   text;      -- 'estate' | 'inverno' | 'mezze stagioni'

comment on column public.sectors.summer_score is 'Stima 0-100 idoneita estiva (internal_calc, da orientamento+quota). Vedi data/crags-metadata.';
comment on column public.sectors.winter_score is 'Stima 0-100 idoneita invernale (internal_calc).';
comment on column public.sectors.best_season  is 'Stagione consigliata derivata dagli score (stima).';
