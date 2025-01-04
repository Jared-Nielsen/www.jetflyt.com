import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { TransitType } from '../types/trip';

export function useTransitTypes() {
  const [transitTypes, setTransitTypes] = useState<TransitType[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchTransitTypes();
  }, []);

  const fetchTransitTypes = async () => {
    try {
      const { data, error: supabaseError } = await supabase
        .from('transit_types')
        .select('*')
        .order('name');

      if (supabaseError) throw supabaseError;
      setTransitTypes(data || []);
    } catch (err) {
      console.error('Error fetching transit types:', err);
      setError('Failed to load transit types');
    } finally {
      setLoading(false);
    }
  };

  return { transitTypes, loading, error };
}