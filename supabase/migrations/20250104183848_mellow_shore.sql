-- Add Panama City airport and update Tallahassee FBOs
DO $$ 
BEGIN
  -- First ensure Panama City airport exists
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude, icao_type_id)
  VALUES (
    'KECP',
    'Northwest Florida Beaches International Airport',
    'FL',
    'United States',
    'North America',
    30.3571,
    -85.7954,
    (SELECT id FROM icao_types WHERE name = 'regional')
  )
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    state = EXCLUDED.state,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    icao_type_id = EXCLUDED.icao_type_id;

  -- Add FBO locations for Tallahassee (KTLH)
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country, state)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'USA',
    'FL'
  FROM (
    VALUES 
      ('Million Air TLH', 30.3965, -84.3503, '3244 Capital Circle SW, Tallahassee, FL 32310'),
      ('Flightline Group', 30.3960, -84.3498, '3256 Capital Circle SW, Tallahassee, FL 32310'),
      ('Signature Flight Support TLH', 30.3970, -84.3508, '3232 Capital Circle SW, Tallahassee, FL 32310')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KTLH'
  ) i
  ON CONFLICT DO NOTHING;

  -- Add FBO locations for Panama City (KECP)
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country, state)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'USA',
    'FL'
  FROM (
    VALUES 
      ('Sheltair ECP', 30.3571, -85.7954, '5325 Johnny Reaver Rd, Panama City Beach, FL 32409'),
      ('Panama Aviation Center', 30.3575, -85.7950, '5317 Johnny Reaver Rd, Panama City Beach, FL 32409')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KECP'
  ) i
  ON CONFLICT DO NOTHING;
END $$;