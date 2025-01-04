import { useEffect } from 'react';
import { useMap } from 'react-leaflet';
import L from 'leaflet';
import type { NOTAM } from '../../types/notam';

interface NotamBoundaryProps {
  notam: NOTAM;
}

export function NotamBoundary({ notam }: NotamBoundaryProps) {
  const map = useMap();

  useEffect(() => {
    // Create polygon from NOTAM coordinates
    const polygon = L.polygon(notam.coordinates, {
      color: '#ff4444',
      weight: 2,
      opacity: 0.8,
      fillOpacity: 0.2
    });

    // Add popup with NOTAM details
    polygon.bindPopup(`
      <div class="p-2">
        <h3 class="font-bold">${notam.identifier}</h3>
        <p class="text-sm mt-1">${notam.description}</p>
        <p class="text-xs text-gray-500 mt-2">
          Valid: ${new Date(notam.startTime).toLocaleString()} - 
          ${new Date(notam.endTime).toLocaleString()}
        </p>
      </div>
    `);

    polygon.addTo(map);

    return () => {
      map.removeLayer(polygon);
    };
  }, [map, notam]);

  return null;
}