-- Add ICAOs and FBOs for New Mexico, Colorado, Utah, and Wyoming
DO $$ 
BEGIN
  -- Insert ICAO codes
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  VALUES
    -- New Mexico Airports
    ('KABQ', 'Albuquerque International Sunport', 'NM', 'United States', 'North America', 35.0402, -106.6091),
    ('KSAF', 'Santa Fe Municipal Airport', 'NM', 'United States', 'North America', 35.6170, -106.0880),
    ('KROW', 'Roswell Air Center', 'NM', 'United States', 'North America', 33.3016, -104.5307),
    ('KFMN', 'Four Corners Regional Airport', 'NM', 'United States', 'North America', 36.7412, -108.2299),
    ('KLRU', 'Las Cruces International Airport', 'NM', 'United States', 'North America', 32.2894, -106.9219),
    ('KHOB', 'Lea County Regional Airport', 'NM', 'United States', 'North America', 32.6875, -103.2170),
    
    -- Colorado Airports
    ('KDEN', 'Denver International Airport', 'CO', 'United States', 'North America', 39.8561, -104.6737),
    ('KCOS', 'Colorado Springs Airport', 'CO', 'United States', 'North America', 38.8059, -104.7000),
    ('KASE', 'Aspen/Pitkin County Airport', 'CO', 'United States', 'North America', 39.2232, -106.8687),
    ('KEGE', 'Eagle County Regional Airport', 'CO', 'United States', 'North America', 39.6426, -106.9159),
    ('KGJT', 'Grand Junction Regional Airport', 'CO', 'United States', 'North America', 39.1224, -108.5267),
    ('KAPA', 'Centennial Airport', 'CO', 'United States', 'North America', 39.5700, -104.8490),
    ('KBJC', 'Rocky Mountain Metropolitan Airport', 'CO', 'United States', 'North America', 39.9089, -105.1172),
    ('KFNL', 'Northern Colorado Regional Airport', 'CO', 'United States', 'North America', 40.4518, -105.0113),
    
    -- Utah Airports
    ('KSLC', 'Salt Lake City International Airport', 'UT', 'United States', 'North America', 40.7884, -111.9778),
    ('KPVU', 'Provo Municipal Airport', 'UT', 'United States', 'North America', 40.2191, -111.7233),
    ('KOGD', 'Ogden-Hinckley Airport', 'UT', 'United States', 'North America', 41.1959, -112.0122),
    ('KCDC', 'Cedar City Regional Airport', 'UT', 'United States', 'North America', 37.7010, -113.0989),
    ('KSGU', 'St. George Regional Airport', 'UT', 'United States', 'North America', 37.0363, -113.5103),
    ('KVEL', 'Vernal Regional Airport', 'UT', 'United States', 'North America', 40.4409, -109.5099),
    
    -- Wyoming Airports
    ('KCPR', 'Casper/Natrona County International', 'WY', 'United States', 'North America', 42.9080, -106.4645),
    ('KJAR', 'Jackson Hole Airport', 'WY', 'United States', 'North America', 43.6072, -110.7377),
    ('KCYS', 'Cheyenne Regional Airport', 'WY', 'United States', 'North America', 41.1557, -104.8118),
    ('KGCC', 'Gillette-Campbell County Airport', 'WY', 'United States', 'North America', 44.3489, -105.5393),
    ('KRKS', 'Southwest Wyoming Regional Airport', 'WY', 'United States', 'North America', 41.5942, -109.0652),
    ('KLND', 'Hunt Field Airport', 'WY', 'United States', 'North America', 42.8152, -108.7273)
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
      -- Albuquerque (KABQ)
      ('Signature Flight Support ABQ', 35.0402, -106.6091, '2501 Yale Blvd SE, Albuquerque, NM 87106', 'NM'),
      ('Atlantic Aviation ABQ', 35.0405, -106.6095, '2505 Clark Carr Loop SE, Albuquerque, NM 87106', 'NM'),
      
      -- Denver (KDEN)
      ('Signature Flight Support DEN', 39.8561, -104.6737, '7850 N Passenger Terminal Rd, Denver, CO 80249', 'CO'),
      ('TAC Air DEN', 39.8565, -104.6740, '7425 Tower Rd, Denver, CO 80249', 'CO'),
      ('Modern Aviation DEN', 39.8558, -104.6734, '7850 N Passenger Terminal Rd, Denver, CO 80249', 'CO'),
      
      -- Aspen (KASE)
      ('Atlantic Aviation ASE', 39.2232, -106.8687, '100 Boomerang Rd, Aspen, CO 81611', 'CO'),
      
      -- Eagle County (KEGE)
      ('Vail Valley Jet Center', 39.6426, -106.9159, '871 Cooley Mesa Rd, Gypsum, CO 81637', 'CO'),
      
      -- Salt Lake City (KSLC)
      ('TAC Air SLC', 40.7884, -111.9778, '303 N 2370 W, Salt Lake City, UT 84116', 'UT'),
      ('Atlantic Aviation SLC', 40.7880, -111.9775, '397 N 2370 W, Salt Lake City, UT 84116', 'UT'),
      
      -- Jackson Hole (KJAR)
      ('Jackson Hole Aviation', 43.6072, -110.7377, '1250 E Airport Rd, Jackson, WY 83001', 'WY'),
      
      -- Casper (KCPR)
      ('Atlantic Aviation CPR', 42.9080, -106.4645, '8500 Airport Pkwy, Casper, WY 82604', 'WY')
  ) as fbo(name, latitude, longitude, address, state)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'KABQ', 'KDEN', 'KASE', 'KEGE', 'KSLC', 'KJAR', 'KCPR'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%ABQ%' THEN 'KABQ'
      WHEN fbo.name LIKE '%DEN%' THEN 'KDEN'
      WHEN fbo.name LIKE '%ASE%' THEN 'KASE'
      WHEN fbo.name LIKE '%Vail Valley%' THEN 'KEGE'
      WHEN fbo.name LIKE '%SLC%' THEN 'KSLC'
      WHEN fbo.name LIKE '%Jackson Hole%' THEN 'KJAR'
      WHEN fbo.name LIKE '%CPR%' THEN 'KCPR'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;