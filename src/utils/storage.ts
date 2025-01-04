// Storage keys
export const STORAGE_KEYS = {
  ICAOS: 'jetflyt-icaos',
  FBOS: 'jetflyt-fbos'
} as const;

// Cache duration in milliseconds (24 hours)
export const CACHE_DURATION = 24 * 60 * 60 * 1000;

export function clearStorage() {
  Object.values(STORAGE_KEYS).forEach(key => {
    localStorage.removeItem(key);
  });
}