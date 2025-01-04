import React, { useState, useEffect } from 'react';
import { useAircraftTypes } from '../../hooks/useAircraftTypes';
import { useAircraftEngineTypes } from '../../hooks/useAircraftEngineTypes';
import { useFuelTypes } from '../../hooks/useFuelTypes';
import { FormField } from './FormField';
import { FormSelect } from './FormSelect';
import { CoordinatesField } from './CoordinatesField';
import type { Aircraft } from '../../types/aircraft';

interface AircraftFormProps {
  onSubmit: (data: Omit<Aircraft, 'id' | 'user_id' | 'created_at' | 'updated_at'>) => Promise<void>;
  initialData?: Aircraft;
  onCancel: () => void;
}

export function AircraftForm({ onSubmit, initialData, onCancel }: AircraftFormProps) {
  const { types: aircraftTypes, loading: typesLoading } = useAircraftTypes();
  const { types: engineTypes, loading: engineTypesLoading } = useAircraftEngineTypes();
  const { types: fuelTypes, loading: fuelTypesLoading } = useFuelTypes();
  
  const [formData, setFormData] = useState({
    tail_number: initialData?.tail_number || '',
    type_id: initialData?.type_id || '',
    manufacturer: initialData?.manufacturer || '',
    model: initialData?.model || '',
    year: initialData?.year?.toString() || new Date().getFullYear().toString(),
    max_range: initialData?.max_range?.toString() || '5000',
    fuel_type_id: initialData?.fuel_type_id || '',
    fuel_capacity: initialData?.fuel_capacity?.toString() || '0',
    engine_type_id: initialData?.engine_type_id || '',
    latitude: initialData?.latitude?.toString() || '29.9902',
    longitude: initialData?.longitude?.toString() || '-95.3368'
  });

  // Update manufacturer when aircraft type changes
  useEffect(() => {
    if (formData.type_id) {
      const selectedType = aircraftTypes.find(t => t.id === formData.type_id);
      if (selectedType) {
        setFormData(prev => ({
          ...prev,
          manufacturer: selectedType.manufacturer
        }));
      }
    }
  }, [formData.type_id, aircraftTypes]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await onSubmit({
      ...formData,
      year: parseInt(formData.year),
      max_range: parseInt(formData.max_range),
      fuel_capacity: parseInt(formData.fuel_capacity),
      latitude: parseFloat(formData.latitude),
      longitude: parseFloat(formData.longitude)
    });
  };

  const handleCoordinateChange = (field: 'latitude' | 'longitude', value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const isLoading = typesLoading || engineTypesLoading || fuelTypesLoading;
  if (isLoading) {
    return <div className="p-4">Loading...</div>;
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Existing form fields */}
        <FormField
          label="Tail Number"
          name="tail_number"
          value={formData.tail_number}
          onChange={e => setFormData(prev => ({ ...prev, tail_number: e.target.value }))}
          required
        />

        <FormSelect
          label="Aircraft Type"
          value={formData.type_id}
          onChange={e => setFormData(prev => ({ ...prev, type_id: e.target.value }))}
          required
        >
          <option value="">Select aircraft type</option>
          {aircraftTypes.map(type => (
            <option key={type.id} value={type.id}>
              {type.manufacturer} {type.name} - {type.category}
            </option>
          ))}
        </FormSelect>

        {/* Other existing fields... */}

        {/* Add coordinates field */}
        <CoordinatesField
          latitude={formData.latitude}
          longitude={formData.longitude}
          onChange={handleCoordinateChange}
        />
      </div>

      <div className="flex justify-end space-x-4 pt-6">
        <button
          type="button"
          onClick={onCancel}
          className="px-6 py-3 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
        >
          Cancel
        </button>
        <button
          type="submit"
          className="px-6 py-3 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
        >
          {initialData ? 'Update' : 'Add'} Aircraft
        </button>
      </div>
    </form>
  );
}