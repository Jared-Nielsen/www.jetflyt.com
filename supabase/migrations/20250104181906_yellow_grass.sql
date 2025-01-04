-- Add ICAOs for Oklahoma, Kansas, and Missouri airports
DO $$ 
BEGIN
  -- Insert ICAO codes
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  VALUES
    -- Oklahoma Airports
    ('KOKC', 'Will Rogers World Airport', 'OK', 'United States', 'North America', 35.3931, -97.6007),
    ('KTUL', 'Tulsa International Airport', 'OK', 'United States', 'North America', 36.1984, -95.8881),
    ('KPWA', 'Wiley Post Airport', 'OK', 'United States', 'North America', 35.5342, -97.6474),
    ('KLAW', 'Lawton-Fort Sill Regional Airport', 'OK', 'United States', 'North America', 34.5677, -98.4166),
    ('KOUN', 'University of Oklahoma Westheimer Airport', 'OK', 'United States', 'North America', 35.2456, -97.4720),
    ('KGAG', 'Gage Airport', 'OK', 'United States', 'North America', 36.2955, -99.7764),
    ('KPNC', 'Ponca City Regional Airport', 'OK', 'United States', 'North America', 36.7306, -97.0997),
    ('KEND', 'Vance Air Force Base', 'OK', 'United States', 'North America', 36.3397, -97.9165),

    -- Kansas Airports
    ('KICT', 'Wichita Dwight D. Eisenhower National Airport', 'KS', 'United States', 'North America', 37.6499, -97.4331),
    ('KMHK', 'Manhattan Regional Airport', 'KS', 'United States', 'North America', 39.1409, -96.6708),
    ('KFOE', 'Topeka Regional Airport', 'KS', 'United States', 'North America', 38.9509, -95.6636),
    ('KGCK', 'Garden City Regional Airport', 'KS', 'United States', 'North America', 37.9275, -100.7244),
    ('KHYS', 'Hays Regional Airport', 'KS', 'United States', 'North America', 38.8422, -99.2732),
    ('KSLN', 'Salina Regional Airport', 'KS', 'United States', 'North America', 38.7910, -97.6522),
    ('KBEC', 'Beech Factory Airport', 'KS', 'United States', 'North America', 37.6940, -97.2149),
    ('KCNU', 'Chanute Martin Johnson Airport', 'KS', 'United States', 'North America', 37.6687, -95.4855),

    -- Missouri Airports
    ('KMCI', 'Kansas City International Airport', 'MO', 'United States', 'North America', 39.2976, -94.7139),
    ('KSTL', 'St. Louis Lambert International Airport', 'MO', 'United States', 'North America', 38.7487, -90.3700),
    ('KSGF', 'Springfield-Branson National Airport', 'MO', 'United States', 'North America', 37.2457, -93.3886),
    ('KCOU', 'Columbia Regional Airport', 'MO', 'United States', 'North America', 38.8181, -92.2196),
    ('KJLN', 'Joplin Regional Airport', 'MO', 'United States', 'North America', 37.1518, -94.4983),
    ('KBBG', 'Branson Airport', 'MO', 'United States', 'North America', 36.5317, -93.2005),
    ('KTBN', 'Waynesville-St. Robert Regional Airport', 'MO', 'United States', 'North America', 37.7416, -92.1407),
    ('KSZL', 'Whiteman Air Force Base', 'MO', 'United States', 'North America', 38.7303, -93.5479)
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    state = EXCLUDED.state,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

  -- Add FBOs for major airports in these states
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
      -- Oklahoma FBOs
      ('Atlantic Aviation OKC', 35.3931, -97.6007, '6201 S Meridian Ave, Oklahoma City, OK 73159', 'OK'),
      ('Signature Flight Support OKC', 35.3935, -97.6010, '6101 S Meridian Ave, Oklahoma City, OK 73159', 'OK'),
      ('Signature Flight Support TUL', 36.1984, -95.8881, '2251 N Sheridan Rd, Tulsa, OK 74115', 'OK'),
      ('Atlantic Aviation TUL', 36.1980, -95.8885, '2000 N Memorial Dr, Tulsa, OK 74115', 'OK'),

      -- Kansas FBOs
      ('Signature Flight Support ICT', 37.6499, -97.4331, '2061 Airport Rd, Wichita, KS 67209', 'KS'),
      ('Yingling Aviation', 37.6495, -97.4335, '2010 Airport Rd, Wichita, KS 67209', 'KS'),
      ('Million Air ICT', 37.6492, -97.4328, '2120 Airport Rd, Wichita, KS 67209', 'KS'),
      ('Atlantic Aviation MHK', 39.1409, -96.6708, '1725 K-18, Manhattan, KS 66503', 'KS'),

      -- Missouri FBOs
      ('Signature Flight Support MCI', 39.2976, -94.7139, '10 Richards Rd, Kansas City, MO 64153', 'MO'),
      ('Atlantic Aviation MCI', 39.2980, -94.7135, '201 NW Lou Holland Dr, Kansas City, MO 64153', 'MO'),
      ('Signature Flight Support STL', 38.7487, -90.3700, '10897 Lambert International Blvd, St. Louis, MO 63145', 'MO'),
      ('Million Air STL', 38.7483, -90.3695, '10897 Lambert International Blvd, St. Louis, MO 63145', 'MO')
  ) as fbo(name, latitude, longitude, address, state)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'KOKC', 'KTUL', 'KICT', 'KMHK', 'KMCI', 'KSTL'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%OKC%' THEN 'KOKC'
      WHEN fbo.name LIKE '%TUL%' THEN 'KTUL'
      WHEN fbo.name LIKE '%ICT%' THEN 'KICT'
      WHEN fbo.name LIKE '%MHK%' THEN 'KMHK'
      WHEN fbo.name LIKE '%MCI%' THEN 'KMCI'
      WHEN fbo.name LIKE '%STL%' THEN 'KSTL'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;