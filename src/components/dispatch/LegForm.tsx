import { useState } from 'react';
import { FormField } from '../shared/FormField';
import { FormSelect } from '../shared/FormSelect';
import { useICAOData } from '../../hooks/useICAOData';
import type { Leg } from '../../types/trip';

interface LegFormProps {
  initialData?: Leg;
  onSubmit: (data: Omit<Leg, 'id' | 'auth_id' | 'created_at' | 'updated_at'>) => Promise<void>;
  onCancel: () => void;
}

export function LegForm({ initialData, onSubmit, onCancel }: LegFormProps) {
  const { data: airports, loading } = useICAOData();
  const [formData, setFormData] = useState({
    origin_id: initialData?.origin_id || '',
    destination_id: initialData?.destination_id || '',
    scheduled_departure: initialData?.scheduled_departure 
      ? new Date(initialData.scheduled_departure).toISOString().slice(0, 16)
      : new Date().toISOString().slice(0, 16),
    scheduled_arrival: initialData?.scheduled_arrival
      ? new Date(initialData.scheduled_arrival).toISOString().slice(0, 16)
      : new Date(Date.now() + 3600000).toISOString().slice(0, 16), // Default to 1 hour later
    status: initialData?.status || 'scheduled',
    notes: initialData?.notes || ''
  });
  const [validationError, setValidationError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validate times
    const departureTime = new Date(formData.scheduled_departure).getTime();
    const arrivalTime = new Date(formData.scheduled_arrival).getTime();
    
    if (arrivalTime <= departureTime) {
      setValidationError('Scheduled arrival must be after scheduled departure');
      return;
    }

    // Validate airports
    if (formData.origin_id === formData.destination_id) {
      setValidationError('Origin and destination airports must be different');
      return;
    }

    setValidationError(null);
    await onSubmit({
      ...formData,
      scheduled_departure: new Date(formData.scheduled_departure).toISOString(),
      scheduled_arrival: new Date(formData.scheduled_arrival).toISOString()
    });
  };

  if (loading) {
    return <div>Loading airports...</div>;
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      {validationError && (
        <div className="p-2 text-sm text-red-700 bg-red-50 rounded">
          {validationError}
        </div>
      )}

      <div className="grid grid-cols-2 gap-4">
        <FormSelect
          label="Origin"
          value={formData.origin_id}
          onChange={e => setFormData(prev => ({ ...prev, origin_id: e.target.value }))}
          required
        >
          <option value="">Select origin</option>
          {airports?.map(airport => (
            <option key={airport.id} value={airport.id}>
              {airport.code} - {airport.name}
            </option>
          ))}
        </FormSelect>

        <FormSelect
          label="Destination"
          value={formData.destination_id}
          onChange={e => setFormData(prev => ({ ...prev, destination_id: e.target.value }))}
          required
        >
          <option value="">Select destination</option>
          {airports?.map(airport => (
            <option key={airport.id} value={airport.id}>
              {airport.code} - {airport.name}
            </option>
          ))}
        </FormSelect>
      </div>

      <div className="grid grid-cols-2 gap-4">
        <FormField
          label="Scheduled Departure"
          name="scheduled_departure"
          type="datetime-local"
          value={formData.scheduled_departure}
          onChange={e => {
            setFormData(prev => ({ ...prev, scheduled_departure: e.target.value }));
            setValidationError(null);
          }}
          required
        />

        <FormField
          label="Scheduled Arrival"
          name="scheduled_arrival"
          type="datetime-local"
          value={formData.scheduled_arrival}
          onChange={e => {
            setFormData(prev => ({ ...prev, scheduled_arrival: e.target.value }));
            setValidationError(null);
          }}
          required
        />
      </div>

      <FormField
        label="Notes"
        name="notes"
        type="textarea"
        value={formData.notes}
        onChange={e => setFormData(prev => ({ ...prev, notes: e.target.value }))}
      />

      <div className="flex justify-end space-x-4 pt-4">
        <button
          type="button"
          onClick={onCancel}
          className="px-4 py-2 border border-gray-300 rounded shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50"
        >
          Cancel
        </button>
        <button
          type="submit"
          className="px-4 py-2 border border-transparent rounded shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700"
        >
          {initialData ? 'Update' : 'Create'} Leg
        </button>
      </div>
    </form>
  );
}