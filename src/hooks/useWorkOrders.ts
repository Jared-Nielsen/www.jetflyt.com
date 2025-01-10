import { useState, useCallback } from 'react';
import { supabase } from '../lib/supabase';
import type { WorkOrder } from '../types/workOrder';

export function useWorkOrders() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const createWorkOrder = useCallback(async (workOrderData: {
    aircraft_id: string;
    service_id: string;
    fbo_id: string;
    quantity: number;
    description: string;
    requested_date: string;
  }) => {
    try {
      setLoading(true);
      setError(null);

      const { data: workOrder, error: workOrderError } = await supabase
        .from('work_orders')
        .insert([{
          aircraft_id: workOrderData.aircraft_id,
          service_id: workOrderData.service_id,
          fbo_id: workOrderData.fbo_id,
          quantity: workOrderData.quantity,
          description: workOrderData.description,
          requested_date: workOrderData.requested_date,
          status: 'pending'
        }])
        .select()
        .single();

      if (workOrderError) throw workOrderError;
      return workOrder;
    } catch (err) {
      console.error('Error creating work order:', err);
      setError('Failed to create work order');
      throw err;
    } finally {
      setLoading(false);
    }
  }, []);

  const getWorkOrders = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);

      const { data, error: fetchError } = await supabase
        .from('work_orders')
        .select(`
          *,
          aircraft:aircraft_id(*),
          service:service_id(
            *,
            type:type_id(*)
          ),
          fbo:fbo_id(
            *,
            icao:icao_id(*)
          )
        `)
        .order('created_at', { ascending: false });

      if (fetchError) throw fetchError;
      return data;
    } catch (err) {
      console.error('Error fetching work orders:', err);
      setError('Failed to fetch work orders');
      throw err;
    } finally {
      setLoading(false);
    }
  }, []);

  return {
    loading,
    error,
    createWorkOrder,
    getWorkOrders
  };
}