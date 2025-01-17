import { useState } from 'react';
import { FormField } from '../shared/FormField';
import { FormSelect } from '../shared/FormSelect';
import { Plus, Minus } from 'lucide-react';
import { useServices } from '../../hooks/useServices';
import { useAircraft } from '../../hooks/useAircraft';
import { useICAOData } from '../../hooks/useICAOData';
import { supabase } from '../../lib/supabase';
import type { Service } from '../../types/workOrder';
import type { FBO } from '../../types/fbo';
import type { ICAO } from '../../types/icao';
import { useTranslation } from 'react-i18next';

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
  const { t } = useTranslation();
  
  const [fbos, setFbos] = useState<FBO[]>([]);
  const [selectedAirport, setSelectedAirport] = useState<ICAO | null>(null);
  const [selectedService, setSelectedService] = useState<Service | null>(null);
  const [loading, setLoading] = useState(false);
  const [dateError, setDateError] = useState<string | null>(null);

  // Initialize form data with current date/time for requested_date
  const now = new Date();
  now.setMinutes(now.getMinutes() - now.getTimezoneOffset()); // Adjust for timezone
  const defaultDateTime = now.toISOString().slice(0, 16);

  const [formData, setFormData] = useState({
    aircraft_id: initialData?.aircraft_id || '',
    service_id: initialData?.service_id || '',
    selected_fbos: initialData?.selected_fbos || [],
    quantity: initialData?.quantity?.toString() || '1',
    description: initialData?.description || '',
    requested_date: initialData?.requested_date ? new Date(initialData.requested_date).toISOString().slice(0, 16) : defaultDateTime,
    arrival_date: initialData?.arrival_date ? new Date(initialData.arrival_date).toISOString().slice(0, 16) : '',
    departure_date: initialData?.departure_date ? new Date(initialData.departure_date).toISOString().slice(0, 16) : '',
    passenger_count: initialData?.passenger_count || 0,
    crew_count: initialData?.crew_count || 0,
    pet_count: initialData?.pet_count || 0
  });

  // Load FBOs for the selected airport
  const loadFBOs = async (icaoId: string) => {
    try {
      const { data, error } = await supabase
        .from('fbos')
        .select('*')
        .eq('icao_id', icaoId);

      if (error) throw error;
      setFbos(data || []);
    } catch (err) {
      console.error('Error fetching FBOs:', err);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (loading) return;

    // Validate dates
    if (formData.arrival_date && formData.departure_date) {
      const arrivalTime = new Date(formData.arrival_date).getTime();
      const departureTime = new Date(formData.departure_date).getTime();
      
      if (departureTime <= arrivalTime) {
        setDateError(t('handling.form.errors.invalidDates'));
        return;
      }
    }

    // Validate at least one FBO is selected
    if (formData.selected_fbos.length === 0) {
      alert(t('handling.form.errors.noFboSelected'));
      return;
    }

    // Validate required date
    if (!formData.requested_date) {
      alert(t('handling.form.errors.noRequestedDate'));
      return;
    }

    try {
      setLoading(true);
      setDateError(null);

      // Ensure all dates are valid ISO strings
      const submissionData = {
        ...formData,
        quantity: parseInt(formData.quantity, 10),
        requested_date: new Date(formData.requested_date).toISOString(),
        arrival_date: formData.arrival_date ? new Date(formData.arrival_date).toISOString() : undefined,
        departure_date: formData.departure_date ? new Date(formData.departure_date).toISOString() : undefined
      };

      await onSubmit(submissionData);
    } catch (err) {
      console.error('Form submission error:', err);
      alert(t('handling.form.errors.submissionFailed'));
    } finally {
      setLoading(false);
    }
  };

  if (servicesLoading || aircraftLoading || airportsLoading) {
    return <div>{t('common.loading')}</div>;
  }

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
          onClick={() => setFormData(prev => ({
            ...prev,
            [field]: Math.max(0, prev[field] - 1)
          }))}
          className="p-2 rounded-full hover:bg-gray-100"
        >
          <Minus className="h-5 w-5 text-gray-600" />
        </button>
        <span className="w-12 text-center text-lg font-medium">{value}</span>
        <button
          type="button"
          onClick={() => setFormData(prev => ({
            ...prev,
            [field]: prev[field] + 1
          }))}
          className="p-2 rounded-full hover:bg-gray-100"
        >
          <Plus className="h-5 w-5 text-gray-600" />
        </button>
      </div>
    </div>
  );

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <FormSelect
        label={t('handling.form.fields.aircraft')}
        value={formData.aircraft_id}
        onChange={e => setFormData(prev => ({ ...prev, aircraft_id: e.target.value }))}
        required
      >
        <option value="">{t('handling.form.fields.selectAircraft')}</option>
        {aircraft?.map(a => (
          <option key={a.id} value={a.id}>
            {a.tail_number} - {a.type?.name || 'Unknown Type'}
          </option>
        ))}
      </FormSelect>

      <FormSelect
        label={t('handling.form.fields.airport')}
        value={selectedAirport?.id || ''}
        onChange={e => {
          const airport = airports?.find(a => a.id === e.target.value);
          setSelectedAirport(airport || null);
          if (airport) {
            loadFBOs(airport.id);
          }
          setFormData(prev => ({ ...prev, selected_fbos: [] }));
        }}
        required
      >
        <option value="">{t('handling.form.fields.selectAirport')}</option>
        {airports?.map(airport => (
          <option key={airport.id} value={airport.id}>
            {airport.code} - {airport.name}
          </option>
        ))}
      </FormSelect>

      <FormSelect
        label={t('handling.form.fields.service')}
        value={formData.service_id}
        onChange={e => {
          const service = services.find(s => s.id === e.target.value);
          setSelectedService(service || null);
          setFormData(prev => ({ ...prev, service_id: e.target.value }));
        }}
        required
      >
        <option value="">{t('handling.form.fields.selectService')}</option>
        {services.map(service => (
          <option key={service.id} value={service.id}>
            {service.name} - ${service.price}/unit
          </option>
        ))}
      </FormSelect>

      <FormField
        label={t('handling.form.fields.quantity')}
        type="number"
        min="1"
        value={formData.quantity}
        onChange={e => setFormData(prev => ({ ...prev, quantity: e.target.value }))}
        required
      />

      <FormField
        label={t('handling.form.fields.description')}
        type="textarea"
        value={formData.description}
        onChange={e => setFormData(prev => ({ ...prev, description: e.target.value }))}
        required
      />

      <FormField
        label={t('handling.form.fields.requestedDate')}
        type="datetime-local"
        value={formData.requested_date}
        onChange={e => setFormData(prev => ({ ...prev, requested_date: e.target.value }))}
        required
      />
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <FormField
          label={t('handling.form.fields.arrivalDate')}
          type="datetime-local"
          value={formData.arrival_date}
          onChange={e => {
            setFormData(prev => ({ ...prev, arrival_date: e.target.value }));
            setDateError(null);
          }}
        />

        <FormField
          label={t('handling.form.fields.departureDate')}
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

      {fbos.length > 0 && (
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            {t('handling.form.fields.selectFbos')}
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

      <div className="border-t border-gray-200 pt-6">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <CountField 
            label={t('handling.form.fields.passengerCount')}
            field="passenger_count" 
            value={formData.passenger_count} 
          />
          <CountField 
            label={t('handling.form.fields.crewCount')}
            field="crew_count" 
            value={formData.crew_count} 
          />
          <CountField 
            label={t('handling.form.fields.petCount')}
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
          {t('handling.form.buttons.cancel')}
        </button>
        <button
          type="submit"
          disabled={loading || formData.selected_fbos.length === 0}
          className="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50"
        >
          {loading ? t('common.loading') : t('handling.form.buttons.create')}
        </button>
      </div>
    </form>
  );
}