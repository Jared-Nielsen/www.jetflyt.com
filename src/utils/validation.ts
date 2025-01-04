import type { Aircraft } from '../types/aircraft';
import type { ICAO } from '../types/icao';
import type { Tender } from '../types/tender';

export function validateAircraft(data: Partial<Aircraft>): string | null {
  if (!data.tail_number?.trim()) {
    return 'Tail number is required';
  }
  if (!data.type_id) {
    return 'Aircraft type is required';
  }
  if (!data.manufacturer?.trim()) {
    return 'Manufacturer is required';
  }
  if (!data.model?.trim()) {
    return 'Model is required';
  }
  if (!data.year || data.year < 1900 || data.year > new Date().getFullYear()) {
    return 'Invalid year';
  }
  if (!data.fuel_type_id) {
    return 'Fuel type is required';
  }
  if (!data.fuel_capacity || data.fuel_capacity <= 0) {
    return 'Invalid fuel capacity';
  }
  return null;
}

export function validateTender(data: Partial<Tender>): string | null {
  if (!data.aircraft_id) {
    return 'Aircraft is required';
  }
  if (!data.icao_id) {
    return 'Airport is required';
  }
  if (!data.gallons || data.gallons <= 0) {
    return 'Invalid fuel amount';
  }
  if (!data.target_price || data.target_price <= 0) {
    return 'Invalid target price';
  }
  return null;
}

export function validateICAOCode(code: string): boolean {
  return /^[A-Z]{4}$/.test(code);
}

export function validateCoordinates(lat: number, lng: number): boolean {
  return (
    !isNaN(lat) && 
    !isNaN(lng) && 
    lat >= -90 && 
    lat <= 90 && 
    lng >= -180 && 
    lng <= 180
  );
}

export function validateAirportData(airport: Partial<ICAO>): string | null {
  if (!airport.code || !validateICAOCode(airport.code)) {
    return 'Invalid ICAO code';
  }
  if (!airport.name?.trim()) {
    return 'Airport name is required';
  }
  if (!validateCoordinates(airport.latitude, airport.longitude)) {
    return 'Invalid coordinates';
  }
  return null;
}