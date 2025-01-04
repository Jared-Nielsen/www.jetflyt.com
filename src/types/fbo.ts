export interface FBO {
  id: string;
  name: string;
  icao_id: string;
  icao?: {
    code: string;
    name: string;
  };
  latitude: number;
  longitude: number;
  address: string;
  country: string;
  state?: string;
}