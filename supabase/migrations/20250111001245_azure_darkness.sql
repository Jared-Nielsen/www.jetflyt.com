-- Create service offers table
CREATE TABLE service_offers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  fbo_id uuid REFERENCES fbos(id) ON DELETE CASCADE,
  service_id uuid REFERENCES services(id) ON DELETE CASCADE,
  price numeric NOT NULL DEFAULT 0 CHECK (price >= 0),
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'inactive')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(fbo_id, service_id)
);

-- Enable RLS
ALTER TABLE service_offers ENABLE ROW LEVEL SECURITY;

-- Add RLS policy for reading service offers
CREATE POLICY "Anyone can read service offers"
  ON service_offers
  FOR SELECT
  TO authenticated
  USING (true);

-- Add RLS policy for FBOs to manage their own service offers
CREATE POLICY "FBOs can manage their own service offers"
  ON service_offers
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM fbos 
      WHERE fbos.id = service_offers.fbo_id 
      AND fbos.id IN (
        SELECT f.id FROM fbos f
        INNER JOIN users u ON u.id = auth.uid()
        WHERE f.user_id = u.id
      )
    )
  );

-- Create indexes
CREATE INDEX idx_service_offers_fbo_id ON service_offers(fbo_id);
CREATE INDEX idx_service_offers_service_id ON service_offers(service_id);
CREATE INDEX idx_service_offers_status ON service_offers(status);

-- Add updated_at trigger
CREATE TRIGGER update_service_offers_updated_at
  BEFORE UPDATE ON service_offers
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();