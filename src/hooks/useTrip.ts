import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { Trip } from '../types/trip';

export function useTrip() {
  const [activeTrip, setActiveTrip] = useState<Trip | null>(null);
  const [trips, setTrips] = useState<Trip[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchTrips();
  }, []);

  const fetchTrips = async () => {
    try {
      setError(null);
      // Fetch all trips for the user
      const { data: allTrips, error: tripsError } = await supabase
        .from('trips')
        .select('*')
        .order('created_at', { ascending: false });

      if (tripsError) throw tripsError;
      setTrips(allTrips || []);

      // Find active trip
      const active = allTrips?.find(trip => trip.status === 'active') || null;
      setActiveTrip(active);
    } catch (err) {
      console.error('Error fetching trips:', err);
      setError('Failed to load trips');
    } finally {
      setLoading(false);
    }
  };

  const createTrip = async (tripData: Omit<Trip, 'id' | 'auth_id' | 'created_at' | 'updated_at'>) => {
    try {
      setError(null);
      const { data, error: createError } = await supabase
        .from('trips')
        .insert([tripData])
        .select()
        .single();

      if (createError) throw createError;
      
      // If this is the first trip, set it as active
      if (!activeTrip) {
        const { error: updateError } = await supabase
          .from('trips')
          .update({ status: 'active' })
          .eq('id', data.id);

        if (updateError) throw updateError;
      }
      
      await fetchTrips();
      return data;
    } catch (err) {
      console.error('Error creating trip:', err);
      throw err;
    }
  };

  const setTripActive = async (tripId: string) => {
    try {
      setError(null);
      // First, set all trips to planned
      await supabase
        .from('trips')
        .update({ status: 'planned' })
        .neq('id', tripId);

      // Then set the selected trip as active
      const { error: updateError } = await supabase
        .from('trips')
        .update({ status: 'active' })
        .eq('id', tripId);

      if (updateError) throw updateError;
      await fetchTrips();
    } catch (err) {
      console.error('Error setting trip active:', err);
      throw err;
    }
  };

  return { 
    activeTrip,
    trips,
    loading, 
    error,
    refetch: fetchTrips,
    createTrip,
    setTripActive
  };
}