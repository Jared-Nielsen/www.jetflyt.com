/*
  # FBO Contracts Table

  1. New Tables
    - fbo_contracts: Stores legal agreements between FBOs and operators
    - contract_terms: Stores specific terms and conditions
    - contract_signatures: Stores digital signatures and timestamps

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users
    - Ensure proper access control for both parties

  3. Sample Data
    - Add a comprehensive sample jet fuel contract
*/

-- Create contract status enum
CREATE TYPE contract_status AS ENUM (
  'draft',
  'pending_operator',
  'pending_fbo',
  'active',
  'expired',
  'terminated'
);

-- Create payment terms enum
CREATE TYPE payment_terms AS ENUM (
  'net_15',
  'net_30',
  'net_45',
  'net_60',
  'prepaid',
  'cod'
);

-- Create fbo_contracts table
CREATE TABLE fbo_contracts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  operator_counterparty_id uuid DEFAULT auth.uid() REFERENCES auth.users(id),
  fbo_counterparty_id uuid REFERENCES fbos(id),
  contract_number text UNIQUE NOT NULL,
  status contract_status DEFAULT 'draft',
  effective_date date NOT NULL,
  expiration_date date NOT NULL,
  payment_terms payment_terms DEFAULT 'net_30',
  fuel_type_id uuid REFERENCES fuel_types(id),
  base_price_per_gallon numeric NOT NULL CHECK (base_price_per_gallon > 0),
  minimum_volume numeric NOT NULL CHECK (minimum_volume > 0),
  maximum_volume numeric NOT NULL CHECK (maximum_volume >= minimum_volume),
  price_adjustment_formula text,
  into_plane_fee numeric DEFAULT 0,
  storage_fee numeric DEFAULT 0,
  taxes_and_fees jsonb DEFAULT '{}',
  special_terms text,
  cancellation_terms text,
  force_majeure_terms text,
  insurance_requirements text,
  environmental_requirements text,
  quality_control_terms text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  CHECK (expiration_date > effective_date)
);

-- Create contract_terms table for specific terms and conditions
CREATE TABLE contract_terms (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_id uuid REFERENCES fbo_contracts(id) ON DELETE CASCADE,
  section_name text NOT NULL,
  content text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Create contract_signatures table
CREATE TABLE contract_signatures (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  contract_id uuid REFERENCES fbo_contracts(id) ON DELETE CASCADE,
  signer_id uuid REFERENCES auth.users(id),
  signer_role text NOT NULL,
  signature_data text NOT NULL,
  ip_address inet,
  signed_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE fbo_contracts ENABLE ROW LEVEL SECURITY;
ALTER TABLE contract_terms ENABLE ROW LEVEL SECURITY;
ALTER TABLE contract_signatures ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view their own contracts"
  ON fbo_contracts
  FOR SELECT
  TO authenticated
  USING (operator_counterparty_id = auth.uid());

CREATE POLICY "Users can manage their own contracts"
  ON fbo_contracts
  FOR ALL
  TO authenticated
  USING (operator_counterparty_id = auth.uid());

CREATE POLICY "Users can view their contract terms"
  ON contract_terms
  FOR SELECT
  TO authenticated
  USING (
    contract_id IN (
      SELECT id FROM fbo_contracts 
      WHERE operator_counterparty_id = auth.uid()
    )
  );

CREATE POLICY "Users can view their contract signatures"
  ON contract_signatures
  FOR SELECT
  TO authenticated
  USING (
    contract_id IN (
      SELECT id FROM fbo_contracts 
      WHERE operator_counterparty_id = auth.uid()
    )
  );

-- Create indexes
CREATE INDEX idx_fbo_contracts_operator ON fbo_contracts(operator_counterparty_id);
CREATE INDEX idx_fbo_contracts_fbo ON fbo_contracts(fbo_counterparty_id);
CREATE INDEX idx_contract_terms_contract ON contract_terms(contract_id);
CREATE INDEX idx_contract_signatures_contract ON contract_signatures(contract_id);

-- Create updated_at trigger
CREATE TRIGGER update_fbo_contracts_updated_at
  BEFORE UPDATE ON fbo_contracts
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Insert sample contract
INSERT INTO fbo_contracts (
  contract_number,
  status,
  effective_date,
  expiration_date,
  payment_terms,
  fuel_type_id,
  base_price_per_gallon,
  minimum_volume,
  maximum_volume,
  price_adjustment_formula,
  into_plane_fee,
  storage_fee,
  taxes_and_fees,
  special_terms,
  cancellation_terms,
  force_majeure_terms,
  insurance_requirements,
  environmental_requirements,
  quality_control_terms
) 
SELECT
  'FBO-2024-001',
  'active',
  '2024-01-01',
  '2024-12-31',
  'net_30',
  ft.id,
  5.25,
  100000,
  500000,
  'Base price adjusted monthly according to Platts Gulf Coast Jet Fuel Index + $0.25/gallon',
  0.15,
  0.05,
  '{"federal_excise_tax": 0.244, "state_tax": 0.20, "spill_fee": 0.02}',
  'Priority fueling available 24/7. Volume discounts apply for purchases exceeding 250,000 gallons per quarter.',
  'Either party may terminate with 90 days written notice. Early termination fee applies if minimum volume not met.',
  'Standard force majeure conditions apply, including but not limited to natural disasters, war, strikes, and government actions.',
  'Operator must maintain $5M aviation liability insurance. FBO must maintain $10M general liability coverage.',
  'Compliance with all applicable environmental regulations required. Spill prevention and response plan must be maintained.',
  'Fuel quality testing performed daily. Compliance with ATA 103 and API 1543 standards required.'
FROM fuel_types ft
WHERE ft.name = 'Jet A'
LIMIT 1;