-- Allow null values for max_range column in aircraft table
ALTER TABLE aircraft ALTER COLUMN max_range DROP NOT NULL;

-- Add check constraint to ensure max_range is either null or positive
ALTER TABLE aircraft ADD CONSTRAINT max_range_check 
  CHECK (max_range IS NULL OR max_range >= 0);