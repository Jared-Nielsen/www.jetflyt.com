-- Add European airports and their FBOs
DO $$ 
BEGIN
  -- Insert ICAO codes for major international hubs
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- United Kingdom Major Hubs
    ('EGLL', 'London Heathrow Airport', 'United Kingdom', 'Europe', 51.4700, -0.4543,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('EGKK', 'London Gatwick Airport', 'United Kingdom', 'Europe', 51.1537, -0.1821,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('EGCC', 'Manchester Airport', 'United Kingdom', 'Europe', 53.3537, -2.2750,
      (SELECT id FROM icao_types WHERE name = 'major_international')),

    -- France Major Hubs
    ('LFPG', 'Paris Charles de Gaulle Airport', 'France', 'Europe', 49.0097, 2.5478,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('LFPO', 'Paris Orly Airport', 'France', 'Europe', 48.7262, 2.3652,
      (SELECT id FROM icao_types WHERE name = 'major_international')),

    -- Spain Major Hubs
    ('LEMD', 'Adolfo Suárez Madrid–Barajas Airport', 'Spain', 'Europe', 40.4983, -3.5676,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('LEBL', 'Barcelona–El Prat Airport', 'Spain', 'Europe', 41.2971, 2.0785,
      (SELECT id FROM icao_types WHERE name = 'major_international'))
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    icao_type_id = EXCLUDED.icao_type_id;

  -- Insert international airports
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- United Kingdom International
    ('EGBB', 'Birmingham Airport', 'United Kingdom', 'Europe', 52.4539, -1.7480,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('EGPH', 'Edinburgh Airport', 'United Kingdom', 'Europe', 55.9500, -3.3725,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('EGGW', 'London Luton Airport', 'United Kingdom', 'Europe', 51.8747, -0.3683,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('EGSS', 'London Stansted Airport', 'United Kingdom', 'Europe', 51.8850, 0.2350,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('EGLC', 'London City Airport', 'United Kingdom', 'Europe', 51.5048, 0.0495,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('EGPF', 'Glasgow Airport', 'United Kingdom', 'Europe', 55.8717, -4.4333,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- France International
    ('LFMN', 'Nice Côte d''Azur Airport', 'France', 'Europe', 43.6584, 7.2159,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('LFLL', 'Lyon Saint-Exupéry Airport', 'France', 'Europe', 45.7256, 5.0811,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('LFML', 'Marseille Provence Airport', 'France', 'Europe', 43.4392, 5.2214,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('LFBD', 'Bordeaux–Mérignac Airport', 'France', 'Europe', 44.8283, -0.7156,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Spain International
    ('LEAL', 'Alicante–Elche Airport', 'Spain', 'Europe', 38.2822, -0.5582,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('LEPA', 'Palma de Mallorca Airport', 'Spain', 'Europe', 39.5517, 2.7388,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('LEMG', 'Málaga Airport', 'Spain', 'Europe', 36.6749, -4.4991,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('LEZL', 'Seville Airport', 'Spain', 'Europe', 37.4180, -5.8932,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Ireland International
    ('EIDW', 'Dublin Airport', 'Ireland', 'Europe', 53.4213, -6.2700,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('EICK', 'Cork Airport', 'Ireland', 'Europe', 51.8413, -8.4911,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('EINN', 'Shannon Airport', 'Ireland', 'Europe', 52.7019, -8.9248,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Portugal International
    ('LPPT', 'Lisbon Airport', 'Portugal', 'Europe', 38.7813, -9.1359,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('LPPR', 'Porto Airport', 'Portugal', 'Europe', 41.2481, -8.6814,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('LPFR', 'Faro Airport', 'Portugal', 'Europe', 37.0144, -7.9659,
      (SELECT id FROM icao_types WHERE name = 'international'))
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
    fbo.country
  FROM (
    VALUES 
      -- London Heathrow (EGLL)
      ('Signature Flight Support LHR', 51.4700, -0.4543, 'Terminal 3, Heathrow Airport', 'United Kingdom'),
      ('Universal Aviation LHR', 51.4695, -0.4540, 'Building 604, Sandringham Road', 'United Kingdom'),
      ('Jet Aviation LHR', 51.4690, -0.4535, 'Building 578, Southern Perimeter Road', 'United Kingdom'),

      -- Paris CDG (LFPG)
      ('Signature Flight Support CDG', 49.0097, 2.5478, 'Zone Aviation Générale, 95700 Roissy-en-France', 'France'),
      ('Universal Aviation CDG', 49.0090, 2.5470, 'Aéroport CDG, Terminal d''Aviation d''Affaires', 'France'),
      ('Advanced Air Support CDG', 49.0085, 2.5465, 'Zone Aviation d''Affaires, Rue de la Belle Borne', 'France'),

      -- Madrid (LEMD)
      ('Executive Aviation MAD', 40.4983, -3.5676, 'Terminal Ejecutiva T1, Aeropuerto Madrid-Barajas', 'Spain'),
      ('Sky Valet MAD', 40.4980, -3.5673, 'Terminal de Aviación Ejecutiva, Madrid-Barajas', 'Spain'),
      ('United Aviation MAD', 40.4977, -3.5670, 'Terminal FBO, Aeropuerto Adolfo Suárez', 'Spain'),

      -- Dublin (EIDW)
      ('Universal Aviation DUB', 53.4213, -6.2700, 'Terminal 1, Dublin Airport', 'Ireland'),
      ('Signature Flight Support DUB', 53.4210, -6.2697, 'General Aviation Terminal, Dublin Airport', 'Ireland'),
      ('Executive Aircraft Services', 53.4207, -6.2694, 'Business Aviation Centre, Dublin Airport', 'Ireland'),

      -- Lisbon (LPPT)
      ('Omni Handling LIS', 38.7813, -9.1359, 'Terminal de Aviação Executiva, Aeroporto de Lisboa', 'Portugal'),
      ('NetJets Europe LIS', 38.7810, -9.1356, 'Terminal VIP, Aeroporto Humberto Delgado', 'Portugal'),
      ('Sky Valet LIS', 38.7807, -9.1353, 'Executive Terminal, Lisbon Airport', 'Portugal')
  ) as fbo(name, latitude, longitude, address, country)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'EGLL', 'LFPG', 'LEMD', 'EIDW', 'LPPT'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%LHR%' THEN 'EGLL'
      WHEN fbo.name LIKE '%CDG%' THEN 'LFPG'
      WHEN fbo.name LIKE '%MAD%' THEN 'LEMD'
      WHEN fbo.name LIKE '%DUB%' OR fbo.name LIKE '%Executive Aircraft%' THEN 'EIDW'
      WHEN fbo.name LIKE '%LIS%' THEN 'LPPT'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;