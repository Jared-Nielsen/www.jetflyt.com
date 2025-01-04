-- Add Mexican airports and their FBOs
DO $$ 
BEGIN
  -- Insert ICAO codes
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- Major International Airports
    ('MMMX', 'Benito Juárez International Airport', 'Mexico', 'North America', 19.4363, -99.0721,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('MMUN', 'Cancún International Airport', 'Mexico', 'North America', 21.0365, -86.8771,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('MMGL', 'Guadalajara International Airport', 'Mexico', 'North America', 20.5218, -103.3111,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('MMTJ', 'Tijuana International Airport', 'Mexico', 'North America', 32.5411, -116.9702,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- International Airports
    ('MMMY', 'Monterrey International Airport', 'Mexico', 'North America', 25.7785, -100.1069,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('MMPR', 'Licenciado Gustavo Díaz Ordaz International', 'Mexico', 'North America', 20.6801, -105.2542,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('MMSD', 'Los Cabos International Airport', 'Mexico', 'North America', 23.1518, -109.7215,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('MMHO', 'General Ignacio P. Garcia International', 'Mexico', 'North America', 29.0959, -111.0484,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('MMCZ', 'Cozumel International Airport', 'Mexico', 'North America', 20.5224, -86.9256,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('MMMD', 'Mérida International Airport', 'Mexico', 'North America', 20.9370, -89.6577,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Regional Airports
    ('MMTO', 'Licenciado Adolfo López Mateos International', 'Mexico', 'North America', 19.3371, -99.5660,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('MMLO', 'Del Bajío International Airport', 'Mexico', 'North America', 20.9935, -101.4815,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('MMIA', 'Ignacio Agramonte International Airport', 'Mexico', 'North America', 27.4391, -109.8333,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('MMVA', 'C.P.A. Carlos Rovirosa International Airport', 'Mexico', 'North America', 17.9969, -92.8174,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('MMBT', 'Bahías de Huatulco International Airport', 'Mexico', 'North America', 15.7753, -96.2626,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('MMIO', 'Plan de Guadalupe International Airport', 'Mexico', 'North America', 25.5495, -100.9287,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('MMCM', 'Ciudad del Carmen International Airport', 'Mexico', 'North America', 18.6537, -91.7990,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('MMCP', 'Ingeniero Alberto Acuña Ongay International', 'Mexico', 'North America', 19.8168, -90.5003,
      (SELECT id FROM icao_types WHERE name = 'regional'))
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
    'Mexico'
  FROM (
    VALUES 
      -- Mexico City (MMMX)
      ('Jetex MMMX', 19.4363, -99.0721, 'Terminal 2, Zona Federal, Mexico City International Airport'),
      ('Million Air MMMX', 19.4360, -99.0718, 'Hangar 1, Zona de Aviación General'),
      ('Manny Aviation Services', 19.4365, -99.0725, 'Terminal de Aviación General'),
      ('Universal Aviation MMMX', 19.4368, -99.0728, 'Zona de Hangares, Aviación General'),
      ('ASA FBO Services', 19.4370, -99.0730, 'Terminal de Aviación General, AICM'),

      -- Cancún (MMUN)
      ('Signature Flight Support CUN', 21.0365, -86.8771, 'Terminal FBO, Aeropuerto Internacional de Cancún'),
      ('Menzies Aviation CUN', 21.0368, -86.8774, 'Zona de Aviación General, Aeropuerto de Cancún'),
      ('FBO Cancún', 21.0362, -86.8768, 'Terminal Ejecutiva, Aeropuerto Internacional de Cancún'),

      -- Guadalajara (MMGL)
      ('FBO Aerotron', 20.5218, -103.3111, 'Carretera Guadalajara Chapala Km 17.5, 45659 Jalisco'),
      ('Grupo Lomex FBO', 20.5214, -103.3107, 'Terminal Ejecutiva, Aeropuerto Internacional de Guadalajara'),
      ('Jetex Guadalajara', 20.5222, -103.3115, 'Zona de Hangares, Aeropuerto Internacional de Guadalajara'),

      -- Monterrey (MMMY)
      ('Million Air MTY', 25.7785, -100.1069, 'Terminal de Aviación Privada, Aeropuerto de Monterrey'),
      ('FBO Monterrey', 25.7782, -100.1066, 'Hangar 1, Zona de Aviación General'),
      ('Grupo Lomex MTY', 25.7788, -100.1072, 'Terminal Ejecutiva, Aeropuerto Internacional de Monterrey'),

      -- Los Cabos (MMSD)
      ('Cabo FBO Services', 23.1518, -109.7215, 'Terminal Ejecutiva, Aeropuerto Internacional de Los Cabos'),
      ('Manny Aviation SJD', 23.1515, -109.7212, 'Zona de Aviación General, Aeropuerto de Los Cabos'),
      ('Universal Aviation SJD', 23.1521, -109.7218, 'Terminal FBO, Aeropuerto Internacional de Los Cabos'),

      -- Mérida (MMMD)
      ('FBO Mérida', 20.9370, -89.6577, 'Terminal de Aviación General, Aeropuerto de Mérida'),
      ('Manny Aviation MID', 20.9373, -89.6580, 'Hangar 3, Aeropuerto Internacional de Mérida'),
      ('ASA Mérida', 20.9367, -89.6574, 'Terminal Ejecutiva, Aeropuerto Internacional de Mérida'),

      -- Toluca (MMTO)
      ('Million Air TLC', 19.3371, -99.5660, 'Terminal FBO, Aeropuerto Internacional de Toluca'),
      ('Jetex Toluca', 19.3374, -99.5663, 'Zona de Aviación General, Aeropuerto de Toluca'),
      ('Universal Aviation TLC', 19.3368, -99.5657, 'Terminal Ejecutiva, Aeropuerto Internacional de Toluca')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'MMMX', 'MMUN', 'MMGL', 'MMMY', 'MMSD', 'MMMD', 'MMTO'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%MMMX%' OR fbo.name LIKE '%Mexico City%' THEN 'MMMX'
      WHEN fbo.name LIKE '%CUN%' OR fbo.name LIKE '%Cancún%' THEN 'MMUN'
      WHEN fbo.name LIKE '%Guadalajara%' OR fbo.name LIKE '%Aerotron%' OR fbo.name LIKE '%Lomex%' THEN 'MMGL'
      WHEN fbo.name LIKE '%MTY%' OR fbo.name LIKE '%Monterrey%' THEN 'MMMY'
      WHEN fbo.name LIKE '%SJD%' OR fbo.name LIKE '%Cabo%' THEN 'MMSD'
      WHEN fbo.name LIKE '%MID%' OR fbo.name LIKE '%Mérida%' THEN 'MMMD'
      WHEN fbo.name LIKE '%TLC%' OR fbo.name LIKE '%Toluca%' THEN 'MMTO'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;