-- Add FBOs for KFTW (Fort Worth Meacham International Airport)
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
      ('American Aero FTW', 32.8198, -97.3622, '201 American Concourse, Fort Worth, TX 76106'),
      ('Signature Flight Support FTW', 32.8190, -97.3615, '201 N Jim Wright Fwy, Fort Worth, TX 76106'),
      ('Texas Jet', 32.8205, -97.3630, '200 Texas Dr, Fort Worth, TX 76106'),
      ('FTW Aero', 32.8183, -97.3608, '4201 N Main St, Fort Worth, TX 76106')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KFTW'
  ) i
  ON CONFLICT DO NOTHING;
END $$;