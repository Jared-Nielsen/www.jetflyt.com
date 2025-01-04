export function formatCurrency(amount: number): string {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD'
  }).format(amount);
}

export function formatNumber(num: number, decimals = 0): string {
  return new Intl.NumberFormat('en-US', {
    minimumFractionDigits: decimals,
    maximumFractionDigits: decimals
  }).format(num);
}

export function formatGallons(gallons: number): string {
  return `${formatNumber(gallons)} gal`;
}

export function formatCoordinates(lat: number, lng: number): string {
  return `${lat.toFixed(4)}°, ${lng.toFixed(4)}°`;
}

export function formatDistance(nauticalMiles: number): string {
  return `${formatNumber(nauticalMiles)} nm`;
}

export function formatTailNumber(tailNumber: string): string {
  return tailNumber.toUpperCase().trim();
}