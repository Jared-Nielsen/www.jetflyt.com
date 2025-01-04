import { useState } from 'react';
import { Modal } from '../shared/Modal';
import { LegForm } from './LegForm';
import { supabase } from '../../lib/supabase';
import type { Leg } from '../../types/trip';

interface EditLegModalProps {
  isOpen: boolean;
  onClose: () => void;
  leg: Leg;
  onLegUpdated: () => void;
}

export function EditLegModal({ isOpen, onClose, leg, onLegUpdated }: EditLegModalProps) {
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (legData: Omit<Leg, 'id' | 'auth_id' | 'created_at' | 'updated_at'>) => {
    try {
      setError(null);
      const { error: updateError } = await supabase
        .from('legs')
        .update(legData)
        .eq('id', leg.id);

      if (updateError) throw updateError;
      onLegUpdated();
      onClose();
    } catch (err) {
      console.error('Error updating leg:', err);
      setError('Failed to update leg');
    }
  };

  return (
    <Modal isOpen={isOpen} onClose={onClose} title="Edit Leg">
      {error && (
        <div className="mb-4 p-2 bg-red-50 text-red-700 rounded">
          {error}
        </div>
      )}
      <LegForm 
        initialData={leg}
        onSubmit={handleSubmit} 
        onCancel={onClose} 
      />
    </Modal>
  );
}