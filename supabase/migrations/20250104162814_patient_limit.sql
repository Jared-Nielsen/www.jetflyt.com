-- Add FBOs for KSAT (San Antonio International Airport)
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
      ('Signature Flight Support SAT', 29.5339, -98.4690, '1215 N Frank Luke Dr, San Antonio, TX 78226'),
      ('Million Air SAT', 29.5347, -98.4681, '8901 Wetmore Rd, San Antonio, TX 78216'),
      ('Atlantic Aviation SAT', 29.5331, -98.4698, '8325 Mission Rd, San Antonio, TX 78214'),
      ('Skyplace FBO', 29.5320, -98.4705, '8538 Mission Rd, San Antonio, TX 78214')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KSAT'
  ) i
  ON CONFLICT DO NOTHING;
END $$;