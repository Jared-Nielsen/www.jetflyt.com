-- Allow null values for fuel_capacity column in aircraft table
ALTER TABLE aircraft ALTER COLUMN fuel_capacity DROP NOT NULL;

-- Add check constraint to ensure fuel_capacity is either null or positive
ALTER TABLE aircraft ADD CONSTRAINT fuel_capacity_check 
  CHECK (fuel_capacity IS NULL OR fuel_capacity >= 0);