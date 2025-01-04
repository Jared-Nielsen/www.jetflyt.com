import { useState } from 'react';
import { Modal } from '../shared/Modal';
import { LegForm } from './LegForm';
import { supabase } from '../../lib/supabase';
import type { Leg } from '../../types/trip';
import { useTrip } from '../../hooks/useTrip';

interface AddLegModalProps {
  isOpen: boolean;
  onClose: () => void;
  routeId: string;
  onLegAdded: () => void;
}

export function AddLegModal({ isOpen, onClose, routeId, onLegAdded }: AddLegModalProps) {
  const [error, setError] = useState<string | null>(null);
  const { refetch: refetchTrip } = useTrip();

  const handleSubmit = async (legData: Omit<Leg, 'id' | 'auth_id' | 'created_at' | 'updated_at'>) => {
    try {
      setError(null);
      const { error: supabaseError } = await supabase
        .from('legs')
        .insert([{ ...legData, route_id: routeId }]);

      if (supabaseError) throw supabaseError;
      
      // Refresh both the routes list and active trip data
      onLegAdded();
      await refetchTrip();
      
      onClose();
    } catch (err) {
      console.error('Error adding leg:', err);
      setError('Failed to create leg');
    }
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="Add New Leg">
      {error && (
        <div className="mb-4 p-2 bg-red-50 text-red-700 rounded">
          {error}
        </div>
      )}
      <LegForm onSubmit={handleSubmit} onCancel={onClose} />
    </Modal>
  );
}