-- Add FBOs for KACT, KGRK, KAUS, and KBPT
DO $$ 
BEGIN
  -- Add FBOs for KACT (Waco Regional Airport)
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
      ('Texas Aero', 31.6112, -97.2304, '7909 Karl May Dr, Waco, TX 76708')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KACT'
  ) i
  ON CONFLICT DO NOTHING;

  -- Add FBOs for KGRK (Killeen-Fort Hood Regional Airport)
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
      ('CSI Aviation Services', 31.0672, -97.8289, '8101 S Clear Creek Rd, Killeen, TX 76549'),
      ('Skylark Aviation', 31.0668, -97.8285, '8208 S Clear Creek Rd, Killeen, TX 76549')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KGRK'
  ) i
  ON CONFLICT DO NOTHING;

  -- Add FBOs for KAUS (Austin-Bergstrom International Airport)
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
      ('Signature Flight Support AUS', 30.1945, -97.6699, '4321 Emma Browning Ave, Austin, TX 78719'),
      ('Million Air AUS', 30.1952, -97.6692, '4309 Emma Browning Ave, Austin, TX 78719'),
      ('Atlantic Aviation AUS', 30.1938, -97.6705, '4330 S Terminal Blvd, Austin, TX 78719'),
      ('Jet Aviation AUS', 30.1960, -97.6685, '4401 Emma Browning Ave, Austin, TX 78719')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KAUS'
  ) i
  ON CONFLICT DO NOTHING;

  -- Add FBOs for KBPT (Jack Brooks Regional Airport)
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
      ('Southeast Texas Air Services', 29.9508, -94.0207, '5000 Jerry Ware Dr, Beaumont, TX 77705'),
      ('Golden Triangle Aviation', 29.9515, -94.0200, '4875 Parker Dr, Beaumont, TX 77705')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KBPT'
  ) i
  ON CONFLICT DO NOTHING;
END $$;