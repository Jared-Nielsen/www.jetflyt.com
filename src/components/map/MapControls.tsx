import React from 'react';
import { CollapsibleControl } from './CollapsibleControl';
import { WeatherControl } from './WeatherControl';
import { MapPin } from 'lucide-react';
import type { WeatherLayer } from '../../config/weather';

interface MapControlsProps {
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

export function MapControls({ activeLayers, onLayersChange }: MapControlsProps) {
  return (
    <div className="absolute top-4 right-4 z-[1000] space-y-2">
      <CollapsibleControl title="Map Layers" defaultCollapsed={false}>
        <div className="space-y-4">
          <WeatherControl
            activeLayers={activeLayers}
            onLayersChange={onLayersChange}
          />
          
          <div className="border-t pt-2">
            <h3 className="text-sm font-medium text-gray-700 px-3 mb-2">Map Features</h3>
            <button
              onClick={() => onLayersChange({
                ...activeLayers,
                icaos: !activeLayers.icaos
              })}
              className={`flex items-center space-x-2 px-3 py-2 w-full rounded-md transition-colors ${
                activeLayers.icaos
                  ? 'bg-blue-100 text-blue-700'
                  : 'hover:bg-gray-100 text-gray-700'
              }`}
            >
              <MapPin className="h-5 w-5" />
              <span className="text-sm">Airports</span>
            </button>
          </div>
        </div>
      </CollapsibleControl>
    </div>
  );
}