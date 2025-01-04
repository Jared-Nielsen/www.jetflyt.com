/*
  # Add Texas FBOs

  1. Schema Updates
    - Add `icao` and `state` columns to `fbos` table
    
  2. Data
    - Insert major Texas FBOs with accurate location data
*/

-- Add new columns
ALTER TABLE fbos 
ADD COLUMN IF NOT EXISTS icao text,
ADD COLUMN IF NOT EXISTS state text;

-- Insert Texas FBOs
INSERT INTO fbos (name, icao, latitude, longitude, address, country, state) 
VALUES 
  ('Million Air Dallas', 'KADS', 32.9686, -96.8362, '4300 Westgrove Dr, Addison, TX 75001', 'USA', 'TX'),
  ('Signature Flight Support Austin', 'KAUS', 30.1945, -97.6699, '4321 Emma Browning Ave, Austin, TX 78719', 'USA', 'TX'),
  ('Atlantic Aviation Dallas', 'KDAL', 32.8481, -96.8512, '7515 Lemmon Ave, Dallas, TX 75209', 'USA', 'TX'),
  ('Signature Flight Support Houston', 'KHOU', 29.6459, -95.2789, '8402 Nelms St, Houston, TX 77061', 'USA', 'TX'),
  ('Million Air San Antonio', 'KSAT', 29.5339, -98.4690, '1215 N. Frank Luke Dr, San Antonio, TX 78226', 'USA', 'TX'),
  ('Signature Flight Support Fort Worth', 'KFTW', 32.8198, -97.3622, '201 American Concourse, Fort Worth, TX 76106', 'USA', 'TX'),
  ('Atlantic Aviation El Paso', 'KELP', 31.8069, -106.3778, '1850 Hawkins Blvd, El Paso, TX 79925', 'USA', 'TX'),
  ('Signature Flight Support Midland', 'KMAF', 31.9425, -102.2019, '10401 Earhart Dr, Midland, TX 79711', 'USA', 'TX'),
  ('Henriksen Jet Center Houston', 'KTME', 29.8053, -95.8935, '20803 Stuebner Airline Rd, Spring, TX 77379', 'USA', 'TX'),
  ('Galaxy FBO Conroe', 'KCXO', 30.3518, -95.4144, '2971 Hawthorne Dr, Conroe, TX 77303', 'USA', 'TX');