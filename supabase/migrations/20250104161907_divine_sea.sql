/*
  # Add Signature Flight Support FBO Locations Worldwide

  1. New Data
    - Add major Signature Flight Support FBO locations globally
    - Each location includes precise coordinates and full address
  
  2. Changes
    - Insert new ICAO codes for airports not yet in database
    - Insert new FBO records with corresponding ICAO references
*/

-- Insert Signature Flight Support FBO locations
DO $$ 
BEGIN
  -- First ensure all required ICAO codes exist
  INSERT INTO icaos (code, name, state, country, latitude, longitude)
  VALUES
    -- United States (Major Locations)
    ('KBOS', 'Boston Logan International Airport', 'MA', 'United States', 42.3656, -71.0096),
    ('KJFK', 'John F Kennedy International Airport', 'NY', 'United States', 40.6413, -73.7781),
    ('KLAX', 'Los Angeles International Airport', 'CA', 'United States', 33.9416, -118.4085),
    ('KORD', 'Chicago O''Hare International Airport', 'IL', 'United States', 41.9742, -87.9073),
    ('KSFO', 'San Francisco International Airport', 'CA', 'United States', 37.6213, -122.3790),
    ('KMIA', 'Miami International Airport', 'FL', 'United States', 25.7932, -80.2906),
    -- Europe
    ('EGLL', 'London Heathrow Airport', NULL, 'United Kingdom', 51.4700, -0.4543),
    ('LFPG', 'Paris Charles de Gaulle Airport', NULL, 'France', 49.0097, 2.5478),
    ('EHAM', 'Amsterdam Airport Schiphol', NULL, 'Netherlands', 52.3086, 4.7639),
    ('EDDF', 'Frankfurt Airport', NULL, 'Germany', 50.0379, 8.5622),
    -- Asia Pacific
    ('VHHH', 'Hong Kong International Airport', NULL, 'Hong Kong', 22.3080, 113.9185),
    ('WSSS', 'Singapore Changi Airport', NULL, 'Singapore', 1.3644, 103.9915)
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;

  -- Now add the FBO locations
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country, state)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    fbo.country,
    fbo.state
  FROM (
    VALUES 
      -- United States
      ('Signature Flight Support BOS', 42.3656, -71.0096, '148 Harborside Dr, Boston, MA 02128', 'USA', 'MA'),
      ('Signature Flight Support JFK', 40.6413, -73.7781, 'Building 145, Jamaica, NY 11430', 'USA', 'NY'),
      ('Signature Flight Support LAX', 33.9416, -118.4085, '6201 W Imperial Hwy, Los Angeles, CA 90045', 'USA', 'CA'),
      ('Signature Flight Support ORD', 41.9742, -87.9073, '1000 Bessie Coleman Dr, Chicago, IL 60666', 'USA', 'IL'),
      ('Signature Flight Support SFO', 37.6213, -122.3790, '323 N Access Rd, San Francisco, CA 94128', 'USA', 'CA'),
      ('Signature Flight Support MIA', 25.7932, -80.2906, '5000 NW 36th St, Miami, FL 33122', 'USA', 'FL'),
      -- Europe
      ('Signature Flight Support LHR', 51.4700, -0.4543, 'Terminal 3, Heathrow Airport, UK', 'United Kingdom', NULL),
      ('Signature Flight Support CDG', 49.0097, 2.5478, 'Zone Aviation Générale, 95700 Roissy-en-France', 'France', NULL),
      ('Signature Flight Support AMS', 52.3086, 4.7639, 'Thermiekstraat 1, 1117 Schiphol', 'Netherlands', NULL),
      ('Signature Flight Support FRA', 50.0379, 8.5622, 'Gate 26, Frankfurt Airport', 'Germany', NULL),
      -- Asia Pacific
      ('Signature Flight Support HKG', 22.3080, 113.9185, '6 Cheong Hong Rd, Chek Lap Kok', 'Hong Kong', NULL),
      ('Signature Flight Support SIN', 1.3644, 103.9915, '60 Airport Boulevard, Changi Airport', 'Singapore', NULL)
  ) as fbo(name, latitude, longitude, address, country, state)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'KBOS', 'KJFK', 'KLAX', 'KORD', 'KSFO', 'KMIA',
      'EGLL', 'LFPG', 'EHAM', 'EDDF', 'VHHH', 'WSSS'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%BOS' THEN 'KBOS'
      WHEN fbo.name LIKE '%JFK' THEN 'KJFK'
      WHEN fbo.name LIKE '%LAX' THEN 'KLAX'
      WHEN fbo.name LIKE '%ORD' THEN 'KORD'
      WHEN fbo.name LIKE '%SFO' THEN 'KSFO'
      WHEN fbo.name LIKE '%MIA' THEN 'KMIA'
      WHEN fbo.name LIKE '%LHR' THEN 'EGLL'
      WHEN fbo.name LIKE '%CDG' THEN 'LFPG'
      WHEN fbo.name LIKE '%AMS' THEN 'EHAM'
      WHEN fbo.name LIKE '%FRA' THEN 'EDDF'
      WHEN fbo.name LIKE '%HKG' THEN 'VHHH'
      WHEN fbo.name LIKE '%SIN' THEN 'WSSS'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;