-- Drop the existing check constraint
ALTER TABLE fbo_tenders
DROP CONSTRAINT IF EXISTS status_check;

-- Add the updated check constraint with 'canceled' status
ALTER TABLE fbo_tenders
ADD CONSTRAINT status_check
CHECK (status IN ('pending', 'submitted', 'accepted', 'rejected', 'canceled'));

-- Update any existing cancelled statuses to canceled (if they exist)
UPDATE fbo_tenders
SET status = 'canceled'
WHERE status = 'cancelled';
