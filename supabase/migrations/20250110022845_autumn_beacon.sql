-- Add FBO relationship to work orders
ALTER TABLE work_orders
ADD COLUMN fbo_id uuid REFERENCES fbos(id);

-- Create index for FBO lookups
CREATE INDEX idx_work_orders_fbo_id ON work_orders(fbo_id);

-- Update work orders query policy to include FBO data
DROP POLICY IF EXISTS "Users can manage their own work orders" ON work_orders;

CREATE POLICY "Users can manage their own work orders"
  ON work_orders
  FOR ALL
  TO authenticated
  USING (auth_id = auth.uid());

-- Make fbo_id required after adding it
ALTER TABLE work_orders
ALTER COLUMN fbo_id SET NOT NULL;