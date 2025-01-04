import { useEffect, useRef, useState } from 'react';
import mapboxgl from 'mapbox-gl';
import { MAPBOX_ACCESS_TOKEN, MAPBOX_STYLE, DEFAULT_CENTER, DEFAULT_ZOOM, isValidMapboxToken } from '../config/mapbox';

if (!MAPBOX_ACCESS_TOKEN || !isValidMapboxToken(MAPBOX_ACCESS_TOKEN)) {
  throw new Error('Valid Mapbox access token is required');
}

mapboxgl.accessToken = MAPBOX_ACCESS_TOKEN;

export function useMapbox() {
  const mapContainer = useRef<HTMLDivElement | null>(null);
  const mapInstance = useRef<mapboxgl.Map | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [isLoaded, setIsLoaded] = useState(false);

  useEffect(() => {
    if (!mapContainer.current || mapInstance.current) return;

    try {
      const map = new mapboxgl.Map({
        container: mapContainer.current,
        style: MAPBOX_STYLE,
        center: DEFAULT_CENTER,
        zoom: DEFAULT_ZOOM,
        attributionControl: true,
        preserveDrawingBuffer: true
      });

      map.on('load', () => {
        setIsLoaded(true);
      });

      map.on('error', (e) => {
        console.error('Mapbox error:', e);
        setError('Failed to load map resources. Please check your internet connection.');
      });

      map.addControl(new mapboxgl.NavigationControl(), 'top-right');

      mapInstance.current = map;

      return () => {
        map.remove();
        mapInstance.current = null;
      };
    } catch (err) {
      console.error('Error initializing map:', err);
      setError('Failed to initialize map. Please refresh the page.');
    }
  }, []);

  return { 
    map: mapInstance.current, 
    error, 
    isLoaded,
    containerRef: mapContainer 
  };
}