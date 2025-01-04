-- Add ICAOs for Ohio, Indiana, Michigan, Pennsylvania, and West Virginia
DO $$ 
BEGIN
  -- Insert ICAO codes
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  VALUES
    -- Ohio Airports
    ('KCLE', 'Cleveland Hopkins International Airport', 'OH', 'United States', 'North America', 41.4117, -81.8497),
    ('KCMH', 'John Glenn Columbus International Airport', 'OH', 'United States', 'North America', 39.9980, -82.8919),
    ('KCVG', 'Cincinnati/Northern Kentucky International', 'OH', 'United States', 'North America', 39.0489, -84.6678),
    ('KDAY', 'James M. Cox Dayton International Airport', 'OH', 'United States', 'North America', 39.9024, -84.2194),
    ('KTOL', 'Eugene F. Kranz Toledo Express Airport', 'OH', 'United States', 'North America', 41.5868, -83.8078),
    ('KYNG', 'Youngstown-Warren Regional Airport', 'OH', 'United States', 'North America', 41.2607, -80.6790),
    ('KLCK', 'Rickenbacker International Airport', 'OH', 'United States', 'North America', 39.8138, -82.9278),
    ('KZZV', 'Zanesville Municipal Airport', 'OH', 'United States', 'North America', 39.9444, -81.8920),

    -- Indiana Airports
    ('KIND', 'Indianapolis International Airport', 'IN', 'United States', 'North America', 39.7173, -86.2944),
    ('KFWA', 'Fort Wayne International Airport', 'IN', 'United States', 'North America', 40.9785, -85.1951),
    ('KSBN', 'South Bend International Airport', 'IN', 'United States', 'North America', 41.7087, -86.3173),
    ('KEVV', 'Evansville Regional Airport', 'IN', 'United States', 'North America', 38.0368, -87.5320),
    ('KLAF', 'Purdue University Airport', 'IN', 'United States', 'North America', 40.4123, -86.9369),
    ('KBMG', 'Monroe County Airport', 'IN', 'United States', 'North America', 39.1460, -86.6167),
    ('KGUS', 'Grissom Air Reserve Base', 'IN', 'United States', 'North America', 40.6481, -86.1521),
    ('KTYQ', 'Indianapolis Executive Airport', 'IN', 'United States', 'North America', 40.0313, -86.2514),

    -- Michigan Airports
    ('KDTW', 'Detroit Metropolitan Wayne County Airport', 'MI', 'United States', 'North America', 42.2124, -83.3534),
    ('KGRR', 'Gerald R. Ford International Airport', 'MI', 'United States', 'North America', 42.8808, -85.5228),
    ('KLAN', 'Capital Region International Airport', 'MI', 'United States', 'North America', 42.7786, -84.5874),
    ('KFNT', 'Bishop International Airport', 'MI', 'United States', 'North America', 42.9654, -83.7436),
    ('KAZW', 'Kalamazoo/Battle Creek International', 'MI', 'United States', 'North America', 42.2349, -85.5521),
    ('KMKG', 'Muskegon County Airport', 'MI', 'United States', 'North America', 43.1695, -86.2382),
    ('KPTK', 'Oakland County International Airport', 'MI', 'United States', 'North America', 42.6655, -83.4185),
    ('KYIP', 'Willow Run Airport', 'MI', 'United States', 'North America', 42.2378, -83.5300),

    -- Pennsylvania Airports
    ('KPHL', 'Philadelphia International Airport', 'PA', 'United States', 'North America', 39.8721, -75.2411),
    ('KPIT', 'Pittsburgh International Airport', 'PA', 'United States', 'North America', 40.4915, -80.2329),
    ('KMDT', 'Harrisburg International Airport', 'PA', 'United States', 'North America', 40.1935, -76.7634),
    ('KABE', 'Lehigh Valley International Airport', 'PA', 'United States', 'North America', 40.6521, -75.4408),
    ('KERI', 'Erie International Airport', 'PA', 'United States', 'North America', 42.0831, -80.1739),
    ('KAVP', 'Wilkes-Barre/Scranton International', 'PA', 'United States', 'North America', 41.3384, -75.7234),
    ('KUNV', 'University Park Airport', 'PA', 'United States', 'North America', 40.8492, -77.8487),
    ('KRDG', 'Reading Regional Airport', 'PA', 'United States', 'North America', 40.3785, -75.9652),

    -- West Virginia Airports
    ('KCRW', 'Yeager Airport', 'WV', 'United States', 'North America', 38.3731, -81.5932),
    ('KCKB', 'North Central West Virginia Airport', 'WV', 'United States', 'North America', 39.2966, -80.2281),
    ('KHTS', 'Tri-State Airport', 'WV', 'United States', 'North America', 38.3667, -82.5580),
    ('KMGW', 'Morgantown Municipal Airport', 'WV', 'United States', 'North America', 39.6429, -79.9163),
    ('KBKW', 'Raleigh County Memorial Airport', 'WV', 'United States', 'North America', 37.7873, -81.1242),
    ('KPKB', 'Mid-Ohio Valley Regional Airport', 'WV', 'United States', 'North America', 39.3451, -81.4392),
    ('KLWB', 'Greenbrier Valley Airport', 'WV', 'United States', 'North America', 37.8583, -80.3994),
    ('KHLG', 'Wheeling Ohio County Airport', 'WV', 'United States', 'North America', 40.1749, -80.6463)
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    state = EXCLUDED.state,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

  -- Update ICAO types
  -- Major International Hubs
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'major_international'
  )
  WHERE code IN ('KPHL', 'KDTW');

  -- International Airports
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'international'
  )
  WHERE code IN (
    'KCLE', 'KCMH', 'KCVG', 'KIND', 'KPIT'
  );

  -- Regional Airports
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'regional'
  )
  WHERE code IN (
    'KDAY', 'KTOL', 'KYNG', 'KFWA', 'KSBN', 'KEVV',
    'KGRR', 'KLAN', 'KFNT', 'KAZW', 'KMKG',
    'KMDT', 'KABE', 'KERI', 'KAVP', 'KUNV',
    'KCRW', 'KCKB', 'KHTS', 'KMGW', 'KBKW', 'KPKB'
  );

  -- General Aviation
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'general_aviation'
  )
  WHERE code IN ('KPTK', 'KYIP', 'KTYQ', 'KRDG', 'KLWB', 'KHLG', 'KZZV', 'KBMG');

  -- Cargo Hubs
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'cargo'
  )
  WHERE code IN ('KLCK');

  -- Military
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'military'
  )
  WHERE code IN ('KGUS');

  -- Add FBO locations for major airports
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country, state)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'USA',
    fbo.state
  FROM (
    VALUES 
      -- Philadelphia (KPHL)
      ('Atlantic Aviation PHL', 39.8721, -75.2411, '8375 Enterprise Ave, Philadelphia, PA 19153', 'PA'),
      ('Signature Flight Support PHL', 39.8717, -75.2407, '8375 Enterprise Ave, Philadelphia, PA 19153', 'PA'),

      -- Pittsburgh (KPIT)
      ('Atlantic Aviation PIT', 40.4915, -80.2329, '1000 Airport Blvd, Pittsburgh, PA 15231', 'PA'),
      ('Corporate Air PIT', 40.4911, -80.2325, '1000 Airport Blvd, Pittsburgh, PA 15231', 'PA'),

      -- Detroit (KDTW)
      ('Signature Flight Support DTW', 42.2124, -83.3534, '2607 Lucas Dr, Detroit, MI 48242', 'MI'),
      ('Metro Flight Services', 42.2120, -83.3530, '2613 Lucas Dr, Detroit, MI 48242', 'MI'),

      -- Cleveland (KCLE)
      ('Signature Flight Support CLE', 41.4117, -81.8497, '19301 Snow Rd, Cleveland, OH 44135', 'OH'),
      ('Atlantic Aviation CLE', 41.4113, -81.8493, '19000 Airport Pkwy, Cleveland, OH 44135', 'OH'),

      -- Indianapolis (KIND)
      ('Signature Flight Support IND', 39.7173, -86.2944, '7051 Pierson Dr, Indianapolis, IN 46241', 'IN'),
      ('Million Air IND', 39.7169, -86.2940, '6921 Pierson Dr, Indianapolis, IN 46241', 'IN')
  ) as fbo(name, latitude, longitude, address, state)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'KPHL', 'KPIT', 'KDTW', 'KCLE', 'KIND'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%PHL%' THEN 'KPHL'
      WHEN fbo.name LIKE '%PIT%' THEN 'KPIT'
      WHEN fbo.name LIKE '%DTW%' OR fbo.name LIKE '%Metro Flight%' THEN 'KDTW'
      WHEN fbo.name LIKE '%CLE%' THEN 'KCLE'
      WHEN fbo.name LIKE '%IND%' THEN 'KIND'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;