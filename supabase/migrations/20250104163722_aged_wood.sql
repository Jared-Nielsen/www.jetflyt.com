-- Add Jetex FBO locations worldwide
DO $$ 
BEGIN
  -- First ensure all required ICAO codes exist
  INSERT INTO icaos (code, name, country, continent, latitude, longitude)
  VALUES
    -- Europe
    ('LEBL', 'Barcelona–El Prat Airport', 'Spain', 'Europe', 41.2971, 2.0785),
    ('LIRA', 'Rome Ciampino Airport', 'Italy', 'Europe', 41.7994, 12.5949),
    ('LKPR', 'Václav Havel Airport Prague', 'Czech Republic', 'Europe', 50.1008, 14.2600),
    -- Middle East
    ('OBBI', 'Bahrain International Airport', 'Bahrain', 'Asia', 26.2708, 50.6332),
    ('OMAA', 'Abu Dhabi International Airport', 'United Arab Emirates', 'Asia', 24.4441, 54.6511),
    ('OTHH', 'Hamad International Airport', 'Qatar', 'Asia', 25.2731, 51.6081),
    -- Asia
    ('VTBS', 'Suvarnabhumi Airport', 'Thailand', 'Asia', 13.6900, 100.7501),
    ('WMKK', 'Kuala Lumpur International Airport', 'Malaysia', 'Asia', 2.7456, 101.7099)
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

  -- Add Jetex FBO locations
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
      -- Europe
      ('Jetex BCN', 41.2971, 2.0785, 'Terminal Corporativa, El Prat de Llobregat', 'Spain'),
      ('Jetex CIA', 41.7994, 12.5949, 'Via Appia Nuova, 1651, Roma', 'Italy'),
      ('Jetex PRG', 50.1008, 14.2600, 'Terminal 3, Aviatická, Prague', 'Czech Republic'),
      -- Middle East
      ('Jetex BAH', 26.2708, 50.6332, 'Aviation Terminal, Muharraq', 'Bahrain'),
      ('Jetex AUH', 24.4441, 54.6511, 'VIP Terminal, Abu Dhabi International Airport', 'United Arab Emirates'),
      ('Jetex DOH', 25.2731, 51.6081, 'FBO Terminal, Hamad International Airport', 'Qatar'),
      -- Asia
      ('Jetex BKK', 13.6900, 100.7501, 'Private Aviation Terminal, Samut Prakan', 'Thailand'),
      ('Jetex KUL', 2.7456, 101.7099, 'Skypark Regional Aviation Centre, Sepang', 'Malaysia')
  ) as fbo(name, latitude, longitude, address, country)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'LEBL', 'LIRA', 'LKPR', 'OBBI', 'OMAA', 'OTHH', 'VTBS', 'WMKK'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%BCN' THEN 'LEBL'
      WHEN fbo.name LIKE '%CIA' THEN 'LIRA'
      WHEN fbo.name LIKE '%PRG' THEN 'LKPR'
      WHEN fbo.name LIKE '%BAH' THEN 'OBBI'
      WHEN fbo.name LIKE '%AUH' THEN 'OMAA'
      WHEN fbo.name LIKE '%DOH' THEN 'OTHH'
      WHEN fbo.name LIKE '%BKK' THEN 'VTBS'
      WHEN fbo.name LIKE '%KUL' THEN 'WMKK'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;