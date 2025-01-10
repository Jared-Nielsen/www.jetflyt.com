import type { FBO } from './fbo';
import type { Aircraft } from './aircraft';

export interface ServiceType {
  id: string;
  name: string;
  description: string;
  created_at: string;
}

export interface Service {
  id: string;
  name: string;
  description: string;
  type_id: string;
  type: ServiceType;
  price: number;
  created_at: string;
  updated_at: string;
}

export interface WorkOrder {
  id: string;
  auth_id: string;
  aircraft_id: string;
  aircraft: Aircraft;
  service_id: string;
  service: Service;
  fbo_id: string;
  fbo: FBO;
  quantity: number;
  description: string;
  requested_date: string;
  arrival_date?: string;
  departure_date?: string;
  completed_date?: string;
  status: 'pending' | 'in_progress' | 'completed' | 'cancelled';
  created_at: string;
  updated_at: string;
}