import { Plus, Pencil } from 'lucide-react';
import { useState } from 'react';
import { useRoutes } from '../../hooks/useRoutes';
import { AddRouteModal } from '../dispatch/AddRouteModal';
import { EditRouteModal } from '../dispatch/EditRouteModal';
import { LegList } from '../dispatch/LegList';
import type { Trip, Route } from '../../types/trip';

interface RouteListProps {
  trip: Trip;
}

export function RouteList({ trip }: RouteListProps) {
  const [showAddModal, setShowAddModal] = useState(false);
  const [editingRoute, setEditingRoute] = useState<Route | null>(null);
  const { routes, loading, refetch } = useRoutes(trip.id);

  if (loading) {
    return <div>Loading routes...</div>;
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-lg font-medium text-gray-900">Routes</h3>
        <button
          onClick={() => setShowAddModal(true)}
          className="flex items-center space-x-1 px-2 py-1 text-sm rounded bg-blue-600 text-white hover:bg-blue-700"
        >
          <Plus className="h-4 w-4" />
          <span>Add Route</span>
        </button>
      </div>

      <div className="space-y-4">
        {routes.map(route => (
          <div
            key={route.id}
            className="p-3 bg-gray-50 rounded-lg"
          >
            <div className="flex items-center justify-between">
              <div>
                <h4 className="font-medium text-gray-900">{route.name}</h4>
                <p className="text-sm text-gray-500">
                  {route.transit_type.name.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase())}
                </p>
              </div>
              <div className="flex items-center space-x-4">
                <button
                  onClick={() => setEditingRoute(route)}
                  className="text-sm text-gray-600 hover:text-gray-900 flex items-center space-x-1"
                >
                  <Pencil className="h-4 w-4" />
                  <span>Edit</span>
                </button>
                <div className="text-sm text-gray-500">
                  {route.legs.length} {route.legs.length === 1 ? 'leg' : 'legs'}
                </div>
              </div>
            </div>

            <LegList route={route} onLegAdded={refetch} />
          </div>
        ))}
      </div>

      <AddRouteModal
        isOpen={showAddModal}
        onClose={() => setShowAddModal(false)}
        tripId={trip.id}
        onRouteAdded={refetch}
      />

      {editingRoute && (
        <EditRouteModal
          isOpen={true}
          onClose={() => setEditingRoute(null)}
          route={editingRoute}
          onRouteUpdated={refetch}
        />
      )}
    </div>
  );
}