import { supabase } from '../lib/supabase';
import type { FBO } from '../types/fbo';
import { STORAGE_KEYS } from '../utils/storage';
import { useLocalStorageCache } from './useLocalStorageCache';

export function useFBOData() {
  const fetchFBOs = async () => {
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
      `);
    
    if (error) throw error;
    if (!data) throw new Error('No data received from the database');
    
    return data;
  };

  return useLocalStorageCache<FBO[]>(STORAGE_KEYS.FBOS, fetchFBOs);
}