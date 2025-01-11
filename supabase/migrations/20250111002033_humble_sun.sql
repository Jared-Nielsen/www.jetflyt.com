-- Create function to handle service offer creation
CREATE OR REPLACE FUNCTION handle_work_order_fbo_insert()
RETURNS TRIGGER AS $$
BEGIN
  -- Create a service offer for the FBO if one doesn't exist
  INSERT INTO service_offers (fbo_id, service_id)
  SELECT 
    NEW.fbo_id,
    wo.service_id
  FROM work_orders wo
  WHERE wo.id = NEW.work_order_id
  ON CONFLICT (fbo_id, service_id) DO NOTHING;
  
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to create service offers when FBOs are added to work orders
CREATE TRIGGER create_service_offer_on_work_order_fbo
  AFTER INSERT ON work_order_fbos
  FOR EACH ROW
  EXECUTE FUNCTION handle_work_order_fbo_insert();