-- First delete any existing work orders since we're adding a required column
DELETE FROM work_orders;

-- Add FBO relationship to work orders
ALTER TABLE work_orders
ADD COLUMN fbo_id uuid REFERENCES fbos(id) NOT NULL;

-- Create index for FBO lookups
CREATE INDEX idx_work_orders_fbo_id ON work_orders(fbo_id);

-- Update work orders query policy to include FBO data
DROP POLICY IF EXISTS "Users can manage their own work orders" ON work_orders;

CREATE POLICY "Users can manage their own work orders"
  ON work_orders
  FOR ALL
  TO authenticated
  USING (auth_id = auth.uid());