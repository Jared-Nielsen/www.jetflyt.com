-- Drop existing policies
DROP POLICY IF EXISTS "Allow authenticated users to create FBO tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Allow authenticated users to view FBO tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Allow authenticated users to update FBO tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Allow authenticated users to delete FBO tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Users can view their own tenders" ON tenders;
DROP POLICY IF EXISTS "Users can create their own tenders" ON tenders;
DROP POLICY IF EXISTS "Users can update their own tenders" ON tenders;
DROP POLICY IF EXISTS "Users can delete their own tenders" ON tenders;
DROP POLICY IF EXISTS "Users can view FBO tenders for their own tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Users can create FBO tenders for their own tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Users can update FBO tenders for their own tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Users can delete FBO tenders for their own tenders" ON fbo_tenders;

-- Enable RLS on both tables
ALTER TABLE tenders ENABLE ROW LEVEL SECURITY;
ALTER TABLE fbo_tenders ENABLE ROW LEVEL SECURITY;

-- Create policies for tenders table
CREATE POLICY "Users can view their own tenders"
ON tenders
FOR SELECT
TO authenticated
USING (auth_id = auth.uid());

CREATE POLICY "Users can create their own tenders"
ON tenders
FOR INSERT
TO authenticated
WITH CHECK (auth_id = auth.uid());

CREATE POLICY "Users can update their own tenders"
ON tenders
FOR UPDATE
TO authenticated
USING (auth_id = auth.uid())
WITH CHECK (auth_id = auth.uid());

CREATE POLICY "Users can delete their own tenders"
ON tenders
FOR DELETE
TO authenticated
USING (auth_id = auth.uid());

-- Create a function to check tender ownership
CREATE OR REPLACE FUNCTION check_tender_ownership(tender_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM tenders
    WHERE id = tender_id
    AND auth_id = auth.uid()
  );
$$;

-- Create policies for fbo_tenders table using the function
CREATE POLICY "Users can view FBO tenders for their own tenders"
ON fbo_tenders
FOR SELECT
TO authenticated
USING (check_tender_ownership(tender_id));

CREATE POLICY "Users can create FBO tenders for their own tenders"
ON fbo_tenders
FOR INSERT
TO authenticated
WITH CHECK (check_tender_ownership(tender_id));

CREATE POLICY "Users can update FBO tenders for their own tenders"
ON fbo_tenders
FOR UPDATE
TO authenticated
USING (check_tender_ownership(tender_id))
WITH CHECK (check_tender_ownership(tender_id));

CREATE POLICY "Users can delete FBO tenders for their own tenders"
ON fbo_tenders
FOR DELETE
TO authenticated
USING (check_tender_ownership(tender_id));
