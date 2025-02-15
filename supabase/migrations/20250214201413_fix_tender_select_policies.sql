-- Drop existing policies
DROP POLICY IF EXISTS "Users can view their own tenders" ON tenders;
DROP POLICY IF EXISTS "Users can view FBO tenders for their own tenders" ON fbo_tenders;

-- Create updated select policies
CREATE POLICY "Users can view their own tenders"
ON tenders
FOR SELECT
TO authenticated
USING (auth_id = auth.uid());

-- Create policy for FBO tenders with simplified check
CREATE POLICY "Users can view FBO tenders"
ON fbo_tenders
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM tenders
    WHERE tenders.id = fbo_tenders.tender_id
    AND tenders.auth_id = auth.uid()
  )
);

-- Add policy for FBOs table if not exists
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'fbos' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users"
        ON fbos
        FOR SELECT
        TO authenticated
        USING (true);
    END IF;
END $$;

-- Add policy for aircraft table if not exists
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'aircraft' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users"
        ON aircraft
        FOR SELECT
        TO authenticated
        USING (true);
    END IF;
END $$;

-- Add policy for icaos table if not exists
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'icaos' AND policyname = 'Enable read access for all users'
    ) THEN
        CREATE POLICY "Enable read access for all users"
        ON icaos
        FOR SELECT
        TO authenticated
        USING (true);
    END IF;
END $$;

-- Enable RLS on tables if not already enabled
ALTER TABLE fbos ENABLE ROW LEVEL SECURITY;
ALTER TABLE aircraft ENABLE ROW LEVEL SECURITY;
ALTER TABLE icaos ENABLE ROW LEVEL SECURITY;
