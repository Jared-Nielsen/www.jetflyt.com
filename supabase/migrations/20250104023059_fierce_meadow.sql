/*
  # Add worldwide ICAO codes

  1. Changes
    - Make state column optional for international airports
    - Add country and continent columns
    - Add worldwide ICAO codes while preserving existing Texas entries
    - Create index for faster lookups

  2. Security
    - Maintain existing RLS policies
*/

-- Make state column optional
ALTER TABLE icaos
ALTER COLUMN state DROP NOT NULL;

-- Add new columns if they don't exist
ALTER TABLE icaos
ADD COLUMN IF NOT EXISTS country text,
ADD COLUMN IF NOT EXISTS continent text;

-- Update existing Texas entries
UPDATE icaos
SET country = 'United States',
    continent = 'North America'
WHERE state = 'TX';

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_icaos_code ON icaos (code);

-- Insert worldwide ICAO codes
DO $$ 
BEGIN
  -- North America (excluding existing Texas airports)
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  SELECT code, name, state, country, continent, latitude, longitude
  FROM (VALUES
    ('KJFK', 'John F. Kennedy International Airport', 'NY', 'United States', 'North America', 40.6413, -73.7781),
    ('KLAX', 'Los Angeles International Airport', 'CA', 'United States', 'North America', 33.9416, -118.4085),
    ('CYYZ', 'Toronto Pearson International Airport', 'ON', 'Canada', 'North America', 43.6777, -79.6248),
    ('MMMX', 'Benito Juárez International Airport', 'CDMX', 'Mexico', 'North America', 19.4363, -99.0721)
  ) AS north_america(code, name, state, country, continent, latitude, longitude)
  WHERE NOT EXISTS (
    SELECT 1 FROM icaos WHERE icaos.code = north_america.code
  );

  -- Europe
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  SELECT code, name, state, country, continent, latitude, longitude
  FROM (VALUES
    ('EGLL', 'London Heathrow Airport', NULL, 'United Kingdom', 'Europe', 51.4700, -0.4543),
    ('LFPG', 'Charles de Gaulle Airport', NULL, 'France', 'Europe', 49.0097, 2.5478),
    ('EDDF', 'Frankfurt Airport', NULL, 'Germany', 'Europe', 50.0379, 8.5622),
    ('EHAM', 'Amsterdam Airport Schiphol', NULL, 'Netherlands', 'Europe', 52.3086, 4.7639)
  ) AS europe(code, name, state, country, continent, latitude, longitude)
  WHERE NOT EXISTS (
    SELECT 1 FROM icaos WHERE icaos.code = europe.code
  );

  -- Asia
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  SELECT code, name, state, country, continent, latitude, longitude
  FROM (VALUES
    ('RJTT', 'Tokyo Haneda Airport', NULL, 'Japan', 'Asia', 35.5494, 139.7798),
    ('ZBAA', 'Beijing Capital International Airport', NULL, 'China', 'Asia', 40.0799, 116.6031),
    ('VHHH', 'Hong Kong International Airport', NULL, 'Hong Kong', 'Asia', 22.3080, 113.9185),
    ('WSSS', 'Singapore Changi Airport', NULL, 'Singapore', 'Asia', 1.3644, 103.9915)
  ) AS asia(code, name, state, country, continent, latitude, longitude)
  WHERE NOT EXISTS (
    SELECT 1 FROM icaos WHERE icaos.code = asia.code
  );

  -- Oceania
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  SELECT code, name, state, country, continent, latitude, longitude
  FROM (VALUES
    ('YSSY', 'Sydney Kingsford Smith Airport', 'NSW', 'Australia', 'Oceania', -33.9399, 151.1753),
    ('YMML', 'Melbourne Airport', 'VIC', 'Australia', 'Oceania', -37.6690, 144.8410),
    ('NZAA', 'Auckland Airport', NULL, 'New Zealand', 'Oceania', -37.0082, 174.7850),
    ('NZCH', 'Christchurch International Airport', NULL, 'New Zealand', 'Oceania', -43.4894, 172.5324)
  ) AS oceania(code, name, state, country, continent, latitude, longitude)
  WHERE NOT EXISTS (
    SELECT 1 FROM icaos WHERE icaos.code = oceania.code
  );

  -- South America
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  SELECT code, name, state, country, continent, latitude, longitude
  FROM (VALUES
    ('SBGR', 'São Paulo/Guarulhos International Airport', 'SP', 'Brazil', 'South America', -23.4356, -46.4731),
    ('SCEL', 'Arturo Merino Benítez International Airport', NULL, 'Chile', 'South America', -33.3930, -70.7858),
    ('SAEZ', 'Ministro Pistarini International Airport', NULL, 'Argentina', 'South America', -34.8222, -58.5358),
    ('SKBO', 'El Dorado International Airport', NULL, 'Colombia', 'South America', 4.7016, -74.1469)
  ) AS south_america(code, name, state, country, continent, latitude, longitude)
  WHERE NOT EXISTS (
    SELECT 1 FROM icaos WHERE icaos.code = south_america.code
  );

  -- Africa
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  SELECT code, name, state, country, continent, latitude, longitude
  FROM (VALUES
    ('FACT', 'Cape Town International Airport', NULL, 'South Africa', 'Africa', -33.9715, 18.6021),
    ('HKJK', 'Jomo Kenyatta International Airport', NULL, 'Kenya', 'Africa', -1.3192, 36.9278),
    ('DNMM', 'Murtala Muhammed International Airport', NULL, 'Nigeria', 'Africa', 6.5774, 3.3215),
    ('HECA', 'Cairo International Airport', NULL, 'Egypt', 'Africa', 30.1219, 31.4056)
  ) AS africa(code, name, state, country, continent, latitude, longitude)
  WHERE NOT EXISTS (
    SELECT 1 FROM icaos WHERE icaos.code = africa.code
  );

END $$;