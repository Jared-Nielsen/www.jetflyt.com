-- Add ICAOs and FBOs for Washington, Oregon, and Idaho
DO $$ 
BEGIN
  -- Insert ICAO codes
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  VALUES
    -- Washington Airports
    ('KSEA', 'Seattle-Tacoma International Airport', 'WA', 'United States', 'North America', 47.4502, -122.3088),
    ('KBFI', 'Boeing Field/King County International', 'WA', 'United States', 'North America', 47.5299, -122.3019),
    ('KGEG', 'Spokane International Airport', 'WA', 'United States', 'North America', 47.6199, -117.5337),
    ('KPAE', 'Snohomish County Airport (Paine Field)', 'WA', 'United States', 'North America', 47.9063, -122.2815),
    ('KPSC', 'Tri-Cities Airport', 'WA', 'United States', 'North America', 46.2647, -119.1191),
    ('KYKM', 'Yakima Air Terminal', 'WA', 'United States', 'North America', 46.5682, -120.5425),
    ('KBLI', 'Bellingham International Airport', 'WA', 'United States', 'North America', 48.7927, -122.5375),
    ('KOLM', 'Olympia Regional Airport', 'WA', 'United States', 'North America', 46.9694, -122.9025),

    -- Oregon Airports
    ('KPDX', 'Portland International Airport', 'OR', 'United States', 'North America', 45.5887, -122.5975),
    ('KHIO', 'Portland-Hillsboro Airport', 'OR', 'United States', 'North America', 45.5404, -122.9498),
    ('KEUG', 'Eugene Airport', 'OR', 'United States', 'North America', 44.1246, -123.2190),
    ('KMFR', 'Rogue Valley International-Medford', 'OR', 'United States', 'North America', 42.3742, -122.8735),
    ('KRDM', 'Roberts Field', 'OR', 'United States', 'North America', 44.2541, -121.1500),
    ('KBDN', 'Bend Municipal Airport', 'OR', 'United States', 'North America', 44.0945, -121.2002),
    ('KSLE', 'Salem Municipal Airport', 'OR', 'United States', 'North America', 44.9095, -123.0026),
    ('KONP', 'Newport Municipal Airport', 'OR', 'United States', 'North America', 44.5804, -124.0579),

    -- Idaho Airports
    ('KBOI', 'Boise Airport', 'ID', 'United States', 'North America', 43.5644, -116.2228),
    ('KSUN', 'Friedman Memorial Airport', 'ID', 'United States', 'North America', 43.5044, -114.2956),
    ('KIDA', 'Idaho Falls Regional Airport', 'ID', 'United States', 'North America', 43.5146, -112.0708),
    ('KLWS', 'Lewiston-Nez Perce County Airport', 'ID', 'United States', 'North America', 46.3745, -117.0152),
    ('KPIH', 'Pocatello Regional Airport', 'ID', 'United States', 'North America', 42.9098, -112.5960),
    ('KTWF', 'Magic Valley Regional Airport', 'ID', 'United States', 'North America', 42.4818, -114.4877),
    ('KCOE', 'Coeur d''Alene Airport', 'ID', 'United States', 'North America', 47.7729, -116.8196),
    ('KMYL', 'McCall Municipal Airport', 'ID', 'United States', 'North America', 44.8897, -116.1012)
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
      -- Seattle-Tacoma (KSEA)
      ('Signature Flight Support SEA', 47.4502, -122.3088, '7149 Perimeter Rd S, Seattle, WA 98108', 'WA'),
      ('Modern Aviation SEA', 47.4506, -122.3092, '7145 Perimeter Rd S, Seattle, WA 98108', 'WA'),
      
      -- Boeing Field (KBFI)
      ('Signature Flight Support BFI', 47.5299, -122.3019, '8555 Perimeter Rd S, Seattle, WA 98108', 'WA'),
      ('Modern Aviation BFI', 47.5295, -122.3015, '8285 Perimeter Rd S, Seattle, WA 98108', 'WA'),
      ('Clay Lacy Aviation BFI', 47.5292, -122.3012, '8285 Perimeter Rd S, Seattle, WA 98108', 'WA'),
      
      -- Portland (KPDX)
      ('Atlantic Aviation PDX', 45.5887, -122.5975, '7135 NE Airport Way, Portland, OR 97218', 'OR'),
      ('Signature Flight Support PDX', 45.5883, -122.5971, '7777 NE Airport Way, Portland, OR 97218', 'OR'),
      
      -- Portland-Hillsboro (KHIO)
      ('Aero Air FBO', 45.5404, -122.9498, '3355 NE Cornell Rd, Hillsboro, OR 97124', 'OR'),
      ('Global Aviation', 45.5400, -122.9494, '3220 NE Cornell Rd, Hillsboro, OR 97124', 'OR'),
      
      -- Boise (KBOI)
      ('Jackson Jet Center', 43.5644, -116.2228, '3815 Rickenbacker St, Boise, ID 83705', 'ID'),
      ('Western Aircraft', 43.5640, -116.2224, '4300 S Orchard St, Boise, ID 83705', 'ID'),
      
      -- Sun Valley (KSUN)
      ('Atlantic Aviation SUN', 43.5044, -114.2956, '1616 Airport Cir, Hailey, ID 83333', 'ID'),
      
      -- Spokane (KGEG)
      ('Signature Flight Support GEG', 47.6199, -117.5337, '8136 W Pilot Dr, Spokane, WA 99224', 'WA'),
      ('Western Aviation GEG', 47.6195, -117.5333, '8135 W Pilot Dr, Spokane, WA 99224', 'WA')
  ) as fbo(name, latitude, longitude, address, state)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'KSEA', 'KBFI', 'KPDX', 'KHIO', 'KBOI', 'KSUN', 'KGEG'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%SEA' THEN 'KSEA'
      WHEN fbo.name LIKE '%BFI' THEN 'KBFI'
      WHEN fbo.name LIKE '%PDX' THEN 'KPDX'
      WHEN fbo.name LIKE '%Aero Air%' OR fbo.name LIKE '%Global Aviation%' THEN 'KHIO'
      WHEN fbo.name LIKE '%Jackson%' OR fbo.name LIKE '%Western Aircraft%' THEN 'KBOI'
      WHEN fbo.name LIKE '%SUN' THEN 'KSUN'
      WHEN fbo.name LIKE '%GEG' THEN 'KGEG'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;