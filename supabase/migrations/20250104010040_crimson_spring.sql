/*
  # Create ICAO codes table and update FBO structure
  
  1. New Tables
    - `icaos`
      - `id` (uuid, primary key)
      - `code` (text, unique) - The ICAO code
      - `name` (text) - Airport/facility name
      - `state` (text) - State code
      - `created_at` (timestamp)
  
  2. Changes
    - Add foreign key relationship from fbos to icaos
    - Migrate existing ICAO data
  
  3. Security
    - Enable RLS on icaos table
    - Add policy for authenticated users to read ICAO data
*/

-- Create ICAO codes table
CREATE TABLE IF NOT EXISTS icaos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code text UNIQUE NOT NULL,
  name text NOT NULL,
  state text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE icaos ENABLE ROW LEVEL SECURITY;

-- Add read policy for authenticated users
CREATE POLICY "Anyone can read ICAO data"
  ON icaos
  FOR SELECT
  TO authenticated
  USING (true);

-- Insert Texas ICAO codes
INSERT INTO icaos (code, name, state) VALUES
  ('KADS', 'Addison Airport', 'TX'),
  ('KAUS', 'Austin-Bergstrom International Airport', 'TX'),
  ('KDAL', 'Dallas Love Field', 'TX'),
  ('KHOU', 'William P. Hobby Airport', 'TX'),
  ('KSAT', 'San Antonio International Airport', 'TX'),
  ('KFTW', 'Fort Worth Meacham International Airport', 'TX'),
  ('KELP', 'El Paso International Airport', 'TX'),
  ('KMAF', 'Midland International Air and Space Port', 'TX'),
  ('KTME', 'Houston Executive Airport', 'TX'),
  ('KCXO', 'Conroe-North Houston Regional Airport', 'TX'),
  ('KDFW', 'Dallas/Fort Worth International Airport', 'TX'),
  ('KIAH', 'George Bush Intercontinental Airport', 'TX'),
  ('KLBB', 'Lubbock Preston Smith International Airport', 'TX'),
  ('KAMA', 'Rick Husband Amarillo International Airport', 'TX'),
  ('KGRK', 'Killeen-Fort Hood Regional Airport', 'TX'),
  ('KCRP', 'Corpus Christi International Airport', 'TX'),
  ('KBPT', 'Jack Brooks Regional Airport', 'TX'),
  ('KABI', 'Abilene Regional Airport', 'TX'),
  ('KACT', 'Waco Regional Airport', 'TX'),
  ('KGGG', 'East Texas Regional Airport', 'TX');

-- Add icao_id to fbos table
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'fbos' AND column_name = 'icao_id'
  ) THEN
    ALTER TABLE fbos ADD COLUMN icao_id uuid REFERENCES icaos(id);
  END IF;
END $$;