import { useState } from 'react';
import { FormField } from '../shared/FormField';
import type { Trip } from '../../types/trip';

interface TripFormProps {
  initialData?: Trip;
  onSubmit: (data: Omit<Trip, 'id' | 'auth_id' | 'created_at' | 'updated_at'>) => Promise<void>;
  onCancel: () => void;
}

export function TripForm({ initialData, onSubmit, onCancel }: TripFormProps) {
  const [formData, setFormData] = useState({
    name: initialData?.name || '',
    description: initialData?.description || '',
    start_date: initialData?.start_date || new Date().toISOString().slice(0, 16),
    end_date: initialData?.end_date || new Date(Date.now() + 3600000).toISOString().slice(0, 16),
    status: initialData?.status || 'planned'
  });

  const handleStartDateChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const startDate = new Date(e.target.value);
    const endDate = new Date(startDate.getTime() + 3600000); // Add 1 hour (3600000 milliseconds)
    
    setFormData(prev => ({
      ...prev,
      start_date: e.target.value,
      end_date: endDate.toISOString().slice(0, 16)
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    await onSubmit(formData);
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <FormField
        label="Trip Name"
        name="name"
        value={formData.name}
        onChange={e => setFormData(prev => ({ ...prev, name: e.target.value }))}
        required
      />

      <FormField
        label="Description"
        name="description"
        type="textarea"
        value={formData.description}
        onChange={e => setFormData(prev => ({ ...prev, description: e.target.value }))}
      />

      <div className="grid grid-cols-2 gap-4">
        <FormField
          label="Start Date"
          name="start_date"
          type="datetime-local"
          value={formData.start_date}
          onChange={handleStartDateChange}
          required
        />

        <FormField
          label="End Date"
          name="end_date"
          type="datetime-local"
          value={formData.end_date}
          onChange={e => setFormData(prev => ({ ...prev, end_date: e.target.value }))}
        />
      </div>

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
          {initialData ? 'Update' : 'Create'} Trip
        </button>
      </div>
    </form>
  );
}