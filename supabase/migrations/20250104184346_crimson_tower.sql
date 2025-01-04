-- Add ICAOs for Northeast states and DC
DO $$ 
BEGIN
  -- Insert ICAO codes
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  VALUES
    -- Maine Airports
    ('KPWM', 'Portland International Jetport', 'ME', 'United States', 'North America', 43.6462, -70.3087),
    ('KBGR', 'Bangor International Airport', 'ME', 'United States', 'North America', 44.8074, -68.8281),
    ('KPQI', 'Presque Isle International Airport', 'ME', 'United States', 'North America', 46.6889, -68.0448),
    ('KAUG', 'Augusta State Airport', 'ME', 'United States', 'North America', 44.3206, -69.7973),
    ('KRKD', 'Knox County Regional Airport', 'ME', 'United States', 'North America', 44.0601, -69.0992),
    ('KBHB', 'Hancock County-Bar Harbor Airport', 'ME', 'United States', 'North America', 44.4498, -68.3615),

    -- Vermont Airports
    ('KBTV', 'Burlington International Airport', 'VT', 'United States', 'North America', 44.4720, -73.1533),
    ('KMPV', 'Edward F. Knapp State Airport', 'VT', 'United States', 'North America', 44.2035, -72.5623),
    ('KRUT', 'Rutland Southern Vermont Regional', 'VT', 'United States', 'North America', 43.5294, -72.9496),
    ('KVSF', 'Hartness State Airport', 'VT', 'United States', 'North America', 43.3436, -72.5175),
    ('KMVL', 'Morrisville-Stowe State Airport', 'VT', 'United States', 'North America', 44.5345, -72.6140),
    ('K6B0', 'Bennington State Airport', 'VT', 'United States', 'North America', 42.8913, -73.2462),

    -- New Hampshire Airports
    ('KMHT', 'Manchester-Boston Regional Airport', 'NH', 'United States', 'North America', 42.9326, -71.4357),
    ('KPSM', 'Portsmouth International Airport', 'NH', 'United States', 'North America', 43.0779, -70.8233),
    ('KLEB', 'Lebanon Municipal Airport', 'NH', 'United States', 'North America', 43.6261, -72.3042),
    ('KEEN', 'Dillant-Hopkins Airport', 'NH', 'United States', 'North America', 42.8984, -72.2715),
    ('KLCI', 'Laconia Municipal Airport', 'NH', 'United States', 'North America', 43.5727, -71.4189),
    ('KASH', 'Nashua Airport-Boire Field', 'NH', 'United States', 'North America', 42.7817, -71.5148),

    -- Massachusetts Airports
    ('KBOS', 'Boston Logan International Airport', 'MA', 'United States', 'North America', 42.3656, -71.0096),
    ('KBED', 'Laurence G. Hanscom Field', 'MA', 'United States', 'North America', 42.4700, -71.2890),
    ('KORH', 'Worcester Regional Airport', 'MA', 'United States', 'North America', 42.2673, -71.8757),
    ('KACK', 'Nantucket Memorial Airport', 'MA', 'United States', 'North America', 41.2528, -70.0604),
    ('KMVY', 'Martha''s Vineyard Airport', 'MA', 'United States', 'North America', 41.3931, -70.6143),
    ('KHYA', 'Cape Cod Gateway Airport', 'MA', 'United States', 'North America', 41.6693, -70.2804),
    ('KBVY', 'Beverly Regional Airport', 'MA', 'United States', 'North America', 42.5841, -70.9161),
    ('KEWB', 'New Bedford Regional Airport', 'MA', 'United States', 'North America', 41.6761, -70.9569),

    -- Rhode Island Airports
    ('KPVD', 'Rhode Island T.F. Green International', 'RI', 'United States', 'North America', 41.7267, -71.4320),
    ('KWST', 'Westerly State Airport', 'RI', 'United States', 'North America', 41.3496, -71.8033),
    ('KBID', 'Block Island State Airport', 'RI', 'United States', 'North America', 41.1681, -71.5778),
    ('KUUU', 'Newport State Airport', 'RI', 'United States', 'North America', 41.5324, -71.2812),
    ('KSFZ', 'North Central State Airport', 'RI', 'United States', 'North America', 41.9207, -71.4914),
    ('KOQU', 'Quonset State Airport', 'RI', 'United States', 'North America', 41.5971, -71.4121),

    -- Delaware Airports
    ('KILG', 'Wilmington Airport', 'DE', 'United States', 'North America', 39.6787, -75.6065),
    ('KDOV', 'Dover Air Force Base', 'DE', 'United States', 'North America', 39.1294, -75.4666),
    ('KGED', 'Delaware Coastal Airport', 'DE', 'United States', 'North America', 38.6890, -75.3592),
    ('KEVY', 'Summit Airport', 'DE', 'United States', 'North America', 39.5203, -75.7220),
    ('K33N', 'Delaware Airpark', 'DE', 'United States', 'North America', 39.2185, -75.5991),

    -- Washington DC Airports
    ('KDCA', 'Ronald Reagan Washington National', 'DC', 'United States', 'North America', 38.8521, -77.0377),
    ('KIAD', 'Washington Dulles International', 'DC', 'United States', 'North America', 38.9445, -77.4558),
    ('KBWI', 'Baltimore/Washington International', 'MD', 'United States', 'North America', 39.1754, -76.6682),
    ('KCGS', 'College Park Airport', 'MD', 'United States', 'North America', 38.9807, -76.9229),
    ('KHEF', 'Manassas Regional Airport', 'VA', 'United States', 'North America', 38.7213, -77.5155)
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
  WHERE code IN ('KBOS', 'KIAD', 'KBWI');

  -- International Airports
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'international'
  )
  WHERE code IN (
    'KDCA', 'KPVD', 'KBTV', 'KMHT', 'KBGR', 'KPWM'
  );

  -- Regional Airports
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'regional'
  )
  WHERE code IN (
    'KORH', 'KACK', 'KMVY', 'KHYA', 'KEWB',
    'KWST', 'KSFZ', 'KOQU',
    'KILG', 'KGED',
    'KPSM', 'KLEB', 'KEEN', 'KLCI',
    'KMPV', 'KRUT', 'KVSF',
    'KPQI', 'KAUG', 'KRKD', 'KBHB'
  );

  -- General Aviation
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'general_aviation'
  )
  WHERE code IN (
    'KBVY', 'KBID', 'KUUU',
    'KEVY', 'K33N',
    'KASH', 'KMVL', 'K6B0',
    'KCGS', 'KHEF'
  );

  -- Military
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'military'
  )
  WHERE code IN ('KDOV', 'KBED');

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
      -- Boston Logan (KBOS)
      ('Signature Flight Support BOS', 42.3656, -71.0096, '148 Harborside Dr, Boston, MA 02128', 'MA'),
      ('Signature Flight Support BOS North', 42.3660, -71.0100, '480 Harborside Dr, Boston, MA 02128', 'MA'),

      -- Dulles (KIAD)
      ('Signature Flight Support IAD', 38.9445, -77.4558, '23950 Wind Sock Dr, Sterling, VA 20166', 'VA'),
      ('Jet Aviation IAD', 38.9440, -77.4553, '23411 Autopilot Dr, Sterling, VA 20166', 'VA'),
      ('Modern Aviation IAD', 38.9435, -77.4548, '23540 Autopilot Dr, Sterling, VA 20166', 'VA'),

      -- Reagan National (KDCA)
      ('Signature Flight Support DCA', 38.8521, -77.0377, '1 Aviation Circle, Washington, DC 20001', 'DC'),

      -- BWI (KBWI)
      ('Signature Flight Support BWI', 39.1754, -76.6682, '7425 E Furnace Branch Rd, Glen Burnie, MD 21060', 'MD'),
      ('BWI Aviation Services', 39.1750, -76.6678, '7432 New Ridge Rd, Hanover, MD 21076', 'MD'),

      -- Burlington (KBTV)
      ('Heritage Aviation', 44.4720, -73.1533, '228 Aviation Ave, South Burlington, VT 05403', 'VT'),
      ('Signature Flight Support BTV', 44.4715, -73.1528, '1198 Airport Dr #1, South Burlington, VT 05403', 'VT'),

      -- Portland (KPWM)
      ('Northeast Air', 43.6462, -70.3087, '1011 Westbrook St, Portland, ME 04102', 'ME'),
      ('MAC Jets', 43.6458, -70.3083, '100 Aviation Blvd, Portland, ME 04102', 'ME')
  ) as fbo(name, latitude, longitude, address, state)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'KBOS', 'KIAD', 'KDCA', 'KBWI', 'KBTV', 'KPWM'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%BOS%' THEN 'KBOS'
      WHEN fbo.name LIKE '%IAD%' THEN 'KIAD'
      WHEN fbo.name LIKE '%DCA%' THEN 'KDCA'
      WHEN fbo.name LIKE '%BWI%' THEN 'KBWI'
      WHEN fbo.name LIKE '%BTV%' OR fbo.name LIKE '%Heritage%' THEN 'KBTV'
      WHEN fbo.name LIKE '%Northeast%' OR fbo.name LIKE '%MAC Jets%' THEN 'KPWM'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;