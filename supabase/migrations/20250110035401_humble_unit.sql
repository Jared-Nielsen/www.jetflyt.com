/*
  # Add date fields to tenders table

  1. Changes
    - Add start_date (required) with default now()
    - Add end_date (optional)
    - Add date validation constraint
    - Add index for better query performance

  2. Notes
    - start_date is required and defaults to current timestamp
    - end_date is optional but must be after start_date if provided
*/

-- Add date fields to tenders table
ALTER TABLE tenders
ADD COLUMN start_date timestamptz NOT NULL DEFAULT now(),
ADD COLUMN end_date timestamptz;

-- Add constraint to ensure end_date is after start_date if provided
ALTER TABLE tenders
ADD CONSTRAINT tenders_dates_check
  CHECK (
    end_date IS NULL OR 
    end_date > start_date
  );

-- Create index for date fields
CREATE INDEX idx_tenders_dates ON tenders(start_date, end_date);