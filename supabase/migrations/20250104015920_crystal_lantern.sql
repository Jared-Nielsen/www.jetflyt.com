/*
  # Add KIAH FBOs

  1. Changes
    - Add FBOs for George Bush Intercontinental Airport (KIAH)
    - Link FBOs to KIAH ICAO code
*/

-- Get KIAH ICAO ID
DO $$ 
BEGIN
  -- Add FBOs for KIAH
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
      ('Signature Flight Support IAH North', 29.9902, -95.3368, '19150 Lee Road, Humble, TX 77338'),
      ('Signature Flight Support IAH South', 29.9850, -95.3390, '19000 Airport Blvd, Houston, TX 77338'),
      ('Atlantic Aviation IAH', 29.9889, -95.3411, '19421 Lee Road, Humble, TX 77338'),
      ('Million Air Houston', 29.9933, -95.3356, '19301 McKay Dr, Humble, TX 77338')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id FROM icaos WHERE code = 'KIAH'
  ) i
  ON CONFLICT DO NOTHING;
END $$;