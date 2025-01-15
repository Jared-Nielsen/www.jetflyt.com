import { useState, useEffect } from 'react';
import { Plus, Minus } from 'lucide-react';
import { FormField } from '../shared/FormField';
import { FormSelect } from '../shared/FormSelect';
import { useServices } from '../../hooks/useServices';
import { useAircraft } from '../../hooks/useAircraft';
import { useICAOData } from '../../hooks/useICAOData';
import { supabase } from '../../lib/supabase';
import type { Service } from '../../types/workOrder';
import type { FBO } from '../../types/fbo';
import type { ICAO } from '../../types/icao';

interface WorkOrderFormProps {
  initialData?: {
    aircraft_id: string;
    service_id: string;
    selected_fbos: string[];
    quantity: number;
    description: string;
    requested_date: string;
    arrival_date?: string;
    departure_date?: string;
    passenger_count: number;
    crew_count: number;
    pet_count: number;
  };
  onSubmit: (data: {
    aircraft_id: string;
    service_id: string;
    selected_fbos: string[];
    quantity: number;
    description: string;
    requested_date: string;
    arrival_date?: string;
    departure_date?: string;
    passenger_count: number;
    crew_count: number;
    pet_count: number;
  }) => Promise<void>;
  onCancel: () => void;
}

export function WorkOrderForm({ initialData, onSubmit, onCancel }: WorkOrderFormProps) {
  const { services, loading: servicesLoading } = useServices();
  const { aircraft, loading: aircraftLoading } = useAircraft();
  const { data: airports, loading: airportsLoading } = useICAOData();
  const [fbos, setFbos] = useState<FBO[]>([]);
  const [selectedAirport, setSelectedAirport] = useState<ICAO | null>(null);
  const [formData, setFormData] = useState({
    aircraft_id: initialData?.aircraft_id || '',
    service_id: initialData?.service_id || '',
    selected_fbos: initialData?.selected_fbos || [],
    quantity: initialData?.quantity?.toString() || '1',
    description: initialData?.description || '',
    requested_date: initialData?.requested_date ? new Date(initialData.requested_date).toISOString().slice(0, 16) : new Date().toISOString().slice(0, 16),
    arrival_date: initialData?.arrival_date ? new Date(initialData.arrival_date).toISOString().slice(0, 16) : '',
    departure_date: initialData?.departure_date ? new Date(initialData.departure_date).toISOString().slice(0, 16) : '',
    passenger_count: initialData?.passenger_count || 0,
    crew_count: initialData?.crew_count || 0,
    pet_count: initialData?.pet_count || 0
  });
  const [selectedService, setSelectedService] = useState<Service | null>(null);
  const [loading, setLoading] = useState(false);
  const [dateError, setDateError] = useState<string | null>(null);

  // Load FBOs for the selected airport
  useEffect(() => {
    if (selectedAirport) {
      const fetchFBOs = async () => {
        try {
          const { data, error } = await supabase
            .from('fbos')
            .select('*')
            .eq('icao_id', selectedAirport.id);

          if (error) throw error;
          setFbos(data || []);
        } catch (err) {
          console.error('Error fetching FBOs:', err);
        }
      };

      fetchFBOs();
    } else {
      setFbos([]);
    }
  }, [selectedAirport]);

  // Load initial service data
  useEffect(() => {
    if (initialData?.service_id && services.length > 0) {
      const service = services.find(s => s.id === initialData.service_id);
      setSelectedService(service || null);
    }
  }, [initialData?.service_id, services]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (loading) return;

    // Validate dates if both are provided
    if (formData.arrival_date && formData.departure_date) {
      const arrivalTime = new Date(formData.arrival_date).getTime();
      const departureTime = new Date(formData.departure_date).getTime();
      
      if (departureTime <= arrivalTime) {
        setDateError('Departure date must be after arrival date');
        return;
      }
    }

    // Validate at least one FBO is selected
    if (formData.selected_fbos.length === 0) {
      alert('Please select at least one FBO');
      return;
    }

    try {
      setLoading(true);
      await onSubmit({
        ...formData,
        quantity: parseInt(formData.quantity, 10)
      });
    } catch (err) {
      console.error('Form submission error:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleCountChange = (field: 'passenger_count' | 'crew_count' | 'pet_count', increment: boolean) => {
    setFormData(prev => ({
      ...prev,
      [field]: Math.max(0, prev[field] + (increment ? 1 : -1))
    }));
  };

  const CountField = ({ 
    label, 
    field, 
    value 
  }: { 
    label: string; 
    field: 'passenger_count' | 'crew_count' | 'pet_count'; 
    value: number;
  }) => (
    <div>
      <label className="block text-sm font-medium text-gray-700 mb-1">
        {label}
      </label>
      <div className="flex items-center space-x-2">
        <button
          type="button"
          onClick={() => handleCountChange(field, false)}
          className="p-2 rounded-full hover:bg-gray-100"
        >
          <Minus className="h-5 w-5 text-gray-600" />
        </button>
        <span className="w-12 text-center text-lg font-medium">{value}</span>
        <button
          type="button"
          onClick={() => handleCountChange(field, true)}
          className="p-2 rounded-full hover:bg-gray-100"
        >
          <Plus className="h-5 w-5 text-gray-600" />
        </button>
      </div>
    </div>
  );

  if (servicesLoading || aircraftLoading || airportsLoading) {
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
        value={selectedAirport?.id || ''}
        onChange={e => {
          const airport = airports?.find(a => a.id === e.target.value);
          setSelectedAirport(airport || null);
          setFormData(prev => ({ ...prev, selected_fbos: [] }));
        }}
        required
      >
        <option value="">Select airport</option>
        {airports?.map(airport => (
          <option key={airport.id} value={airport.id}>
            {airport.code} - {airport.name}
          </option>
        ))}
      </FormSelect>

      {fbos.length > 0 && (
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Select FBOs
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

      <FormSelect
        label="Service"
        value={formData.service_id}
        onChange={e => {
          const service = services.find(s => s.id === e.target.value);
          setSelectedService(service || null);
          setFormData(prev => ({ ...prev, service_id: e.target.value }));
        }}
        required
      >
        <option value="">Select service</option>
        {services.map(service => (
          <option key={service.id} value={service.id}>
            {service.name} - ${service.price}/unit
          </option>
        ))}
      </FormSelect>

      <FormField
        label="Quantity"
        type="number"
        min="1"
        value={formData.quantity}
        onChange={e => setFormData(prev => ({ ...prev, quantity: e.target.value }))}
        required
      />

      <FormField
        label="Description"
        type="textarea"
        value={formData.description}
        onChange={e => setFormData(prev => ({ ...prev, description: e.target.value }))}
        required
      />

      <FormField
        label="Requested Date"
        type="datetime-local"
        value={formData.requested_date}
        onChange={e => setFormData(prev => ({ ...prev, requested_date: e.target.value }))}
        required
      />
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <FormField
          label="Arrival Date (Optional)"
          type="datetime-local"
          value={formData.arrival_date}
          onChange={e => {
            setFormData(prev => ({ ...prev, arrival_date: e.target.value }));
            setDateError(null);
          }}
        />

        <FormField
          label="Departure Date (Optional)"
          type="datetime-local"
          value={formData.departure_date}
          onChange={e => {
            setFormData(prev => ({ ...prev, departure_date: e.target.value }));
            setDateError(null);
          }}
        />
      </div>

      {dateError && (
        <div className="text-sm text-red-600">
          {dateError}
        </div>
      )}

      <div className="border-t border-gray-200 pt-6">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <CountField 
            label="Passengers" 
            field="passenger_count" 
            value={formData.passenger_count} 
          />
          <CountField 
            label="Crew" 
            field="crew_count" 
            value={formData.crew_count} 
          />
          <CountField 
            label="Pets" 
            field="pet_count" 
            value={formData.pet_count} 
          />
        </div>
      </div>

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
          disabled={loading || formData.selected_fbos.length === 0}
          className="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50"
        >
          {loading ? 'Creating...' : 'Create Work Order'}
        </button>
      </div>
    </form>
  );
}