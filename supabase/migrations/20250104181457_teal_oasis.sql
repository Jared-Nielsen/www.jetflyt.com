-- Add FBOs for SKBO, Venezuelan airports, and Canadian airports
DO $$ 
BEGIN
  -- First ensure all required ICAO codes exist
  INSERT INTO icaos (code, name, country, continent, latitude, longitude)
  VALUES
    -- Colombia
    ('SKBO', 'El Dorado International Airport', 'Colombia', 'South America', 4.7016, -74.1469),
    
    -- Venezuela
    ('SVMI', 'Simón Bolívar International Airport', 'Venezuela', 'South America', 10.6012, -66.9913),
    ('SVMC', 'La Chinita International Airport', 'Venezuela', 'South America', 10.5582, -71.7279),
    ('SVVA', 'Arturo Michelena International Airport', 'Venezuela', 'South America', 10.1505, -67.9284),
    
    -- Canada Major Airports
    ('CYYZ', 'Toronto Pearson International Airport', 'Canada', 'North America', 43.6777, -79.6248),
    ('CYVR', 'Vancouver International Airport', 'Canada', 'North America', 49.1967, -123.1815),
    ('CYUL', 'Montréal-Pierre Elliott Trudeau International', 'Canada', 'North America', 45.4706, -73.7408),
    ('CYYC', 'Calgary International Airport', 'Canada', 'North America', 51.1215, -114.0076),
    ('CYEG', 'Edmonton International Airport', 'Canada', 'North America', 53.3097, -113.5792),
    ('CYOW', 'Ottawa Macdonald-Cartier International', 'Canada', 'North America', 45.3225, -75.6692),
    ('CYWG', 'Winnipeg James Armstrong Richardson', 'Canada', 'North America', 49.9100, -97.2397),
    ('CYTZ', 'Billy Bishop Toronto City Airport', 'Canada', 'North America', 43.6285, -79.3962)
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

  -- Add FBOs for SKBO (El Dorado International Airport)
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'Colombia'
  FROM (
    VALUES 
      ('Universal Aviation BOG', 4.7016, -74.1469, 'Terminal de Aviación Privada, El Dorado International Airport'),
      ('Signature Flight Support BOG', 4.7020, -74.1465, 'Terminal Ejecutivo, El Dorado International Airport'),
      ('FBO Bogota', 4.7012, -74.1472, 'Terminal de Aviación General, El Dorado International Airport')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'SKBO'
  ) i
  ON CONFLICT DO NOTHING;

  -- Add FBOs for Venezuelan airports
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'Venezuela'
  FROM (
    VALUES 
      -- Simón Bolívar International Airport (SVMI)
      ('Universal Aviation CCS', 10.6012, -66.9913, 'Terminal de Aviación General, Aeropuerto Internacional Simón Bolívar'),
      ('Aeropuerto FBO Services', 10.6015, -66.9910, 'Terminal Ejecutiva, Aeropuerto Internacional Simón Bolívar'),
      
      -- La Chinita International Airport (SVMC)
      ('Maracaibo Aviation Services', 10.5582, -71.7279, 'Terminal de Aviación General, Aeropuerto Internacional La Chinita'),
      ('FBO La Chinita', 10.5585, -71.7275, 'Terminal Ejecutiva, Aeropuerto Internacional La Chinita'),
      
      -- Arturo Michelena International Airport (SVVA)
      ('Valencia Aviation Services', 10.1505, -67.9284, 'Terminal de Aviación General, Aeropuerto Internacional Arturo Michelena'),
      ('FBO Valencia', 10.1508, -67.9280, 'Terminal Ejecutiva, Aeropuerto Internacional Arturo Michelena')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN ('SVMI', 'SVMC', 'SVVA')
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%CCS%' OR fbo.name LIKE '%Aeropuerto FBO%' THEN 'SVMI'
      WHEN fbo.name LIKE '%Maracaibo%' OR fbo.name LIKE '%La Chinita%' THEN 'SVMC'
      WHEN fbo.name LIKE '%Valencia%' THEN 'SVVA'
    END
  )
  ON CONFLICT DO NOTHING;

  -- Add FBOs for Canadian airports
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
      -- Toronto Pearson (CYYZ)
      ('Skyservice FBO YYZ', 43.6777, -79.6248, '6120 Midfield Rd, Mississauga, ON L5P 1B1'),
      ('Signature Flight Support YYZ', 43.6780, -79.6245, '6500 Silver Dart Dr, Mississauga, ON L5P 1B2'),
      
      -- Vancouver (CYVR)
      ('Signature Flight Support YVR', 49.1967, -123.1815, '4360 Agar Dr, Richmond, BC V7B 1A3'),
      ('London Air Services', 49.1970, -123.1812, '4340 Agar Dr, Richmond, BC V7B 1A3'),
      
      -- Montreal (CYUL)
      ('Signature Flight Support YUL', 45.4706, -73.7408, '9785 Avenue Ryan, Dorval, QC H9P 1A2'),
      ('Skyservice FBO YUL', 45.4709, -73.7405, '9501 Avenue Ryan, Dorval, QC H9P 1A2'),
      
      -- Calgary (CYYC)
      ('Skyservice FBO YYC', 51.1215, -114.0076, '577 Aero Dr NE, Calgary, AB T2E 8M7'),
      ('Million Air YYC', 51.1218, -114.0073, '575 Palmer Rd NE, Calgary, AB T2E 7G4'),
      
      -- Edmonton (CYEG)
      ('Signature Flight Support YEG', 53.3097, -113.5792, '6800 30 Ave, Edmonton, AB T9E 0V4'),
      ('Shell Aerocentre YEG', 53.3100, -113.5789, '3610 Shell Rd, Edmonton, AB T9E 0V4'),
      
      -- Ottawa (CYOW)
      ('Skyservice FBO YOW', 45.3225, -75.6692, '11 Canadair Private, Ottawa, ON K1V 1C1'),
      ('Executive Aviation YOW', 45.3228, -75.6689, '1000 Private, Ottawa, ON K1V 1C1'),
      
      -- Winnipeg (CYWG)
      ('Fast Air Executive Aviation Services', 49.9100, -97.2397, '200-1325 Church Avenue, Winnipeg, MB R2X 1G5'),
      
      -- Billy Bishop Toronto City (CYTZ)
      ('Porter FBO Services', 43.6285, -79.3962, '2 Eireann Quay, Toronto, ON M5V 1A1'),
      ('Stolport Corporation', 43.6288, -79.3959, '1 Island Airport, Toronto, ON M5V 1A1')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'CYYZ', 'CYVR', 'CYUL', 'CYYC', 'CYEG', 'CYOW', 'CYWG', 'CYTZ'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%YYZ%' THEN 'CYYZ'
      WHEN fbo.name LIKE '%YVR%' THEN 'CYVR'
      WHEN fbo.name LIKE '%YUL%' THEN 'CYUL'
      WHEN fbo.name LIKE '%YYC%' THEN 'CYYC'
      WHEN fbo.name LIKE '%YEG%' THEN 'CYEG'
      WHEN fbo.name LIKE '%YOW%' THEN 'CYOW'
      WHEN fbo.name LIKE '%Fast Air%' THEN 'CYWG'
      WHEN fbo.name LIKE '%Porter%' OR fbo.name LIKE '%Stolport%' THEN 'CYTZ'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;