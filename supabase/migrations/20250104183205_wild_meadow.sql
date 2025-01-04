-- Create ICAO types table
CREATE TABLE icao_types (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  description text,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE icao_types ENABLE ROW LEVEL SECURITY;

-- Add read policy for authenticated users
CREATE POLICY "Anyone can read ICAO types"
  ON icao_types
  FOR SELECT
  TO authenticated
  USING (true);

-- Add icao_type_id to icaos table
ALTER TABLE icaos 
ADD COLUMN icao_type_id uuid REFERENCES icao_types(id);

-- Insert ICAO types
INSERT INTO icao_types (name, description) VALUES
  ('major_international', 'Major international airports serving multiple international carriers'),
  ('international', 'International airports with regular international service'),
  ('regional', 'Regional airports serving domestic routes and limited international'),
  ('military', 'Military air bases and joint use facilities'),
  ('general_aviation', 'General aviation and private airports'),
  ('cargo', 'Primary cargo handling facilities'),
  ('reliever', 'Reliever airports for major metropolitan areas');

-- Update existing ICAOs with their types
DO $$ 
DECLARE
  major_international_id uuid;
  international_id uuid;
  regional_id uuid;
  military_id uuid;
  general_aviation_id uuid;
  cargo_id uuid;
  reliever_id uuid;
BEGIN
  -- Get type IDs
  SELECT id INTO major_international_id FROM icao_types WHERE name = 'major_international';
  SELECT id INTO international_id FROM icao_types WHERE name = 'international';
  SELECT id INTO regional_id FROM icao_types WHERE name = 'regional';
  SELECT id INTO military_id FROM icao_types WHERE name = 'military';
  SELECT id INTO general_aviation_id FROM icao_types WHERE name = 'general_aviation';
  SELECT id INTO cargo_id FROM icao_types WHERE name = 'cargo';
  SELECT id INTO reliever_id FROM icao_types WHERE name = 'reliever';

  -- Major International Airports
  UPDATE icaos SET icao_type_id = major_international_id
  WHERE code IN (
    'KJFK', 'KLAX', 'KORD', 'KSFO', 'KDFW', 'KIAH', 'KATL', 'KMIA',
    'KDEN', 'KSEA', 'KLAS', 'KPHX', 'EGLL', 'LFPG', 'EDDF', 'EHAM',
    'VHHH', 'WSSS', 'ZBAA', 'RJTT', 'YSSY'
  );

  -- International Airports
  UPDATE icaos SET icao_type_id = international_id
  WHERE code IN (
    'KBOS', 'KPHL', 'KMCO', 'KSLC', 'KPDX', 'KBNA', 'KCLT',
    'KAUS', 'KSAN', 'KMSP', 'KDTW', 'KCVG', 'KMKE', 'KPIT'
  );

  -- Regional Airports
  UPDATE icaos SET icao_type_id = regional_id
  WHERE code IN (
    'KABQ', 'KICT', 'KMCI', 'KOMA', 'KDSM', 'KFAR', 'KBIS',
    'KGEG', 'KBOI', 'KGRR', 'KDAY', 'KLEX', 'KGSO', 'KROC'
  );

  -- Military Airports
  UPDATE icaos SET icao_type_id = military_id
  WHERE code IN (
    'KWRI', 'KOFF', 'KLFI', 'KDOV', 'KMCF', 'KSKF', 'KLRF',
    'KBAD', 'KCHS', 'KNGU', 'KNZY', 'KNPA', 'KVPS'
  );

  -- General Aviation
  UPDATE icaos SET icao_type_id = general_aviation_id
  WHERE code IN (
    'KAPA', 'KSDL', 'KTEB', 'KPDK', 'KVNY', 'KFRG', 'KHPN',
    'KBCT', 'KFXE', 'KISM', 'KMMU', 'KBFI'
  );

  -- Cargo Hubs
  UPDATE icaos SET icao_type_id = cargo_id
  WHERE code IN (
    'KSDF', 'KMEM', 'PANC', 'KTOL', 'KHSV', 'KONT', 'KGYR'
  );

  -- Reliever Airports
  UPDATE icaos SET icao_type_id = reliever_id
  WHERE code IN (
    'KFUL', 'KHWD', 'KPAO', 'KCCR', 'KRHV', 'KLVK', 'KDPA',
    'KPWK', 'KFTW', 'KADS', 'KMKC', 'KFCM'
  );

  -- Set remaining airports to regional by default
  UPDATE icaos SET icao_type_id = regional_id
  WHERE icao_type_id IS NULL;
END $$;