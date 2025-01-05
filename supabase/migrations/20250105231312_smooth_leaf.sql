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

  -- Drop existing status constraint if it exists
  ALTER TABLE fbo_tenders 
  DROP CONSTRAINT IF EXISTS status_check;

  -- Add the new status constraint
  ALTER TABLE fbo_tenders
  ADD CONSTRAINT status_check 
    CHECK (status IN ('pending', 'accepted', 'rejected', 'cancelled'));

  -- Create index on status for faster queries
  CREATE INDEX IF NOT EXISTS idx_fbo_tenders_status ON fbo_tenders(status);
END $$;