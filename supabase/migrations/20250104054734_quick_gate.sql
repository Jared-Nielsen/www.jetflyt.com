-- Add counter offer columns and status if they don't exist
DO $$ 
BEGIN
  -- First update any existing NULL values to 0 to avoid constraint violations
  UPDATE fbo_tenders 
  SET taxes_and_fees = 0 
  WHERE taxes_and_fees IS NULL;

  -- Add counter offer columns with safe defaults
  ALTER TABLE fbo_tenders
  ADD COLUMN IF NOT EXISTS counter_price numeric DEFAULT 0,
  ADD COLUMN IF NOT EXISTS counter_total_cost numeric DEFAULT 0,
  ADD COLUMN IF NOT EXISTS counter_taxes_and_fees numeric DEFAULT 0,
  ADD COLUMN IF NOT EXISTS status text DEFAULT 'pending';

  -- Now add the constraints
  ALTER TABLE fbo_tenders
  ADD CONSTRAINT counter_price_check 
    CHECK (counter_price >= 0),
  ADD CONSTRAINT counter_total_cost_check 
    CHECK (counter_total_cost >= 0),
  ADD CONSTRAINT counter_taxes_and_fees_check 
    CHECK (counter_taxes_and_fees >= 0),
  ADD CONSTRAINT status_check 
    CHECK (status IN ('pending', 'accepted', 'rejected'));

  -- Create index on status for faster queries
  CREATE INDEX IF NOT EXISTS idx_fbo_tenders_status ON fbo_tenders(status);
END $$;