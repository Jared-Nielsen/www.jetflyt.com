-- Add arrival_date and departure_date to work_orders table
ALTER TABLE work_orders
ADD COLUMN arrival_date timestamptz,
ADD COLUMN departure_date timestamptz;

-- Add check constraint to ensure departure is after arrival if both are set
ALTER TABLE work_orders
ADD CONSTRAINT work_orders_dates_check
  CHECK (
    (arrival_date IS NULL AND departure_date IS NULL) OR
    (arrival_date IS NULL OR departure_date IS NULL) OR
    (departure_date > arrival_date)
  );

-- Create index for date fields
CREATE INDEX idx_work_orders_dates ON work_orders(arrival_date, departure_date);