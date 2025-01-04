-- Add African airports and their FBOs
DO $$ 
BEGIN
  -- Insert ICAO codes for North African countries
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- Morocco
    ('GMMN', 'Mohammed V International Airport', 'Morocco', 'Africa', 33.3675, -7.5900,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('GMMX', 'Marrakesh Menara Airport', 'Morocco', 'Africa', 31.6069, -8.0363,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('GMTT', 'Tangier Ibn Battouta Airport', 'Morocco', 'Africa', 35.7269, -5.9168,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Egypt
    ('HECA', 'Cairo International Airport', 'Egypt', 'Africa', 30.1219, 31.4056,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('HEGN', 'Hurghada International Airport', 'Egypt', 'Africa', 27.1783, 33.7994,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('HESH', 'Sharm El Sheikh International Airport', 'Egypt', 'Africa', 27.9773, 34.3950,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Tunisia
    ('DTTA', 'Tunis-Carthage International Airport', 'Tunisia', 'Africa', 36.8510, 10.2272,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('DTMB', 'Djerba-Zarzis International Airport', 'Tunisia', 'Africa', 33.8757, 10.7755,
      (SELECT id FROM icao_types WHERE name = 'international'));

  -- Insert ICAO codes for West African countries
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- Nigeria
    ('DNMM', 'Murtala Muhammed International Airport', 'Nigeria', 'Africa', 6.5774, 3.3215,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('DNAA', 'Nnamdi Azikiwe International Airport', 'Nigeria', 'Africa', 9.0065, 7.2631,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Ghana
    ('DGAA', 'Kotoka International Airport', 'Ghana', 'Africa', 5.6052, -0.1668,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('DGLE', 'Tamale Airport', 'Ghana', 'Africa', 9.5577, -0.8632,
      (SELECT id FROM icao_types WHERE name = 'regional')),

    -- Senegal
    ('GOBD', 'Blaise Diagne International Airport', 'Senegal', 'Africa', 14.6710, -17.0733,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('GOGS', 'Cap Skirring Airport', 'Senegal', 'Africa', 12.4102, -16.7462,
      (SELECT id FROM icao_types WHERE name = 'regional'));

  -- Insert ICAO codes for East African countries
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- Kenya
    ('HKJK', 'Jomo Kenyatta International Airport', 'Kenya', 'Africa', -1.3192, 36.9278,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('HKMO', 'Mombasa Moi International Airport', 'Kenya', 'Africa', -4.0348, 39.5942,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Tanzania
    ('HTDA', 'Julius Nyerere International Airport', 'Tanzania', 'Africa', -6.8778, 39.2026,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('HTZA', 'Abeid Amani Karume International Airport', 'Tanzania', 'Africa', -6.2224, 39.2244,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Ethiopia
    ('HAAB', 'Addis Ababa Bole International Airport', 'Ethiopia', 'Africa', 8.9778, 38.7989,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('HADR', 'Dire Dawa Airport', 'Ethiopia', 'Africa', 9.6247, 41.8542,
      (SELECT id FROM icao_types WHERE name = 'regional'));

  -- Insert ICAO codes for Southern African countries
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- South Africa
    ('FAOR', 'O.R. Tambo International Airport', 'South Africa', 'Africa', -26.1325, 28.2424,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('FACT', 'Cape Town International Airport', 'South Africa', 'Africa', -33.9715, 18.6021,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('FALE', 'King Shaka International Airport', 'South Africa', 'Africa', -29.6144, 31.1197,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Namibia
    ('FYWH', 'Hosea Kutako International Airport', 'Namibia', 'Africa', -22.4799, 17.4709,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('FYWE', 'Walvis Bay Airport', 'Namibia', 'Africa', -22.9799, 14.6453,
      (SELECT id FROM icao_types WHERE name = 'regional')),

    -- Botswana
    ('FBSK', 'Sir Seretse Khama International Airport', 'Botswana', 'Africa', -24.5553, 25.9183,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('FBMN', 'Maun Airport', 'Botswana', 'Africa', -19.9726, 23.4311,
      (SELECT id FROM icao_types WHERE name = 'regional'));

  -- Add FBO locations
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    fbo.country
  FROM (
    VALUES 
      -- Cairo (HECA)
      ('Jetex Cairo', 30.1219, 31.4056, 'Private Aviation Terminal, Cairo International Airport', 'Egypt'),
      ('ExecuJet Cairo', 30.1215, 31.4052, 'Business Aviation Center, Cairo Airport', 'Egypt'),

      -- Johannesburg (FAOR)
      ('ExecuJet O.R. Tambo', -26.1325, 28.2424, 'General Aviation Terminal, O.R. Tambo International', 'South Africa'),
      ('National Airways Corporation', -26.1321, 28.2420, 'Hangar 104, O.R. Tambo International', 'South Africa'),

      -- Cape Town (FACT)
      ('ExecuJet Cape Town', -33.9715, 18.6021, 'General Aviation Area, Cape Town International Airport', 'South Africa'),
      ('NAC Cape Town', -33.9711, 18.6017, 'General Aviation Terminal, Cape Town International', 'South Africa'),

      -- Nairobi (HKJK)
      ('Africair FBO', -1.3192, 36.9278, 'General Aviation Terminal, JKIA', 'Kenya'),
      ('Kenya Aero Club', -1.3188, 36.9274, 'Private Aviation Center, JKIA', 'Kenya'),

      -- Lagos (DNMM)
      ('ExecuJet Nigeria', 6.5774, 3.3215, 'General Aviation Terminal, Murtala Muhammed Airport', 'Nigeria'),
      ('Evergreen Apple Nigeria', 6.5770, 3.3211, 'Private Aviation Terminal, Lagos Airport', 'Nigeria'),

      -- Casablanca (GMMN)
      ('Jetex Casablanca', 33.3675, -7.5900, 'Terminal VIP, Mohammed V International Airport', 'Morocco'),
      ('Swissport Executive Aviation', 33.3671, -7.5896, 'FBO Terminal, Casablanca Airport', 'Morocco'),

      -- Marrakesh (GMMX)
      ('Jetex Marrakesh', 31.6069, -8.0363, 'Terminal VIP, Marrakesh Menara Airport', 'Morocco'),
      ('Swissport Executive MRA', 31.6065, -8.0359, 'General Aviation Terminal, Menara Airport', 'Morocco'),

      -- Addis Ababa (HAAB)
      ('National Airways Ethiopia', 8.9778, 38.7989, 'VIP Terminal, Bole International Airport', 'Ethiopia'),
      ('Ethiopian Aviation Academy', 8.9774, 38.7985, 'General Aviation Center, Bole Airport', 'Ethiopia')
  ) as fbo(name, latitude, longitude, address, country)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'HECA', 'FAOR', 'FACT', 'HKJK', 'DNMM', 'GMMN', 'GMMX', 'HAAB'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%Cairo%' THEN 'HECA'
      WHEN fbo.name LIKE '%O.R. Tambo%' OR fbo.name LIKE '%National Airways Corporation%' THEN 'FAOR'
      WHEN fbo.name LIKE '%Cape Town%' THEN 'FACT'
      WHEN fbo.name LIKE '%Africair%' OR fbo.name LIKE '%Kenya Aero%' THEN 'HKJK'
      WHEN fbo.name LIKE '%Nigeria%' THEN 'DNMM'
      WHEN fbo.name LIKE '%Casablanca%' THEN 'GMMN'
      WHEN fbo.name LIKE '%Marrakesh%' OR fbo.name LIKE '%MRA%' THEN 'GMMX'
      WHEN fbo.name LIKE '%Ethiopia%' OR fbo.name LIKE '%Bole%' THEN 'HAAB'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;