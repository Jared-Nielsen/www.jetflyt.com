import { supabase } from '../lib/supabase';
import type { ICAO } from '../types/icao';
import { STORAGE_KEYS } from '../utils/storage';
import { useLocalStorageCache } from './useLocalStorageCache';

export function useICAOData() {
  const fetchICAOs = async () => {
    const { data, error } = await supabase
      .from('icaos')
      .select('*')
      .order('code');
    
    if (error) throw error;
    if (!data) throw new Error('No data received from the database');
    
    return data;
  };

  return useLocalStorageCache<ICAO[]>(STORAGE_KEYS.ICAOS, fetchICAOs);
}