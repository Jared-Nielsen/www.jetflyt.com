/*
  # Add Aircraft Management

  1. New Tables
    - `aircraft`
      - `id` (uuid, primary key)
      - `user_id` (uuid, references auth.users)
      - `tail_number` (text, unique)
      - `type` (text)
      - `manufacturer` (text)
      - `model` (text)
      - `year` (integer)
      - `max_range` (numeric) - in nautical miles
      - `fuel_type` (text)
      - `fuel_capacity` (numeric) - in gallons
      - `engine_type` (text)
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)

  2. Security
    - Enable RLS on aircraft table
    - Add policies for authenticated users to manage their aircraft
*/

CREATE TABLE aircraft (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  tail_number text UNIQUE NOT NULL,
  type text NOT NULL,
  manufacturer text NOT NULL,
  model text NOT NULL,
  year integer NOT NULL,
  max_range numeric NOT NULL,
  fuel_type text NOT NULL,
  fuel_capacity numeric NOT NULL,
  engine_type text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE aircraft ENABLE ROW LEVEL SECURITY;

-- Policy to allow users to manage their own aircraft
CREATE POLICY "Users can manage their own aircraft"
  ON aircraft
  FOR ALL
  TO authenticated
  USING (user_id = auth.uid());

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update updated_at
CREATE TRIGGER update_aircraft_updated_at
  BEFORE UPDATE ON aircraft
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();