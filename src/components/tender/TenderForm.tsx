import { useState, useEffect } from 'react';
import { useAircraft } from '../../hooks/useAircraft';
import { useICAOData } from '../../hooks/useICAOData';
import { FormField } from '../shared/FormField';
import { FormSelect } from '../shared/FormSelect';
import { supabase } from '../../lib/supabase';
import type { FBO } from '../../types/fbo';
import type { Tender } from '../../types/tender';

interface TenderFormProps {
  initialData?: Tender;
  onSubmit: (data: {
    aircraft_id: string;
    icao_id: string;
    gallons: number;
    target_price: number;
    description: string;
    selected_fbos: string[];
    start_date: string;
    end_date?: string;
  }) => Promise<void>;
  onCancel: () => void;
}

export function TenderForm({ initialData, onSubmit, onCancel }: TenderFormProps) {
  const { aircraft, loading: aircraftLoading } = useAircraft();
  const { data: airports, loading: airportsLoading } = useICAOData();
  const [fbos, setFBOs] = useState<FBO[]>([]);
  const [loading, setLoading] = useState(false);
  const [dateError, setDateError] = useState<string | null>(null);
  const [isAnnual, setIsAnnual] = useState(false);
  const [formData, setFormData] = useState({
    aircraft_id: initialData?.aircraft_id || '',
    icao_id: initialData?.icao_id || '',
    gallons: initialData?.gallons.toString() || '',
    target_price: initialData?.target_price.toString() || '',
    description: initialData?.description || '',
    selected_fbos: [] as string[],
    start_date: initialData?.start_date ? new Date(initialData.start_date).toISOString().slice(0, 16) : new Date().toISOString().slice(0, 16),
    end_date: initialData?.end_date ? new Date(initialData.end_date).toISOString().slice(0, 16) : ''
  });

  // Fetch FBOs when ICAO is selected
  useEffect(() => {
    if (!formData.icao_id) {
      setFBOs([]);
      return;
    }

    const fetchFBOs = async () => {
      try {
        const { data, error } = await supabase
          .from('fbos')
          .select('*')
          .eq('icao_id', formData.icao_id);

        if (error) throw error;
        setFBOs(data || []);
      } catch (err) {
        console.error('Error fetching FBOs:', err);
      }
    };

    fetchFBOs();
  }, [formData.icao_id]);

  const handleStartDateChange = (date: string) => {
    setFormData(prev => {
      const newData = { ...prev, start_date: date };
      if (isAnnual) {
        const startDate = new Date(date);
        const endDate = new Date(startDate);
        endDate.setFullYear(endDate.getFullYear() + 1);
        newData.end_date = endDate.toISOString().slice(0, 16);
      }
      return newData;
    });
    setDateError(null);
  };

  const handleAnnualClick = () => {
    setIsAnnual(true);
    const startDate = new Date(formData.start_date);
    const endDate = new Date(startDate);
    endDate.setFullYear(endDate.getFullYear() + 1);
    setFormData(prev => ({
      ...prev,
      end_date: endDate.toISOString().slice(0, 16)
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (loading) return;

    // Validate dates if end date is provided
    if (formData.end_date) {
      const startTime = new Date(formData.start_date).getTime();
      const endTime = new Date(formData.end_date).getTime();
      
      if (endTime <= startTime) {
        setDateError('End date must be after start date');
        return;
      }
    }

    try {
      setLoading(true);
      await onSubmit({
        ...formData,
        gallons: Number(formData.gallons),
        target_price: Number(formData.target_price)
      });
    } finally {
      setLoading(false);
    }
  };

  if (aircraftLoading || airportsLoading) {
    return <div>Loading...</div>;
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <FormSelect
        label="Aircraft"
        value={formData.aircraft_id}
        onChange={e => setFormData(prev => ({ ...prev, aircraft_id: e.target.value }))}
        required
        disabled={Boolean(initialData)}
      >
        <option value="">Select aircraft</option>
        {aircraft?.map(a => (
          <option key={a.id} value={a.id}>
            {a.tail_number} - {a.type?.name || 'Unknown Type'}
          </option>
        ))}
      </FormSelect>

      <FormSelect
        label="Airport"
        value={formData.icao_id}
        onChange={e => setFormData(prev => ({ ...prev, icao_id: e.target.value }))}
        required
        disabled={Boolean(initialData)}
      >
        <option value="">Select airport</option>
        {airports?.map(airport => (
          <option key={airport.id} value={airport.id}>
            {airport.code} - {airport.name}
          </option>
        ))}
      </FormSelect>

      <div className="grid grid-cols-2 gap-4">
        <FormField
          label="Gallons Required"
          type="number"
          min="1"
          step="1"
          value={formData.gallons}
          onChange={e => setFormData(prev => ({ ...prev, gallons: e.target.value }))}
          required
        />

        <FormField
          label="Best Current Price"
          type="number"
          min="0.01"
          step="0.01"
          value={formData.target_price}
          onChange={e => setFormData(prev => ({ ...prev, target_price: e.target.value }))}
          required
        />
      </div>

      <div className="space-y-4">
        <div className="flex justify-end">
          <button
            type="button"
            onClick={handleAnnualClick}
            className={`px-4 py-2 rounded-md text-sm font-medium ${
              isAnnual 
                ? 'bg-green-600 text-white hover:bg-green-700' 
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            }`}
          >
            Annual
          </button>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <FormField
            label="Start Date"
            type="datetime-local"
            value={formData.start_date}
            onChange={e => handleStartDateChange(e.target.value)}
            required
          />

          <FormField
            label="End Date (Optional)"
            type="datetime-local"
            value={formData.end_date}
            onChange={e => {
              setFormData(prev => ({ ...prev, end_date: e.target.value }));
              setDateError(null);
              setIsAnnual(false);
            }}
          />
        </div>
      </div>

      {dateError && (
        <div className="text-sm text-red-600">
          {dateError}
        </div>
      )}

      <FormField
        label="Description"
        type="textarea"
        value={formData.description}
        onChange={e => setFormData(prev => ({ ...prev, description: e.target.value }))}
      />

      {fbos.length > 0 && !initialData && (
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Select FBOs to Send Tender
          </label>
          <div className="space-y-2 border rounded-md p-3">
            {fbos.map(fbo => (
              <label key={fbo.id} className="flex items-center space-x-2">
                <input
                  type="checkbox"
                  checked={formData.selected_fbos.includes(fbo.id)}
                  onChange={e => {
                    setFormData(prev => ({
                      ...prev,
                      selected_fbos: e.target.checked
                        ? [...prev.selected_fbos, fbo.id]
                        : prev.selected_fbos.filter(id => id !== fbo.id)
                    }));
                  }}
                  className="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                />
                <span className="text-sm text-gray-900">{fbo.name}</span>
              </label>
            ))}
          </div>
        </div>
      )}

      <div className="flex justify-end space-x-4">
        <button
          type="button"
          onClick={onCancel}
          className="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50"
        >
          Cancel
        </button>
        <button
          type="submit"
          disabled={loading || (!initialData && formData.selected_fbos.length === 0)}
          className="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50"
        >
          {loading ? 'Saving...' : (initialData ? 'Update Tender' : 'Create Tender')}
        </button>
      </div>
    </form>
  );
}