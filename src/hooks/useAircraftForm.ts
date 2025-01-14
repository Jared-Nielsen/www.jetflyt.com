import { useState } from 'react';
import type { Aircraft } from '../types/aircraft';

interface FormState {
  tail_number: string;
  type_id: string;
  manufacturer: string;
  model: string;
  year: string;
  max_range: string;
  fuel_type_id: string;
  fuel_capacity: string;
  engine_type_id: string;
  latitude: string;
  longitude: string;
}

export function useAircraftForm(initialData?: Aircraft) {
  const [formData, setFormData] = useState<FormState>({
    tail_number: initialData?.tail_number || '',
    type_id: initialData?.type_id || '',
    manufacturer: initialData?.manufacturer || '',
    model: initialData?.model || '',
    year: initialData?.year?.toString() || '',
    max_range: initialData?.max_range?.toString() || '',
    fuel_type_id: initialData?.fuel_type_id || '',
    fuel_capacity: initialData?.fuel_capacity?.toString() || '',
    engine_type_id: initialData?.engine_type_id || '',
    latitude: initialData?.latitude?.toString() || '29.9902',
    longitude: initialData?.longitude?.toString() || '-95.3368'
  });

  const [error, setError] = useState<string | null>(null);

  const validateForm = (): boolean => {
    // Reset error
    setError(null);

    // Required field validation
    const requiredFields: Array<{ field: keyof FormState; label: string }> = [
      { field: 'tail_number', label: 'Tail number' },
      { field: 'type_id', label: 'Aircraft type' },
      { field: 'manufacturer', label: 'Manufacturer' },
      { field: 'fuel_type_id', label: 'Fuel type' },
      { field: 'engine_type_id', label: 'Engine type' }
    ];

    for (const { field, label } of requiredFields) {
      if (!formData[field]?.trim()) {
        setError(`${label} is required`);
        return false;
      }
    }

    // Numeric field validation
    const numericFields: Array<{ field: keyof FormState; label: string; min?: number; max?: number; required?: boolean }> = [
      { field: 'year', label: 'Year', min: 1900, max: new Date().getFullYear(), required: false },
      { field: 'max_range', label: 'Max range', min: 0, required: false },
      { field: 'fuel_capacity', label: 'Fuel capacity', min: 0, required: false },
      { field: 'latitude', label: 'Latitude', min: -90, max: 90 },
      { field: 'longitude', label: 'Longitude', min: -180, max: 180 }
    ];

    for (const { field, label, min, max, required } of numericFields) {
      // Skip empty non-required fields
      if (!required && !formData[field]) {
        continue;
      }
      
      const value = Number(formData[field]);
      if (isNaN(value)) {
        setError(`${label} must be a valid number`);
        return false;
      }
      if (min !== undefined && value < min) {
        setError(`${label} must be at least ${min}`);
        return false;
      }
      if (max !== undefined && value > max) {
        setError(`${label} must be no more than ${max}`);
        return false;
      }
    }

    return true;
  };

  const getFormattedData = () => ({
    tail_number: formData.tail_number.trim().toUpperCase(),
    type_id: formData.type_id,
    manufacturer: formData.manufacturer.trim(),
    model: formData.model.trim() || null,
    year: formData.year ? parseInt(formData.year) : null,
    max_range: formData.max_range ? parseInt(formData.max_range) : null,
    fuel_type_id: formData.fuel_type_id,
    fuel_capacity: formData.fuel_capacity ? parseInt(formData.fuel_capacity) : null,
    engine_type_id: formData.engine_type_id,
    latitude: parseFloat(formData.latitude),
    longitude: parseFloat(formData.longitude)
  });

  return {
    formData,
    setFormData,
    error,
    setError,
    validateForm,
    getFormattedData
  };
}