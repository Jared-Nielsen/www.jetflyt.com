-- Create tender_logs table if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'tender_logs') THEN
        CREATE TABLE tender_logs (
            id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
            tender_id uuid REFERENCES tenders(id) ON DELETE CASCADE,
            auth_id uuid REFERENCES auth.users(id),
            changed_at timestamptz NOT NULL DEFAULT now(),
            action text NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
            old_data jsonb,
            new_data jsonb
        );
    END IF;
END $$;

-- Create fbo_tender_logs table if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'fbo_tender_logs') THEN
        CREATE TABLE fbo_tender_logs (
            id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
            fbo_tender_id uuid REFERENCES fbo_tenders(id) ON DELETE CASCADE,
            auth_id uuid REFERENCES auth.users(id),
            changed_at timestamptz NOT NULL DEFAULT now(),
            action text NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
            old_data jsonb,
            new_data jsonb
        );
    END IF;
END $$;

-- Create or replace functions for logging changes
CREATE OR REPLACE FUNCTION log_tender_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO tender_logs (tender_id, auth_id, changed_at, action, old_data, new_data)
        VALUES (OLD.id, OLD.auth_id, now(), TG_OP, row_to_json(OLD), NULL);
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO tender_logs (tender_id, auth_id, changed_at, action, old_data, new_data)
        VALUES (NEW.id, NEW.auth_id, now(), TG_OP, row_to_json(OLD), row_to_json(NEW));
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO tender_logs (tender_id, auth_id, changed_at, action, old_data, new_data)
        VALUES (NEW.id, NEW.auth_id, now(), TG_OP, NULL, row_to_json(NEW));
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION log_fbo_tender_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO fbo_tender_logs (fbo_tender_id, auth_id, changed_at, action, old_data, new_data)
        VALUES (OLD.id, auth.uid(), now(), TG_OP, row_to_json(OLD), NULL);
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO fbo_tender_logs (fbo_tender_id, auth_id, changed_at, action, old_data, new_data)
        VALUES (NEW.id, auth.uid(), now(), TG_OP, row_to_json(OLD), row_to_json(NEW));
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO fbo_tender_logs (fbo_tender_id, auth_id, changed_at, action, old_data, new_data)
        VALUES (NEW.id, auth.uid(), now(), TG_OP, NULL, row_to_json(NEW));
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Add RLS policies for tender_logs
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Users can view tender logs for their own tenders') THEN
        ALTER TABLE tender_logs ENABLE ROW LEVEL SECURITY;
        CREATE POLICY "Users can view tender logs for their own tenders"
            ON tender_logs FOR SELECT
            USING (auth_id = auth.uid());
    END IF;
END $$;

-- Add RLS policies for fbo_tender_logs
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Users can view FBO tender logs for their own tenders') THEN
        ALTER TABLE fbo_tender_logs ENABLE ROW LEVEL SECURITY;
        CREATE POLICY "Users can view FBO tender logs for their own tenders"
            ON fbo_tender_logs FOR SELECT
            USING (auth_id = auth.uid());
    END IF;
END $$;

-- Create triggers if they don't exist
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.triggers WHERE trigger_name = 'log_tender_changes_trigger') THEN
        CREATE TRIGGER log_tender_changes_trigger
        AFTER INSERT OR UPDATE OR DELETE ON tenders
        FOR EACH ROW EXECUTE FUNCTION log_tender_changes();
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.triggers WHERE trigger_name = 'log_fbo_tender_changes_trigger') THEN
        CREATE TRIGGER log_fbo_tender_changes_trigger
        AFTER INSERT OR UPDATE OR DELETE ON fbo_tenders
        FOR EACH ROW EXECUTE FUNCTION log_fbo_tender_changes();
    END IF;
END $$;
