-- Rename Galaxy Air Services to Galaxy FBO at KHOU
DO $$ 
DECLARE
  hou_id uuid;
BEGIN
  -- Get KHOU airport ID
  SELECT id INTO hou_id FROM icaos WHERE code = 'KHOU';

  -- Update Galaxy Air Services to Galaxy FBO
  UPDATE fbos 
  SET name = 'Galaxy FBO'
  WHERE icao_id = hou_id 
  AND name = 'Galaxy Air Services';

  -- Verify FBOs at KHOU should now be:
  -- 1. Signature Flight Support HOU
  -- 2. Wilson Air Center HOU
  -- 3. Million Air HOU
  -- 4. Atlantic Aviation HOU
  -- 5. Jet Aviation HOU
  -- 6. Galaxy FBO
END $$;