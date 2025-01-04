-- Add Universal Aviation and Jet Aviation FBO locations worldwide
DO $$ 
BEGIN
  -- First ensure all required ICAO codes exist
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  VALUES
    -- United States
    ('KIAH', 'George Bush Intercontinental Airport', 'TX', 'United States', 'North America', 29.9902, -95.3368),
    ('KMCO', 'Orlando International Airport', 'FL', 'United States', 'North America', 28.4312, -81.3081),
    ('KPBI', 'Palm Beach International Airport', 'FL', 'United States', 'North America', 26.6832, -80.0956),
    -- Europe
    ('LSZH', 'Zurich Airport', NULL, 'Switzerland', 'Europe', 47.4582, 8.5555),
    ('LSGG', 'Geneva Airport', NULL, 'Switzerland', 'Europe', 46.2370, 6.1089),
    ('LIML', 'Milan Linate Airport', NULL, 'Italy', 'Europe', 45.4497, 9.2778),
    ('LEMD', 'Adolfo Suárez Madrid–Barajas Airport', NULL, 'Spain', 'Europe', 40.4983, -3.5676),
    -- Asia
    ('VHHH', 'Hong Kong International Airport', NULL, 'Hong Kong', 'Asia', 22.3080, 113.9185),
    ('WSSS', 'Singapore Changi Airport', NULL, 'Singapore', 'Asia', 1.3644, 103.9915),
    ('ZBAA', 'Beijing Capital International Airport', NULL, 'China', 'Asia', 40.0799, 116.6031),
    -- Middle East
    ('OMDB', 'Dubai International Airport', NULL, 'United Arab Emirates', 'Asia', 25.2532, 55.3657),
    ('OEJN', 'King Abdulaziz International Airport', NULL, 'Saudi Arabia', 'Asia', 21.6805, 39.1722)
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

  -- Add Universal Aviation locations
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country, state)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    fbo.country,
    fbo.state
  FROM (
    VALUES 
      -- United States
      ('Universal Aviation IAH', 29.9902, -95.3368, '19419 Jet Center Dr, Houston, TX 77338', 'United States', 'TX'),
      ('Universal Aviation MCO', 28.4312, -81.3081, '4901 Andros Dr, Orlando, FL 32827', 'United States', 'FL'),
      -- Europe
      ('Universal Aviation ZRH', 47.4582, 8.5555, 'Business Aviation Center, 8058 Zurich', 'Switzerland', NULL),
      ('Universal Aviation GVA', 46.2370, 6.1089, 'Route de l''Aéroport 5, 1215 Geneva', 'Switzerland', NULL),
      ('Universal Aviation LIN', 45.4497, 9.2778, 'Via dell''Aviazione, 20090 Segrate MI', 'Italy', NULL),
      ('Universal Aviation MAD', 40.4983, -3.5676, 'Terminal Ejecutiva, 28042 Madrid', 'Spain', NULL),
      -- Asia
      ('Universal Aviation HKG', 22.3080, 113.9185, 'Business Aviation Centre, Chek Lap Kok', 'Hong Kong', NULL),
      ('Universal Aviation SIN', 1.3644, 103.9915, '11 Airline Road, Changi Airport', 'Singapore', NULL),
      ('Universal Aviation PEK', 40.0799, 116.6031, 'Capital Jet FBO, Beijing', 'China', NULL)
  ) as fbo(name, latitude, longitude, address, country, state)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'KIAH', 'KMCO', 'LSZH', 'LSGG', 'LIML', 'LEMD', 'VHHH', 'WSSS', 'ZBAA'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%IAH' THEN 'KIAH'
      WHEN fbo.name LIKE '%MCO' THEN 'KMCO'
      WHEN fbo.name LIKE '%ZRH' THEN 'LSZH'
      WHEN fbo.name LIKE '%GVA' THEN 'LSGG'
      WHEN fbo.name LIKE '%LIN' THEN 'LIML'
      WHEN fbo.name LIKE '%MAD' THEN 'LEMD'
      WHEN fbo.name LIKE '%HKG' THEN 'VHHH'
      WHEN fbo.name LIKE '%SIN' THEN 'WSSS'
      WHEN fbo.name LIKE '%PEK' THEN 'ZBAA'
    END
  )
  ON CONFLICT DO NOTHING;

  -- Add Jet Aviation locations
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country, state)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    fbo.country,
    fbo.state
  FROM (
    VALUES 
      -- United States
      ('Jet Aviation PBI', 26.6832, -80.0956, '1515 Perimeter Rd, West Palm Beach, FL 33406', 'United States', 'FL'),
      -- Europe
      ('Jet Aviation ZRH', 47.4582, 8.5555, 'Business Aviation Center, 8058 Zurich', 'Switzerland', NULL),
      ('Jet Aviation GVA', 46.2370, 6.1089, 'Chemin des Papillons 18, 1215 Geneva', 'Switzerland', NULL),
      -- Middle East
      ('Jet Aviation DXB', 25.2532, 55.3657, 'Dubai International Airport', 'United Arab Emirates', NULL),
      ('Jet Aviation JED', 21.6805, 39.1722, 'King Abdulaziz International Airport', 'Saudi Arabia', NULL),
      -- Asia
      ('Jet Aviation SIN', 1.3644, 103.9915, '60 Seletar Aerospace View, Singapore 797564', 'Singapore', NULL),
      ('Jet Aviation HKG', 22.3080, 113.9185, 'Business Aviation Centre, Hong Kong', 'Hong Kong', NULL)
  ) as fbo(name, latitude, longitude, address, country, state)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'KPBI', 'LSZH', 'LSGG', 'OMDB', 'OEJN', 'WSSS', 'VHHH'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%PBI' THEN 'KPBI'
      WHEN fbo.name LIKE '%ZRH' THEN 'LSZH'
      WHEN fbo.name LIKE '%GVA' THEN 'LSGG'
      WHEN fbo.name LIKE '%DXB' THEN 'OMDB'
      WHEN fbo.name LIKE '%JED' THEN 'OEJN'
      WHEN fbo.name LIKE '%SIN' THEN 'WSSS'
      WHEN fbo.name LIKE '%HKG' THEN 'VHHH'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;