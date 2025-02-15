export interface Tender {
  id: string;
  auth_id: string;
  aircraft_id: string;
  icao_id: string;
  gallons: number;
  target_price: number;
  description: string;
  status: 'pending' | 'active' | 'accepted' | 'rejected';
  created_at: string;
  updated_at: string;
}

export interface FBOTender {
  id: string;
  tender_id: string;
  fbo_id: string;
  fbo?: {
    id: string;
    name: string;
  };
  offer_price: number;
  total_cost: number;
  taxes_and_fees: number;
  counter_price?: number;
  counter_total_cost?: number;
  counter_taxes_and_fees?: number;
  description: string;
  status?: 'pending' | 'submitted' | 'accepted' | 'rejected' | 'canceled';
  created_at: string;
  updated_at: string;
}