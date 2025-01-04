-- Add Atlantic Aviation FBO locations worldwide
DO $$ 
BEGIN
  -- First ensure all required ICAO codes exist
  INSERT INTO icaos (code, name, state, country, latitude, longitude)
  VALUES
    -- United States (Major Locations)
    ('KPDK', 'DeKalb-Peachtree Airport', 'GA', 'United States', 33.8756, -84.3020),
    ('KAPA', 'Centennial Airport', 'CO', 'United States', 39.5700, -104.8490),
    ('KSDL', 'Scottsdale Airport', 'AZ', 'United States', 33.6228, -111.9107),
    ('KLAS', 'Harry Reid International Airport', 'NV', 'United States', 36.0840, -115.1537),
    ('KPBI', 'Palm Beach International Airport', 'FL', 'United States', 26.6832, -80.0956),
    ('KTEB', 'Teterboro Airport', 'NJ', 'United States', 40.8501, -74.0608),
    ('KBCT', 'Boca Raton Airport', 'FL', 'United States', 26.3785, -80.1077),
    ('KBED', 'Laurence G. Hanscom Field', 'MA', 'United States', 42.4700, -71.2890),
    ('KBFI', 'Boeing Field/King County International', 'WA', 'United States', 47.5299, -122.3019)
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

  -- Now add the FBO locations
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
      ('Atlantic Aviation PDK', 33.8756, -84.3020, '2000 Airport Rd, Atlanta, GA 30341', 'GA'),
      ('Atlantic Aviation APA', 39.5700, -104.8490, '7850 S Peoria St, Englewood, CO 80112', 'CO'),
      ('Atlantic Aviation SDL', 33.6228, -111.9107, '14600 N Airport Dr, Scottsdale, AZ 85260', 'AZ'),
      ('Atlantic Aviation LAS', 36.0840, -115.1537, '275 E Tropicana Ave, Las Vegas, NV 89169', 'NV'),
      ('Atlantic Aviation PBI', 26.6832, -80.0956, '3800 Southern Blvd, West Palm Beach, FL 33406', 'FL'),
      ('Atlantic Aviation TEB', 40.8501, -74.0608, '101 Charles A. Lindbergh Dr, Teterboro, NJ 07608', 'NJ'),
      ('Atlantic Aviation BCT', 26.3785, -80.1077, '3700 Airport Rd, Boca Raton, FL 33431', 'FL'),
      ('Atlantic Aviation BED', 42.4700, -71.2890, '380 Hanscom Dr, Bedford, MA 01730', 'MA'),
      ('Atlantic Aviation BFI', 47.5299, -122.3019, '8555 Perimeter Rd S, Seattle, WA 98108', 'WA')
  ) as fbo(name, latitude, longitude, address, state)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'KPDK', 'KAPA', 'KSDL', 'KLAS', 'KPBI', 'KTEB', 'KBCT', 'KBED', 'KBFI'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%PDK' THEN 'KPDK'
      WHEN fbo.name LIKE '%APA' THEN 'KAPA'
      WHEN fbo.name LIKE '%SDL' THEN 'KSDL'
      WHEN fbo.name LIKE '%LAS' THEN 'KLAS'
      WHEN fbo.name LIKE '%PBI' THEN 'KPBI'
      WHEN fbo.name LIKE '%TEB' THEN 'KTEB'
      WHEN fbo.name LIKE '%BCT' THEN 'KBCT'
      WHEN fbo.name LIKE '%BED' THEN 'KBED'
      WHEN fbo.name LIKE '%BFI' THEN 'KBFI'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;