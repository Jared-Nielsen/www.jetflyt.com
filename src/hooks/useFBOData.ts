import { supabase } from '../lib/supabase';
import type { FBO } from '../types/fbo';
import { STORAGE_KEYS } from '../utils/storage';
import { useLocalStorageCache } from './useLocalStorageCache';

export function useFBOData() {
  const fetchFBOs = async () => {
    let allData: any[] = [];
    let page = 0;
    const pageSize = 1000;
    let hasMore = true;

    while (hasMore) {
      const { data, error } = await supabase
        .from('fbos')
        .select(`
          id,
          name,
          latitude,
          longitude,
          address,
          country,
          state,
          icao:icaos (
            id,
            code,
            name
          )
        `)
        .range(page * pageSize, (page + 1) * pageSize - 1);

      if (error) throw error;
      if (!data || data.length === 0) {
        hasMore = false;
      } else {
        allData = [...allData, ...data];
        page++;
      }
    }

    if (allData.length === 0) {
      throw new Error('No data received from the database');
    }

    return allData;
  };

  return useLocalStorageCache<FBO[]>(STORAGE_KEYS.FBOS, fetchFBOs);
}