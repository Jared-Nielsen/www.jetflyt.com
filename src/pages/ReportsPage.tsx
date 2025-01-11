import { FileText, Briefcase, Route, Plane } from 'lucide-react';
import { SEO } from '../components/SEO';
import { KPIMetrics } from '../components/reports/KPIMetrics';
import { TenderStatusChart } from '../components/reports/TenderStatusChart';
import { ServiceTenderStatusChart } from '../components/reports/ServiceTenderStatusChart';
import { useAuth } from '../contexts/AuthContext';
import { LoadingScreen } from '../components/auth/LoadingScreen';
import { ProtectedRoute } from '../components/auth/ProtectedRoute';

export default function ReportsPage() {
  const { user, loading } = useAuth();

  if (loading) {
    return <LoadingScreen />;
  }

  if (!user) {
    return <ProtectedRoute />;
  }

  return (
    <>
      <SEO 
        title="Reports"
        description="View analytics and reports for your aviation operations"
      />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="sm:flex sm:items-center sm:justify-between mb-8">
          <div>
            <h1 className="text-2xl font-semibold text-gray-900">Reports & Analytics</h1>
            <p className="mt-2 text-sm text-gray-700">
              View key metrics and insights about your operations
            </p>
          </div>
        </div>

        <div className="space-y-8">
          <KPIMetrics />
          
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
            <div className="bg-white shadow rounded-lg p-6">
              <h2 className="text-lg font-medium text-gray-900 mb-4">Fuel Tender Distribution</h2>
              <div className="h-80">
                <TenderStatusChart />
              </div>
            </div>

            <div className="bg-white shadow rounded-lg p-6">
              <h2 className="text-lg font-medium text-gray-900 mb-4">Service Tender Distribution</h2>
              <div className="h-80">
                <ServiceTenderStatusChart />
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}