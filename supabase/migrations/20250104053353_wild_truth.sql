/*
  # Fix tender system tables

  1. Changes
    - Add existence checks before creating tables
    - Safely create tables and policies
    - Add proper indexes for performance

  2. Tables
    - tenders: Stores tender offers
    - fbo_tenders: Links tenders to FBOs with pricing details

  3. Security
    - Enable RLS on all tables
    - Add policies for authenticated users
*/

-- Safely create tenders table if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'tenders') THEN
    CREATE TABLE tenders (
      id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
      auth_id uuid DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
      aircraft_id uuid REFERENCES aircraft(id),
      icao_id uuid REFERENCES icaos(id),
      gallons numeric NOT NULL CHECK (gallons > 0),
      target_price numeric NOT NULL CHECK (target_price > 0),
      description text,
      status text DEFAULT 'pending',
      created_at timestamptz DEFAULT now(),
      updated_at timestamptz DEFAULT now()
    );

    -- Enable RLS
    ALTER TABLE tenders ENABLE ROW LEVEL SECURITY;

    -- Create policy
    CREATE POLICY "Users can manage their own tenders"
      ON tenders
      FOR ALL
      TO authenticated
      USING (auth_id = auth.uid());

    -- Create indexes
    CREATE INDEX idx_tenders_auth_id ON tenders(auth_id);
    CREATE INDEX idx_tenders_aircraft_id ON tenders(aircraft_id);
    CREATE INDEX idx_tenders_icao_id ON tenders(icao_id);

    -- Create updated_at trigger
    CREATE TRIGGER update_tenders_updated_at
      BEFORE UPDATE ON tenders
      FOR EACH ROW
      EXECUTE FUNCTION update_updated_at_column();
  END IF;
END $$;

-- Safely create fbo_tenders table if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE tablename = 'fbo_tenders') THEN
    CREATE TABLE fbo_tenders (
      id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
      tender_id uuid REFERENCES tenders(id) ON DELETE CASCADE,
      fbo_id uuid REFERENCES fbos(id),
      offer_price numeric NOT NULL CHECK (offer_price > 0),
      total_cost numeric NOT NULL CHECK (total_cost > 0),
      taxes_and_fees numeric NOT NULL DEFAULT 0,
      description text,
      created_at timestamptz DEFAULT now(),
      updated_at timestamptz DEFAULT now()
    );

    -- Enable RLS
    ALTER TABLE fbo_tenders ENABLE ROW LEVEL SECURITY;

    -- Create policy
    CREATE POLICY "Users can manage their own FBO tenders"
      ON fbo_tenders
      FOR ALL
      TO authenticated
      USING (
        tender_id IN (
          SELECT id FROM tenders WHERE auth_id = auth.uid()
        )
      );

    -- Create indexes
    CREATE INDEX idx_fbo_tenders_tender_id ON fbo_tenders(tender_id);
    CREATE INDEX idx_fbo_tenders_fbo_id ON fbo_tenders(fbo_id);

    -- Create updated_at trigger
    CREATE TRIGGER update_fbo_tenders_updated_at
      BEFORE UPDATE ON fbo_tenders
      FOR EACH ROW
      EXECUTE FUNCTION update_updated_at_column();
  END IF;
END $$;