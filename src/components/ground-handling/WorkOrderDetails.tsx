import { useState } from 'react';
import { Modal } from '../shared/Modal';
import { WorkOrderStatus } from './WorkOrderStatus';
import { WorkOrderForm } from './WorkOrderForm';
import { supabase } from '../../lib/supabase';
import type { WorkOrder } from '../../types/workOrder';
import { Users, UserCircle2, Dog, Calendar, Pencil, PlaneLanding, PlaneTakeoff } from 'lucide-react';

interface WorkOrderDetailsProps {
  workOrder: WorkOrder;
  onClose: () => void;
  onWorkOrderUpdated: () => void;
}

export function WorkOrderDetails({ workOrder, onClose, onWorkOrderUpdated }: WorkOrderDetailsProps) {
  const [showCancelModal, setShowCancelModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const totalCost = workOrder.quantity * workOrder.service.price;

  const handleStatusUpdate = async (newStatus: WorkOrder['status']) => {
    try {
      setLoading(true);
      setError(null);

      const updates = {
        status: newStatus,
        ...(newStatus === 'completed' ? { completed_date: new Date().toISOString() } : {})
      };

      const { error: updateError } = await supabase
        .from('work_orders')
        .update(updates)
        .eq('id', workOrder.id);

      if (updateError) throw updateError;
      
      await onWorkOrderUpdated();
      onClose();
    } catch (err) {
      console.error('Error updating work order:', err);
      setError('Failed to update work order status');
    } finally {
      setLoading(false);
    }
  };

  const handleCancel = async () => {
    try {
      await handleStatusUpdate('cancelled');
      setShowCancelModal(false);
    } catch (err) {
      console.error('Error cancelling work order:', err);
    }
  };

  const handleEdit = async (data: any) => {
    try {
      setLoading(true);
      setError(null);

      const { error: updateError } = await supabase
        .from('work_orders')
        .update({
          service_id: data.service_id,
          fbo_id: data.fbo_id,
          quantity: data.quantity,
          description: data.description,
          requested_date: data.requested_date,
          arrival_date: data.arrival_date || null,
          departure_date: data.departure_date || null,
          passenger_count: data.passenger_count,
          crew_count: data.crew_count,
          pet_count: data.pet_count
        })
        .eq('id', workOrder.id);

      if (updateError) throw updateError;
      
      // First update the parent component
      await onWorkOrderUpdated();
      // Then close the modal
      setShowEditModal(false);
      // Finally close the details view to show the updated list
      onClose();
    } catch (err) {
      console.error('Error updating work order:', err);
      setError('Failed to update work order');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="bg-white shadow sm:rounded-lg">
      <div className="px-4 py-5 sm:p-6">
        <div className="flex justify-between items-start">
          <div>
            <h3 className="text-lg font-medium text-gray-900">Work Order Details</h3>
            <div className="mt-2 space-y-1">
              <div className="flex items-center text-sm text-gray-500">
                <Calendar className="h-4 w-4 mr-1" />
                Created: {new Date(workOrder.created_at).toLocaleString()}
              </div>
              {workOrder.arrival_date && (
                <div className="flex items-center text-sm text-gray-500">
                  <PlaneLanding className="h-4 w-4 mr-1 text-blue-500" />
                  Arrival: {new Date(workOrder.arrival_date).toLocaleString()}
                </div>
              )}
              {workOrder.departure_date && (
                <div className="flex items-center text-sm text-gray-500">
                  <PlaneTakeoff className="h-4 w-4 mr-1 text-blue-500" />
                  Departure: {new Date(workOrder.departure_date).toLocaleString()}
                </div>
              )}
            </div>
          </div>
          <div className="flex items-center space-x-4">
            <WorkOrderStatus status={workOrder.status} />
            {workOrder.status === 'pending' && (
              <>
                <button
                  onClick={() => setShowEditModal(true)}
                  className="flex items-center px-3 py-1 text-sm font-medium text-blue-600 hover:text-blue-500 border border-blue-600 rounded"
                >
                  <Pencil className="h-4 w-4 mr-1" />
                  Edit
                </button>
                <button
                  onClick={() => setShowCancelModal(true)}
                  className="px-3 py-1 text-sm font-medium text-red-600 hover:text-red-500 border border-red-600 rounded"
                >
                  Cancel Order
                </button>
              </>
            )}
          </div>
        </div>

        <div className="mt-6 border-t border-gray-200 pt-6">
          <dl className="grid grid-cols-1 gap-x-4 gap-y-6 sm:grid-cols-2">
            <div>
              <dt className="text-sm font-medium text-gray-500">Aircraft</dt>
              <dd className="mt-1">
                <div className="text-sm text-gray-900">{workOrder.aircraft.tail_number}</div>
                <div className="text-sm text-gray-500">
                  {workOrder.aircraft.manufacturer} {workOrder.aircraft.model}
                </div>
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">Location</dt>
              <dd className="mt-1">
                <div className="text-sm text-gray-900">{workOrder.fbo.name}</div>
                <div className="text-sm text-gray-500">{workOrder.fbo.icao.code}</div>
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">Service</dt>
              <dd className="mt-1">
                <div className="text-sm text-gray-900">{workOrder.service.name}</div>
                <div className="text-sm text-gray-500">{workOrder.service.type.name}</div>
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">Quantity</dt>
              <dd className="mt-1 text-sm text-gray-900">
                {workOrder.quantity} units
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">Price</dt>
              <dd className="mt-1 text-sm text-gray-900">
                ${workOrder.service.price}/unit
                <div className="text-sm text-gray-500">
                  Total: ${totalCost.toFixed(2)}
                </div>
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">Requested Date</dt>
              <dd className="mt-1 text-sm text-gray-900">
                {new Date(workOrder.requested_date).toLocaleString()}
              </dd>
            </div>

            {workOrder.completed_date && (
              <div>
                <dt className="text-sm font-medium text-gray-500">Completed Date</dt>
                <dd className="mt-1 text-sm text-gray-900">
                  {new Date(workOrder.completed_date).toLocaleString()}
                </dd>
              </div>
            )}

            <div className="sm:col-span-2">
              <dt className="text-sm font-medium text-gray-500">Description</dt>
              <dd className="mt-1 text-sm text-gray-900">{workOrder.description}</dd>
            </div>

            <div className="sm:col-span-2 border-t border-gray-200 pt-4">
              <dt className="text-sm font-medium text-gray-500 mb-4">Passenger Information</dt>
              <dd className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div className="flex items-center space-x-3 bg-gray-50 p-3 rounded-lg">
                  <Users className="h-5 w-5 text-gray-400" />
                  <div>
                    <div className="text-sm font-medium text-gray-900">{workOrder.passenger_count}</div>
                    <div className="text-xs text-gray-500">Passengers</div>
                  </div>
                </div>

                <div className="flex items-center space-x-3 bg-gray-50 p-3 rounded-lg">
                  <UserCircle2 className="h-5 w-5 text-gray-400" />
                  <div>
                    <div className="text-sm font-medium text-gray-900">{workOrder.crew_count}</div>
                    <div className="text-xs text-gray-500">Crew</div>
                  </div>
                </div>

                <div className="flex items-center space-x-3 bg-gray-50 p-3 rounded-lg">
                  <Dog className="h-5 w-5 text-gray-400" />
                  <div>
                    <div className="text-sm font-medium text-gray-900">{workOrder.pet_count}</div>
                    <div className="text-xs text-gray-500">Pets</div>
                  </div>
                </div>
              </dd>
            </div>
          </dl>
        </div>

        <div className="mt-6 flex justify-between items-center border-t border-gray-200 pt-4">
          <button
            type="button"
            onClick={onClose}
            className="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50"
          >
            Close
          </button>
          
          {workOrder.status === 'pending' && (
            <button
              onClick={() => handleStatusUpdate('in_progress')}
              className="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700"
              disabled={loading}
            >
              Start Work
            </button>
          )}

          {workOrder.status === 'in_progress' && (
            <button
              onClick={() => handleStatusUpdate('completed')}
              className="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-green-600 hover:bg-green-700"
              disabled={loading}
            >
              Mark Complete
            </button>
          )}
        </div>

        <Modal
          isOpen={showCancelModal}
          onClose={() => setShowCancelModal(false)}
          title="Cancel Work Order"
        >
          <div className="p-6">
            <p className="text-gray-700 mb-4">
              Are you sure you want to cancel this work order? This action cannot be undone.
            </p>
            {error && (
              <p className="text-red-600 mb-4">{error}</p>
            )}
            <div className="flex justify-end space-x-4">
              <button
                onClick={() => setShowCancelModal(false)}
                className="px-4 py-2 text-gray-700 border border-gray-300 rounded-md hover:bg-gray-50"
                disabled={loading}
              >
                No, Keep It
              </button>
              <button
                onClick={handleCancel}
                className="px-4 py-2 text-white bg-red-600 rounded-md hover:bg-red-700"
                disabled={loading}
              >
                {loading ? 'Cancelling...' : 'Yes, Cancel Order'}
              </button>
            </div>
          </div>
        </Modal>

        <Modal
          isOpen={showEditModal}
          onClose={() => setShowEditModal(false)}
          title="Edit Work Order"
        >
          <WorkOrderForm
            initialData={{
              aircraft_id: workOrder.aircraft_id,
              service_id: workOrder.service_id,
              fbo_id: workOrder.fbo_id,
              quantity: workOrder.quantity,
              description: workOrder.description,
              requested_date: workOrder.requested_date,
              arrival_date: workOrder.arrival_date,
              departure_date: workOrder.departure_date,
              passenger_count: workOrder.passenger_count,
              crew_count: workOrder.crew_count,
              pet_count: workOrder.pet_count
            }}
            onSubmit={handleEdit}
            onCancel={() => setShowEditModal(false)}
          />
        </Modal>
      </div>
    </div>
  );
}