-- Add Jetex FBO locations worldwide
DO $$ 
BEGIN
  -- Add Jetex FBO locations
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    fbo.country
  FROM (
    VALUES 
      -- Europe
      ('Jetex Paris Le Bourget', 48.9693, 2.4412, 'Terminal d''Aviation d''Affaires, Aéroport de Paris-Le Bourget', 'France'),
      ('Jetex Barcelona', 41.2971, 2.0785, 'Terminal Corporativa, El Prat de Llobregat', 'Spain'),
      ('Jetex Rome Ciampino', 41.7994, 12.5949, 'Via Appia Nuova, 1651, Roma', 'Italy'),
      ('Jetex Prague', 50.1008, 14.2600, 'Terminal 3, Aviatická, Prague', 'Czech Republic'),
      ('Jetex Kiev', 50.4018, 30.4492, 'Terminal B, Kiev International Airport', 'Ukraine'),
      ('Jetex Shannon', 52.7019, -8.9248, 'Business Aviation Terminal, Shannon Airport', 'Ireland'),

      -- Middle East
      ('Jetex Dubai DWC', 24.8969, 55.1714, 'Dubai South VIP Terminal, Al Maktoum International Airport', 'United Arab Emirates'),
      ('Jetex Dubai FBO & FTZ', 25.2532, 55.3657, 'Dubai International Airport Terminal 3', 'United Arab Emirates'),
      ('Jetex Muscat', 23.5931, 58.2844, 'Private Aviation Terminal, Muscat International Airport', 'Oman'),
      ('Jetex Bahrain', 26.2708, 50.6332, 'Aviation Terminal, Muharraq', 'Bahrain'),
      ('Jetex Abu Dhabi', 24.4441, 54.6511, 'VIP Terminal, Abu Dhabi International Airport', 'United Arab Emirates'),
      ('Jetex Doha', 25.2731, 51.6081, 'FBO Terminal, Hamad International Airport', 'Qatar'),

      -- Asia
      ('Jetex Bangkok', 13.6900, 100.7501, 'Private Aviation Terminal, Suvarnabhumi Airport', 'Thailand'),
      ('Jetex Kuala Lumpur', 2.7456, 101.7099, 'Skypark Regional Aviation Centre, Sepang', 'Malaysia'),
      ('Jetex Beijing', 40.0799, 116.6031, 'Business Aviation Terminal, Beijing Capital International Airport', 'China'),
      ('Jetex Singapore', 1.3644, 103.9915, '11 Airline Road, Changi Airport', 'Singapore'),

      -- Americas
      ('Jetex Miami', 25.7932, -80.2906, '5000 NW 36th St, Miami, FL 33122', 'United States'),
      ('Jetex Mexico City', 19.4363, -99.0721, 'Terminal 2, Zona Federal, Mexico City International Airport', 'Mexico'),
      ('Jetex Toluca', 19.3371, -99.5660, 'Terminal FBO, Aeropuerto Internacional de Toluca', 'Mexico'),
      ('Jetex São Paulo', -23.4356, -46.4731, 'Terminal de Aviação Executiva, Aeroporto de Guarulhos', 'Brazil'),

      -- Africa
      ('Jetex Marrakech', 31.6069, -8.0363, 'Terminal VIP, Marrakech Menara Airport', 'Morocco'),
      ('Jetex Cairo', 30.1219, 31.4056, 'Private Aviation Terminal, Cairo International Airport', 'Egypt')
  ) as fbo(name, latitude, longitude, address, country)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'LFPB', 'LEBL', 'LIRA', 'LKPR', 'UKKK', 'EINN',  -- Europe
      'OMDW', 'OMDB', 'OOMS', 'OBBI', 'OMAA', 'OTHH',  -- Middle East
      'VTBS', 'WMKK', 'ZBAA', 'WSSS',                   -- Asia
      'KMIA', 'MMMX', 'MMTO', 'SBGR',                   -- Americas
      'GMMX', 'HECA'                                     -- Africa
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%Paris%' THEN 'LFPB'
      WHEN fbo.name LIKE '%Barcelona%' THEN 'LEBL'
      WHEN fbo.name LIKE '%Rome%' THEN 'LIRA'
      WHEN fbo.name LIKE '%Prague%' THEN 'LKPR'
      WHEN fbo.name LIKE '%Kiev%' THEN 'UKKK'
      WHEN fbo.name LIKE '%Shannon%' THEN 'EINN'
      WHEN fbo.name LIKE '%DWC%' THEN 'OMDW'
      WHEN fbo.name LIKE '%Dubai FBO%' THEN 'OMDB'
      WHEN fbo.name LIKE '%Muscat%' THEN 'OOMS'
      WHEN fbo.name LIKE '%Bahrain%' THEN 'OBBI'
      WHEN fbo.name LIKE '%Abu Dhabi%' THEN 'OMAA'
      WHEN fbo.name LIKE '%Doha%' THEN 'OTHH'
      WHEN fbo.name LIKE '%Bangkok%' THEN 'VTBS'
      WHEN fbo.name LIKE '%Kuala Lumpur%' THEN 'WMKK'
      WHEN fbo.name LIKE '%Beijing%' THEN 'ZBAA'
      WHEN fbo.name LIKE '%Singapore%' THEN 'WSSS'
      WHEN fbo.name LIKE '%Miami%' THEN 'KMIA'
      WHEN fbo.name LIKE '%Mexico City%' THEN 'MMMX'
      WHEN fbo.name LIKE '%Toluca%' THEN 'MMTO'
      WHEN fbo.name LIKE '%São Paulo%' THEN 'SBGR'
      WHEN fbo.name LIKE '%Marrakech%' THEN 'GMMX'
      WHEN fbo.name LIKE '%Cairo%' THEN 'HECA'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;