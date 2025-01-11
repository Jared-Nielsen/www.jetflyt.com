-- Add price and status to work_order_fbos table
ALTER TABLE work_order_fbos
ADD COLUMN price numeric DEFAULT 0 CHECK (price >= 0),
ADD COLUMN status text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'offered', 'accepted'));

-- Create index for status
CREATE INDEX idx_work_order_fbos_status ON work_order_fbos(status);

-- Update existing rows to have pending status
UPDATE work_order_fbos SET status = 'pending' WHERE status IS NULL;