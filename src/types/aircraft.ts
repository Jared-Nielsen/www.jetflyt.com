export interface FuelType {
  id: string;
  name: string;
  description: string;
  created_at: string;
}

export interface AircraftEngineType {
  id: string;
  name: string;
  description: string;
  created_at: string;
}

export interface AircraftType {
  id: string;
  name: string;
  manufacturer: string;
  category: string;
  created_at: string;
}

export interface Aircraft {
  id: string;
  user_id: string;
  tail_number: string;
  type_id: string;
  type?: AircraftType;
  manufacturer: string;
  model: string;
  year: number;
  max_range: number;
  fuel_type_id: string;
  fuel_type?: FuelType;
  fuel_capacity: number;
  engine_type_id: string;
  engine_type?: AircraftEngineType;
  latitude: number;
  longitude: number;
  created_at: string;
  updated_at: string;
}