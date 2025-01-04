import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { AircraftEngineType } from '../types/aircraft';

export function useAircraftEngineTypes() {
  const [types, setTypes] = useState<AircraftEngineType[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchTypes() {
      try {
        const { data, error: supabaseError } = await supabase
          .from('aircraft_engine_types')
          .select('*')
          .order('name', { ascending: true });

        if (supabaseError) throw supabaseError;
        setTypes(data || []);
      } catch (err) {
        console.error('Error fetching engine types:', err);
        setError('Failed to load engine types');
      } finally {
        setLoading(false);
      }
    }

    fetchTypes();
  }, []);

  return { types, loading, error };
}