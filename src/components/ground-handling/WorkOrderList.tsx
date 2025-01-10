import React, { useState } from 'react';
import { WorkOrderDetails } from './WorkOrderDetails';
import { WorkOrderStatus } from './WorkOrderStatus';
import type { WorkOrder } from '../../types/workOrder';

interface WorkOrderListProps {
  workOrders: WorkOrder[];
  onWorkOrdersUpdated: () => void;
}

export function WorkOrderList({ workOrders, onWorkOrdersUpdated }: WorkOrderListProps) {
  const [selectedWorkOrder, setSelectedWorkOrder] = useState<WorkOrder | null>(null);

  if (workOrders.length === 0) {
    return (
      <div className="text-center py-8 bg-white rounded-lg shadow">
        <p className="text-gray-500">No work orders found.</p>
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
              {workOrder.fbo.icao.code} - {workOrder.fbo.name}
            </div>
            <div className="text-sm text-gray-500">
              {workOrder.service.name}
            </div>
          </div>

          <div className="mt-2 flex justify-between items-end">
            <div className="text-sm text-gray-600">
              Qty: {workOrder.quantity}
            </div>
            <div className="text-sm text-gray-600">
              {new Date(workOrder.requested_date).toLocaleDateString()}
            </div>
          </div>
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
            Location
          </th>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            Service
          </th>
          <th scope="col" className="hidden lg:table-cell px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            Description
          </th>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            Quantity
          </th>
          <th scope="col" className="hidden lg:table-cell px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            Price
          </th>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            Requested Date
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
                {workOrder.fbo.name}
              </div>
              <div className="text-sm text-gray-500">
                {workOrder.fbo.icao.code}
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
            <td className="hidden lg:table-cell px-6 py-4">
              <div className="text-sm text-gray-900">
                {workOrder.description}
              </div>
            </td>
            <td className="px-6 py-4 whitespace-nowrap">
              <div className="text-sm text-gray-900">
                {workOrder.quantity}
              </div>
            </td>
            <td className="hidden lg:table-cell px-6 py-4 whitespace-nowrap">
              <div className="text-sm text-gray-900">
                ${(workOrder.quantity * workOrder.service.price).toFixed(2)}
              </div>
              <div className="text-xs text-gray-500">
                ${workOrder.service.price}/unit
              </div>
            </td>
            <td className="px-6 py-4 whitespace-nowrap">
              <div className="text-sm text-gray-900">
                {new Date(workOrder.requested_date).toLocaleDateString()}
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
      {/* Show mobile view on small screens, desktop view on medium and up */}
      <div className="block md:hidden">
        <MobileView />
      </div>
      <div className="hidden md:block">
        <DesktopView />
      </div>
    </div>
  );
}