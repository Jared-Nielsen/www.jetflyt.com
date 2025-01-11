import { useState } from 'react';
import { STLViewer } from './STLViewer';
import { Modal } from '../shared/Modal';
import { AircraftForm } from './AircraftForm';
import type { Aircraft } from '../../types/aircraft';
import { Pencil, MapPin } from 'lucide-react';
import { Link } from 'react-router-dom';

interface AircraftDetailsProps {
  aircraft: Aircraft;
  onClose: () => void;
  onAircraftUpdated: () => void;
}

export function AircraftDetails({ aircraft, onClose, onAircraftUpdated }: AircraftDetailsProps) {
  const [showEditModal, setShowEditModal] = useState(false);

  // Generate the filename that would be used for the STL file
  const getStlFilename = (name: string) => name.toLowerCase().replace(/[^a-z0-9]+/g, '_') + '.stl';

  return (
    <div className="bg-white shadow sm:rounded-lg">
      <div className="px-4 py-5 sm:p-6">
        <div className="flex justify-between items-start">
          <div>
            <h3 className="text-lg font-medium text-gray-900">Aircraft Details</h3>
            <div className="mt-2 text-sm text-gray-500">
              Registration: {aircraft.tail_number}
            </div>
          </div>
          <div className="flex items-center space-x-4">
            <button
              onClick={() => setShowEditModal(true)}
              className="flex items-center px-3 py-1 text-sm font-medium text-blue-600 hover:text-blue-500 border border-blue-600 rounded"
            >
              <Pencil className="h-4 w-4 mr-1" />
              Edit
            </button>
            <Link
              to="/fbos"
              className="flex items-center px-3 py-1 text-sm font-medium text-blue-600 hover:text-blue-500 border border-blue-600 rounded"
            >
              <MapPin className="h-4 w-4 mr-1" />
              View on Map
            </Link>
          </div>
        </div>

        <div className="mt-6 border-t border-gray-200 pt-6">
          <dl className="grid grid-cols-1 gap-x-4 gap-y-6 sm:grid-cols-2">
            <div>
              <dt className="text-sm font-medium text-gray-500">Aircraft Type</dt>
              <dd className="mt-1">
                <div className="text-sm text-gray-900">{aircraft.type?.name}</div>
                <div className="text-sm text-gray-500">{aircraft.type?.category}</div>
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">Manufacturer</dt>
              <dd className="mt-1">
                <div className="text-sm text-gray-900">{aircraft.manufacturer}</div>
                <div className="text-sm text-gray-500">{aircraft.model}</div>
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">Year</dt>
              <dd className="mt-1 text-sm text-gray-900">{aircraft.year}</dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">Engine Type</dt>
              <dd className="mt-1 text-sm text-gray-900">
                {aircraft.engine_type?.name}
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">Fuel Type</dt>
              <dd className="mt-1 text-sm text-gray-900">
                {aircraft.fuel_type?.name}
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">Fuel Capacity</dt>
              <dd className="mt-1 text-sm text-gray-900">
                {aircraft.fuel_capacity.toLocaleString()} gallons
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">Max Range</dt>
              <dd className="mt-1 text-sm text-gray-900">
                {aircraft.max_range.toLocaleString()} nm
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">Current Location</dt>
              <dd className="mt-1 text-sm text-gray-900">
                {aircraft.latitude.toFixed(4)}°, {aircraft.longitude.toFixed(4)}°
              </dd>
            </div>
          </dl>
        </div>

        {/* 3D Model Viewers */}
        <div className="mt-6 border-t border-gray-200 pt-6">
          <h4 className="text-sm font-medium text-gray-500 mb-4">3D Model Preview</h4>
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
            Close
          </button>
        </div>

        <Modal
          isOpen={showEditModal}
          onClose={() => setShowEditModal(false)}
          title="Edit Aircraft"
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