-- Add FBOs for KTEB (Teterboro Airport)
DO $$ 
BEGIN
  -- First ensure KTEB exists with correct data
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  VALUES (
    'KTEB',
    'Teterboro Airport',
    'NJ',
    'United States',
    'North America',
    40.8501,
    -74.0608
  )
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    state = EXCLUDED.state,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

  -- Add FBO locations
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country, state)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'USA',
    'NJ'
  FROM (
    VALUES 
      ('Meridian Teterboro', 40.8501, -74.0608, '485 Industrial Ave, Teterboro, NJ 07608'),
      ('Signature Flight Support TEB North', 40.8515, -74.0612, '101 Charles A. Lindbergh Dr, Teterboro, NJ 07608'),
      ('Signature Flight Support TEB South', 40.8485, -74.0605, '200 Fred Wehran Dr, Teterboro, NJ 07608'),
      ('Atlantic Aviation TEB', 40.8508, -74.0615, '220 Industrial Ave, Teterboro, NJ 07608'),
      ('Jet Aviation Teterboro', 40.8492, -74.0600, '112 Charles A. Lindbergh Dr, Teterboro, NJ 07608')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KTEB'
  ) i
  ON CONFLICT DO NOTHING;
END $$;