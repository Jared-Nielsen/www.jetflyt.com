-- Add ICAOs for Northern US and Canadian Airports
DO $$ 
BEGIN
  -- Insert ICAO codes
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  VALUES
    -- Montana Airports
    ('KBZN', 'Bozeman Yellowstone International', 'MT', 'United States', 'North America', 45.7772, -111.1529),
    ('KBIL', 'Billings Logan International', 'MT', 'United States', 'North America', 45.8077, -108.5429),
    ('KGPI', 'Glacier Park International', 'MT', 'United States', 'North America', 48.3105, -114.2559),
    ('KHLN', 'Helena Regional Airport', 'MT', 'United States', 'North America', 46.6068, -111.9827),
    ('KGTF', 'Great Falls International', 'MT', 'United States', 'North America', 47.4821, -111.3707),
    ('KMSO', 'Missoula Montana Airport', 'MT', 'United States', 'North America', 46.9163, -114.0906),
    ('KBUT', 'Bert Mooney Airport', 'MT', 'United States', 'North America', 45.9548, -112.4973),
    ('KGGW', 'Glasgow International Airport', 'MT', 'United States', 'North America', 48.2125, -106.6147),

    -- Calgary Airports (Alberta)
    ('CYYC', 'Calgary International Airport', NULL, 'Canada', 'North America', 51.1215, -114.0076),
    ('CYBW', 'Calgary/Springbank Airport', NULL, 'Canada', 'North America', 51.1027, -114.3747),
    ('CYYL', 'Lloydminster Airport', NULL, 'Canada', 'North America', 53.3092, -110.0725),

    -- Regina Airports (Saskatchewan)
    ('CYQR', 'Regina International Airport', NULL, 'Canada', 'North America', 50.4319, -104.6657),
    ('CYXE', 'Saskatoon John G. Diefenbaker International', NULL, 'Canada', 'North America', 52.1708, -106.6998),
    ('CYPA', 'Prince Albert Glass Field', NULL, 'Canada', 'North America', 53.2142, -105.6731),

    -- Winnipeg Airports (Manitoba)
    ('CYWG', 'Winnipeg James Armstrong Richardson', NULL, 'Canada', 'North America', 49.9100, -97.2397),
    ('CYPG', 'Portage la Prairie/Southport Airport', NULL, 'Canada', 'North America', 49.9030, -98.2747),
    ('CYAV', 'St. Andrews Airport', NULL, 'Canada', 'North America', 50.0564, -97.0325),

    -- British Columbia Airports
    ('CYVR', 'Vancouver International Airport', NULL, 'Canada', 'North America', 49.1967, -123.1815),
    ('CYYJ', 'Victoria International Airport', NULL, 'Canada', 'North America', 48.6469, -123.4258),
    ('CYLW', 'Kelowna International Airport', NULL, 'Canada', 'North America', 49.9561, -119.3778),
    ('CYXS', 'Prince George Airport', NULL, 'Canada', 'North America', 53.8894, -122.6789),
    ('CYXX', 'Abbotsford International Airport', NULL, 'Canada', 'North America', 49.0253, -122.3611),
    ('CYCD', 'Nanaimo Airport', NULL, 'Canada', 'North America', 49.0547, -123.8702),

    -- Alaska Airports
    ('PANC', 'Ted Stevens Anchorage International', 'AK', 'United States', 'North America', 61.1743, -149.9962),
    ('PAFA', 'Fairbanks International Airport', 'AK', 'United States', 'North America', 64.8151, -147.8561),
    ('PAJN', 'Juneau International Airport', 'AK', 'United States', 'North America', 58.3547, -134.5762),
    ('PAKT', 'Ketchikan International Airport', 'AK', 'United States', 'North America', 55.3556, -131.7136),
    ('PAEN', 'Kenai Municipal Airport', 'AK', 'United States', 'North America', 60.5731, -151.2451),
    ('PASI', 'Sitka Rocky Gutierrez Airport', 'AK', 'United States', 'North America', 57.0471, -135.3614),
    ('PAWD', 'Seward Airport', 'AK', 'United States', 'North America', 60.1269, -149.4188),
    ('PAWG', 'Wrangell Airport', 'AK', 'United States', 'North America', 56.4843, -132.3698),

    -- Hawaii Airports
    ('PHNL', 'Daniel K. Inouye International', 'HI', 'United States', 'North America', 21.3245, -157.9251),
    ('PHOG', 'Kahului Airport', 'HI', 'United States', 'North America', 20.8986, -156.4305),
    ('PHKO', 'Ellison Onizuka Kona International', 'HI', 'United States', 'North America', 19.7388, -156.0456),
    ('PHTO', 'Hilo International Airport', 'HI', 'United States', 'North America', 19.7202, -155.0484),
    ('PHLI', 'Lihue Airport', 'HI', 'United States', 'North America', 21.9760, -159.3389),
    ('PHMK', 'Molokai Airport', 'HI', 'United States', 'North America', 21.1529, -157.0961),
    ('PHNY', 'Lanai Airport', 'HI', 'United States', 'North America', 20.7856, -156.9514),
    ('PHHN', 'Hana Airport', 'HI', 'United States', 'North America', 20.7956, -156.0144),

    -- Yukon Airports
    ('CYXY', 'Erik Nielsen Whitehorse International', NULL, 'Canada', 'North America', 60.7096, -135.0678),
    ('CYDA', 'Dawson City Airport', NULL, 'Canada', 'North America', 64.0431, -139.1280),
    ('CZFA', 'Faro Airport', NULL, 'Canada', 'North America', 62.2075, -133.3761),
    ('CYOC', 'Old Crow Airport', NULL, 'Canada', 'North America', 67.5705, -139.8390)
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
  WHERE code IN ('PANC', 'PHNL', 'CYVR', 'CYYC');

  -- International Airports
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'international'
  )
  WHERE code IN (
    'CYWG', 'CYQR', 'CYYJ', 'CYLW', 'PAFA', 'PAJN',
    'PHOG', 'PHKO', 'PHTO', 'PHLI'
  );

  -- Regional Airports
  UPDATE icaos SET icao_type_id = (
    SELECT id FROM icao_types WHERE name = 'regional'
  )
  WHERE code IN (
    'KBZN', 'KBIL', 'KGPI', 'KHLN', 'KGTF', 'KMSO',
    'CYBW', 'CYYL', 'CYXE', 'CYPA', 'CYPG',
    'CYXX', 'CYCD', 'CYXS',
    'PAKT', 'PAEN', 'PASI',
    'PHMK', 'PHNY', 'PHHN',
    'CYXY', 'CYDA', 'CZFA', 'CYOC'
  );

  -- Add FBO locations for major airports
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
      -- Anchorage (PANC)
      ('Signature Flight Support ANC', 61.1743, -149.9962, '6231 S Airpark Pl, Anchorage, AK 99502', 'USA', 'AK'),
      ('Great Circle Flight Services', 61.1739, -149.9958, '6121 S Airpark Pl, Anchorage, AK 99502', 'USA', 'AK'),

      -- Honolulu (PHNL)
      ('Air Service Hawaii', 21.3245, -157.9251, '90 Nakolo Pl, Honolulu, HI 96819', 'USA', 'HI'),
      ('Castle & Cooke Aviation', 21.3241, -157.9247, '155 Kapalulu Pl, Honolulu, HI 96819', 'USA', 'HI'),

      -- Vancouver (CYVR)
      ('Signature Flight Support YVR', 49.1967, -123.1815, '4360 Agar Dr, Richmond, BC V7B 1A3', 'Canada', NULL),
      ('London Air Services', 49.1963, -123.1811, '4340 Agar Dr, Richmond, BC V7B 1A3', 'Canada', NULL),

      -- Calgary (CYYC)
      ('Skyservice FBO YYC', 51.1215, -114.0076, '577 Aero Dr NE, Calgary, AB T2E 8M7', 'Canada', NULL),
      ('Million Air YYC', 51.1211, -114.0072, '575 Palmer Rd NE, Calgary, AB T2E 7G4', 'Canada', NULL),

      -- Winnipeg (CYWG)
      ('Fast Air Executive Aviation Services', 49.9100, -97.2397, '200-1325 Church Avenue, Winnipeg, MB R2X 1G5', 'Canada', NULL),
      ('Skyservice FBO YWG', 49.9096, -97.2393, '1-1750 Sargent Avenue, Winnipeg, MB R3H 0C7', 'Canada', NULL),

      -- Regina (CYQR)
      ('Kreos Aviation', 50.4319, -104.6657, '2710 Tutor Way, Regina, SK S4W 1B3', 'Canada', NULL),
      ('Regina Flying Club', 50.4315, -104.6653, '2610 Airport Road, Regina, SK S4W 1A3', 'Canada', NULL)
  ) as fbo(name, latitude, longitude, address, country, state)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'PANC', 'PHNL', 'CYVR', 'CYYC', 'CYWG', 'CYQR'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%ANC%' OR fbo.name LIKE '%Great Circle%' THEN 'PANC'
      WHEN fbo.name LIKE '%Air Service Hawaii%' OR fbo.name LIKE '%Castle & Cooke%' THEN 'PHNL'
      WHEN fbo.name LIKE '%YVR%' OR fbo.name LIKE '%London Air%' THEN 'CYVR'
      WHEN fbo.name LIKE '%YYC%' THEN 'CYYC'
      WHEN fbo.name LIKE '%Fast Air%' OR fbo.name LIKE '%YWG%' THEN 'CYWG'
      WHEN fbo.name LIKE '%Kreos%' OR fbo.name LIKE '%Regina Flying%' THEN 'CYQR'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;