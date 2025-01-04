-- Add FBOs for KAMA (Rick Husband Amarillo International Airport)
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
      ('TAC Air AMA', 35.2194, -101.7059, '10610 Airport Blvd, Amarillo, TX 79111'),
      ('Atlantic Aviation AMA', 35.2188, -101.7065, '10801 Airport Blvd, Amarillo, TX 79111')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KAMA'
  ) i
  ON CONFLICT DO NOTHING;
END $$;