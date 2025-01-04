import { Marker, Popup } from 'react-leaflet';
import L from 'leaflet';
import type { Aircraft } from '../../types/aircraft';

// Custom green marker icon
const aircraftIcon = new L.Icon({
  iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-green.png',
  shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-shadow.png',
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  shadowSize: [41, 41]
});

interface AircraftMarkerProps {
  aircraft: Aircraft;
}

export function AircraftMarker({ aircraft }: AircraftMarkerProps) {
  if (!aircraft.latitude || !aircraft.longitude) {
    return null;
  }

  return (
    <Marker
      position={[aircraft.latitude, aircraft.longitude]}
      icon={aircraftIcon}
      zIndexOffset={1000} // This ensures aircraft markers appear above other markers
    >
      <Popup>
        <div className="p-2 min-w-[200px]">
          <h3 className="text-lg font-bold mb-1">{aircraft.tail_number}</h3>
          <div className="text-sm text-gray-600">
            <p>{aircraft.manufacturer} {aircraft.model}</p>
            <p className="mt-1">
              {aircraft.fuel_capacity} gal {aircraft.fuel_type?.name}
            </p>
          </div>
        </div>
      </Popup>
    </Marker>
  );
}