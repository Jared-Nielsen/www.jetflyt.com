import { Plus, Pencil } from 'lucide-react';
import { useState } from 'react';
import { AddLegModal } from './AddLegModal';
import { EditLegModal } from './EditLegModal';
import { LegStatus } from './LegStatus';
import type { Route, Leg } from '../../types/trip';

interface LegListProps {
  route: Route;
  onLegAdded: () => void;
}

export function LegList({ route, onLegAdded }: LegListProps) {
  const [showAddModal, setShowAddModal] = useState(false);
  const [editingLeg, setEditingLeg] = useState<Leg | null>(null);

  // Sort legs by scheduled departure
  const sortedLegs = [...route.legs].sort((a, b) => 
    new Date(a.scheduled_departure).getTime() - new Date(b.scheduled_departure).getTime()
  );

  return (
    <div className="mt-2">
      <div className="flex items-center justify-between mb-2">
        <h4 className="text-sm font-medium text-gray-700">Legs</h4>
        <button
          onClick={() => setShowAddModal(true)}
          className="flex items-center space-x-1 px-2 py-1 text-xs rounded bg-gray-100 text-gray-700 hover:bg-gray-200"
        >
          <Plus className="h-3 w-3" />
          <span>Add Leg</span>
        </button>
      </div>

      <div className="space-y-2">
        {sortedLegs.map(leg => (
          <div
            key={leg.id}
            onClick={() => setEditingLeg(leg)}
            className="p-2 bg-white rounded border border-gray-200 cursor-pointer hover:bg-gray-50"
          >
            <div className="flex items-center justify-between">
              <div>
                <div className="text-sm font-medium">
                  {leg.origin.code} → {leg.destination.code}
                </div>
                <div className="text-xs text-gray-500">
                  {new Date(leg.scheduled_departure).toLocaleString()} →{' '}
                  {new Date(leg.scheduled_arrival).toLocaleString()}
                </div>
                {leg.notes && (
                  <div className="text-xs text-gray-500 mt-1">
                    {leg.notes}
                  </div>
                )}
              </div>
              <div className="flex items-center space-x-2">
                <button
                  onClick={(e) => {
                    e.stopPropagation();
                    setEditingLeg(leg);
                  }}
                  className="text-gray-600 hover:text-gray-900"
                >
                  <Pencil className="h-4 w-4" />
                </button>
                <LegStatus status={leg.status} />
              </div>
            </div>
          </div>
        ))}
      </div>

      <AddLegModal
        isOpen={showAddModal}
        onClose={() => setShowAddModal(false)}
        routeId={route.id}
        onLegAdded={onLegAdded}
      />

      {editingLeg && (
        <EditLegModal
          isOpen={true}
          onClose={() => setEditingLeg(null)}
          leg={editingLeg}
          onLegUpdated={onLegAdded}
        />
      )}
    </div>
  );
}