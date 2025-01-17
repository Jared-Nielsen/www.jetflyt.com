import { useState } from 'react';
import { Modal } from '../shared/Modal';
import { TripStatus } from './TripStatus';
import { TripForm } from './TripForm';
import { useTrip } from '../../hooks/useTrip';
import type { Trip } from '../../types/trip';
import { useTranslation } from 'react-i18next';

interface TripCardProps {
  trip: Trip;
  onEdit: () => void;
  onTripUpdated: () => void;
}

export function TripCard({ trip, onEdit, onTripUpdated }: TripCardProps) {
  const [showEditModal, setShowEditModal] = useState(false);
  const { t } = useTranslation();

  return (
    <>
      <div className="bg-white shadow rounded-lg p-6">
        <div className="flex items-center justify-between mb-4">
          <div>
            <h3 className="text-lg font-medium text-gray-900">{trip.name}</h3>
            {trip.description && (
              <p className="mt-1 text-sm text-gray-500">{trip.description}</p>
            )}
          </div>
          <TripStatus status={trip.status} />
        </div>

        <div className="flex items-center justify-between">
          <div className="text-sm text-gray-500">
            {new Date(trip.start_date).toLocaleDateString()}
            {trip.end_date && (
              <> → {new Date(trip.end_date).toLocaleDateString()}</>
            )}
          </div>
          <div className="flex items-center space-x-4">
            <button
              onClick={() => setShowEditModal(true)}
              className="text-sm text-gray-600 hover:text-gray-900"
            >
              {t('trip.form.buttons.edit')}
            </button>
            {trip.status !== 'active' && (
              <button
                onClick={onEdit}
                className="text-sm text-blue-600 hover:text-blue-500"
              >
                {t('trip.status.setActive')}
              </button>
            )}
          </div>
        </div>
      </div>

      <Modal
        isOpen={showEditModal}
        onClose={() => setShowEditModal(false)}
        title={t('trip.form.title.edit')}
      >
        <TripForm
          initialData={trip}
          onSubmit={async (data) => {
            await onTripUpdated();
            setShowEditModal(false);
          }}
          onCancel={() => setShowEditModal(false)}
        />
      </Modal>
    </>
  );
}