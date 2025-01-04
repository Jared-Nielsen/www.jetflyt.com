-- Add FBO locations for Japanese airports
DO $$ 
BEGIN
  -- First ensure all required ICAO codes exist
  INSERT INTO icaos (code, name, country, continent, latitude, longitude)
  VALUES
    -- Major International Airports
    ('RJTT', 'Tokyo Haneda International Airport', 'Japan', 'Asia', 35.5494, 139.7798),
    ('RJAA', 'Narita International Airport', 'Japan', 'Asia', 35.7719, 140.3928),
    ('RJBB', 'Kansai International Airport', 'Japan', 'Asia', 34.4320, 135.2304),
    ('RJCC', 'New Chitose Airport', 'Japan', 'Asia', 42.7752, 141.6925),
    ('RJFF', 'Fukuoka Airport', 'Japan', 'Asia', 33.5847, 130.4510),
    ('RJGG', 'Chubu Centrair International Airport', 'Japan', 'Asia', 34.8584, 136.8049),
    -- Regional Airports
    ('RJBE', 'Kobe Airport', 'Japan', 'Asia', 34.6328, 135.2238),
    ('RJOO', 'Osaka International Airport', 'Japan', 'Asia', 34.7854, 135.4385),
    ('RJNA', 'Nagoya Airfield', 'Japan', 'Asia', 35.2550, 136.9237),
    ('RJNS', 'Nagasaki Airport', 'Japan', 'Asia', 32.9169, 129.9138),
    ('RJFR', 'Kitakyushu Airport', 'Japan', 'Asia', 33.8456, 131.0352),
    ('RJSS', 'Sendai Airport', 'Japan', 'Asia', 38.1397, 140.9170)
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
    'Japan'
  FROM (
    VALUES 
      -- Tokyo Haneda (RJTT)
      ('Universal Aviation HND', 35.5494, 139.7798, 'Business Aviation Terminal, 3-3-2 Haneda Airport, Ota-ku, Tokyo'),
      ('Signature Flight Support HND', 35.5490, 139.7795, 'Premier Gate, Haneda Airport, Tokyo'),
      ('JAL Business Aviation', 35.5488, 139.7792, 'Terminal 3, Haneda Airport, Tokyo'),
      ('ExecuJet Tokyo', 35.5485, 139.7790, 'Business Aviation Center, Haneda Airport'),

      -- Narita (RJAA)
      ('NAA Business Aviation', 35.7719, 140.3928, 'Business Aviation Terminal, Narita International Airport'),
      ('Universal Aviation NRT', 35.7715, 140.3925, 'Business Jets Terminal, Narita Airport'),
      ('Signature Flight Support NRT', 35.7712, 140.3922, 'Premier Gate, Narita International Airport'),

      -- Kansai (RJBB)
      ('Premium Gate KIX', 34.4320, 135.2304, 'Business Aviation Terminal, Kansai International Airport'),
      ('Universal Aviation KIX', 34.4317, 135.2301, 'Business Jets Terminal, Kansai Airport'),
      ('Sky Support KIX', 34.4315, 135.2298, 'General Aviation Center, Kansai International Airport'),

      -- New Chitose (RJCC)
      ('Hokkaido Air Service', 42.7752, 141.6925, 'Business Aviation Terminal, New Chitose Airport'),
      ('Universal Aviation CTS', 42.7748, 141.6922, 'General Aviation Center, New Chitose Airport'),

      -- Fukuoka (RJFF)
      ('Fukuoka Aviation Service', 33.5847, 130.4510, 'Business Aviation Terminal, Fukuoka Airport'),
      ('Universal Aviation FUK', 33.5844, 130.4507, 'General Aviation Center, Fukuoka Airport'),

      -- Chubu Centrair (RJGG)
      ('Centrair Business Aviation', 34.8584, 136.8049, 'Business Aviation Terminal, Chubu Centrair International Airport'),
      ('Universal Aviation NGO', 34.8581, 136.8046, 'General Aviation Center, Centrair Airport'),

      -- Kobe (RJBE)
      ('Kobe Aviation Service', 34.6328, 135.2238, 'Business Aviation Terminal, Kobe Airport'),
      ('Sky Support UKB', 34.6325, 135.2235, 'General Aviation Center, Kobe Airport'),

      -- Osaka International (RJOO)
      ('Osaka Business Aviation', 34.7854, 135.4385, 'Business Aviation Terminal, Osaka International Airport'),
      ('Universal Aviation ITM', 34.7851, 135.4382, 'General Aviation Center, Itami Airport'),

      -- Nagoya (RJNA)
      ('Nagoya Aviation Service', 35.2550, 136.9237, 'Business Aviation Terminal, Nagoya Airfield'),
      ('Universal Aviation NKM', 35.2547, 136.9234, 'General Aviation Center, Nagoya Airport'),

      -- Nagasaki (RJNS)
      ('Nagasaki Aviation Service', 32.9169, 129.9138, 'Business Aviation Terminal, Nagasaki Airport'),
      ('Sky Support NGS', 32.9166, 129.9135, 'General Aviation Center, Nagasaki Airport'),

      -- Kitakyushu (RJFR)
      ('Kitakyushu Aviation Service', 33.8456, 131.0352, 'Business Aviation Terminal, Kitakyushu Airport'),
      ('Sky Support KKJ', 33.8453, 131.0349, 'General Aviation Center, Kitakyushu Airport'),

      -- Sendai (RJSS)
      ('Sendai Aviation Service', 38.1397, 140.9170, 'Business Aviation Terminal, Sendai Airport'),
      ('Universal Aviation SDJ', 38.1394, 140.9167, 'General Aviation Center, Sendai Airport')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'RJTT', 'RJAA', 'RJBB', 'RJCC', 'RJFF', 'RJGG',
      'RJBE', 'RJOO', 'RJNA', 'RJNS', 'RJFR', 'RJSS'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%HND%' OR fbo.name LIKE '%JAL%' THEN 'RJTT'
      WHEN fbo.name LIKE '%NRT%' OR fbo.name LIKE '%NAA%' THEN 'RJAA'
      WHEN fbo.name LIKE '%KIX%' OR fbo.name LIKE '%Premium Gate%' THEN 'RJBB'
      WHEN fbo.name LIKE '%CTS%' OR fbo.name LIKE '%Hokkaido%' THEN 'RJCC'
      WHEN fbo.name LIKE '%FUK%' OR fbo.name LIKE '%Fukuoka Aviation%' THEN 'RJFF'
      WHEN fbo.name LIKE '%NGO%' OR fbo.name LIKE '%Centrair%' THEN 'RJGG'
      WHEN fbo.name LIKE '%UKB%' OR fbo.name LIKE '%Kobe Aviation%' THEN 'RJBE'
      WHEN fbo.name LIKE '%ITM%' OR fbo.name LIKE '%Osaka Business%' THEN 'RJOO'
      WHEN fbo.name LIKE '%NKM%' OR fbo.name LIKE '%Nagoya Aviation%' THEN 'RJNA'
      WHEN fbo.name LIKE '%NGS%' OR fbo.name LIKE '%Nagasaki Aviation%' THEN 'RJNS'
      WHEN fbo.name LIKE '%KKJ%' OR fbo.name LIKE '%Kitakyushu Aviation%' THEN 'RJFR'
      WHEN fbo.name LIKE '%SDJ%' OR fbo.name LIKE '%Sendai Aviation%' THEN 'RJSS'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;