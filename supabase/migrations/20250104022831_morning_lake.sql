-- Create fuel types table
CREATE TABLE fuel_types (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  description text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE fuel_types ENABLE ROW LEVEL SECURITY;

-- Add read policy for authenticated users
CREATE POLICY "Anyone can read fuel types"
  ON fuel_types
  FOR SELECT
  TO authenticated
  USING (true);

-- Add fuel_type_id to aircraft table
ALTER TABLE aircraft 
  ADD COLUMN fuel_type_id uuid REFERENCES fuel_types(id),
  DROP COLUMN fuel_type;

-- Insert common aviation fuel types
INSERT INTO fuel_types (name, description) VALUES
  ('Jet A', 'Most common jet fuel type in the US and worldwide. Kerosene-based fuel with a freeze point of -40°C.'),
  ('Jet A-1', 'Similar to Jet A but with a lower freeze point of -47°C. Standard in most of the world outside the US.'),
  ('Jet B', 'Wide-cut fuel blend of kerosene and gasoline. Used in extremely cold climates.'),
  ('JP-8', 'Military variant of Jet A-1 with additional additives for improved performance and safety.'),
  ('Sustainable Aviation Fuel (SAF)', 'Renewable fuel made from sustainable feedstocks, offering reduced carbon emissions.'),
  ('Bio-Jet A', 'Blend of conventional Jet A with sustainable aviation fuel components.');