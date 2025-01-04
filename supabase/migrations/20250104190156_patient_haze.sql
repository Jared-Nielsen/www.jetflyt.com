-- Add European and Asian airports and their FBOs
DO $$ 
BEGIN
  -- Insert ICAO codes for Nordic countries
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- Norway Major
    ('ENGM', 'Oslo Gardermoen Airport', 'Norway', 'Europe', 60.1975, 11.1004,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('ENBR', 'Bergen Airport, Flesland', 'Norway', 'Europe', 60.2934, 5.2181,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Sweden Major
    ('ESSA', 'Stockholm Arlanda Airport', 'Sweden', 'Europe', 59.6519, 17.9186,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('ESGG', 'Gothenburg-Landvetter Airport', 'Sweden', 'Europe', 57.6627, 12.2798,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Denmark Major
    ('EKCH', 'Copenhagen Airport', 'Denmark', 'Europe', 55.6180, 12.6508,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('EKBI', 'Billund Airport', 'Denmark', 'Europe', 55.7403, 9.1517,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Finland Major
    ('EFHK', 'Helsinki-Vantaa Airport', 'Finland', 'Europe', 60.3172, 24.9633,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('EFOU', 'Oulu Airport', 'Finland', 'Europe', 64.9301, 25.3546,
      (SELECT id FROM icao_types WHERE name = 'international'))
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    icao_type_id = EXCLUDED.icao_type_id;

  -- Insert ICAO codes for Eastern European countries
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- Poland Major
    ('EPWA', 'Warsaw Chopin Airport', 'Poland', 'Europe', 52.1657, 20.9671,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('EPKK', 'Kraków John Paul II International Airport', 'Poland', 'Europe', 50.0777, 19.7848,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Latvia
    ('EVRA', 'Riga International Airport', 'Latvia', 'Europe', 56.9236, 23.9711,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Estonia
    ('EETN', 'Lennart Meri Tallinn Airport', 'Estonia', 'Europe', 59.4133, 24.8328,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Slovenia
    ('LJLJ', 'Ljubljana Jože Pučnik Airport', 'Slovenia', 'Europe', 46.2237, 14.4576,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Croatia
    ('LDZA', 'Zagreb Airport', 'Croatia', 'Europe', 45.7429, 16.0688,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('LDSP', 'Split Airport', 'Croatia', 'Europe', 43.5389, 16.2981,
      (SELECT id FROM icao_types WHERE name = 'international'))
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    icao_type_id = EXCLUDED.icao_type_id;

  -- Insert ICAO codes for Southern European countries
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- Italy Major
    ('LIRF', 'Leonardo da Vinci International Airport', 'Italy', 'Europe', 41.8045, 12.2508,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('LIMC', 'Milan Malpensa Airport', 'Italy', 'Europe', 45.6306, 8.7281,
      (SELECT id FROM icao_types WHERE name = 'major_international')),

    -- Greece Major
    ('LGAV', 'Athens International Airport', 'Greece', 'Europe', 37.9364, 23.9445,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('LGTS', 'Thessaloniki Airport', 'Greece', 'Europe', 40.5197, 22.9709,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Turkey Major
    ('LTFM', 'Istanbul Airport', 'Turkey', 'Europe', 41.2751, 28.7519,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('LTAC', 'Ankara Esenboğa International Airport', 'Turkey', 'Europe', 40.1281, 32.9951,
      (SELECT id FROM icao_types WHERE name = 'international'))
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    icao_type_id = EXCLUDED.icao_type_id;

  -- Insert ICAO codes for Eastern European countries
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- Hungary
    ('LHBP', 'Budapest Ferenc Liszt International Airport', 'Hungary', 'Europe', 47.4298, 19.2611,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Georgia
    ('UGTB', 'Tbilisi International Airport', 'Georgia', 'Europe', 41.6692, 44.9547,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Kosovo
    ('BKPR', 'Pristina International Airport', 'Kosovo', 'Europe', 42.5728, 21.0358,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Moldova
    ('LUKK', 'Chișinău International Airport', 'Moldova', 'Europe', 46.9277, 28.9313,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Ukraine Major
    ('UKBB', 'Boryspil International Airport', 'Ukraine', 'Europe', 50.3451, 30.8947,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('UKKK', 'Kiev International Airport', 'Ukraine', 'Europe', 50.4018, 30.4492,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Russia Major (European Part)
    ('UUEE', 'Sheremetyevo International Airport', 'Russia', 'Europe', 55.9726, 37.4146,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('UUDD', 'Domodedovo International Airport', 'Russia', 'Europe', 55.4103, 37.9026,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('ULLI', 'Pulkovo Airport', 'Russia', 'Europe', 59.8003, 30.2625,
      (SELECT id FROM icao_types WHERE name = 'international'))
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    icao_type_id = EXCLUDED.icao_type_id;

  -- Add FBO locations for major airports
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
      -- Oslo (ENGM)
      ('Signature Flight Support OSL', 60.1975, 11.1004, 'General Aviation Terminal, Oslo Airport', 'Norway'),
      ('Norse Atlantic Ground Services', 60.1970, 11.1000, 'GA Terminal, Oslo Gardermoen Airport', 'Norway'),

      -- Stockholm (ESSA)
      ('Grafair Jet Center', 59.6519, 17.9186, 'Hangar 3, Stockholm Arlanda Airport', 'Sweden'),
      ('Aviator Sweden', 59.6515, 17.9182, 'Business Aviation Terminal, Arlanda Airport', 'Sweden'),

      -- Copenhagen (EKCH)
      ('Signature Flight Support CPH', 55.6180, 12.6508, 'General Aviation Terminal, Copenhagen Airport', 'Denmark'),
      ('Copenhagen Air Center', 55.6176, 12.6504, 'Hangar 142, Københavns Lufthavn', 'Denmark'),

      -- Helsinki (EFHK)
      ('Signature Flight Support HEL', 60.3172, 24.9633, 'General Aviation Terminal, Helsinki Airport', 'Finland'),
      ('Nordic FBO Services', 60.3168, 24.9629, 'Business Flight Center, Helsinki-Vantaa', 'Finland'),

      -- Warsaw (EPWA)
      ('Executive Aviation WAW', 52.1657, 20.9671, 'General Aviation Terminal, Warsaw Chopin Airport', 'Poland'),
      ('Baltic Ground Services', 52.1653, 20.9667, 'Business Aviation Center, Chopin Airport', 'Poland'),

      -- Rome (LIRF)
      ('Sky Services Rome', 41.8045, 12.2508, 'General Aviation Terminal, Fiumicino Airport', 'Italy'),
      ('Universal Aviation FCO', 41.8041, 12.2504, 'Business Aviation Center, Leonardo da Vinci Airport', 'Italy'),

      -- Athens (LGAV)
      ('Goldair Handling ATH', 37.9364, 23.9445, 'General Aviation Terminal, Athens International Airport', 'Greece'),
      ('Universal Aviation ATH', 37.9360, 23.9441, 'Private Aviation Center, Athens Airport', 'Greece'),

      -- Istanbul (LTFM)
      ('MNG Jet IST', 41.2751, 28.7519, 'General Aviation Terminal, Istanbul Airport', 'Turkey'),
      ('GOZEN Air Services', 41.2747, 28.7515, 'Private Aviation Center, Istanbul Airport', 'Turkey'),

      -- Moscow Sheremetyevo (UUEE)
      ('A-Group Terminal A', 55.9726, 37.4146, 'Terminal A, Sheremetyevo Airport', 'Russia'),
      ('Premier Avia SVO', 55.9722, 37.4142, 'Business Aviation Center, Sheremetyevo', 'Russia'),

      -- Moscow Domodedovo (UUDD)
      ('SKYPRO Handling', 55.4103, 37.9026, 'Business Aviation Terminal, Domodedovo Airport', 'Russia'),
      ('DME Business Aviation', 55.4099, 37.9022, 'VIP Terminal, Domodedovo International', 'Russia')
  ) as fbo(name, latitude, longitude, address, country)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'ENGM', 'ESSA', 'EKCH', 'EFHK', 'EPWA', 'LIRF', 'LGAV', 'LTFM', 'UUEE', 'UUDD'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%OSL%' OR fbo.name LIKE '%Norse%' THEN 'ENGM'
      WHEN fbo.name LIKE '%Grafair%' OR fbo.name LIKE '%Aviator Sweden%' THEN 'ESSA'
      WHEN fbo.name LIKE '%CPH%' OR fbo.name LIKE '%Copenhagen Air%' THEN 'EKCH'
      WHEN fbo.name LIKE '%HEL%' OR fbo.name LIKE '%Nordic FBO%' THEN 'EFHK'
      WHEN fbo.name LIKE '%WAW%' OR fbo.name LIKE '%Baltic Ground%' THEN 'EPWA'
      WHEN fbo.name LIKE '%Rome%' OR fbo.name LIKE '%FCO%' THEN 'LIRF'
      WHEN fbo.name LIKE '%ATH%' THEN 'LGAV'
      WHEN fbo.name LIKE '%IST%' OR fbo.name LIKE '%GOZEN%' THEN 'LTFM'
      WHEN fbo.name LIKE '%SVO%' OR fbo.name LIKE '%A-Group%' THEN 'UUEE'
      WHEN fbo.name LIKE '%SKYPRO%' OR fbo.name LIKE '%DME%' THEN 'UUDD'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;