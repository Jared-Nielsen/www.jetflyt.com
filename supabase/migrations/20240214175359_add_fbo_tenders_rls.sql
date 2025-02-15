-- Enable RLS on fbo_tenders table
ALTER TABLE fbo_tenders ENABLE ROW LEVEL SECURITY;

-- Create policy to allow authenticated users to create FBO tenders
CREATE POLICY "Allow authenticated users to create FBO tenders"
ON fbo_tenders
FOR INSERT
TO authenticated
WITH CHECK (true);

-- Create policy to allow authenticated users to view FBO tenders
CREATE POLICY "Allow authenticated users to view FBO tenders"
ON fbo_tenders
FOR SELECT
TO authenticated
USING (true);

-- Create policy to allow authenticated users to update FBO tenders
CREATE POLICY "Allow authenticated users to update FBO tenders"
ON fbo_tenders
FOR UPDATE
TO authenticated
USING (true)
WITH CHECK (true);

-- Create policy to allow authenticated users to delete FBO tenders
CREATE POLICY "Allow authenticated users to delete FBO tenders"
ON fbo_tenders
FOR DELETE
TO authenticated
USING (true);
