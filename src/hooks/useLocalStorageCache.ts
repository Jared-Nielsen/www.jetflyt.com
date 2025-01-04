import { useState, useEffect } from 'react';
import { CACHE_DURATION } from '../utils/storage';

interface CacheData<T> {
  data: T;
  timestamp: number;
}

export function useLocalStorageCache<T>(
  key: string,
  fetchData: () => Promise<T>,
  dependencies: any[] = []
) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function loadData() {
      try {
        // Try to get from cache first
        const cached = localStorage.getItem(key);
        if (cached) {
          const { data: cachedData, timestamp }: CacheData<T> = JSON.parse(cached);
          const now = Date.now();
          
          // Check if cache is still valid
          if (now - timestamp < CACHE_DURATION) {
            setData(cachedData);
            setLoading(false);
            return;
          }
        }

        // Fetch fresh data
        const freshData = await fetchData();
        
        // Save to cache
        const cacheData: CacheData<T> = {
          data: freshData,
          timestamp: Date.now()
        };
        localStorage.setItem(key, JSON.stringify(cacheData));
        
        setData(freshData);
      } catch (err) {
        console.error(`Error loading ${key}:`, err);
        setError(`Failed to load ${key}`);
      } finally {
        setLoading(false);
      }
    }

    loadData();
  }, dependencies);

  return { data, loading, error };
}