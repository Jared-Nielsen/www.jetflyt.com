-- Check if the enum type exists
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_type 
        WHERE typname = 'fbo_tender_status'
    ) THEN
        -- Create the enum if it doesn't exist
        CREATE TYPE fbo_tender_status AS ENUM ('pending', 'submitted', 'accepted', 'rejected', 'canceled');
        
        -- Alter the column to use the new type
        ALTER TABLE fbo_tenders 
        ALTER COLUMN status TYPE fbo_tender_status 
        USING status::fbo_tender_status;
    ELSE
        -- Add the new value to the existing enum
        ALTER TYPE fbo_tender_status ADD VALUE IF NOT EXISTS 'canceled';
    END IF;
END $$;
