import { useEffect } from 'react';
import { useMap } from 'react-leaflet';
import L from 'leaflet';
import type { Trip } from '../../types/trip';
import { useRoutes } from '../../hooks/useRoutes';
import { RoutePolyline } from './RoutePolyline';

interface TripRoutesProps {
  trip: Trip;
}

const FALLBACK_COLORS = [
  '#2563eb', // blue-600
  '#1d4ed8', // blue-700
  '#1e40af', // blue-800
  '#1e3a8a', // blue-900
];

export function TripRoutes({ trip }: TripRoutesProps) {
  const { routes, loading } = useRoutes(trip.id);
  const map = useMap();

  useEffect(() => {
    if (!loading && routes.length > 0) {
      const allCoordinates = routes.flatMap(route => 
        route.legs.map(leg => [
          [leg.origin.latitude, leg.origin.longitude],
          [leg.destination.latitude, leg.destination.longitude]
        ])
      ).flat();

      if (allCoordinates.length > 0) {
        const bounds = L.latLngBounds(allCoordinates);
        map.fitBounds(bounds, { padding: [50, 50] });
      }
    }
  }, [map, routes, loading]);

  if (loading || !routes.length) return null;

  return (
    <>
      {routes.map((route, routeIndex) => {
        const color = route.transit_type?.color || FALLBACK_COLORS[routeIndex % FALLBACK_COLORS.length];
        const sortedLegs = [...route.legs].sort(
          (a, b) => new Date(a.scheduled_departure).getTime() - new Date(b.scheduled_departure).getTime()
        );

        return sortedLegs.map((leg) => (
          <RoutePolyline
            key={leg.id}
            leg={leg}
            route={route}
            color={color}
          />
        ));
      })}
    </>
  );
}