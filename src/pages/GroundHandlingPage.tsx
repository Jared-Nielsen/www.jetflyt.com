import { useState, useEffect } from 'react';
import { Plus } from 'lucide-react';
import { Modal } from '../components/shared/Modal';
import { WorkOrderForm } from '../components/ground-handling/WorkOrderForm';
import { WorkOrderList } from '../components/ground-handling/WorkOrderList';
import { useWorkOrders } from '../hooks/useWorkOrders';
import { SEO } from '../components/SEO';
import { LoadingScreen } from '../components/auth/LoadingScreen';

export default function GroundHandlingPage() {
  const [showForm, setShowForm] = useState(false);
  const { loading, error, createWorkOrder, getWorkOrders } = useWorkOrders();
  const [workOrders, setWorkOrders] = useState<any[]>([]);

  // Load work orders on mount only
  useEffect(() => {
    async function loadWorkOrders() {
      try {
        const data = await getWorkOrders();
        setWorkOrders(data || []);
      } catch (err) {
        console.error('Error loading work orders:', err);
      }
    }
    loadWorkOrders();
  }, [getWorkOrders]);

  const handleSubmit = async (data: any) => {
    try {
      await createWorkOrder(data);
      window.location.href = '/ground-handling';
    } catch (err) {
      console.error('Error submitting work order:', err);
    }
  };

  const handleWorkOrdersUpdated = async () => {
    try {
      const data = await getWorkOrders();
      setWorkOrders(data || []);
    } catch (err) {
      console.error('Error refreshing work orders:', err);
    }
  };

  if (loading && workOrders.length === 0) {
    return <LoadingScreen />;
  }

  return (
    <>
      <SEO 
        title="Ground Handling"
        description="Create and manage your ground handling service tenders."
      />
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="sm:flex sm:items-center sm:justify-between">
          <div>
            <h1 className="text-2xl font-semibold text-gray-900">Ground Handling</h1>
            <p className="mt-2 text-sm text-gray-700">
              Create and manage your ground handling service requests.
            </p>
          </div>
          <div className="mt-4 sm:mt-0">
            <button
              onClick={() => setShowForm(true)}
              className="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700"
            >
              <Plus className="h-4 w-4 mr-2" />
              New Service Tender
            </button>
          </div>
        </div>

        {error && (
          <div className="mt-4 bg-red-50 border-l-4 border-red-400 p-4">
            <p className="text-red-700">{error}</p>
          </div>
        )}

        <div className="mt-8">
          <WorkOrderList workOrders={workOrders} onWorkOrdersUpdated={handleWorkOrdersUpdated} />
        </div>

        <Modal
          isOpen={showForm}
          onClose={() => setShowForm(false)}
          title="Create New Service Tender"
        >
          <WorkOrderForm
            onSubmit={handleSubmit}
            onCancel={() => setShowForm(false)}
          />
        </Modal>
      </div>
    </>
  );
}