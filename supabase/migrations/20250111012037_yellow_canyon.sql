-- Drop existing status constraint if it exists
ALTER TABLE work_orders 
DROP CONSTRAINT IF EXISTS work_orders_status_check;

-- Add new status constraint with accepted status
ALTER TABLE work_orders
ADD CONSTRAINT work_orders_status_check
  CHECK (status IN ('pending', 'accepted', 'in_progress', 'completed', 'cancelled'));

-- Update any existing null statuses to 'pending'
UPDATE work_orders 
SET status = 'pending' 
WHERE status IS NULL;

-- Ensure status has a default value
ALTER TABLE work_orders 
ALTER COLUMN status SET DEFAULT 'pending';

-- Create or update index for status
DROP INDEX IF EXISTS idx_work_orders_status;
CREATE INDEX idx_work_orders_status ON work_orders(status);