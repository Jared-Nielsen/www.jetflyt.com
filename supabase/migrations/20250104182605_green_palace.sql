-- Add ICAOs and FBOs for Midwest states
DO $$ 
BEGIN
  -- Insert ICAO codes
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  VALUES
    -- North Dakota
    ('KBIS', 'Bismarck Airport', 'ND', 'United States', 'North America', 46.7724, -100.7467),
    ('KFAR', 'Hector International Airport', 'ND', 'United States', 'North America', 46.9207, -96.8158),
    ('KGFK', 'Grand Forks International Airport', 'ND', 'United States', 'North America', 47.9493, -97.1761),
    ('KMOT', 'Minot International Airport', 'ND', 'United States', 'North America', 48.2594, -101.2801),
    ('KDIK', 'Dickinson Theodore Roosevelt Regional', 'ND', 'United States', 'North America', 46.7974, -102.8020),
    ('KJMS', 'Jamestown Regional Airport', 'ND', 'United States', 'North America', 46.9297, -98.6782),

    -- South Dakota
    ('KFSD', 'Sioux Falls Regional Airport', 'SD', 'United States', 'North America', 43.5820, -96.7417),
    ('KRAP', 'Rapid City Regional Airport', 'SD', 'United States', 'North America', 44.0453, -103.0574),
    ('KABR', 'Aberdeen Regional Airport', 'SD', 'United States', 'North America', 45.4491, -98.4218),
    ('KPIR', 'Pierre Regional Airport', 'SD', 'United States', 'North America', 44.3827, -100.2859),
    ('KATY', 'Watertown Regional Airport', 'SD', 'United States', 'North America', 44.9140, -97.1547),
    ('KYKN', 'Chan Gurney Municipal Airport', 'SD', 'United States', 'North America', 42.9166, -97.3646),

    -- Nebraska
    ('KOMA', 'Eppley Airfield', 'NE', 'United States', 'North America', 41.3032, -95.8940),
    ('KLNK', 'Lincoln Airport', 'NE', 'United States', 'North America', 40.8510, -96.7592),
    ('KGRI', 'Central Nebraska Regional Airport', 'NE', 'United States', 'North America', 40.9675, -98.3096),
    ('KBFF', 'Western Nebraska Regional Airport', 'NE', 'United States', 'North America', 41.8742, -103.5957),
    ('KOFK', 'Norfolk Regional Airport', 'NE', 'United States', 'North America', 41.9855, -97.4351),
    ('KEAR', 'Kearney Regional Airport', 'NE', 'United States', 'North America', 40.7270, -99.0068),

    -- Iowa
    ('KDSM', 'Des Moines International Airport', 'IA', 'United States', 'North America', 41.5340, -93.6631),
    ('KCID', 'The Eastern Iowa Airport', 'IA', 'United States', 'North America', 41.8847, -91.7108),
    ('KALO', 'Waterloo Regional Airport', 'IA', 'United States', 'North America', 42.5571, -92.4003),
    ('KSUX', 'Sioux Gateway Airport', 'IA', 'United States', 'North America', 42.4026, -96.3844),
    ('KDBQ', 'Dubuque Regional Airport', 'IA', 'United States', 'North America', 42.4020, -90.7095),
    ('KBRL', 'Southeast Iowa Regional Airport', 'IA', 'United States', 'North America', 40.7832, -91.1255),

    -- Minnesota
    ('KMSP', 'Minneapolis-Saint Paul International', 'MN', 'United States', 'North America', 44.8820, -93.2218),
    ('KRST', 'Rochester International Airport', 'MN', 'United States', 'North America', 43.9084, -92.5000),
    ('KDLH', 'Duluth International Airport', 'MN', 'United States', 'North America', 46.8420, -92.1936),
    ('KSTC', 'St. Cloud Regional Airport', 'MN', 'United States', 'North America', 45.5463, -94.0598),
    ('KBRD', 'Brainerd Lakes Regional Airport', 'MN', 'United States', 'North America', 46.3979, -94.1372),
    ('KFCM', 'Flying Cloud Airport', 'MN', 'United States', 'North America', 44.8277, -93.4577),

    -- Wisconsin
    ('KMKE', 'Milwaukee Mitchell International Airport', 'WI', 'United States', 'North America', 42.9472, -87.8966),
    ('KMSN', 'Dane County Regional Airport', 'WI', 'United States', 'North America', 43.1399, -89.3375),
    ('KGRB', 'Green Bay Austin Straubel International', 'WI', 'United States', 'North America', 44.4851, -88.1296),
    ('KCWA', 'Central Wisconsin Airport', 'WI', 'United States', 'North America', 44.7777, -89.6668),
    ('KEAU', 'Chippewa Valley Regional Airport', 'WI', 'United States', 'North America', 44.8658, -91.4843),
    ('KATW', 'Appleton International Airport', 'WI', 'United States', 'North America', 44.2581, -88.5191),

    -- Illinois
    ('KORD', 'Chicago O''Hare International Airport', 'IL', 'United States', 'North America', 41.9742, -87.9073),
    ('KMDW', 'Chicago Midway International Airport', 'IL', 'United States', 'North America', 41.7868, -87.7522),
    ('KPWK', 'Chicago Executive Airport', 'IL', 'United States', 'North America', 42.1142, -87.9015),
    ('KUGN', 'Waukegan National Airport', 'IL', 'United States', 'North America', 42.4222, -87.8679),
    ('KPIA', 'General Wayne A. Downing Peoria International', 'IL', 'United States', 'North America', 40.6642, -89.6933),
    ('KCMI', 'University of Illinois Willard Airport', 'IL', 'United States', 'North America', 40.0390, -88.2778)
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
      -- Minneapolis-Saint Paul (KMSP)
      ('Signature Flight Support MSP', 44.8820, -93.2218, '6160 28th Ave S, Minneapolis, MN 55450', 'MN'),
      ('Signature Flight Support MSP South', 44.8815, -93.2213, '7034 Tower Rd, Minneapolis, MN 55450', 'MN'),
      
      -- Chicago O'Hare (KORD)
      ('Atlantic Aviation ORD', 41.9742, -87.9073, '11901 W Irving Park Rd, Chicago, IL 60666', 'IL'),
      ('Signature Flight Support ORD', 41.9747, -87.9078, '11601 W Irving Park Rd, Chicago, IL 60666', 'IL'),
      
      -- Milwaukee (KMKE)
      ('Signature Flight Support MKE', 42.9472, -87.8966, '923 E Layton Ave, Milwaukee, WI 53207', 'WI'),
      
      -- Des Moines (KDSM)
      ('Signature Flight Support DSM', 41.5340, -93.6631, '6000 Fleur Dr, Des Moines, IA 50321', 'IA'),
      ('Elliott Aviation DSM', 41.5345, -93.6636, '5800 Fleur Dr, Des Moines, IA 50321', 'IA'),
      
      -- Omaha (KOMA)
      ('TAC Air OMA', 41.3032, -95.8940, '3737 Orville Plaza, Omaha, NE 68110', 'NE'),
      ('Signature Flight Support OMA', 41.3037, -95.8945, '3636 Orville Plaza, Omaha, NE 68110', 'NE'),
      
      -- Fargo (KFAR)
      ('Fargo Jet Center', 46.9207, -96.8158, '3802 20th St N, Fargo, ND 58102', 'ND'),
      
      -- Sioux Falls (KFSD)
      ('Maverick Air Center', 43.5820, -96.7417, '4201 N Maverick Pl, Sioux Falls, SD 57104', 'SD'),
      ('Signature Flight Support FSD', 43.5825, -96.7422, '4101 N Aviation Ave, Sioux Falls, SD 57104', 'SD'),
      
      -- Chicago Executive (KPWK)
      ('Signature Flight Support PWK', 42.1142, -87.9015, '1100 S Milwaukee Ave, Wheeling, IL 60090', 'IL'),
      ('Atlantic Aviation PWK', 42.1147, -87.9020, '1011 S Wolf Rd, Wheeling, IL 60090', 'IL')
  ) as fbo(name, latitude, longitude, address, state)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'KMSP', 'KORD', 'KMKE', 'KDSM', 'KOMA', 'KFAR', 'KFSD', 'KPWK'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%MSP%' THEN 'KMSP'
      WHEN fbo.name LIKE '%ORD%' THEN 'KORD'
      WHEN fbo.name LIKE '%MKE%' THEN 'KMKE'
      WHEN fbo.name LIKE '%DSM%' THEN 'KDSM'
      WHEN fbo.name LIKE '%OMA%' THEN 'KOMA'
      WHEN fbo.name LIKE '%Fargo%' THEN 'KFAR'
      WHEN fbo.name LIKE '%FSD%' OR fbo.name LIKE '%Maverick%' THEN 'KFSD'
      WHEN fbo.name LIKE '%PWK%' THEN 'KPWK'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;