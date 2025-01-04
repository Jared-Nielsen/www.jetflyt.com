/*
  # Add Aircraft Engine Types

  1. New Tables
    - `aircraft_engine_types`
      - `id` (uuid, primary key)
      - `name` (text, unique)
      - `description` (text)
      - `created_at` (timestamp)

  2. Changes
    - Add `engine_type_id` to `aircraft` table
    - Remove `engine_type` from `aircraft` table
    - Add foreign key constraint

  3. Security
    - Enable RLS on `aircraft_engine_types`
    - Add read policy for authenticated users
*/

-- Create aircraft engine types table
CREATE TABLE aircraft_engine_types (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  description text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE aircraft_engine_types ENABLE ROW LEVEL SECURITY;

-- Add read policy for authenticated users
CREATE POLICY "Anyone can read aircraft engine types"
  ON aircraft_engine_types
  FOR SELECT
  TO authenticated
  USING (true);

-- Add engine_type_id to aircraft table
ALTER TABLE aircraft 
  ADD COLUMN engine_type_id uuid REFERENCES aircraft_engine_types(id);

-- Insert engine types
INSERT INTO aircraft_engine_types (name, description) VALUES
  ('Turbofan', 'High-bypass ratio engine commonly used in modern commercial and business jets. Offers excellent fuel efficiency and reduced noise.'),
  ('Low-Bypass Turbofan', 'Lower bypass ratio engine used in high-performance military and some business jets. Provides good balance of speed and efficiency.'),
  ('Turbojet', 'Simple jet engine design used in early jet aircraft. Still used in some military applications.'),
  ('Turboprop', 'Gas turbine engine driving a propeller. Common in regional and utility aircraft, offering good efficiency at lower altitudes.'),
  ('Geared Turbofan', 'Advanced turbofan design with a gearbox to optimize fan speed. Provides improved fuel efficiency and noise reduction.'),
  ('High-Bypass Turbofan', 'Very high bypass ratio engine used in large commercial aircraft. Maximizes fuel efficiency for long-range operations.');

-- Safely remove old engine_type column
DO $$ 
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'aircraft' AND column_name = 'engine_type'
  ) THEN
    ALTER TABLE aircraft DROP COLUMN engine_type;
  END IF;
END $$;