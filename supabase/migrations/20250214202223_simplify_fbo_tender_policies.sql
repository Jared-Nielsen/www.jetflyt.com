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
DROP POLICY IF EXISTS "select_fbo_tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "insert_fbo_tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "update_fbo_tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "delete_fbo_tenders" ON fbo_tenders;

-- Add a helper function to check tender ownership
CREATE OR REPLACE FUNCTION check_tender_owner(tender_id uuid)
RETURNS boolean AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM tenders
    WHERE id = tender_id
    AND auth_id = auth.uid()
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create simplified FBO tender policies using the helper function
CREATE POLICY "select_fbo_tenders"
ON fbo_tenders
FOR SELECT
TO authenticated
USING (check_tender_owner(tender_id));

CREATE POLICY "insert_fbo_tenders"
ON fbo_tenders
FOR INSERT
TO authenticated
WITH CHECK (check_tender_owner(tender_id));

CREATE POLICY "update_fbo_tenders"
ON fbo_tenders
FOR UPDATE
TO authenticated
USING (check_tender_owner(tender_id))
WITH CHECK (true);

CREATE POLICY "delete_fbo_tenders"
ON fbo_tenders
FOR DELETE
TO authenticated
USING (check_tender_owner(tender_id));

-- Drop and recreate tender policies
DROP POLICY IF EXISTS "Users can view their own tenders" ON tenders;
DROP POLICY IF EXISTS "Users can create their own tenders" ON tenders;
DROP POLICY IF EXISTS "Users can update their own tenders" ON tenders;
DROP POLICY IF EXISTS "Users can delete their own tenders" ON tenders;
DROP POLICY IF EXISTS "select_tenders" ON tenders;
DROP POLICY IF EXISTS "insert_tenders" ON tenders;
DROP POLICY IF EXISTS "update_tenders" ON tenders;
DROP POLICY IF EXISTS "delete_tenders" ON tenders;

-- Simple tender policies
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
USING (auth_id = auth.uid())
WITH CHECK (auth_id = auth.uid());

CREATE POLICY "delete_tenders"
ON tenders
FOR DELETE
TO authenticated
USING (auth_id = auth.uid());

-- Ensure RLS is enabled
ALTER TABLE tenders ENABLE ROW LEVEL SECURITY;
ALTER TABLE fbo_tenders ENABLE ROW LEVEL SECURITY;

-- Simple policies for reference tables
CREATE OR REPLACE POLICY "select_fbos"
ON fbos
FOR SELECT
TO authenticated
USING (true);

CREATE OR REPLACE POLICY "select_aircraft"
ON aircraft
FOR SELECT
TO authenticated
USING (true);

CREATE OR REPLACE POLICY "select_icaos"
ON icaos
FOR SELECT
TO authenticated
USING (true);

-- Enable RLS on reference tables
ALTER TABLE fbos ENABLE ROW LEVEL SECURITY;
ALTER TABLE aircraft ENABLE ROW LEVEL SECURITY;
ALTER TABLE icaos ENABLE ROW LEVEL SECURITY;
