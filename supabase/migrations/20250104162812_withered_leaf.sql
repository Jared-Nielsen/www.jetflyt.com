-- Add FBOs for KTME (Houston Executive Airport)
DO $$ 
BEGIN
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
      ('Henriksen Jet Center', 29.8053, -95.8935, '20803 Stuebner Airline Rd, Spring, TX 77379')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KTME'
  ) i
  ON CONFLICT DO NOTHING;
END $$;