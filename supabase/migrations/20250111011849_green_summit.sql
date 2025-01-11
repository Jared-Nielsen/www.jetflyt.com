-- Drop existing status constraint if it exists
ALTER TABLE work_order_fbos 
DROP CONSTRAINT IF EXISTS work_order_fbos_status_check;

-- Add new status constraint that allows blank status
ALTER TABLE work_order_fbos
ADD CONSTRAINT work_order_fbos_status_check
  CHECK (status IN ('pending', 'offered', 'accepted', ''));

-- Update any existing blank or null statuses to 'pending'
UPDATE work_order_fbos 
SET status = 'pending' 
WHERE status IS NULL OR status = '';

-- Ensure status has a default value
ALTER TABLE work_order_fbos 
ALTER COLUMN status SET DEFAULT 'pending';

-- Create or update index for status
DROP INDEX IF EXISTS idx_work_order_fbos_status;
CREATE INDEX idx_work_order_fbos_status ON work_order_fbos(status);