-- Capital Climbing — cleanup duplicate/legacy crags
-- Keeps: 00000000-0000-0000-0010-* (canonical) + Ussassai (cefe2f1e)
-- Merges: dd46a77d (Colle dell'Orso dup) + dcd74e0a (Ermita dup) into canonicals
-- Deletes: all "% - Elenco vie" crags (old Climbook import)

DO $$
DECLARE
  v_ascent_count int;
BEGIN

  -- SAFETY CHECK: verify no ascents reference routes we're about to delete
  SELECT COUNT(*) INTO v_ascent_count
  FROM ascents a
  JOIN routes r ON r.id = a.route_id
  WHERE r.crag_id IN (
    'dd46a77d-9d5e-493b-9b0b-f30b1da9e214',
    'dcd74e0a-a502-4053-a15f-392f344cce34',
    '51cb60de-a502-4053-a15f-392f344cce34',
    '3208f713-0dd2-4630-beb1-9773f2e167bc',
    '2609a181-6aee-40ca-adc1-f3de9c3716e7',
    '0c055b48-7d76-42fa-be78-0f1e00382159',
    'a1be7f1a-4bb3-4f99-856f-97274f4549fa',
    '319f0d2d-f5d5-4e2f-9f74-9050f8bd9c04',
    'f7c4617d-e129-40fc-829d-1a161b43866b',
    'a7fce960-ef39-414a-9d59-6d678c351be0',
    '9eea6365-422b-4a61-a1d2-a9287e7b93a1',
    'f4230e4c-6b76-45fd-bc60-4e698a549c28',
    'e82b1e34-195f-4fe0-a668-6e0b75a1fe9b',
    '7c7f204c-ec2c-4c20-ac1d-fba8407374af',
    'ce49cd92-7698-4f79-af4d-a33e234facf6',
    '6e9c626a-9598-4015-8788-45b8ef4ebdd9',
    'ac7dfb4a-e28f-4f42-add9-13dabf20b4bc',
    '9addb069-3b64-4db0-a88d-32e34c1b3064',
    'e1133634-ca4f-413e-839a-e2c0e3f3116d'
  );

  IF v_ascent_count > 0 THEN
    RAISE EXCEPTION 'STOP: % ascent(s) reference routes to be deleted — manual review needed', v_ascent_count;
  END IF;

  RAISE NOTICE 'Safety check passed: 0 ascents affected.';

  -- ── 1. Merge duplicate Colle dell Orso (dd46a77d) → canonical (00000000-...-004) ──
  UPDATE sectors SET crag_id = '00000000-0000-0000-0010-000000000004'
    WHERE crag_id = 'dd46a77d-9d5e-493b-9b0b-f30b1da9e214';
  UPDATE routes SET crag_id = '00000000-0000-0000-0010-000000000004'
    WHERE crag_id = 'dd46a77d-9d5e-493b-9b0b-f30b1da9e214';
  DELETE FROM crags WHERE id = 'dd46a77d-9d5e-493b-9b0b-f30b1da9e214';
  RAISE NOTICE 'Merged Colle dell Orso duplicate.';

  -- ── 2. Merge duplicate Ermita de Betlem (dcd74e0a) → canonical (00000000-...-007) ──
  UPDATE sectors SET crag_id = '00000000-0000-0000-0010-000000000007'
    WHERE crag_id = 'dcd74e0a-a502-4053-a15f-392f344cce34';
  UPDATE routes SET crag_id = '00000000-0000-0000-0010-000000000007'
    WHERE crag_id = 'dcd74e0a-a502-4053-a15f-392f344cce34';
  DELETE FROM crags WHERE id = 'dcd74e0a-a502-4053-a15f-392f344cce34';
  RAISE NOTICE 'Merged Ermita de Betlem duplicate.';

  -- ── 3. Delete all "Elenco vie" legacy crags ──
  -- Routes stored with crag_id pointing directly to Elenco vie crags
  DELETE FROM routes
    WHERE crag_id IN (SELECT id FROM crags WHERE name LIKE '% - Elenco vie');

  -- Routes stored via sector_id in sectors belonging to Elenco vie crags
  DELETE FROM routes
    WHERE sector_id IN (
      SELECT s.id FROM sectors s
      JOIN crags c ON c.id = s.crag_id
      WHERE c.name LIKE '% - Elenco vie'
    );

  -- Sectors belonging to Elenco vie crags
  DELETE FROM sectors
    WHERE crag_id IN (SELECT id FROM crags WHERE name LIKE '% - Elenco vie');

  -- The Elenco vie crags themselves
  DELETE FROM crags WHERE name LIKE '% - Elenco vie';

  RAISE NOTICE 'Deleted all Elenco vie legacy crags.';

END $$;
