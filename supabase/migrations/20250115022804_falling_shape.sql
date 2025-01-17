-- Rename FBOs at KHOU to remove HOU suffix
DO $$ 
DECLARE
  hou_id uuid;
BEGIN
  -- Get KHOU airport ID
  SELECT id INTO hou_id FROM icaos WHERE code = 'KHOU';

  -- Update FBO names
  UPDATE fbos 
  SET name = 'Wilson Air Center'
  WHERE icao_id = hou_id 
  AND name = 'Wilson Air Center HOU';

  UPDATE fbos 
  SET name = 'Million Air'
  WHERE icao_id = hou_id 
  AND name = 'Million Air HOU';

  UPDATE fbos 
  SET name = 'Atlantic Aviation'
  WHERE icao_id = hou_id 
  AND name = 'Atlantic Aviation HOU';

  UPDATE fbos 
  SET name = 'Jet Aviation'
  WHERE icao_id = hou_id 
  AND name = 'Jet Aviation HOU';

  -- Verify FBOs at KHOU should now be:
  -- 1. Wilson Air Center
  -- 2. Million Air
  -- 3. Atlantic Aviation
  -- 4. Jet Aviation
  -- 5. Galaxy FBO
END $$;