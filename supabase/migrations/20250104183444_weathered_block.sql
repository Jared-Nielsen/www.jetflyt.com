-- Add ICAOs and FBOs for Arkansas, Louisiana, Mississippi, and Alabama
DO $$ 
BEGIN
  -- Insert ICAO codes
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  VALUES
    -- Arkansas Airports
    ('KLIT', 'Bill and Hillary Clinton National Airport', 'AR', 'United States', 'North America', 34.7294, -92.2243),
    ('KXNA', 'Northwest Arkansas National Airport', 'AR', 'United States', 'North America', 36.2819, -94.3068),
    ('KFSM', 'Fort Smith Regional Airport', 'AR', 'United States', 'North America', 35.3366, -94.3674),
    ('KTXK', 'Texarkana Regional Airport', 'AR', 'United States', 'North America', 33.4537, -93.9911),
    ('KJBR', 'Jonesboro Municipal Airport', 'AR', 'United States', 'North America', 35.8315, -90.6465),
    ('KHOT', 'Memorial Field Airport', 'AR', 'United States', 'North America', 34.4780, -93.0962),

    -- Louisiana Airports
    ('KMSY', 'Louis Armstrong New Orleans International', 'LA', 'United States', 'North America', 29.9934, -90.2580),
    ('KBTR', 'Baton Rouge Metropolitan Airport', 'LA', 'United States', 'North America', 30.5332, -91.1496),
    ('KSHV', 'Shreveport Regional Airport', 'LA', 'United States', 'North America', 32.4466, -93.8256),
    ('KLFT', 'Lafayette Regional Airport', 'LA', 'United States', 'North America', 30.2053, -91.9876),
    ('KMBX', 'Monroe Regional Airport', 'LA', 'United States', 'North America', 32.5109, -92.0377),
    ('KLCH', 'Lake Charles Regional Airport', 'LA', 'United States', 'North America', 30.1261, -93.2234),
    ('KNEW', 'New Orleans Lakefront Airport', 'LA', 'United States', 'North America', 30.0424, -90.0283),
    ('KAEX', 'Alexandria International Airport', 'LA', 'United States', 'North America', 31.3274, -92.5486),

    -- Mississippi Airports
    ('KJAN', 'Jackson-Medgar Wiley Evers International', 'MS', 'United States', 'North America', 32.3112, -90.0759),
    ('KGPT', 'Gulfport-Biloxi International Airport', 'MS', 'United States', 'North America', 30.4073, -89.0701),
    ('KMEI', 'Key Field', 'MS', 'United States', 'North America', 32.3326, -88.7519),
    ('KGLH', 'Mid Delta Regional Airport', 'MS', 'United States', 'North America', 33.4829, -90.9856),
    ('KTUP', 'Tupelo Regional Airport', 'MS', 'United States', 'North America', 34.2681, -88.7699),
    ('KHBG', 'Hattiesburg-Laurel Regional Airport', 'MS', 'United States', 'North America', 31.2674, -89.2528),

    -- Alabama Airports
    ('KBHM', 'Birmingham-Shuttlesworth International', 'AL', 'United States', 'North America', 33.5629, -86.7535),
    ('KMOB', 'Mobile Regional Airport', 'AL', 'United States', 'North America', 30.6914, -88.2428),
    ('KHSV', 'Huntsville International Airport', 'AL', 'United States', 'North America', 34.6372, -86.7751),
    ('KMGM', 'Montgomery Regional Airport', 'AL', 'United States', 'North America', 32.3006, -86.3939),
    ('KDHN', 'Dothan Regional Airport', 'AL', 'United States', 'North America', 31.3213, -85.4496),
    ('KTCL', 'Tuscaloosa National Airport', 'AL', 'United States', 'North America', 33.2206, -87.6114),
    ('KEET', 'Northwest Alabama Regional Airport', 'AL', 'United States', 'North America', 34.9046, -87.6077),
    ('KANB', 'Anniston Regional Airport', 'AL', 'United States', 'North America', 33.5882, -85.8581)
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    state = EXCLUDED.state,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

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
      -- Little Rock (KLIT)
      ('TAC Air LIT', 34.7294, -92.2243, '2401 Crisp Dr, Little Rock, AR 72202', 'AR'),
      ('Signature Flight Support LIT', 34.7290, -92.2238, '2301 Crisp Dr, Little Rock, AR 72202', 'AR'),

      -- Northwest Arkansas (KXNA)
      ('Summit Aviation XNA', 36.2819, -94.3068, '2501 SW I St, Bentonville, AR 72712', 'AR'),
      ('Signature Flight Support XNA', 36.2815, -94.3063, '2535 SW I St, Bentonville, AR 72712', 'AR'),

      -- New Orleans (KMSY)
      ('Signature Flight Support MSY', 29.9934, -90.2580, '6101 G Hangar Rd, New Orleans, LA 70126', 'LA'),
      ('Atlantic Aviation MSY', 29.9930, -90.2575, '6205 7th St, New Orleans, LA 70126', 'LA'),

      -- Lakefront (KNEW)
      ('Signature Flight Support NEW', 30.0424, -90.0283, '6101 Stars and Stripes Blvd, New Orleans, LA 70126', 'LA'),
      ('Flightline First', 30.0420, -90.0278, '6101 G Hangar Rd, New Orleans, LA 70126', 'LA'),

      -- Jackson (KJAN)
      ('Atlantic Aviation JAN', 32.3112, -90.0759, '333 W Ramp St, Pearl, MS 39208', 'MS'),
      ('Million Air JAN', 32.3108, -90.0754, '120 Terminal Dr, Pearl, MS 39208', 'MS'),

      -- Gulfport-Biloxi (KGPT)
      ('Million Air GPT', 30.4073, -89.0701, '14035 Airport Rd, Gulfport, MS 39503', 'MS'),
      ('Atlantic Aviation GPT', 30.4069, -89.0696, '14040 Airport Rd, Gulfport, MS 39503', 'MS'),

      -- Birmingham (KBHM)
      ('Atlantic Aviation BHM', 33.5629, -86.7535, '4243 E Lake Blvd, Birmingham, AL 35217', 'AL'),
      ('Signature Flight Support BHM', 33.5625, -86.7530, '4201 E Lake Blvd, Birmingham, AL 35217', 'AL'),

      -- Huntsville (KHSV)
      ('Signature Flight Support HSV', 34.6372, -86.7751, '1000 Glenn Hearn Blvd SW, Huntsville, AL 35824', 'AL'),
      ('Port of Huntsville FBO', 34.6368, -86.7746, '1090 Glenn Hearn Blvd SW, Huntsville, AL 35824', 'AL')
  ) as fbo(name, latitude, longitude, address, state)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'KLIT', 'KXNA', 'KMSY', 'KNEW', 'KJAN', 'KGPT', 'KBHM', 'KHSV'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%LIT%' THEN 'KLIT'
      WHEN fbo.name LIKE '%XNA%' THEN 'KXNA'
      WHEN fbo.name LIKE '%MSY%' THEN 'KMSY'
      WHEN fbo.name LIKE '%NEW%' OR fbo.name LIKE '%Flightline%' THEN 'KNEW'
      WHEN fbo.name LIKE '%JAN%' THEN 'KJAN'
      WHEN fbo.name LIKE '%GPT%' THEN 'KGPT'
      WHEN fbo.name LIKE '%BHM%' THEN 'KBHM'
      WHEN fbo.name LIKE '%HSV%' THEN 'KHSV'
    END
  )
  ON CONFLICT DO NOTHING;

  -- Update ICAO types for the new airports
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'international'
  )
  WHERE code IN ('KMSY', 'KBHM', 'KHSV', 'KLIT', 'KXNA');

  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'regional'
  )
  WHERE code IN (
    'KJAN', 'KGPT', 'KMOB', 'KMGM', 'KBTR', 'KSHV', 'KLFT',
    'KFSM', 'KTXK', 'KJBR', 'KHOT', 'KMBX', 'KLCH', 'KAEX',
    'KMEI', 'KGLH', 'KTUP', 'KHBG', 'KDHN', 'KTCL', 'KEET', 'KANB'
  );

  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'general_aviation'
  )
  WHERE code = 'KNEW';
END $$;