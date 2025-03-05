-- Update any aircraft records that don't have a user_id set
UPDATE aircraft
SET user_id = auth.uid()
WHERE user_id IS NULL;

-- Add NOT NULL constraint to user_id to prevent this issue in the future
ALTER TABLE aircraft 
ALTER COLUMN user_id SET NOT NULL;
