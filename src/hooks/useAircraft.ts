import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import type { Aircraft } from '../types/aircraft';

export function useAircraft() {
  const [aircraft, setAircraft] = useState<Aircraft[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchAircraft();
  }, []);

  const fetchAircraft = async () => {
    try {
      const { data, error: supabaseError } = await supabase
        .from('aircraft')
        .select(`
          *,
          type:type_id(*),
          engine_type:engine_type_id(*),
          fuel_type:fuel_type_id(*)
        `)
        .order('created_at', { ascending: false });

      if (supabaseError) throw supabaseError;
      setAircraft(data || []);
    } catch (err) {
      console.error('Error fetching aircraft:', err);
      setError('Failed to load aircraft data');
    } finally {
      setLoading(false);
    }
  };

  const addAircraft = async (newAircraft: Omit<Aircraft, 'id' | 'user_id' | 'created_at' | 'updated_at'>) => {
    try {
      const { data, error: supabaseError } = await supabase
        .from('aircraft')
        .insert([newAircraft])
        .select(`
          *,
          type:type_id(*),
          engine_type:engine_type_id(*),
          fuel_type:fuel_type_id(*)
        `)
        .single();

      if (supabaseError) throw supabaseError;
      setAircraft(prev => [data, ...prev]);
      return data;
    } catch (err) {
      console.error('Error adding aircraft:', err);
      throw err;
    }
  };

  const updateAircraft = async (id: string, updates: Partial<Aircraft>) => {
    try {
      const { data, error: supabaseError } = await supabase
        .from('aircraft')
        .update(updates)
        .eq('id', id)
        .select(`
          *,
          type:type_id(*),
          engine_type:engine_type_id(*),
          fuel_type:fuel_type_id(*)
        `)
        .single();

      if (supabaseError) throw supabaseError;
      setAircraft(prev => prev.map(a => a.id === id ? data : a));
      return data;
    } catch (err) {
      console.error('Error updating aircraft:', err);
      throw err;
    }
  };

  const deleteAircraft = async (id: string) => {
    try {
      const { error: supabaseError } = await supabase
        .from('aircraft')
        .delete()
        .eq('id', id);

      if (supabaseError) throw supabaseError;
      setAircraft(prev => prev.filter(a => a.id !== id));
    } catch (err) {
      console.error('Error deleting aircraft:', err);
      throw err;
    }
  };

  return {
    aircraft,
    loading,
    error,
    addAircraft,
    updateAircraft,
    deleteAircraft,
    refresh: fetchAircraft
  };
}