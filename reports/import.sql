-- Capital Climbing — crag/sector/route import
-- Generated: 2026-06-27T22:45:59.012Z
-- Paste in Supabase SQL Editor and run.
-- Safe to re-run: skips existing records by name.

DO $$
DECLARE
  v_crag_id   uuid;
  v_sector_id uuid;
BEGIN

  -- ── Petrella Liri (Abruzzo) ──
  SELECT id INTO v_crag_id FROM crags
    WHERE lower(name) = lower('Petrella Liri')
      AND region_id = '00000000-0000-0000-0002-000000000001' LIMIT 1;
  IF v_crag_id IS NULL THEN
    -- Also check crags without region_id (from previous imports)
    SELECT id INTO v_crag_id FROM crags
      WHERE lower(name) = lower('Petrella Liri') AND region_id IS NULL LIMIT 1;
    IF v_crag_id IS NOT NULL THEN
      UPDATE crags SET region_id = '00000000-0000-0000-0002-000000000001', country_id = '00000000-0000-0000-0001-000000000001',
        region = 'Abruzzo', province = 'L''Aquila',
        municipality = 'Cappadocia'
      WHERE id = v_crag_id;
    ELSE
      INSERT INTO crags (name, normalized_name, slug, country, country_id, region, region_id, province, municipality, access_status, rainproof, services, aliases)
      VALUES ('Petrella Liri', 'petrella liri', 'petrella-liri',
              'Italy', '00000000-0000-0000-0001-000000000001', 'Abruzzo', '00000000-0000-0000-0002-000000000001',
              'L''Aquila', 'Cappadocia', 'open', false, '{}', '{}')
      RETURNING id INTO v_crag_id;
    END IF;
  END IF;

  -- Settore: Petrella Alta
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Petrella Alta') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Petrella Alta', 'petrella alta', 'petrella-alta', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1 var.dx', 'senza nome 1 var.dx', 'senza-nome-1-var-dx', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1 var.dx') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Antifà', 'antifa', 'antifa', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Antifà') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 2', 'senza nome 2', 'senza-nome-2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 3', 'senza nome 3', 'senza-nome-3', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Alessio Angeloni the driller', 'alessio angeloni the driller', 'alessio-angeloni-the-driller', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Alessio Angeloni the driller') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 5', 'senza nome 5', 'senza-nome-5', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 5') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Enigma', 'enigma', 'enigma', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Enigma') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Altrobazzie', 'altrobazzie', 'altrobazzie', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Altrobazzie') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 6', 'senza nome 6', 'senza-nome-6', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 6') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 7', 'senza nome 7', 'senza-nome-7', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 7') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 8', 'senza nome 8', 'senza-nome-8', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 8') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 9', 'senza nome 9', 'senza-nome-9', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 9') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La teoria dei buchi neri', 'la teoria dei buchi neri', 'la-teoria-dei-buchi-neri', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La teoria dei buchi neri') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Separate reality', 'separate reality', 'separate-reality', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Separate reality') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Glory hole', 'glory hole', 'glory-hole', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Glory hole') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fly Life', 'fly life', 'fly-life', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fly Life') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nel nome del padre', 'nel nome del padre', 'nel-nome-del-padre', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nel nome del padre') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 10', 'senza nome 10', 'senza-nome-10', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 10') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Back to black', 'back to black', 'back-to-black', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Back to black') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Noir desir', 'noir desir', 'noir-desir', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Noir desir') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vendee globe', 'vendee globe', 'vendee-globe', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vendee globe') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Le donne del sud comandano e quantaltro', 'le donne del sud comandano e quantaltro', 'le-donne-del-sud-comandano-e-quantaltro', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Le donne del sud comandano e quantaltro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Venom (var. sx)', 'venom (var. sx)', 'venom-var-sx', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Venom (var. sx)') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Venom', 'venom', 'venom', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Venom') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Osez Josephine', 'osez josephine', 'osez-josephine', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Osez Josephine') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Isue de secours', 'isue de secours', 'isue-de-secours', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Isue de secours') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Le casalingue', 'le casalingue', 'le-casalingue', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Le casalingue') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Modalità aereo', 'modalita aereo', 'modalita-aereo', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Modalità aereo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il pellecchia', 'il pellecchia', 'il-pellecchia', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il pellecchia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 11', 'senza nome 11', 'senza-nome-11', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 11') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 12', 'senza nome 12', 'senza-nome-12', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 12') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 13', 'senza nome 13', 'senza-nome-13', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 13') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sgarbellati la testa', 'sgarbellati la testa', 'sgarbellati-la-testa', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sgarbellati la testa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La donna col SUV', 'la donna col suv', 'la-donna-col-suv', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La donna col SUV') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dolce milù', 'dolce milu', 'dolce-milu', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dolce milù') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ruzza line', 'ruzza line', 'ruzza-line', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ruzza line') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Scamandratemucho', 'scamandratemucho', 'scamandratemucho', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Scamandratemucho') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 14', 'senza nome 14', 'senza-nome-14', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 14') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 15', 'senza nome 15', 'senza-nome-15', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 15') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La sposa cadavere', 'la sposa cadavere', 'la-sposa-cadavere', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La sposa cadavere') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Robotoff', 'robotoff', 'robotoff', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Robotoff') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dio serpente', 'dio serpente', 'dio-serpente', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dio serpente') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Variante Dio serpente', 'variante dio serpente', 'variante-dio-serpente', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Variante Dio serpente') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Anelli di pane', 'anelli di pane', 'anelli-di-pane', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Anelli di pane') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Benvenuti a Duloc', 'benvenuti a duloc', 'benvenuti-a-duloc', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Benvenuti a Duloc') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La pettegola', 'la pettegola', 'la-pettegola', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La pettegola') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vertical', 'vertical', 'vertical', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vertical') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Besame mucho', 'besame mucho', 'besame-mucho', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Besame mucho') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nico', 'nico', 'nico', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nico') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tina', 'tina', 'tina', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lo stratega', 'lo stratega', 'lo-stratega', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lo stratega') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pony express', 'pony express', 'pony-express', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pony express') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Martirio', 'martirio', 'martirio', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Martirio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spirito guida', 'spirito guida', 'spirito-guida', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spirito guida') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ice cube', 'ice cube', 'ice-cube', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ice cube') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ectoplasma', 'ectoplasma', 'ectoplasma', '8b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ectoplasma') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il mosaico di Marta', 'il mosaico di marta', 'il-mosaico-di-marta', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il mosaico di Marta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Made in Germany', 'made in germany', 'made-in-germany', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Made in Germany') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Risiko', 'risiko', 'risiko', '8b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Risiko') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gioco di Gerard', 'gioco di gerard', 'gioco-di-gerard', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gioco di Gerard') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Volo del falco', 'volo del falco', 'volo-del-falco', '8a/8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Volo del falco') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Revenge', 'revenge', 'revenge', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Revenge') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La fine dell''impero', 'la fine dell''impero', 'la-fine-dell-impero', '8b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La fine dell''impero') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lullaby', 'lullaby', 'lullaby', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lullaby') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Anakin', 'anakin', 'anakin', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Anakin') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ronchiatour direct', 'ronchiatour direct', 'ronchiatour-direct', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ronchiatour direct') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ronchiatour', 'ronchiatour', 'ronchiatour', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ronchiatour') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Trazione fatale', 'trazione fatale', 'trazione-fatale', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Trazione fatale') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Snikefinger L1', 'snikefinger l1', 'snikefinger-l1', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Snikefinger L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Snikefinger L1+L2', 'snikefinger l1+l2', 'snikefinger-l1-l2', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Snikefinger L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Godiva', 'godiva', 'godiva', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Godiva') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Goditela', 'goditela', 'goditela', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Goditela') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Per Miriam', 'per miriam', 'per-miriam', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Per Miriam') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Eroi per Miriam', 'eroi per miriam', 'eroi-per-miriam', '7c+/8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Eroi per Miriam') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Eroi nel vento', 'eroi nel vento', 'eroi-nel-vento', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Eroi nel vento') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Biko', 'biko', 'biko', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Biko') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Wish', 'wish', 'wish', '8b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Wish') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Soft', 'soft', 'soft', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Soft') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Liberate Prometeo', 'liberate prometeo', 'liberate-prometeo', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Liberate Prometeo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vamonos', 'vamonos', 'vamonos', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vamonos') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Watah', 'watah', 'watah', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Watah') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Feddayn', 'feddayn', 'feddayn', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Feddayn') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tupamaros', 'tupamaros', 'tupamaros', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tupamaros') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il canto della gabbianella', 'il canto della gabbianella', 'il-canto-della-gabbianella', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il canto della gabbianella') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Opopomoz L1', 'opopomoz l1', 'opopomoz-l1', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Opopomoz L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Opopomoz L2', 'opopomoz l2', 'opopomoz-l2', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Opopomoz L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Linea sognata', 'linea sognata', 'linea-sognata', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Linea sognata') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La biscia che striscia nella fessura liscia', 'la biscia che striscia nella fessura liscia', 'la-biscia-che-striscia-nella-fessura-liscia', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La biscia che striscia nella fessura liscia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 16', 'senza nome 16', 'senza-nome-16', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 16') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Arrivederci Skodre', 'arrivederci skodre', 'arrivederci-skodre', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Arrivederci Skodre') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Onda energetica', 'onda energetica', 'onda-energetica', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Onda energetica') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Alta quota', 'alta quota', 'alta-quota', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Alta quota') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Edema', 'edema', 'edema', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Edema') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 17', 'senza nome 17', 'senza-nome-17', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 17') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Regole di base', 'regole di base', 'regole-di-base', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Regole di base') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sapore di Autan', 'sapore di autan', 'sapore-di-autan', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sapore di Autan') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lupetto', 'lupetto', 'lupetto', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lupetto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Prima gli italiani', 'prima gli italiani', 'prima-gli-italiani', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Prima gli italiani') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Zitto stupidó', 'zitto stupido', 'zitto-stupido', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Zitto stupidó') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Eccolo', 'eccolo', 'eccolo', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Eccolo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''uscita del merlo', 'l''uscita del merlo', 'l-uscita-del-merlo', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''uscita del merlo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spacca corda', 'spacca corda', 'spacca-corda', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spacca corda') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza soldi L1', 'senza soldi l1', 'senza-soldi-l1', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza soldi L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza corda L1+L2', 'senza corda l1+l2', 'senza-corda-l1-l2', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza corda L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Roman Club', 'roman club', 'roman-club', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Roman Club') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ballkan club', 'ballkan club', 'ballkan-club', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ballkan club') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Trapanato remoto', 'trapanato remoto', 'trapanato-remoto', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Trapanato remoto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Temperatura ambiente', 'temperatura ambiente', 'temperatura-ambiente', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Temperatura ambiente') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Old boy', 'old boy', 'old-boy', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Old boy') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Petrella forever', 'petrella forever', 'petrella-forever', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Petrella forever') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Kill Bill', 'kill bill', 'kill-bill', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Kill Bill') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Quasar', 'quasar', 'quasar', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Quasar') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Coca buton', 'coca buton', 'coca-buton', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Coca buton') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Aghetti', 'aghetti', 'aghetti', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Aghetti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La banana', 'la banana', 'la-banana', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La banana') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La carota', 'la carota', 'la-carota', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La carota') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il bastone', 'il bastone', 'il-bastone', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il bastone') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Massa critica', 'massa critica', 'massa-critica', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Massa critica') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Takaya Todoroki', 'takaya todoroki', 'takaya-todoroki', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Takaya Todoroki') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lo zimbello gallico', 'lo zimbello gallico', 'lo-zimbello-gallico', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lo zimbello gallico') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'A modo mio', 'a modo mio', 'a-modo-mio', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('A modo mio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Kind guide', 'kind guide', 'kind-guide', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Kind guide') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vita da spinone', 'vita da spinone', 'vita-da-spinone', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vita da spinone') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Altezza mezza bellezza', 'altezza mezza bellezza', 'altezza-mezza-bellezza', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Altezza mezza bellezza') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fatti i sassi tuoi', 'fatti i sassi tuoi', 'fatti-i-sassi-tuoi', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fatti i sassi tuoi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sette chi?', 'sette chi?', 'sette-chi', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sette chi?') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Soleado', 'soleado', 'soleado', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Soleado') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Battaglia di isso', 'battaglia di isso', 'battaglia-di-isso', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Battaglia di isso') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Battaglia dei poveri', 'battaglia dei poveri', 'battaglia-dei-poveri', '7a+/7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Battaglia dei poveri') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Che lo sforzo sia con te', 'che lo sforzo sia con te', 'che-lo-sforzo-sia-con-te', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Che lo sforzo sia con te') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Via le mani dal cu...ore', 'via le mani dal cu...ore', 'via-le-mani-dal-cu-ore', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Via le mani dal cu...ore') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Auuu', 'auuu', 'auuu', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Auuu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Forza papà', 'forza papa', 'forza-papa', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Forza papà') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Buccia di banana', 'buccia di banana', 'buccia-di-banana', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Buccia di banana') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Obiettivo qualità', 'obiettivo qualita', 'obiettivo-qualita', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Obiettivo qualità') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Play climbing', 'play climbing', 'play-climbing', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Play climbing') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''abbraccio di Dafne', 'l''abbraccio di dafne', 'l-abbraccio-di-dafne', '5b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''abbraccio di Dafne') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ghost', 'ghost', 'ghost', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ghost') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pitbull', 'pitbull', 'pitbull', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pitbull') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Murakami', 'murakami', 'murakami', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Murakami') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Li odio tutti', 'li odio tutti', 'li-odio-tutti', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Li odio tutti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Original shit', 'original shit', 'original-shit', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Original shit') AND sector_id = v_sector_id);

  -- Settore: Placche di Bini
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Placche di Bini') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Placche di Bini', 'placche di bini', 'placche-di-bini', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bob mano di fata', 'bob mano di fata', 'bob-mano-di-fata', '5b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bob mano di fata') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''asino innamorato', 'l''asino innamorato', 'l-asino-innamorato', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''asino innamorato') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Miloù', 'milou', 'milou', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Miloù') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Grillo parlante', 'grillo parlante', 'grillo-parlante', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Grillo parlante') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''arca di Noè', 'l''arca di noe', 'l-arca-di-noe', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''arca di Noè') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vape', 'vape', 'vape', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vape') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Palle', 'palle', 'palle', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Palle') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Orsi marsicani', 'orsi marsicani', 'orsi-marsicani', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Orsi marsicani') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il palanchino', 'il palanchino', 'il-palanchino', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il palanchino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dopo il palanchino', 'dopo il palanchino', 'dopo-il-palanchino', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dopo il palanchino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Kim jong un', 'kim jong un', 'kim-jong-un', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Kim jong un') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La mia nemesi', 'la mia nemesi', 'la-mia-nemesi', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La mia nemesi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Taglio e cucito', 'taglio e cucito', 'taglio-e-cucito', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Taglio e cucito') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Smog', 'smog', 'smog', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Smog') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Paperinox', 'paperinox', 'paperinox', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Paperinox') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Classica', 'classica', 'classica', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Classica') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Stefix L1', 'stefix l1', 'stefix-l1', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Stefix L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ce sta chi ce pensa L2', 'ce sta chi ce pensa l2', 'ce-sta-chi-ce-pensa-l2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ce sta chi ce pensa L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Prurito', 'prurito', 'prurito', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Prurito') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Silvia', 'silvia', 'silvia', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Silvia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cuba libre', 'cuba libre', 'cuba-libre', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cuba libre') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mirco', 'mirco', 'mirco', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mirco') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Orione', 'orione', 'orione', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Orione') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pippicalzelunghe L1', 'pippicalzelunghe l1', 'pippicalzelunghe-l1', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pippicalzelunghe L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La seconda vita di Pippi Calze Lunghe', 'la seconda vita di pippi calze lunghe', 'la-seconda-vita-di-pippi-calze-lunghe', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La seconda vita di Pippi Calze Lunghe') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sauve-qui-peut L1', 'sauve-qui-peut l1', 'sauve-qui-peut-l1', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sauve-qui-peut L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vintage', 'vintage', 'vintage', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vintage') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Voglia di ridere', 'voglia di ridere', 'voglia-di-ridere', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Voglia di ridere') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Voglia di rissa', 'voglia di rissa', 'voglia-di-rissa', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Voglia di rissa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La dieta del muco', 'la dieta del muco', 'la-dieta-del-muco', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La dieta del muco') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fight Club', 'fight club', 'fight-club', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fight Club') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Var. 69', 'var. 69', 'var-69', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Var. 69') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Classe 74', 'classe 74', 'classe-74', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Classe 74') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ferratelle L1', 'ferratelle l1', 'ferratelle-l1', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ferratelle L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ciambellone L2', 'ciambellone l2', 'ciambellone-l2', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ciambellone L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tiramisù L1', 'tiramisu l1', 'tiramisu-l1', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tiramisù L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Babà L2', 'baba l2', 'baba-l2', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Babà L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Creme caramel', 'creme caramel', 'creme-caramel', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Creme caramel') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Creps', 'creps', 'creps', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Creps') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Strudel L1', 'strudel l1', 'strudel-l1', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Strudel L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Strudel L2', 'strudel l2', 'strudel-l2', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Strudel L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Strudel L3', 'strudel l3', 'strudel-l3', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Strudel L3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rumba magica', 'rumba magica', 'rumba-magica', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rumba magica') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 2', 'senza nome 2', 'senza-nome-2', '5b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rumba mistica', 'rumba mistica', 'rumba-mistica', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rumba mistica') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 3', 'senza nome 3', 'senza-nome-3', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Le bateau ivre', 'le bateau ivre', 'le-bateau-ivre', '8b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Le bateau ivre') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 4', 'senza nome 4', 'senza-nome-4', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 4') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 5', 'senza nome 5', 'senza-nome-5', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 5') AND sector_id = v_sector_id);

  -- ── Pietrasecca (Abruzzo) ──
  SELECT id INTO v_crag_id FROM crags
    WHERE lower(name) = lower('Pietrasecca')
      AND region_id = '00000000-0000-0000-0002-000000000001' LIMIT 1;
  IF v_crag_id IS NULL THEN
    -- Also check crags without region_id (from previous imports)
    SELECT id INTO v_crag_id FROM crags
      WHERE lower(name) = lower('Pietrasecca') AND region_id IS NULL LIMIT 1;
    IF v_crag_id IS NOT NULL THEN
      UPDATE crags SET region_id = '00000000-0000-0000-0002-000000000001', country_id = '00000000-0000-0000-0001-000000000001',
        region = 'Abruzzo', province = 'L''Aquila',
        municipality = 'Carsoli'
      WHERE id = v_crag_id;
    ELSE
      INSERT INTO crags (name, normalized_name, slug, country, country_id, region, region_id, province, municipality, access_status, rainproof, services, aliases)
      VALUES ('Pietrasecca', 'pietrasecca', 'pietrasecca',
              'Italy', '00000000-0000-0000-0001-000000000001', 'Abruzzo', '00000000-0000-0000-0002-000000000001',
              'L''Aquila', 'Carsoli', 'open', false, '{}', '{}')
      RETURNING id INTO v_crag_id;
    END IF;
  END IF;

  -- Settore: Vena Cionca
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Vena Cionca') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Vena Cionca', 'vena cionca', 'vena-cionca', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Si puo'' fare', 'si puo'' fare', 'si-puo-fare', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Si puo'' fare') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Scaramuccia', 'scaramuccia', 'scaramuccia', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Scaramuccia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Safari Park', 'safari park', 'safari-park', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Safari Park') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Marina', 'marina', 'marina', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Marina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Silvia', 'silvia', 'silvia', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Silvia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fiore di loto', 'fiore di loto', 'fiore-di-loto', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fiore di loto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 2 L2', 'senza nome 2 l2', 'senza-nome-2-l2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 2 L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La petit mort L2', 'la petit mort l2', 'la-petit-mort-l2', '8c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La petit mort L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La morte L2', 'la morte l2', 'la-morte-l2', '8c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La morte L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tic tac', 'tic tac', 'tic-tac', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tic tac') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Equilibri precari', 'equilibri precari', 'equilibri-precari', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Equilibri precari') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Berhaultmania', 'berhaultmania', 'berhaultmania', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Berhaultmania') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vaimo''', 'vaimo''', 'vaimo', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vaimo''') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lola Falana', 'lola falana', 'lola-falana', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lola Falana') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ordine nuovo', 'ordine nuovo', 'ordine-nuovo', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ordine nuovo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Shangai', 'shangai', 'shangai', '8c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Shangai') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Polifemo', 'polifemo', 'polifemo', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Polifemo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Strapiombami sui bicipiti L1', 'strapiombami sui bicipiti l1', 'strapiombami-sui-bicipiti-l1', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Strapiombami sui bicipiti L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La vita L1+L2', 'la vita l1+l2', 'la-vita-l1-l2', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La vita L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Calipso', 'calipso', 'calipso', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Calipso') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nemo', 'nemo', 'nemo', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nemo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nemo uscita diretta', 'nemo uscita diretta', 'nemo-uscita-diretta', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nemo uscita diretta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nasce Lollo', 'nasce lollo', 'nasce-lollo', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nasce Lollo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Eppoi Lolletto', 'eppoi lolletto', 'eppoi-lolletto', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Eppoi Lolletto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Aridatece la Gioconda', 'aridatece la gioconda', 'aridatece-la-gioconda', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Aridatece la Gioconda') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Stretching per un nano', 'stretching per un nano', 'stretching-per-un-nano', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Stretching per un nano') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Napalm dead L2', 'napalm dead l2', 'napalm-dead-l2', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Napalm dead L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bouldermania', 'bouldermania', 'bouldermania', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bouldermania') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Jokerman', 'jokerman', 'jokerman', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Jokerman') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rana gastrica', 'rana gastrica', 'rana-gastrica', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rana gastrica') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Merdacce', 'merdacce', 'merdacce', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Merdacce') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mary L1', 'mary l1', 'mary-l1', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mary L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Caporaju L2', 'caporaju l2', 'caporaju-l2', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Caporaju L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Le bugie hanno le gambe corte', 'le bugie hanno le gambe corte', 'le-bugie-hanno-le-gambe-corte', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Le bugie hanno le gambe corte') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Uragano', 'uragano', 'uragano', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Uragano') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'So ito pe stracci', 'so ito pe stracci', 'so-ito-pe-stracci', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('So ito pe stracci') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gemella di sinistra', 'gemella di sinistra', 'gemella-di-sinistra', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gemella di sinistra') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gemella di destra', 'gemella di destra', 'gemella-di-destra', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gemella di destra') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Se vi va! L1', 'se vi va! l1', 'se-vi-va-l1', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Se vi va! L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Se vi va! L2', 'se vi va! l2', 'se-vi-va-l2', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Se vi va! L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Miriam', 'miriam', 'miriam', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Miriam') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lama non lama L1', 'lama non lama l1', 'lama-non-lama-l1', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lama non lama L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lama non lama L2', 'lama non lama l2', 'lama-non-lama-l2', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lama non lama L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lotar', 'lotar', 'lotar', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lotar') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fasa', 'fasa', 'fasa', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fasa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cannolo siciliano', 'cannolo siciliano', 'cannolo-siciliano', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cannolo siciliano') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Jab', 'jab', 'jab', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Jab') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Eresia', 'eresia', 'eresia', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Eresia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Siddharta', 'siddharta', 'siddharta', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Siddharta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nick di Bari', 'nick di bari', 'nick-di-bari', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nick di Bari') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La spattonata del Presidente', 'la spattonata del presidente', 'la-spattonata-del-presidente', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La spattonata del Presidente') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ribelli urlanti', 'ribelli urlanti', 'ribelli-urlanti', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ribelli urlanti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ribelli urlanti var. dx.', 'ribelli urlanti var. dx.', 'ribelli-urlanti-var-dx', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ribelli urlanti var. dx.') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Leaders in sindrome', 'leaders in sindrome', 'leaders-in-sindrome', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Leaders in sindrome') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Je vais', 'je vais', 'je-vais', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Je vais') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Yama', 'yama', 'yama', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Yama') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Eos', 'eos', 'eos', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Eos') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Auguri Veronica', 'auguri veronica', 'auguri-veronica', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Auguri Veronica') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pietraseckante', 'pietraseckante', 'pietraseckante', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pietraseckante') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pontini in trasferta', 'pontini in trasferta', 'pontini-in-trasferta', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pontini in trasferta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Auto...stima', 'auto...stima', 'auto-stima', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Auto...stima') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Appiglio prezioso', 'appiglio prezioso', 'appiglio-prezioso', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Appiglio prezioso') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Classica', 'classica', 'classica', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Classica') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nata al sole', 'nata al sole', 'nata-al-sole', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nata al sole') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Solengo', 'solengo', 'solengo', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Solengo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La mia rovina', 'la mia rovina', 'la-mia-rovina', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La mia rovina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Caro Federico', 'caro federico', 'caro-federico', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Caro Federico') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sembra facile L1', 'sembra facile l1', 'sembra-facile-l1', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sembra facile L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Placca di Danser L2', 'placca di danser l2', 'placca-di-danser-l2', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Placca di Danser L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Danser in the sky L2', 'danser in the sky l2', 'danser-in-the-sky-l2', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Danser in the sky L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Service après vente', 'service apres vente', 'service-apres-vente', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Service après vente') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il cordino di Paola', 'il cordino di paola', 'il-cordino-di-paola', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il cordino di Paola') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La mossa', 'la mossa', 'la-mossa', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La mossa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sotto la pioggia L1', 'sotto la pioggia l1', 'sotto-la-pioggia-l1', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sotto la pioggia L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il volpone rampante L2', 'il volpone rampante l2', 'il-volpone-rampante-l2', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il volpone rampante L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'A sinistra del televisore L1', 'a sinistra del televisore l1', 'a-sinistra-del-televisore-l1', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('A sinistra del televisore L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mannaggia all''ortolano L2', 'mannaggia all''ortolano l2', 'mannaggia-all-ortolano-l2', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mannaggia all''ortolano L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'I bloccati L1', 'i bloccati l1', 'i-bloccati-l1', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('I bloccati L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Franziskaner e noccioline L2', 'franziskaner e noccioline l2', 'franziskaner-e-noccioline-l2', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Franziskaner e noccioline L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La grande fuga', 'la grande fuga', 'la-grande-fuga', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La grande fuga') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rick e Tack', 'rick e tack', 'rick-e-tack', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rick e Tack') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cardo maximo', 'cardo maximo', 'cardo-maximo', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cardo maximo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''anno che verrà', 'l''anno che verra', 'l-anno-che-verra', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''anno che verrà') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '4 marzo 1943', '4 marzo 1943', '4-marzo-1943', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('4 marzo 1943') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Quelli che il mercoledi''...', 'quelli che il mercoledi''...', 'quelli-che-il-mercoledi', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Quelli che il mercoledi''...') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La valigia di cartone', 'la valigia di cartone', 'la-valigia-di-cartone', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La valigia di cartone') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'My architect', 'my architect', 'my-architect', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('My architect') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Arrivederci Moneta', 'arrivederci moneta', 'arrivederci-moneta', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Arrivederci Moneta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Carbonella', 'carbonella', 'carbonella', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Carbonella') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lo scorpione', 'lo scorpione', 'lo-scorpione', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lo scorpione') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Croce e delizia', 'croce e delizia', 'croce-e-delizia', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Croce e delizia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Miss Magoo', 'miss magoo', 'miss-magoo', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Miss Magoo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pisolo', 'pisolo', 'pisolo', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pisolo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mammolo', 'mammolo', 'mammolo', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mammolo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Buongiorno Pietrasecca', 'buongiorno pietrasecca', 'buongiorno-pietrasecca', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Buongiorno Pietrasecca') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lame rotanti', 'lame rotanti', 'lame-rotanti', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lame rotanti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lady Frittata', 'lady frittata', 'lady-frittata', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lady Frittata') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Orso merendino', 'orso merendino', 'orso-merendino', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Orso merendino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'MetaMarzo', 'metamarzo', 'metamarzo', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('MetaMarzo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La smaranza', 'la smaranza', 'la-smaranza', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La smaranza') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'A destra del lampadario', 'a destra del lampadario', 'a-destra-del-lampadario', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('A destra del lampadario') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 3', 'senza nome 3', 'senza-nome-3', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 4', 'senza nome 4', 'senza-nome-4', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 4') AND sector_id = v_sector_id);

  -- ── Tagliacozzo (Abruzzo) ──
  SELECT id INTO v_crag_id FROM crags
    WHERE lower(name) = lower('Tagliacozzo')
      AND region_id = '00000000-0000-0000-0002-000000000001' LIMIT 1;
  IF v_crag_id IS NULL THEN
    -- Also check crags without region_id (from previous imports)
    SELECT id INTO v_crag_id FROM crags
      WHERE lower(name) = lower('Tagliacozzo') AND region_id IS NULL LIMIT 1;
    IF v_crag_id IS NOT NULL THEN
      UPDATE crags SET region_id = '00000000-0000-0000-0002-000000000001', country_id = '00000000-0000-0000-0001-000000000001',
        region = 'Abruzzo', province = 'L''Aquila',
        municipality = NULL
      WHERE id = v_crag_id;
    ELSE
      INSERT INTO crags (name, normalized_name, slug, country, country_id, region, region_id, province, municipality, access_status, rainproof, services, aliases)
      VALUES ('Tagliacozzo', 'tagliacozzo', 'tagliacozzo',
              'Italy', '00000000-0000-0000-0001-000000000001', 'Abruzzo', '00000000-0000-0000-0002-000000000001',
              'L''Aquila', NULL, 'open', false, '{}', '{}')
      RETURNING id INTO v_crag_id;
    END IF;
  END IF;

  -- Settore: Estrema Destra
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Estrema Destra') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Estrema Destra', 'estrema destra', 'estrema-destra', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 4', 'senza nome 4', 'senza-nome-4', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 4') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Diedro naril', 'diedro naril', 'diedro-naril', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Diedro naril') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Antonello lo spiantato', 'antonello lo spiantato', 'antonello-lo-spiantato', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Antonello lo spiantato') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sbagliando t''impala', 'sbagliando t''impala', 'sbagliando-t-impala', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sbagliando t''impala') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Serpentone', 'serpentone', 'serpentone', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Serpentone') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Acido nirvanico', 'acido nirvanico', 'acido-nirvanico', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Acido nirvanico') AND sector_id = v_sector_id);

  -- Settore: Estrema Sinistra
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Estrema Sinistra') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Estrema Sinistra', 'estrema sinistra', 'estrema-sinistra', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vituzza', 'vituzza', 'vituzza', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vituzza') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pasqualina 08', 'pasqualina 08', 'pasqualina-08', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pasqualina 08') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rossino', 'rossino', 'rossino', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rossino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Unita'' vinofila', 'unita'' vinofila', 'unita-vinofila', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Unita'' vinofila') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spigoletto', 'spigoletto', 'spigoletto', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spigoletto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Camel trek', 'camel trek', 'camel-trek', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Camel trek') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 2', 'senza nome 2', 'senza-nome-2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id);

  -- Settore: Grande Tetto
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Grande Tetto') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Grande Tetto', 'grande tetto', 'grande-tetto', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Don''t eat the yellow snow', 'don''t eat the yellow snow', 'don-t-eat-the-yellow-snow', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Don''t eat the yellow snow') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dirty love', 'dirty love', 'dirty-love', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dirty love') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Equinozio', 'equinozio', 'equinozio', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Equinozio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ghepardi da salotto L1', 'ghepardi da salotto l1', 'ghepardi-da-salotto-l1', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ghepardi da salotto L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tengo ''na minchia tanta L2', 'tengo ''na minchia tanta l2', 'tengo-na-minchia-tanta-l2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tengo ''na minchia tanta L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Zero umiltà', 'zero umilta', 'zero-umilta', '7c/7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Zero umiltà') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Salto di Stagione L1', 'salto di stagione l1', 'salto-di-stagione-l1', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Salto di Stagione L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Salto di stagione L1+L2', 'salto di stagione l1+l2', 'salto-di-stagione-l1-l2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Salto di stagione L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ballo liscio L1', 'ballo liscio l1', 'ballo-liscio-l1', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ballo liscio L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Elledue L2', 'elledue l2', 'elledue-l2', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Elledue L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Buchi-Hughi', 'buchi-hughi', 'buchi-hughi', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Buchi-Hughi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Toto bang', 'toto bang', 'toto-bang', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Toto bang') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il signore di Petrella', 'il signore di petrella', 'il-signore-di-petrella', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il signore di Petrella') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''arte di giudicare', 'l''arte di giudicare', 'l-arte-di-giudicare', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''arte di giudicare') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Torna a Surriento', 'torna a surriento', 'torna-a-surriento', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Torna a Surriento') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Che spread L1', 'che spread l1', 'che-spread-l1', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Che spread L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Che spread L1+L2', 'che spread l1+l2', 'che-spread-l1-l2', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Che spread L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il caffè di Domenico', 'il caffe di domenico', 'il-caffe-di-domenico', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il caffè di Domenico') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Profumo di abbacchio', 'profumo di abbacchio', 'profumo-di-abbacchio', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Profumo di abbacchio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Così è la vita', 'cosi e la vita', 'cosi-e-la-vita', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Così è la vita') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mòsò mandorle amare', 'moso mandorle amare', 'moso-mandorle-amare', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mòsò mandorle amare') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Marrakesh express', 'marrakesh express', 'marrakesh-express', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Marrakesh express') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rosicamentos', 'rosicamentos', 'rosicamentos', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rosicamentos') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spigolando', 'spigolando', 'spigolando', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spigolando') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Glutei in fiamme', 'glutei in fiamme', 'glutei-in-fiamme', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Glutei in fiamme') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Porco demonio', 'porco demonio', 'porco-demonio', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Porco demonio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 3', 'senza nome 3', 'senza-nome-3', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '4 maggio', '4 maggio', '4-maggio', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('4 maggio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il morbo di Arianna', 'il morbo di arianna', 'il-morbo-di-arianna', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il morbo di Arianna') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La mia nuova fidanzata', 'la mia nuova fidanzata', 'la-mia-nuova-fidanzata', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La mia nuova fidanzata') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Questione di panze', 'questione di panze', 'questione-di-panze', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Questione di panze') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ah Toto', 'ah toto', 'ah-toto', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ah Toto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Anita', 'anita', 'anita', '4c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Anita') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Giulia', 'giulia', 'giulia', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Giulia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Le tre Laure', 'le tre laure', 'le-tre-laure', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Le tre Laure') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Beatrice', 'beatrice', 'beatrice', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Beatrice') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Alice', 'alice', 'alice', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Alice') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fabiana', 'fabiana', 'fabiana', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fabiana') AND sector_id = v_sector_id);

  -- Settore: Scudo Centrale
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Scudo Centrale') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Scudo Centrale', 'scudo centrale', 'scudo-centrale', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Muccassassina', 'muccassassina', 'muccassassina', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Muccassassina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '40° all''ombra', '40° all''ombra', '40-all-ombra', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('40° all''ombra') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bultro 71', 'bultro 71', 'bultro-71', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bultro 71') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ultima chans', 'ultima chans', 'ultima-chans', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ultima chans') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Giorgia', 'giorgia', 'giorgia', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Giorgia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La spagnola L1', 'la spagnola l1', 'la-spagnola-l1', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La spagnola L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La spagnola L1+L2', 'la spagnola l1+l2', 'la-spagnola-l1-l2', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La spagnola L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Inglese', 'inglese', 'inglese', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Inglese') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Distretto marsicano', 'distretto marsicano', 'distretto-marsicano', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Distretto marsicano') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cazzo è finita la birra', 'cazzo e finita la birra', 'cazzo-e-finita-la-birra', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cazzo è finita la birra') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'A tutta birra', 'a tutta birra', 'a-tutta-birra', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('A tutta birra') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Samoano', 'samoano', 'samoano', '6a+/6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Samoano') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mistral', 'mistral', 'mistral', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mistral') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Miky Mouse', 'miky mouse', 'miky-mouse', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Miky Mouse') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Buona la prima', 'buona la prima', 'buona-la-prima', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Buona la prima') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Scassa palle', 'scassa palle', 'scassa-palle', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Scassa palle') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Jumping fox', 'jumping fox', 'jumping-fox', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Jumping fox') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Versante est', 'versante est', 'versante-est', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Versante est') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vecchio chiodo', 'vecchio chiodo', 'vecchio-chiodo', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vecchio chiodo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Arihummer', 'arihummer', 'arihummer', '5c+/6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Arihummer') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Angelo custode', 'angelo custode', 'angelo-custode', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Angelo custode') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ottoz', 'ottoz', 'ottoz', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ottoz') AND sector_id = v_sector_id);

  -- ── Caprile (Lazio) ──
  SELECT id INTO v_crag_id FROM crags
    WHERE lower(name) = lower('Caprile')
      AND region_id = '00000000-0000-0000-0002-000000000007' LIMIT 1;
  IF v_crag_id IS NULL THEN
    -- Also check crags without region_id (from previous imports)
    SELECT id INTO v_crag_id FROM crags
      WHERE lower(name) = lower('Caprile') AND region_id IS NULL LIMIT 1;
    IF v_crag_id IS NOT NULL THEN
      UPDATE crags SET region_id = '00000000-0000-0000-0002-000000000007', country_id = '00000000-0000-0000-0001-000000000001',
        region = 'Lazio', province = 'Frosinone',
        municipality = NULL
      WHERE id = v_crag_id;
    ELSE
      INSERT INTO crags (name, normalized_name, slug, country, country_id, region, region_id, province, municipality, access_status, rainproof, services, aliases)
      VALUES ('Caprile', 'caprile', 'caprile',
              'Italy', '00000000-0000-0000-0001-000000000001', 'Lazio', '00000000-0000-0000-0002-000000000007',
              'Frosinone', NULL, 'open', false, '{}', '{}')
      RETURNING id INTO v_crag_id;
    END IF;
  END IF;

  -- Settore: Eremo
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Eremo') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Eremo', 'eremo', 'eremo', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'acCiuffaPolli', 'acciuffapolli', 'acciuffapolli', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('acCiuffaPolli') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '+Salgo+Piango', '+salgo+piango', 'salgo-piango', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('+Salgo+Piango') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Zio Alx', 'zio alx', 'zio-alx', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Zio Alx') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Wishyouwherehere', 'wishyouwherehere', 'wishyouwherehere', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Wishyouwherehere') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Habemus nomen', 'habemus nomen', 'habemus-nomen', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Habemus nomen') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Salsiccia', 'salsiccia', 'salsiccia', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Salsiccia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ludo', 'ludo', 'ludo', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ludo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 2', 'senza nome 2', 'senza-nome-2', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 3', 'senza nome 3', 'senza-nome-3', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 4', 'senza nome 4', 'senza-nome-4', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 4') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 5', 'senza nome 5', 'senza-nome-5', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 5') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 6', 'senza nome 6', 'senza-nome-6', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 6') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 7', 'senza nome 7', 'senza-nome-7', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 7') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 8', 'senza nome 8', 'senza-nome-8', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 8') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 9 L1', 'senza nome 9 l1', 'senza-nome-9-l1', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 9 L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 9 L2', 'senza nome 9 l2', 'senza-nome-9-l2', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 9 L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 9 L1+L2', 'senza nome 9 l1+l2', 'senza-nome-9-l1-l2', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 9 L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 10 L1', 'senza nome 10 l1', 'senza-nome-10-l1', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 10 L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 10 L2', 'senza nome 10 l2', 'senza-nome-10-l2', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 10 L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 10 L1+L2', 'senza nome 10 l1+l2', 'senza-nome-10-l1-l2', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 10 L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '30 bare', '30 bare', '30-bare', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('30 bare') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 11', 'senza nome 11', 'senza-nome-11', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 11') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 12', 'senza nome 12', 'senza-nome-12', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 12') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 13', 'senza nome 13', 'senza-nome-13', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 13') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La bua', 'la bua', 'la-bua', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La bua') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Caprile dreaming', 'caprile dreaming', 'caprile-dreaming', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Caprile dreaming') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Questa non l''hai fatta Frà?', 'questa non l''hai fatta fra?', 'questa-non-l-hai-fatta-fra', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Questa non l''hai fatta Frà?') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lo svita miti', 'lo svita miti', 'lo-svita-miti', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lo svita miti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Culo (Cialis?)', 'culo (cialis?)', 'culo-cialis', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Culo (Cialis?)') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pancia pelosa', 'pancia pelosa', 'pancia-pelosa', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pancia pelosa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 14', 'senza nome 14', 'senza-nome-14', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 14') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fanaticaria', 'fanaticaria', 'fanaticaria', '5b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fanaticaria') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 15', 'senza nome 15', 'senza-nome-15', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 15') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Oltre lo spigolo', 'oltre lo spigolo', 'oltre-lo-spigolo', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Oltre lo spigolo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 16', 'senza nome 16', 'senza-nome-16', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 16') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 17', 'senza nome 17', 'senza-nome-17', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 17') AND sector_id = v_sector_id);

  -- Settore: I Gradoni
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('I Gradoni') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('I Gradoni', 'i gradoni', 'i-gradoni', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 2', 'senza nome 2', 'senza-nome-2', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bocca figa', 'bocca figa', 'bocca-figa', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bocca figa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Collaborazione', 'collaborazione', 'collaborazione', '6b/6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Collaborazione') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Superkactus', 'superkactus', 'superkactus', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Superkactus') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'B-107-K', 'b-107-k', 'b-107-k', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('B-107-K') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tritadita', 'tritadita', 'tritadita', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tritadita') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lo scambista L1', 'lo scambista l1', 'lo-scambista-l1', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lo scambista L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rereset L2', 'rereset l2', 'rereset-l2', '7a+/7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rereset L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Anticelli L1', 'anticelli l1', 'anticelli-l1', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Anticelli L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il Brodo è di Gallina L2', 'il brodo e di gallina l2', 'il-brodo-e-di-gallina-l2', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il Brodo è di Gallina L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fiasco collection', 'fiasco collection', 'fiasco-collection', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fiasco collection') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Peppedek', 'peppedek', 'peppedek', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Peppedek') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mani di forbice', 'mani di forbice', 'mani-di-forbice', '6c+/7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mani di forbice') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Una volta era un bel posto', 'una volta era un bel posto', 'una-volta-era-un-bel-posto', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Una volta era un bel posto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mimí Cocò', 'mimi coco', 'mimi-coco', '5b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mimí Cocò') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Neutroni', 'neutroni', 'neutroni', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Neutroni') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lucigolett', 'lucigolett', 'lucigolett', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lucigolett') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Quilk (Domatore di vermi)', 'quilk (domatore di vermi)', 'quilk-domatore-di-vermi', '6a+/6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Quilk (Domatore di vermi)') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tre di gobbe', 'tre di gobbe', 'tre-di-gobbe', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tre di gobbe') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tagliaspinoterapia', 'tagliaspinoterapia', 'tagliaspinoterapia', '5c+/6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tagliaspinoterapia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Diedro sporcaccione', 'diedro sporcaccione', 'diedro-sporcaccione', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Diedro sporcaccione') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 3', 'senza nome 3', 'senza-nome-3', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 4', 'senza nome 4', 'senza-nome-4', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 4') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 5', 'senza nome 5', 'senza-nome-5', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 5') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 6', 'senza nome 6', 'senza-nome-6', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 6') AND sector_id = v_sector_id);

  -- Settore: Le Canne
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Le Canne') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Le Canne', 'le canne', 'le-canne', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ma che cactus fai?', 'ma che cactus fai?', 'ma-che-cactus-fai', '6a+/6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ma che cactus fai?') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Califfato ciociaro', 'califfato ciociaro', 'califfato-ciociaro', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Califfato ciociaro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 2', 'senza nome 2', 'senza-nome-2', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 3', 'senza nome 3', 'senza-nome-3', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 4', 'senza nome 4', 'senza-nome-4', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 4') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 5', 'senza nome 5', 'senza-nome-5', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 5') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Stalattite nel bucone', 'stalattite nel bucone', 'stalattite-nel-bucone', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Stalattite nel bucone') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 5 bis', 'senza nome 5 bis', 'senza-nome-5-bis', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 5 bis') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 6', 'senza nome 6', 'senza-nome-6', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 6') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 6 bis', 'senza nome 6 bis', 'senza-nome-6-bis', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 6 bis') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Canne rosse', 'canne rosse', 'canne-rosse', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Canne rosse') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 7', 'senza nome 7', 'senza-nome-7', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 7') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 8', 'senza nome 8', 'senza-nome-8', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 8') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 9', 'senza nome 9', 'senza-nome-9', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 9') AND sector_id = v_sector_id);

  -- Settore: Le Grandi Panze
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Le Grandi Panze') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Le Grandi Panze', 'le grandi panze', 'le-grandi-panze', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1 L1', 'senza nome 1 l1', 'senza-nome-1-l1', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1 L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1 L2', 'senza nome 1 l2', 'senza-nome-1-l2', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1 L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 2 L1', 'senza nome 2 l1', 'senza-nome-2-l1', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 2 L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 2 L2', 'senza nome 2 l2', 'senza-nome-2-l2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 2 L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Job', 'job', 'job', '5b+/5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Job') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La biomeccanica', 'la biomeccanica', 'la-biomeccanica', '5a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La biomeccanica') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cioppi Cioppi', 'cioppi cioppi', 'cioppi-cioppi', '5b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cioppi Cioppi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 3', 'senza nome 3', 'senza-nome-3', '5a+/5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 4', 'senza nome 4', 'senza-nome-4', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 4') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Acido lattico', 'acido lattico', 'acido-lattico', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Acido lattico') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Centerbe', 'centerbe', 'centerbe', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Centerbe') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sesto acuto', 'sesto acuto', 'sesto-acuto', '5b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sesto acuto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cirrosi sciatica', 'cirrosi sciatica', 'cirrosi-sciatica', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cirrosi sciatica') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Giovanna d''Arco', 'giovanna d''arco', 'giovanna-d-arco', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Giovanna d''Arco') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 5', 'senza nome 5', 'senza-nome-5', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 5') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Buccia d''arancia', 'buccia d''arancia', 'buccia-d-arancia', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Buccia d''arancia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La pececa L1', 'la pececa l1', 'la-pececa-l1', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La pececa L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Centocimici L2', 'centocimici l2', 'centocimici-l2', '6c+/7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Centocimici L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 6', 'senza nome 6', 'senza-nome-6', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 6') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 7', 'senza nome 7', 'senza-nome-7', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 7') AND sector_id = v_sector_id);

  -- ── Collepardo (Lazio) ──
  SELECT id INTO v_crag_id FROM crags
    WHERE lower(name) = lower('Collepardo')
      AND region_id = '00000000-0000-0000-0002-000000000007' LIMIT 1;
  IF v_crag_id IS NULL THEN
    -- Also check crags without region_id (from previous imports)
    SELECT id INTO v_crag_id FROM crags
      WHERE lower(name) = lower('Collepardo') AND region_id IS NULL LIMIT 1;
    IF v_crag_id IS NOT NULL THEN
      UPDATE crags SET region_id = '00000000-0000-0000-0002-000000000007', country_id = '00000000-0000-0000-0001-000000000001',
        region = 'Lazio', province = 'Frosinone',
        municipality = NULL
      WHERE id = v_crag_id;
    ELSE
      INSERT INTO crags (name, normalized_name, slug, country, country_id, region, region_id, province, municipality, access_status, rainproof, services, aliases)
      VALUES ('Collepardo', 'collepardo', 'collepardo',
              'Italy', '00000000-0000-0000-0001-000000000001', 'Lazio', '00000000-0000-0000-0002-000000000007',
              'Frosinone', NULL, 'open', false, '{}', '{}')
      RETURNING id INTO v_crag_id;
    END IF;
  END IF;

  -- Settore: Cueva
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Cueva') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Cueva', 'cueva', 'cueva', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Traverso della muerte L1', 'traverso della muerte l1', 'traverso-della-muerte-l1', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Traverso della muerte L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Traverso della muerte L1+L2', 'traverso della muerte l1+l2', 'traverso-della-muerte-l1-l2', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Traverso della muerte L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Traverso dei sogni', 'traverso dei sogni', 'traverso-dei-sogni', '8b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Traverso dei sogni') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Reveille-toi', 'reveille-toi', 'reveille-toi', '9a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Reveille-toi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tomorrowland L1', 'tomorrowland l1', 'tomorrowland-l1', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tomorrowland L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La terra dei sogni L1+L2', 'la terra dei sogni l1+l2', 'la-terra-dei-sogni-l1-l2', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La terra dei sogni L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tomorrowland extension L1', 'tomorrowland extension l1', 'tomorrowland-extension-l1', '8c+/9a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tomorrowland extension L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tomorrowland extension L1+L2', 'tomorrowland extension l1+l2', 'tomorrowland-extension-l1-l2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tomorrowland extension L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bella Lù L1', 'bella lu l1', 'bella-lu-l1', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bella Lù L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bella Lù L1+L2', 'bella lu l1+l2', 'bella-lu-l1-l2', '8a+/8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bella Lù L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Clorophilla L1', 'clorophilla l1', 'clorophilla-l1', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Clorophilla L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Clorophilla L1+L2', 'clorophilla l1+l2', 'clorophilla-l1-l2', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Clorophilla L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Donkey kong', 'donkey kong', 'donkey-kong', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Donkey kong') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''assassino L1', 'l''assassino l1', 'l-assassino-l1', '6c+/7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''assassino L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''assassino L1+L2', 'l''assassino l1+l2', 'l-assassino-l1-l2', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''assassino L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il ritorno', 'il ritorno', 'il-ritorno', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il ritorno') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sadomasoclimb L1', 'sadomasoclimb l1', 'sadomasoclimb-l1', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sadomasoclimb L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sadomasoclimb L1+L2', 'sadomasoclimb l1+l2', 'sadomasoclimb-l1-l2', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sadomasoclimb L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Madonnazinonvedol''ora', 'madonnazinonvedol''ora', 'madonnazinonvedol-ora', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Madonnazinonvedol''ora') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spermatocanna', 'spermatocanna', 'spermatocanna', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spermatocanna') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''anno mio', 'l''anno mio', 'l-anno-mio', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''anno mio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Abbasso la pinna', 'abbasso la pinna', 'abbasso-la-pinna', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Abbasso la pinna') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cresta di gallo', 'cresta di gallo', 'cresta-di-gallo', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cresta di gallo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Torno subito', 'torno subito', 'torno-subito', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Torno subito') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Super Crack', 'super crack', 'super-crack', '8b/8b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Super Crack') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Piccola Giulia', 'piccola giulia', 'piccola-giulia', '6c+/7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Piccola Giulia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La gasparata L1', 'la gasparata l1', 'la-gasparata-l1', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La gasparata L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La gasparata L1+L2', 'la gasparata l1+l2', 'la-gasparata-l1-l2', '8c+/9a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La gasparata L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '95 bpm', '95 bpm', '95-bpm', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('95 bpm') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La spada Jedy L1', 'la spada jedy l1', 'la-spada-jedy-l1', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La spada Jedy L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Yuri Gagarin L1+L2', 'yuri gagarin l1+l2', 'yuri-gagarin-l1-l2', '8b+/8c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Yuri Gagarin L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'I sette passi', 'i sette passi', 'i-sette-passi', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('I sette passi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fuckaldo L1', 'fuckaldo l1', 'fuckaldo-l1', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fuckaldo L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ma non vuoi o non puoi? L1+L2', 'ma non vuoi o non puoi? l1+l2', 'ma-non-vuoi-o-non-puoi-l1-l2', '8b/8b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ma non vuoi o non puoi? L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vertical Park L1+L2+L3', 'vertical park l1+l2+l3', 'vertical-park-l1-l2-l3', '8c/8c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vertical Park L1+L2+L3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Eye of the tiger', 'eye of the tiger', 'eye-of-the-tiger', '8b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Eye of the tiger') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'One peace', 'one peace', 'one-peace', '8b+/8c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('One peace') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '3:36', '3:36', '3-36', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('3:36') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Se non ci penso io...', 'se non ci penso io...', 'se-non-ci-penso-io', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Se non ci penso io...') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La scallona', 'la scallona', 'la-scallona', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La scallona') AND sector_id = v_sector_id);

  -- Settore: Cuevita
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Cuevita') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Cuevita', 'cuevita', 'cuevita', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Come piace a me', 'come piace a me', 'come-piace-a-me', '6c/6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Come piace a me') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Felix', 'felix', 'felix', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Felix') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Riabassa la pinna', 'riabassa la pinna', 'riabassa-la-pinna', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Riabassa la pinna') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '50/50', '50/50', '50-50', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('50/50') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Super santos', 'super santos', 'super-santos', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Super santos') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sono finiti gli anni 80', 'sono finiti gli anni 80', 'sono-finiti-gli-anni-80', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sono finiti gli anni 80') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mister laghetto', 'mister laghetto', 'mister-laghetto', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mister laghetto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''incompresa', 'l''incompresa', 'l-incompresa', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''incompresa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Zio Domenico', 'zio domenico', 'zio-domenico', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Zio Domenico') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Old skull', 'old skull', 'old-skull', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Old skull') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nero a metà', 'nero a meta', 'nero-a-meta', '6b/6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nero a metà') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il bullo, il manesco e l''autistico', 'il bullo, il manesco e l''autistico', 'il-bullo-il-manesco-e-l-autistico', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il bullo, il manesco e l''autistico') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vertical family', 'vertical family', 'vertical-family', '6c+/7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vertical family') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 2', 'senza nome 2', 'senza-nome-2', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Merda de vacca', 'merda de vacca', 'merda-de-vacca', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Merda de vacca') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 3', 'senza nome 3', 'senza-nome-3', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il nero sfinisce', 'il nero sfinisce', 'il-nero-sfinisce', '8b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il nero sfinisce') AND sector_id = v_sector_id);

  -- ── Norma (Lazio) ──
  SELECT id INTO v_crag_id FROM crags
    WHERE lower(name) = lower('Norma')
      AND region_id = '00000000-0000-0000-0002-000000000007' LIMIT 1;
  IF v_crag_id IS NULL THEN
    -- Also check crags without region_id (from previous imports)
    SELECT id INTO v_crag_id FROM crags
      WHERE lower(name) = lower('Norma') AND region_id IS NULL LIMIT 1;
    IF v_crag_id IS NOT NULL THEN
      UPDATE crags SET region_id = '00000000-0000-0000-0002-000000000007', country_id = '00000000-0000-0000-0001-000000000001',
        region = 'Lazio', province = 'Latina',
        municipality = NULL
      WHERE id = v_crag_id;
    ELSE
      INSERT INTO crags (name, normalized_name, slug, country, country_id, region, region_id, province, municipality, access_status, rainproof, services, aliases)
      VALUES ('Norma', 'norma', 'norma',
              'Italy', '00000000-0000-0000-0001-000000000001', 'Lazio', '00000000-0000-0000-0002-000000000007',
              'Latina', NULL, 'open', false, '{}', '{}')
      RETURNING id INTO v_crag_id;
    END IF;
  END IF;

  -- Settore: Placche Rosse
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Placche Rosse') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Placche Rosse', 'placche rosse', 'placche-rosse', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Hard lisc', 'hard lisc', 'hard-lisc', '5a+/5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Hard lisc') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Melanio', 'melanio', 'melanio', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Melanio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Drakulesco', 'drakulesco', 'drakulesco', '5c+/6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Drakulesco') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Salsa', 'salsa', 'salsa', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Salsa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Merengue', 'merengue', 'merengue', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Merengue') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Eroe del silenzio', 'eroe del silenzio', 'eroe-del-silenzio', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Eroe del silenzio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'May day', 'may day', 'may-day', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('May day') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Iron man', 'iron man', 'iron-man', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Iron man') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tossicomane', 'tossicomane', 'tossicomane', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tossicomane') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Jump', 'jump', 'jump', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Jump') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gabibbo', 'gabibbo', 'gabibbo', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gabibbo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cagliostro', 'cagliostro', 'cagliostro', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cagliostro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Demolition girl', 'demolition girl', 'demolition-girl', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Demolition girl') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bunny e Clik', 'bunny e clik', 'bunny-e-clik', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bunny e Clik') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tex', 'tex', 'tex', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tex') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pretty woman', 'pretty woman', 'pretty-woman', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pretty woman') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lecca lecca', 'lecca lecca', 'lecca-lecca', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lecca lecca') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Patriots', 'patriots', 'patriots', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Patriots') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Demolition man', 'demolition man', 'demolition-man', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Demolition man') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cavalier tempesta', 'cavalier tempesta', 'cavalier-tempesta', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cavalier tempesta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Macchia nera', 'macchia nera', 'macchia-nera', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Macchia nera') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Venti dell''est', 'venti dell''est', 'venti-dell-est', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Venti dell''est') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Biberon', 'biberon', 'biberon', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Biberon') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il pensionato', 'il pensionato', 'il-pensionato', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il pensionato') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La valle dell''eco', 'la valle dell''eco', 'la-valle-dell-eco', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La valle dell''eco') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La clava', 'la clava', 'la-clava', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La clava') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Electric people', 'electric people', 'electric-people', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Electric people') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Aftherglow', 'aftherglow', 'aftherglow', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Aftherglow') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La tana del geco', 'la tana del geco', 'la-tana-del-geco', '5b+/5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La tana del geco') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'El perma', 'el perma', 'el-perma', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('El perma') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tempo', 'tempo', 'tempo', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tempo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Variante tempo', 'variante tempo', 'variante-tempo', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Variante tempo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pioggia di luce', 'pioggia di luce', 'pioggia-di-luce', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pioggia di luce') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Trippegghi e Climborazzo', 'trippegghi e climborazzo', 'trippegghi-e-climborazzo', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Trippegghi e Climborazzo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Belfagor', 'belfagor', 'belfagor', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Belfagor') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Scusate i ritardi', 'scusate i ritardi', 'scusate-i-ritardi', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Scusate i ritardi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Over and over', 'over and over', 'over-and-over', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Over and over') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'One undred degrace', 'one undred degrace', 'one-undred-degrace', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('One undred degrace') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Licantropia', 'licantropia', 'licantropia', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Licantropia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cocktail di scarpe', 'cocktail di scarpe', 'cocktail-di-scarpe', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cocktail di scarpe') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il ruggito del laicone', 'il ruggito del laicone', 'il-ruggito-del-laicone', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il ruggito del laicone') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Piange il telefonino', 'piange il telefonino', 'piange-il-telefonino', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Piange il telefonino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Trapanetor', 'trapanetor', 'trapanetor', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Trapanetor') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Grande Allok', 'grande allok', 'grande-allok', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Grande Allok') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Geremia', 'geremia', 'geremia', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Geremia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Via tutta mia', 'via tutta mia', 'via-tutta-mia', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Via tutta mia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Little frog', 'little frog', 'little-frog', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Little frog') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Little frog diretta', 'little frog diretta', 'little-frog-diretta', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Little frog diretta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Come un lupo nella notte', 'come un lupo nella notte', 'come-un-lupo-nella-notte', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Come un lupo nella notte') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Strapiombetti', 'strapiombetti', 'strapiombetti', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Strapiombetti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Diedro rosso', 'diedro rosso', 'diedro-rosso', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Diedro rosso') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spigolo del cactus', 'spigolo del cactus', 'spigolo-del-cactus', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spigolo del cactus') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Diedro di Roberto', 'diedro di roberto', 'diedro-di-roberto', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Diedro di Roberto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Betty blue', 'betty blue', 'betty-blue', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Betty blue') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tracchiellozza', 'tracchiellozza', 'tracchiellozza', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tracchiellozza') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Strapazzami', 'strapazzami', 'strapazzami', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Strapazzami') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Saponette', 'saponette', 'saponette', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Saponette') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sandrokan e i pigrotti della falesia', 'sandrokan e i pigrotti della falesia', 'sandrokan-e-i-pigrotti-della-falesia', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sandrokan e i pigrotti della falesia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Variante', 'variante', 'variante', '5b+/5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Variante') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Infrasettimanale', 'infrasettimanale', 'infrasettimanale', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Infrasettimanale') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Giovani rampolli', 'giovani rampolli', 'giovani-rampolli', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Giovani rampolli') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dolores de panza', 'dolores de panza', 'dolores-de-panza', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dolores de panza') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La pera', 'la pera', 'la-pera', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La pera') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Festa di compleanno', 'festa di compleanno', 'festa-di-compleanno', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Festa di compleanno') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nessuno è perfetto', 'nessuno e perfetto', 'nessuno-e-perfetto', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nessuno è perfetto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'C.C.C.P.', 'c.c.c.p.', 'c-c-c-p', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('C.C.C.P.') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Perchè no?', 'perche no?', 'perche-no', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Perchè no?') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Scout', 'scout', 'scout', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Scout') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Non mas', 'non mas', 'non-mas', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Non mas') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spigolo del congedo', 'spigolo del congedo', 'spigolo-del-congedo', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spigolo del congedo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fess...urrà', 'fess...urra', 'fess-urra', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fess...urrà') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Moda', 'moda', 'moda', '4c+/5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Moda') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sulmo', 'sulmo', 'sulmo', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sulmo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''albero nero', 'l''albero nero', 'l-albero-nero', '4c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''albero nero') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ursus', 'ursus', 'ursus', '5b+/5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ursus') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lobotomy', 'lobotomy', 'lobotomy', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lobotomy') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La puzzola', 'la puzzola', 'la-puzzola', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La puzzola') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il ritorno del barman', 'il ritorno del barman', 'il-ritorno-del-barman', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il ritorno del barman') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Space man', 'space man', 'space-man', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Space man') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Amadeus', 'amadeus', 'amadeus', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Amadeus') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nano nano', 'nano nano', 'nano-nano', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nano nano') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'C''est la vie', 'c''est la vie', 'c-est-la-vie', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('C''est la vie') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Regina della pioggia', 'regina della pioggia', 'regina-della-pioggia', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Regina della pioggia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'No me siento', 'no me siento', 'no-me-siento', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('No me siento') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Time out', 'time out', 'time-out', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Time out') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il fachiro', 'il fachiro', 'il-fachiro', '6a/6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il fachiro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fico d''India', 'fico d''india', 'fico-d-india', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fico d''India') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rigel', 'rigel', 'rigel', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rigel') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mò so cazzi', 'mo so cazzi', 'mo-so-cazzi', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mò so cazzi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Perone', 'perone', 'perone', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Perone') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Melone', 'melone', 'melone', '4a+/4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Melone') AND sector_id = v_sector_id);

  -- ── Configni (Lazio) ──
  SELECT id INTO v_crag_id FROM crags
    WHERE lower(name) = lower('Configni')
      AND region_id = '00000000-0000-0000-0002-000000000007' LIMIT 1;
  IF v_crag_id IS NULL THEN
    -- Also check crags without region_id (from previous imports)
    SELECT id INTO v_crag_id FROM crags
      WHERE lower(name) = lower('Configni') AND region_id IS NULL LIMIT 1;
    IF v_crag_id IS NOT NULL THEN
      UPDATE crags SET region_id = '00000000-0000-0000-0002-000000000007', country_id = '00000000-0000-0000-0001-000000000001',
        region = 'Lazio', province = 'Rieti',
        municipality = NULL
      WHERE id = v_crag_id;
    ELSE
      INSERT INTO crags (name, normalized_name, slug, country, country_id, region, region_id, province, municipality, access_status, rainproof, services, aliases)
      VALUES ('Configni', 'configni', 'configni',
              'Italy', '00000000-0000-0000-0001-000000000001', 'Lazio', '00000000-0000-0000-0002-000000000007',
              'Rieti', NULL, 'open', false, '{}', '{}')
      RETURNING id INTO v_crag_id;
    END IF;
  END IF;

  -- Settore: Placca Rossa
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Placca Rossa') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Placca Rossa', 'placca rossa', 'placca-rossa', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rinascita di Configni', 'rinascita di configni', 'rinascita-di-configni', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rinascita di Configni') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ai Configni della Realtà', 'ai configni della realta', 'ai-configni-della-realta', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ai Configni della Realtà') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'I confini di Configni', 'i confini di configni', 'i-confini-di-configni', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('I confini di Configni') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Wang', 'wang', 'wang', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Wang') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Magica bula', 'magica bula', 'magica-bula', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Magica bula') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'I tozzetti di Anna', 'i tozzetti di anna', 'i-tozzetti-di-anna', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('I tozzetti di Anna') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il calderone celtico', 'il calderone celtico', 'il-calderone-celtico', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il calderone celtico') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Leo Tre Caffè', 'leo tre caffe', 'leo-tre-caffe', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Leo Tre Caffè') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Shamshi', 'shamshi', 'shamshi', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Shamshi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Litodomi', 'litodomi', 'litodomi', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Litodomi') AND sector_id = v_sector_id);

  -- Settore: Settore A
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Settore A') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Settore A', 'settore a', 'settore-a', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cip', 'cip', 'cip', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cip') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ciop', 'ciop', 'ciop', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ciop') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The Eye', 'the eye', 'the-eye', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The Eye') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '1998', '1998', '1998', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('1998') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tettino', 'tettino', 'tettino', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tettino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Arianna', 'arianna', 'arianna', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Arianna') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ale', 'ale', 'ale', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ale') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Brick', 'brick', 'brick', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Brick') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rino', 'rino', 'rino', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il Sole', 'il sole', 'il-sole', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il Sole') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Hot jazz', 'hot jazz', 'hot-jazz', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Hot jazz') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Hard rock', 'hard rock', 'hard-rock', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Hard rock') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Zoom', 'zoom', 'zoom', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Zoom') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Grazie Mario', 'grazie mario', 'grazie-mario', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Grazie Mario') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Alfio', 'alfio', 'alfio', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Alfio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bye bye baby', 'bye bye baby', 'bye-bye-baby', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bye bye baby') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tribolazione', 'tribolazione', 'tribolazione', '5b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tribolazione') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Concoraggio', 'concoraggio', 'concoraggio', '4c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Concoraggio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Disturbata', 'disturbata', 'disturbata', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Disturbata') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Slittony', 'slittony', 'slittony', '6a/6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Slittony') AND sector_id = v_sector_id);

  -- Settore: Settore B
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Settore B') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Settore B', 'settore b', 'settore-b', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Paperino', 'paperino', 'paperino', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Paperino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Qui', 'qui', 'qui', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Qui') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Quo', 'quo', 'quo', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Quo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Qua', 'qua', 'qua', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Qua') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Paperoga', 'paperoga', 'paperoga', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Paperoga') AND sector_id = v_sector_id);

  -- Settore: Settore C
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Settore C') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Settore C', 'settore c', 'settore-c', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Hagrid', 'hagrid', 'hagrid', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Hagrid') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Califano', 'califano', 'califano', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Califano') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Variante sx Il pilastrino', 'variante sx il pilastrino', 'variante-sx-il-pilastrino', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Variante sx Il pilastrino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pilastrino', 'pilastrino', 'pilastrino', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pilastrino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Jambo', 'jambo', 'jambo', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Jambo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''urlo', 'l''urlo', 'l-urlo', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''urlo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cetlen', 'cetlen', 'cetlen', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cetlen') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Le du socere', 'le du socere', 'le-du-socere', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Le du socere') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ra L1', 'ra l1', 'ra-l1', '3a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ra L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ra L2', 'ra l2', 'ra-l2', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ra L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '3m', '3m', '3m', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('3m') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Xiatien L1', 'xiatien l1', 'xiatien-l1', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Xiatien L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Xiatien L2', 'xiatien l2', 'xiatien-l2', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Xiatien L2') AND sector_id = v_sector_id);

  -- Settore: Settore D
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Settore D') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Settore D', 'settore d', 'settore-d', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La giostra di Zazza', 'la giostra di zazza', 'la-giostra-di-zazza', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La giostra di Zazza') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mi faccio il riccio', 'mi faccio il riccio', 'mi-faccio-il-riccio', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mi faccio il riccio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'E adesso basta', 'e adesso basta', 'e-adesso-basta', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('E adesso basta') AND sector_id = v_sector_id);

  -- Settore: Settore E
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Settore E') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Settore E', 'settore e', 'settore-e', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gli accimatori', 'gli accimatori', 'gli-accimatori', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gli accimatori') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il tappezziere ingiallito', 'il tappezziere ingiallito', 'il-tappezziere-ingiallito', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il tappezziere ingiallito') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''isola di Configni', 'l''isola di configni', 'l-isola-di-configni', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''isola di Configni') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La palma di Configni', 'la palma di configni', 'la-palma-di-configni', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La palma di Configni') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Piccoli passi', 'piccoli passi', 'piccoli-passi', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Piccoli passi') AND sector_id = v_sector_id);

  -- Settore: Settore F
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Settore F') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Settore F', 'settore f', 'settore-f', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Configni a 360', 'configni a 360', 'configni-a-360', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Configni a 360') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il prugnolo', 'il prugnolo', 'il-prugnolo', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il prugnolo') AND sector_id = v_sector_id);

  -- ── Grotti (Lazio) ──
  SELECT id INTO v_crag_id FROM crags
    WHERE lower(name) = lower('Grotti')
      AND region_id = '00000000-0000-0000-0002-000000000007' LIMIT 1;
  IF v_crag_id IS NULL THEN
    -- Also check crags without region_id (from previous imports)
    SELECT id INTO v_crag_id FROM crags
      WHERE lower(name) = lower('Grotti') AND region_id IS NULL LIMIT 1;
    IF v_crag_id IS NOT NULL THEN
      UPDATE crags SET region_id = '00000000-0000-0000-0002-000000000007', country_id = '00000000-0000-0000-0001-000000000001',
        region = 'Lazio', province = 'Rieti',
        municipality = 'Cittaducale'
      WHERE id = v_crag_id;
    ELSE
      INSERT INTO crags (name, normalized_name, slug, country, country_id, region, region_id, province, municipality, access_status, rainproof, services, aliases)
      VALUES ('Grotti', 'grotti', 'grotti',
              'Italy', '00000000-0000-0000-0001-000000000001', 'Lazio', '00000000-0000-0000-0002-000000000007',
              'Rieti', 'Cittaducale', 'open', false, '{}', '{}')
      RETURNING id INTO v_crag_id;
    END IF;
  END IF;

  -- Settore: Grotti Bassa - Nuovo Settore
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Grotti Bassa - Nuovo Settore') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Grotti Bassa - Nuovo Settore', 'grotti bassa - nuovo settore', 'grotti-bassa-nuovo-settore', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ferite', 'ferite', 'ferite', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ferite') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tagli', 'tagli', 'tagli', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tagli') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Contusioni', 'contusioni', 'contusioni', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Contusioni') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il vena', 'il vena', 'il-vena', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il vena') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Batman', 'batman', 'batman', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Batman') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''ombra del bastone', 'l''ombra del bastone', 'l-ombra-del-bastone', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''ombra del bastone') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il mollicone', 'il mollicone', 'il-mollicone', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il mollicone') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mago supremo', 'mago supremo', 'mago-supremo', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mago supremo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La froceria', 'la froceria', 'la-froceria', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La froceria') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Le return de Frank', 'le return de frank', 'le-return-de-frank', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Le return de Frank') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Zio Gianguido', 'zio gianguido', 'zio-gianguido', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Zio Gianguido') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'A piede libero', 'a piede libero', 'a-piede-libero', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('A piede libero') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Alfredo Alfredo', 'alfredo alfredo', 'alfredo-alfredo', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Alfredo Alfredo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Paura', 'paura', 'paura', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Paura') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Labinia', 'labinia', 'labinia', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Labinia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mission', 'mission', 'mission', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mission') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Valla a falla', 'valla a falla', 'valla-a-falla', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Valla a falla') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Allegria', 'allegria', 'allegria', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Allegria') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Scaccolone', 'scaccolone', 'scaccolone', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Scaccolone') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gli invidiosi', 'gli invidiosi', 'gli-invidiosi', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gli invidiosi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'S.O.S', 's.o.s', 's-o-s', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('S.O.S') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il Pippone', 'il pippone', 'il-pippone', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il Pippone') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ritornerai', 'ritornerai', 'ritornerai', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ritornerai') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il Droga', 'il droga', 'il-droga', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il Droga') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Che schifo', 'che schifo', 'che-schifo', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Che schifo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rosa sativa', 'rosa sativa', 'rosa-sativa', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rosa sativa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ritorno', 'ritorno', 'ritorno', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ritorno') AND sector_id = v_sector_id);

  -- ── La Fortezza (Lazio) ──
  SELECT id INTO v_crag_id FROM crags
    WHERE lower(name) = lower('La Fortezza')
      AND region_id = '00000000-0000-0000-0002-000000000007' LIMIT 1;
  IF v_crag_id IS NULL THEN
    -- Also check crags without region_id (from previous imports)
    SELECT id INTO v_crag_id FROM crags
      WHERE lower(name) = lower('La Fortezza') AND region_id IS NULL LIMIT 1;
    IF v_crag_id IS NOT NULL THEN
      UPDATE crags SET region_id = '00000000-0000-0000-0002-000000000007', country_id = '00000000-0000-0000-0001-000000000001',
        region = 'Lazio', province = 'Rieti',
        municipality = NULL
      WHERE id = v_crag_id;
    ELSE
      INSERT INTO crags (name, normalized_name, slug, country, country_id, region, region_id, province, municipality, access_status, rainproof, services, aliases)
      VALUES ('La Fortezza', 'la fortezza', 'la-fortezza',
              'Italy', '00000000-0000-0000-0001-000000000001', 'Lazio', '00000000-0000-0000-0002-000000000007',
              'Rieti', NULL, 'open', false, '{}', '{}')
      RETURNING id INTO v_crag_id;
    END IF;
  END IF;

  -- Settore: La Fortezza
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('La Fortezza') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('La Fortezza', 'la fortezza', 'la-fortezza', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Avanguardia', 'avanguardia', 'avanguardia', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Avanguardia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La Giggiata', 'la giggiata', 'la-giggiata', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La Giggiata') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cos''è facile', 'cos''e facile', 'cos-e-facile', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cos''è facile') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Piramid', 'piramid', 'piramid', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Piramid') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La normale', 'la normale', 'la-normale', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La normale') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '...abu', '...abu', 'abu', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('...abu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'BaaB L1', 'baab l1', 'baab-l1', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('BaaB L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'BaaB L2', 'baab l2', 'baab-l2', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('BaaB L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Zahma', 'zahma', 'zahma', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Zahma') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Albedo', 'albedo', 'albedo', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Albedo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nigredo', 'nigredo', 'nigredo', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nigredo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La prostata', 'la prostata', 'la-prostata', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La prostata') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The little flower', 'the little flower', 'the-little-flower', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The little flower') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cucciolo', 'cucciolo', 'cucciolo', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cucciolo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La valle del 2000', 'la valle del 2000', 'la-valle-del-2000', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La valle del 2000') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sogno Lucido', 'sogno lucido', 'sogno-lucido', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sogno Lucido') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Observe', 'observe', 'observe', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Observe') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Attrazione', 'attrazione', 'attrazione', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Attrazione') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Jumpe', 'jumpe', 'jumpe', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Jumpe') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ascoltati', 'ascoltati', 'ascoltati', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ascoltati') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fuori dai pendoli', 'fuori dai pendoli', 'fuori-dai-pendoli', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fuori dai pendoli') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'So what', 'so what', 'so-what', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('So what') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Calvi Klimb', 'calvi klimb', 'calvi-klimb', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Calvi Klimb') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '37 secondi', '37 secondi', '37-secondi', '7c+/8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('37 secondi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mente', 'mente', 'mente', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mente') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Corpo', 'corpo', 'corpo', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Corpo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Maya', 'maya', 'maya', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Maya') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Grazie', 'grazie', 'grazie', '8b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Grazie') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Inerzia', 'inerzia', 'inerzia', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Inerzia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Idiocrazia', 'idiocrazia', 'idiocrazia', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Idiocrazia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The bra', 'the bra', 'the-bra', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The bra') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The get down', 'the get down', 'the-get-down', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The get down') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'White rabbit', 'white rabbit', 'white-rabbit', '8c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('White rabbit') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'RCC', 'rcc', 'rcc', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('RCC') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ipocrisia', 'ipocrisia', 'ipocrisia', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ipocrisia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 2', 'senza nome 2', 'senza-nome-2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dopo dopo pure tu', 'dopo dopo pure tu', 'dopo-dopo-pure-tu', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dopo dopo pure tu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cagliostro', 'cagliostro', 'cagliostro', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cagliostro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Deleta resurgo', 'deleta resurgo', 'deleta-resurgo', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Deleta resurgo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Quantico', 'quantico', 'quantico', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Quantico') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lo specchio', 'lo specchio', 'lo-specchio', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lo specchio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tutimenti', 'tutimenti', 'tutimenti', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tutimenti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sinfonia d''autunno', 'sinfonia d''autunno', 'sinfonia-d-autunno', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sinfonia d''autunno') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Adamo', 'adamo', 'adamo', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Adamo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Schizzechea with love', 'schizzechea with love', 'schizzechea-with-love', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Schizzechea with love') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 3', 'senza nome 3', 'senza-nome-3', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Esegesi', 'esegesi', 'esegesi', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Esegesi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il frutto della conoscenza', 'il frutto della conoscenza', 'il-frutto-della-conoscenza', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il frutto della conoscenza') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Le scelte', 'le scelte', 'le-scelte', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Le scelte') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Negli occhi', 'negli occhi', 'negli-occhi', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Negli occhi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tune up', 'tune up', 'tune-up', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tune up') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bitches brew', 'bitches brew', 'bitches-brew', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bitches brew') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Alertez les bébés', 'alertez les bebes', 'alertez-les-bebes', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Alertez les bébés') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cyborg, metà uomo e metà bidito artificiale', 'cyborg, meta uomo e meta bidito artificiale', 'cyborg-meta-uomo-e-meta-bidito-artificiale', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cyborg, metà uomo e metà bidito artificiale') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ghost in the Shell', 'ghost in the shell', 'ghost-in-the-shell', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ghost in the Shell') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Aia', 'aia', 'aia', '8b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Aia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Thor', 'thor', 'thor', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Thor') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tengo Famiglia', 'tengo famiglia', 'tengo-famiglia', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tengo Famiglia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Come mi pare', 'come mi pare', 'come-mi-pare', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Come mi pare') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Io posso entrare', 'io posso entrare', 'io-posso-entrare', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Io posso entrare') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Meritocrazia', 'meritocrazia', 'meritocrazia', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Meritocrazia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La montagna è cultura', 'la montagna e cultura', 'la-montagna-e-cultura', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La montagna è cultura') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Medioman', 'medioman', 'medioman', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Medioman') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tangente', 'tangente', 'tangente', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tangente') AND sector_id = v_sector_id);

  -- ── Ripa Majala (Lazio) ──
  SELECT id INTO v_crag_id FROM crags
    WHERE lower(name) = lower('Ripa Majala')
      AND region_id = '00000000-0000-0000-0002-000000000007' LIMIT 1;
  IF v_crag_id IS NULL THEN
    -- Also check crags without region_id (from previous imports)
    SELECT id INTO v_crag_id FROM crags
      WHERE lower(name) = lower('Ripa Majala') AND region_id IS NULL LIMIT 1;
    IF v_crag_id IS NOT NULL THEN
      UPDATE crags SET region_id = '00000000-0000-0000-0002-000000000007', country_id = '00000000-0000-0000-0001-000000000001',
        region = 'Lazio', province = 'Roma',
        municipality = 'Allumiere'
      WHERE id = v_crag_id;
    ELSE
      INSERT INTO crags (name, normalized_name, slug, country, country_id, region, region_id, province, municipality, access_status, rainproof, services, aliases)
      VALUES ('Ripa Majala', 'ripa majala', 'ripa-majala',
              'Italy', '00000000-0000-0000-0001-000000000001', 'Lazio', '00000000-0000-0000-0002-000000000007',
              'Roma', 'Allumiere', 'open', false, '{}', '{}')
      RETURNING id INTO v_crag_id;
    END IF;
  END IF;

  -- Settore: Settore Principale
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Settore Principale') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Settore Principale', 'settore principale', 'settore-principale', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mastica zi', 'mastica zi', 'mastica-zi', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mastica zi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Alta marea', 'alta marea', 'alta-marea', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Alta marea') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gioia e rivoluzione', 'gioia e rivoluzione', 'gioia-e-rivoluzione', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gioia e rivoluzione') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mamma li turchi', 'mamma li turchi', 'mamma-li-turchi', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mamma li turchi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Acqua azzurra', 'acqua azzurra', 'acqua-azzurra', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Acqua azzurra') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Maremma maiala', 'maremma maiala', 'maremma-maiala', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Maremma maiala') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Passalento', 'passalento', 'passalento', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Passalento') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'San soufflè', 'san souffle', 'san-souffle', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('San soufflè') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Passaveloce', 'passaveloce', 'passaveloce', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Passaveloce') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La pallina di Lina', 'la pallina di lina', 'la-pallina-di-lina', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La pallina di Lina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Variante de Alla larga i farisei', 'variante de alla larga i farisei', 'variante-de-alla-larga-i-farisei', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Variante de Alla larga i farisei') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Alla larga i farisei', 'alla larga i farisei', 'alla-larga-i-farisei', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Alla larga i farisei') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Polemika', 'polemika', 'polemika', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Polemika') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ore perse', 'ore perse', 'ore-perse', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ore perse') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Civitavecchia verticale', 'civitavecchia verticale', 'civitavecchia-verticale', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Civitavecchia verticale') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il raglio del somaro', 'il raglio del somaro', 'il-raglio-del-somaro', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il raglio del somaro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Necrosi muscolare', 'necrosi muscolare', 'necrosi-muscolare', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Necrosi muscolare') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lo scudo di Avalon', 'lo scudo di avalon', 'lo-scudo-di-avalon', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lo scudo di Avalon') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'DiscantoMediterraneo', 'discantomediterraneo', 'discantomediterraneo', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('DiscantoMediterraneo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mediterranea L1', 'mediterranea l1', 'mediterranea-l1', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mediterranea L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mediterranea L1 + L2', 'mediterranea l1 + l2', 'mediterranea-l1-l2', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mediterranea L1 + L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Falce e martello', 'falce e martello', 'falce-e-martello', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Falce e martello') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Potere operaio', 'potere operaio', 'potere-operaio', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Potere operaio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lotta continua L1', 'lotta continua l1', 'lotta-continua-l1', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lotta continua L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lotta continua L1+L2', 'lotta continua l1+l2', 'lotta-continua-l1-l2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lotta continua L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sinistra antagonista', 'sinistra antagonista', 'sinistra-antagonista', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sinistra antagonista') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Siegfried L1', 'siegfried l1', 'siegfried-l1', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Siegfried L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Siegfried L2', 'siegfried l2', 'siegfried-l2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Siegfried L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Morte all''imperialismo mondiale', 'morte all''imperialismo mondiale', 'morte-all-imperialismo-mondiale', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Morte all''imperialismo mondiale') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''ora d''aria', 'l''ora d''aria', 'l-ora-d-aria', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''ora d''aria') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Solo per gente di mare', 'solo per gente di mare', 'solo-per-gente-di-mare', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Solo per gente di mare') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nonno santo', 'nonno santo', 'nonno-santo', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nonno santo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Legalizzatela L1', 'legalizzatela l1', 'legalizzatela-l1', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Legalizzatela L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Var. Dose media giornaliera', 'var. dose media giornaliera', 'var-dose-media-giornaliera', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Var. Dose media giornaliera') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dose media giornaliera L1', 'dose media giornaliera l1', 'dose-media-giornaliera-l1', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dose media giornaliera L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dose media giornaliera L2', 'dose media giornaliera l2', 'dose-media-giornaliera-l2', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dose media giornaliera L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Coffee break', 'coffee break', 'coffee-break', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Coffee break') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Variante tossica', 'variante tossica', 'variante-tossica', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Variante tossica') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Modica quantità L1', 'modica quantita l1', 'modica-quantita-l1', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Modica quantità L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il velo di Maia L2', 'il velo di maia l2', 'il-velo-di-maia-l2', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il velo di Maia L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Brilligiù L2', 'brilligiu l2', 'brilligiu-l2', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Brilligiù L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Wadi Rum L2', 'wadi rum l2', 'wadi-rum-l2', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Wadi Rum L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La dama del lago L2', 'la dama del lago l2', 'la-dama-del-lago-l2', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La dama del lago L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Metropolis L2', 'metropolis l2', 'metropolis-l2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Metropolis L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mezza sega L2', 'mezza sega l2', 'mezza-sega-l2', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mezza sega L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gola profonda L2', 'gola profonda l2', 'gola-profonda-l2', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gola profonda L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Istigazione a delinquere L2', 'istigazione a delinquere l2', 'istigazione-a-delinquere-l2', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Istigazione a delinquere L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La pagherete cara la pagherete tutti L2', 'la pagherete cara la pagherete tutti l2', 'la-pagherete-cara-la-pagherete-tutti-l2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La pagherete cara la pagherete tutti L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Io sono il vento L2', 'io sono il vento l2', 'io-sono-il-vento-l2', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Io sono il vento L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Microcriminalità', 'microcriminalita', 'microcriminalita', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Microcriminalità') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ca z o', 'ca z o', 'ca-z-o', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ca z o') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Boh!', 'boh!', 'boh', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Boh!') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Se la conosci la eviti', 'se la conosci la eviti', 'se-la-conosci-la-eviti', '5b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Se la conosci la eviti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fax totum', 'fax totum', 'fax-totum', '5a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fax totum') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fra la via Aurelia ed il West', 'fra la via aurelia ed il west', 'fra-la-via-aurelia-ed-il-west', '5b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fra la via Aurelia ed il West') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mezza sega', 'mezza sega', 'mezza-sega', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mezza sega') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Re.Le.', 're.le.', 're-le', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Re.Le.') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Foxtrot', 'foxtrot', 'foxtrot', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Foxtrot') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lo zighero', 'lo zighero', 'lo-zighero', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lo zighero') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La Ciociara volante', 'la ciociara volante', 'la-ciociara-volante', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La Ciociara volante') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La Cia ci spia', 'la cia ci spia', 'la-cia-ci-spia', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La Cia ci spia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La zighera L1', 'la zighera l1', 'la-zighera-l1', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La zighera L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La zighera L2', 'la zighera l2', 'la-zighera-l2', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La zighera L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Eskimo', 'eskimo', 'eskimo', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Eskimo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il migliore', 'il migliore', 'il-migliore', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il migliore') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dolores de panzas', 'dolores de panzas', 'dolores-de-panzas', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dolores de panzas') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Manipolazione genetica', 'manipolazione genetica', 'manipolazione-genetica', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Manipolazione genetica') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Porci con le ali', 'porci con le ali', 'porci-con-le-ali', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Porci con le ali') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Amico fragile', 'amico fragile', 'amico-fragile', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Amico fragile') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Maiale incontinente', 'maiale incontinente', 'maiale-incontinente', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Maiale incontinente') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La normale', 'la normale', 'la-normale', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La normale') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Diavoli al culo L2', 'diavoli al culo l2', 'diavoli-al-culo-l2', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Diavoli al culo L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La spinosa', 'la spinosa', 'la-spinosa', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La spinosa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Variante La spinosa', 'variante la spinosa', 'variante-la-spinosa', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Variante La spinosa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vitto e alloggio', 'vitto e alloggio', 'vitto-e-alloggio', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vitto e alloggio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Soviet supremo', 'soviet supremo', 'soviet-supremo', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Soviet supremo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Comitato centrale', 'comitato centrale', 'comitato-centrale', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Comitato centrale') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'G.A.C.', 'g.a.c.', 'g-a-c', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('G.A.C.') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Hermes', 'hermes', 'hermes', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Hermes') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ostpolitk', 'ostpolitk', 'ostpolitk', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ostpolitk') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ostpolitik variante dx', 'ostpolitik variante dx', 'ostpolitik-variante-dx', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ostpolitik variante dx') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ripa libera', 'ripa libera', 'ripa-libera', '4c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ripa libera') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Socialismo reale', 'socialismo reale', 'socialismo-reale', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Socialismo reale') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La lunga marcia', 'la lunga marcia', 'la-lunga-marcia', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La lunga marcia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pista Ho Chi Minh', 'pista ho chi minh', 'pista-ho-chi-minh', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pista Ho Chi Minh') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il baratro L2', 'il baratro l2', 'il-baratro-l2', '5b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il baratro L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il rosso e il nero L2', 'il rosso e il nero l2', 'il-rosso-e-il-nero-l2', '5b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il rosso e il nero L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tg 0 L2', 'tg 0 l2', 'tg-0-l2', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tg 0 L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Samarcanda L2', 'samarcanda l2', 'samarcanda-l2', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Samarcanda L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Truffa truffa ambiguità L2', 'truffa truffa ambiguita l2', 'truffa-truffa-ambiguita-l2', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Truffa truffa ambiguità L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mi manda Lubrano L2', 'mi manda lubrano l2', 'mi-manda-lubrano-l2', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mi manda Lubrano L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cazzarola L2', 'cazzarola l2', 'cazzarola-l2', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cazzarola L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sole nero L2', 'sole nero l2', 'sole-nero-l2', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sole nero L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rapsodia in rosso L2', 'rapsodia in rosso l2', 'rapsodia-in-rosso-l2', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rapsodia in rosso L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tempi bui L2', 'tempi bui l2', 'tempi-bui-l2', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tempi bui L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Grilletto di Dio L2', 'grilletto di dio l2', 'grilletto-di-dio-l2', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Grilletto di Dio L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fidel L2', 'fidel l2', 'fidel-l2', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fidel L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sendero luminoso', 'sendero luminoso', 'sendero-luminoso', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sendero luminoso') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Var. Sendero luminoso', 'var. sendero luminoso', 'var-sendero-luminoso', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Var. Sendero luminoso') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tupak amaros', 'tupak amaros', 'tupak-amaros', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tupak amaros') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Variante Tupak amaros', 'variante tupak amaros', 'variante-tupak-amaros', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Variante Tupak amaros') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Via di 1/2', 'via di 1/2', 'via-di-1-2', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Via di 1/2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nannolino cerca l''acqua', 'nannolino cerca l''acqua', 'nannolino-cerca-l-acqua', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nannolino cerca l''acqua') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Culo di gomma', 'culo di gomma', 'culo-di-gomma', '5b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Culo di gomma') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ottobre rosso', 'ottobre rosso', 'ottobre-rosso', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ottobre rosso') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Regina della notte', 'regina della notte', 'regina-della-notte', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Regina della notte') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Un grammo di paura', 'un grammo di paura', 'un-grammo-di-paura', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Un grammo di paura') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pugni chiusi', 'pugni chiusi', 'pugni-chiusi', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pugni chiusi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nati in cattività', 'nati in cattivita', 'nati-in-cattivita', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nati in cattività') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Anni di piombo', 'anni di piombo', 'anni-di-piombo', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Anni di piombo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ani di Piombo (Variante Anni di piombo)', 'ani di piombo (variante anni di piombo)', 'ani-di-piombo-variante-anni-di-piombo', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ani di Piombo (Variante Anni di piombo)') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il cerchio nella roccia', 'il cerchio nella roccia', 'il-cerchio-nella-roccia', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il cerchio nella roccia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Male oscuro', 'male oscuro', 'male-oscuro', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Male oscuro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ekkecazzo', 'ekkecazzo', 'ekkecazzo', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ekkecazzo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Variante Giancola', 'variante giancola', 'variante-giancola', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Variante Giancola') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Diserta il deserto', 'diserta il deserto', 'diserta-il-deserto', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Diserta il deserto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rote Armee Fraktion', 'rote armee fraktion', 'rote-armee-fraktion', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rote Armee Fraktion') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Balloancora', 'balloancora', 'balloancora', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Balloancora') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il mestiere di vivere', 'il mestiere di vivere', 'il-mestiere-di-vivere', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il mestiere di vivere') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nulla', 'nulla', 'nulla', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nulla') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spiritosa', 'spiritosa', 'spiritosa', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spiritosa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Capelli bianchi', 'capelli bianchi', 'capelli-bianchi', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Capelli bianchi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il tempo è tiranno', 'il tempo e tiranno', 'il-tempo-e-tiranno', '4c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il tempo è tiranno') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senilità', 'senilita', 'senilita', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senilità') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Via della terza età', 'via della terza eta', 'via-della-terza-eta', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Via della terza età') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Polli di allevamento', 'polli di allevamento', 'polli-di-allevamento', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Polli di allevamento') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mea culpa', 'mea culpa', 'mea-culpa', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mea culpa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ecce bombo', 'ecce bombo', 'ecce-bombo', '5b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ecce bombo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Montagna ladra', 'montagna ladra', 'montagna-ladra', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Montagna ladra') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Allegro ma non troppo', 'allegro ma non troppo', 'allegro-ma-non-troppo', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Allegro ma non troppo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Variante tazbau', 'variante tazbau', 'variante-tazbau', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Variante tazbau') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Meco Joni', 'meco joni', 'meco-joni', '4c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Meco Joni') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il Manifesto', 'il manifesto', 'il-manifesto', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il Manifesto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vita a colori', 'vita a colori', 'vita-a-colori', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vita a colori') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Come un ramarro', 'come un ramarro', 'come-un-ramarro', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Come un ramarro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Non sono stato io', 'non sono stato io', 'non-sono-stato-io', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Non sono stato io') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spigolando', 'spigolando', 'spigolando', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spigolando') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pio 6 1 dio', 'pio 6 1 dio', 'pio-6-1-dio', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pio 6 1 dio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '1960/2010', '1960/2010', '1960-2010', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('1960/2010') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La placca di Marco', 'la placca di marco', 'la-placca-di-marco', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La placca di Marco') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fessura', 'fessura', 'fessura', '4c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fessura') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Diedro dei 3 gechi', 'diedro dei 3 gechi', 'diedro-dei-3-gechi', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Diedro dei 3 gechi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Diedrino di dx', 'diedrino di dx', 'diedrino-di-dx', '4c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Diedrino di dx') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vecchi e vecchioni', 'vecchi e vecchioni', 'vecchi-e-vecchioni', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vecchi e vecchioni') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lo scherzetto', 'lo scherzetto', 'lo-scherzetto', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lo scherzetto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Le due fessure', 'le due fessure', 'le-due-fessure', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Le due fessure') AND sector_id = v_sector_id);

  -- Settore: Settore Secondario
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Settore Secondario') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Settore Secondario', 'settore secondario', 'settore-secondario', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Facile è bello', 'facile e bello', 'facile-e-bello', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Facile è bello') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il vecchio che avanza', 'il vecchio che avanza', 'il-vecchio-che-avanza', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il vecchio che avanza') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La cucina di Marina', 'la cucina di marina', 'la-cucina-di-marina', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La cucina di Marina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Le ricette di Marina', 'le ricette di marina', 'le-ricette-di-marina', '4c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Le ricette di Marina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Crick e Crock', 'crick e crock', 'crick-e-crock', '4c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Crick e Crock') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Alicetta forever', 'alicetta forever', 'alicetta-forever', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Alicetta forever') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Barman e Robin', 'barman e robin', 'barman-e-robin', '5a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Barman e Robin') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ragazzo di Calabria', 'ragazzo di calabria', 'ragazzo-di-calabria', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ragazzo di Calabria') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Specchio al sole', 'specchio al sole', 'specchio-al-sole', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Specchio al sole') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nonni folli', 'nonni folli', 'nonni-folli', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nonni folli') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pio amore mio', 'pio amore mio', 'pio-amore-mio', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pio amore mio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ultimo sole', 'ultimo sole', 'ultimo-sole', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ultimo sole') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il ruggito del coniglio', 'il ruggito del coniglio', 'il-ruggito-del-coniglio', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il ruggito del coniglio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Occhio al nodo', 'occhio al nodo', 'occhio-al-nodo', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Occhio al nodo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La pera amara', 'la pera amara', 'la-pera-amara', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La pera amara') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Teo dove sei? (variante d''attacco)', 'teo dove sei? (variante d''attacco)', 'teo-dove-sei-variante-d-attacco', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Teo dove sei? (variante d''attacco)') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Teo dove sei?', 'teo dove sei?', 'teo-dove-sei', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Teo dove sei?') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lichene a gogo', 'lichene a gogo', 'lichene-a-gogo', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lichene a gogo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il geco ci guarda', 'il geco ci guarda', 'il-geco-ci-guarda', '4c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il geco ci guarda') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Via la folla', 'via la folla', 'via-la-folla', '5b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Via la folla') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tettino dello speziale', 'tettino dello speziale', 'tettino-dello-speziale', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tettino dello speziale') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il pilastrino giallo', 'il pilastrino giallo', 'il-pilastrino-giallo', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il pilastrino giallo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Diedro di Roberto', 'diedro di roberto', 'diedro-di-roberto', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Diedro di Roberto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il muschio selvaggio', 'il muschio selvaggio', 'il-muschio-selvaggio', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il muschio selvaggio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spigolo di Roberto', 'spigolo di roberto', 'spigolo-di-roberto', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spigolo di Roberto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il buco malefico', 'il buco malefico', 'il-buco-malefico', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il buco malefico') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fatti e misfatti', 'fatti e misfatti', 'fatti-e-misfatti', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fatti e misfatti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il moschettone rubato', 'il moschettone rubato', 'il-moschettone-rubato', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il moschettone rubato') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La spinosa', 'la spinosa', 'la-spinosa', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La spinosa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fessurina', 'fessurina', 'fessurina', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fessurina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ritorno di Gabri', 'ritorno di gabri', 'ritorno-di-gabri', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ritorno di Gabri') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La bomba', 'la bomba', 'la-bomba', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La bomba') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Grotta', 'grotta', 'grotta', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Grotta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 2', 'senza nome 2', 'senza-nome-2', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id);

  -- ── Colle dell'Orso (Molise) ──
  SELECT id INTO v_crag_id FROM crags
    WHERE lower(name) = lower('Colle dell''Orso')
      AND region_id = '00000000-0000-0000-0002-000000000011' LIMIT 1;
  IF v_crag_id IS NULL THEN
    -- Also check crags without region_id (from previous imports)
    SELECT id INTO v_crag_id FROM crags
      WHERE lower(name) = lower('Colle dell''Orso') AND region_id IS NULL LIMIT 1;
    IF v_crag_id IS NOT NULL THEN
      UPDATE crags SET region_id = '00000000-0000-0000-0002-000000000011', country_id = '00000000-0000-0000-0001-000000000001',
        region = 'Molise', province = 'Isernia',
        municipality = 'Frosolone'
      WHERE id = v_crag_id;
    ELSE
      INSERT INTO crags (name, normalized_name, slug, country, country_id, region, region_id, province, municipality, access_status, rainproof, services, aliases)
      VALUES ('Colle dell''Orso', 'colle dell''orso', 'colle-dell-orso',
              'Italy', '00000000-0000-0000-0001-000000000001', 'Molise', '00000000-0000-0000-0002-000000000011',
              'Isernia', 'Frosolone', 'open', false, '{}', '{}')
      RETURNING id INTO v_crag_id;
    END IF;
  END IF;

  -- Settore: Blocco P
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Blocco P') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Blocco P', 'blocco p', 'blocco-p', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Solina', 'solina', 'solina', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Solina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Soletta', 'soletta', 'soletta', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Soletta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Er Macina', 'er macina', 'er-macina', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Er Macina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Le poissons sur le visage', 'le poissons sur le visage', 'le-poissons-sur-le-visage', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Le poissons sur le visage') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Patty', 'patty', 'patty', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Patty') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Chato', 'chato', 'chato', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Chato') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Patata bollente', 'patata bollente', 'patata-bollente', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Patata bollente') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Falsi miti', 'falsi miti', 'falsi-miti', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Falsi miti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Socrate', 'socrate', 'socrate', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Socrate') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il punto oscuro', 'il punto oscuro', 'il-punto-oscuro', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il punto oscuro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il lato oscuro', 'il lato oscuro', 'il-lato-oscuro', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il lato oscuro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Schizofrenia', 'schizofrenia', 'schizofrenia', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Schizofrenia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Queimada (variante)', 'queimada (variante)', 'queimada-variante', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Queimada (variante)') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Queimada', 'queimada', 'queimada', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Queimada') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fagian Club', 'fagian club', 'fagian-club', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fagian Club') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Birra e patatine', 'birra e patatine', 'birra-e-patatine', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Birra e patatine') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Flesh for fantasy', 'flesh for fantasy', 'flesh-for-fantasy', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Flesh for fantasy') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il tango si balla in due', 'il tango si balla in due', 'il-tango-si-balla-in-due', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il tango si balla in due') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Olive fritte L1', 'olive fritte l1', 'olive-fritte-l1', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Olive fritte L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Olive fritte L2', 'olive fritte l2', 'olive-fritte-l2', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Olive fritte L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pantera nera (Latte e caffe'')', 'pantera nera (latte e caffe'')', 'pantera-nera-latte-e-caffe', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pantera nera (Latte e caffe'')') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cardine sinistro', 'cardine sinistro', 'cardine-sinistro', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cardine sinistro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Oltre il cancello', 'oltre il cancello', 'oltre-il-cancello', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Oltre il cancello') AND sector_id = v_sector_id);

  -- Settore: Blocco Q
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Blocco Q') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Blocco Q', 'blocco q', 'blocco-q', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Chicchi live', 'chicchi live', 'chicchi-live', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Chicchi live') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cardine destro', 'cardine destro', 'cardine-destro', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cardine destro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Charriba', 'charriba', 'charriba', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Charriba') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 2', 'senza nome 2', 'senza-nome-2', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lo scazzo', 'lo scazzo', 'lo-scazzo', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lo scazzo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ciao Tito', 'ciao tito', 'ciao-tito', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ciao Tito') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The wall of woodoo', 'the wall of woodoo', 'the-wall-of-woodoo', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The wall of woodoo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 3', 'senza nome 3', 'senza-nome-3', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rapidoil', 'rapidoil', 'rapidoil', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rapidoil') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Verminsugo', 'verminsugo', 'verminsugo', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Verminsugo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pulcinella', 'pulcinella', 'pulcinella', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pulcinella') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Morgialiscia', 'morgialiscia', 'morgialiscia', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Morgialiscia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Stasera mangio tanto lo dico e lo faccio', 'stasera mangio tanto lo dico e lo faccio', 'stasera-mangio-tanto-lo-dico-e-lo-faccio', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Stasera mangio tanto lo dico e lo faccio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La roccia di Marco', 'la roccia di marco', 'la-roccia-di-marco', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La roccia di Marco') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La via di Marco', 'la via di marco', 'la-via-di-marco', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La via di Marco') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La via di Marco (variante)', 'la via di marco (variante)', 'la-via-di-marco-variante', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La via di Marco (variante)') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Seek and destroy', 'seek and destroy', 'seek-and-destroy', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Seek and destroy') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Padre Luciano', 'padre luciano', 'padre-luciano', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Padre Luciano') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Abbi dubbi', 'abbi dubbi', 'abbi-dubbi', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Abbi dubbi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Luigi coi blue jeans', 'luigi coi blue jeans', 'luigi-coi-blue-jeans', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Luigi coi blue jeans') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dalle picche al costume', 'dalle picche al costume', 'dalle-picche-al-costume', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dalle picche al costume') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Via Crucis', 'via crucis', 'via-crucis', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Via Crucis') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Irriverenza', 'irriverenza', 'irriverenza', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Irriverenza') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mister Pink', 'mister pink', 'mister-pink', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mister Pink') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Isolation', 'isolation', 'isolation', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Isolation') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nomadi', 'nomadi', 'nomadi', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nomadi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sploosh', 'sploosh', 'sploosh', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sploosh') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Poiana', 'poiana', 'poiana', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Poiana') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cerimonia', 'cerimonia', 'cerimonia', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cerimonia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''animale', 'l''animale', 'l-animale', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''animale') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Inox', 'inox', 'inox', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Inox') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Afroclonck', 'afroclonck', 'afroclonck', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Afroclonck') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Poldo', 'poldo', 'poldo', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Poldo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il folletto delle morge', 'il folletto delle morge', 'il-folletto-delle-morge', '4c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il folletto delle morge') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Supercrack', 'supercrack', 'supercrack', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Supercrack') AND sector_id = v_sector_id);

  -- ── Ulassai (Sardegna) ──
  SELECT id INTO v_crag_id FROM crags
    WHERE lower(name) = lower('Ulassai')
      AND region_id = '00000000-0000-0000-0002-000000000014' LIMIT 1;
  IF v_crag_id IS NULL THEN
    -- Also check crags without region_id (from previous imports)
    SELECT id INTO v_crag_id FROM crags
      WHERE lower(name) = lower('Ulassai') AND region_id IS NULL LIMIT 1;
    IF v_crag_id IS NOT NULL THEN
      UPDATE crags SET region_id = '00000000-0000-0000-0002-000000000014', country_id = '00000000-0000-0000-0001-000000000001',
        region = 'Sardegna', province = 'Nuoro',
        municipality = NULL
      WHERE id = v_crag_id;
    ELSE
      INSERT INTO crags (name, normalized_name, slug, country, country_id, region, region_id, province, municipality, access_status, rainproof, services, aliases)
      VALUES ('Ulassai', 'ulassai', 'ulassai',
              'Italy', '00000000-0000-0000-0001-000000000001', 'Sardegna', '00000000-0000-0000-0002-000000000014',
              'Nuoro', NULL, 'open', false, '{}', '{}')
      RETURNING id INTO v_crag_id;
    END IF;
  END IF;

  -- Settore: Baccili
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Baccili') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Baccili', 'baccili', 'baccili', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ganesh', 'ganesh', 'ganesh', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ganesh') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ganesh L1+L2', 'ganesh l1+l2', 'ganesh-l1-l2', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ganesh L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Left behind', 'left behind', 'left-behind', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Left behind') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Right behind', 'right behind', 'right-behind', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Right behind') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Discworld', 'discworld', 'discworld', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Discworld') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Takatsuki', 'takatsuki', 'takatsuki', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Takatsuki') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lilac', 'lilac', 'lilac', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lilac') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '1312', '1312', '1312', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('1312') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Insanity', 'insanity', 'insanity', '8c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Insanity') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Profanity', 'profanity', 'profanity', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Profanity') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ciao Bella', 'ciao bella', 'ciao-bella', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ciao Bella') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cannonau', 'cannonau', 'cannonau', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cannonau') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Crack my bitch up L1', 'crack my bitch up l1', 'crack-my-bitch-up-l1', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Crack my bitch up L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Crack my bitch up L2', 'crack my bitch up l2', 'crack-my-bitch-up-l2', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Crack my bitch up L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Twisted fire cracker', 'twisted fire cracker', 'twisted-fire-cracker', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Twisted fire cracker') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Goldilocks', 'goldilocks', 'goldilocks', '8c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Goldilocks') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Grand Cru', 'grand cru', 'grand-cru', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Grand Cru') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '4 orsi bagnati', '4 orsi bagnati', '4-orsi-bagnati', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('4 orsi bagnati') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'So you think you can yoga', 'so you think you can yoga', 'so-you-think-you-can-yoga', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('So you think you can yoga') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gonzo the Maine Coon', 'gonzo the maine coon', 'gonzo-the-maine-coon', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gonzo the Maine Coon') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Agnese', 'agnese', 'agnese', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Agnese') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Taxi easy', 'taxi easy', 'taxi-easy', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Taxi easy') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gust', 'gust', 'gust', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gust') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La spalla rotta', 'la spalla rotta', 'la-spalla-rotta', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La spalla rotta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sti cazzi', 'sti cazzi', 'sti-cazzi', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sti cazzi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rock warriors', 'rock warriors', 'rock-warriors', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rock warriors') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Libottentros', 'libottentros', 'libottentros', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Libottentros') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '48+1', '48+1', '48-1', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('48+1') AND sector_id = v_sector_id);

  -- Settore: Cave of Dreams
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Cave of Dreams') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Cave of Dreams', 'cave of dreams', 'cave-of-dreams', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'A-pollo One', 'a-pollo one', 'a-pollo-one', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('A-pollo One') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Crossroads', 'crossroads', 'crossroads', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Crossroads') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Opinioni di un Climber', 'opinioni di un climber', 'opinioni-di-un-climber', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Opinioni di un Climber') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Light my fire', 'light my fire', 'light-my-fire', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Light my fire') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Iuston', 'iuston', 'iuston', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Iuston') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'We begin', 'we begin', 'we-begin', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('We begin') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il manzo di Eraldo', 'il manzo di eraldo', 'il-manzo-di-eraldo', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il manzo di Eraldo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Empty wallet', 'empty wallet', 'empty-wallet', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Empty wallet') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'See without looking', 'see without looking', 'see-without-looking', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('See without looking') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'B&V', 'b&v', 'b-v', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('B&V') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Provolina', 'provolina', 'provolina', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Provolina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Seven', 'seven', 'seven', '7b+/7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Seven') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Coincidence or destiny', 'coincidence or destiny', 'coincidence-or-destiny', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Coincidence or destiny') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Frigorifero', 'frigorifero', 'frigorifero', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Frigorifero') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Upupa meccanica', 'upupa meccanica', 'upupa-meccanica', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Upupa meccanica') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Coca light', 'coca light', 'coca-light', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Coca light') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Erbalife', 'erbalife', 'erbalife', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Erbalife') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La danza dei nerd', 'la danza dei nerd', 'la-danza-dei-nerd', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La danza dei nerd') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Controluce', 'controluce', 'controluce', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Controluce') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cittidì', 'cittidi', 'cittidi', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cittidì') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Why not', 'why not', 'why-not', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Why not') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cromo', 'cromo', 'cromo', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cromo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Riglos L1', 'riglos l1', 'riglos-l1', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Riglos L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Riglos L1+L2', 'riglos l1+l2', 'riglos-l1-l2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Riglos L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'White out', 'white out', 'white-out', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('White out') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Silver rope', 'silver rope', 'silver-rope', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Silver rope') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pink ball', 'pink ball', 'pink-ball', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pink ball') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''illusione di competere col tempo', 'l''illusione di competere col tempo', 'l-illusione-di-competere-col-tempo', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''illusione di competere col tempo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Free for all', 'free for all', 'free-for-all', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Free for all') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Io chiodo, tu paga', 'io chiodo, tu paga', 'io-chiodo-tu-paga', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Io chiodo, tu paga') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Melo sushi', 'melo sushi', 'melo-sushi', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Melo sushi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nonna Pina e Nonno Angelo', 'nonna pina e nonno angelo', 'nonna-pina-e-nonno-angelo', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nonna Pina e Nonno Angelo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Stazione curcuda', 'stazione curcuda', 'stazione-curcuda', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Stazione curcuda') AND sector_id = v_sector_id);

  -- Settore: El Dorado
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('El Dorado') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('El Dorado', 'el dorado', 'el-dorado', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Liposuzione', 'liposuzione', 'liposuzione', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Liposuzione') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Effetto doppler', 'effetto doppler', 'effetto-doppler', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Effetto doppler') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Killer Pablito', 'killer pablito', 'killer-pablito', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Killer Pablito') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Caballo desbocado', 'caballo desbocado', 'caballo-desbocado', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Caballo desbocado') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Carovana', 'carovana', 'carovana', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Carovana') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il furbetto L1', 'il furbetto l1', 'il-furbetto-l1', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il furbetto L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il furbetto L1+L2', 'il furbetto l1+l2', 'il-furbetto-l1-l2', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il furbetto L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nuovo mondo L1', 'nuovo mondo l1', 'nuovo-mondo-l1', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nuovo mondo L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nuovo mondo L1+L2', 'nuovo mondo l1+l2', 'nuovo-mondo-l1-l2', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nuovo mondo L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'El Dorado', 'el dorado', 'el-dorado', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('El Dorado') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La strada per el dorado', 'la strada per el dorado', 'la-strada-per-el-dorado', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La strada per el dorado') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il missionario', 'il missionario', 'il-missionario', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il missionario') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Junkie paradise', 'junkie paradise', 'junkie-paradise', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Junkie paradise') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Risonanzà L1', 'risonanza l1', 'risonanza-l1', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Risonanzà L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Risonanzà L1+L2', 'risonanza l1+l2', 'risonanza-l1-l2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Risonanzà L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Empatia e moralità', 'empatia e moralita', 'empatia-e-moralita', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Empatia e moralità') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La bella Ila', 'la bella ila', 'la-bella-ila', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La bella Ila') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mimimi', 'mimimi', 'mimimi', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mimimi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Non una di meno L1', 'non una di meno l1', 'non-una-di-meno-l1', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Non una di meno L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Non una di meno L1+L2', 'non una di meno l1+l2', 'non-una-di-meno-l1-l2', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Non una di meno L1+L2') AND sector_id = v_sector_id);

  -- Settore: Il Canyon
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Il Canyon') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Il Canyon', 'il canyon', 'il-canyon', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Giulia', 'giulia', 'giulia', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Giulia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Hotel Su Murmuri', 'hotel su murmuri', 'hotel-su-murmuri', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Hotel Su Murmuri') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cavineddu', 'cavineddu', 'cavineddu', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cavineddu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '1, 2 donne', '1, 2 donne', '1-2-donne', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('1, 2 donne') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cloaca', 'cloaca', 'cloaca', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cloaca') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tom', 'tom', 'tom', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tom') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Jerry', 'jerry', 'jerry', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Jerry') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Intrusi sospetti', 'intrusi sospetti', 'intrusi-sospetti', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Intrusi sospetti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vision Crack', 'vision crack', 'vision-crack', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vision Crack') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Molto rumore per nulla', 'molto rumore per nulla', 'molto-rumore-per-nulla', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Molto rumore per nulla') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ricordati di me', 'ricordati di me', 'ricordati-di-me', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ricordati di me') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Arcipelaghi L1', 'arcipelaghi l1', 'arcipelaghi-l1', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Arcipelaghi L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il coyote L1+L2', 'il coyote l1+l2', 'il-coyote-l1-l2', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il coyote L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Educanza L1', 'educanza l1', 'educanza-l1', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Educanza L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mezza pizzetta L1+L2', 'mezza pizzetta l1+l2', 'mezza-pizzetta-l1-l2', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mezza pizzetta L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nonluogo', 'nonluogo', 'nonluogo', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nonluogo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Disamore', 'disamore', 'disamore', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Disamore') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cattolico decoro', 'cattolico decoro', 'cattolico-decoro', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cattolico decoro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lacrime di coccodrillo', 'lacrime di coccodrillo', 'lacrime-di-coccodrillo', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lacrime di coccodrillo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Coccole e magnesite', 'coccole e magnesite', 'coccole-e-magnesite', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Coccole e magnesite') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Hamtaro', 'hamtaro', 'hamtaro', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Hamtaro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tarantula', 'tarantula', 'tarantula', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tarantula') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tasmania', 'tasmania', 'tasmania', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tasmania') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Quinto', 'quinto', 'quinto', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Quinto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Maladittu siasta', 'maladittu siasta', 'maladittu-siasta', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Maladittu siasta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Aquila Skalza', 'aquila skalza', 'aquila-skalza', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Aquila Skalza') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Già lo sai', 'gia lo sai', 'gia-lo-sai', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Già lo sai') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Up', 'up', 'up', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Up') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Koda', 'koda', 'koda', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Koda') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Kenai', 'kenai', 'kenai', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Kenai') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La reina', 'la reina', 'la-reina', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La reina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Zinghi', 'zinghi', 'zinghi', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Zinghi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Niagara', 'niagara', 'niagara', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Niagara') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nazarè', 'nazare', 'nazare', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nazarè') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Prozac Blues', 'prozac blues', 'prozac-blues', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Prozac Blues') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Artattak L1', 'artattak l1', 'artattak-l1', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Artattak L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pescecane L1+L2', 'pescecane l1+l2', 'pescecane-l1-l2', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pescecane L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ladri scalatori', 'ladri scalatori', 'ladri-scalatori', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ladri scalatori') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pasqua bagnata', 'pasqua bagnata', 'pasqua-bagnata', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pasqua bagnata') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Flower crack L1', 'flower crack l1', 'flower-crack-l1', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Flower crack L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Flower crack L1+L2', 'flower crack l1+l2', 'flower-crack-l1-l2', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Flower crack L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The Lobster', 'the lobster', 'the-lobster', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The Lobster') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Crystal waves', 'crystal waves', 'crystal-waves', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Crystal waves') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tuco Ramirez', 'tuco ramirez', 'tuco-ramirez', '8a+/8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tuco Ramirez') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'I nodi vengono al pettine', 'i nodi vengono al pettine', 'i-nodi-vengono-al-pettine', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('I nodi vengono al pettine') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Buonuomo', 'buonuomo', 'buonuomo', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Buonuomo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fruttolo L1', 'fruttolo l1', 'fruttolo-l1', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fruttolo L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fruttolo L1+L2', 'fruttolo l1+l2', 'fruttolo-l1-l2', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fruttolo L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Aggannammala', 'aggannammala', 'aggannammala', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Aggannammala') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Zitto e tira!', 'zitto e tira!', 'zitto-e-tira', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Zitto e tira!') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mina vagante', 'mina vagante', 'mina-vagante', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mina vagante') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ta peccau', 'ta peccau', 'ta-peccau', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ta peccau') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Trottolina', 'trottolina', 'trottolina', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Trottolina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La danza del maestrale', 'la danza del maestrale', 'la-danza-del-maestrale', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La danza del maestrale') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sabagas', 'sabagas', 'sabagas', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sabagas') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nebbia', 'nebbia', 'nebbia', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nebbia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Anisakis', 'anisakis', 'anisakis', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Anisakis') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Caccia alle streghe', 'caccia alle streghe', 'caccia-alle-streghe', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Caccia alle streghe') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Meda', 'meda', 'meda', '7c+/8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Meda') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Intervista col vampiro L1', 'intervista col vampiro l1', 'intervista-col-vampiro-l1', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Intervista col vampiro L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Intervista col vampiro L1+L2', 'intervista col vampiro l1+l2', 'intervista-col-vampiro-l1-l2', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Intervista col vampiro L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ecco Dati', 'ecco dati', 'ecco-dati', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ecco Dati') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bolle di sapone', 'bolle di sapone', 'bolle-di-sapone', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bolle di sapone') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Savoiardo d''Egitto', 'savoiardo d''egitto', 'savoiardo-d-egitto', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Savoiardo d''Egitto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sugo', 'sugo', 'sugo', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sugo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''uomo senz''anima', 'l''uomo senz''anima', 'l-uomo-senz-anima', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''uomo senz''anima') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Still alive', 'still alive', 'still-alive', '8c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Still alive') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il fanfarone', 'il fanfarone', 'il-fanfarone', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il fanfarone') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Forcefit', 'forcefit', 'forcefit', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Forcefit') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Stiziaticodidioi', 'stiziaticodidioi', 'stiziaticodidioi', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Stiziaticodidioi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Trilobite', 'trilobite', 'trilobite', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Trilobite') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nuraghe (SCHIODATA)', 'nuraghe (schiodata)', 'nuraghe-schiodata', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nuraghe (SCHIODATA)') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Snake Eye', 'snake eye', 'snake-eye', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Snake Eye') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Neverwhere', 'neverwhere', 'neverwhere', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Neverwhere') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fiona diretta', 'fiona diretta', 'fiona-diretta', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fiona diretta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fiona', 'fiona', 'fiona', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fiona') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Clio', 'clio', 'clio', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Clio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Blu', 'blu', 'blu', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Blu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Olieningrado', 'olieningrado', 'olieningrado', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Olieningrado') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bad Joke', 'bad joke', 'bad-joke', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bad Joke') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Anemnesi', 'anemnesi', 'anemnesi', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Anemnesi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''aria', 'l''aria', 'l-aria', '6b+/6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''aria') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nido di draghi', 'nido di draghi', 'nido-di-draghi', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nido di draghi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mexina', 'mexina', 'mexina', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mexina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sudottori', 'sudottori', 'sudottori', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sudottori') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tossisca', 'tossisca', 'tossisca', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tossisca') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fura fura (SCHIODATA)', 'fura fura (schiodata)', 'fura-fura-schiodata', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fura fura (SCHIODATA)') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fura crabasa (SCHIODATA)', 'fura crabasa (schiodata)', 'fura-crabasa-schiodata', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fura crabasa (SCHIODATA)') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Osculto', 'osculto', 'osculto', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Osculto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Kajoe', 'kajoe', 'kajoe', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Kajoe') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sun and bass', 'sun and bass', 'sun-and-bass', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sun and bass') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Hugs e kisses', 'hugs e kisses', 'hugs-e-kisses', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Hugs e kisses') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dica 33', 'dica 33', 'dica-33', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dica 33') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spiedl dl ana', 'spiedl dl ana', 'spiedl-dl-ana', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spiedl dl ana') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sas Viv', 'sas viv', 'sas-viv', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sas Viv') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'False promesse', 'false promesse', 'false-promesse', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('False promesse') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il passo del fandango', 'il passo del fandango', 'il-passo-del-fandango', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il passo del fandango') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Passo doble', 'passo doble', 'passo-doble', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Passo doble') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Abbardente tomorrow i''m a flower', 'abbardente tomorrow i''m a flower', 'abbardente-tomorrow-i-m-a-flower', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Abbardente tomorrow i''m a flower') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Checiapp', 'checiapp', 'checiapp', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Checiapp') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fiocchetti e palmette', 'fiocchetti e palmette', 'fiocchetti-e-palmette', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fiocchetti e palmette') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Manu''s paradise', 'manu''s paradise', 'manu-s-paradise', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Manu''s paradise') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Belin', 'belin', 'belin', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Belin') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Succio… è', 'succio… e', 'succio-e', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Succio… è') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Praticamente no!', 'praticamente no!', 'praticamente-no', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Praticamente no!') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gli apostoli', 'gli apostoli', 'gli-apostoli', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gli apostoli') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nebia', 'nebia', 'nebia', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nebia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The leisure princess', 'the leisure princess', 'the-leisure-princess', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The leisure princess') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The purple gecko galaxy', 'the purple gecko galaxy', 'the-purple-gecko-galaxy', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The purple gecko galaxy') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tre soldi', 'tre soldi', 'tre-soldi', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tre soldi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Peppino e Peppina', 'peppino e peppina', 'peppino-e-peppina', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Peppino e Peppina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rebecca', 'rebecca', 'rebecca', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rebecca') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pissenlove', 'pissenlove', 'pissenlove', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pissenlove') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Zimo', 'zimo', 'zimo', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Zimo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Criminally', 'criminally', 'criminally', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Criminally') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mummietta', 'mummietta', 'mummietta', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mummietta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Giolla', 'giolla', 'giolla', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Giolla') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cicciosauro', 'cicciosauro', 'cicciosauro', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cicciosauro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cicciasaura', 'cicciasaura', 'cicciasaura', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cicciasaura') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Formicuzza', 'formicuzza', 'formicuzza', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Formicuzza') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Crepa cuore', 'crepa cuore', 'crepa-cuore', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Crepa cuore') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Barra dei leppuri', 'barra dei leppuri', 'barra-dei-leppuri', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Barra dei leppuri') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Carola block', 'carola block', 'carola-block', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Carola block') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cavità sensuali', 'cavita sensuali', 'cavita-sensuali', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cavità sensuali') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Diagolal theatre', 'diagolal theatre', 'diagolal-theatre', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Diagolal theatre') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'B.I.C.', 'b.i.c.', 'b-i-c', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('B.I.C.') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spritz litz', 'spritz litz', 'spritz-litz', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spritz litz') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''igienista', 'l''igienista', 'l-igienista', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''igienista') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Estigazzi', 'estigazzi', 'estigazzi', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Estigazzi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sammi', 'sammi', 'sammi', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sammi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Patata volante', 'patata volante', 'patata-volante', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Patata volante') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Miki superstar', 'miki superstar', 'miki-superstar', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Miki superstar') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Piccola mou', 'piccola mou', 'piccola-mou', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Piccola mou') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Via campo sportivo nr.1', 'via campo sportivo nr.1', 'via-campo-sportivo-nr-1', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Via campo sportivo nr.1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'High school girls', 'high school girls', 'high-school-girls', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('High school girls') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'History repeating', 'history repeating', 'history-repeating', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('History repeating') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Emelie''s first steps', 'emelie''s first steps', 'emelie-s-first-steps', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Emelie''s first steps') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Peppa pig', 'peppa pig', 'peppa-pig', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Peppa pig') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ponio', 'ponio', 'ponio', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ponio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lamù', 'lamu', 'lamu', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lamù') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pio pio', 'pio pio', 'pio-pio', '4b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pio pio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Caterpillar Mario', 'caterpillar mario', 'caterpillar-mario', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Caterpillar Mario') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Empia Spiga', 'empia spiga', 'empia-spiga', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Empia Spiga') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pino solitario', 'pino solitario', 'pino-solitario', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pino solitario') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Semini fini', 'semini fini', 'semini-fini', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Semini fini') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pane', 'pane', 'pane', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pane') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nutella', 'nutella', 'nutella', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nutella') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Minimo decoro', 'minimo decoro', 'minimo-decoro', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Minimo decoro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Questione di pitting', 'questione di pitting', 'questione-di-pitting', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Questione di pitting') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Baby body painting', 'baby body painting', 'baby-body-painting', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Baby body painting') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sfigatello', 'sfigatello', 'sfigatello', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sfigatello') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fuerte e ventura', 'fuerte e ventura', 'fuerte-e-ventura', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fuerte e ventura') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bulgarmente', 'bulgarmente', 'bulgarmente', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bulgarmente') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bocabulario', 'bocabulario', 'bocabulario', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bocabulario') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lole', 'lole', 'lole', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lole') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Amaramura', 'amaramura', 'amaramura', '4c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Amaramura') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Marinella boulder', 'marinella boulder', 'marinella-boulder', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Marinella boulder') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cristina Canarina', 'cristina canarina', 'cristina-canarina', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cristina Canarina') AND sector_id = v_sector_id);

  -- Settore: Inquietudini
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Inquietudini') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Inquietudini', 'inquietudini', 'inquietudini', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Monster & Co', 'monster & co', 'monster-co', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Monster & Co') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'El dieguito enfurecido', 'el dieguito enfurecido', 'el-dieguito-enfurecido', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('El dieguito enfurecido') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Black Mamba', 'black mamba', 'black-mamba', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Black Mamba') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Shenron dragon', 'shenron dragon', 'shenron-dragon', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Shenron dragon') AND sector_id = v_sector_id);

  -- Settore: Is Janas
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Is Janas') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Is Janas', 'is janas', 'is-janas', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nanny Ogg.', 'nanny ogg.', 'nanny-ogg', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nanny Ogg.') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Greebo', 'greebo', 'greebo', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Greebo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lilia', 'lilia', 'lilia', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lilia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Acqua vite', 'acqua vite', 'acqua-vite', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Acqua vite') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Water life', 'water life', 'water-life', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Water life') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sa janitedda', 'sa janitedda', 'sa-janitedda', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sa janitedda') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Puzza di gatto', 'puzza di gatto', 'puzza-di-gatto', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Puzza di gatto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bocca di rosa', 'bocca di rosa', 'bocca-di-rosa', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bocca di rosa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Silence', 'silence', 'silence', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Silence') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Anunnaki', 'anunnaki', 'anunnaki', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Anunnaki') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Caffè scorretto', 'caffe scorretto', 'caffe-scorretto', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Caffè scorretto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tozo on tour', 'tozo on tour', 'tozo-on-tour', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tozo on tour') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Per l''amore di Theo', 'per l''amore di theo', 'per-l-amore-di-theo', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Per l''amore di Theo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bene Gesserit', 'bene gesserit', 'bene-gesserit', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bene Gesserit') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Shai-Hulud', 'shai-hulud', 'shai-hulud', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Shai-Hulud') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Occhi azzurri', 'occhi azzurri', 'occhi-azzurri', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Occhi azzurri') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nog een nijntjes nektapijt', 'nog een nijntjes nektapijt', 'nog-een-nijntjes-nektapijt', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nog een nijntjes nektapijt') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Trust your flake', 'trust your flake', 'trust-your-flake', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Trust your flake') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Azabuba', 'azabuba', 'azabuba', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Azabuba') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ex-runout', 'ex-runout', 'ex-runout', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ex-runout') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vento in fessa', 'vento in fessa', 'vento-in-fessa', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vento in fessa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gancanach', 'gancanach', 'gancanach', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gancanach') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Un viaggio con Tony', 'un viaggio con tony', 'un-viaggio-con-tony', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Un viaggio con Tony') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Aradia', 'aradia', 'aradia', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Aradia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nicnivin', 'nicnivin', 'nicnivin', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nicnivin') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Doggando', 'doggando', 'doggando', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Doggando') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cool Abdul', 'cool abdul', 'cool-abdul', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cool Abdul') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sexual healing', 'sexual healing', 'sexual-healing', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sexual healing') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Savannah', 'savannah', 'savannah', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Savannah') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''ombra del vento', 'l''ombra del vento', 'l-ombra-del-vento', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''ombra del vento') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '100 culurgiones', '100 culurgiones', '100-culurgiones', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('100 culurgiones') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dr. Google', 'dr. google', 'dr-google', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dr. Google') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Muscles from brussels', 'muscles from brussels', 'muscles-from-brussels', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Muscles from brussels') AND sector_id = v_sector_id);

  -- Settore: La Piramide
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('La Piramide') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('La Piramide', 'la piramide', 'la-piramide', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Anubi', 'anubi', 'anubi', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Anubi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cheope', 'cheope', 'cheope', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cheope') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Amon', 'amon', 'amon', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Amon') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bastet', 'bastet', 'bastet', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bastet') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mut', 'mut', 'mut', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mut') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Set', 'set', 'set', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Set') AND sector_id = v_sector_id);

  -- Settore: Lecorci
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Lecorci') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Lecorci', 'lecorci', 'lecorci', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Panta rei', 'panta rei', 'panta-rei', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Panta rei') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Astragalo', 'astragalo', 'astragalo', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Astragalo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Boomerang', 'boomerang', 'boomerang', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Boomerang') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ubi maior', 'ubi maior', 'ubi-maior', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ubi maior') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The watchtower L1', 'the watchtower l1', 'the-watchtower-l1', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The watchtower L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'All along the watchtower L1+L2', 'all along the watchtower l1+l2', 'all-along-the-watchtower-l1-l2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('All along the watchtower L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Hard Bitch', 'hard bitch', 'hard-bitch', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Hard Bitch') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rafiki L1', 'rafiki l1', 'rafiki-l1', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rafiki L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rafiki ext L1+L2', 'rafiki ext l1+l2', 'rafiki-ext-l1-l2', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rafiki ext L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Minor cessat', 'minor cessat', 'minor-cessat', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Minor cessat') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Coming back', 'coming back', 'coming-back', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Coming back') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Stay away', 'stay away', 'stay-away', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Stay away') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Kaftrio', 'kaftrio', 'kaftrio', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Kaftrio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tito', 'tito', 'tito', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tito') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Alfa', 'alfa', 'alfa', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Alfa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Drago nero', 'drago nero', 'drago-nero', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Drago nero') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rurp', 'rurp', 'rurp', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rurp') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mira il dito', 'mira il dito', 'mira-il-dito', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mira il dito') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Doomsday', 'doomsday', 'doomsday', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Doomsday') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Doomsday è bella così L1+L2', 'doomsday e bella cosi l1+l2', 'doomsday-e-bella-cosi-l1-l2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Doomsday è bella così L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bella così', 'bella cosi', 'bella-cosi', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bella così') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bellissima così L1+L2', 'bellissima cosi l1+l2', 'bellissima-cosi-l1-l2', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bellissima così L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Apparenza', 'apparenza', 'apparenza', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Apparenza') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dieta ferrea', 'dieta ferrea', 'dieta-ferrea', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dieta ferrea') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Protuberanza equina', 'protuberanza equina', 'protuberanza-equina', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Protuberanza equina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Regime alimentare', 'regime alimentare', 'regime-alimentare', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Regime alimentare') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spina', 'spina', 'spina', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bobolone', 'bobolone', 'bobolone', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bobolone') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Chichino', 'chichino', 'chichino', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Chichino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Buchi buchi', 'buchi buchi', 'buchi-buchi', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Buchi buchi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome', 'senza nome', 'senza-nome', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lisio', 'lisio', 'lisio', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lisio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Frigo', 'frigo', 'frigo', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Frigo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gino', 'gino', 'gino', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pino', 'pino', 'pino', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nino', 'nino', 'nino', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fammi vedere le tette', 'fammi vedere le tette', 'fammi-vedere-le-tette', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fammi vedere le tette') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spaghetti al rovo', 'spaghetti al rovo', 'spaghetti-al-rovo', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spaghetti al rovo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Stanza', 'stanza', 'stanza', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Stanza') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Atti di clemenza', 'atti di clemenza', 'atti-di-clemenza', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Atti di clemenza') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Zuccherino', 'zuccherino', 'zuccherino', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Zuccherino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tap', 'tap', 'tap', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tap') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tip L1', 'tip l1', 'tip-l1', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tip L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'A''bombazza L2', 'a''bombazza l2', 'a-bombazza-l2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('A''bombazza L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Esagerato', 'esagerato', 'esagerato', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Esagerato') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'MCB L1', 'mcb l1', 'mcb-l1', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('MCB L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'TVB L1+L2', 'tvb l1+l2', 'tvb-l1-l2', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('TVB L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'MDF L1+L2', 'mdf l1+l2', 'mdf-l1-l2', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('MDF L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pipo', 'pipo', 'pipo', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pipo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Liz', 'liz', 'liz', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Liz') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mezzo tiro', 'mezzo tiro', 'mezzo-tiro', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mezzo tiro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La mano bianca', 'la mano bianca', 'la-mano-bianca', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La mano bianca') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The laughing heart', 'the laughing heart', 'the-laughing-heart', '8c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The laughing heart') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Aiutante', 'aiutante', 'aiutante', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Aiutante') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pugnali volanti', 'pugnali volanti', 'pugnali-volanti', '8b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pugnali volanti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vulcano', 'vulcano', 'vulcano', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vulcano') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Canna cinese', 'canna cinese', 'canna-cinese', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Canna cinese') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dolce banana', 'dolce banana', 'dolce-banana', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dolce banana') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dimenticanze', 'dimenticanze', 'dimenticanze', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dimenticanze') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Block', 'block', 'block', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Block') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spakka', 'spakka', 'spakka', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spakka') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Showroom dummies', 'showroom dummies', 'showroom-dummies', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Showroom dummies') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Croce e delizia', 'croce e delizia', 'croce-e-delizia', '7c+/8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Croce e delizia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'P.T.', 'p.t.', 'p-t', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('P.T.') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ghost writer', 'ghost writer', 'ghost-writer', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ghost writer') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La trama del tempo L1', 'la trama del tempo l1', 'la-trama-del-tempo-l1', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La trama del tempo L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La trama del tempo L1+L2', 'la trama del tempo l1+l2', 'la-trama-del-tempo-l1-l2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La trama del tempo L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Red cut', 'red cut', 'red-cut', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Red cut') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bricolage', 'bricolage', 'bricolage', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bricolage') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tentazioni', 'tentazioni', 'tentazioni', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tentazioni') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sinto', 'sinto', 'sinto', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sinto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Finto', 'finto', 'finto', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Finto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pinto', 'pinto', 'pinto', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pinto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rovo di bosco', 'rovo di bosco', 'rovo-di-bosco', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rovo di bosco') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Kill Bill', 'kill bill', 'kill-bill', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Kill Bill') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sorgente', 'sorgente', 'sorgente', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sorgente') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gocce di memoria', 'gocce di memoria', 'gocce-di-memoria', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gocce di memoria') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Indomabile', 'indomabile', 'indomabile', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Indomabile') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Grillo sacente', 'grillo sacente', 'grillo-sacente', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Grillo sacente') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mo...viola', 'mo...viola', 'mo-viola', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mo...viola') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Movimenti socratici', 'movimenti socratici', 'movimenti-socratici', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Movimenti socratici') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Umori al vespero', 'umori al vespero', 'umori-al-vespero', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Umori al vespero') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Short and nameless', 'short and nameless', 'short-and-nameless', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Short and nameless') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sottobosco', 'sottobosco', 'sottobosco', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sottobosco') AND sector_id = v_sector_id);

  -- Settore: Marosini
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Marosini') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Marosini', 'marosini', 'marosini', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Saluto al sole', 'saluto al sole', 'saluto-al-sole', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Saluto al sole') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Eagle Eye', 'eagle eye', 'eagle-eye', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Eagle Eye') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rocket Pocket', 'rocket pocket', 'rocket-pocket', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rocket Pocket') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Geo', 'geo', 'geo', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Geo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pussy wagon', 'pussy wagon', 'pussy-wagon', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pussy wagon') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Esperienza senile', 'esperienza senile', 'esperienza-senile', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Esperienza senile') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Krabfarm', 'krabfarm', 'krabfarm', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Krabfarm') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mister arete', 'mister arete', 'mister-arete', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mister arete') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Capitalismo', 'capitalismo', 'capitalismo', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Capitalismo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spazzolino rotto', 'spazzolino rotto', 'spazzolino-rotto', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spazzolino rotto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Frankie''s finale', 'frankie''s finale', 'frankie-s-finale', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Frankie''s finale') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Poodelwoodelywoopsy', 'poodelwoodelywoopsy', 'poodelwoodelywoopsy', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Poodelwoodelywoopsy') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'FK', 'fk', 'fk', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('FK') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Culurgiones', 'culurgiones', 'culurgiones', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Culurgiones') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Murales', 'murales', 'murales', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Murales') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The alchemist', 'the alchemist', 'the-alchemist', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The alchemist') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'No country for young man', 'no country for young man', 'no-country-for-young-man', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('No country for young man') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Yea vez', 'yea vez', 'yea-vez', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Yea vez') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Grande vez', 'grande vez', 'grande-vez', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Grande vez') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mononoke L1', 'mononoke l1', 'mononoke-l1', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mononoke L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mononoke L1+L2', 'mononoke l1+l2', 'mononoke-l1-l2', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mononoke L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mononoke L1+L2+L3', 'mononoke l1+l2+l3', 'mononoke-l1-l2-l3', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mononoke L1+L2+L3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spriggan L1', 'spriggan l1', 'spriggan-l1', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spriggan L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spriggan L1+L2', 'spriggan l1+l2', 'spriggan-l1-l2', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spriggan L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Angry hippies', 'angry hippies', 'angry-hippies', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Angry hippies') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Highlines', 'highlines', 'highlines', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Highlines') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rosse armee fraction', 'rosse armee fraction', 'rosse-armee-fraction', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rosse armee fraction') AND sector_id = v_sector_id);

  -- Settore: Opera
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Opera') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Opera', 'opera', 'opera', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Magica medicina', 'magica medicina', 'magica-medicina', '3b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Magica medicina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La fabbrica di cioccolata', 'la fabbrica di cioccolata', 'la-fabbrica-di-cioccolata', '3b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La fabbrica di cioccolata') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il gattopardo', 'il gattopardo', 'il-gattopardo', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il gattopardo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'On the road', 'on the road', 'on-the-road', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('On the road') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La leggerezza dell''essere', 'la leggerezza dell''essere', 'la-leggerezza-dell-essere', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La leggerezza dell''essere') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Le radici del cielo', 'le radici del cielo', 'le-radici-del-cielo', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Le radici del cielo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La gabbianella e il gatto', 'la gabbianella e il gatto', 'la-gabbianella-e-il-gatto', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La gabbianella e il gatto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Shining', 'shining', 'shining', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Shining') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il nome della rosa', 'il nome della rosa', 'il-nome-della-rosa', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il nome della rosa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cuore di tenebra', 'cuore di tenebra', 'cuore-di-tenebra', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cuore di tenebra') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il monte analogo', 'il monte analogo', 'il-monte-analogo', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il monte analogo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''interpretazione dei sogni', 'l''interpretazione dei sogni', 'l-interpretazione-dei-sogni', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''interpretazione dei sogni') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La metamorfosi', 'la metamorfosi', 'la-metamorfosi', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La metamorfosi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''ombra dello scorpione', 'l''ombra dello scorpione', 'l-ombra-dello-scorpione', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''ombra dello scorpione') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il muro', 'il muro', 'il-muro', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il muro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lo straniero', 'lo straniero', 'lo-straniero', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lo straniero') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La realtà separata', 'la realta separata', 'la-realta-separata', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La realtà separata') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Siddharta', 'siddharta', 'siddharta', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Siddharta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il dio delle piccole cose', 'il dio delle piccole cose', 'il-dio-delle-piccole-cose', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il dio delle piccole cose') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Musasti', 'musasti', 'musasti', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Musasti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Zanna Bianca', 'zanna bianca', 'zanna-bianca', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Zanna Bianca') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tom Sawyer', 'tom sawyer', 'tom-sawyer', '3b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tom Sawyer') AND sector_id = v_sector_id);

  -- Settore: S'Assa Bella
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('S''Assa Bella') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('S''Assa Bella', 's''assa bella', 's-assa-bella', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tomba Oscura', 'tomba oscura', 'tomba-oscura', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tomba Oscura') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Campeggio eterno', 'campeggio eterno', 'campeggio-eterno', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Campeggio eterno') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Poser', 'poser', 'poser', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Poser') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'M''inchino', 'm''inchino', 'm-inchino', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('M''inchino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Su tasinanta', 'su tasinanta', 'su-tasinanta', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Su tasinanta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Beccamorto', 'beccamorto', 'beccamorto', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Beccamorto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pannelli solari e polpi', 'pannelli solari e polpi', 'pannelli-solari-e-polpi', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pannelli solari e polpi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tutto tu vuole', 'tutto tu vuole', 'tutto-tu-vuole', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tutto tu vuole') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Seta morbida', 'seta morbida', 'seta-morbida', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Seta morbida') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Time to shave', 'time to shave', 'time-to-shave', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Time to shave') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bella zia', 'bella zia', 'bella-zia', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bella zia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Barba Gianni', 'barba gianni', 'barba-gianni', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Barba Gianni') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Miss Coolio', 'miss coolio', 'miss-coolio', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Miss Coolio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Don Abbondio', 'don abbondio', 'don-abbondio', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Don Abbondio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Minchecua', 'minchecua', 'minchecua', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Minchecua') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il cinghiale', 'il cinghiale', 'il-cinghiale', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il cinghiale') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Offerta grazie al cazzo', 'offerta grazie al cazzo', 'offerta-grazie-al-cazzo', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Offerta grazie al cazzo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Basta Marco L1', 'basta marco l1', 'basta-marco-l1', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Basta Marco L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Detonati L1+L2', 'detonati l1+l2', 'detonati-l1-l2', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Detonati L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vai Polleg', 'vai polleg', 'vai-polleg', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vai Polleg') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Salvini merda', 'salvini merda', 'salvini-merda', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Salvini merda') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Porkatron', 'porkatron', 'porkatron', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Porkatron') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''alcolista', 'l''alcolista', 'l-alcolista', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''alcolista') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'I think I smell aerie L1', 'i think i smell aerie l1', 'i-think-i-smell-aerie-l1', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('I think I smell aerie L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'I think I smell aerie L1+L2', 'i think i smell aerie l1+l2', 'i-think-i-smell-aerie-l1-l2', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('I think I smell aerie L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bolle dal culo L1', 'bolle dal culo l1', 'bolle-dal-culo-l1', '5a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bolle dal culo L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Hungarian dance L1+L2', 'hungarian dance l1+l2', 'hungarian-dance-l1-l2', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Hungarian dance L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Clandestino', 'clandestino', 'clandestino', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Clandestino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nanna ice cream', 'nanna ice cream', 'nanna-ice-cream', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nanna ice cream') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Wie heeft mijn setjes', 'wie heeft mijn setjes', 'wie-heeft-mijn-setjes', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Wie heeft mijn setjes') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Poopoo police', 'poopoo police', 'poopoo-police', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Poopoo police') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rita', 'rita', 'rita', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rita') AND sector_id = v_sector_id);

  -- Settore: Sa Matta Prana
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Sa Matta Prana') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Sa Matta Prana', 'sa matta prana', 'sa-matta-prana', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ondarossa', 'ondarossa', 'ondarossa', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ondarossa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pattada & wheels', 'pattada & wheels', 'pattada-wheels', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pattada & wheels') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Années sauvages', 'annees sauvages', 'annees-sauvages', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Années sauvages') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 2', 'senza nome 2', 'senza-nome-2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 3', 'senza nome 3', 'senza-nome-3', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Feeding the algorithm', 'feeding the algorithm', 'feeding-the-algorithm', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Feeding the algorithm') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 4', 'senza nome 4', 'senza-nome-4', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 4') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 5', 'senza nome 5', 'senza-nome-5', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 5') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Riding for a fall', 'riding for a fall', 'riding-for-a-fall', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Riding for a fall') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 6', 'senza nome 6', 'senza-nome-6', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 6') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 7', 'senza nome 7', 'senza-nome-7', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 7') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 8', 'senza nome 8', 'senza-nome-8', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 8') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spiderman', 'spiderman', 'spiderman', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spiderman') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La streghetta', 'la streghetta', 'la-streghetta', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La streghetta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Omineddu antigu', 'omineddu antigu', 'omineddu-antigu', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Omineddu antigu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Giovedì grasso', 'giovedi grasso', 'giovedi-grasso', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Giovedì grasso') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 9', 'senza nome 9', 'senza-nome-9', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 9') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Power of now', 'power of now', 'power-of-now', '8b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Power of now') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 10', 'senza nome 10', 'senza-nome-10', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 10') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Satori', 'satori', 'satori', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Satori') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Papi le gusta el Chile', 'papi le gusta el chile', 'papi-le-gusta-el-chile', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Papi le gusta el Chile') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mamacita', 'mamacita', 'mamacita', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mamacita') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 11', 'senza nome 11', 'senza-nome-11', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 11') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Eschaton', 'eschaton', 'eschaton', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Eschaton') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 12', 'senza nome 12', 'senza-nome-12', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 12') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Triple rocket', 'triple rocket', 'triple-rocket', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Triple rocket') AND sector_id = v_sector_id);

  -- Settore: Scala 'e predi
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Scala ''e predi') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Scala ''e predi', 'scala ''e predi', 'scala-e-predi', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Erre erre', 'erre erre', 'erre-erre', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Erre erre') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pepe al culo', 'pepe al culo', 'pepe-al-culo', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pepe al culo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'ATP', 'atp', 'atp', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('ATP') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bella di notte', 'bella di notte', 'bella-di-notte', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bella di notte') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Prisoner of child', 'prisoner of child', 'prisoner-of-child', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Prisoner of child') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bluebird', 'bluebird', 'bluebird', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bluebird') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Swing it like Roger', 'swing it like roger', 'swing-it-like-roger', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Swing it like Roger') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Augusto terapia', 'augusto terapia', 'augusto-terapia', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Augusto terapia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Altrimenti ci arrabbiamo', 'altrimenti ci arrabbiamo', 'altrimenti-ci-arrabbiamo', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Altrimenti ci arrabbiamo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nonno Cece', 'nonno cece', 'nonno-cece', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nonno Cece') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sasha bella', 'sasha bella', 'sasha-bella', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sasha bella') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Giuanni Aledda 102', 'giuanni aledda 102', 'giuanni-aledda-102', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Giuanni Aledda 102') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''anisiello Nunù', 'l''anisiello nunu', 'l-anisiello-nunu', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''anisiello Nunù') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Formica terapia', 'formica terapia', 'formica-terapia', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Formica terapia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bo!!!', 'bo!!!', 'bo', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bo!!!') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il molecolare', 'il molecolare', 'il-molecolare', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il molecolare') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Negativo', 'negativo', 'negativo', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Negativo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'New style', 'new style', 'new-style', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('New style') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'E... che cazzo', 'e... che cazzo', 'e-che-cazzo', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('E... che cazzo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Aleksänder', 'aleksander', 'aleksander', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Aleksänder') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Monnalisa', 'monnalisa', 'monnalisa', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Monnalisa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cambiamenti', 'cambiamenti', 'cambiamenti', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cambiamenti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Love me two times', 'love me two times', 'love-me-two-times', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Love me two times') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Baciami ancora', 'baciami ancora', 'baciami-ancora', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Baciami ancora') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Scintilla', 'scintilla', 'scintilla', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Scintilla') AND sector_id = v_sector_id);

  -- Settore: Scala Ussassa
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Scala Ussassa') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Scala Ussassa', 'scala ussassa', 'scala-ussassa', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vivi libero o muori', 'vivi libero o muori', 'vivi-libero-o-muori', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vivi libero o muori') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Chasing the scream L1', 'chasing the scream l1', 'chasing-the-scream-l1', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Chasing the scream L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Chasing the scream L1+L2', 'chasing the scream l1+l2', 'chasing-the-scream-l1-l2', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Chasing the scream L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Effective altruism', 'effective altruism', 'effective-altruism', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Effective altruism') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Anansi', 'anansi', 'anansi', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Anansi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Un atto di fede L1', 'un atto di fede l1', 'un-atto-di-fede-l1', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Un atto di fede L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Un atto di fede L1+L2', 'un atto di fede l1+l2', 'un-atto-di-fede-l1-l2', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Un atto di fede L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'At the gates', 'at the gates', 'at-the-gates', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('At the gates') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Finn Sue', 'finn sue', 'finn-sue', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Finn Sue') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mandumbo', 'mandumbo', 'mandumbo', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mandumbo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Check yo self', 'check yo self', 'check-yo-self', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Check yo self') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Team lazer line', 'team lazer line', 'team-lazer-line', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Team lazer line') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Abomba', 'abomba', 'abomba', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Abomba') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lord flashheart', 'lord flashheart', 'lord-flashheart', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lord flashheart') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Capitain slackbladder', 'capitain slackbladder', 'capitain-slackbladder', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Capitain slackbladder') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Agent orange', 'agent orange', 'agent-orange', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Agent orange') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Un giorno di pioggia', 'un giorno di pioggia', 'un-giorno-di-pioggia', '8c+/9a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Un giorno di pioggia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Giusto è giusto', 'giusto e giusto', 'giusto-e-giusto', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Giusto è giusto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Catching up', 'catching up', 'catching-up', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Catching up') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bella ciao', 'bella ciao', 'bella-ciao', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bella ciao') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gatekeeper', 'gatekeeper', 'gatekeeper', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gatekeeper') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Substance of shadows', 'substance of shadows', 'substance-of-shadows', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Substance of shadows') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'I predatori dei ciucci perduti', 'i predatori dei ciucci perduti', 'i-predatori-dei-ciucci-perduti', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('I predatori dei ciucci perduti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Darko', 'darko', 'darko', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Darko') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Battousai', 'battousai', 'battousai', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Battousai') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Trebenna L1', 'trebenna l1', 'trebenna-l1', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Trebenna L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Trebenna L1+L2', 'trebenna l1+l2', 'trebenna-l1-l2', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Trebenna L1+L2') AND sector_id = v_sector_id);

  -- Settore: Sopravento
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Sopravento') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Sopravento', 'sopravento', 'sopravento', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Shiver mi whiskers', 'shiver mi whiskers', 'shiver-mi-whiskers', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Shiver mi whiskers') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '6 piedi sotto la luna', '6 piedi sotto la luna', '6-piedi-sotto-la-luna', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('6 piedi sotto la luna') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Melone melone', 'melone melone', 'melone-melone', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Melone melone') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'King''s Cross', 'king''s cross', 'king-s-cross', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('King''s Cross') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La sete di Squiki', 'la sete di squiki', 'la-sete-di-squiki', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La sete di Squiki') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The colour prince', 'the colour prince', 'the-colour-prince', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The colour prince') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Salty wind', 'salty wind', 'salty-wind', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Salty wind') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tigre d''Ogliastra', 'tigre d''ogliastra', 'tigre-d-ogliastra', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tigre d''Ogliastra') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'So you think you can climb?', 'so you think you can climb?', 'so-you-think-you-can-climb', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('So you think you can climb?') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Goat licker', 'goat licker', 'goat-licker', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Goat licker') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'What''s cracking', 'what''s cracking', 'what-s-cracking', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('What''s cracking') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Jhonny sends', 'jhonny sends', 'jhonny-sends', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Jhonny sends') AND sector_id = v_sector_id);

  -- Settore: Su Casteddu
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Su Casteddu') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Su Casteddu', 'su casteddu', 'su-casteddu', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Baldur''s gate', 'baldur''s gate', 'baldur-s-gate', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Baldur''s gate') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Hier kommt Alex', 'hier kommt alex', 'hier-kommt-alex', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Hier kommt Alex') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Stuck in starlight', 'stuck in starlight', 'stuck-in-starlight', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Stuck in starlight') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'No foefelare', 'no foefelare', 'no-foefelare', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('No foefelare') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Roos&Floor', 'roos&floor', 'roos-floor', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Roos&Floor') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mental breakdown', 'mental breakdown', 'mental-breakdown', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mental breakdown') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gugu e lupo', 'gugu e lupo', 'gugu-e-lupo', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gugu e lupo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Goatrider', 'goatrider', 'goatrider', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Goatrider') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Goatbuster', 'goatbuster', 'goatbuster', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Goatbuster') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Waki', 'waki', 'waki', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Waki') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Buling', 'buling', 'buling', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Buling') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fiamme gialle', 'fiamme gialle', 'fiamme-gialle', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fiamme gialle') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tess the rock princess', 'tess the rock princess', 'tess-the-rock-princess', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tess the rock princess') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Marcello starman', 'marcello starman', 'marcello-starman', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Marcello starman') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lemon squeezy', 'lemon squeezy', 'lemon-squeezy', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lemon squeezy') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Crazy wedding', 'crazy wedding', 'crazy-wedding', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Crazy wedding') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il gusto della libertà', 'il gusto della liberta', 'il-gusto-della-liberta', '8c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il gusto della libertà') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Contromisure', 'contromisure', 'contromisure', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Contromisure') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Je bande donc j''essui L1', 'je bande donc j''essui l1', 'je-bande-donc-j-essui-l1', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Je bande donc j''essui L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Je bande donc j''essui L2', 'je bande donc j''essui l2', 'je-bande-donc-j-essui-l2', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Je bande donc j''essui L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Arnaque', 'arnaque', 'arnaque', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Arnaque') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il rutto', 'il rutto', 'il-rutto', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il rutto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Krankenjura', 'krankenjura', 'krankenjura', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Krankenjura') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gregorian crowbar', 'gregorian crowbar', 'gregorian-crowbar', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gregorian crowbar') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Generale macchi', 'generale macchi', 'generale-macchi', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Generale macchi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cygnus', 'cygnus', 'cygnus', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cygnus') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Python crack', 'python crack', 'python-crack', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Python crack') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Letz petz betz', 'letz petz betz', 'letz-petz-betz', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Letz petz betz') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Skyfall', 'skyfall', 'skyfall', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Skyfall') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Centenario', 'centenario', 'centenario', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Centenario') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sangue di cinghiale', 'sangue di cinghiale', 'sangue-di-cinghiale', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sangue di cinghiale') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Black eyed sky', 'black eyed sky', 'black-eyed-sky', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Black eyed sky') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Scuola alpina', 'scuola alpina', 'scuola-alpina', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Scuola alpina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Send and send ability', 'send and send ability', 'send-and-send-ability', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Send and send ability') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Climb and punishment', 'climb and punishment', 'climb-and-punishment', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Climb and punishment') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lord of the slings', 'lord of the slings', 'lord-of-the-slings', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lord of the slings') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The grip of wrath', 'the grip of wrath', 'the-grip-of-wrath', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The grip of wrath') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Henergy', 'henergy', 'henergy', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Henergy') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pale di San Martino', 'pale di san martino', 'pale-di-san-martino', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pale di San Martino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ceci n''es pas une 8a', 'ceci n''es pas une 8a', 'ceci-n-es-pas-une-8a', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ceci n''es pas une 8a') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Deliverance', 'deliverance', 'deliverance', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Deliverance') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Providence', 'providence', 'providence', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Providence') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Thumbs up, nailed it', 'thumbs up, nailed it', 'thumbs-up-nailed-it', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Thumbs up, nailed it') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mamma Miracoli', 'mamma miracoli', 'mamma-miracoli', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mamma Miracoli') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The bald and the beautiful', 'the bald and the beautiful', 'the-bald-and-the-beautiful', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The bald and the beautiful') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cutting corners', 'cutting corners', 'cutting-corners', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cutting corners') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'About a poisonous snake', 'about a poisonous snake', 'about-a-poisonous-snake', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('About a poisonous snake') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pirate Bandit', 'pirate bandit', 'pirate-bandit', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pirate Bandit') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Chumbawamba', 'chumbawamba', 'chumbawamba', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Chumbawamba') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bokito', 'bokito', 'bokito', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bokito') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sad little ego', 'sad little ego', 'sad-little-ego', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sad little ego') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Hot Marijke', 'hot marijke', 'hot-marijke', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Hot Marijke') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Floki', 'floki', 'floki', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Floki') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nanice', 'nanice', 'nanice', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nanice') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Wie ni waagt, ni klimt', 'wie ni waagt, ni klimt', 'wie-ni-waagt-ni-klimt', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Wie ni waagt, ni klimt') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Baciami subito', 'baciami subito', 'baciami-subito', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Baciami subito') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Plutonium', 'plutonium', 'plutonium', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Plutonium') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rubamitutto', 'rubamitutto', 'rubamitutto', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rubamitutto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rakomelo', 'rakomelo', 'rakomelo', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rakomelo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Come light my sick arête', 'come light my sick arete', 'come-light-my-sick-arete', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Come light my sick arête') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rattoncita', 'rattoncita', 'rattoncita', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rattoncita') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nannaientists 4 ever', 'nannaientists 4 ever', 'nannaientists-4-ever', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nannaientists 4 ever') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Alma', 'alma', 'alma', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Alma') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Women rock', 'women rock', 'women-rock', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Women rock') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Un have Maria', 'un have maria', 'un-have-maria', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Un have Maria') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Accoglie la vi(t)a', 'accoglie la vi(t)a', 'accoglie-la-vi-t-a', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Accoglie la vi(t)a') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Welcome to bambilon', 'welcome to bambilon', 'welcome-to-bambilon', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Welcome to bambilon') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fight the fungus', 'fight the fungus', 'fight-the-fungus', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fight the fungus') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Un attimo', 'un attimo', 'un-attimo', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Un attimo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'ROQS', 'roqs', 'roqs', '5b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('ROQS') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Oempapa', 'oempapa', 'oempapa', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Oempapa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Maria Loddo L1', 'maria loddo l1', 'maria-loddo-l1', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Maria Loddo L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Maria Loddo L1+L2', 'maria loddo l1+l2', 'maria-loddo-l1-l2', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Maria Loddo L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spalla guarita', 'spalla guarita', 'spalla-guarita', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spalla guarita') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Hot Veerleken', 'hot veerleken', 'hot-veerleken', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Hot Veerleken') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Avanza con Costanza', 'avanza con costanza', 'avanza-con-costanza', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Avanza con Costanza') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Happy seratonin', 'happy seratonin', 'happy-seratonin', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Happy seratonin') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '#metoo', '#metoo', 'metoo', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('#metoo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ogliastroman', 'ogliastroman', 'ogliastroman', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ogliastroman') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The yellow king', 'the yellow king', 'the-yellow-king', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The yellow king') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Major Tom', 'major tom', 'major-tom', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Major Tom') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sgt. Hartman', 'sgt. hartman', 'sgt-hartman', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sgt. Hartman') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sylviaster Stallone', 'sylviaster stallone', 'sylviaster-stallone', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sylviaster Stallone') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ground control', 'ground control', 'ground-control', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ground control') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Corner job', 'corner job', 'corner-job', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Corner job') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Kakbroekchef', 'kakbroekchef', 'kakbroekchef', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Kakbroekchef') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'I love bolting', 'i love bolting', 'i-love-bolting', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('I love bolting') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cometè L1', 'comete l1', 'comete-l1', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cometè L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cometè L2', 'comete l2', 'comete-l2', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cometè L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Wallhalla', 'wallhalla', 'wallhalla', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Wallhalla') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Le molle della vita', 'le molle della vita', 'le-molle-della-vita', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Le molle della vita') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Korala', 'korala', 'korala', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Korala') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Luck Lucy', 'luck lucy', 'luck-lucy', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Luck Lucy') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Furto allo stato', 'furto allo stato', 'furto-allo-stato', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Furto allo stato') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Juntos L1', 'juntos l1', 'juntos-l1', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Juntos L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Juntos L2', 'juntos l2', 'juntos-l2', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Juntos L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Juntos L3', 'juntos l3', 'juntos-l3', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Juntos L3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Juntos L4', 'juntos l4', 'juntos-l4', '3a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Juntos L4') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pota tasinantable', 'pota tasinantable', 'pota-tasinantable', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pota tasinantable') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Action indirect', 'action indirect', 'action-indirect', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Action indirect') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fessura Gangialf', 'fessura gangialf', 'fessura-gangialf', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fessura Gangialf') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Reddito di cittadinanza', 'reddito di cittadinanza', 'reddito-di-cittadinanza', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Reddito di cittadinanza') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fagiolo magico', 'fagiolo magico', 'fagiolo-magico', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fagiolo magico') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Punkabestia', 'punkabestia', 'punkabestia', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Punkabestia') AND sector_id = v_sector_id);

  -- Settore: Su Fundu
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Su Fundu') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Su Fundu', 'su fundu', 'su-fundu', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Two jolly young goats', 'two jolly young goats', 'two-jolly-young-goats', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Two jolly young goats') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'C&A', 'c&a', 'c-a', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('C&A') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Momentum', 'momentum', 'momentum', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Momentum') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Via dei piu cento', 'via dei piu cento', 'via-dei-piu-cento', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Via dei piu cento') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Porcahontas', 'porcahontas', 'porcahontas', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Porcahontas') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Scoiattolo verzaschese', 'scoiattolo verzaschese', 'scoiattolo-verzaschese', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Scoiattolo verzaschese') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La mossa del fuorigioco', 'la mossa del fuorigioco', 'la-mossa-del-fuorigioco', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La mossa del fuorigioco') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Amore mio', 'amore mio', 'amore-mio', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Amore mio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Aleci', 'aleci', 'aleci', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Aleci') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Luka', 'luka', 'luka', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Luka') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Unting', 'unting', 'unting', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Unting') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Deck of 51', 'deck of 51', 'deck-of-51', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Deck of 51') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gloria', 'gloria', 'gloria', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gloria') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mira', 'mira', 'mira', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mira') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Capezzoli al cielo', 'capezzoli al cielo', 'capezzoli-al-cielo', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Capezzoli al cielo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dammi il cinque', 'dammi il cinque', 'dammi-il-cinque', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dammi il cinque') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dev''essere la colpa del karma', 'dev''essere la colpa del karma', 'dev-essere-la-colpa-del-karma', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dev''essere la colpa del karma') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sei forte papa', 'sei forte papa', 'sei-forte-papa', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sei forte papa') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Scirocco', 'scirocco', 'scirocco', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Scirocco') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Flapjack', 'flapjack', 'flapjack', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Flapjack') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'V10 people', 'v10 people', 'v10-people', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('V10 people') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Jan Steentjes L1', 'jan steentjes l1', 'jan-steentjes-l1', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Jan Steentjes L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Jan Steentjes L1+L2', 'jan steentjes l1+l2', 'jan-steentjes-l1-l2', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Jan Steentjes L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nobody''s perfect to me L1', 'nobody''s perfect to me l1', 'nobody-s-perfect-to-me-l1', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nobody''s perfect to me L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nobody''s perfect to me L1+L2', 'nobody''s perfect to me l1+l2', 'nobody-s-perfect-to-me-l1-l2', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nobody''s perfect to me L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The birthday party L1', 'the birthday party l1', 'the-birthday-party-l1', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The birthday party L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The birthday party L1+L2', 'the birthday party l1+l2', 'the-birthday-party-l1-l2', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The birthday party L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dreadnaughtus L1', 'dreadnaughtus l1', 'dreadnaughtus-l1', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dreadnaughtus L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dreadnaughtus L1+L2', 'dreadnaughtus l1+l2', 'dreadnaughtus-l1-l2', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dreadnaughtus L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Roccodomo', 'roccodomo', 'roccodomo', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Roccodomo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Because I''m Batman', 'because i''m batman', 'because-i-m-batman', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Because I''m Batman') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Principessa guerriera', 'principessa guerriera', 'principessa-guerriera', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Principessa guerriera') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fanalista', 'fanalista', 'fanalista', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fanalista') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tom tom', 'tom tom', 'tom-tom', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tom tom') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '"free it = name it"', '"free it = name it"', 'free-it-name-it', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('"free it = name it"') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Balls of steel', 'balls of steel', 'balls-of-steel', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Balls of steel') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Steel fingers', 'steel fingers', 'steel-fingers', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Steel fingers') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bianco nero', 'bianco nero', 'bianco-nero', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bianco nero') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Grappa di Vincenzo', 'grappa di vincenzo', 'grappa-di-vincenzo', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Grappa di Vincenzo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Curly Wurly', 'curly wurly', 'curly-wurly', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Curly Wurly') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Boys don''t cry', 'boys don''t cry', 'boys-don-t-cry', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Boys don''t cry') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rochefort 12', 'rochefort 12', 'rochefort-12', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rochefort 12') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il giorne delle firme', 'il giorne delle firme', 'il-giorne-delle-firme', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il giorne delle firme') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gioia armata', 'gioia armata', 'gioia-armata', '8b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gioia armata') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Centenaria Jolien', 'centenaria jolien', 'centenaria-jolien', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Centenaria Jolien') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Crag dominator', 'crag dominator', 'crag-dominator', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Crag dominator') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Crag director', 'crag director', 'crag-director', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Crag director') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Teardrops in paradise', 'teardrops in paradise', 'teardrops-in-paradise', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Teardrops in paradise') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Havoc & Rufus', 'havoc & rufus', 'havoc-rufus', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Havoc & Rufus') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sus''pense', 'sus''pense', 'sus-pense', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sus''pense') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tales of sus''pense', 'tales of sus''pense', 'tales-of-sus-pense', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tales of sus''pense') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tales of the rocking lizard', 'tales of the rocking lizard', 'tales-of-the-rocking-lizard', '8c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tales of the rocking lizard') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il padrino di Tara', 'il padrino di tara', 'il-padrino-di-tara', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il padrino di Tara') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Falkor', 'falkor', 'falkor', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Falkor') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Leaving on a jet plane', 'leaving on a jet plane', 'leaving-on-a-jet-plane', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Leaving on a jet plane') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nudo e crudo', 'nudo e crudo', 'nudo-e-crudo', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nudo e crudo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'T-rex', 't-rex', 't-rex', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('T-rex') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Helejulia', 'helejulia', 'helejulia', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Helejulia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The kitchen sink', 'the kitchen sink', 'the-kitchen-sink', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The kitchen sink') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sletjetrek', 'sletjetrek', 'sletjetrek', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sletjetrek') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rhynoplasty', 'rhynoplasty', 'rhynoplasty', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rhynoplasty') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Riebedebie L1', 'riebedebie l1', 'riebedebie-l1', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Riebedebie L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Riebedebie L1+L2', 'riebedebie l1+l2', 'riebedebie-l1-l2', '8b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Riebedebie L1+L2') AND sector_id = v_sector_id);

  -- Settore: The Cave Theleme
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('The Cave Theleme') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('The Cave Theleme', 'the cave theleme', 'the-cave-theleme', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gargantua', 'gargantua', 'gargantua', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gargantua') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pantagruel', 'pantagruel', 'pantagruel', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pantagruel') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Spike', 'spike', 'spike', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Spike') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Al sapore di rosmarino', 'al sapore di rosmarino', 'al-sapore-di-rosmarino', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Al sapore di rosmarino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bacbuc', 'bacbuc', 'bacbuc', '7b+/7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bacbuc') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Charlie', 'charlie', 'charlie', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Charlie') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'a-Misc', 'a-misc', 'a-misc', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('a-Misc') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The cave Theleme', 'the cave theleme', 'the-cave-theleme', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The cave Theleme') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Harlock', 'harlock', 'harlock', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Harlock') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mimi', 'mimi', 'mimi', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mimi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gordo', 'gordo', 'gordo', '7a+/7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gordo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il ritorno del GPM', 'il ritorno del gpm', 'il-ritorno-del-gpm', '6b+/6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il ritorno del GPM') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The nose', 'the nose', 'the-nose', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The nose') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Brother Boi', 'brother boi', 'brother-boi', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Brother Boi') AND sector_id = v_sector_id);

  -- Settore: The Frame
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('The Frame') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('The Frame', 'the frame', 'the-frame', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Andy Warhol', 'andy warhol', 'andy-warhol', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Andy Warhol') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pollock', 'pollock', 'pollock', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pollock') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Turner', 'turner', 'turner', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Turner') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cézanne', 'cezanne', 'cezanne', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cézanne') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Kandinsky', 'kandinsky', 'kandinsky', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Kandinsky') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Picasso', 'picasso', 'picasso', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Picasso') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Artemisia Gentileschi', 'artemisia gentileschi', 'artemisia-gentileschi', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Artemisia Gentileschi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Klimt', 'klimt', 'klimt', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Klimt') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mirò', 'miro', 'miro', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mirò') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'William Blake', 'william blake', 'william-blake', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('William Blake') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gauguin', 'gauguin', 'gauguin', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gauguin') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Frida Kahlo', 'frida kahlo', 'frida-kahlo', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Frida Kahlo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Caravaggio', 'caravaggio', 'caravaggio', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Caravaggio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Maria Lai', 'maria lai', 'maria-lai', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Maria Lai') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Goya', 'goya', 'goya', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Goya') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Foiso Fois', 'foiso fois', 'foiso-fois', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Foiso Fois') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Leonardo', 'leonardo', 'leonardo', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Leonardo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nivola', 'nivola', 'nivola', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nivola') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ligabue', 'ligabue', 'ligabue', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ligabue') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Escher', 'escher', 'escher', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Escher') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Paul Klee', 'paul klee', 'paul-klee', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Paul Klee') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Botticelli', 'botticelli', 'botticelli', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Botticelli') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mondrian', 'mondrian', 'mondrian', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mondrian') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Van Gogh', 'van gogh', 'van-gogh', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Van Gogh') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Salvador Dalì', 'salvador dali', 'salvador-dali', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Salvador Dalì') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Banksy', 'banksy', 'banksy', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Banksy') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sciola', 'sciola', 'sciola', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sciola') AND sector_id = v_sector_id);

  -- Settore: Torre dei Venti
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Torre dei Venti') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Torre dei Venti', 'torre dei venti', 'torre-dei-venti', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tenendo per mano il sole', 'tenendo per mano il sole', 'tenendo-per-mano-il-sole', '5c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tenendo per mano il sole') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Catturando spiritelli', 'catturando spiritelli', 'catturando-spiritelli', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Catturando spiritelli') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Diario intimo L1', 'diario intimo l1', 'diario-intimo-l1', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Diario intimo L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Diario intimo L1+L2', 'diario intimo l1+l2', 'diario-intimo-l1-l2', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Diario intimo L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Utopia', 'utopia', 'utopia', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Utopia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''ala del vento', 'l''ala del vento', 'l-ala-del-vento', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''ala del vento') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tenendo per mano l''ombra', 'tenendo per mano l''ombra', 'tenendo-per-mano-l-ombra', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tenendo per mano l''ombra') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'All''orizzonte azzurro', 'all''orizzonte azzurro', 'all-orizzonte-azzurro', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('All''orizzonte azzurro') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Al variar della luna', 'al variar della luna', 'al-variar-della-luna', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Al variar della luna') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ansia d''infinito', 'ansia d''infinito', 'ansia-d-infinito', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ansia d''infinito') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Maria Pietra L1', 'maria pietra l1', 'maria-pietra-l1', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Maria Pietra L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Maria Pietra L1+L2', 'maria pietra l1+l2', 'maria-pietra-l1-l2', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Maria Pietra L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Misurando l''infinito', 'misurando l''infinito', 'misurando-l-infinito', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Misurando l''infinito') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Le parole prigioniere', 'le parole prigioniere', 'le-parole-prigioniere', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Le parole prigioniere') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Filando stupore nel cielo L1', 'filando stupore nel cielo l1', 'filando-stupore-nel-cielo-l1', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Filando stupore nel cielo L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Filando stupore nel cielo L1+L2', 'filando stupore nel cielo l1+l2', 'filando-stupore-nel-cielo-l1-l2', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Filando stupore nel cielo L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lo scialle della luna', 'lo scialle della luna', 'lo-scialle-della-luna', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lo scialle della luna') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'In vista di altri cieli', 'in vista di altri cieli', 'in-vista-di-altri-cieli', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('In vista di altri cieli') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ricucire il mondo', 'ricucire il mondo', 'ricucire-il-mondo', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ricucire il mondo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La vela del cielo', 'la vela del cielo', 'la-vela-del-cielo', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La vela del cielo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il mondo incandescente', 'il mondo incandescente', 'il-mondo-incandescente', '8b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il mondo incandescente') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mondo in fuga', 'mondo in fuga', 'mondo-in-fuga', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mondo in fuga') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Geografia', 'geografia', 'geografia', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Geografia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cuore mio', 'cuore mio', 'cuore-mio', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cuore mio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fiabe intrecciate', 'fiabe intrecciate', 'fiabe-intrecciate', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fiabe intrecciate') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mappa celeste', 'mappa celeste', 'mappa-celeste', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mappa celeste') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Foglie di memoria', 'foglie di memoria', 'foglie-di-memoria', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Foglie di memoria') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Quanti mari navigare', 'quanti mari navigare', 'quanti-mari-navigare', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Quanti mari navigare') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Curiosape', 'curiosape', 'curiosape', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Curiosape') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La fuga della capretta', 'la fuga della capretta', 'la-fuga-della-capretta', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La fuga della capretta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il sasso', 'il sasso', 'il-sasso', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il sasso') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il volo dell''oca', 'il volo dell''oca', 'il-volo-dell-oca', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il volo dell''oca') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Creando spazi nuovi', 'creando spazi nuovi', 'creando-spazi-nuovi', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Creando spazi nuovi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Errando', 'errando', 'errando', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Errando') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Un filo nella notte L1', 'un filo nella notte l1', 'un-filo-nella-notte-l1', '5b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Un filo nella notte L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Un filo nella notte L1+L2', 'un filo nella notte l1+l2', 'un-filo-nella-notte-l1-l2', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Un filo nella notte L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Robusta anima mia', 'robusta anima mia', 'robusta-anima-mia', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Robusta anima mia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La casa delle inquietudini', 'la casa delle inquietudini', 'la-casa-delle-inquietudini', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La casa delle inquietudini') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sole scucito', 'sole scucito', 'sole-scucito', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sole scucito') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Un mondo di trame', 'un mondo di trame', 'un-mondo-di-trame', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Un mondo di trame') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dal segno allo spazio', 'dal segno allo spazio', 'dal-segno-allo-spazio', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dal segno allo spazio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dal pane al sasso', 'dal pane al sasso', 'dal-pane-al-sasso', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dal pane al sasso') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La notte dei mondi scuciti', 'la notte dei mondi scuciti', 'la-notte-dei-mondi-scuciti', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La notte dei mondi scuciti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Storia universale', 'storia universale', 'storia-universale', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Storia universale') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Verde coprente', 'verde coprente', 'verde-coprente', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Verde coprente') AND sector_id = v_sector_id);

  -- Settore: Vivendum
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Vivendum') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Vivendum', 'vivendum', 'vivendum', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Calypso Queen', 'calypso queen', 'calypso-queen', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Calypso Queen') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ho munto come il porco', 'ho munto come il porco', 'ho-munto-come-il-porco', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ho munto come il porco') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fottonica', 'fottonica', 'fottonica', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fottonica') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Una via Donato', 'una via donato', 'una-via-donato', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Una via Donato') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Kip', 'kip', 'kip', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Kip') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cut the balls', 'cut the balls', 'cut-the-balls', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cut the balls') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Astamborra', 'astamborra', 'astamborra', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Astamborra') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Minca se stamborra', 'minca se stamborra', 'minca-se-stamborra', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Minca se stamborra') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fingers in the dark', 'fingers in the dark', 'fingers-in-the-dark', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fingers in the dark') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il ritorno del filobus', 'il ritorno del filobus', 'il-ritorno-del-filobus', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il ritorno del filobus') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Grow treviglio', 'grow treviglio', 'grow-treviglio', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Grow treviglio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Jump around', 'jump around', 'jump-around', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Jump around') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Jah Jah city', 'jah jah city', 'jah-jah-city', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Jah Jah city') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'A sollazzare tra i monti', 'a sollazzare tra i monti', 'a-sollazzare-tra-i-monti', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('A sollazzare tra i monti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The Flokes van story', 'the flokes van story', 'the-flokes-van-story', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The Flokes van story') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Huara guat', 'huara guat', 'huara-guat', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Huara guat') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Acazzimma', 'acazzimma', 'acazzimma', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Acazzimma') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sargente Nathan', 'sargente nathan', 'sargente-nathan', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sargente Nathan') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Vanity fair', 'vanity fair', 'vanity-fair', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Vanity fair') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dark krystal', 'dark krystal', 'dark-krystal', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dark krystal') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Effetto edera', 'effetto edera', 'effetto-edera', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Effetto edera') AND sector_id = v_sector_id);

  -- Settore: Wallstreet
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Wallstreet') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Wallstreet', 'wallstreet', 'wallstreet', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'K3', 'k3', 'k3', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('K3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La proposta', 'la proposta', 'la-proposta', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La proposta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tilda', 'tilda', 'tilda', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tilda') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Le vent nous portera', 'le vent nous portera', 'le-vent-nous-portera', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Le vent nous portera') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tunderpoo', 'tunderpoo', 'tunderpoo', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tunderpoo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''alpinista', 'l''alpinista', 'l-alpinista', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''alpinista') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Wilf', 'wilf', 'wilf', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Wilf') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Grazie tante nonnine', 'grazie tante nonnine', 'grazie-tante-nonnine', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Grazie tante nonnine') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bellirisima', 'bellirisima', 'bellirisima', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bellirisima') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Stoneman', 'stoneman', 'stoneman', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Stoneman') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Slow pilot', 'slow pilot', 'slow-pilot', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Slow pilot') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lorelei', 'lorelei', 'lorelei', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lorelei') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Wallstreet of Antwerp', 'wallstreet of antwerp', 'wallstreet-of-antwerp', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Wallstreet of Antwerp') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Beefy', 'beefy', 'beefy', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Beefy') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Quicky and the beast', 'quicky and the beast', 'quicky-and-the-beast', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Quicky and the beast') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The wolf L1', 'the wolf l1', 'the-wolf-l1', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The wolf L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The wolf L1+L2', 'the wolf l1+l2', 'the-wolf-l1-l2', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The wolf L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Arezu', 'arezu', 'arezu', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Arezu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The lonely shephard', 'the lonely shephard', 'the-lonely-shephard', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The lonely shephard') AND sector_id = v_sector_id);

  -- ── Ussassai (Sardegna) ──
  SELECT id INTO v_crag_id FROM crags
    WHERE lower(name) = lower('Ussassai')
      AND region_id = '00000000-0000-0000-0002-000000000014' LIMIT 1;
  IF v_crag_id IS NULL THEN
    -- Also check crags without region_id (from previous imports)
    SELECT id INTO v_crag_id FROM crags
      WHERE lower(name) = lower('Ussassai') AND region_id IS NULL LIMIT 1;
    IF v_crag_id IS NOT NULL THEN
      UPDATE crags SET region_id = '00000000-0000-0000-0002-000000000014', country_id = '00000000-0000-0000-0001-000000000001',
        region = 'Sardegna', province = 'Nuoro',
        municipality = NULL
      WHERE id = v_crag_id;
    ELSE
      INSERT INTO crags (name, normalized_name, slug, country, country_id, region, region_id, province, municipality, access_status, rainproof, services, aliases)
      VALUES ('Ussassai', 'ussassai', 'ussassai',
              'Italy', '00000000-0000-0000-0001-000000000001', 'Sardegna', '00000000-0000-0000-0002-000000000014',
              'Nuoro', NULL, 'open', false, '{}', '{}')
      RETURNING id INTO v_crag_id;
    END IF;
  END IF;

  -- Settore: Fundu 'e s'unturgiu
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Fundu ''e s''unturgiu') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Fundu ''e s''unturgiu', 'fundu ''e s''unturgiu', 'fundu-e-s-unturgiu', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Gli altri', 'gli altri', 'gli-altri', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Gli altri') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ragione e sentimento', 'ragione e sentimento', 'ragione-e-sentimento', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ragione e sentimento') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Esodo', 'esodo', 'esodo', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Esodo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Coso', 'coso', 'coso', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Coso') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The Swan', 'the swan', 'the-swan', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The Swan') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''inizio della fine', 'l''inizio della fine', 'l-inizio-della-fine', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''inizio della fine') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Déjà vu', 'deja vu', 'deja-vu', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Déjà vu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sayid', 'sayid', 'sayid', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sayid') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Ben', 'ben', 'ben', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Ben') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sawyer', 'sawyer', 'sawyer', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sawyer') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La costante', 'la costante', 'la-costante', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La costante') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tre minuti', 'tre minuti', 'tre-minuti', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tre minuti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Piccolo Aaron', 'piccolo aaron', 'piccolo-aaron', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Piccolo Aaron') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Volo 815', 'volo 815', 'volo-815', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Volo 815') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Katelegs', 'katelegs', 'katelegs', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Katelegs') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fumonero', 'fumonero', 'fumonero', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fumonero') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mister Eko', 'mister eko', 'mister-eko', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mister Eko') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Jacob', 'jacob', 'jacob', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Jacob') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Flashforward', 'flashforward', 'flashforward', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Flashforward') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sequenza numerica', 'sequenza numerica', 'sequenza-numerica', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sequenza numerica') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Kahana', 'kahana', 'kahana', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Kahana') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Barrette apollo', 'barrette apollo', 'barrette-apollo', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Barrette apollo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Roccianera', 'roccianera', 'roccianera', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Roccianera') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'L''equazione di Valenzetti', 'l''equazione di valenzetti', 'l-equazione-di-valenzetti', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('L''equazione di Valenzetti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Jack Shephard', 'jack shephard', 'jack-shephard', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Jack Shephard') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'John Locke', 'john locke', 'john-locke', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('John Locke') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Oceanic Six', 'oceanic six', 'oceanic-six', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Oceanic Six') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Dharma', 'dharma', 'dharma', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Dharma') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Hurley', 'hurley', 'hurley', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Hurley') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Timeline', 'timeline', 'timeline', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Timeline') AND sector_id = v_sector_id);

  -- Settore: Guglie di Niala
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Guglie di Niala') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Guglie di Niala', 'guglie di niala', 'guglie-di-niala', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', NULL, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Far Est Story L1', 'far est story l1', 'far-est-story-l1', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Far Est Story L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Far Est Story L2', 'far est story l2', 'far-est-story-l2', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Far Est Story L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Far Est Story L3', 'far est story l3', 'far-est-story-l3', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Far Est Story L3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Far Est Story L4', 'far est story l4', 'far-est-story-l4', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Far Est Story L4') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tacchi a spillo L1', 'tacchi a spillo l1', 'tacchi-a-spillo-l1', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tacchi a spillo L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tacchi a spillo L2', 'tacchi a spillo l2', 'tacchi-a-spillo-l2', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tacchi a spillo L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tacchi a spillo L3', 'tacchi a spillo l3', 'tacchi-a-spillo-l3', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tacchi a spillo L3') AND sector_id = v_sector_id);

  -- Settore: Irtzioni
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Irtzioni') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Irtzioni', 'irtzioni', 'irtzioni', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Trempa orrubia', 'trempa orrubia', 'trempa-orrubia', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Trempa orrubia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mela ferru', 'mela ferru', 'mela-ferru', '5b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mela ferru') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Civargiu', 'civargiu', 'civargiu', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Civargiu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sartissu', 'sartissu', 'sartissu', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sartissu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Presuttu', 'presuttu', 'presuttu', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Presuttu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Marandula', 'marandula', 'marandula', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Marandula') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Casuagedu', 'casuagedu', 'casuagedu', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Casuagedu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Coccoi prena', 'coccoi prena', 'coccoi-prena', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Coccoi prena') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Strippidi', 'strippidi', 'strippidi', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Strippidi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Culurgioni L1', 'culurgioni l1', 'culurgioni-l1', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Culurgioni L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Culurgioni L1+L2', 'culurgioni l1+l2', 'culurgioni-l1-l2', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Culurgioni L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Trattalia L1', 'trattalia l1', 'trattalia-l1', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Trattalia L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Trattalia L1+L2', 'trattalia l1+l2', 'trattalia-l1-l2', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Trattalia L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pani indorau', 'pani indorau', 'pani-indorau', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pani indorau') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Orrubiolus', 'orrubiolus', 'orrubiolus', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Orrubiolus') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pira molenti', 'pira molenti', 'pira-molenti', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pira molenti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pira cambusina', 'pira cambusina', 'pira-cambusina', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pira cambusina') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pira coscia', 'pira coscia', 'pira-coscia', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pira coscia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pira buttinu', 'pira buttinu', 'pira-buttinu', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pira buttinu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mela titongia', 'mela titongia', 'mela-titongia', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mela titongia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mel''ogliu', 'mel''ogliu', 'mel-ogliu', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mel''ogliu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pani e saba', 'pani e saba', 'pani-e-saba', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pani e saba') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Erda', 'erda', 'erda', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Erda') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Pani pintau', 'pani pintau', 'pani-pintau', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Pani pintau') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Friga tianu', 'friga tianu', 'friga-tianu', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Friga tianu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Sambineddu', 'sambineddu', 'sambineddu', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Sambineddu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Acuardenti', 'acuardenti', 'acuardenti', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Acuardenti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Brodu di casu', 'brodu di casu', 'brodu-di-casu', '4a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Brodu di casu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Casue fitta L1', 'casue fitta l1', 'casue-fitta-l1', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Casue fitta L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Casue fitta L1+L2', 'casue fitta l1+l2', 'casue-fitta-l1-l2', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Casue fitta L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Casucottu', 'casucottu', 'casucottu', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Casucottu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Capottu', 'capottu', 'capottu', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Capottu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Cagliadeddu', 'cagliadeddu', 'cagliadeddu', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Cagliadeddu') AND sector_id = v_sector_id);

  -- ── Ferentillo (Umbria) ──
  SELECT id INTO v_crag_id FROM crags
    WHERE lower(name) = lower('Ferentillo')
      AND region_id = '00000000-0000-0000-0002-000000000018' LIMIT 1;
  IF v_crag_id IS NULL THEN
    -- Also check crags without region_id (from previous imports)
    SELECT id INTO v_crag_id FROM crags
      WHERE lower(name) = lower('Ferentillo') AND region_id IS NULL LIMIT 1;
    IF v_crag_id IS NOT NULL THEN
      UPDATE crags SET region_id = '00000000-0000-0000-0002-000000000018', country_id = '00000000-0000-0000-0001-000000000001',
        region = 'Umbria', province = 'Terni',
        municipality = NULL
      WHERE id = v_crag_id;
    ELSE
      INSERT INTO crags (name, normalized_name, slug, country, country_id, region, region_id, province, municipality, access_status, rainproof, services, aliases)
      VALUES ('Ferentillo', 'ferentillo', 'ferentillo',
              'Italy', '00000000-0000-0000-0001-000000000001', 'Umbria', '00000000-0000-0000-0002-000000000018',
              'Terni', NULL, 'open', false, '{}', '{}')
      RETURNING id INTO v_crag_id;
    END IF;
  END IF;

  -- Settore: Gabbio
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Gabbio') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Gabbio', 'gabbio', 'gabbio', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Hey sei', 'hey sei', 'hey-sei', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Hey sei') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Maledetti vi odio', 'maledetti vi odio', 'maledetti-vi-odio', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Maledetti vi odio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Willy Love', 'willy love', 'willy-love', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Willy Love') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Uomo civile', 'uomo civile', 'uomo-civile', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Uomo civile') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Portatore di tempesta', 'portatore di tempesta', 'portatore-di-tempesta', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Portatore di tempesta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'So Sexi', 'so sexi', 'so-sexi', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('So Sexi') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Die Hard', 'die hard', 'die-hard', '8c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Die Hard') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Totem', 'totem', 'totem', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Totem') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Corvo morto', 'corvo morto', 'corvo-morto', '8c+/9a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Corvo morto') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il corvo', 'il corvo', 'il-corvo', '8c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il corvo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Malkuth', 'malkuth', 'malkuth', '9a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Malkuth') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Jorgao', 'jorgao', 'jorgao', '8b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Jorgao') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Kether', 'kether', 'kether', '8c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Kether') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La danza dei dervisci', 'la danza dei dervisci', 'la-danza-dei-dervisci', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La danza dei dervisci') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Capriccio', 'capriccio', 'capriccio', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Capriccio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Nel buio', 'nel buio', 'nel-buio', '8b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Nel buio') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT '12', '12', '12', '8c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('12') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Calvizia', 'calvizia', 'calvizia', '7c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Calvizia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Troppa informazione', 'troppa informazione', 'troppa-informazione', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Troppa informazione') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Linea Sottiletta', 'linea sottiletta', 'linea-sottiletta', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Linea Sottiletta') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il sentiero dei giganti', 'il sentiero dei giganti', 'il-sentiero-dei-giganti', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il sentiero dei giganti') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bombardamentos L1', 'bombardamentos l1', 'bombardamentos-l1', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bombardamentos L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Bombardamentos L1+L2', 'bombardamentos l1+l2', 'bombardamentos-l1-l2', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Bombardamentos L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La Maro del Pepi L1+L2', 'la maro del pepi l1+l2', 'la-maro-del-pepi-l1-l2', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La Maro del Pepi L1+L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Alfredo Alfredo L1', 'alfredo alfredo l1', 'alfredo-alfredo-l1', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Alfredo Alfredo L1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Black panthers L2', 'black panthers l2', 'black-panthers-l2', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Black panthers L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'In un giorno di pioggia L2', 'in un giorno di pioggia l2', 'in-un-giorno-di-pioggia-l2', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('In un giorno di pioggia L2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Polpastrillo', 'polpastrillo', 'polpastrillo', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Polpastrillo') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tex mex', 'tex mex', 'tex-mex', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tex mex') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Zambia - Italia 4-0', 'zambia - italia 4-0', 'zambia-italia-4-0', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Zambia - Italia 4-0') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Lo spigolo delle streghe', 'lo spigolo delle streghe', 'lo-spigolo-delle-streghe', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Lo spigolo delle streghe') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Viva Cuba', 'viva cuba', 'viva-cuba', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Viva Cuba') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', '8a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Romeo 89', 'romeo 89', 'romeo-89', '7a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Romeo 89') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il morbo di Ciato', 'il morbo di ciato', 'il-morbo-di-ciato', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il morbo di Ciato') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mandela superstar', 'mandela superstar', 'mandela-superstar', '8a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mandela superstar') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'The chinese way', 'the chinese way', 'the-chinese-way', '7b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('The chinese way') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Prosciuttini', 'prosciuttini', 'prosciuttini', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Prosciuttini') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Donne in amore', 'donne in amore', 'donne-in-amore', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Donne in amore') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Rock a gay''n', 'rock a gay''n', 'rock-a-gay-n', '6c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Rock a gay''n') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Mumble mumble', 'mumble mumble', 'mumble-mumble', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Mumble mumble') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Hare krisna', 'hare krisna', 'hare-krisna', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Hare krisna') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Yuk baluk', 'yuk baluk', 'yuk-baluk', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Yuk baluk') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fragole e sangue', 'fragole e sangue', 'fragole-e-sangue', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fragole e sangue') AND sector_id = v_sector_id);

  -- ── Miollet (Valle d'Aosta) ──
  SELECT id INTO v_crag_id FROM crags
    WHERE lower(name) = lower('Miollet')
      AND region_id = '00000000-0000-0000-0002-000000000019' LIMIT 1;
  IF v_crag_id IS NULL THEN
    -- Also check crags without region_id (from previous imports)
    SELECT id INTO v_crag_id FROM crags
      WHERE lower(name) = lower('Miollet') AND region_id IS NULL LIMIT 1;
    IF v_crag_id IS NOT NULL THEN
      UPDATE crags SET region_id = '00000000-0000-0000-0002-000000000019', country_id = '00000000-0000-0000-0001-000000000001',
        region = 'Valle d''Aosta', province = 'Aosta',
        municipality = 'Valgrisenche'
      WHERE id = v_crag_id;
    ELSE
      INSERT INTO crags (name, normalized_name, slug, country, country_id, region, region_id, province, municipality, access_status, rainproof, services, aliases)
      VALUES ('Miollet', 'miollet', 'miollet',
              'Italy', '00000000-0000-0000-0001-000000000001', 'Valle d''Aosta', '00000000-0000-0000-0002-000000000019',
              'Aosta', 'Valgrisenche', 'open', false, '{}', '{}')
      RETURNING id INTO v_crag_id;
    END IF;
  END IF;

  -- Settore: Destro
  SELECT id INTO v_sector_id FROM sectors
    WHERE lower(name) = lower('Destro') AND crag_id = v_crag_id LIMIT 1;
  IF v_sector_id IS NULL THEN
    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)
    VALUES ('Destro', 'destro', 'destro', v_crag_id, '{}', 0)
    RETURNING id INTO v_sector_id;
  END IF;
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Petolla frolla', 'petolla frolla', 'petolla-frolla', '7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Petolla frolla') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Masterplax', 'masterplax', 'masterplax', '6c+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Masterplax') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Tot dret', 'tot dret', 'tot-dret', '6b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Tot dret') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La ciociara', 'la ciociara', 'la-ciociara', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La ciociara') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Harborea', 'harborea', 'harborea', '7b+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Harborea') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Acquargento', 'acquargento', 'acquargento', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Acquargento') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 1', 'senza nome 1', 'senza-nome-1', '7b+/7c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 1') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Déjà vu', 'deja vu', 'deja-vu', '7a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Déjà vu') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Il porco', 'il porco', 'il-porco', '6b', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Il porco') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La maiala', 'la maiala', 'la-maiala', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La maiala') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Fessurino', 'fessurino', 'fessurino', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Fessurino') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Intifada', 'intifada', 'intifada', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Intifada') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Salonicco', 'salonicco', 'salonicco', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Salonicco') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'La sfera', 'la sfera', 'la-sfera', '6a', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('La sfera') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Infernalia', 'infernalia', 'infernalia', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Infernalia') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 2', 'senza nome 2', 'senza-nome-2', '6a+', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 2') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 3', 'senza nome 3', 'senza-nome-3', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 3') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 4', 'senza nome 4', 'senza-nome-4', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 4') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 5', 'senza nome 5', 'senza-nome-5', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 5') AND sector_id = v_sector_id);
  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)
  SELECT 'Senza nome 6', 'senza nome 6', 'senza-nome-6', '5c', v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'
  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower('Senza nome 6') AND sector_id = v_sector_id);

END $$;

-- Summary: 15 crags, 54 sectors, 1979 routes
