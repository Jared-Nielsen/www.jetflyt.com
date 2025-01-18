import { useState } from 'react';
import { FormField } from '../shared/FormField';
import { FormSelect } from '../shared/FormSelect';
import { SearchableSelect } from '../shared/SearchableSelect';
import { useAircraft } from '../../hooks/useAircraft';
import { useICAOData } from '../../hooks/useICAOData';
import { supabase } from '../../lib/supabase';
import type { Tender } from '../../types/tender';
import { useTranslation } from 'react-i18next';

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
  const [fbos, setFBOs] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [dateError, setDateError] = useState<string | null>(null);
  const [isAnnual, setIsAnnual] = useState(false);
  const { t } = useTranslation();

  // Initialize form data with current date/time for requested_date
  const now = new Date();
  now.setMinutes(now.getMinutes() - now.getTimezoneOffset()); // Adjust for timezone
  const defaultDateTime = now.toISOString().slice(0, 16);

  const [formData, setFormData] = useState({
    aircraft_id: initialData?.aircraft_id || '',
    icao_id: initialData?.icao_id || '',
    selected_fbos: initialData?.selected_fbos || [],
    gallons: initialData?.gallons?.toString() || '',
    target_price: initialData?.target_price?.toString() || '',
    description: initialData?.description || '',
    start_date: initialData?.start_date ? new Date(initialData.start_date).toISOString().slice(0, 16) : defaultDateTime,
    end_date: initialData?.end_date ? new Date(initialData.end_date).toISOString().slice(0, 16) : ''
  });

  // Load FBOs for the selected airport
  const loadFBOs = async (icaoId: string) => {
    try {
      const { data, error } = await supabase
        .from('fbos')
        .select('*')
        .eq('icao_id', icaoId);

      if (error) throw error;
      setFBOs(data || []);
    } catch (err) {
      console.error('Error fetching FBOs:', err);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (loading) return;

    // Validate dates
    if (formData.end_date) {
      const startTime = new Date(formData.start_date).getTime();
      const endTime = new Date(formData.end_date).getTime();
      
      if (endTime <= startTime) {
        setDateError(t('tenders.form.errors.invalidDates'));
        return;
      }
    }

    // Validate at least one FBO is selected
    if (formData.selected_fbos.length === 0) {
      alert(t('tenders.form.errors.noFboSelected'));
      return;
    }

    try {
      setLoading(true);
      setDateError(null);

      await onSubmit({
        ...formData,
        gallons: parseInt(formData.gallons, 10),
        target_price: parseFloat(formData.target_price)
      });
    } catch (err) {
      console.error('Form submission error:', err);
      alert(t('tenders.form.errors.submissionFailed'));
    } finally {
      setLoading(false);
    }
  };

  if (aircraftLoading || airportsLoading) {
    return <div>{t('common.loading')}</div>;
  }

  const airportOptions = airports?.map(airport => ({
    id: airport.id,
    label: `${airport.code} - ${airport.name}`,
    sublabel: airport.state ? `${airport.state}, ${airport.country}` : airport.country
  })) || [];

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <FormSelect
        label={t('tenders.form.fields.aircraft')}
        value={formData.aircraft_id}
        onChange={e => setFormData(prev => ({ ...prev, aircraft_id: e.target.value }))}
        required
        disabled={Boolean(initialData)}
      >
        <option value="">{t('tenders.form.fields.selectAircraft')}</option>
        {aircraft?.map(a => (
          <option key={a.id} value={a.id}>
            {a.tail_number} - {a.type?.name || 'Unknown Type'}
          </option>
        ))}
      </FormSelect>

      <SearchableSelect
        label={t('tenders.form.fields.airport')}
        options={airportOptions}
        value={formData.icao_id}
        onChange={(value) => {
          setFormData(prev => ({ ...prev, icao_id: value, selected_fbos: [] }));
          if (value) {
            loadFBOs(value);
          }
        }}
        placeholder={t('tenders.form.fields.selectAirport')}
        required
        disabled={Boolean(initialData)}
      />

      <div className="grid grid-cols-2 gap-4">
        <FormField
          label={t('tenders.form.fields.gallons')}
          type="number"
          min="1"
          step="1"
          value={formData.gallons}
          onChange={e => setFormData(prev => ({ ...prev, gallons: e.target.value }))}
          required
        />

        <FormField
          label={t('tenders.form.fields.targetPrice')}
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
            onClick={() => {
              setIsAnnual(true);
              const startDate = new Date(formData.start_date);
              const endDate = new Date(startDate);
              endDate.setFullYear(endDate.getFullYear() + 1);
              setFormData(prev => ({
                ...prev,
                end_date: endDate.toISOString().slice(0, 16)
              }));
            }}
            className={`px-4 py-2 rounded-md text-sm font-medium ${
              isAnnual 
                ? 'bg-green-600 text-white hover:bg-green-700' 
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            }`}
          >
            {t('tenders.form.fields.annual')}
          </button>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <FormField
            label={t('tenders.form.fields.startDate')}
            type="datetime-local"
            value={formData.start_date}
            onChange={e => {
              const startDate = new Date(e.target.value);
              setFormData(prev => {
                const newData = { ...prev, start_date: e.target.value };
                if (isAnnual) {
                  const endDate = new Date(startDate);
                  endDate.setFullYear(endDate.getFullYear() + 1);
                  newData.end_date = endDate.toISOString().slice(0, 16);
                }
                return newData;
              });
              setDateError(null);
            }}
            required
          />

          <FormField
            label={t('tenders.form.fields.endDate')}
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
        label={t('tenders.form.fields.description')}
        type="textarea"
        value={formData.description}
        onChange={e => setFormData(prev => ({ ...prev, description: e.target.value }))}
      />

      {fbos.length > 0 && !initialData && (
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            {t('tenders.form.fields.selectFbos')}
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
          {t('tenders.form.buttons.cancel')}
        </button>
        <button
          type="submit"
          disabled={loading || (!initialData && formData.selected_fbos.length === 0)}
          className="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50"
        >
          {loading ? t('tenders.form.buttons.creating') : (initialData ? t('tenders.form.buttons.update') : t('tenders.form.buttons.create'))}
        </button>
      </div>
    </form>
  );
}