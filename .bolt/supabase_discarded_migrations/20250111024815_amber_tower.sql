-- Add image_logo field to aircraft_types table
ALTER TABLE aircraft_types
ADD COLUMN image_logo text;

-- Add check constraint to ensure image_logo is a valid URL
ALTER TABLE aircraft_types
ADD CONSTRAINT aircraft_types_image_logo_check
  CHECK (image_logo IS NULL OR image_logo ~ '^https?://.*');

-- Create index for image_logo field
CREATE INDEX idx_aircraft_types_image_logo ON aircraft_types(image_logo);

-- Add comment explaining the field usage
COMMENT ON COLUMN aircraft_types.image_logo IS 'URL reference to aircraft type logo image stored in the logo bucket';