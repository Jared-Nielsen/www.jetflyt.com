-- Update missing coordinates for ICAO airports
DO $$ 
BEGIN
  -- Update coordinates for airports that don't have them
  UPDATE icaos 
  SET 
    latitude = CASE code
      -- European Airports
      WHEN 'LFML' THEN 43.4392  -- Marseille Provence Airport
      WHEN 'LFBD' THEN 44.8283  -- Bordeaux–Mérignac Airport
      WHEN 'LEAL' THEN 38.2822  -- Alicante–Elche Airport
      WHEN 'LEPA' THEN 39.5517  -- Palma de Mallorca Airport
      WHEN 'LEMG' THEN 36.6749  -- Málaga Airport
      WHEN 'LEZL' THEN 37.4180  -- Seville Airport
      -- Nordic Airports
      WHEN 'ENGM' THEN 60.1975  -- Oslo Gardermoen Airport
      WHEN 'ENBR' THEN 60.2934  -- Bergen Airport, Flesland
      WHEN 'ESSA' THEN 59.6519  -- Stockholm Arlanda Airport
      WHEN 'ESGG' THEN 57.6627  -- Gothenburg-Landvetter Airport
      -- Eastern European Airports
      WHEN 'EPWA' THEN 52.1657  -- Warsaw Chopin Airport
      WHEN 'EPKK' THEN 50.0777  -- Kraków John Paul II International
      WHEN 'EVRA' THEN 56.9236  -- Riga International Airport
      WHEN 'EETN' THEN 59.4133  -- Lennart Meri Tallinn Airport
      -- Asian Airports
      WHEN 'VABB' THEN 19.0896  -- Chhatrapati Shivaji International Airport
      WHEN 'VOBL' THEN 13.1986  -- Kempegowda International Airport
      WHEN 'VECC' THEN 22.6520  -- Netaji Subhas Chandra Bose International
      WHEN 'OPKC' THEN 24.9065  -- Jinnah International Airport
      WHEN 'OPRN' THEN 33.6167  -- Benazir Bhutto International Airport
      END,
    longitude = CASE code
      -- European Airports
      WHEN 'LFML' THEN 5.2214   -- Marseille Provence Airport
      WHEN 'LFBD' THEN -0.7156  -- Bordeaux–Mérignac Airport
      WHEN 'LEAL' THEN -0.5582  -- Alicante–Elche Airport
      WHEN 'LEPA' THEN 2.7388   -- Palma de Mallorca Airport
      WHEN 'LEMG' THEN -4.4991  -- Málaga Airport
      WHEN 'LEZL' THEN -5.8932  -- Seville Airport
      -- Nordic Airports
      WHEN 'ENGM' THEN 11.1004  -- Oslo Gardermoen Airport
      WHEN 'ENBR' THEN 5.2181   -- Bergen Airport, Flesland
      WHEN 'ESSA' THEN 17.9186  -- Stockholm Arlanda Airport
      WHEN 'ESGG' THEN 12.2798  -- Gothenburg-Landvetter Airport
      -- Eastern European Airports
      WHEN 'EPWA' THEN 20.9671  -- Warsaw Chopin Airport
      WHEN 'EPKK' THEN 19.7848  -- Kraków John Paul II International
      WHEN 'EVRA' THEN 23.9711  -- Riga International Airport
      WHEN 'EETN' THEN 24.8328  -- Lennart Meri Tallinn Airport
      -- Asian Airports
      WHEN 'VABB' THEN 72.8656  -- Chhatrapati Shivaji International Airport
      WHEN 'VOBL' THEN 77.7066  -- Kempegowda International Airport
      WHEN 'VECC' THEN 88.4467  -- Netaji Subhas Chandra Bose International
      WHEN 'OPKC' THEN 67.1608  -- Jinnah International Airport
      WHEN 'OPRN' THEN 73.0991  -- Benazir Bhutto International Airport
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