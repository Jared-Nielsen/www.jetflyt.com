-- Add Galaxy FBO to KHOU
DO $$ 
DECLARE
  hou_id uuid;
BEGIN
  -- Get KHOU airport ID
  SELECT id INTO hou_id FROM icaos WHERE code = 'KHOU';

  -- Add Galaxy FBO
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country, state)
  VALUES (
    'Galaxy Air Services', 
    hou_id,
    29.6467, 
    -95.2775,
    '8700 Scranton St, Houston, TX 77061',
    'USA',
    'TX'
  )
  ON CONFLICT DO NOTHING;

  -- Verify FBOs at KHOU should now be:
  -- 1. Signature Flight Support HOU
  -- 2. Wilson Air Center HOU
  -- 3. Million Air HOU
  -- 4. Atlantic Aviation HOU
  -- 5. Jet Aviation HOU
  -- 6. Galaxy Air Services
END $$;