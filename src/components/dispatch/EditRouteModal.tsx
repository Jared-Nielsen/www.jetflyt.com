import { useState } from 'react';
import { Modal } from '../shared/Modal';
import { RouteForm } from './RouteForm';
import { supabase } from '../../lib/supabase';
import type { Route } from '../../types/trip';

interface EditRouteModalProps {
  isOpen: boolean;
  onClose: () => void;
  route: Route;
  onRouteUpdated: () => void;
}

export function EditRouteModal({ isOpen, onClose, route, onRouteUpdated }: EditRouteModalProps) {
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (routeData: Omit<Route, 'id' | 'auth_id' | 'created_at' | 'updated_at' | 'legs'>) => {
    try {
      setError(null);
      const { error: updateError } = await supabase
        .from('routes')
        .update(routeData)
        .eq('id', route.id);

      if (updateError) throw updateError;
      onRouteUpdated();
      onClose();
    } catch (err) {
      console.error('Error updating route:', err);
      setError('Failed to update route');
    }
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="Edit Route">
      {error && (
        <div className="mb-4 p-2 bg-red-50 text-red-700 rounded">
          {error}
        </div>
      )}
      <RouteForm 
        initialData={route}
        onSubmit={handleSubmit} 
        onCancel={onClose} 
      />
    </Modal>
  );
}