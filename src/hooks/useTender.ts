import { useState } from 'react';
import { supabase } from '../lib/supabase';
import type { Tender, FBOTender } from '../types/tender';

export function useTender() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const createTender = async (
    tenderData: {
      aircraft_id: string;
      icao_id: string;
      gallons: number;
      target_price: number;
      description: string;
    },
    selectedFBOs: string[]
  ) => {
    try {
      setLoading(true);
      setError(null);

      // First, create the tender record
      const { data: tender, error: tenderError } = await supabase
        .from('tenders')
        .insert([{
          aircraft_id: tenderData.aircraft_id,
          icao_id: tenderData.icao_id,
          gallons: tenderData.gallons,
          target_price: tenderData.target_price,
          description: tenderData.description
        }])
        .select()
        .single();

      if (tenderError) throw tenderError;

      // Then create FBO tender records
      if (selectedFBOs.length > 0) {
        const fboTenders = selectedFBOs.map(fboId => ({
          tender_id: tender.id,
          fbo_id: fboId,
          offer_price: tenderData.target_price,
          total_cost: tenderData.target_price * tenderData.gallons,
          taxes_and_fees: 0
        }));

        const { error: fboError } = await supabase
          .from('fbo_tenders')
          .insert(fboTenders);

        if (fboError) throw fboError;
      }

      return tender;
    } catch (err) {
      console.error('Error creating tender:', err);
      setError('Failed to create tender');
      throw err;
    } finally {
      setLoading(false);
    }
  };

  const getTenders = async () => {
    try {
      setLoading(true);
      setError(null);

      const { data, error: fetchError } = await supabase
        .from('tenders')
        .select(`
          *,
          aircraft:aircraft_id(
            tail_number,
            manufacturer,
            model
          ),
          icao:icao_id(
            code,
            name
          ),
          fbo_tenders(
            id,
            fbo_id,
            fbo:fbos(id, name),
            offer_price,
            total_cost,
            taxes_and_fees,
            counter_price,
            counter_total_cost,
            counter_taxes_and_fees,
            status,
            description
          )
        `)
        .order('created_at', { ascending: false });

      if (fetchError) throw fetchError;
      return data;
    } catch (err) {
      console.error('Error fetching tenders:', err);
      setError('Failed to fetch tenders');
      throw err;
    } finally {
      setLoading(false);
    }
  };

  return {
    loading,
    error,
    createTender,
    getTenders
  };
}