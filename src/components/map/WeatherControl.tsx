import React from 'react';
import { Cloud, Droplets, Wind, Thermometer, GaugeCircle, AlertTriangle } from 'lucide-react';
import type { WeatherLayer } from '../../config/weather';

interface WeatherControlProps {
  activeLayers: {
    weather: WeatherLayer[];
    notams: boolean;
    icaos: boolean;
  };
  onLayersChange: (layers: {
    weather: WeatherLayer[];
    notams: boolean;
    icaos: boolean;
  }) => void;
}

export function WeatherControl({ activeLayers, onLayersChange }: WeatherControlProps) {
  const layers: { id: WeatherLayer; icon: React.ReactNode; label: string }[] = [
    { id: 'temp', icon: <Thermometer className="h-5 w-5" />, label: 'Temperature' },
    { id: 'clouds', icon: <Cloud className="h-5 w-5" />, label: 'Clouds' },
    { id: 'precipitation', icon: <Droplets className="h-5 w-5" />, label: 'Precipitation' },
    { id: 'wind', icon: <Wind className="h-5 w-5" />, label: 'Wind' },
    { id: 'pressure', icon: <GaugeCircle className="h-5 w-5" />, label: 'Pressure' }
  ];

  const toggleWeatherLayer = (layer: WeatherLayer) => {
    onLayersChange({
      ...activeLayers,
      weather: activeLayers.weather.includes(layer)
        ? activeLayers.weather.filter(l => l !== layer)
        : [...activeLayers.weather, layer]
    });
  };

  const toggleNotams = () => {
    onLayersChange({
      ...activeLayers,
      notams: !activeLayers.notams
    });
  };

  return (
    <div className="space-y-4">
      <div className="space-y-2">
        <h3 className="text-sm font-medium text-gray-700 px-3">Weather</h3>
        {layers.map(({ id, icon, label }) => (
          <button
            key={id}
            onClick={() => toggleWeatherLayer(id)}
            className={`flex items-center space-x-2 px-3 py-2 w-full rounded-md transition-colors ${
              activeLayers.weather.includes(id)
                ? 'bg-blue-100 text-blue-700'
                : 'hover:bg-gray-100 text-gray-700'
            }`}
            title={label}
          >
            {icon}
            <span className="text-sm">{label}</span>
          </button>
        ))}
      </div>

      <div className="border-t pt-2">
        <h3 className="text-sm font-medium text-gray-700 px-3 mb-2">Alerts</h3>
        <button
          onClick={toggleNotams}
          className={`flex items-center space-x-2 px-3 py-2 w-full rounded-md transition-colors ${
            activeLayers.notams
              ? 'bg-yellow-100 text-yellow-700'
              : 'hover:bg-gray-100 text-gray-700'
          }`}
        >
          <AlertTriangle className="h-5 w-5" />
          <span className="text-sm">NOTAMs</span>
        </button>
      </div>
    </div>
  );
}