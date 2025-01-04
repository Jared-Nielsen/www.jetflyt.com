import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { Leg } from '../types/trip';

export function useLegs(routeId: string) {
  const [legs, setLegs] = useState<Leg[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (routeId) {
      fetchLegs();
    }
  }, [routeId]);

  const fetchLegs = async () => {
    try {
      const { data, error: supabaseError } = await supabase
        .from('legs')
        .select(`
          *,
          origin:origin_id(id, code, name, latitude, longitude),
          destination:destination_id(id, code, name, latitude, longitude)
        `)
        .eq('route_id', routeId)
        .order('scheduled_departure', { ascending: true });

      if (supabaseError) throw supabaseError;
      setLegs(data || []);
    } catch (err) {
      console.error('Error fetching legs:', err);
      setError('Failed to load legs');
    } finally {
      setLoading(false);
    }
  };

  return { legs, loading, error, refetch: fetchLegs };
}