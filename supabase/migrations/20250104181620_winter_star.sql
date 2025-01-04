-- Add FBOs for New York State airports
DO $$ 
BEGIN
  -- First ensure all required ICAO codes exist
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  VALUES
    -- Major International
    ('KJFK', 'John F. Kennedy International Airport', 'NY', 'United States', 'North America', 40.6413, -73.7781),
    ('KLGA', 'LaGuardia Airport', 'NY', 'United States', 'North America', 40.7769, -73.8740),
    -- Regional
    ('KALB', 'Albany International Airport', 'NY', 'United States', 'North America', 42.7483, -73.8017),
    ('KBUF', 'Buffalo Niagara International Airport', 'NY', 'United States', 'North America', 42.9405, -78.7322),
    ('KISP', 'Long Island MacArthur Airport', 'NY', 'United States', 'North America', 40.7952, -73.1002),
    ('KROC', 'Frederick Douglass Greater Rochester International', 'NY', 'United States', 'North America', 43.1189, -77.6724),
    ('KSYR', 'Syracuse Hancock International Airport', 'NY', 'United States', 'North America', 43.1112, -76.1063),
    -- Local/Executive
    ('KHPN', 'Westchester County Airport', 'NY', 'United States', 'North America', 41.0670, -73.7076),
    ('KFRG', 'Republic Airport', 'NY', 'United States', 'North America', 40.7288, -73.4134),
    ('KSWF', 'New York Stewart International Airport', 'NY', 'United States', 'North America', 41.5040, -74.1047),
    ('KITH', 'Ithaca Tompkins International Airport', 'NY', 'United States', 'North America', 42.4913, -76.4584),
    ('KBGM', 'Greater Binghamton Airport', 'NY', 'United States', 'North America', 42.2087, -75.9795)
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    state = EXCLUDED.state,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

  -- Add FBO locations
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country, state)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'USA',
    'NY'
  FROM (
    VALUES 
      -- JFK
      ('Sheltair JFK', 40.6413, -73.7781, '145-50 157th Street, Jamaica, NY 11434'),
      ('Signature Flight Support JFK', 40.6410, -73.7778, 'Building 145, Jamaica, NY 11430'),
      
      -- LaGuardia
      ('Signature Flight Support LGA', 40.7769, -73.8740, 'Hangar 7, Flushing, NY 11371'),
      ('SheltairAviation LGA', 40.7765, -73.8735, '23-50 87th Street, East Elmhurst, NY 11369'),
      
      -- Albany
      ('Million Air ALB', 42.7483, -73.8017, '1 Airport Rd, Albany, NY 12211'),
      ('Signature Flight Support ALB', 42.7480, -73.8014, '6 Airport Park Blvd, Latham, NY 12110'),
      
      -- Buffalo
      ('TAC Air BUF', 42.9405, -78.7322, '485 Cayuga Rd, Buffalo, NY 14225'),
      ('Prior Aviation Service', 42.9402, -78.7319, '50 North Airport Drive, Buffalo, NY 14225'),
      
      -- Long Island MacArthur
      ('Sheltair ISP', 40.7952, -73.1002, '100 Arrival Ave, Ronkonkoma, NY 11779'),
      ('Hawthorne Global Aviation Services', 40.7949, -73.0999, '3950 Veterans Memorial Hwy, Ronkonkoma, NY 11779'),
      
      -- Rochester
      ('USAirports FBO ROC', 43.1189, -77.6724, '1295 Scottsville Rd, Rochester, NY 14624'),
      ('Signature Flight Support ROC', 43.1186, -77.6721, '1285 Scottsville Rd, Rochester, NY 14624'),
      
      -- Syracuse
      ('Signature Flight Support SYR', 43.1112, -76.1063, '248 Tuskegee Rd, Syracuse, NY 13211'),
      
      -- Westchester
      ('Million Air HPN', 41.0670, -73.7076, '136 Tower Rd, White Plains, NY 10604'),
      ('Signature Flight Support HPN', 41.0667, -73.7073, '85 Tower Rd, White Plains, NY 10604'),
      ('Ross Aviation HPN', 41.0673, -73.7079, '67 Tower Rd, White Plains, NY 10604'),
      
      -- Republic
      ('Sheltair FRG', 40.7288, -73.4134, '7150 Republic Airport, East Farmingdale, NY 11735'),
      ('Atlantic Aviation FRG', 40.7285, -73.4131, '7160 Republic Airport, East Farmingdale, NY 11735'),
      
      -- Stewart
      ('Signature Flight Support SWF', 41.5040, -74.1047, '1032 1st St, New Windsor, NY 12553'),
      ('Atlantic Aviation SWF', 41.5037, -74.1044, '1035 1st St, New Windsor, NY 12553'),
      
      -- Ithaca
      ('Taughannock Aviation', 42.4913, -76.4584, '66 Brown Road, Ithaca, NY 14850'),
      
      -- Binghamton
      ('FirstAir BGM', 42.2087, -75.9795, '2534 Airport Rd, Johnson City, NY 13790')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'KJFK', 'KLGA', 'KALB', 'KBUF', 'KISP', 'KROC', 'KSYR',
      'KHPN', 'KFRG', 'KSWF', 'KITH', 'KBGM'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%JFK%' THEN 'KJFK'
      WHEN fbo.name LIKE '%LGA%' THEN 'KLGA'
      WHEN fbo.name LIKE '%ALB%' THEN 'KALB'
      WHEN fbo.name LIKE '%BUF%' OR fbo.name LIKE '%Prior%' THEN 'KBUF'
      WHEN fbo.name LIKE '%ISP%' THEN 'KISP'
      WHEN fbo.name LIKE '%ROC%' THEN 'KROC'
      WHEN fbo.name LIKE '%SYR%' THEN 'KSYR'
      WHEN fbo.name LIKE '%HPN%' THEN 'KHPN'
      WHEN fbo.name LIKE '%FRG%' THEN 'KFRG'
      WHEN fbo.name LIKE '%SWF%' THEN 'KSWF'
      WHEN fbo.name LIKE '%Taughannock%' THEN 'KITH'
      WHEN fbo.name LIKE '%BGM%' THEN 'KBGM'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;