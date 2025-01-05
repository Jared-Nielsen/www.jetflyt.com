import { useState, useCallback } from 'react';
import { Plus } from 'lucide-react';
import { useTrip } from '../hooks/useTrip';
import { AddTripModal } from '../components/dispatch/AddTripModal';
import { RouteList } from '../components/map/RouteList';
import { TripCard } from '../components/dispatch/TripCard';
import { EmptyState } from '../components/dispatch/EmptyState';
import { SEO } from '../components/SEO';
import { LoadingScreen } from '../components/auth/LoadingScreen';

export default function DispatchPage() {
  const [showAddModal, setShowAddModal] = useState(false);
  const { trips, activeTrip, loading, error, setTripActive, refetch } = useTrip();

  const handleTripAdded = useCallback(async () => {
    await refetch();
    setShowAddModal(false);
  }, [refetch]);

  if (loading) {
    return <LoadingScreen />;
  }

  return (
    <>
      <SEO 
        title="Dispatch"
        description="Manage your trips and routes with our comprehensive dispatch system."
      />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="sm:flex sm:items-center sm:justify-between">
          <div>
            <h1 className="text-2xl font-semibold text-gray-900">Trip Management</h1>
            <p className="mt-2 text-sm text-gray-700">
              Plan and manage your trips across multiple modes of transportation.
            </p>
          </div>
          <div className="mt-4 sm:mt-0">
            <button
              onClick={() => setShowAddModal(true)}
              className="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700"
            >
              <Plus className="h-4 w-4 mr-2" />
              New Trip
            </button>
          </div>
        </div>

        {error && (
          <div className="mt-4 bg-red-50 border-l-4 border-red-400 p-4">
            <p className="text-red-700">{error}</p>
          </div>
        )}

        <div className="mt-8 space-y-6">
          {trips.length === 0 ? (
            <EmptyState
              title="No trips found"
              description="Get started by creating your first trip"
              actionLabel="Create Trip"
              onAction={() => setShowAddModal(true)}
            />
          ) : (
            <>
              {/* Active Trip Section */}
              {activeTrip && (
                <div className="bg-white shadow sm:rounded-lg">
                  <div className="px-4 py-5 sm:p-6">
                    <div className="flex items-center justify-between mb-4">
                      <div>
                        <h2 className="text-lg font-medium text-gray-900">
                          Active Trip: {activeTrip.name}
                        </h2>
                        {activeTrip.description && (
                          <p className="mt-1 text-sm text-gray-500">
                            {activeTrip.description}
                          </p>
                        )}
                      </div>
                      <div className="text-sm text-gray-500">
                        {new Date(activeTrip.start_date).toLocaleDateString()}
                        {activeTrip.end_date && (
                          <> → {new Date(activeTrip.end_date).toLocaleDateString()}</>
                        )}
                      </div>
                    </div>

                    <RouteList trip={activeTrip} />
                  </div>
                </div>
              )}

              {/* Other Trips */}
              <div className="bg-white shadow sm:rounded-lg">
                <div className="px-4 py-5 sm:p-6">
                  <h3 className="text-lg font-medium text-gray-900 mb-4">
                    All Trips
                  </h3>
                  <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                    {trips.map(trip => (
                      <TripCard
                        key={trip.id}
                        trip={trip}
                        onEdit={() => {
                          if (trip.status !== 'active') {
                            setTripActive(trip.id);
                          }
                        }}
                        onTripUpdated={refetch}
                      />
                    ))}
                  </div>
                </div>
              </div>
            </>
          )}
        </div>

        <AddTripModal
          isOpen={showAddModal}
          onClose={() => setShowAddModal(false)}
          onTripAdded={handleTripAdded}
        />
      </div>
    </>
  );
}