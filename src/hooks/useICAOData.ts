import { supabase } from '../lib/supabase';
import type { ICAO } from '../types/icao';
import { STORAGE_KEYS } from '../utils/storage';
import { useLocalStorageCache } from './useLocalStorageCache';

export function useICAOData() {
  const fetchICAOs = async () => {
    let allData: any[] = [];
    let page = 0;
    const pageSize = 1000;
    let hasMore = true;

    while (hasMore) {
      const { data, error } = await supabase
        .from('icaos')
        .select(`
          *,
          icao_type:icao_type_id (
            id,
            name,
            description
          )
        `)
        .range(page * pageSize, (page + 1) * pageSize - 1)
        .order('code');

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

  return useLocalStorageCache<ICAO[]>(STORAGE_KEYS.ICAOS, fetchICAOs);
}