import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { Route } from '../types/trip';

export function useRoutes(tripId: string) {
  const [routes, setRoutes] = useState<Route[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (tripId) {
      fetchRoutes();
    }
  }, [tripId]);

  const fetchRoutes = async () => {
    try {
      const { data, error: supabaseError } = await supabase
        .from('routes')
        .select(`
          *,
          transit_type:transit_types(*),
          legs:legs(
            *,
            origin:origin_id(id, code, name, latitude, longitude),
            destination:destination_id(id, code, name, latitude, longitude)
          )
        `)
        .eq('trip_id', tripId)
        .order('created_at', { ascending: true });

      if (supabaseError) throw supabaseError;
      setRoutes(data || []);
    } catch (err) {
      console.error('Error fetching routes:', err);
      setError('Failed to load routes');
    } finally {
      setLoading(false);
    }
  };

  return { routes, loading, error, refetch: fetchRoutes };
}