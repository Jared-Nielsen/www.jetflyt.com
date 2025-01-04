/*
  # Add DFW Airport FBO Locations

  1. New Data
    - Add FBO locations for Dallas/Fort Worth International Airport (KDFW)
    - Each FBO includes name, coordinates, and full address
  
  2. Changes
    - Insert new FBO records with KDFW ICAO reference
*/

-- Get KDFW ICAO ID
DO $$ 
BEGIN
  -- Add FBOs for KDFW
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
      ('Signature Flight Support DFW North', 32.8968, -97.0380, '2425 Aviation Drive, DFW Airport, TX 75261'),
      ('Signature Flight Support DFW South', 32.8918, -97.0402, '1816 N 24th Ave, DFW Airport, TX 75261'),
      ('TAC Air DFW', 32.8935, -97.0425, '2525 Aviation Drive, DFW Airport, TX 75261'),
      ('American Aero FTW', 32.8945, -97.0408, '2301 Aviation Drive, DFW Airport, TX 75261')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KDFW'
  ) i
  ON CONFLICT DO NOTHING;
END $$;