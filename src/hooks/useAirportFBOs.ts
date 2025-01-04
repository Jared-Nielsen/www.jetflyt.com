import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { FBO } from '../types/fbo';

export function useAirportFBOs(icaoId: string) {
  const [fbos, setFbos] = useState<FBO[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchFBOs() {
      try {
        const { data, error: supabaseError } = await supabase
          .from('fbos')
          .select(`
            id,
            name,
            latitude,
            longitude,
            address,
            country,
            state
          `)
          .eq('icao_id', icaoId);

        if (supabaseError) throw supabaseError;
        setFbos(data || []);
      } catch (err) {
        console.error('Error fetching FBOs:', err);
        setError('Failed to load FBO data');
      } finally {
        setLoading(false);
      }
    }

    if (icaoId) {
      fetchFBOs();
    }
  }, [icaoId]);

  return { fbos, loading, error };
}