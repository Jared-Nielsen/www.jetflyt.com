import React from 'react';
import type { ICAO } from '../../types/icao';
import { useAirportFBOs } from '../../hooks/useAirportFBOs';
import { Building2 } from 'lucide-react';
import { ICAO_TYPE_COLORS } from '../../hooks/useMarkerIcon';

interface AirportPopupProps {
  airport: ICAO;
}

export function AirportPopup({ airport }: AirportPopupProps) {
  const { fbos, loading, error } = useAirportFBOs(airport.id);

  // Get color based on ICAO type
  const typeColor = airport.icao_type?.name ? 
    ICAO_TYPE_COLORS[airport.icao_type.name as keyof typeof ICAO_TYPE_COLORS] : 
    'blue';

  return (
    <div className="p-2 min-w-[200px]">
      <h3 className="text-lg font-bold mb-1">{airport.name}</h3>
      <div className="mb-2 flex gap-2">
        <span className="inline-block px-2 py-1 bg-blue-100 text-blue-800 rounded text-sm font-medium">
          {airport.code}
        </span>
        {airport.icao_type && (
          <span 
            className={`inline-block px-2 py-1 rounded text-sm font-medium`}
            style={{
              backgroundColor: `${typeColor}20`,
              color: typeColor
            }}
          >
            {airport.icao_type.name.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase())}
          </span>
        )}
      </div>
      
      <div>
        <h4 className="text-sm font-semibold text-gray-700 mb-1 flex items-center gap-1">
          <Building2 className="h-4 w-4" />
          FBO Locations
        </h4>
        
        {loading ? (
          <p className="text-sm text-gray-500">Loading FBOs...</p>
        ) : error ? (
          <p className="text-sm text-red-500">{error}</p>
        ) : fbos.length === 0 ? (
          <p className="text-sm text-gray-500">No FBOs found at this airport</p>
        ) : (
          <ul className="text-sm">
            {fbos.map((fbo) => (
              <li key={fbo.id} className="py-0.5">
                {fbo.name}
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
}