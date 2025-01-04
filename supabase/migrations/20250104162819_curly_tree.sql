-- Add FBOs for KABI (Abilene Regional Airport)
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
      ('Eagle Aviation Services', 32.4113, -99.6819, '2850 Airport Blvd, Abilene, TX 79602'),
      ('Abilene Aero', 32.4120, -99.6825, '2850 Airport Blvd, Abilene, TX 79602')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KABI'
  ) i
  ON CONFLICT DO NOTHING;
END $$;