import { Pencil } from 'lucide-react';
import { useState } from 'react';
import { TripStatus } from './TripStatus';
import { EditTripModal } from './EditTripModal';
import type { Trip } from '../../types/trip';

interface TripCardProps {
  trip: Trip;
  onEdit: () => void;
  onTripUpdated: () => void;
}

export function TripCard({ trip, onEdit, onTripUpdated }: TripCardProps) {
  const [showEditModal, setShowEditModal] = useState(false);

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
              className="text-sm text-gray-600 hover:text-gray-900 flex items-center space-x-1"
            >
              <Pencil className="h-4 w-4" />
              <span>Edit</span>
            </button>
            {trip.status !== 'active' && (
              <button
                onClick={onEdit}
                className="text-sm text-blue-600 hover:text-blue-500"
              >
                Set Active
              </button>
            )}
          </div>
        </div>
      </div>

      <EditTripModal
        isOpen={showEditModal}
        onClose={() => setShowEditModal(false)}
        trip={trip}
        onTripUpdated={onTripUpdated}
      />
    </>
  );
}