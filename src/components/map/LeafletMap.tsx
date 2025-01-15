import { useState, useRef } from 'react';
import { MapContainer, TileLayer, useMap } from 'react-leaflet';
import type { Map as LeafletMap } from 'leaflet';
import 'leaflet/dist/leaflet.css';
import { DEFAULT_CENTER, DEFAULT_ZOOM, TILE_LAYER_URL, TILE_LAYER_ATTRIBUTION } from '../../config/map';
import { WEATHER_API_KEY, isWeatherConfigured } from '../../config/weather';
import { AirportMarker } from './AirportMarker';
import { AircraftMarker } from './AircraftMarker';
import { MapControls } from './MapControls';
import { WeatherLayer } from './WeatherLayer';
import { NotamBoundary } from './NotamBoundary';
import { AircraftList } from './AircraftList';
import { TripRoutes } from './TripRoutes';
import { useNotams } from '../../hooks/useNotams';
import { useAuth } from '../../contexts/AuthContext';
import { useAircraft } from '../../hooks/useAircraft';
import { useTrip } from '../../hooks/useTrip';
import type { ICAO } from '../../types/icao';
import type { WeatherLayer as WeatherLayerType } from '../../config/weather';

function MapController({ onMapReady }: { onMapReady: (map: LeafletMap) => void }) {
  const map = useMap();
  onMapReady(map);
  return null;
}

interface LeafletMapProps {
  airports?: ICAO[];
}

export function LeafletMap({ airports = [] }: LeafletMapProps) {
  const { user } = useAuth();
  const { aircraft } = useAircraft();
  const { activeTrip } = useTrip();
  const [visibleAircraft, setVisibleAircraft] = useState<Set<string>>(new Set());
  const mapRef = useRef<LeafletMap | null>(null);
  const [activeLayers, setActiveLayers] = useState<{
    weather: WeatherLayerType[];
    notams: boolean;
    icaos: boolean;
  }>({
    weather: ['precipitation', 'temp'],
    notams: true,
    icaos: true
  });
  
  const { notams, loading: notamsLoading } = useNotams();

  const handleAircraftToggle = (aircraftId: string, visible: boolean) => {
    const selectedAircraft = aircraft?.find(a => a.id === aircraftId);
    
    setVisibleAircraft(prev => {
      const newSet = new Set(prev);
      if (visible) {
        newSet.add(aircraftId);
        // Only pan to aircraft if coordinates are valid
        if (selectedAircraft && 
            selectedAircraft.latitude != null && 
            selectedAircraft.longitude != null && 
            !isNaN(selectedAircraft.latitude) && 
            !isNaN(selectedAircraft.longitude) && 
            mapRef.current) {
          const currentZoom = mapRef.current.getZoom();
          mapRef.current.setView(
            [selectedAircraft.latitude, selectedAircraft.longitude],
            currentZoom
          );
        }
      } else {
        newSet.delete(aircraftId);
      }
      return newSet;
    });
  };

  return (
    <div className="relative h-full">
      <MapContainer
        center={DEFAULT_CENTER}
        zoom={DEFAULT_ZOOM}
        className="h-full w-full z-0"
      >
        <MapController onMapReady={(map) => { mapRef.current = map; }} />
        <TileLayer
          url={TILE_LAYER_URL}
          attribution={TILE_LAYER_ATTRIBUTION}
        />
        {isWeatherConfigured() && activeLayers.weather.map(layer => (
          <WeatherLayer
            key={layer}
            layer={layer}
            apiKey={WEATHER_API_KEY}
          />
        ))}
        {activeLayers.icaos && airports.map((airport) => (
          airport.latitude != null && 
          airport.longitude != null && 
          !isNaN(airport.latitude) && 
          !isNaN(airport.longitude) && (
            <AirportMarker key={airport.id} airport={airport} />
          )
        ))}
        {user && aircraft?.map((aircraft) => (
          visibleAircraft.has(aircraft.id) && 
          aircraft.latitude != null && 
          aircraft.longitude != null && 
          !isNaN(aircraft.latitude) && 
          !isNaN(aircraft.longitude) && (
            <AircraftMarker key={aircraft.id} aircraft={aircraft} />
          )
        ))}
        {activeLayers.notams && !notamsLoading && notams?.map((notam) => (
          <NotamBoundary key={notam.identifier} notam={notam} />
        ))}
        {activeTrip && <TripRoutes trip={activeTrip} />}
      </MapContainer>
      <MapControls
        activeLayers={activeLayers}
        onLayersChange={setActiveLayers}
      />
      {user && (
        <AircraftList
          onAircraftToggle={handleAircraftToggle}
          visibleAircraft={visibleAircraft}
        />
      )}
    </div>
  );
}