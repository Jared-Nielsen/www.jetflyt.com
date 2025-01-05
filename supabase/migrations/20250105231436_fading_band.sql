-- Update existing tables with new status constraints
DO $$ 
BEGIN
  -- Drop existing status constraints if they exist
  ALTER TABLE tenders 
  DROP CONSTRAINT IF EXISTS tenders_status_check;

  ALTER TABLE fbo_tenders 
  DROP CONSTRAINT IF EXISTS fbo_tenders_status_check;

  -- Add new status constraints
  ALTER TABLE tenders
  ADD CONSTRAINT tenders_status_check 
    CHECK (status IN ('pending', 'accepted', 'rejected', 'cancelled'));

  ALTER TABLE fbo_tenders
  ADD CONSTRAINT fbo_tenders_status_check 
    CHECK (status IN ('pending', 'accepted', 'rejected', 'cancelled'));

  -- Update any NULL statuses to 'pending'
  UPDATE tenders 
  SET status = 'pending' 
  WHERE status IS NULL;

  UPDATE fbo_tenders 
  SET status = 'pending' 
  WHERE status IS NULL;

  -- Ensure status columns have default values
  ALTER TABLE tenders 
  ALTER COLUMN status SET DEFAULT 'pending';

  ALTER TABLE fbo_tenders 
  ALTER COLUMN status SET DEFAULT 'pending';

  -- Create or update indexes if they don't exist
  CREATE INDEX IF NOT EXISTS idx_tenders_status ON tenders(status);
  CREATE INDEX IF NOT EXISTS idx_fbo_tenders_status ON fbo_tenders(status);
  CREATE INDEX IF NOT EXISTS idx_tenders_auth_id ON tenders(auth_id);
  CREATE INDEX IF NOT EXISTS idx_tenders_aircraft_id ON tenders(aircraft_id);
  CREATE INDEX IF NOT EXISTS idx_tenders_icao_id ON tenders(icao_id);
  CREATE INDEX IF NOT EXISTS idx_fbo_tenders_tender_id ON fbo_tenders(tender_id);
  CREATE INDEX IF NOT EXISTS idx_fbo_tenders_fbo_id ON fbo_tenders(fbo_id);
END $$;