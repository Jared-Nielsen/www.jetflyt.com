-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view their own tenders" ON tenders;
DROP POLICY IF EXISTS "Users can create their own tenders" ON tenders;
DROP POLICY IF EXISTS "Users can update their own tenders" ON tenders;
DROP POLICY IF EXISTS "Users can view tenders" ON tenders;
DROP POLICY IF EXISTS "Users can create tenders" ON tenders;
DROP POLICY IF EXISTS "Users can update tenders" ON tenders;

-- Set default value for auth_id to current user
DO $$ 
BEGIN
    -- Check if the tables exist before altering them
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'tenders') THEN
        ALTER TABLE tenders ALTER COLUMN auth_id SET DEFAULT auth.uid();
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'tender_logs') THEN
        ALTER TABLE tender_logs ALTER COLUMN auth_id SET DEFAULT auth.uid();
    END IF;

    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'fbo_tender_logs') THEN
        ALTER TABLE fbo_tender_logs ALTER COLUMN auth_id SET DEFAULT auth.uid();
    END IF;
END $$;

-- Create new policies that don't require explicit auth_id
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'tenders') THEN
        CREATE POLICY "Users can view tenders"
        ON tenders
        FOR SELECT
        TO authenticated
        USING (true);

        CREATE POLICY "Users can create tenders"
        ON tenders
        FOR INSERT
        TO authenticated
        WITH CHECK (
            auth_id = auth.uid() -- Ensure auth_id matches current user even with default
        );

        CREATE POLICY "Users can update tenders"
        ON tenders
        FOR UPDATE
        TO authenticated
        USING (auth_id = auth.uid())
        WITH CHECK (auth_id = auth.uid());
    END IF;
END $$;

-- Update FBO tender policies
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'fbo_tenders') THEN
        DROP POLICY IF EXISTS "Users can update FBO tenders for their own tenders" ON fbo_tenders;
        DROP POLICY IF EXISTS "Users can update FBO tenders" ON fbo_tenders;

        CREATE POLICY "Users can update FBO tenders"
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
    END IF;
END $$;
