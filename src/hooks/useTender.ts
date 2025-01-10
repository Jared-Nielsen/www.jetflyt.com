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
          description: tenderData.description,
          status: 'pending'
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
          taxes_and_fees: 0,
          status: 'pending'
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

  const updateTender = async (
    tenderId: string,
    updates: {
      gallons?: number;
      target_price?: number;
      description?: string;
    }
  ) => {
    try {
      setLoading(true);
      setError(null);

      const { error: updateError } = await supabase
        .from('tenders')
        .update(updates)
        .eq('id', tenderId);

      if (updateError) throw updateError;

      // If price changed, update all pending FBO tenders
      if (updates.target_price || updates.gallons) {
        const { data: fboTenders, error: fetchError } = await supabase
          .from('fbo_tenders')
          .select('*')
          .eq('tender_id', tenderId)
          .eq('status', 'pending');

        if (fetchError) throw fetchError;

        if (fboTenders) {
          const fboUpdates = fboTenders.map(fboTender => ({
            ...fboTender,
            offer_price: updates.target_price || fboTender.offer_price,
            total_cost: (updates.target_price || fboTender.offer_price) * (updates.gallons || fboTender.total_cost / fboTender.offer_price)
          }));

          const { error: fboUpdateError } = await supabase
            .from('fbo_tenders')
            .upsert(fboUpdates);

          if (fboUpdateError) throw fboUpdateError;
        }
      }
    } catch (err) {
      console.error('Error updating tender:', err);
      setError('Failed to update tender');
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
            fbo:fbos(
              id, 
              name,
              icao:icaos(
                code,
                name
              )
            ),
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

  const acceptOffer = async (offerId: string, tenderId: string) => {
    try {
      setLoading(true);
      setError(null);

      // First update the FBO tender
      const { error: offerError } = await supabase
        .from('fbo_tenders')
        .update({ status: 'accepted' })
        .eq('id', offerId);

      if (offerError) throw offerError;

      // Then update the tender
      const { error: tenderError } = await supabase
        .from('tenders')
        .update({ status: 'accepted' })
        .eq('id', tenderId);

      if (tenderError) throw tenderError;

      // Finally update all other FBO tenders to rejected
      const { error: rejectError } = await supabase
        .from('fbo_tenders')
        .update({ status: 'rejected' })
        .eq('tender_id', tenderId)
        .neq('id', offerId);

      if (rejectError) throw rejectError;

    } catch (err) {
      console.error('Error accepting offer:', err);
      setError('Failed to accept offer');
      throw err;
    } finally {
      setLoading(false);
    }
  };

  const cancelTender = async (tenderId: string) => {
    try {
      setLoading(true);
      setError(null);

      // First verify the tender is in pending status
      const { data: tender, error: fetchError } = await supabase
        .from('tenders')
        .select('status')
        .eq('id', tenderId)
        .single();

      if (fetchError) throw fetchError;
      if (!tender) throw new Error('Tender not found');
      if (tender.status !== 'pending') {
        throw new Error('Only pending tenders can be cancelled');
      }

      // First update all FBO tenders
      const { error: fboError } = await supabase
        .from('fbo_tenders')
        .update({ status: 'cancelled' })
        .eq('tender_id', tenderId);

      if (fboError) throw fboError;

      // Then update the tender itself
      const { error: tenderError } = await supabase
        .from('tenders')
        .update({ status: 'cancelled' })
        .eq('id', tenderId);

      if (tenderError) throw tenderError;

    } catch (err) {
      console.error('Error cancelling tender:', err);
      setError(err instanceof Error ? err.message : 'Failed to cancel tender');
      throw err;
    } finally {
      setLoading(false);
    }
  };

  return {
    loading,
    error,
    createTender,
    updateTender,
    getTenders,
    acceptOffer,
    cancelTender
  };
}