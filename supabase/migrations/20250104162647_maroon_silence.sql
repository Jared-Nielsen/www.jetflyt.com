-- Get KHOU ICAO ID
DO $$ 
BEGIN
  -- Add FBOs for KHOU (William P. Hobby Airport)
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country, state)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'USA',
    'TX'
  FROM (
    VALUES 
      ('Signature Flight Support HOU', 29.6459, -95.2789, '8402 Nelms St, Houston, TX 77061'),
      ('Wilson Air Center HOU', 29.6476, -95.2773, '9000 Randolph St, Houston, TX 77061'),
      ('Million Air HOU', 29.6463, -95.2781, '8501 Telephone Rd, Houston, TX 77061'),
      ('Atlantic Aviation HOU', 29.6470, -95.2767, '8620 Paul B Koonce St, Houston, TX 77061'),
      ('Jet Aviation HOU', 29.6455, -95.2795, '8410 Nelms St, Houston, TX 77061')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KHOU'
  ) i
  ON CONFLICT DO NOTHING;
END $$;