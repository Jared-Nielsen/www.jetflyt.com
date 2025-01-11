import { useState, useEffect } from 'react';
import { Plane, FileText, Route, Briefcase } from 'lucide-react';
import { supabase } from '../../lib/supabase';

interface Metrics {
  tripCount: number;
  tenderCount: number;
  serviceTenderCount: number;
  activeTrips: number;
  loading: boolean;
  error: string | null;
}

export function KPIMetrics() {
  const [metrics, setMetrics] = useState<Metrics>({
    tripCount: 0,
    tenderCount: 0,
    serviceTenderCount: 0,
    activeTrips: 0,
    loading: true,
    error: null
  });

  useEffect(() => {
    async function fetchMetrics() {
      try {
        // Get trip counts
        const { data: trips, error: tripsError } = await supabase
          .from('trips')
          .select('status', { count: 'exact' });

        if (tripsError) throw tripsError;

        const activeTrips = trips?.filter(t => t.status === 'active').length || 0;
        const tripCount = trips?.length || 0;

        // Get fuel tender count
        const { count: tenderCount, error: tenderError } = await supabase
          .from('tenders')
          .select('*', { count: 'exact' });

        if (tenderError) throw tenderError;

        // Get service tender count
        const { count: serviceTenderCount, error: serviceTenderError } = await supabase
          .from('work_orders')
          .select('*', { count: 'exact' });

        if (serviceTenderError) throw serviceTenderError;

        setMetrics({
          tripCount,
          tenderCount: tenderCount || 0,
          serviceTenderCount: serviceTenderCount || 0,
          activeTrips,
          loading: false,
          error: null
        });
      } catch (err) {
        console.error('Error fetching metrics:', err);
        setMetrics(prev => ({
          ...prev,
          loading: false,
          error: 'Failed to load metrics'
        }));
      }
    }

    fetchMetrics();
  }, []);

  if (metrics.error) {
    return (
      <div className="bg-red-50 p-4 rounded-lg">
        <p className="text-red-700">{metrics.error}</p>
      </div>
    );
  }

  return (
    <div className="grid grid-cols-1 gap-5 sm:grid-cols-2">
      {/* Top Row - Tenders */}
      <div className="bg-white overflow-hidden shadow rounded-lg">
        <div className="p-5">
          <div className="flex items-center">
            <div className="flex-shrink-0">
              <FileText className="h-6 w-6 text-gray-400" />
            </div>
            <div className="ml-5 w-0 flex-1">
              <dl>
                <dt className="text-sm font-medium text-gray-500 truncate">Total Fuel Tenders</dt>
                <dd className="flex items-baseline">
                  <div className="text-2xl font-semibold text-gray-900">
                    {metrics.loading ? '...' : metrics.tenderCount}
                  </div>
                </dd>
              </dl>
            </div>
          </div>
        </div>
      </div>

      <div className="bg-white overflow-hidden shadow rounded-lg">
        <div className="p-5">
          <div className="flex items-center">
            <div className="flex-shrink-0">
              <Briefcase className="h-6 w-6 text-gray-400" />
            </div>
            <div className="ml-5 w-0 flex-1">
              <dl>
                <dt className="text-sm font-medium text-gray-500 truncate">Total Service Tenders</dt>
                <dd className="flex items-baseline">
                  <div className="text-2xl font-semibold text-gray-900">
                    {metrics.loading ? '...' : metrics.serviceTenderCount}
                  </div>
                </dd>
              </dl>
            </div>
          </div>
        </div>
      </div>

      {/* Bottom Row - Trips */}
      <div className="bg-white overflow-hidden shadow rounded-lg">
        <div className="p-5">
          <div className="flex items-center">
            <div className="flex-shrink-0">
              <Route className="h-6 w-6 text-gray-400" />
            </div>
            <div className="ml-5 w-0 flex-1">
              <dl>
                <dt className="text-sm font-medium text-gray-500 truncate">Total Trips</dt>
                <dd className="flex items-baseline">
                  <div className="text-2xl font-semibold text-gray-900">
                    {metrics.loading ? '...' : metrics.tripCount}
                  </div>
                </dd>
              </dl>
            </div>
          </div>
        </div>
      </div>

      <div className="bg-white overflow-hidden shadow rounded-lg">
        <div className="p-5">
          <div className="flex items-center">
            <div className="flex-shrink-0">
              <Plane className="h-6 w-6 text-gray-400" />
            </div>
            <div className="ml-5 w-0 flex-1">
              <dl>
                <dt className="text-sm font-medium text-gray-500 truncate">Active Trips</dt>
                <dd className="flex items-baseline">
                  <div className="text-2xl font-semibold text-gray-900">
                    {metrics.loading ? '...' : metrics.activeTrips}
                  </div>
                </dd>
              </dl>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}