-- Add FBOs for KDAL (Dallas Love Field)
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
      ('Business Jet Center', 32.8481, -96.8512, '8611 Lemmon Ave, Dallas, TX 75209'),
      ('Signature Flight Support DAL', 32.8475, -96.8505, '8321 Lemmon Ave, Dallas, TX 75209'),
      ('TAC Air DAL', 32.8488, -96.8520, '7515 Lemmon Ave, Dallas, TX 75209'),
      ('Modern Aviation DAL', 32.8470, -96.8498, '7777 Lemmon Ave, Dallas, TX 75209')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KDAL'
  ) i
  ON CONFLICT DO NOTHING;
END $$;