-- Add FBOs for MMMX (Benito Juárez International Airport)
DO $$ 
BEGIN
  -- First ensure MMMX exists with correct data
  INSERT INTO icaos (code, name, country, continent, latitude, longitude)
  VALUES (
    'MMMX',
    'Benito Juárez International Airport',
    'Mexico',
    'North America',
    19.4363,
    -99.0721
  )
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

  -- Add FBO locations
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'Mexico'
  FROM (
    VALUES 
      ('Jetex MMMX', 19.4363, -99.0721, 'Terminal 2, Zona Federal, Mexico City International Airport'),
      ('Million Air MMMX', 19.4360, -99.0718, 'Hangar 1, Zona de Aviación General'),
      ('Manny Aviation Services', 19.4365, -99.0725, 'Terminal de Aviación General'),
      ('Universal Aviation MMMX', 19.4368, -99.0728, 'Zona de Hangares, Aviación General'),
      ('ASA FBO Services', 19.4370, -99.0730, 'Terminal de Aviación General, AICM')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'MMMX'
  ) i
  ON CONFLICT DO NOTHING;
END $$;