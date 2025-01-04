/*
  # Add Million Air FBO Locations Worldwide

  1. New Data
    - Add all Million Air FBO locations globally
    - Each location includes precise coordinates and full address
  
  2. Changes
    - Insert new FBO records with corresponding ICAO references
*/

-- Insert Million Air FBO locations
DO $$ 
BEGIN
  -- First ensure all required ICAO codes exist
  INSERT INTO icaos (code, name, state, country, latitude, longitude)
  VALUES
    -- United States (excluding existing Texas locations)
    ('KBUR', 'Hollywood Burbank Airport', 'CA', 'United States', 34.1983, -118.3583),
    ('KAPA', 'Centennial Airport', 'CO', 'United States', 39.5700, -104.8490),
    ('KPDK', 'DeKalb-Peachtree Airport', 'GA', 'United States', 33.8756, -84.3020),
    ('KPTK', 'Oakland County International Airport', 'MI', 'United States', 42.6655, -83.4185),
    ('KWHP', 'Whiteman Airport', 'CA', 'United States', 34.2593, -118.4134),
    ('KALB', 'Albany International Airport', 'NY', 'United States', 42.7483, -73.8017),
    ('KBCT', 'Boca Raton Airport', 'FL', 'United States', 26.3785, -80.1077),
    ('KMSS', 'Massena International Airport', 'NY', 'United States', 44.9357, -74.8451),
    ('KOXC', 'Waterbury-Oxford Airport', 'CT', 'United States', 41.4785, -73.1352),
    ('KPIE', 'St. Petersburg-Clearwater International', 'FL', 'United States', 27.9105, -82.6873),
    ('KRMG', 'Richard B Russell Regional Airport', 'GA', 'United States', 34.3508, -85.1587),
    ('KSFB', 'Orlando Sanford International Airport', 'FL', 'United States', 28.7776, -81.2375),
    -- International
    ('MWCR', 'Owen Roberts International Airport', NULL, 'Cayman Islands', 19.2928, -81.3577),
    ('MMTO', 'Toluca International Airport', NULL, 'Mexico', 19.3371, -99.5660)
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

  -- Now add the FBO locations
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country, state)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    fbo.country,
    fbo.state
  FROM (
    VALUES 
      -- United States
      ('Million Air Burbank', 34.1983, -118.3583, '2815 N Hollywood Way, Burbank, CA 91505', 'USA', 'CA'),
      ('Million Air Centennial', 39.5700, -104.8490, '7850 S Peoria St, Englewood, CO 80112', 'USA', 'CO'),
      ('Million Air DeKalb Peachtree', 33.8756, -84.3020, '2000 Airport Rd, Atlanta, GA 30341', 'USA', 'GA'),
      ('Million Air Detroit', 42.6655, -83.4185, '6544 Highland Rd, Waterford Township, MI 48327', 'USA', 'MI'),
      ('Million Air Whiteman', 34.2593, -118.4134, '12653 Osborne St, Pacoima, CA 91331', 'USA', 'CA'),
      ('Million Air Albany', 42.7483, -73.8017, '1 Airport Rd, Albany, NY 12211', 'USA', 'NY'),
      ('Million Air Boca Raton', 26.3785, -80.1077, '3300 Airport Rd, Boca Raton, FL 33431', 'USA', 'FL'),
      ('Million Air Massena', 44.9357, -74.8451, '90 Aviation Rd, Massena, NY 13662', 'USA', 'NY'),
      ('Million Air Waterbury-Oxford', 41.4785, -73.1352, '300 Christian St, Oxford, CT 06478', 'USA', 'CT'),
      ('Million Air St. Petersburg', 27.9105, -82.6873, '14700 Terminal Blvd, Clearwater, FL 33762', 'USA', 'FL'),
      ('Million Air Rome', 34.3508, -85.1587, '304 Russell Field Dr NW, Rome, GA 30165', 'USA', 'GA'),
      ('Million Air Orlando Sanford', 28.7776, -81.2375, '2841 Flight Line Ave, Sanford, FL 32773', 'USA', 'FL'),
      -- International
      ('Million Air Grand Cayman', 19.2928, -81.3577, '46 Owen Roberts Dr, George Town, Cayman Islands', 'Cayman Islands', NULL),
      ('Million Air Toluca', 19.3371, -99.5660, 'Blvd. Miguel Alemán 255, Toluca, Mexico', 'Mexico', NULL)
  ) as fbo(name, latitude, longitude, address, country, state)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'KBUR', 'KAPA', 'KPDK', 'KPTK', 'KWHP', 'KALB', 
      'KBCT', 'KMSS', 'KOXC', 'KPIE', 'KRMG', 'KSFB',
      'MWCR', 'MMTO'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%Burbank%' THEN 'KBUR'
      WHEN fbo.name LIKE '%Centennial%' THEN 'KAPA'
      WHEN fbo.name LIKE '%DeKalb%' THEN 'KPDK'
      WHEN fbo.name LIKE '%Detroit%' THEN 'KPTK'
      WHEN fbo.name LIKE '%Whiteman%' THEN 'KWHP'
      WHEN fbo.name LIKE '%Albany%' THEN 'KALB'
      WHEN fbo.name LIKE '%Boca%' THEN 'KBCT'
      WHEN fbo.name LIKE '%Massena%' THEN 'KMSS'
      WHEN fbo.name LIKE '%Waterbury%' THEN 'KOXC'
      WHEN fbo.name LIKE '%Petersburg%' THEN 'KPIE'
      WHEN fbo.name LIKE '%Rome%' THEN 'KRMG'
      WHEN fbo.name LIKE '%Sanford%' THEN 'KSFB'
      WHEN fbo.name LIKE '%Cayman%' THEN 'MWCR'
      WHEN fbo.name LIKE '%Toluca%' THEN 'MMTO'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;