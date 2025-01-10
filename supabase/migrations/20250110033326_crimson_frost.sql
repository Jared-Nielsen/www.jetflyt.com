-- Add passenger count fields to work_orders table
ALTER TABLE work_orders
ADD COLUMN passenger_count integer DEFAULT 0 CHECK (passenger_count >= 0),
ADD COLUMN crew_count integer DEFAULT 0 CHECK (crew_count >= 0),
ADD COLUMN pet_count integer DEFAULT 0 CHECK (pet_count >= 0);

-- Create index for count fields
CREATE INDEX idx_work_orders_counts ON work_orders(passenger_count, crew_count, pet_count);