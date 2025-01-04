/*
  # Add aircraft types and update aircraft schema
  
  1. New Tables
    - `aircraft_types`
      - `id` (uuid, primary key)
      - `name` (text, unique)
      - `manufacturer` (text)
      - `category` (text)
      - `created_at` (timestamptz)

  2. Changes
    - Add `type_id` to `aircraft` table
    - Remove `type` column from `aircraft` table
    - Add foreign key constraint

  3. Security
    - Enable RLS on `aircraft_types` table
    - Add policy for authenticated users to read aircraft types
*/

-- Create aircraft types table
CREATE TABLE aircraft_types (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  manufacturer text NOT NULL,
  category text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE aircraft_types ENABLE ROW LEVEL SECURITY;

-- Add read policy for authenticated users
CREATE POLICY "Anyone can read aircraft types"
  ON aircraft_types
  FOR SELECT
  TO authenticated
  USING (true);

-- Add type_id to aircraft table
ALTER TABLE aircraft 
  ADD COLUMN type_id uuid REFERENCES aircraft_types(id),
  DROP COLUMN type;

-- Insert popular private jet types
INSERT INTO aircraft_types (name, manufacturer, category) VALUES
  -- Light Jets
  ('Citation CJ4', 'Cessna', 'Light Jet'),
  ('Phenom 300', 'Embraer', 'Light Jet'),
  ('Learjet 75', 'Bombardier', 'Light Jet'),
  ('HondaJet Elite', 'Honda', 'Light Jet'),
  
  -- Midsize Jets
  ('Citation Latitude', 'Cessna', 'Midsize Jet'),
  ('Challenger 350', 'Bombardier', 'Midsize Jet'),
  ('Praetor 500', 'Embraer', 'Midsize Jet'),
  ('Legacy 450', 'Embraer', 'Midsize Jet'),
  
  -- Super Midsize Jets
  ('Citation Longitude', 'Cessna', 'Super Midsize Jet'),
  ('Challenger 650', 'Bombardier', 'Super Midsize Jet'),
  ('Praetor 600', 'Embraer', 'Super Midsize Jet'),
  ('G280', 'Gulfstream', 'Super Midsize Jet'),
  
  -- Large Jets
  ('Global 7500', 'Bombardier', 'Large Jet'),
  ('G650ER', 'Gulfstream', 'Large Jet'),
  ('Falcon 8X', 'Dassault', 'Large Jet'),
  ('Global 6000', 'Bombardier', 'Large Jet'),
  
  -- Regional Jets
  ('CRJ-200', 'Bombardier', 'Regional Jet'),
  ('ERJ-145', 'Embraer', 'Regional Jet'),
  ('E175', 'Embraer', 'Regional Jet'),
  ('CRJ-700', 'Bombardier', 'Regional Jet');