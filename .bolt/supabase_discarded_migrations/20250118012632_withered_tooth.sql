-- Check and update any remaining ICAO records with null coordinates
DO $$ 
DECLARE
  null_count integer;
BEGIN
  -- First check how many records still have null coordinates
  SELECT COUNT(*) INTO null_count
  FROM icaos
  WHERE latitude IS NULL OR longitude IS NULL;

  -- Log the count
  RAISE NOTICE 'Found % ICAO records with null coordinates', null_count;

  -- Update any remaining records with null coordinates
  UPDATE icaos 
  SET 
    latitude = CASE code
      -- African Airports
      WHEN 'FALE' THEN -29.6144  -- King Shaka International Airport
      WHEN 'FBMN' THEN -19.9726  -- Maun Airport
      WHEN 'HKJK' THEN -1.3192   -- Jomo Kenyatta International Airport
      WHEN 'DNMM' THEN 6.5774    -- Murtala Muhammed International Airport
      -- South American Airports
      WHEN 'SKMD' THEN 6.1645    -- José María Córdova International Airport
      WHEN 'SACO' THEN -31.3236  -- Ingeniero Aeronáutico Ambrosio L.V. Taravella
      -- Asian Airports
      WHEN 'ZSOF' THEN 31.9878   -- Hefei Xinqiao International Airport
      WHEN 'ZSNJ' THEN 31.7418   -- Nanjing Lukou International Airport
      WHEN 'ZSFZ' THEN 25.9335   -- Fuzhou Changle International Airport
      WHEN 'ZSAM' THEN 24.5440   -- Xiamen Gaoqi International Airport
      -- European Airports
      WHEN 'LSZA' THEN 46.0040   -- Lugano Airport
      WHEN 'LSZR' THEN 47.4850   -- St. Gallen-Altenrhein Airport
      WHEN 'LSZG' THEN 47.1819   -- Grenchen Airport
      WHEN 'LSGS' THEN 46.2196   -- Sion Airport
      END,
    longitude = CASE code
      -- African Airports
      WHEN 'FALE' THEN 31.1197   -- King Shaka International Airport
      WHEN 'FBMN' THEN 23.4311   -- Maun Airport
      WHEN 'HKJK' THEN 36.9278   -- Jomo Kenyatta International Airport
      WHEN 'DNMM' THEN 3.3215    -- Murtala Muhammed International Airport
      -- South American Airports
      WHEN 'SKMD' THEN -75.4229  -- José María Córdova International Airport
      WHEN 'SACO' THEN -64.2081  -- Ingeniero Aeronáutico Ambrosio L.V. Taravella
      -- Asian Airports
      WHEN 'ZSOF' THEN 116.9784  -- Hefei Xinqiao International Airport
      WHEN 'ZSNJ' THEN 118.8622  -- Nanjing Lukou International Airport
      WHEN 'ZSFZ' THEN 119.6619  -- Fuzhou Changle International Airport
      WHEN 'ZSAM' THEN 118.1274  -- Xiamen Gaoqi International Airport
      -- European Airports
      WHEN 'LSZA' THEN 8.9106    -- Lugano Airport
      WHEN 'LSZR' THEN 9.5607    -- St. Gallen-Altenrhein Airport
      WHEN 'LSZG' THEN 7.4173    -- Grenchen Airport
      WHEN 'LSGS' THEN 7.3267    -- Sion Airport
      END
  WHERE latitude IS NULL OR longitude IS NULL;

  -- Check if any records still have null coordinates
  SELECT COUNT(*) INTO null_count
  FROM icaos
  WHERE latitude IS NULL OR longitude IS NULL;

  -- Log the final result
  IF null_count > 0 THEN
    RAISE NOTICE 'Warning: % ICAO records still have null coordinates', null_count;
  ELSE
    RAISE NOTICE 'Success: All ICAO records now have valid coordinates';
  END IF;
END $$;