-- Allow null values for year column in aircraft table
ALTER TABLE aircraft ALTER COLUMN year DROP NOT NULL;

-- Add check constraint to ensure year is either null or within reasonable range
ALTER TABLE aircraft ADD CONSTRAINT year_range_check 
  CHECK (year IS NULL OR (year >= 1900 AND year <= extract(year from current_date)));