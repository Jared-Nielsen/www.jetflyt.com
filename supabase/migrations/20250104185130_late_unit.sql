-- Add Louisville and Tijuana airports and their FBOs
DO $$ 
BEGIN
  -- First ensure airports exist
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- Louisville
    ('KSDF', 'Louisville Muhammad Ali International', 'KY', 'United States', 'North America', 38.1744, -85.7361,
      (SELECT id FROM icao_types WHERE name = 'cargo')),
    ('KLOU', 'Bowman Field', 'KY', 'United States', 'North America', 38.2280, -85.6636,
      (SELECT id FROM icao_types WHERE name = 'general_aviation')),
    
    -- Tijuana
    ('MMTJ', 'Tijuana International Airport', NULL, 'Mexico', 'North America', 32.5411, -116.9702,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('MMGL', 'Guadalajara International Airport', NULL, 'Mexico', 'North America', 20.5218, -103.3111,
      (SELECT id FROM icao_types WHERE name = 'international'))
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    state = EXCLUDED.state,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    icao_type_id = EXCLUDED.icao_type_id;

  -- Add FBO locations for Louisville airports
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country, state)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'USA',
    'KY'
  FROM (
    VALUES 
      -- Louisville Muhammad Ali International (KSDF)
      ('Atlantic Aviation SDF', 38.1744, -85.7361, '2741 Crittenden Dr, Louisville, KY 40209'),
      ('UPS Global Aviation Operations', 38.1740, -85.7357, '911 Grade Ln, Louisville, KY 40213'),
      ('Signature Flight Support SDF', 38.1748, -85.7365, '2800 Crittenden Dr, Louisville, KY 40209'),
      
      -- Bowman Field (KLOU)
      ('Central American Airways', 38.2280, -85.6636, '2700 Gast Blvd, Louisville, KY 40205'),
      ('Louisville Executive Aviation', 38.2276, -85.6632, '2700 Gast Blvd, Louisville, KY 40205')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN ('KSDF', 'KLOU')
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%SDF%' OR fbo.name LIKE '%UPS%' THEN 'KSDF'
      WHEN fbo.name LIKE '%Central American%' OR fbo.name LIKE '%Louisville Executive%' THEN 'KLOU'
    END
  )
  ON CONFLICT DO NOTHING;

  -- Add FBO locations for Tijuana and Guadalajara airports
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
      -- Tijuana International (MMTJ)
      ('GAT Tijuana FBO', 32.5411, -116.9702, 'Carretera Aeropuerto S/N, Mesa de Otay, 22435 Tijuana, B.C.'),
      ('Grupo Aeroportuario del Pacífico', 32.5407, -116.9698, 'Terminal FBO, Aeropuerto Internacional de Tijuana'),
      ('CBX FBO Services', 32.5415, -116.9706, 'Cross Border Xpress Terminal, Tijuana International Airport'),
      
      -- Guadalajara International (MMGL)
      ('FBO Aerotron', 20.5218, -103.3111, 'Carretera Guadalajara Chapala Km 17.5, 45659 Jalisco'),
      ('Grupo Lomex FBO', 20.5214, -103.3107, 'Terminal Ejecutiva, Aeropuerto Internacional de Guadalajara'),
      ('Jetex Guadalajara', 20.5222, -103.3115, 'Zona de Hangares, Aeropuerto Internacional de Guadalajara')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN ('MMTJ', 'MMGL')
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%Tijuana%' OR fbo.name LIKE '%CBX%' OR fbo.name LIKE '%GAT%' THEN 'MMTJ'
      WHEN fbo.name LIKE '%Guadalajara%' OR fbo.name LIKE '%Aerotron%' OR fbo.name LIKE '%Lomex%' THEN 'MMGL'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;