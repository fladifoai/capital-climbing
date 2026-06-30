-- Capital Climbing — create areas (province level) and link crags
-- Run AFTER import.sql
-- Safe to re-run.

DO $$
DECLARE
  v_area_id uuid;
BEGIN

  -- Area: L'Aquila (Abruzzo)
  SELECT id INTO v_area_id FROM areas
    WHERE lower(name) = lower('L''Aquila') AND region_id = '00000000-0000-0000-0002-000000000001' LIMIT 1;
  IF v_area_id IS NULL THEN
    INSERT INTO areas (name, normalized_name, slug, region_id, area_type)
    VALUES ('L''Aquila', 'l''aquila', 'l-aquila', '00000000-0000-0000-0002-000000000001', 'province')
    RETURNING id INTO v_area_id;
  END IF;
  -- Link crags to this area
  UPDATE crags SET area_id = v_area_id
    WHERE lower(name) = lower('Petrella Liri') AND region_id = '00000000-0000-0000-0002-000000000001' AND (area_id IS NULL OR area_id != v_area_id);
  UPDATE crags SET area_id = v_area_id
    WHERE lower(name) = lower('Pietrasecca') AND region_id = '00000000-0000-0000-0002-000000000001' AND (area_id IS NULL OR area_id != v_area_id);
  UPDATE crags SET area_id = v_area_id
    WHERE lower(name) = lower('Tagliacozzo') AND region_id = '00000000-0000-0000-0002-000000000001' AND (area_id IS NULL OR area_id != v_area_id);

  -- Area: Frosinone (Lazio)
  SELECT id INTO v_area_id FROM areas
    WHERE lower(name) = lower('Frosinone') AND region_id = '00000000-0000-0000-0002-000000000007' LIMIT 1;
  IF v_area_id IS NULL THEN
    INSERT INTO areas (name, normalized_name, slug, region_id, area_type)
    VALUES ('Frosinone', 'frosinone', 'frosinone', '00000000-0000-0000-0002-000000000007', 'province')
    RETURNING id INTO v_area_id;
  END IF;
  -- Link crags to this area
  UPDATE crags SET area_id = v_area_id
    WHERE lower(name) = lower('Caprile') AND region_id = '00000000-0000-0000-0002-000000000007' AND (area_id IS NULL OR area_id != v_area_id);
  UPDATE crags SET area_id = v_area_id
    WHERE lower(name) = lower('Collepardo') AND region_id = '00000000-0000-0000-0002-000000000007' AND (area_id IS NULL OR area_id != v_area_id);

  -- Area: Latina (Lazio)
  SELECT id INTO v_area_id FROM areas
    WHERE lower(name) = lower('Latina') AND region_id = '00000000-0000-0000-0002-000000000007' LIMIT 1;
  IF v_area_id IS NULL THEN
    INSERT INTO areas (name, normalized_name, slug, region_id, area_type)
    VALUES ('Latina', 'latina', 'latina', '00000000-0000-0000-0002-000000000007', 'province')
    RETURNING id INTO v_area_id;
  END IF;
  -- Link crags to this area
  UPDATE crags SET area_id = v_area_id
    WHERE lower(name) = lower('Norma') AND region_id = '00000000-0000-0000-0002-000000000007' AND (area_id IS NULL OR area_id != v_area_id);

  -- Area: Rieti (Lazio)
  SELECT id INTO v_area_id FROM areas
    WHERE lower(name) = lower('Rieti') AND region_id = '00000000-0000-0000-0002-000000000007' LIMIT 1;
  IF v_area_id IS NULL THEN
    INSERT INTO areas (name, normalized_name, slug, region_id, area_type)
    VALUES ('Rieti', 'rieti', 'rieti', '00000000-0000-0000-0002-000000000007', 'province')
    RETURNING id INTO v_area_id;
  END IF;
  -- Link crags to this area
  UPDATE crags SET area_id = v_area_id
    WHERE lower(name) = lower('Configni') AND region_id = '00000000-0000-0000-0002-000000000007' AND (area_id IS NULL OR area_id != v_area_id);
  UPDATE crags SET area_id = v_area_id
    WHERE lower(name) = lower('Grotti') AND region_id = '00000000-0000-0000-0002-000000000007' AND (area_id IS NULL OR area_id != v_area_id);
  UPDATE crags SET area_id = v_area_id
    WHERE lower(name) = lower('La Fortezza') AND region_id = '00000000-0000-0000-0002-000000000007' AND (area_id IS NULL OR area_id != v_area_id);

  -- Area: Roma (Lazio)
  SELECT id INTO v_area_id FROM areas
    WHERE lower(name) = lower('Roma') AND region_id = '00000000-0000-0000-0002-000000000007' LIMIT 1;
  IF v_area_id IS NULL THEN
    INSERT INTO areas (name, normalized_name, slug, region_id, area_type)
    VALUES ('Roma', 'roma', 'roma', '00000000-0000-0000-0002-000000000007', 'province')
    RETURNING id INTO v_area_id;
  END IF;
  -- Link crags to this area
  UPDATE crags SET area_id = v_area_id
    WHERE lower(name) = lower('Ripa Majala') AND region_id = '00000000-0000-0000-0002-000000000007' AND (area_id IS NULL OR area_id != v_area_id);

  -- Area: Isernia (Molise)
  SELECT id INTO v_area_id FROM areas
    WHERE lower(name) = lower('Isernia') AND region_id = '00000000-0000-0000-0002-000000000011' LIMIT 1;
  IF v_area_id IS NULL THEN
    INSERT INTO areas (name, normalized_name, slug, region_id, area_type)
    VALUES ('Isernia', 'isernia', 'isernia', '00000000-0000-0000-0002-000000000011', 'province')
    RETURNING id INTO v_area_id;
  END IF;
  -- Link crags to this area
  UPDATE crags SET area_id = v_area_id
    WHERE lower(name) = lower('Colle dell''Orso') AND region_id = '00000000-0000-0000-0002-000000000011' AND (area_id IS NULL OR area_id != v_area_id);

  -- Area: Nuoro (Sardegna)
  SELECT id INTO v_area_id FROM areas
    WHERE lower(name) = lower('Nuoro') AND region_id = '00000000-0000-0000-0002-000000000014' LIMIT 1;
  IF v_area_id IS NULL THEN
    INSERT INTO areas (name, normalized_name, slug, region_id, area_type)
    VALUES ('Nuoro', 'nuoro', 'nuoro', '00000000-0000-0000-0002-000000000014', 'province')
    RETURNING id INTO v_area_id;
  END IF;
  -- Link crags to this area
  UPDATE crags SET area_id = v_area_id
    WHERE lower(name) = lower('Ulassai') AND region_id = '00000000-0000-0000-0002-000000000014' AND (area_id IS NULL OR area_id != v_area_id);
  UPDATE crags SET area_id = v_area_id
    WHERE lower(name) = lower('Ussassai') AND region_id = '00000000-0000-0000-0002-000000000014' AND (area_id IS NULL OR area_id != v_area_id);

  -- Area: Terni (Umbria)
  SELECT id INTO v_area_id FROM areas
    WHERE lower(name) = lower('Terni') AND region_id = '00000000-0000-0000-0002-000000000018' LIMIT 1;
  IF v_area_id IS NULL THEN
    INSERT INTO areas (name, normalized_name, slug, region_id, area_type)
    VALUES ('Terni', 'terni', 'terni', '00000000-0000-0000-0002-000000000018', 'province')
    RETURNING id INTO v_area_id;
  END IF;
  -- Link crags to this area
  UPDATE crags SET area_id = v_area_id
    WHERE lower(name) = lower('Ferentillo') AND region_id = '00000000-0000-0000-0002-000000000018' AND (area_id IS NULL OR area_id != v_area_id);

  -- Area: Aosta (Valle d'Aosta)
  SELECT id INTO v_area_id FROM areas
    WHERE lower(name) = lower('Aosta') AND region_id = '00000000-0000-0000-0002-000000000019' LIMIT 1;
  IF v_area_id IS NULL THEN
    INSERT INTO areas (name, normalized_name, slug, region_id, area_type)
    VALUES ('Aosta', 'aosta', 'aosta', '00000000-0000-0000-0002-000000000019', 'province')
    RETURNING id INTO v_area_id;
  END IF;
  -- Link crags to this area
  UPDATE crags SET area_id = v_area_id
    WHERE lower(name) = lower('Miollet') AND region_id = '00000000-0000-0000-0002-000000000019' AND (area_id IS NULL OR area_id != v_area_id);

END $$;
