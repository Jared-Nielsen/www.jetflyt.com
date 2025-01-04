import { useState } from 'react';
import { Modal } from '../shared/Modal';
import { TripForm } from './TripForm';
import { supabase } from '../../lib/supabase';
import type { Trip } from '../../types/trip';

interface EditTripModalProps {
  isOpen: boolean;
  onClose: () => void;
  trip: Trip;
  onTripUpdated: () => void;
}

export function EditTripModal({ isOpen, onClose, trip, onTripUpdated }: EditTripModalProps) {
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (tripData: Omit<Trip, 'id' | 'auth_id' | 'created_at' | 'updated_at'>) => {
    try {
      setError(null);
      const { error: updateError } = await supabase
        .from('trips')
        .update(tripData)
        .eq('id', trip.id);

      if (updateError) throw updateError;
      onTripUpdated();
      onClose();
    } catch (err) {
      console.error('Error updating trip:', err);
      setError('Failed to update trip');
    }
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="Edit Trip">
      {error && (
        <div className="mb-4 p-2 bg-red-50 text-red-700 rounded">
          {error}
        </div>
      )}
      <TripForm 
        initialData={trip}
        onSubmit={handleSubmit} 
        onCancel={onClose} 
      />
    </Modal>
  );
}