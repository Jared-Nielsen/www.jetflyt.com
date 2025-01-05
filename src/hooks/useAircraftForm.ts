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
    year: initialData?.year?.toString() || new Date().getFullYear().toString(),
    max_range: initialData?.max_range?.toString() || '5000',
    fuel_type_id: initialData?.fuel_type_id || '',
    fuel_capacity: initialData?.fuel_capacity?.toString() || '0',
    engine_type_id: initialData?.engine_type_id || '',
    latitude: initialData?.latitude?.toString() || '29.9902',
    longitude: initialData?.longitude?.toString() || '-95.3368'
  });

  const [error, setError] = useState<string | null>(null);

  const validateForm = (): boolean => {
    if (!formData.tail_number.trim()) {
      setError('Tail number is required');
      return false;
    }

    if (!formData.type_id) {
      setError('Aircraft type is required');
      return false;
    }

    if (!formData.manufacturer.trim()) {
      setError('Manufacturer is required');
      return false;
    }

    if (!formData.model.trim()) {
      setError('Model is required');
      return false;
    }

    if (!formData.fuel_type_id) {
      setError('Fuel type is required');
      return false;
    }

    if (!formData.engine_type_id) {
      setError('Engine type is required');
      return false;
    }

    setError(null);
    return true;
  };

  const getFormattedData = () => ({
    tail_number: formData.tail_number.trim(),
    type_id: formData.type_id,
    manufacturer: formData.manufacturer.trim(),
    model: formData.model.trim(),
    year: parseInt(formData.year),
    max_range: parseInt(formData.max_range),
    fuel_type_id: formData.fuel_type_id,
    fuel_capacity: parseInt(formData.fuel_capacity),
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