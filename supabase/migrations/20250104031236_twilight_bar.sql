/*
  # Create dispatch schema and trip-related tables

  1. New Schema
    - Creates a new 'dispatch' schema for trip-related tables

  2. New Tables
    - `dispatch.transit_types`: Lookup table for different types of transportation
    - `dispatch.trips`: Main trips table
    - `dispatch.routes`: Routes within trips for specific transit types
    - `dispatch.legs`: Individual journey segments

  3. Security
    - Enable RLS on all tables
    - Add policies for authenticated users
*/

-- Create dispatch schema
CREATE SCHEMA dispatch;

-- Transit types lookup table
CREATE TABLE dispatch.transit_types (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  description text,
  created_at timestamptz DEFAULT now()
);

-- Insert transit types
INSERT INTO dispatch.transit_types (name, description) VALUES
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
CREATE TABLE dispatch.trips (
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

-- Routes table (groups legs by transit type within a trip)
CREATE TABLE dispatch.routes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_id uuid DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  trip_id uuid REFERENCES dispatch.trips(id) ON DELETE CASCADE,
  transit_type_id uuid REFERENCES dispatch.transit_types(id),
  name text NOT NULL,
  description text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(trip_id, transit_type_id, name)
);

-- Legs table
CREATE TABLE dispatch.legs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_id uuid DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  route_id uuid REFERENCES dispatch.routes(id) ON DELETE CASCADE,
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
ALTER TABLE dispatch.transit_types ENABLE ROW LEVEL SECURITY;
ALTER TABLE dispatch.trips ENABLE ROW LEVEL SECURITY;
ALTER TABLE dispatch.routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE dispatch.legs ENABLE ROW LEVEL SECURITY;

-- Transit types policies
CREATE POLICY "Transit types are readable by all authenticated users"
  ON dispatch.transit_types
  FOR SELECT
  TO authenticated
  USING (true);

-- Trips policies
CREATE POLICY "Users can manage their own trips"
  ON dispatch.trips
  FOR ALL
  TO authenticated
  USING (auth_id = auth.uid());

-- Routes policies
CREATE POLICY "Users can manage their own routes"
  ON dispatch.routes
  FOR ALL
  TO authenticated
  USING (auth_id = auth.uid());

-- Legs policies
CREATE POLICY "Users can manage their own legs"
  ON dispatch.legs
  FOR ALL
  TO authenticated
  USING (auth_id = auth.uid());

-- Updated triggers
CREATE OR REPLACE FUNCTION dispatch.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Add update triggers
CREATE TRIGGER update_trips_updated_at
  BEFORE UPDATE ON dispatch.trips
  FOR EACH ROW
  EXECUTE FUNCTION dispatch.update_updated_at_column();

CREATE TRIGGER update_routes_updated_at
  BEFORE UPDATE ON dispatch.routes
  FOR EACH ROW
  EXECUTE FUNCTION dispatch.update_updated_at_column();

CREATE TRIGGER update_legs_updated_at
  BEFORE UPDATE ON dispatch.legs
  FOR EACH ROW
  EXECUTE FUNCTION dispatch.update_updated_at_column();

-- Add indexes for better query performance
CREATE INDEX idx_trips_auth_id ON dispatch.trips(auth_id);
CREATE INDEX idx_routes_trip_id ON dispatch.routes(trip_id);
CREATE INDEX idx_routes_transit_type_id ON dispatch.routes(transit_type_id);
CREATE INDEX idx_legs_route_id ON dispatch.legs(route_id);
CREATE INDEX idx_legs_origin_id ON dispatch.legs(origin_id);
CREATE INDEX idx_legs_destination_id ON dispatch.legs(destination_id);