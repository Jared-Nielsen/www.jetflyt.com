-- Add Asian and Oceanian airports and their FBOs
DO $$ 
BEGIN
  -- Insert ICAO codes for South Asian countries
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- India Major
    ('VIDP', 'Indira Gandhi International Airport', 'India', 'Asia', 28.5562, 77.1000,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('VABB', 'Chhatrapati Shivaji International Airport', 'India', 'Asia', 19.0896, 72.8656,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('VOBL', 'Kempegowda International Airport', 'India', 'Asia', 13.1986, 77.7066,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('VECC', 'Netaji Subhas Chandra Bose International', 'India', 'Asia', 22.6520, 88.4467,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Pakistan Major
    ('OPKC', 'Jinnah International Airport', 'Pakistan', 'Asia', 24.9065, 67.1608,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('OPRN', 'Benazir Bhutto International Airport', 'Pakistan', 'Asia', 33.6167, 73.0991,
      (SELECT id FROM icao_types WHERE name = 'international'))
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    icao_type_id = EXCLUDED.icao_type_id;

  -- Insert ICAO codes for Central Asian countries
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- Uzbekistan
    ('UTTT', 'Tashkent International Airport', 'Uzbekistan', 'Asia', 41.2573, 69.2817,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('UTSS', 'Samarkand International Airport', 'Uzbekistan', 'Asia', 39.7005, 66.9838,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Turkmenistan
    ('UTAA', 'Ashgabat International Airport', 'Turkmenistan', 'Asia', 37.9868, 58.3610,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('UTAT', 'Türkmenabat International Airport', 'Turkmenistan', 'Asia', 39.0833, 63.6133,
      (SELECT id FROM icao_types WHERE name = 'international'))
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    icao_type_id = EXCLUDED.icao_type_id;

  -- Insert ICAO codes for Southeast Asian countries
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- Malaysia
    ('WMKK', 'Kuala Lumpur International Airport', 'Malaysia', 'Asia', 2.7456, 101.7099,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('WMSA', 'Sultan Abdul Aziz Shah Airport', 'Malaysia', 'Asia', 3.1303, 101.5492,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Vietnam
    ('VVNB', 'Noi Bai International Airport', 'Vietnam', 'Asia', 21.2187, 105.8055,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('VVTS', 'Tan Son Nhat International Airport', 'Vietnam', 'Asia', 10.8188, 106.6520,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Cambodia
    ('VDPP', 'Phnom Penh International Airport', 'Cambodia', 'Asia', 11.5466, 104.8444,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('VDSR', 'Siem Reap International Airport', 'Cambodia', 'Asia', 13.4117, 103.8135,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Philippines
    ('RPLL', 'Ninoy Aquino International Airport', 'Philippines', 'Asia', 14.5086, 121.0194,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('RPLC', 'Clark International Airport', 'Philippines', 'Asia', 15.1859, 120.5594,
      (SELECT id FROM icao_types WHERE name = 'international'))
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    icao_type_id = EXCLUDED.icao_type_id;

  -- Insert ICAO codes for East Asian and Oceanian countries
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- Mongolia
    ('ZMUB', 'Chinggis Khaan International Airport', 'Mongolia', 'Asia', 47.8431, 106.7666,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Papua New Guinea
    ('AYPY', 'Jacksons International Airport', 'Papua New Guinea', 'Oceania', -9.4438, 147.2200,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('AYNZ', 'Nadzab Airport', 'Papua New Guinea', 'Oceania', -6.5698, 146.7262,
      (SELECT id FROM icao_types WHERE name = 'regional')),

    -- Iran
    ('OIIE', 'Imam Khomeini International Airport', 'Iran', 'Asia', 35.4161, 51.1522,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('OIII', 'Mehrabad International Airport', 'Iran', 'Asia', 35.6892, 51.3134,
      (SELECT id FROM icao_types WHERE name = 'international'))
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    icao_type_id = EXCLUDED.icao_type_id;

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
      -- Delhi (VIDP)
      ('Bird ExecuJet', 28.5562, 77.1000, 'General Aviation Terminal, IGI Airport', 'India'),
      ('Indamer Aviation', 28.5558, 77.0996, 'Business Aviation Centre, Terminal 1D', 'India'),

      -- Mumbai (VABB)
      ('Universal Aviation BOM', 19.0896, 72.8656, 'General Aviation Terminal, CSIA', 'India'),
      ('Taj Air FBO', 19.0892, 72.8652, 'Business Aviation Terminal, Mumbai Airport', 'India'),

      -- Kuala Lumpur (WMKK)
      ('Skypark FBO Malaysia', 2.7456, 101.7099, 'Sultan Abdul Aziz Shah Airport', 'Malaysia'),
      ('ExecuJet Malaysia', 2.7452, 101.7095, 'Business Aviation Centre, KLIA', 'Malaysia'),

      -- Manila (RPLL)
      ('Asian Aerospace FBO', 14.5086, 121.0194, 'General Aviation Terminal, NAIA', 'Philippines'),
      ('INAEC Aviation', 14.5082, 121.0190, 'Business Aviation Center, Manila Airport', 'Philippines'),

      -- Tehran IKA (OIIE)
      ('Iran Air FBO Services', 35.4161, 51.1522, 'General Aviation Terminal, IKA Airport', 'Iran'),
      ('Tehran Business Aviation', 35.4157, 51.1518, 'VIP Terminal, Imam Khomeini Airport', 'Iran'),

      -- Hanoi (VVNB)
      ('Vietnam Air Service Company', 21.2187, 105.8055, 'General Aviation Terminal, Noi Bai Airport', 'Vietnam'),
      ('Hanoi Business Aviation', 21.2183, 105.8051, 'VIP Terminal, Noi Bai International', 'Vietnam'),

      -- Phnom Penh (VDPP)
      ('Cambodia Air Services', 11.5466, 104.8444, 'Business Aviation Center, Phnom Penh Airport', 'Cambodia'),
      ('Royal Aviation Services', 11.5462, 104.8440, 'VIP Terminal, Phnom Penh International', 'Cambodia'),

      -- Tashkent (UTTT)
      ('Uzbekistan Airways FBO', 41.2573, 69.2817, 'Business Aviation Terminal, Tashkent Airport', 'Uzbekistan'),
      ('Central Asia Ground Services', 41.2569, 69.2813, 'VIP Terminal, Tashkent International', 'Uzbekistan')
  ) as fbo(name, latitude, longitude, address, country)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'VIDP', 'VABB', 'WMKK', 'RPLL', 'OIIE', 'VVNB', 'VDPP', 'UTTT'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%Bird%' OR fbo.name LIKE '%Indamer%' THEN 'VIDP'
      WHEN fbo.name LIKE '%BOM%' OR fbo.name LIKE '%Taj Air%' THEN 'VABB'
      WHEN fbo.name LIKE '%Skypark%' OR fbo.name LIKE '%ExecuJet Malaysia%' THEN 'WMKK'
      WHEN fbo.name LIKE '%Asian Aerospace%' OR fbo.name LIKE '%INAEC%' THEN 'RPLL'
      WHEN fbo.name LIKE '%Iran Air%' OR fbo.name LIKE '%Tehran%' THEN 'OIIE'
      WHEN fbo.name LIKE '%Vietnam Air%' OR fbo.name LIKE '%Hanoi%' THEN 'VVNB'
      WHEN fbo.name LIKE '%Cambodia%' OR fbo.name LIKE '%Royal Aviation%' THEN 'VDPP'
      WHEN fbo.name LIKE '%Uzbekistan%' OR fbo.name LIKE '%Central Asia%' THEN 'UTTT'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;