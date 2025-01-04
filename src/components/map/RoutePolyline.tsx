import { Polyline, Popup } from 'react-leaflet';
import type { Leg, Route } from '../../types/trip';
import { LegPopup } from './LegPopup';

interface RoutePolylineProps {
  leg: Leg;
  route: Route;
  color: string;
}

export function RoutePolyline({ leg, route, color }: RoutePolylineProps) {
  const coordinates = [
    [leg.origin.latitude, leg.origin.longitude],
    [leg.destination.latitude, leg.destination.longitude]
  ];

  return (
    <Polyline
      positions={coordinates}
      color={color}
      weight={3}
      opacity={0.8}
      zIndex={1000}
    >
      <Popup>
        <LegPopup 
          leg={leg} 
          transitCategory={route.transit_type.category}
          transitType={route.transit_type}
        />
      </Popup>
    </Polyline>
  );
}