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

      console.log('Creating tender with data:', { tenderData, selectedFBOs });

      // Get current user's ID
      const { data: { user }, error: userError } = await supabase.auth.getUser();
      if (userError) {
        console.error('Error getting user:', userError);
        throw userError;
      }
      if (!user) {
        throw new Error('No authenticated user found');
      }

      // First, create the tender record
      const { data: tender, error: tenderError } = await supabase
        .from('tenders')
        .insert([{
          aircraft_id: tenderData.aircraft_id,
          icao_id: tenderData.icao_id,
          gallons: tenderData.gallons,
          target_price: tenderData.target_price,
          description: tenderData.description,
          status: 'pending',
          auth_id: user.id
        }])
        .select()
        .single();

      if (tenderError) {
        console.error('Error creating tender record:', tenderError);
        throw tenderError;
      }

      console.log('Created tender:', tender);

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

        console.log('Creating FBO tenders:', fboTenders);

        const { error: fboError } = await supabase
          .from('fbo_tenders')
          .insert(fboTenders);

        if (fboError) {
          console.error('Error creating FBO tenders:', fboError);
          throw fboError;
        }

        console.log('Created FBO tenders successfully');
      }

      return tender;
    } catch (err) {
      console.error('Error in createTender:', err);
      setError(err instanceof Error ? err.message : 'Failed to create tender');
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
      status?: string;
      start_date?: string;
      end_date?: string;
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

      console.log('Accepting offer:', { offerId, tenderId });

      // Use a transaction to ensure all updates happen atomically
      const { data, error } = await supabase.rpc('accept_tender_offer', {
        p_tender_id: tenderId,
        p_offer_id: offerId
      });

      if (error) {
        console.error('Supabase error:', error);
        throw error;
      }

      console.log('Offer accepted successfully:', data);
      return data;
    } catch (err) {
      console.error('Error accepting offer:', err);
      setError(err instanceof Error ? err.message : 'Failed to accept offer');
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

      // Update all FBO tenders first
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

  const cancelFBOTender = async (fboTenderId: string) => {
    try {
      setLoading(true);
      setError(null);

      const { error } = await supabase.rpc('cancel_fbo_tender', {
        p_fbo_tender_id: fboTenderId
      });

      if (error) throw error;

    } catch (err) {
      console.error('Error canceling FBO tender:', err);
      setError(err instanceof Error ? err.message : 'Failed to cancel FBO tender');
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
    cancelTender,
    cancelFBOTender
  };
}