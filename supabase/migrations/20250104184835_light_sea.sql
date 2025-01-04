-- Add ICAOs for Canadian Provinces
DO $$ 
BEGIN
  -- Insert ICAO codes
  INSERT INTO icaos (code, name, country, continent, latitude, longitude)
  VALUES
    -- Newfoundland Airports
    ('CYYT', 'St. John''s International Airport', 'Canada', 'North America', 47.6186, -52.7519),
    ('CYQX', 'Gander International Airport', 'Canada', 'North America', 48.9369, -54.5680),
    ('CYDF', 'Deer Lake Regional Airport', 'Canada', 'North America', 49.2108, -57.3914),
    ('CYQM', 'Greater Moncton Roméo LeBlanc International', 'Canada', 'North America', 46.1122, -64.6786),
    ('CYSJ', 'Saint John Airport', 'Canada', 'North America', 45.3161, -65.8902),
    ('CYFC', 'Fredericton International Airport', 'Canada', 'North America', 45.8689, -66.5372),

    -- Quebec Airports
    ('CYUL', 'Montréal-Pierre Elliott Trudeau International', 'Canada', 'North America', 45.4706, -73.7408),
    ('CYQB', 'Québec City Jean Lesage International', 'Canada', 'North America', 46.7911, -71.3933),
    ('CYMX', 'Montréal-Mirabel International Airport', 'Canada', 'North America', 45.6797, -74.0387),
    ('CYHU', 'Montréal/Saint-Hubert Airport', 'Canada', 'North America', 45.5175, -73.4169),
    ('CYYY', 'Mont-Joli Airport', 'Canada', 'North America', 48.6086, -68.2081),
    ('CYVO', 'Val-d''Or Airport', 'Canada', 'North America', 48.0533, -77.7828),
    ('CYGP', 'Michel-Pouliot Gaspé Airport', 'Canada', 'North America', 48.7753, -64.4786),
    ('CYBC', 'Baie-Comeau Airport', 'Canada', 'North America', 49.1325, -68.2044),

    -- Ontario Additional Airports
    ('CYOW', 'Ottawa Macdonald-Cartier International', 'Canada', 'North America', 45.3225, -75.6692),
    ('CYKF', 'Region of Waterloo International Airport', 'Canada', 'North America', 43.4608, -80.3847),
    ('CYXU', 'London International Airport', 'Canada', 'North America', 43.0336, -81.1511),
    ('CYHM', 'John C. Munro Hamilton International', 'Canada', 'North America', 43.1736, -79.9347),
    ('CYTS', 'Timmins Victor M. Power Airport', 'Canada', 'North America', 48.5697, -81.3767),
    ('CYSB', 'Sudbury Airport', 'Canada', 'North America', 46.6250, -80.7989),
    ('CYQT', 'Thunder Bay International Airport', 'Canada', 'North America', 48.3719, -89.3239),
    ('CYKZ', 'Toronto/Buttonville Municipal Airport', 'Canada', 'North America', 43.8622, -79.3703),

    -- Manitoba Additional Airports
    ('CYQD', 'The Pas Airport', 'Canada', 'North America', 53.9714, -101.0917),
    ('CYNE', 'Norway House Airport', 'Canada', 'North America', 53.9583, -97.8442),
    ('CYFO', 'Flin Flon Airport', 'Canada', 'North America', 54.6781, -101.6819),
    ('CZWL', 'Wollaston Lake Airport', 'Canada', 'North America', 58.1067, -103.1719),
    ('CYTH', 'Thompson Airport', 'Canada', 'North America', 55.8011, -97.8642),
    ('CYGX', 'Gillam Airport', 'Canada', 'North America', 56.3575, -94.7106),

    -- Saskatchewan Additional Airports
    ('CYVC', 'La Ronge Airport', 'Canada', 'North America', 55.1514, -105.2622),
    ('CYSF', 'Stony Rapids Airport', 'Canada', 'North America', 59.2503, -105.8417),
    ('CYYN', 'Swift Current Airport', 'Canada', 'North America', 50.2919, -107.6914),
    ('CYKY', 'Kindersley Airport', 'Canada', 'North America', 51.5175, -109.1806),
    ('CYBU', 'Nipawin Airport', 'Canada', 'North America', 53.3342, -104.0014),
    ('CZMJ', 'Meadow Lake Airport', 'Canada', 'North America', 54.1253, -108.5228),

    -- Northwest Territories Airports
    ('CYZF', 'Yellowknife Airport', 'Canada', 'North America', 62.4628, -114.4403),
    ('CYHY', 'Hay River Airport', 'Canada', 'North America', 60.8397, -115.7833),
    ('CYFS', 'Fort Simpson Airport', 'Canada', 'North America', 61.7602, -121.2367),
    ('CYJF', 'Fort Liard Airport', 'Canada', 'North America', 60.2358, -123.4692),
    ('CYGH', 'Fort Good Hope Airport', 'Canada', 'North America', 66.2407, -128.6508),
    ('CYUB', 'Tuktoyaktuk/James Gruben Airport', 'Canada', 'North America', 69.4333, -133.0261),
    ('CYEV', 'Inuvik Mike Zubko Airport', 'Canada', 'North America', 68.3042, -133.4831),
    ('CYPC', 'Paulatuk Airport', 'Canada', 'North America', 69.3611, -124.0756)
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

  -- Update ICAO types
  -- Major International Hubs
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'major_international'
  )
  WHERE code IN ('CYUL', 'CYOW');

  -- International Airports
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'international'
  )
  WHERE code IN (
    'CYYT', 'CYQX', 'CYQB', 'CYHM', 'CYXU',
    'CYQT', 'CYZF'
  );

  -- Regional Airports
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'regional'
  )
  WHERE code IN (
    'CYDF', 'CYQM', 'CYSJ', 'CYFC',
    'CYMX', 'CYHU', 'CYYY', 'CYVO', 'CYGP', 'CYBC',
    'CYKF', 'CYTS', 'CYSB',
    'CYQD', 'CYNE', 'CYFO', 'CYTH',
    'CYVC', 'CYSF', 'CYYN',
    'CYHY', 'CYFS', 'CYEV'
  );

  -- Add FBO locations for major airports
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'Canada'
  FROM (
    VALUES 
      -- Montreal (CYUL)
      ('Signature Flight Support YUL', 45.4706, -73.7408, '9785 Avenue Ryan, Dorval, QC H9P 1A2'),
      ('Skyservice FBO YUL', 45.4709, -73.7405, '9501 Avenue Ryan, Dorval, QC H9P 1A2'),
      ('Starlink Aviation', 45.4712, -73.7410, '9960 Côte de Liesse, Dorval, QC H9P 1A2'),

      -- Ottawa (CYOW)
      ('Skyservice FBO YOW', 45.3225, -75.6692, '11 Canadair Private, Ottawa, ON K1V 1C1'),
      ('Executive Aviation YOW', 45.3228, -75.6689, '1000 Private, Ottawa, ON K1V 1C1'),
      
      -- St. John's (CYYT)
      ('Irving Aviation Services', 47.6186, -52.7519, '80 Airport Terminal Access Rd, St. John''s, NL A1A 5B4'),
      ('Provincial Airlines', 47.6182, -52.7515, '85 Airport Terminal Access Rd, St. John''s, NL A1A 5B4'),

      -- Quebec City (CYQB)
      ('Skyservice FBO YQB', 46.7911, -71.3933, '700 7e Rue de l''Aéroport, Québec, QC G2G 2S8'),
      ('Avjet YQB', 46.7915, -71.3937, '800 7e Rue de l''Aéroport, Québec, QC G2G 2S8')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'CYUL', 'CYOW', 'CYYT', 'CYQB'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%YUL%' OR fbo.name LIKE '%Starlink%' THEN 'CYUL'
      WHEN fbo.name LIKE '%YOW%' THEN 'CYOW'
      WHEN fbo.name LIKE '%Irving%' OR fbo.name LIKE '%Provincial%' THEN 'CYYT'
      WHEN fbo.name LIKE '%YQB%' THEN 'CYQB'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;