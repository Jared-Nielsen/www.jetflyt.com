-- Drop existing policies
DROP POLICY IF EXISTS "Allow authenticated users to create FBO tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Allow authenticated users to view FBO tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Allow authenticated users to update FBO tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Allow authenticated users to delete FBO tenders" ON fbo_tenders;

-- Enable RLS on tenders table if not already enabled
ALTER TABLE tenders ENABLE ROW LEVEL SECURITY;

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

-- Create policies for fbo_tenders table
CREATE POLICY "Users can view FBO tenders for their own tenders"
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

CREATE POLICY "Users can create FBO tenders for their own tenders"
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

CREATE POLICY "Users can update FBO tenders for their own tenders"
ON fbo_tenders
FOR UPDATE
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM tenders
    WHERE tenders.id = fbo_tenders.tender_id
    AND tenders.auth_id = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM tenders
    WHERE tenders.id = fbo_tenders.tender_id
    AND tenders.auth_id = auth.uid()
  )
);

CREATE POLICY "Users can delete FBO tenders for their own tenders"
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
