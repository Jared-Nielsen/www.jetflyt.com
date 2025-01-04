-- Add Air Center One and ExecuJet FBO locations worldwide
DO $$ 
BEGIN
  -- First ensure all required ICAO codes exist
  INSERT INTO icaos (code, name, country, continent, latitude, longitude)
  VALUES
    -- Air Center One Locations (excluding existing)
    ('NZWN', 'Wellington International Airport', 'New Zealand', 'Oceania', -41.3272, 174.8053),
    ('NZRO', 'Rotorua Airport', 'New Zealand', 'Oceania', -38.1092, 176.3172),
    -- ExecuJet Locations
    ('FACT', 'Cape Town International Airport', 'South Africa', 'Africa', -33.9715, 18.6021),
    ('FAOR', 'O.R. Tambo International Airport', 'South Africa', 'Africa', -26.1325, 28.2424),
    ('YSRI', 'Richmond Airport', 'Australia', 'Oceania', -20.7019, 143.1153),
    ('YMEN', 'Essendon Airport', 'Australia', 'Oceania', -37.7281, 144.9019),
    ('YBCS', 'Cairns Airport', 'Australia', 'Oceania', -16.8858, 145.7555),
    ('YPPH', 'Perth Airport', 'Australia', 'Oceania', -31.9405, 115.9670),
    ('WBSB', 'Brunei International Airport', 'Brunei', 'Asia', 4.9442, 114.9281),
    ('ZBAD', 'Beijing Daxing International Airport', 'China', 'Asia', 39.5098, 116.4105)
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

  -- Add Air Center One locations (excluding existing)
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
      ('Air Center One WLG', -41.3272, 174.8053, '2 Leonard Isitt Drive, Rongotai, Wellington'),
      ('Air Center One ROT', -38.1092, 176.3172, 'Airport Road, Rotorua Airport')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN ('NZWN', 'NZRO')
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%WLG' THEN 'NZWN'
      WHEN fbo.name LIKE '%ROT' THEN 'NZRO'
    END
  )
  ON CONFLICT DO NOTHING;

  -- Add ExecuJet locations
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
      -- Africa
      ('ExecuJet Cape Town', -33.9715, 18.6021, 'General Aviation Area, Cape Town International Airport', 'South Africa'),
      ('ExecuJet Johannesburg', -26.1325, 28.2424, 'Hangar 237, O.R. Tambo International Airport', 'South Africa'),
      -- Australia
      ('ExecuJet Richmond', -20.7019, 143.1153, 'Richmond Airport, Queensland', 'Australia'),
      ('ExecuJet Melbourne-Essendon', -37.7281, 144.9019, '1H York Street, Essendon Fields', 'Australia'),
      ('ExecuJet Cairns', -16.8858, 145.7555, 'General Aviation Terminal, Cairns Airport', 'Australia'),
      ('ExecuJet Perth', -31.9405, 115.9670, '15 Hugh Edwards Drive, Perth Airport', 'Australia'),
      -- Asia
      ('ExecuJet Brunei', 4.9442, 114.9281, 'Business Aviation Centre, Brunei International Airport', 'Brunei'),
      ('ExecuJet Beijing Daxing', 39.5098, 116.4105, 'Business Aviation Terminal, Beijing Daxing International Airport', 'China')
  ) as fbo(name, latitude, longitude, address, country)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'FACT', 'FAOR', 'YSRI', 'YMEN', 'YBCS', 'YPPH', 'WBSB', 'ZBAD'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%Cape Town%' THEN 'FACT'
      WHEN fbo.name LIKE '%Johannesburg%' THEN 'FAOR'
      WHEN fbo.name LIKE '%Richmond%' THEN 'YSRI'
      WHEN fbo.name LIKE '%Essendon%' THEN 'YMEN'
      WHEN fbo.name LIKE '%Cairns%' THEN 'YBCS'
      WHEN fbo.name LIKE '%Perth%' THEN 'YPPH'
      WHEN fbo.name LIKE '%Brunei%' THEN 'WBSB'
      WHEN fbo.name LIKE '%Beijing%' THEN 'ZBAD'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;