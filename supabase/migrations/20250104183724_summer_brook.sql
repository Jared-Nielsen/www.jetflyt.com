-- Add ICAOs for Southeast states
DO $$ 
BEGIN
  -- Insert ICAO codes
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  VALUES
    -- Georgia Airports
    ('KATL', 'Hartsfield-Jackson Atlanta International', 'GA', 'United States', 'North America', 33.6367, -84.4281),
    ('KSAV', 'Savannah/Hilton Head International', 'GA', 'United States', 'North America', 32.1276, -81.2020),
    ('KPDK', 'DeKalb-Peachtree Airport', 'GA', 'United States', 'North America', 33.8756, -84.3020),
    ('KMCN', 'Middle Georgia Regional Airport', 'GA', 'United States', 'North America', 32.6927, -83.6492),
    ('KVLD', 'Valdosta Regional Airport', 'GA', 'United States', 'North America', 30.7825, -83.2767),
    ('KABY', 'Southwest Georgia Regional Airport', 'GA', 'United States', 'North America', 31.5355, -84.1945),
    ('KCSG', 'Columbus Airport', 'GA', 'United States', 'North America', 32.5163, -84.9389),
    ('KFTY', 'Fulton County Airport-Brown Field', 'GA', 'United States', 'North America', 33.7790, -84.5214),

    -- Florida Airports
    ('KMIA', 'Miami International Airport', 'FL', 'United States', 'North America', 25.7932, -80.2906),
    ('KMCO', 'Orlando International Airport', 'FL', 'United States', 'North America', 28.4294, -81.3089),
    ('KTPA', 'Tampa International Airport', 'FL', 'United States', 'North America', 27.9755, -82.5332),
    ('KFLL', 'Fort Lauderdale-Hollywood International', 'FL', 'United States', 'North America', 26.0726, -80.1527),
    ('KJAX', 'Jacksonville International Airport', 'FL', 'United States', 'North America', 30.4941, -81.6879),
    ('KRSW', 'Southwest Florida International Airport', 'FL', 'United States', 'North America', 26.5362, -81.7552),
    ('KPBI', 'Palm Beach International Airport', 'FL', 'United States', 'North America', 26.6832, -80.0956),
    ('KPNS', 'Pensacola International Airport', 'FL', 'United States', 'North America', 30.4734, -87.1866),
    ('KTLH', 'Tallahassee International Airport', 'FL', 'United States', 'North America', 30.3965, -84.3503),
    ('KMLB', 'Melbourne Orlando International Airport', 'FL', 'United States', 'North America', 28.1028, -80.6453),

    -- South Carolina Airports
    ('KCHS', 'Charleston International Airport', 'SC', 'United States', 'North America', 32.8986, -80.0405),
    ('KCAE', 'Columbia Metropolitan Airport', 'SC', 'United States', 'North America', 33.9388, -81.1195),
    ('KGSP', 'Greenville-Spartanburg International', 'SC', 'United States', 'North America', 34.8957, -82.2189),
    ('KMYR', 'Myrtle Beach International Airport', 'SC', 'United States', 'North America', 33.6797, -78.9283),
    ('KHXD', 'Hilton Head Airport', 'SC', 'United States', 'North America', 32.2243, -80.6975),
    ('KFLO', 'Florence Regional Airport', 'SC', 'United States', 'North America', 34.1854, -79.7239),

    -- North Carolina Airports
    ('KCLT', 'Charlotte Douglas International Airport', 'NC', 'United States', 'North America', 35.2140, -80.9431),
    ('KRDU', 'Raleigh-Durham International Airport', 'NC', 'United States', 'North America', 35.8776, -78.7875),
    ('KGSO', 'Piedmont Triad International Airport', 'NC', 'United States', 'North America', 36.0978, -79.9373),
    ('KAVL', 'Asheville Regional Airport', 'NC', 'United States', 'North America', 35.4361, -82.5418),
    ('KILM', 'Wilmington International Airport', 'NC', 'United States', 'North America', 34.2706, -77.9027),
    ('KFAY', 'Fayetteville Regional Airport', 'NC', 'United States', 'North America', 34.9912, -78.8803),
    ('KOAJ', 'Albert J Ellis Airport', 'NC', 'United States', 'North America', 34.8292, -77.6121),
    ('KJQF', 'Concord-Padgett Regional Airport', 'NC', 'United States', 'North America', 35.3877, -80.7089),

    -- Tennessee Airports
    ('KBNA', 'Nashville International Airport', 'TN', 'United States', 'North America', 36.1245, -86.6782),
    ('KMEM', 'Memphis International Airport', 'TN', 'United States', 'North America', 35.0424, -89.9767),
    ('KTYS', 'McGhee Tyson Airport', 'TN', 'United States', 'North America', 35.8110, -83.9940),
    ('KCHA', 'Lovell Field', 'TN', 'United States', 'North America', 35.0353, -85.2038),
    ('KTRI', 'Tri-Cities Airport', 'TN', 'United States', 'North America', 36.4752, -82.4074),
    ('KMKL', 'McKellar-Sipes Regional Airport', 'TN', 'United States', 'North America', 35.5999, -88.9156)
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
  WHERE code IN ('KATL', 'KMIA', 'KCLT');

  -- International Airports
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'international'
  )
  WHERE code IN (
    'KMCO', 'KTPA', 'KFLL', 'KBNA', 'KMEM', 'KRDU',
    'KCHS', 'KGSP', 'KJAX', 'KRSW', 'KPBI'
  );

  -- Regional Airports
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'regional'
  )
  WHERE code IN (
    'KSAV', 'KMCN', 'KVLD', 'KABY', 'KCSG',
    'KPNS', 'KTLH', 'KMLB', 'KCAE', 'KMYR',
    'KFLO', 'KGSO', 'KAVL', 'KILM', 'KFAY',
    'KOAJ', 'KTYS', 'KCHA', 'KTRI', 'KMKL'
  );

  -- General Aviation
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'general_aviation'
  )
  WHERE code IN ('KPDK', 'KFTY', 'KHXD', 'KJQF');

  -- Cargo Hub
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'cargo'
  )
  WHERE code = 'KMEM';

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
      -- Atlanta (KATL)
      ('Signature Flight Support ATL', 33.6367, -84.4281, '1200 Toffie Terrace, Atlanta, GA 30354', 'GA'),
      ('Atlantic Aviation ATL', 33.6363, -84.4277, '2040 Toffie Terrace, Atlanta, GA 30354', 'GA'),

      -- Miami (KMIA)
      ('Signature Flight Support MIA', 25.7932, -80.2906, '5000 NW 36th St, Miami, FL 33122', 'FL'),
      ('Atlantic Aviation MIA', 25.7928, -80.2902, '6500 NW 22nd St, Miami, FL 33122', 'FL'),

      -- Orlando (KMCO)
      ('Signature Flight Support MCO', 28.4294, -81.3089, '5901 Butler National Dr, Orlando, FL 32822', 'FL'),
      ('Atlantic Aviation MCO', 28.4290, -81.3085, '6023 Cargo Rd, Orlando, FL 32827', 'FL'),

      -- Charlotte (KCLT)
      ('Wilson Air Center CLT', 35.2140, -80.9431, '4530 Airport Dr, Charlotte, NC 28208', 'NC'),
      ('Signature Flight Support CLT', 35.2136, -80.9427, '4108 Airport Dr, Charlotte, NC 28208', 'NC'),

      -- Nashville (KBNA)
      ('Atlantic Aviation BNA', 36.1245, -86.6782, '801 Hangar Ln, Nashville, TN 37217', 'TN'),
      ('Signature Flight Support BNA', 36.1241, -86.6778, '937 Airport Service Rd, Nashville, TN 37217', 'TN'),

      -- Memphis (KMEM)
      ('Signature Flight Support MEM', 35.0424, -89.9767, '2488 Winchester Rd, Memphis, TN 38116', 'TN'),
      ('Wilson Air Center MEM', 35.0420, -89.9763, '2930 Winchester Rd, Memphis, TN 38118', 'TN')
  ) as fbo(name, latitude, longitude, address, state)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'KATL', 'KMIA', 'KMCO', 'KCLT', 'KBNA', 'KMEM'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%ATL%' THEN 'KATL'
      WHEN fbo.name LIKE '%MIA%' THEN 'KMIA'
      WHEN fbo.name LIKE '%MCO%' THEN 'KMCO'
      WHEN fbo.name LIKE '%CLT%' THEN 'KCLT'
      WHEN fbo.name LIKE '%BNA%' THEN 'KBNA'
      WHEN fbo.name LIKE '%MEM%' THEN 'KMEM'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;