-- Add South American airports and their FBOs
DO $$ 
BEGIN
  -- Insert ICAO codes
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- Ecuador
    ('SEQM', 'Mariscal Sucre International Airport', 'Ecuador', 'South America', -0.1292, -78.3575,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('SEGU', 'José Joaquín de Olmedo International Airport', 'Ecuador', 'South America', -2.1574, -79.8837,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Peru
    ('SPJC', 'Jorge Chávez International Airport', 'Peru', 'South America', -12.0219, -77.1143,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('SPZO', 'Alejandro Velasco Astete International Airport', 'Peru', 'South America', -13.5357, -71.9389,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Bolivia
    ('SLLP', 'El Alto International Airport', 'Bolivia', 'South America', -16.5133, -68.1919,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('SLVR', 'Viru Viru International Airport', 'Bolivia', 'South America', -17.6445, -63.1353,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Paraguay
    ('SGAS', 'Silvio Pettirossi International Airport', 'Paraguay', 'South America', -25.2400, -57.5200,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Brazil
    ('SBCT', 'Afonso Pena International Airport', 'Brazil', 'South America', -25.5285, -49.1758,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('SBMQ', 'Alberto Alcolumbre International Airport', 'Brazil', 'South America', 0.0507, -51.0722,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('SBFZ', 'Pinto Martins International Airport', 'Brazil', 'South America', -3.7761, -38.5323,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('SBSV', 'Deputado Luís Eduardo Magalhães International', 'Brazil', 'South America', -12.9086, -38.3225,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('SBBR', 'Presidente Juscelino Kubitschek International', 'Brazil', 'South America', -15.8711, -47.9186,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('SBCF', 'Tancredo Neves International Airport', 'Brazil', 'South America', -19.6336, -43.9686,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('SBGL', 'Rio Galeão International Airport', 'Brazil', 'South America', -22.8092, -43.2506,
      (SELECT id FROM icao_types WHERE name = 'major_international')),

    -- Venezuela
    ('SVMI', 'Simón Bolívar International Airport', 'Venezuela', 'South America', 10.6012, -66.9913,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('SVMC', 'La Chinita International Airport', 'Venezuela', 'South America', 10.5582, -71.7279,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Colombia
    ('SKBO', 'El Dorado International Airport', 'Colombia', 'South America', 4.7016, -74.1469,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('SKMD', 'José María Córdova International Airport', 'Colombia', 'South America', 6.1645, -75.4229,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Chile
    ('SCEL', 'Arturo Merino Benítez International Airport', 'Chile', 'South America', -33.3930, -70.7858,
      (SELECT id FROM icao_types WHERE name = 'major_international')),

    -- Argentina
    ('SAEZ', 'Ministro Pistarini International Airport', 'Argentina', 'South America', -34.8222, -58.5358,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('SACO', 'Ingeniero Aeronáutico Ambrosio L.V. Taravella', 'Argentina', 'South America', -31.3236, -64.2081,
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
      -- Quito (SEQM)
      ('Signature Flight Support UIO', -0.1292, -78.3575, 'Terminal VIP, Mariscal Sucre International Airport', 'Ecuador'),
      ('Ecuacentair', -0.1295, -78.3578, 'Hangar 1, Mariscal Sucre International Airport', 'Ecuador'),

      -- Lima (SPJC)
      ('Atsa FBO', -12.0219, -77.1143, 'Av. Elmer Faucett s/n, Callao', 'Peru'),
      ('Lima FBO Services', -12.0222, -77.1146, 'Terminal de Aviación General, Aeropuerto Jorge Chávez', 'Peru'),

      -- La Paz (SLLP)
      ('Amaszonas FBO', -16.5133, -68.1919, 'Terminal de Aviación General, Aeropuerto El Alto', 'Bolivia'),
      ('TAB FBO Services', -16.5136, -68.1922, 'Hangar 3, Aeropuerto Internacional El Alto', 'Bolivia'),

      -- Asunción (SGAS)
      ('Paraguay FBO Services', -25.2400, -57.5200, 'Terminal Ejecutiva, Aeropuerto Silvio Pettirossi', 'Paraguay'),
      ('ASU Aviation', -25.2403, -57.5203, 'Hangar 5, Aeropuerto Internacional Silvio Pettirossi', 'Paraguay'),

      -- Curitiba (SBCT)
      ('Galisteu Aviation', -25.5285, -49.1758, 'Terminal de Aviação Geral, Aeroporto Afonso Pena', 'Brazil'),
      ('OMNI Handling CWB', -25.5288, -49.1761, 'Hangar 7, Aeroporto Internacional Afonso Pena', 'Brazil'),

      -- Manaus (SBMQ)
      ('Lider Aviação MQ', 0.0507, -51.0722, 'Terminal VIP, Aeroporto Internacional de Macapá', 'Brazil'),
      ('Manaus Executive Aviation', 0.0510, -51.0725, 'Hangar 3, Aeroporto Internacional de Macapá', 'Brazil'),

      -- Fortaleza (SBFZ)
      ('Lider Aviação FOR', -3.7761, -38.5323, 'Terminal de Aviação Executiva, Aeroporto de Fortaleza', 'Brazil'),
      ('FOR Executive Aviation', -3.7764, -38.5326, 'Hangar 2, Aeroporto Internacional Pinto Martins', 'Brazil'),

      -- Salvador (SBSV)
      ('Lider Aviação SSA', -12.9086, -38.3225, 'Terminal VIP, Aeroporto Internacional de Salvador', 'Brazil'),
      ('Salvador Jet Center', -12.9089, -38.3228, 'Hangar 4, Aeroporto Internacional de Salvador', 'Brazil'),

      -- Brasília (SBBR)
      ('Lider Aviação BSB', -15.8711, -47.9186, 'Terminal VIP, Aeroporto Internacional de Brasília', 'Brazil'),
      ('Global Aviation BSB', -15.8714, -47.9189, 'Hangar 33, Aeroporto Internacional de Brasília', 'Brazil'),

      -- Belo Horizonte (SBCF)
      ('Lider Aviação CNF', -19.6336, -43.9686, 'Terminal de Aviação Executiva, Aeroporto de Confins', 'Brazil'),
      ('BH Airport Executive Aviation', -19.6339, -43.9689, 'Hangar 5, Aeroporto Internacional de Confins', 'Brazil'),

      -- Rio de Janeiro (SBGL)
      ('Lider Aviação GIG', -22.8092, -43.2506, 'Terminal VIP, Aeroporto Internacional do Galeão', 'Brazil'),
      ('RIOgaleão Executive Aviation', -22.8095, -43.2509, 'Hangar 8, Aeroporto Internacional do Galeão', 'Brazil'),

      -- Caracas (SVMI)
      ('Aeropaq FBO', 10.6012, -66.9913, 'Terminal Ejecutiva, Aeropuerto Internacional Simón Bolívar', 'Venezuela'),
      ('Executive Aviation VE', 10.6015, -66.9916, 'Hangar 7, Aeropuerto Internacional de Maiquetía', 'Venezuela'),

      -- Medellín (SKMD)
      ('Aviación Ejecutiva MDE', 6.1645, -75.4229, 'Terminal VIP, Aeropuerto José María Córdova', 'Colombia'),
      ('Colombian Aviation Services', 6.1648, -75.4232, 'Hangar 3, Aeropuerto Internacional JMC', 'Colombia'),

      -- Santiago (SCEL)
      ('Santiago FBO', -33.3930, -70.7858, 'Terminal VIP, Aeropuerto Arturo Merino Benítez', 'Chile'),
      ('Chilean Aviation Services', -33.3933, -70.7861, 'Hangar 5, Aeropuerto Internacional SCL', 'Chile'),

      -- Buenos Aires (SAEZ)
      ('InterFBO Argentina', -34.8222, -58.5358, 'Terminal Ejecutiva, Aeropuerto Internacional Ezeiza', 'Argentina'),
      ('Buenos Aires Executive Aviation', -34.8225, -58.5361, 'Hangar 12, Aeropuerto Internacional Ministro Pistarini', 'Argentina'),

      -- Córdoba (SACO)
      ('Córdoba Executive Aviation', -31.3236, -64.2081, 'Terminal VIP, Aeropuerto Internacional Pajas Blancas', 'Argentina'),
      ('FBO Argentina COR', -31.3239, -64.2084, 'Hangar 3, Aeropuerto Internacional de Córdoba', 'Argentina')
  ) as fbo(name, latitude, longitude, address, country)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'SEQM', 'SPJC', 'SLLP', 'SGAS', 'SBCT', 'SBMQ', 'SBFZ', 'SBSV',
      'SBBR', 'SBCF', 'SBGL', 'SVMI', 'SKMD', 'SCEL', 'SAEZ', 'SACO'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%UIO%' OR fbo.name LIKE '%Ecuacentair%' THEN 'SEQM'
      WHEN fbo.name LIKE '%Atsa%' OR fbo.name LIKE '%Lima FBO%' THEN 'SPJC'
      WHEN fbo.name LIKE '%Amaszonas%' OR fbo.name LIKE '%TAB%' THEN 'SLLP'
      WHEN fbo.name LIKE '%Paraguay%' OR fbo.name LIKE '%ASU%' THEN 'SGAS'
      WHEN fbo.name LIKE '%Galisteu%' OR fbo.name LIKE '%CWB%' THEN 'SBCT'
      WHEN fbo.name LIKE '%MQ%' OR fbo.name LIKE '%Manaus%' THEN 'SBMQ'
      WHEN fbo.name LIKE '%FOR%' THEN 'SBFZ'
      WHEN fbo.name LIKE '%SSA%' OR fbo.name LIKE '%Salvador%' THEN 'SBSV'
      WHEN fbo.name LIKE '%BSB%' THEN 'SBBR'
      WHEN fbo.name LIKE '%CNF%' OR fbo.name LIKE '%BH Airport%' THEN 'SBCF'
      WHEN fbo.name LIKE '%GIG%' OR fbo.name LIKE '%RIOgaleão%' THEN 'SBGL'
      WHEN fbo.name LIKE '%Aeropaq%' OR fbo.name LIKE '%Executive Aviation VE%' THEN 'SVMI'
      WHEN fbo.name LIKE '%MDE%' OR fbo.name LIKE '%Colombian%' THEN 'SKMD'
      WHEN fbo.name LIKE '%Santiago%' OR fbo.name LIKE '%Chilean%' THEN 'SCEL'
      WHEN fbo.name LIKE '%InterFBO%' OR fbo.name LIKE '%Buenos Aires%' THEN 'SAEZ'
      WHEN fbo.name LIKE '%Córdoba%' OR fbo.name LIKE '%COR%' THEN 'SACO'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;