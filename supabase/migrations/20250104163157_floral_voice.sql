-- Add FBOs for major European airports
DO $$ 
BEGIN
  -- First ensure all required ICAO codes exist
  INSERT INTO icaos (code, name, country, continent, latitude, longitude)
  VALUES
    ('LFPG', 'Paris Charles de Gaulle Airport', 'France', 'Europe', 49.0097, 2.5478),
    ('EGLL', 'London Heathrow Airport', 'United Kingdom', 'Europe', 51.4700, -0.4543),
    ('EDDF', 'Frankfurt Airport', 'Germany', 'Europe', 50.0379, 8.5622),
    ('EHAM', 'Amsterdam Airport Schiphol', 'Netherlands', 'Europe', 52.3086, 4.7639)
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

  -- Add FBOs for Paris Charles de Gaulle (LFPG)
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'France'
  FROM (
    VALUES 
      ('Signature Flight Support CDG', 49.0097, 2.5478, 'Zone Aviation Générale, 95700 Roissy-en-France'),
      ('Universal Aviation CDG', 49.0090, 2.5470, 'Aéroport CDG, Terminal d''Aviation d''Affaires'),
      ('Advanced Air Support CDG', 49.0085, 2.5465, 'Zone Aviation d''Affaires, Rue de la Belle Borne'),
      ('Sky Valet CDG', 49.0080, 2.5460, 'Terminal d''Aviation d''Affaires, Zone Centrale')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'LFPG'
  ) i
  ON CONFLICT DO NOTHING;

  -- Add FBOs for London Heathrow (EGLL)
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'United Kingdom'
  FROM (
    VALUES 
      ('Signature Flight Support LHR', 51.4700, -0.4543, 'Terminal 3, Heathrow Airport'),
      ('Universal Aviation LHR', 51.4695, -0.4540, 'Building 604, Sandringham Road'),
      ('Jet Aviation LHR', 51.4690, -0.4535, 'Building 578, Southern Perimeter Road'),
      ('Farnborough Airport VIP Terminal', 51.4685, -0.4530, 'Terminal 5, Heathrow Airport')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'EGLL'
  ) i
  ON CONFLICT DO NOTHING;

  -- Add FBOs for Frankfurt (EDDF)
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'Germany'
  FROM (
    VALUES 
      ('Signature Flight Support FRA', 50.0379, 8.5622, 'Gate 26, Frankfurt Airport'),
      ('Air Service Basel FRA', 50.0375, 8.5618, 'General Aviation Terminal'),
      ('ExecuJet FRA', 50.0370, 8.5615, 'GAT, Frankfurt Airport'),
      ('FAI Aviation Group', 50.0365, 8.5610, 'General Aviation Center')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'EDDF'
  ) i
  ON CONFLICT DO NOTHING;

  -- Add FBOs for Amsterdam Schiphol (EHAM)
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'Netherlands'
  FROM (
    VALUES 
      ('Signature Flight Support AMS', 52.3086, 4.7639, 'Thermiekstraat 1, 1117 Schiphol'),
      ('KLM Jet Center', 52.3080, 4.7635, 'Thermiekstraat 5, 1117 Schiphol'),
      ('JetSupport', 52.3075, 4.7630, 'Thermiekstraat 7, 1117 Schiphol'),
      ('General Aviation Terminal', 52.3070, 4.7625, 'Thermiekstraat 10, 1117 Schiphol')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'EHAM'
  ) i
  ON CONFLICT DO NOTHING;
END $$;