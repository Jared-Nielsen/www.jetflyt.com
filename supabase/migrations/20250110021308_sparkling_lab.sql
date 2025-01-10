-- Create service types table
CREATE TABLE service_types (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS on service types
ALTER TABLE service_types ENABLE ROW LEVEL SECURITY;

-- Add read policy for authenticated users
CREATE POLICY "Anyone can read service types"
  ON service_types
  FOR SELECT
  TO authenticated
  USING (true);

-- Create services table
CREATE TABLE services (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  type_id uuid REFERENCES service_types(id) NOT NULL,
  price numeric NOT NULL CHECK (price >= 0),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS on services
ALTER TABLE services ENABLE ROW LEVEL SECURITY;

-- Add read policy for authenticated users
CREATE POLICY "Anyone can read services"
  ON services
  FOR SELECT
  TO authenticated
  USING (true);

-- Create work orders table
CREATE TABLE work_orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_id uuid DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  service_id uuid REFERENCES services(id) NOT NULL,
  quantity numeric NOT NULL CHECK (quantity > 0),
  description text NOT NULL,
  requested_date timestamptz NOT NULL,
  completed_date timestamptz,
  status text NOT NULL CHECK (status IN ('pending', 'in_progress', 'completed', 'cancelled')) DEFAULT 'pending',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS on work orders
ALTER TABLE work_orders ENABLE ROW LEVEL SECURITY;

-- Add policies for work orders
CREATE POLICY "Users can manage their own work orders"
  ON work_orders
  FOR ALL
  TO authenticated
  USING (auth_id = auth.uid());

-- Create updated_at trigger function if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'update_updated_at_column') THEN
    CREATE FUNCTION update_updated_at_column()
    RETURNS TRIGGER AS $$
    BEGIN
      NEW.updated_at = now();
      RETURN NEW;
    END;
    $$ language 'plpgsql';
  END IF;
END $$;

-- Add triggers for updated_at columns
CREATE TRIGGER update_services_updated_at
  BEFORE UPDATE ON services
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_work_orders_updated_at
  BEFORE UPDATE ON work_orders
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Create indexes
CREATE INDEX idx_services_type_id ON services(type_id);
CREATE INDEX idx_work_orders_auth_id ON work_orders(auth_id);
CREATE INDEX idx_work_orders_service_id ON work_orders(service_id);
CREATE INDEX idx_work_orders_status ON work_orders(status);

-- Insert initial service types
INSERT INTO service_types (name, description) VALUES
  ('aircraft_cleaning', 'Aircraft cleaning and detailing services'),
  ('baggage_handling', 'Baggage and cargo handling services'),
  ('catering', 'In-flight catering and provisioning'),
  ('fueling', 'Aircraft fueling and fuel testing services'),
  ('maintenance', 'Aircraft maintenance and repair services'),
  ('transportation', 'Ground transportation services'),
  ('security', 'Security and screening services'),
  ('de_icing', 'Aircraft de-icing services'),
  ('waste_management', 'Waste management and disposal services'),
  ('customs', 'Customs and immigration services');

-- Insert sample services
INSERT INTO services (name, description, type_id, price) 
SELECT 
  'Interior Cleaning',
  'Complete interior aircraft cleaning service',
  id,
  299.99
FROM service_types 
WHERE name = 'aircraft_cleaning';

INSERT INTO services (name, description, type_id, price) 
SELECT 
  'Exterior Washing',
  'Full exterior aircraft washing and detailing',
  id,
  499.99
FROM service_types 
WHERE name = 'aircraft_cleaning';

INSERT INTO services (name, description, type_id, price) 
SELECT 
  'VIP Baggage Handling',
  'Premium baggage handling service with dedicated staff',
  id,
  149.99
FROM service_types 
WHERE name = 'baggage_handling';

INSERT INTO services (name, description, type_id, price) 
SELECT 
  'Cargo Loading',
  'Professional cargo loading and securing service',
  id,
  299.99
FROM service_types 
WHERE name = 'baggage_handling';

INSERT INTO services (name, description, type_id, price) 
SELECT 
  'Premium Catering',
  'High-end in-flight meal service',
  id,
  399.99
FROM service_types 
WHERE name = 'catering';

INSERT INTO services (name, description, type_id, price) 
SELECT 
  'Standard De-icing',
  'Type I de-icing fluid application',
  id,
  599.99
FROM service_types 
WHERE name = 'de_icing';

INSERT INTO services (name, description, type_id, price) 
SELECT 
  'Anti-icing Treatment',
  'Type IV anti-icing fluid application',
  id,
  799.99
FROM service_types 
WHERE name = 'de_icing';

INSERT INTO services (name, description, type_id, price) 
SELECT 
  'Lavatory Service',
  'Complete lavatory cleaning and servicing',
  id,
  199.99
FROM service_types 
WHERE name = 'waste_management';

INSERT INTO services (name, description, type_id, price) 
SELECT 
  'Potable Water Service',
  'Potable water tank filling and testing',
  id,
  149.99
FROM service_types 
WHERE name = 'maintenance';

INSERT INTO services (name, description, type_id, price) 
SELECT 
  'Aircraft Security Check',
  'Comprehensive security inspection',
  id,
  249.99
FROM service_types 
WHERE name = 'security';