-- Update missing coordinates for remaining ICAO airports
DO $$ 
BEGIN
  -- Update coordinates for airports that don't have them
  UPDATE icaos 
  SET 
    latitude = CASE code
      -- South American Airports
      WHEN 'SLLP' THEN -16.5133  -- El Alto International Airport
      WHEN 'SLVR' THEN -17.6445  -- Viru Viru International Airport
      WHEN 'SGAS' THEN -25.2400  -- Silvio Pettirossi International Airport
      WHEN 'SBCT' THEN -25.5285  -- Afonso Pena International Airport
      WHEN 'SBMQ' THEN 0.0507    -- Alberto Alcolumbre International Airport
      WHEN 'SBFZ' THEN -3.7761   -- Pinto Martins International Airport
      WHEN 'SBSV' THEN -12.9086  -- Deputado Luís Eduardo Magalhães International
      WHEN 'SBBR' THEN -15.8711  -- Presidente Juscelino Kubitschek International
      WHEN 'SBCF' THEN -19.6336  -- Tancredo Neves International Airport
      -- Southeast Asian Airports
      WHEN 'WMSA' THEN 3.1303    -- Sultan Abdul Aziz Shah Airport
      WHEN 'VVNB' THEN 21.2187   -- Noi Bai International Airport
      WHEN 'VVTS' THEN 10.8188   -- Tan Son Nhat International Airport
      WHEN 'VDPP' THEN 11.5466   -- Phnom Penh International Airport
      WHEN 'VDSR' THEN 13.4117   -- Siem Reap International Airport
      WHEN 'RPLL' THEN 14.5086   -- Ninoy Aquino International Airport
      WHEN 'RPLC' THEN 15.1859   -- Clark International Airport
      -- Central Asian Airports
      WHEN 'ZMUB' THEN 47.8431   -- Chinggis Khaan International Airport
      END,
    longitude = CASE code
      -- South American Airports
      WHEN 'SLLP' THEN -68.1919  -- El Alto International Airport
      WHEN 'SLVR' THEN -63.1353  -- Viru Viru International Airport
      WHEN 'SGAS' THEN -57.5200  -- Silvio Pettirossi International Airport
      WHEN 'SBCT' THEN -49.1758  -- Afonso Pena International Airport
      WHEN 'SBMQ' THEN -51.0722  -- Alberto Alcolumbre International Airport
      WHEN 'SBFZ' THEN -38.5323  -- Pinto Martins International Airport
      WHEN 'SBSV' THEN -38.3225  -- Deputado Luís Eduardo Magalhães International
      WHEN 'SBBR' THEN -47.9186  -- Presidente Juscelino Kubitschek International
      WHEN 'SBCF' THEN -43.9686  -- Tancredo Neves International Airport
      -- Southeast Asian Airports
      WHEN 'WMSA' THEN 101.5492  -- Sultan Abdul Aziz Shah Airport
      WHEN 'VVNB' THEN 105.8055  -- Noi Bai International Airport
      WHEN 'VVTS' THEN 106.6520  -- Tan Son Nhat International Airport
      WHEN 'VDPP' THEN 104.8444  -- Phnom Penh International Airport
      WHEN 'VDSR' THEN 103.8135  -- Siem Reap International Airport
      WHEN 'RPLL' THEN 121.0194  -- Ninoy Aquino International Airport
      WHEN 'RPLC' THEN 120.5594  -- Clark International Airport
      -- Central Asian Airports
      WHEN 'ZMUB' THEN 106.7666  -- Chinggis Khaan International Airport
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