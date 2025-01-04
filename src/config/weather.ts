// OpenWeatherMap configuration
export const WEATHER_API_KEY = import.meta.env.VITE_OPENWEATHER_API_KEY || '';

export const WEATHER_LAYERS = {
  clouds: 'clouds_new',
  precipitation: 'precipitation_new',
  pressure: 'pressure_new',
  wind: 'wind_new',
  temp: 'temp_new'
} as const;

export type WeatherLayer = keyof typeof WEATHER_LAYERS;

// Helper to check if OpenWeather is properly configured
export const isWeatherConfigured = () => {
  return Boolean(WEATHER_API_KEY && WEATHER_API_KEY.length === 32);
};