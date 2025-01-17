import { useAircraftTypes } from '../../hooks/useAircraftTypes';
import { useAircraftEngineTypes } from '../../hooks/useAircraftEngineTypes';
import { useFuelTypes } from '../../hooks/useFuelTypes';
import { useAircraftForm } from '../../hooks/useAircraftForm';
import { FormField } from './FormField';
import { FormSelect } from './FormSelect';
import { CoordinatesField } from './CoordinatesField';
import type { Aircraft } from '../../types/aircraft';
import { useTranslation } from 'react-i18next';

interface AircraftFormProps {
  initialData?: Aircraft;
  onSubmit: (data: Omit<Aircraft, 'id' | 'user_id' | 'created_at' | 'updated_at'>) => Promise<void>;
  onCancel: () => void;
}

export function AircraftForm({ initialData, onSubmit, onCancel }: AircraftFormProps) {
  const { types: aircraftTypes, loading: typesLoading } = useAircraftTypes();
  const { types: engineTypes, loading: engineTypesLoading } = useAircraftEngineTypes();
  const { types: fuelTypes, loading: fuelTypesLoading } = useFuelTypes();
  const { t } = useTranslation();
  
  const { formData, setFormData, error, validateForm, getFormattedData } = useAircraftForm(initialData);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!validateForm()) {
      return;
    }

    try {
      await onSubmit(getFormattedData());
    } catch (err) {
      console.error('Form submission error:', err);
    }
  };

  if (typesLoading || engineTypesLoading || fuelTypesLoading) {
    return <div>{t('common.loading')}</div>;
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      {error && (
        <div className="bg-red-50 border-l-4 border-red-400 p-4">
          <p className="text-sm text-red-700">{error}</p>
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <FormField
          label={t('fleet.form.fields.tailNumber')}
          name="tail_number"
          value={formData.tail_number}
          onChange={e => setFormData(prev => ({ ...prev, tail_number: e.target.value }))}
          required
        />

        <FormSelect
          label={t('fleet.form.fields.type')}
          value={formData.type_id}
          onChange={e => setFormData(prev => ({ ...prev, type_id: e.target.value }))}
          required
        >
          <option value="">{t('fleet.form.fields.selectType')}</option>
          {aircraftTypes.map(type => (
            <option key={type.id} value={type.id}>
              {type.manufacturer} {type.name} - {type.category}
            </option>
          ))}
        </FormSelect>

        <FormField
          label={t('fleet.form.fields.manufacturer')}
          name="manufacturer"
          value={formData.manufacturer}
          onChange={e => setFormData(prev => ({ ...prev, manufacturer: e.target.value }))}
          required
        />

        <FormField
          label={t('fleet.form.fields.model')}
          name="model"
          value={formData.model}
          onChange={e => setFormData(prev => ({ ...prev, model: e.target.value }))}
        />

        <FormField
          label={t('fleet.form.fields.year')}
          name="year"
          type="number"
          min={1900}
          max={new Date().getFullYear()}
          value={formData.year}
          onChange={e => setFormData(prev => ({ ...prev, year: e.target.value }))}
        />

        <FormSelect
          label={t('fleet.form.fields.engineType')}
          value={formData.engine_type_id}
          onChange={e => setFormData(prev => ({ ...prev, engine_type_id: e.target.value }))}
          required
        >
          <option value="">{t('fleet.form.fields.selectEngineType')}</option>
          {engineTypes.map(type => (
            <option key={type.id} value={type.id}>
              {type.name}
            </option>
          ))}
        </FormSelect>

        <FormSelect
          label={t('fleet.form.fields.fuelType')}
          value={formData.fuel_type_id}
          onChange={e => setFormData(prev => ({ ...prev, fuel_type_id: e.target.value }))}
          required
        >
          <option value="">{t('fleet.form.fields.selectFuelType')}</option>
          {fuelTypes.map(type => (
            <option key={type.id} value={type.id}>
              {type.name}
            </option>
          ))}
        </FormSelect>

        <FormField
          label={t('fleet.form.fields.fuelCapacity')}
          name="fuel_capacity"
          type="number"
          min="0"
          value={formData.fuel_capacity}
          onChange={e => setFormData(prev => ({ ...prev, fuel_capacity: e.target.value }))}
        />

        <FormField
          label={t('fleet.form.fields.maxRange')}
          name="max_range"
          type="number"
          min="0"
          value={formData.max_range}
          onChange={e => setFormData(prev => ({ ...prev, max_range: e.target.value }))}
        />

        <CoordinatesField
          latitude={formData.latitude}
          longitude={formData.longitude}
          onChange={(field, value) => setFormData(prev => ({ ...prev, [field]: value }))}
        />
      </div>

      <div className="flex justify-end space-x-4">
        <button
          type="button"
          onClick={onCancel}
          className="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50"
        >
          {t('fleet.form.buttons.cancel')}
        </button>
        <button
          type="submit"
          className="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700"
        >
          {initialData ? t('fleet.form.buttons.update') : t('fleet.form.buttons.create')}
        </button>
      </div>
    </form>
  );
}