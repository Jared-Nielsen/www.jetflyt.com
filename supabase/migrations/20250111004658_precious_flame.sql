-- Create work order offers table
CREATE TABLE IF NOT EXISTS work_order_offers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  work_order_id uuid REFERENCES work_orders(id) ON DELETE CASCADE,
  fbo_id uuid REFERENCES fbos(id) ON DELETE CASCADE,
  price numeric NOT NULL DEFAULT 0 CHECK (price >= 0),
  status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected', 'cancelled')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(work_order_id, fbo_id)
);

-- Enable RLS
ALTER TABLE work_order_offers ENABLE ROW LEVEL SECURITY;

-- Add RLS policy for reading work order offers
CREATE POLICY "Anyone can read work order offers"
  ON work_order_offers
  FOR SELECT
  TO authenticated
  USING (true);

-- Add RLS policy for managing work order offers
CREATE POLICY "Users can manage their work order offers"
  ON work_order_offers
  FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM work_orders wo
      WHERE wo.id = work_order_offers.work_order_id
      AND wo.auth_id = auth.uid()
    )
  );

-- Create indexes
CREATE INDEX idx_work_order_offers_work_order_id ON work_order_offers(work_order_id);
CREATE INDEX idx_work_order_offers_fbo_id ON work_order_offers(fbo_id);
CREATE INDEX idx_work_order_offers_status ON work_order_offers(status);

-- Add updated_at trigger
CREATE TRIGGER update_work_order_offers_updated_at
  BEFORE UPDATE ON work_order_offers
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Create function to handle work order offer creation
CREATE OR REPLACE FUNCTION handle_work_order_offer_creation()
RETURNS TRIGGER AS $$
BEGIN
  -- Create a work order offer for the FBO
  INSERT INTO work_order_offers (work_order_id, fbo_id)
  VALUES (NEW.work_order_id, NEW.fbo_id)
  ON CONFLICT (work_order_id, fbo_id) DO NOTHING;
  
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to create work order offers when FBOs are added
CREATE TRIGGER create_work_order_offer_on_fbo_insert
  AFTER INSERT ON work_order_fbos
  FOR EACH ROW
  EXECUTE FUNCTION handle_work_order_offer_creation();