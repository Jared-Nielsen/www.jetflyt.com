-- Drop existing policies
DROP POLICY IF EXISTS "Users can view FBO tenders for their own tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Users can create FBO tenders for their own tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Users can update FBO tenders for their own tenders" ON fbo_tenders;
DROP POLICY IF EXISTS "Users can delete FBO tenders for their own tenders" ON fbo_tenders;

-- Create policies for fbo_tenders table with optimized checks
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

-- Update policy: Only check tender ownership in USING clause to avoid recursion
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
WITH CHECK (true);

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
