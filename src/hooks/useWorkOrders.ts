import { useState, useCallback } from 'react';
import { supabase } from '../lib/supabase';
import type { WorkOrder } from '../types/workOrder';

export function useWorkOrders() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const getWorkOrders = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);

      const { data: workOrders, error: workOrdersError } = await supabase
        .from('work_orders')
        .select(`
          *,
          aircraft:aircraft_id(*),
          service:service_id(
            *,
            type:type_id(*)
          ),
          fbo_associations:work_order_fbos(
            id,
            price,
            status,
            created_at,
            fbo:fbo_id(
              *,
              icao:icao_id(*)
            )
          )
        `)
        .order('created_at', { ascending: false });

      if (workOrdersError) throw workOrdersError;

      return workOrders;
    } catch (err) {
      console.error('Error fetching work orders:', err);
      setError('Failed to fetch work orders');
      throw err;
    } finally {
      setLoading(false);
    }
  }, []);

  const createWorkOrder = useCallback(async (workOrderData: {
    aircraft_id: string;
    service_id: string;
    selected_fbos: string[];
    quantity: number;
    description: string;
    requested_date: string;
    arrival_date?: string;
    departure_date?: string;
    passenger_count?: number;
    crew_count?: number;
    pet_count?: number;
  }) => {
    try {
      setLoading(true);
      setError(null);

      // First create the work order
      const { data: workOrder, error: workOrderError } = await supabase
        .from('work_orders')
        .insert([{
          aircraft_id: workOrderData.aircraft_id,
          service_id: workOrderData.service_id,
          quantity: workOrderData.quantity,
          description: workOrderData.description,
          requested_date: workOrderData.requested_date,
          arrival_date: workOrderData.arrival_date,
          departure_date: workOrderData.departure_date,
          passenger_count: workOrderData.passenger_count,
          crew_count: workOrderData.crew_count,
          pet_count: workOrderData.pet_count,
          status: 'pending'
        }])
        .select()
        .single();

      if (workOrderError) throw workOrderError;

      // Then create the FBO associations
      const fboAssociations = workOrderData.selected_fbos.map(fboId => ({
        work_order_id: workOrder.id,
        fbo_id: fboId,
        status: 'pending'
      }));

      const { error: fboError } = await supabase
        .from('work_order_fbos')
        .insert(fboAssociations);

      if (fboError) throw fboError;

      return workOrder;
    } catch (err) {
      console.error('Error creating work order:', err);
      setError('Failed to create work order');
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