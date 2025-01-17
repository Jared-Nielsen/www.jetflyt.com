-- Add Le Bourget Airport and its FBOs
DO $$ 
BEGIN
  -- Insert ICAO code for Le Bourget
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    ('LFPB', 'Paris-Le Bourget Airport', 'France', 'Europe', 48.9693, 2.4412,
      (SELECT id FROM icao_types WHERE name = 'international'))
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    icao_type_id = EXCLUDED.icao_type_id;

  -- Add FBO locations for Le Bourget
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
      ('Signature Flight Support Le Bourget', 48.9693, 2.4412, 'Aéroport de Paris-Le Bourget, 93350 Le Bourget'),
      ('Universal Aviation Le Bourget', 48.9690, 2.4408, 'Zone d''Aviation d''Affaires, Aéroport du Bourget'),
      ('Advanced Air Support', 48.9687, 2.4405, 'Hangar H1, Aéroport de Paris-Le Bourget'),
      ('Jetex Paris FBO', 48.9684, 2.4402, 'Zone Aviation d''Affaires, Paris-Le Bourget'),
      ('Dassault Falcon Service', 48.9681, 2.4399, '21 Avenue de l''Europe, 93350 Le Bourget'),
      ('Sky Valet Le Bourget', 48.9678, 2.4396, 'Zone d''Aviation Générale, Aéroport de Paris-Le Bourget')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'LFPB'
  ) i
  ON CONFLICT DO NOTHING;
END $$;