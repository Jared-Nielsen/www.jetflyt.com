import { Marker, Popup } from 'react-leaflet';
import type { ICAO } from '../../types/icao';
import { useMarkerIcon } from '../../hooks/useMarkerIcon';
import { AirportPopup } from './AirportPopup';

interface AirportMarkerProps {
  airport: ICAO;
}

export function AirportMarker({ airport }: AirportMarkerProps) {
  const markerIcon = useMarkerIcon(airport.icao_type?.name as any);

  if (!airport.latitude || !airport.longitude) {
    return null;
  }

  return (
    <Marker
      position={[airport.latitude, airport.longitude]}
      icon={markerIcon}
    >
      <Popup>
        <AirportPopup airport={airport} />
      </Popup>
    </Marker>
  );
}