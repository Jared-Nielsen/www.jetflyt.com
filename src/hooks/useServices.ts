import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { Service } from '../types/workOrder';

export function useServices() {
  const [services, setServices] = useState<Service[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchServices();
  }, []);

  const fetchServices = async () => {
    try {
      const { data, error: supabaseError } = await supabase
        .from('services')
        .select(`
          *,
          type:type_id(*)
        `)
        .order('name');

      if (supabaseError) throw supabaseError;
      setServices(data || []);
    } catch (err) {
      console.error('Error fetching services:', err);
      setError('Failed to load services');
    } finally {
      setLoading(false);
    }
  };

  return { services, loading, error };
}