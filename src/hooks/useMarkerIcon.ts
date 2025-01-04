import { useMemo } from 'react';
import L from 'leaflet';

// Fix for default marker icon
import markerIcon2x from 'leaflet/dist/images/marker-icon-2x.png';
import markerIcon from 'leaflet/dist/images/marker-icon.png';
import markerShadow from 'leaflet/dist/images/marker-shadow.png';

// ICAO type to color mapping
const ICAO_TYPE_COLORS = {
  major_international: 'red',      // Major hubs
  international: 'orange',         // International airports
  regional: 'blue',               // Regional airports
  military: 'black',              // Military bases
  general_aviation: 'green',      // GA airports
  cargo: 'violet',                // Cargo hubs
  reliever: 'yellow'              // Reliever airports
} as const;

export function useMarkerIcon(icaoType?: keyof typeof ICAO_TYPE_COLORS) {
  return useMemo(() => {
    // Fix Leaflet's default icon path issues
    delete (L.Icon.Default.prototype as any)._getIconUrl;
    
    // If no ICAO type provided, use default blue marker
    if (!icaoType) {
      L.Icon.Default.mergeOptions({
        iconUrl: markerIcon,
        iconRetinaUrl: markerIcon2x,
        shadowUrl: markerShadow,
      });
      return new L.Icon.Default();
    }

    // Use color-specific marker based on ICAO type
    const color = ICAO_TYPE_COLORS[icaoType];
    return new L.Icon({
      iconUrl: `https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-${color}.png`,
      shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-shadow.png',
      iconSize: [25, 41],
      iconAnchor: [12, 41],
      popupAnchor: [1, -34],
      shadowSize: [41, 41]
    });
  }, [icaoType]);
}

export { ICAO_TYPE_COLORS };