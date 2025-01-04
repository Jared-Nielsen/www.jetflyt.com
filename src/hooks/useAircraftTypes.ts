import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { AircraftType } from '../types/aircraft';

export function useAircraftTypes() {
  const [types, setTypes] = useState<AircraftType[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchTypes() {
      try {
        const { data, error: supabaseError } = await supabase
          .from('aircraft_types')
          .select('*')
          .order('manufacturer', { ascending: true });

        if (supabaseError) throw supabaseError;
        setTypes(data || []);
      } catch (err) {
        console.error('Error fetching aircraft types:', err);
        setError('Failed to load aircraft types');
      } finally {
        setLoading(false);
      }
    }

    fetchTypes();
  }, []);

  return { types, loading, error };
}