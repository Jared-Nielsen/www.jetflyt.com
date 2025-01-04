-- Add FBOs for KGGG (East Texas Regional Airport)
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
      ('East Texas Regional Aviation', 32.3829, -94.7115, '269 Terminal Circle, Longview, TX 75603'),
      ('Longview Jet Center', 32.3825, -94.7110, '400 Terminal Circle, Longview, TX 75603')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KGGG'
  ) i
  ON CONFLICT DO NOTHING;
END $$;