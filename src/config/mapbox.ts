// Mapbox configuration
export const MAPBOX_ACCESS_TOKEN = 'pk.eyJ1Ijoic3RhY2tibGl0eiIsImEiOiJjbHR3ZmF4Z2gwMXZqMmtvOW5sMGZwZXJ4In0.x2qGdf8LA5aU0gRwJcetwA';

// Use a more reliable style URL
export const MAPBOX_STYLE = 'mapbox://styles/mapbox/streets-v12';

export const DEFAULT_CENTER: [number, number] = [10, 51]; // Center on Europe
export const DEFAULT_ZOOM = 4;

// Validate token format
export function isValidMapboxToken(token: string): boolean {
  return /^pk\.[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+$/.test(token);
}