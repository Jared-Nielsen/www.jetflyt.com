import { useState } from 'react';
import { STLViewer } from './STLViewer';
import { Modal } from '../shared/Modal';
import { AircraftForm } from './AircraftForm';
import type { Aircraft } from '../../types/aircraft';
import { Pencil, MapPin } from 'lucide-react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

interface AircraftDetailsProps {
  aircraft: Aircraft;
  onClose: () => void;
  onAircraftUpdated: () => void;
}

export function AircraftDetails({ aircraft, onClose, onAircraftUpdated }: AircraftDetailsProps) {
  const [showEditModal, setShowEditModal] = useState(false);
  const { t } = useTranslation();

  // Format coordinates with null checks
  const formatCoordinates = () => {
    if (aircraft.latitude === null || aircraft.longitude === null) {
      return t('fleet.details.locationNotSet');
    }
    return `${aircraft.latitude.toFixed(4)}°, ${aircraft.longitude.toFixed(4)}°`;
  };

  return (
    <div className="bg-white shadow sm:rounded-lg">
      <div className="px-4 py-5 sm:p-6">
        <div className="flex justify-between items-start">
          <div>
            <h3 className="text-lg font-medium text-gray-900">{t('fleet.details.title')}</h3>
            <div className="mt-2 text-sm text-gray-500">
              {t('fleet.details.registration')}: {aircraft.tail_number}
            </div>
          </div>
          <div className="flex items-center space-x-4">
            <button
              onClick={() => setShowEditModal(true)}
              className="flex items-center px-3 py-1 text-sm font-medium text-blue-600 hover:text-blue-500 border border-blue-600 rounded"
            >
              <Pencil className="h-4 w-4 mr-1" />
              {t('fleet.details.edit')}
            </button>
            <Link
              to="/fbos"
              className="flex items-center px-3 py-1 text-sm font-medium text-blue-600 hover:text-blue-500 border border-blue-600 rounded"
            >
              <MapPin className="h-4 w-4 mr-1" />
              {t('fleet.details.viewOnMap')}
            </Link>
          </div>
        </div>

        <div className="mt-6 border-t border-gray-200 pt-6">
          <dl className="grid grid-cols-1 gap-x-4 gap-y-6 sm:grid-cols-2">
            <div>
              <dt className="text-sm font-medium text-gray-500">{t('fleet.details.aircraftType')}</dt>
              <dd className="mt-1">
                <div className="text-sm text-gray-900">{aircraft.type?.name}</div>
                <div className="text-sm text-gray-500">{aircraft.type?.category}</div>
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">{t('fleet.details.manufacturer')}</dt>
              <dd className="mt-1">
                <div className="text-sm text-gray-900">{aircraft.manufacturer}</div>
                <div className="text-sm text-gray-500">{aircraft.model || t('common.notAvailable')}</div>
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">{t('fleet.details.year')}</dt>
              <dd className="mt-1 text-sm text-gray-900">
                {aircraft.year || t('common.notAvailable')}
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">{t('fleet.details.engineType')}</dt>
              <dd className="mt-1 text-sm text-gray-900">
                {aircraft.engine_type?.name || t('common.notAvailable')}
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">{t('fleet.details.fuelType')}</dt>
              <dd className="mt-1 text-sm text-gray-900">
                {aircraft.fuel_type?.name || t('common.notAvailable')}
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">{t('fleet.details.fuelCapacity')}</dt>
              <dd className="mt-1 text-sm text-gray-900">
                {aircraft.fuel_capacity ? `${aircraft.fuel_capacity.toLocaleString()} gal` : t('common.notAvailable')}
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">{t('fleet.details.maxRange')}</dt>
              <dd className="mt-1 text-sm text-gray-900">
                {aircraft.max_range ? `${aircraft.max_range.toLocaleString()} nm` : t('common.notAvailable')}
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">{t('fleet.details.currentLocation')}</dt>
              <dd className="mt-1 text-sm text-gray-900">
                {formatCoordinates()}
              </dd>
            </div>
          </dl>
        </div>

        {/* 3D Model Viewers */}
        <div className="mt-6 border-t border-gray-200 pt-6">
          <h4 className="text-sm font-medium text-gray-500 mb-4">{t('fleet.details.modelPreview')}</h4>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* Aircraft Type Model */}
            <div className="flex flex-col items-center bg-gray-50 rounded-lg p-4">
              <STLViewer 
                modelName={aircraft.type?.name || ''} 
                width={300} 
                height={300}
              />
            </div>
          </div>
        </div>

        <div className="mt-6 flex justify-end border-t border-gray-200 pt-4">
          <button
            type="button"
            onClick={onClose}
            className="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50"
          >
            {t('common.close')}
          </button>
        </div>

        <Modal
          isOpen={showEditModal}
          onClose={() => setShowEditModal(false)}
          title={t('fleet.form.edit')}
        >
          <AircraftForm
            initialData={aircraft}
            onSubmit={async (data) => {
              await onAircraftUpdated();
              setShowEditModal(false);
              onClose();
            }}
            onCancel={() => setShowEditModal(false)}
          />
        </Modal>
      </div>
    </div>
  );
}