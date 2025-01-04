-- Add FBOs for Australian and New Zealand airports
DO $$ 
BEGIN
  -- First ensure all required ICAO codes exist
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  VALUES
    -- Australia
    ('YMML', 'Melbourne Airport', 'VIC', 'Australia', 'Oceania', -37.6690, 144.8410),
    ('YSSY', 'Sydney Kingsford Smith Airport', 'NSW', 'Australia', 'Oceania', -33.9399, 151.1753),
    -- New Zealand
    ('NZCH', 'Christchurch International Airport', NULL, 'New Zealand', 'Oceania', -43.4894, 172.5324),
    ('NZAA', 'Auckland Airport', NULL, 'New Zealand', 'Oceania', -37.0082, 174.7850)
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

  -- Add FBOs for Melbourne (YMML)
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country, state)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'Australia',
    'VIC'
  FROM (
    VALUES 
      ('Jet Aviation Melbourne', -37.6690, 144.8410, 'Terminal Drive, Melbourne Airport VIC 3045'),
      ('Executive Airlines', -37.6685, 144.8405, '13 South Centre Road, Melbourne Airport VIC 3045'),
      ('Air Centre One MEL', -37.6695, 144.8415, 'Level 1, Terminal Drive, Melbourne Airport VIC 3045')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'YMML'
  ) i
  ON CONFLICT DO NOTHING;

  -- Add FBOs for Sydney (YSSY)
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country, state)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'Australia',
    'NSW'
  FROM (
    VALUES 
      ('Execujet Sydney', -33.9399, 151.1753, '2 Ross Smith Ave, Mascot NSW 2020'),
      ('Universal Aviation SYD', -33.9395, 151.1748, '1 Ross Smith Ave, Mascot NSW 2020'),
      ('Jet Aviation Sydney', -33.9390, 151.1745, '3 Ross Smith Ave, Mascot NSW 2020')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'YSSY'
  ) i
  ON CONFLICT DO NOTHING;

  -- Add FBOs for Christchurch (NZCH)
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'New Zealand'
  FROM (
    VALUES 
      ('Garden City Aviation', -43.4894, 172.5324, '73 Durey Road, Christchurch Airport'),
      ('Air Center One CHC', -43.4890, 172.5320, '100 Durey Road, Christchurch Airport')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'NZCH'
  ) i
  ON CONFLICT DO NOTHING;

  -- Add FBOs for Auckland (NZAA)
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'New Zealand'
  FROM (
    VALUES 
      ('Air Center One AKL', -37.0082, 174.7850, '2 Moncur Place, Auckland Airport'),
      ('Jet Aviation Auckland', -37.0078, 174.7845, '8 Saxon Street, Auckland Airport'),
      ('Universal Aviation AKL', -37.0085, 174.7855, '1 Moncur Place, Auckland Airport')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'NZAA'
  ) i
  ON CONFLICT DO NOTHING;
END $$;