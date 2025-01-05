import { useState, useEffect, useCallback } from 'react';
import { supabase } from '../lib/supabase';
import type { Trip } from '../types/trip';

const MAX_RETRIES = 3;
const RETRY_DELAY = 1000; // 1 second

export function useTrip() {
  const [activeTrip, setActiveTrip] = useState<Trip | null>(null);
  const [trips, setTrips] = useState<Trip[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchTrips = useCallback(async (retryCount = 0) => {
    try {
      setError(null);
      
      // Fetch all trips for the user
      const { data: allTrips, error: tripsError } = await supabase
        .from('trips')
        .select('*')
        .order('created_at', { ascending: false });

      if (tripsError) {
        throw tripsError;
      }

      setTrips(allTrips || []);

      // Find active trip
      const active = allTrips?.find(trip => trip.status === 'active') || null;
      setActiveTrip(active);
      
    } catch (err) {
      console.error('Error fetching trips:', err);
      
      // Retry logic
      if (retryCount < MAX_RETRIES) {
        setTimeout(() => {
          fetchTrips(retryCount + 1);
        }, RETRY_DELAY * Math.pow(2, retryCount)); // Exponential backoff
        return;
      }

      setError('Failed to load trips. Please try again.');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchTrips();
  }, [fetchTrips]);

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
      
      return data;
    } catch (err) {
      console.error('Error creating trip:', err);
      setError('Failed to create trip. Please try again.');
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
      await fetchTrips(); // Refresh trips after status change
    } catch (err) {
      console.error('Error setting trip active:', err);
      setError('Failed to update trip status. Please try again.');
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