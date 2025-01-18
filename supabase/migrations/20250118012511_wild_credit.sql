-- Update missing coordinates for remaining ICAO airports
DO $$ 
BEGIN
  -- Update coordinates for airports that don't have them
  UPDATE icaos 
  SET 
    latitude = CASE code
      -- African Airports
      WHEN 'DNAA' THEN 9.0065   -- Nnamdi Azikiwe International Airport
      WHEN 'DGAA' THEN 5.6052   -- Kotoka International Airport
      WHEN 'DGLE' THEN 9.5577   -- Tamale Airport
      WHEN 'GOBD' THEN 14.6710  -- Blaise Diagne International Airport
      WHEN 'GOGS' THEN 12.4102  -- Cap Skirring Airport
      WHEN 'HKMO' THEN -4.0348  -- Mombasa Moi International Airport
      WHEN 'HTDA' THEN -6.8778  -- Julius Nyerere International Airport
      WHEN 'HTZA' THEN -6.2224  -- Abeid Amani Karume International Airport
      WHEN 'HADR' THEN 9.6247   -- Dire Dawa Airport
      -- South American Airports
      WHEN 'SEQM' THEN -0.1292  -- Mariscal Sucre International Airport
      WHEN 'SEGU' THEN -2.1574  -- José Joaquín de Olmedo International Airport
      WHEN 'SPJC' THEN -12.0219 -- Jorge Chávez International Airport
      WHEN 'SPZO' THEN -13.5357 -- Alejandro Velasco Astete International Airport
      -- Central Asian Airports
      WHEN 'OIIE' THEN 35.4161  -- Imam Khomeini International Airport
      WHEN 'OIII' THEN 35.6892  -- Mehrabad International Airport
      -- Southeast Asian Airports
      WHEN 'VVNB' THEN 21.2187  -- Noi Bai International Airport
      WHEN 'VVTS' THEN 10.8188  -- Tan Son Nhat International Airport
      END,
    longitude = CASE code
      -- African Airports
      WHEN 'DNAA' THEN 7.2631   -- Nnamdi Azikiwe International Airport
      WHEN 'DGAA' THEN -0.1668  -- Kotoka International Airport
      WHEN 'DGLE' THEN -0.8632  -- Tamale Airport
      WHEN 'GOBD' THEN -17.0733 -- Blaise Diagne International Airport
      WHEN 'GOGS' THEN -16.7462 -- Cap Skirring Airport
      WHEN 'HKMO' THEN 39.5942  -- Mombasa Moi International Airport
      WHEN 'HTDA' THEN 39.2026  -- Julius Nyerere International Airport
      WHEN 'HTZA' THEN 39.2244  -- Abeid Amani Karume International Airport
      WHEN 'HADR' THEN 41.8542  -- Dire Dawa Airport
      -- South American Airports
      WHEN 'SEQM' THEN -78.3575 -- Mariscal Sucre International Airport
      WHEN 'SEGU' THEN -79.8837 -- José Joaquín de Olmedo International Airport
      WHEN 'SPJC' THEN -77.1143 -- Jorge Chávez International Airport
      WHEN 'SPZO' THEN -71.9389 -- Alejandro Velasco Astete International Airport
      -- Central Asian Airports
      WHEN 'OIIE' THEN 51.1522  -- Imam Khomeini International Airport
      WHEN 'OIII' THEN 51.3134  -- Mehrabad International Airport
      -- Southeast Asian Airports
      WHEN 'VVNB' THEN 105.8055 -- Noi Bai International Airport
      WHEN 'VVTS' THEN 106.6520 -- Tan Son Nhat International Airport
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