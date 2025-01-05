import { useState } from 'react';
import { useTrip } from '../../hooks/useTrip';
import { Modal } from '../shared/Modal';
import { TripForm } from './TripForm';
import type { Trip } from '../../types/trip';

interface AddTripModalProps {
  isOpen: boolean;
  onClose: () => void;
  onTripAdded: () => void;
}

export function AddTripModal({ isOpen, onClose, onTripAdded }: AddTripModalProps) {
  const [error, setError] = useState<string | null>(null);
  const { createTrip } = useTrip();

  const handleSubmit = async (tripData: Omit<Trip, 'id' | 'auth_id' | 'created_at' | 'updated_at'>) => {
    try {
      setError(null);
      await createTrip(tripData);
      await onTripAdded();
      onClose();
    } catch (err) {
      console.error('Error adding trip:', err);
      setError('Failed to create trip');
    }
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="Add New Trip">
      {error && (
        <div className="mb-4 p-2 bg-red-50 text-red-700 rounded">
          {error}
        </div>
      )}
      <TripForm onSubmit={handleSubmit} onCancel={onClose} />
    </Modal>
  );
}