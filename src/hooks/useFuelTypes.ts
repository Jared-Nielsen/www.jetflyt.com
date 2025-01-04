import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { FuelType } from '../types/aircraft';

export function useFuelTypes() {
  const [types, setTypes] = useState<FuelType[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchTypes() {
      try {
        const { data, error: supabaseError } = await supabase
          .from('fuel_types')
          .select('*')
          .order('name', { ascending: true });

        if (supabaseError) throw supabaseError;
        setTypes(data || []);
      } catch (err) {
        console.error('Error fetching fuel types:', err);
        setError('Failed to load fuel types');
      } finally {
        setLoading(false);
      }
    }

    fetchTypes();
  }, []);

  return { types, loading, error };
}