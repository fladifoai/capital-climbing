-- Re-link ascents from old (Climbook) routes to PDF-imported equivalents.
-- Then delete the old routes from canonical crags.
-- Reports unmatched ascents as warnings — does NOT delete if any unmatched.

DO $$
DECLARE
  v_rec          record;
  v_new_route_id uuid;
  v_relinked     int := 0;
  v_unmatched    int := 0;
BEGIN

  -- Loop over every ascent referencing a non-pdf_import route
  FOR v_rec IN
    SELECT
      a.id        AS ascent_id,
      r.id        AS old_route_id,
      r.name      AS route_name,
      COALESCE(s.crag_id, r.crag_id) AS crag_id
    FROM ascents a
    JOIN routes r ON r.id = a.route_id
    LEFT JOIN sectors s ON s.id = r.sector_id
    WHERE r.source IS DISTINCT FROM 'pdf_import'
  LOOP

    -- Find PDF route with same name in same crag
    SELECT r2.id INTO v_new_route_id
    FROM routes r2
    LEFT JOIN sectors s2 ON s2.id = r2.sector_id
    WHERE lower(r2.name) = lower(v_rec.route_name)
      AND r2.source = 'pdf_import'
      AND (s2.crag_id = v_rec.crag_id OR r2.crag_id = v_rec.crag_id)
    LIMIT 1;

    IF v_new_route_id IS NOT NULL THEN
      UPDATE ascents SET route_id = v_new_route_id WHERE id = v_rec.ascent_id;
      v_relinked := v_relinked + 1;
    ELSE
      RAISE WARNING 'NO MATCH — ascent % | route "%" | crag %',
        v_rec.ascent_id, v_rec.route_name, v_rec.crag_id;
      v_unmatched := v_unmatched + 1;
    END IF;

  END LOOP;

  RAISE NOTICE 'Re-linked: % | Unmatched: %', v_relinked, v_unmatched;

  IF v_unmatched = 0 THEN
    -- Safe to delete old routes in canonical crags
    DELETE FROM routes
    WHERE source IS DISTINCT FROM 'pdf_import'
      AND (
        crag_id::text  LIKE '00000000-0000-0000-0010-%'
        OR sector_id IN (
          SELECT id FROM sectors
          WHERE crag_id::text LIKE '00000000-0000-0000-0010-%'
        )
      );
    RAISE NOTICE 'Old routes deleted successfully.';
  ELSE
    RAISE WARNING 'Old routes NOT deleted — % ascent(s) unmatched. Fix manually then re-run.', v_unmatched;
  END IF;

END $$;
