-- Update missing coordinates for remaining ICAO airports
DO $$ 
BEGIN
  -- Update coordinates for airports that don't have them
  UPDATE icaos 
  SET 
    latitude = CASE code
      -- Canadian Airports
      WHEN 'CYPA' THEN 53.2142  -- Prince Albert Glass Field
      WHEN 'CYPG' THEN 49.9030  -- Portage la Prairie/Southport Airport
      WHEN 'CYAV' THEN 50.0564  -- St. Andrews Airport
      WHEN 'CYCD' THEN 49.0547  -- Nanaimo Airport
      -- Russian Airports
      WHEN 'UUDD' THEN 55.4103  -- Domodedovo International Airport
      WHEN 'ULLI' THEN 59.8003  -- Pulkovo Airport
      -- Asian Airports
      WHEN 'ZGNN' THEN 22.6082  -- Nanning Wuxu International Airport
      WHEN 'ZGHA' THEN 28.1892  -- Changsha Huanghua International Airport
      WHEN 'ZGKL' THEN 25.2178  -- Guilin Liangjiang International Airport
      WHEN 'ZGOW' THEN 27.9122  -- Wenzhou Longwan International Airport
      -- Middle Eastern Airports
      WHEN 'OOMS' THEN 23.5931  -- Muscat International Airport
      WHEN 'OMDW' THEN 24.8969  -- Al Maktoum International Airport
      -- African Airports
      WHEN 'HAAB' THEN 8.9778   -- Addis Ababa Bole International Airport
      WHEN 'DTTA' THEN 36.8510  -- Tunis-Carthage International Airport
      WHEN 'DTMB' THEN 33.8757  -- Djerba-Zarzis International Airport
      END,
    longitude = CASE code
      -- Canadian Airports
      WHEN 'CYPA' THEN -105.6731 -- Prince Albert Glass Field
      WHEN 'CYPG' THEN -98.2747  -- Portage la Prairie/Southport Airport
      WHEN 'CYAV' THEN -97.0325  -- St. Andrews Airport
      WHEN 'CYCD' THEN -123.8702 -- Nanaimo Airport
      -- Russian Airports
      WHEN 'UUDD' THEN 37.9026   -- Domodedovo International Airport
      WHEN 'ULLI' THEN 30.2625   -- Pulkovo Airport
      -- Asian Airports
      WHEN 'ZGNN' THEN 108.1722  -- Nanning Wuxu International Airport
      WHEN 'ZGHA' THEN 113.2197  -- Changsha Huanghua International Airport
      WHEN 'ZGKL' THEN 110.0391  -- Guilin Liangjiang International Airport
      WHEN 'ZGOW' THEN 120.8519  -- Wenzhou Longwan International Airport
      -- Middle Eastern Airports
      WHEN 'OOMS' THEN 58.2844   -- Muscat International Airport
      WHEN 'OMDW' THEN 55.1714   -- Al Maktoum International Airport
      -- African Airports
      WHEN 'HAAB' THEN 38.7989   -- Addis Ababa Bole International Airport
      WHEN 'DTTA' THEN 10.2272   -- Tunis-Carthage International Airport
      WHEN 'DTMB' THEN 10.7755   -- Djerba-Zarzis International Airport
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