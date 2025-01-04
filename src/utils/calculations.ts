const EARTH_RADIUS_NM = 3440.065; // Earth radius in nautical miles

export function calculateDistance(
  lat1: number,
  lon1: number,
  lat2: number,
  lon2: number
): number {
  const toRad = (deg: number) => (deg * Math.PI) / 180;
  
  const dLat = toRad(lat2 - lat1);
  const dLon = toRad(lon2 - lon1);
  
  const a = 
    Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * 
    Math.sin(dLon/2) * Math.sin(dLon/2);
  
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  
  return Math.round(EARTH_RADIUS_NM * c);
}

export function calculateFuelCost(
  gallons: number,
  pricePerGallon: number,
  taxesAndFees = 0
): number {
  const subtotal = gallons * pricePerGallon;
  return subtotal + taxesAndFees;
}

export function calculateRange(
  fuelCapacity: number,
  fuelBurnRate: number,
  reserveFuel = 0.1 // 10% reserve by default
): number {
  const usableFuel = fuelCapacity * (1 - reserveFuel);
  return Math.floor(usableFuel / fuelBurnRate);
}

export function calculateEndurance(
  fuelCapacity: number,
  fuelBurnRate: number,
  reserveFuel = 0.1
): number {
  const usableFuel = fuelCapacity * (1 - reserveFuel);
  return usableFuel / fuelBurnRate;
}