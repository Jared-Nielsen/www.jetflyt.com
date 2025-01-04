import { Marker, Popup } from 'react-leaflet';
import L from 'leaflet';
import type { FBO } from '../../types/fbo';
import { Building2 } from 'lucide-react';

// Custom FBO icon
const fboIcon = new L.Icon({
  iconUrl: 'https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png',
  shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-shadow.png',
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  shadowSize: [41, 41]
});

interface FBOMarkerProps {
  fbo: FBO;
}

export function FBOMarker({ fbo }: FBOMarkerProps) {
  if (!fbo.latitude || !fbo.longitude) {
    return null;
  }

  return (
    <Marker
      position={[fbo.latitude, fbo.longitude]}
      icon={fboIcon}
    >
      <Popup>
        <div className="p-2 min-w-[200px]">
          <div className="flex items-center gap-1 mb-1">
            <Building2 className="h-4 w-4 text-red-600" />
            <h3 className="text-lg font-bold">{fbo.name}</h3>
          </div>
          {fbo.icao && (
            <div className="mb-2">
              <span className="inline-block px-2 py-1 bg-blue-100 text-blue-800 rounded text-sm font-medium">
                {fbo.icao.code}
              </span>
              <p className="text-sm text-gray-600 mt-1">{fbo.icao.name}</p>
            </div>
          )}
          <p className="text-sm text-gray-600">{fbo.address}</p>
          {fbo.state && (
            <p className="text-sm text-gray-600">{fbo.state}, {fbo.country}</p>
          )}
        </div>
      </Popup>
    </Marker>
  );
}