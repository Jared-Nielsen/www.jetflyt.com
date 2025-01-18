-- Update missing coordinates for remaining ICAO airports
DO $$ 
BEGIN
  -- Update coordinates for airports that don't have them
  UPDATE icaos 
  SET 
    latitude = CASE code
      -- European Airports
      WHEN 'LJLJ' THEN 46.2237  -- Ljubljana Jože Pučnik Airport
      WHEN 'LDZA' THEN 45.7429  -- Zagreb Airport
      WHEN 'LDSP' THEN 43.5389  -- Split Airport
      WHEN 'LHBP' THEN 47.4298  -- Budapest Ferenc Liszt International Airport
      WHEN 'UGTB' THEN 41.6692  -- Tbilisi International Airport
      WHEN 'BKPR' THEN 42.5728  -- Pristina International Airport
      WHEN 'LUKK' THEN 46.9277  -- Chișinău International Airport
      -- Asian Airports
      WHEN 'VIDP' THEN 28.5562  -- Indira Gandhi International Airport
      WHEN 'UTTT' THEN 41.2573  -- Tashkent International Airport
      WHEN 'UTSS' THEN 39.7005  -- Samarkand International Airport
      WHEN 'UTAA' THEN 37.9868  -- Ashgabat International Airport
      WHEN 'UTAT' THEN 39.0833  -- Türkmenabat International Airport
      -- Oceanian Airports
      WHEN 'AYPY' THEN -9.4438  -- Jacksons International Airport
      WHEN 'AYNZ' THEN -6.5698  -- Nadzab Airport
      -- African Airports
      WHEN 'FYWH' THEN -22.4799 -- Hosea Kutako International Airport
      WHEN 'FYWE' THEN -22.9799 -- Walvis Bay Airport
      WHEN 'FBSK' THEN -24.5553 -- Sir Seretse Khama International Airport
      WHEN 'FBMN' THEN -19.9726 -- Maun Airport
      END,
    longitude = CASE code
      -- European Airports
      WHEN 'LJLJ' THEN 14.4576  -- Ljubljana Jože Pučnik Airport
      WHEN 'LDZA' THEN 16.0688  -- Zagreb Airport
      WHEN 'LDSP' THEN 16.2981  -- Split Airport
      WHEN 'LHBP' THEN 19.2611  -- Budapest Ferenc Liszt International Airport
      WHEN 'UGTB' THEN 44.9547  -- Tbilisi International Airport
      WHEN 'BKPR' THEN 21.0358  -- Pristina International Airport
      WHEN 'LUKK' THEN 28.9313  -- Chișinău International Airport
      -- Asian Airports
      WHEN 'VIDP' THEN 77.1000  -- Indira Gandhi International Airport
      WHEN 'UTTT' THEN 69.2817  -- Tashkent International Airport
      WHEN 'UTSS' THEN 66.9838  -- Samarkand International Airport
      WHEN 'UTAA' THEN 58.3610  -- Ashgabat International Airport
      WHEN 'UTAT' THEN 63.6133  -- Türkmenabat International Airport
      -- Oceanian Airports
      WHEN 'AYPY' THEN 147.2200 -- Jacksons International Airport
      WHEN 'AYNZ' THEN 146.7262 -- Nadzab Airport
      -- African Airports
      WHEN 'FYWH' THEN 17.4709  -- Hosea Kutako International Airport
      WHEN 'FYWE' THEN 14.6453  -- Walvis Bay Airport
      WHEN 'FBSK' THEN 25.9183  -- Sir Seretse Khama International Airport
      WHEN 'FBMN' THEN 23.4311  -- Maun Airport
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