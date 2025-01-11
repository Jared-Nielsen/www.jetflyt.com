import React, { useState } from 'react';
import { Pencil, Trash2, MapPin } from 'lucide-react';
import { Link } from 'react-router-dom';
import type { Aircraft } from '../../types/aircraft';
import { AircraftDetails } from './AircraftDetails';

interface AircraftListProps {
  aircraft: Aircraft[];
  onEdit: (aircraft: Aircraft) => void;
  onDelete: (id: string) => void;
}

export function AircraftList({ aircraft, onEdit, onDelete }: AircraftListProps) {
  const [selectedAircraft, setSelectedAircraft] = useState<Aircraft | null>(null);

  if (aircraft.length === 0) {
    return (
      <div className="text-center py-8">
        <p className="text-gray-500">No aircraft registered yet.</p>
      </div>
    );
  }

  if (selectedAircraft) {
    return (
      <AircraftDetails 
        aircraft={selectedAircraft}
        onClose={() => setSelectedAircraft(null)}
        onAircraftUpdated={() => {
          onEdit(selectedAircraft);
          setSelectedAircraft(null);
        }}
      />
    );
  }

  return (
    <div className="overflow-x-auto">
      <table className="min-w-full divide-y divide-gray-200">
        <thead className="bg-gray-50">
          <tr>
            <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Tail Number
            </th>
            <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Aircraft
            </th>
            <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Year
            </th>
            <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Range & Fuel
            </th>
            <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Engine
            </th>
            <th scope="col" className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
              Actions
            </th>
          </tr>
        </thead>
        <tbody className="bg-white divide-y divide-gray-200">
          {aircraft.map((aircraft) => (
            <tr 
              key={aircraft.id}
              onClick={() => setSelectedAircraft(aircraft)}
              className="hover:bg-gray-50 cursor-pointer"
            >
              <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                {aircraft.tail_number}
              </td>
              <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                <div>{aircraft.manufacturer} {aircraft.model}</div>
                <div className="text-xs text-gray-400">{aircraft.type?.name}</div>
              </td>
              <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                {aircraft.year}
              </td>
              <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                <div>{aircraft.max_range} nm</div>
                <div className="text-xs text-gray-400">
                  {aircraft.fuel_capacity} gal {aircraft.fuel_type?.name}
                </div>
              </td>
              <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                {aircraft.engine_type?.name}
              </td>
              <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                <Link
                  to="/fbos"
                  className="text-blue-600 hover:text-blue-900 mr-4"
                  title="View on map"
                  onClick={(e) => e.stopPropagation()}
                >
                  <MapPin className="h-4 w-4" />
                </Link>
                <button
                  onClick={(e) => {
                    e.stopPropagation();
                    onEdit(aircraft);
                  }}
                  className="text-blue-600 hover:text-blue-900 mr-4"
                >
                  <Pencil className="h-4 w-4" />
                </button>
                <button
                  onClick={(e) => {
                    e.stopPropagation();
                    onDelete(aircraft.id);
                  }}
                  className="text-red-600 hover:text-red-900"
                >
                  <Trash2 className="h-4 w-4" />
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}