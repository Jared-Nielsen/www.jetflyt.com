import { useEffect } from 'react';
import { useMap } from 'react-leaflet';
import L from 'leaflet';
import { WEATHER_TILE_URL, WEATHER_LAYERS, type WeatherLayer } from '../../config/weather';

interface WeatherLayerProps {
  layer: WeatherLayer;
  apiKey: string;
}

export function WeatherLayer({ layer, apiKey }: WeatherLayerProps) {
  const map = useMap();

  useEffect(() => {
    if (!apiKey) {
      console.error('OpenWeather API key is missing');
      return;
    }

    // Create the weather layer with the correct URL format
    const weatherLayer = L.tileLayer(
      `https://tile.openweathermap.org/map/${WEATHER_LAYERS[layer]}/{z}/{x}/{y}.png?appid=${apiKey}`,
      {
        opacity: 0.7,
        zIndex: 250,
        attribution: '&copy; <a href="https://openweathermap.org/">OpenWeather</a>'
      }
    );

    weatherLayer.addTo(map);

    return () => {
      map.removeLayer(weatherLayer);
    };
  }, [map, layer, apiKey]);

  return null;
}