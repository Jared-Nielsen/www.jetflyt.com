import { useAuth } from '../../contexts/AuthContext';
import { useAircraft } from '../../hooks/useAircraft';
import { ChevronDown, ChevronUp, MapPin } from 'lucide-react';
import { useState } from 'react';

interface AircraftListProps {
  onAircraftToggle: (aircraftId: string, visible: boolean) => void;
  visibleAircraft: Set<string>;
}

export function AircraftList({ onAircraftToggle, visibleAircraft }: AircraftListProps) {
  const { user } = useAuth();
  const { aircraft, loading } = useAircraft();
  const [isExpanded, setIsExpanded] = useState(true);

  if (!user || loading || aircraft.length === 0) return null;

  return (
    <div className="absolute top-4 left-[50px] z-[1000] bg-white rounded-lg shadow-lg w-64">
      <button
        onClick={() => setIsExpanded(!isExpanded)}
        className="w-full px-4 py-3 flex items-center justify-between bg-gray-50 rounded-t-lg hover:bg-gray-100"
      >
        <span className="font-medium text-gray-700">Your Aircraft</span>
        {isExpanded ? (
          <ChevronUp className="h-4 w-4 text-gray-500" />
        ) : (
          <ChevronDown className="h-4 w-4 text-gray-500" />
        )}
      </button>
      
      {isExpanded && (
        <div className="max-h-[calc(100vh-200px)] overflow-y-auto p-2">
          {aircraft.map((aircraft) => (
            <div
              key={aircraft.id}
              onClick={() => onAircraftToggle(aircraft.id, !visibleAircraft.has(aircraft.id))}
              className={`p-2 rounded cursor-pointer transition-colors ${
                visibleAircraft.has(aircraft.id)
                  ? 'bg-green-100 hover:bg-green-200' 
                  : 'hover:bg-gray-50'
              }`}
            >
              <div className="flex items-center justify-between">
                <div>
                  <div className="font-medium text-gray-900">{aircraft.tail_number}</div>
                  <div className="text-sm text-gray-500">
                    {aircraft.manufacturer} {aircraft.model}
                  </div>
                </div>
                {visibleAircraft.has(aircraft.id) && (
                  <MapPin className="h-4 w-4 text-green-600" />
                )}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}