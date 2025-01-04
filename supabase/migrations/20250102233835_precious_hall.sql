/*
  # Aviation Fuel Tender System Schema

  1. New Tables
    - `companies` - Stores fuel company information
      - `id` (uuid, primary key)
      - `name` (text)
      - `contact_email` (text)
      - `created_at` (timestamp)
    
    - `fleet` - Aircraft fleet registration
      - `id` (uuid, primary key)
      - `company_id` (uuid, foreign key)
      - `aircraft_type` (text)
      - `registration` (text)
      - `fuel_capacity` (numeric)
      - `created_at` (timestamp)
    
    - `tender_offers` - Stores tender submissions
      - `id` (uuid, primary key)
      - `company_id` (uuid, foreign key)
      - `fuel_type` (text)
      - `volume_per_year` (numeric)
      - `price_per_gallon` (numeric)
      - `start_date` (date)
      - `end_date` (date)
      - `status` (text)
      - `created_at` (timestamp)
    
    - `fbos` - Fixed Base Operators locations
      - `id` (uuid, primary key)
      - `name` (text)
      - `latitude` (numeric)
      - `longitude` (numeric)
      - `address` (text)
      - `country` (text)
      - `created_at` (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users
*/

-- Companies table
CREATE TABLE companies (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  contact_email text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE companies ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own company data"
  ON companies
  FOR SELECT
  TO authenticated
  USING (auth.uid()::text = id::text);

-- Fleet table
CREATE TABLE fleet (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid REFERENCES companies(id),
  aircraft_type text NOT NULL,
  registration text NOT NULL,
  fuel_capacity numeric NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE fleet ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Companies can manage their fleet"
  ON fleet
  FOR ALL
  TO authenticated
  USING (company_id = auth.uid()::uuid);

-- Tender offers table
CREATE TABLE tender_offers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid REFERENCES companies(id),
  fuel_type text NOT NULL,
  volume_per_year numeric NOT NULL,
  price_per_gallon numeric NOT NULL,
  start_date date NOT NULL,
  end_date date NOT NULL,
  status text DEFAULT 'pending',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE tender_offers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Companies can manage their tender offers"
  ON tender_offers
  FOR ALL
  TO authenticated
  USING (company_id = auth.uid()::uuid);

-- FBOs table
CREATE TABLE fbos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  latitude numeric NOT NULL,
  longitude numeric NOT NULL,
  address text NOT NULL,
  country text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE fbos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read FBO data"
  ON fbos
  FOR SELECT
  TO authenticated
  USING (true);