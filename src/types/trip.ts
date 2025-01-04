export interface TransitType {
  id: string;
  name: string;
  description: string;
  color: string;
  category: string;
  created_at: string;
}

export interface Trip {
  id: string;
  auth_id: string;
  name: string;
  description?: string;
  start_date: string;
  end_date?: string;
  status: 'planned' | 'active' | 'completed' | 'cancelled';
  created_at: string;
  updated_at: string;
}

export interface Route {
  id: string;
  auth_id: string;
  trip_id: string;
  transit_type_id: string;
  transit_type: TransitType;
  name: string;
  description?: string;
  created_at: string;
  updated_at: string;
  legs: Leg[];
}

export interface Leg {
  id: string;
  auth_id: string;
  route_id: string;
  origin_id: string;
  destination_id: string;
  origin: ICAO;
  destination: ICAO;
  scheduled_departure: string;
  scheduled_arrival: string;
  actual_departure?: string;
  actual_arrival?: string;
  status: 'scheduled' | 'departed' | 'arrived' | 'cancelled';
  notes?: string;
  created_at: string;
  updated_at: string;
}