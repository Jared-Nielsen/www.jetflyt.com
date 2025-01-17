-- Remove Signature Flight Support from KHOU
DO $$ 
DECLARE
  hou_id uuid;
BEGIN
  -- Get KHOU airport ID
  SELECT id INTO hou_id FROM icaos WHERE code = 'KHOU';

  -- Delete Signature Flight Support HOU
  DELETE FROM fbos 
  WHERE icao_id = hou_id 
  AND name = 'Signature Flight Support HOU';

  -- Verify FBOs at KHOU should now be:
  -- 1. Wilson Air Center HOU
  -- 2. Million Air HOU
  -- 3. Atlantic Aviation HOU
  -- 4. Jet Aviation HOU
  -- 5. Galaxy FBO
END $$;