-- Drop ALL existing FBO tender policies to start fresh
DROP POLICY IF EXISTS "Users can view FBO tenders for their own tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Users can create FBO tenders for their own tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Users can update FBO tenders for their own tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Users can delete FBO tenders for their own tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Allow authenticated users to create FBO tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Allow authenticated users to view FBO tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Allow authenticated users to update FBO tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Allow authenticated users to delete FBO tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Users can view FBO tenders" ON fbo_tenders;

-- Create a single SELECT policy that doesn't cause recursion
CREATE POLICY "select_fbo_tenders"
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

-- Simple INSERT policy
CREATE POLICY "insert_fbo_tenders"
ON fbo_tenders
FOR INSERT
TO authenticated
WITH CHECK (
  EXISTS (
    SELECT 1 FROM tenders 
    WHERE tenders.id = fbo_tenders.tender_id 
    AND tenders.auth_id = auth.uid()
  )
);

-- UPDATE policy with single check
CREATE POLICY "update_fbo_tenders"
ON fbo_tenders
FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM tenders 
    WHERE tenders.id = fbo_tenders.tender_id 
    AND tenders.auth_id = auth.uid()
  )
);

-- DELETE policy
CREATE POLICY "delete_fbo_tenders"
ON fbo_tenders
FOR DELETE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM tenders 
    WHERE tenders.id = fbo_tenders.tender_id 
    AND tenders.auth_id = auth.uid()
  )
);

-- Drop and recreate tender policies to ensure consistency
DROP POLICY IF EXISTS "Users can view their own tenders" ON tenders;
DROP POLICY IF EXISTS "Users can create their own tenders" ON tenders;
DROP POLICY IF EXISTS "Users can update their own tenders" ON tenders;
DROP POLICY IF EXISTS "Users can delete their own tenders" ON tenders;

-- Simple tender policies based on auth_id only
CREATE POLICY "select_tenders"
ON tenders
FOR SELECT
TO authenticated
USING (auth_id = auth.uid());

CREATE POLICY "insert_tenders"
ON tenders
FOR INSERT
TO authenticated
WITH CHECK (auth_id = auth.uid());

CREATE POLICY "update_tenders"
ON tenders
FOR UPDATE
TO authenticated
USING (auth_id = auth.uid());

CREATE POLICY "delete_tenders"
ON tenders
FOR DELETE
TO authenticated
USING (auth_id = auth.uid());

-- Ensure RLS is enabled
ALTER TABLE tenders ENABLE ROW LEVEL SECURITY;
ALTER TABLE fbo_tenders ENABLE ROW LEVEL SECURITY;

-- Add policies for reference tables if they don't exist
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'fbos' AND policyname = 'select_fbos'
    ) THEN
        CREATE POLICY "select_fbos"
        ON fbos
        FOR SELECT
        TO authenticated
        USING (true);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'aircraft' AND policyname = 'select_aircraft'
    ) THEN
        CREATE POLICY "select_aircraft"
        ON aircraft
        FOR SELECT
        TO authenticated
        USING (true);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'icaos' AND policyname = 'select_icaos'
    ) THEN
        CREATE POLICY "select_icaos"
        ON icaos
        FOR SELECT
        TO authenticated
        USING (true);
    END IF;
END $$;

-- Enable RLS on reference tables
ALTER TABLE fbos ENABLE ROW LEVEL SECURITY;
ALTER TABLE aircraft ENABLE ROW LEVEL SECURITY;
ALTER TABLE icaos ENABLE ROW LEVEL SECURITY;
