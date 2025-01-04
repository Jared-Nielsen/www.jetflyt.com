/*
  # Add KCXO Airport FBO Locations

  1. New Data
    - Add FBO locations for Conroe-North Houston Regional Airport (KCXO)
    - Each FBO includes name, coordinates, and full address
  
  2. Changes
    - Insert new FBO records with KCXO ICAO reference
*/

-- Get KCXO ICAO ID
DO $$ 
BEGIN
  -- Add FBOs for KCXO
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country, state)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'USA',
    'TX'
  FROM (
    VALUES 
      ('Galaxy FBO', 30.3518, -95.4144, '2971 Hawthorne Dr, Conroe, TX 77303'),
      ('General Aviation Services', 30.3507, -95.4133, '2900 FM 1484 Rd, Conroe, TX 77303'),
      ('Lone Star Executive', 30.3525, -95.4150, '10000 Terminal Dr, Conroe, TX 77303')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KCXO'
  ) i
  ON CONFLICT DO NOTHING;
END $$;