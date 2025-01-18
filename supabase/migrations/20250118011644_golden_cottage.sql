-- Update missing coordinates for ICAO airports
DO $$ 
BEGIN
  -- Update coordinates for airports that don't have them
  UPDATE icaos 
  SET 
    latitude = CASE code
      -- Middle East
      WHEN 'OBBI' THEN 26.2708  -- Bahrain International Airport
      WHEN 'OMAA' THEN 24.4441  -- Abu Dhabi International Airport
      WHEN 'OTHH' THEN 25.2731  -- Hamad International Airport
      -- Asia
      WHEN 'VTBS' THEN 13.6900  -- Suvarnabhumi Airport
      WHEN 'WMKK' THEN 2.7456   -- Kuala Lumpur International Airport
      -- Africa
      WHEN 'GMMX' THEN 31.6069  -- Marrakesh Menara Airport
      WHEN 'HECA' THEN 30.1219  -- Cairo International Airport
      -- South America
      WHEN 'SCEL' THEN -33.3930 -- Arturo Merino Benítez International Airport
      WHEN 'SBGR' THEN -23.4356 -- São Paulo/Guarulhos International Airport
      -- Europe
      WHEN 'LIRA' THEN 41.7994  -- Rome Ciampino Airport
      WHEN 'LKPR' THEN 50.1008  -- Václav Havel Airport Prague
      -- North America
      WHEN 'MWCR' THEN 19.2928  -- Owen Roberts International Airport
      WHEN 'MMTO' THEN 19.3371  -- Toluca International Airport
      END,
    longitude = CASE code
      -- Middle East
      WHEN 'OBBI' THEN 50.6332  -- Bahrain International Airport
      WHEN 'OMAA' THEN 54.6511  -- Abu Dhabi International Airport
      WHEN 'OTHH' THEN 51.6081  -- Hamad International Airport
      -- Asia
      WHEN 'VTBS' THEN 100.7501 -- Suvarnabhumi Airport
      WHEN 'WMKK' THEN 101.7099 -- Kuala Lumpur International Airport
      -- Africa
      WHEN 'GMMX' THEN -8.0363  -- Marrakesh Menara Airport
      WHEN 'HECA' THEN 31.4056  -- Cairo International Airport
      -- South America
      WHEN 'SCEL' THEN -70.7858 -- Arturo Merino Benítez International Airport
      WHEN 'SBGR' THEN -46.4731 -- São Paulo/Guarulhos International Airport
      -- Europe
      WHEN 'LIRA' THEN 12.5949  -- Rome Ciampino Airport
      WHEN 'LKPR' THEN 14.2600  -- Václav Havel Airport Prague
      -- North America
      WHEN 'MWCR' THEN -81.3577 -- Owen Roberts International Airport
      WHEN 'MMTO' THEN -99.5660 -- Toluca International Airport
      END
  WHERE latitude IS NULL OR longitude IS NULL;

  -- Verify all airports now have coordinates
  DO $verify$ 
  BEGIN
    IF EXISTS (
      SELECT 1 FROM icaos 
      WHERE latitude IS NULL OR longitude IS NULL
    ) THEN
      RAISE NOTICE 'Warning: Some airports still have missing coordinates';
    END IF;
  END $verify$;
END $$;