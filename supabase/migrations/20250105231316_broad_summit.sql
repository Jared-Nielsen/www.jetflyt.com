-- Create tenders table
CREATE TABLE tenders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_id uuid DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  aircraft_id uuid REFERENCES aircraft(id),
  icao_id uuid REFERENCES icaos(id),
  gallons numeric NOT NULL CHECK (gallons > 0),
  target_price numeric NOT NULL CHECK (target_price > 0),
  description text,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected', 'cancelled')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create fbo_tenders table
CREATE TABLE fbo_tenders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tender_id uuid REFERENCES tenders(id) ON DELETE CASCADE,
  fbo_id uuid REFERENCES fbos(id),
  offer_price numeric NOT NULL CHECK (offer_price > 0),
  total_cost numeric NOT NULL CHECK (total_cost > 0),
  taxes_and_fees numeric NOT NULL DEFAULT 0,
  counter_price numeric DEFAULT 0,
  counter_total_cost numeric DEFAULT 0,
  counter_taxes_and_fees numeric DEFAULT 0,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected', 'cancelled')),
  description text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE tenders ENABLE ROW LEVEL SECURITY;
ALTER TABLE fbo_tenders ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can manage their own tenders"
  ON tenders
  FOR ALL
  TO authenticated
  USING (auth_id = auth.uid());

CREATE POLICY "Users can manage their own FBO tenders"
  ON fbo_tenders
  FOR ALL
  TO authenticated
  USING (
    tender_id IN (
      SELECT id FROM tenders WHERE auth_id = auth.uid()
    )
  );

-- Create updated_at triggers
CREATE TRIGGER update_tenders_updated_at
  BEFORE UPDATE ON tenders
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_fbo_tenders_updated_at
  BEFORE UPDATE ON fbo_tenders
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Create indexes
CREATE INDEX idx_tenders_auth_id ON tenders(auth_id);
CREATE INDEX idx_tenders_aircraft_id ON tenders(aircraft_id);
CREATE INDEX idx_tenders_icao_id ON tenders(icao_id);
CREATE INDEX idx_fbo_tenders_tender_id ON fbo_tenders(tender_id);
CREATE INDEX idx_fbo_tenders_fbo_id ON fbo_tenders(fbo_id);