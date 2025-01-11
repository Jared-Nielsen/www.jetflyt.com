import React, { useState } from 'react';
import { WorkOrderDetails } from './WorkOrderDetails';
import { WorkOrderStatus } from './WorkOrderStatus';
import { supabase } from '../../lib/supabase';
import type { WorkOrder } from '../../types/workOrder';

interface WorkOrderListProps {
  workOrders: WorkOrder[];
  onWorkOrdersUpdated: () => void;
}

export function WorkOrderList({ workOrders, onWorkOrdersUpdated }: WorkOrderListProps) {
  const [selectedWorkOrder, setSelectedWorkOrder] = useState<WorkOrder | null>(null);
  const [loading, setLoading] = useState(false);

  const handleAcceptOffer = async (
    e: React.MouseEvent,
    workOrderId: string,
    fboAssociationId: string
  ) => {
    e.stopPropagation();
    try {
      setLoading(true);

      // Start a transaction by using the same timestamp for all updates
      const timestamp = new Date().toISOString();

      // Update the selected FBO association to accepted
      const { error: acceptError } = await supabase
        .from('work_order_fbos')
        .update({ 
          status: 'accepted',
          updated_at: timestamp 
        })
        .eq('id', fboAssociationId);

      if (acceptError) throw acceptError;

      // Update all other FBO associations for this work order to blank status
      const { error: rejectError } = await supabase
        .from('work_order_fbos')
        .update({ 
          status: '',
          updated_at: timestamp 
        })
        .eq('work_order_id', workOrderId)
        .neq('id', fboAssociationId);

      if (rejectError) throw rejectError;

      // Update the work order status to accepted
      const { error: workOrderError } = await supabase
        .from('work_orders')
        .update({ 
          status: 'accepted',
          updated_at: timestamp 
        })
        .eq('id', workOrderId);

      if (workOrderError) throw workOrderError;

      await onWorkOrdersUpdated();
    } catch (err) {
      console.error('Error accepting offer:', err);
      alert('Failed to accept offer. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const FBOList = ({ workOrder }: { workOrder: WorkOrder }) => {
    // Sort FBO associations alphabetically by FBO name
    const sortedAssociations = [...workOrder.fbo_associations].sort((a, b) => 
      a.fbo.name.localeCompare(b.fbo.name)
    );

    // Check if any FBO has been accepted
    const hasAcceptedFBO = sortedAssociations.some(assoc => assoc.status === 'accepted');

    return (
      <div className="space-y-1">
        {sortedAssociations.map(assoc => (
          <div key={assoc.id} className="flex justify-between items-center">
            <div>
              <span className="font-medium">{assoc.fbo.name}</span>
              <span className="text-gray-500 ml-1">({assoc.fbo.icao?.code})</span>
            </div>
            <div className="flex items-center space-x-2">
              {assoc.price > 0 && (
                <span className="text-sm font-medium text-gray-900">
                  ${assoc.price.toFixed(2)}
                </span>
              )}
              {/* Show Accept button or status badge */}
              <div className="w-16 text-right"> {/* Fixed width container for consistent spacing */}
                {!hasAcceptedFBO && assoc.status === 'pending' ? (
                  <button
                    onClick={(e) => handleAcceptOffer(e, workOrder.id, assoc.id)}
                    disabled={loading}
                    className="px-3 py-1 text-xs font-medium text-white bg-green-600 rounded-full hover:bg-green-700 disabled:opacity-50"
                  >
                    Accept
                  </button>
                ) : assoc.status === 'accepted' && (
                  <span className="inline-block text-xs px-2 py-0.5 rounded-full bg-green-100 text-green-800">
                    Accepted
                  </span>
                )}
              </div>
            </div>
          </div>
        ))}
      </div>
    );
  };

  if (workOrders.length === 0) {
    return (
      <div className="text-center py-8 bg-white rounded-lg shadow">
        <p className="text-gray-500">No service tenders found.</p>
      </div>
    );
  }

  if (selectedWorkOrder) {
    return (
      <WorkOrderDetails 
        workOrder={selectedWorkOrder} 
        onClose={() => setSelectedWorkOrder(null)}
        onWorkOrderUpdated={onWorkOrdersUpdated}
      />
    );
  }

  // Mobile card view
  const MobileView = () => (
    <div className="space-y-4">
      {workOrders.map((workOrder) => (
        <div 
          key={workOrder.id}
          onClick={() => setSelectedWorkOrder(workOrder)}
          className="bg-white shadow rounded-lg p-4 cursor-pointer hover:bg-gray-50"
        >
          <div className="flex justify-between items-start mb-2">
            <div>
              <div className="font-medium text-gray-900">
                {workOrder.aircraft.tail_number}
              </div>
              <div className="text-sm text-gray-500">
                {workOrder.aircraft.manufacturer} {workOrder.aircraft.model}
              </div>
            </div>
            <WorkOrderStatus status={workOrder.status} />
          </div>

          <div className="mt-2">
            <div className="text-sm font-medium text-gray-900">
              {workOrder.service.name}
            </div>
            <div className="text-sm text-gray-500">
              {workOrder.service.type.name}
            </div>
          </div>

          <div className="mt-3 border-t pt-2">
            <div className="text-sm font-medium text-gray-900 mb-1">FBO Locations:</div>
            <FBOList workOrder={workOrder} />
          </div>

          {workOrder.description && (
            <div className="mt-2 text-sm text-gray-600">
              {workOrder.description}
            </div>
          )}
        </div>
      ))}
    </div>
  );

  // Desktop table view
  const DesktopView = () => (
    <table className="min-w-full divide-y divide-gray-200">
      <thead className="bg-gray-50">
        <tr>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            Aircraft
          </th>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            Service
          </th>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            FBO Locations
          </th>
          <th scope="col" className="hidden lg:table-cell px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            Description
          </th>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            Status
          </th>
        </tr>
      </thead>
      <tbody className="bg-white divide-y divide-gray-200">
        {workOrders.map((workOrder) => (
          <tr 
            key={workOrder.id} 
            onClick={() => setSelectedWorkOrder(workOrder)}
            className="hover:bg-gray-50 cursor-pointer"
          >
            <td className="px-6 py-4 whitespace-nowrap">
              <div className="text-sm font-medium text-gray-900">
                {workOrder.aircraft.tail_number}
              </div>
              <div className="text-sm text-gray-500">
                {workOrder.aircraft.manufacturer} {workOrder.aircraft.model}
              </div>
            </td>
            <td className="px-6 py-4 whitespace-nowrap">
              <div className="text-sm font-medium text-gray-900">
                {workOrder.service.name}
              </div>
              <div className="text-sm text-gray-500">
                {workOrder.service.type.name}
              </div>
            </td>
            <td className="px-6 py-4">
              <FBOList workOrder={workOrder} />
            </td>
            <td className="hidden lg:table-cell px-6 py-4">
              <div className="text-sm text-gray-900">
                {workOrder.description}
              </div>
            </td>
            <td className="px-6 py-4 whitespace-nowrap">
              <WorkOrderStatus status={workOrder.status} />
            </td>
          </tr>
        ))}
      </tbody>
    </table>
  );

  return (
    <div className="bg-white shadow overflow-hidden sm:rounded-lg">
      <div className="block md:hidden">
        <MobileView />
      </div>
      <div className="hidden md:block">
        <DesktopView />
      </div>
    </div>
  );
}