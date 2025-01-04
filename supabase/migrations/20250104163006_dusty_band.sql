-- Add FBOs for KLBB (Lubbock Preston Smith International Airport)
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
      ('Lubbock Aero', 33.6636, -101.8230, '6304 N Cedar Ave, Lubbock, TX 79403'),
      ('Atlantic Aviation LBB', 33.6642, -101.8225, '6408 N Cedar Ave, Lubbock, TX 79403')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KLBB'
  ) i
  ON CONFLICT DO NOTHING;
END $$;