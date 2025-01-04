-- Add FBOs for KELP (El Paso International Airport)
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
      ('Million Air ELP', 31.8069, -106.3778, '1850 Hawkins Blvd, El Paso, TX 79925'),
      ('Atlantic Aviation ELP', 31.8075, -106.3772, '1751 Shuttle Columbia Dr, El Paso, TX 79925')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KELP'
  ) i
  ON CONFLICT DO NOTHING;
END $$;