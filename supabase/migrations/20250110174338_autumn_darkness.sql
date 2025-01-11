-- Create junction table for work orders and FBOs
CREATE TABLE work_order_fbos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  work_order_id uuid REFERENCES work_orders(id) ON DELETE CASCADE,
  fbo_id uuid REFERENCES fbos(id) ON DELETE CASCADE,
  created_at timestamptz DEFAULT now(),
  UNIQUE(work_order_id, fbo_id)
);

-- Enable RLS
ALTER TABLE work_order_fbos ENABLE ROW LEVEL SECURITY;

-- Add RLS policy
CREATE POLICY "Users can manage their work order FBOs"
  ON work_order_fbos
  FOR ALL
  TO authenticated
  USING (
    work_order_id IN (
      SELECT id FROM work_orders WHERE auth_id = auth.uid()
    )
  );

-- Create indexes
CREATE INDEX idx_work_order_fbos_work_order_id ON work_order_fbos(work_order_id);
CREATE INDEX idx_work_order_fbos_fbo_id ON work_order_fbos(fbo_id);

-- Remove old fbo_id column from work_orders
ALTER TABLE work_orders DROP COLUMN IF EXISTS fbo_id;