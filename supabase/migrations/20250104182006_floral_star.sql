-- Add ICAOs and FBOs for California, Nevada, and Arizona
DO $$ 
BEGIN
  -- Insert ICAO codes
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  VALUES
    -- California Major Airports
    ('KLAX', 'Los Angeles International Airport', 'CA', 'United States', 'North America', 33.9416, -118.4085),
    ('KSFO', 'San Francisco International Airport', 'CA', 'United States', 'North America', 33.6213, -122.3790),
    ('KSAN', 'San Diego International Airport', 'CA', 'United States', 'North America', 32.7336, -117.1897),
    ('KOAK', 'Oakland International Airport', 'CA', 'United States', 'North America', 37.7214, -122.2208),
    ('KSJC', 'Norman Y. Mineta San Jose International', 'CA', 'United States', 'North America', 37.3626, -121.9291),
    ('KONT', 'Ontario International Airport', 'CA', 'United States', 'North America', 34.0558, -117.6011),
    ('KBUR', 'Hollywood Burbank Airport', 'CA', 'United States', 'North America', 34.2007, -118.3590),
    ('KSNA', 'John Wayne Airport', 'CA', 'United States', 'North America', 33.6762, -117.8674),
    ('KSMF', 'Sacramento International Airport', 'CA', 'United States', 'North America', 38.6955, -121.5907),
    ('KPSP', 'Palm Springs International Airport', 'CA', 'United States', 'North America', 33.8303, -116.5067),

    -- Nevada Major Airports
    ('KLAS', 'Harry Reid International Airport', 'NV', 'United States', 'North America', 36.0840, -115.1537),
    ('KRNO', 'Reno-Tahoe International Airport', 'NV', 'United States', 'North America', 39.4991, -119.7681),
    ('KHND', 'Henderson Executive Airport', 'NV', 'United States', 'North America', 35.9728, -115.1344),
    ('KVGT', 'North Las Vegas Airport', 'NV', 'United States', 'North America', 36.2107, -115.1944),
    ('KCXP', 'Carson City Airport', 'NV', 'United States', 'North America', 39.1927, -119.7344),
    ('KTPH', 'Tonopah Airport', 'NV', 'United States', 'North America', 38.0602, -117.0872),
    ('KEKO', 'Elko Regional Airport', 'NV', 'United States', 'North America', 40.8249, -115.7917),
    ('KWMC', 'Winnemucca Municipal Airport', 'NV', 'United States', 'North America', 40.8965, -117.8059),

    -- Arizona Major Airports
    ('KPHX', 'Phoenix Sky Harbor International Airport', 'AZ', 'United States', 'North America', 33.4352, -112.0101),
    ('KTUS', 'Tucson International Airport', 'AZ', 'United States', 'North America', 32.1161, -110.9410),
    ('KSDL', 'Scottsdale Airport', 'AZ', 'United States', 'North America', 33.6228, -111.9107),
    ('KIWA', 'Phoenix-Mesa Gateway Airport', 'AZ', 'United States', 'North America', 33.3078, -111.6556),
    ('KGYR', 'Phoenix Goodyear Airport', 'AZ', 'United States', 'North America', 33.4234, -112.3761),
    ('KPRC', 'Prescott Regional Airport', 'AZ', 'United States', 'North America', 34.6545, -112.4191),
    ('KFLG', 'Flagstaff Pulliam Airport', 'AZ', 'United States', 'North America', 35.1385, -111.6695),
    ('KGCN', 'Grand Canyon National Park Airport', 'AZ', 'United States', 'North America', 35.9524, -112.1471)
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
      -- LAX FBOs
      ('Signature Flight Support LAX', 33.9416, -118.4085, '6201 W Imperial Hwy, Los Angeles, CA 90045', 'CA'),
      ('Atlantic Aviation LAX', 33.9420, -118.4080, '6411 W Imperial Hwy, Los Angeles, CA 90045', 'CA'),
      ('Clay Lacy Aviation LAX', 33.9425, -118.4075, '6900 W Imperial Hwy, Los Angeles, CA 90045', 'CA'),

      -- SFO FBOs
      ('Signature Flight Support SFO', 37.6213, -122.3790, '323 N Access Rd, San Francisco, CA 94128', 'CA'),
      ('Million Air SFO', 37.6218, -122.3785, '100 N Access Rd, San Francisco, CA 94128', 'CA'),

      -- LAS FBOs
      ('Signature Flight Support LAS', 36.0840, -115.1537, '275 E Tropicana Ave, Las Vegas, NV 89169', 'NV'),
      ('Atlantic Aviation LAS', 36.0845, -115.1532, '315 E Tropicana Ave, Las Vegas, NV 89169', 'NV'),
      ('Henderson Executive Airport FBO', 35.9728, -115.1344, '3500 Executive Terminal Dr, Henderson, NV 89052', 'NV'),

      -- PHX FBOs
      ('Cutter Aviation PHX', 33.4352, -112.0101, '2802 E Old Tower Rd, Phoenix, AZ 85034', 'AZ'),
      ('Signature Flight Support PHX', 33.4357, -112.0096, '2710 E Old Tower Rd, Phoenix, AZ 85034', 'AZ'),
      ('Swift Aviation Services', 33.4362, -112.0091, '2710 E Sky Harbor Cir S, Phoenix, AZ 85034', 'AZ'),

      -- SDL FBOs
      ('Signature Flight Support SDL', 33.6228, -111.9107, '15290 N 78th Way, Scottsdale, AZ 85260', 'AZ'),
      ('Ross Aviation SDL', 33.6233, -111.9102, '14600 N Airport Dr, Scottsdale, AZ 85260', 'AZ'),
      ('Jet Aviation SDL', 33.6238, -111.9097, '14700 N Airport Dr, Scottsdale, AZ 85260', 'AZ')
  ) as fbo(name, latitude, longitude, address, state)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'KLAX', 'KSFO', 'KLAS', 'KPHX', 'KSDL'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%LAX%' THEN 'KLAX'
      WHEN fbo.name LIKE '%SFO%' THEN 'KSFO'
      WHEN fbo.name LIKE '%LAS%' OR fbo.name LIKE '%Henderson%' THEN 'KLAS'
      WHEN fbo.name LIKE '%PHX%' THEN 'KPHX'
      WHEN fbo.name LIKE '%SDL%' THEN 'KSDL'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;