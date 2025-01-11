-- Drop any existing triggers and functions
DROP TRIGGER IF EXISTS create_work_order_offer_on_fbo_insert ON work_order_fbos CASCADE;
DROP FUNCTION IF EXISTS handle_work_order_offer_creation() CASCADE;

-- Drop work_order_offers table if it exists
DROP TABLE IF EXISTS work_order_offers CASCADE;

-- Add missing columns to work_order_fbos if they don't exist
DO $$ 
BEGIN
  -- Add price column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'work_order_fbos' AND column_name = 'price'
  ) THEN
    ALTER TABLE work_order_fbos ADD COLUMN price numeric DEFAULT 0 CHECK (price >= 0);
  END IF;

  -- Add status column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'work_order_fbos' AND column_name = 'status'
  ) THEN
    ALTER TABLE work_order_fbos ADD COLUMN status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'offered', 'accepted', ''));
  END IF;

  -- Add updated_at column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'work_order_fbos' AND column_name = 'updated_at'
  ) THEN
    ALTER TABLE work_order_fbos ADD COLUMN updated_at timestamptz DEFAULT now();
  END IF;
END $$;

-- Create or replace updated_at trigger
CREATE OR REPLACE FUNCTION update_work_order_fbos_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Add trigger for updated_at
DROP TRIGGER IF EXISTS update_work_order_fbos_updated_at ON work_order_fbos;
CREATE TRIGGER update_work_order_fbos_updated_at
  BEFORE UPDATE ON work_order_fbos
  FOR EACH ROW
  EXECUTE FUNCTION update_work_order_fbos_updated_at();

-- Create indexes if they don't exist
CREATE INDEX IF NOT EXISTS idx_work_order_fbos_status ON work_order_fbos(status);
CREATE INDEX IF NOT EXISTS idx_work_order_fbos_price ON work_order_fbos(price);
CREATE INDEX IF NOT EXISTS idx_work_order_fbos_updated_at ON work_order_fbos(updated_at);