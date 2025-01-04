import { MapPin } from 'lucide-react';
import { Link } from 'react-router-dom';
import { FormField } from './FormField';

interface CoordinatesFieldProps {
  latitude: string;
  longitude: string;
  onChange: (field: 'latitude' | 'longitude', value: string) => void;
}

export function CoordinatesField({ latitude, longitude, onChange }: CoordinatesFieldProps) {
  return (
    <div className="md:col-span-2">
      <div className="flex items-center justify-between mb-1">
        <label className="block text-sm font-medium text-gray-700">Location</label>
        <Link 
          to="/fbos" 
          className="text-sm text-blue-600 hover:text-blue-500 flex items-center gap-1"
        >
          <MapPin className="h-4 w-4" />
          <span>View Map</span>
        </Link>
      </div>
      <div className="grid grid-cols-2 gap-4">
        <FormField
          label="Latitude"
          name="latitude"
          type="number"
          step="0.0001"
          value={latitude}
          onChange={(e) => onChange('latitude', e.target.value)}
          required
        />
        <FormField
          label="Longitude"
          name="longitude"
          type="number"
          step="0.0001"
          value={longitude}
          onChange={(e) => onChange('longitude', e.target.value)}
          required
        />
      </div>
    </div>
  );
}