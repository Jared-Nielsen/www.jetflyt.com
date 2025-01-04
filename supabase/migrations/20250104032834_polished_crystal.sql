/*
  # Move dispatch tables to public schema
  
  1. Changes
    - Move all tables from dispatch schema to public schema
    - Update foreign key references
    - Update RLS policies
    - Update trigger functions
  
  2. Tables Moved
    - transit_types
    - trips
    - routes
    - legs
*/

-- Drop existing tables if they exist (in correct order to handle dependencies)
DROP TABLE IF EXISTS dispatch.legs CASCADE;
DROP TABLE IF EXISTS dispatch.routes CASCADE;
DROP TABLE IF EXISTS dispatch.trips CASCADE;
DROP TABLE IF EXISTS dispatch.transit_types CASCADE;

-- Drop the dispatch schema
DROP SCHEMA IF EXISTS dispatch CASCADE;

-- Transit types lookup table
CREATE TABLE transit_types (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  description text,
  created_at timestamptz DEFAULT now()
);

-- Insert transit types
INSERT INTO transit_types (name, description) VALUES
  ('private_jet', 'Private jet transportation'),
  ('commercial_air', 'Commercial airline flights'),
  ('limousine', 'Luxury ground transportation'),
  ('car', 'Personal or rental car transportation'),
  ('walking', 'Walking segments'),
  ('boat', 'Water-based transportation'),
  ('bus', 'Bus transportation'),
  ('train', 'Rail transportation'),
  ('space', 'Space vehicle transportation'),
  ('other', 'Other forms of transportation');

-- Trips table
CREATE TABLE trips (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_id uuid DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  name text NOT NULL,
  description text,
  start_date timestamptz NOT NULL,
  end_date timestamptz,
  status text DEFAULT 'planned',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Routes table
CREATE TABLE routes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_id uuid DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  trip_id uuid REFERENCES trips(id) ON DELETE CASCADE,
  transit_type_id uuid REFERENCES transit_types(id),
  name text NOT NULL,
  description text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(trip_id, transit_type_id, name)
);

-- Legs table
CREATE TABLE legs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_id uuid DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  route_id uuid REFERENCES routes(id) ON DELETE CASCADE,
  origin_id uuid REFERENCES icaos(id) NOT NULL,
  destination_id uuid REFERENCES icaos(id) NOT NULL,
  scheduled_departure timestamptz NOT NULL,
  scheduled_arrival timestamptz NOT NULL,
  actual_departure timestamptz,
  actual_arrival timestamptz,
  status text DEFAULT 'scheduled',
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  CHECK (scheduled_arrival > scheduled_departure),
  CHECK (actual_arrival IS NULL OR actual_departure IS NULL OR actual_arrival > actual_departure)
);

-- Enable RLS on all tables
ALTER TABLE transit_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE trips ENABLE ROW LEVEL SECURITY;
ALTER TABLE routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE legs ENABLE ROW LEVEL SECURITY;

-- Transit types policies
CREATE POLICY "Transit types are readable by all authenticated users"
  ON transit_types
  FOR SELECT
  TO authenticated
  USING (true);

-- Trips policies
CREATE POLICY "Users can manage their own trips"
  ON trips
  FOR ALL
  TO authenticated
  USING (auth_id = auth.uid());

-- Routes policies
CREATE POLICY "Users can manage their own routes"
  ON routes
  FOR ALL
  TO authenticated
  USING (auth_id = auth.uid());

-- Legs policies
CREATE POLICY "Users can manage their own legs"
  ON legs
  FOR ALL
  TO authenticated
  USING (auth_id = auth.uid());

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Add update triggers
CREATE TRIGGER update_trips_updated_at
  BEFORE UPDATE ON trips
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_routes_updated_at
  BEFORE UPDATE ON routes
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_legs_updated_at
  BEFORE UPDATE ON legs
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Add indexes for better query performance
CREATE INDEX idx_trips_auth_id ON trips(auth_id);
CREATE INDEX idx_routes_trip_id ON routes(trip_id);
CREATE INDEX idx_routes_transit_type_id ON routes(transit_type_id);
CREATE INDEX idx_legs_route_id ON legs(route_id);
CREATE INDEX idx_legs_origin_id ON legs(origin_id);
CREATE INDEX idx_legs_destination_id ON legs(destination_id);