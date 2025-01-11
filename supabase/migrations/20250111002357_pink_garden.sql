-- Drop existing trigger if it exists
DROP TRIGGER IF EXISTS create_work_order_offer_on_fbo_insert ON work_order_fbos;
DROP FUNCTION IF EXISTS handle_work_order_fbo_insert();

-- Create function to handle work order offer creation
CREATE OR REPLACE FUNCTION handle_work_order_fbo_insert()
RETURNS TRIGGER AS $$
BEGIN
  -- Create a work order offer for the FBO
  INSERT INTO work_order_offers (work_order_id, fbo_id)
  VALUES (NEW.work_order_id, NEW.fbo_id)
  ON CONFLICT (work_order_id, fbo_id) DO NOTHING;
  
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to create work order offers when FBOs are added
CREATE TRIGGER create_work_order_offer_on_fbo_insert
  AFTER INSERT ON work_order_fbos
  FOR EACH ROW
  EXECUTE FUNCTION handle_work_order_fbo_insert();