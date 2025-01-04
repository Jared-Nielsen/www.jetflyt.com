import { useState } from 'react';
import { Modal } from '../shared/Modal';
import { RouteForm } from './RouteForm';
import { supabase } from '../../lib/supabase';
import type { Route } from '../../types/trip';

interface AddRouteModalProps {
  isOpen: boolean;
  onClose: () => void;
  tripId: string;
  onRouteAdded: () => void;
}

export function AddRouteModal({ isOpen, onClose, tripId, onRouteAdded }: AddRouteModalProps) {
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (routeData: Omit<Route, 'id' | 'auth_id' | 'created_at' | 'updated_at' | 'legs'>) => {
    try {
      setError(null);
      const { error: supabaseError } = await supabase
        .from('routes')
        .insert([{ ...routeData, trip_id: tripId }]);

      if (supabaseError) throw supabaseError;
      onRouteAdded();
      onClose();
    } catch (err) {
      console.error('Error adding route:', err);
      setError('Failed to create route');
    }
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="Add New Route">
      {error && (
        <div className="mb-4 p-2 bg-red-50 text-red-700 rounded">
          {error}
        </div>
      )}
      <RouteForm onSubmit={handleSubmit} onCancel={onClose} />
    </Modal>
  );
}