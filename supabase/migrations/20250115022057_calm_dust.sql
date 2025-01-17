-- Remove duplicate FBOs from KTEB
DO $$ 
DECLARE
  teb_id uuid;
  duplicate_count integer;
BEGIN
  -- Get KTEB airport ID
  SELECT id INTO teb_id FROM icaos WHERE code = 'KTEB';

  -- Count duplicates
  SELECT COUNT(*) INTO duplicate_count
  FROM fbos 
  WHERE icao_id = teb_id;

  -- Only proceed if we have duplicates
  IF duplicate_count > 5 THEN
    -- Keep only the most complete and accurate FBO records
    WITH ranked_fbos AS (
      SELECT id,
             name,
             ROW_NUMBER() OVER (
               PARTITION BY 
                 CASE 
                   WHEN name LIKE '%Meridian%' THEN 'meridian'
                   WHEN name LIKE '%Signature%North%' THEN 'signature_north'
                   WHEN name LIKE '%Signature%South%' THEN 'signature_south'
                   WHEN name LIKE '%Atlantic%' THEN 'atlantic'
                   WHEN name LIKE '%Jet Aviation%' THEN 'jet_aviation'
                   ELSE name
                 END
               ORDER BY id
             ) as rn
      FROM fbos
      WHERE icao_id = teb_id
    )
    DELETE FROM fbos 
    WHERE id IN (
      SELECT id 
      FROM ranked_fbos 
      WHERE rn > 1
    );
  END IF;
END $$;