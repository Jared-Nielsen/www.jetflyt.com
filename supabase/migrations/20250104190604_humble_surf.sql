-- Add Swiss airports and their FBOs
DO $$ 
BEGIN
  -- Insert ICAO codes for Swiss airports
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- Major International
    ('LSZH', 'Zurich Airport', 'Switzerland', 'Europe', 47.4582, 8.5555,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('LSGG', 'Geneva Airport', 'Switzerland', 'Europe', 46.2370, 6.1089,
      (SELECT id FROM icao_types WHERE name = 'major_international')),

    -- International
    ('LSZB', 'Bern Airport', 'Switzerland', 'Europe', 46.9141, 7.4969,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('LSZA', 'Lugano Airport', 'Switzerland', 'Europe', 46.0040, 8.9106,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Regional
    ('LSZR', 'St. Gallen-Altenrhein Airport', 'Switzerland', 'Europe', 47.4850, 9.5607,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('LSZG', 'Grenchen Airport', 'Switzerland', 'Europe', 47.1819, 7.4173,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('LSGS', 'Sion Airport', 'Switzerland', 'Europe', 46.2196, 7.3267,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('LSZC', 'Buochs Airport', 'Switzerland', 'Europe', 46.9745, 8.3997,
      (SELECT id FROM icao_types WHERE name = 'regional')),

    -- General Aviation
    ('LSMD', 'Dubendorf Airport', 'Switzerland', 'Europe', 47.3989, 8.6479,
      (SELECT id FROM icao_types WHERE name = 'general_aviation')),
    ('LSGE', 'Bad Ragaz Airport', 'Switzerland', 'Europe', 47.0167, 9.5000,
      (SELECT id FROM icao_types WHERE name = 'general_aviation')),
    ('LSZL', 'Locarno Airport', 'Switzerland', 'Europe', 46.1608, 8.8787,
      (SELECT id FROM icao_types WHERE name = 'general_aviation')),
    ('LSZT', 'Lommis Airport', 'Switzerland', 'Europe', 47.5244, 9.0061,
      (SELECT id FROM icao_types WHERE name = 'general_aviation'))
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    icao_type_id = EXCLUDED.icao_type_id;

  -- Add FBO locations
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'Switzerland'
  FROM (
    VALUES 
      -- Zurich (LSZH)
      ('Jet Aviation Zurich', 47.4582, 8.5555, 'Business Aviation Center, Zurich Airport', 'Switzerland'),
      ('ExecuJet Zurich', 47.4578, 8.5551, 'General Aviation Center, Zurich Airport', 'Switzerland'),
      ('Cat Aviation', 47.4575, 8.5548, 'Business Aviation Terminal, Zurich Airport', 'Switzerland'),

      -- Geneva (LSGG)
      ('TAG Aviation', 46.2370, 6.1089, 'Terminal C3, Geneva Airport', 'Switzerland'),
      ('Jet Aviation Geneva', 46.2366, 6.1085, 'Executive Terminal, Geneva Airport', 'Switzerland'),
      ('PrivatPort', 46.2363, 6.1082, 'Business Aviation Terminal, Geneva Airport', 'Switzerland'),

      -- Bern (LSZB)
      ('Bern Airport Executive Aviation', 46.9141, 7.4969, 'General Aviation Terminal, Bern Airport', 'Switzerland'),
      ('Sky Services Bern', 46.9137, 7.4965, 'Business Aviation Center, Bern Airport', 'Switzerland'),

      -- Lugano (LSZA)
      ('Lugano Airport Services', 46.0040, 8.9106, 'General Aviation Terminal, Lugano Airport', 'Switzerland'),
      ('Lugano Executive Aviation', 46.0036, 8.9102, 'Business Aviation Center, Lugano Airport', 'Switzerland')
  ) as fbo(name, latitude, longitude, address, country)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'LSZH', 'LSGG', 'LSZB', 'LSZA'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%Zurich%' THEN 'LSZH'
      WHEN fbo.name LIKE '%Geneva%' OR fbo.name LIKE '%TAG%' OR fbo.name LIKE '%PrivatPort%' THEN 'LSGG'
      WHEN fbo.name LIKE '%Bern%' THEN 'LSZB'
      WHEN fbo.name LIKE '%Lugano%' THEN 'LSZA'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;