import { useState } from 'react';
import { Modal } from '../shared/Modal';
import { TripForm } from './TripForm';
import { useTranslation } from 'react-i18next';

interface AddTripModalProps {
  isOpen: boolean;
  onClose: () => void;
  onTripAdded: () => void;
}

export function AddTripModal({ isOpen, onClose, onTripAdded }: AddTripModalProps) {
  const [error, setError] = useState<string | null>(null);
  const { t } = useTranslation();

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title={t('trip.form.title.new')}
    >
      {error && (
        <div className="mb-4 p-2 bg-red-50 text-red-700 rounded">
          {error}
        </div>
      )}
      <TripForm
        onSubmit={async (data) => {
          try {
            await onTripAdded();
            onClose();
          } catch (err) {
            console.error('Error adding trip:', err);
            setError(t('trip.errors.saveFailed'));
          }
        }}
        onCancel={onClose}
      />
    </Modal>
  );
}