-- Remove Meridian FBO from KTEB
DO $$ 
DECLARE
  teb_id uuid;
BEGIN
  -- Get KTEB airport ID
  SELECT id INTO teb_id FROM icaos WHERE code = 'KTEB';

  -- Delete Meridian FBO
  DELETE FROM fbos 
  WHERE icao_id = teb_id 
  AND name LIKE '%Meridian%';

  -- Verify remaining FBOs are correct
  -- Should only have:
  -- 1. Signature Flight Support TEB North
  -- 2. Signature Flight Support TEB South
  -- 3. Atlantic Aviation TEB
  -- 4. Jet Aviation Teterboro
END $$;