-- Allow null values for model column in aircraft table
ALTER TABLE aircraft ALTER COLUMN model DROP NOT NULL;

-- Add check constraint to ensure model is either null or not empty
ALTER TABLE aircraft ADD CONSTRAINT model_not_empty 
  CHECK (model IS NULL OR length(trim(model)) > 0);