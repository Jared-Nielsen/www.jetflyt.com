/*
  # Add aircraft coordinates

  1. Changes
    - Add latitude and longitude columns to aircraft table
    - Set default values to KIAH coordinates (29.9902, -95.3368)
    - Add index for spatial queries
*/

-- Add coordinate columns with KIAH defaults
ALTER TABLE aircraft
ADD COLUMN latitude numeric DEFAULT 29.9902,
ADD COLUMN longitude numeric DEFAULT -95.3368;

-- Create index for spatial queries
CREATE INDEX idx_aircraft_coordinates ON aircraft USING btree (latitude, longitude);