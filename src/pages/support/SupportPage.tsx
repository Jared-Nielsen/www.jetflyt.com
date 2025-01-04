import { Trash2 } from 'lucide-react';
import { SEO } from '../../components/SEO';
import { STORAGE_KEYS } from '../../utils/storage';

export default function SupportPage() {
  const clearCache = () => {
    // Clear all storage keys
    Object.values(STORAGE_KEYS).forEach(key => {
      localStorage.removeItem(key);
    });
    
    // Show confirmation
    window.alert('Cache cleared successfully! The page will now refresh.');
    window.location.reload();
  };

  return (
    <>
      <SEO 
        title="Support"
        description="Get help and manage your JetFlyt application settings."
      />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <h1 className="text-3xl font-bold mb-8">Support</h1>

        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          {/* Cache Management Card */}
          <div className="bg-white shadow rounded-lg p-6">
            <h2 className="text-xl font-semibold mb-4">Cache Management</h2>
            <p className="text-gray-600 mb-4">
              Clear the application cache to fetch fresh data from the server. This can help resolve display issues.
            </p>
            <button
              onClick={clearCache}
              className="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
            >
              <Trash2 className="h-4 w-4 mr-2" />
              Refresh Data
            </button>
          </div>

          {/* Contact Support Card */}
          <div className="bg-white shadow rounded-lg p-6">
            <h2 className="text-xl font-semibold mb-4">Contact Support</h2>
            <p className="text-gray-600 mb-4">
              Need help? Our support team is available 24/7 to assist you.
            </p>
            <div className="space-y-2">
              <p className="text-sm">
                <strong>Email:</strong> support@jetflyt.com
              </p>
              <p className="text-sm">
                <strong>Phone:</strong> +1 (800) 555-0123
              </p>
            </div>
          </div>

          {/* Documentation Card */}
          <div className="bg-white shadow rounded-lg p-6">
            <h2 className="text-xl font-semibold mb-4">Documentation</h2>
            <p className="text-gray-600 mb-4">
              Access our comprehensive documentation and user guides.
            </p>
            <a 
              href="#" 
              className="text-blue-600 hover:text-blue-500 font-medium"
            >
              View Documentation →
            </a>
          </div>
        </div>
      </div>
    </>
  );
}