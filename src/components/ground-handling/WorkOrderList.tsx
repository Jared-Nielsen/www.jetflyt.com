import React, { useState } from 'react';
import { WorkOrderStatus } from './WorkOrderStatus';
import { WorkOrderDetails } from './WorkOrderDetails';
import type { WorkOrder } from '../../types/workOrder';
import { useTranslation } from 'react-i18next';

interface WorkOrderListProps {
  workOrders: WorkOrder[];
  onWorkOrdersUpdated: () => void;
}

export function WorkOrderList({ workOrders, onWorkOrdersUpdated }: WorkOrderListProps) {
  const [selectedWorkOrder, setSelectedWorkOrder] = useState<WorkOrder | null>(null);
  const { t } = useTranslation();

  if (workOrders.length === 0) {
    return (
      <div className="text-center py-8 bg-white rounded-lg shadow">
        <p className="text-gray-500">{t('handling.noServiceTenders')}</p>
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
            <div className="text-sm font-medium text-gray-900 mb-1">{t('handling.list.fboLocations')}:</div>
            <div className="text-sm text-gray-500">
              {workOrder.fbo_associations.length} {t('handling.list.fboCount', { count: workOrder.fbo_associations.length })}
            </div>
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
            {t('handling.list.columns.aircraft')}
          </th>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            {t('handling.list.columns.service')}
          </th>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            {t('handling.list.columns.fboLocations')}
          </th>
          <th scope="col" className="hidden lg:table-cell px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            {t('handling.list.columns.description')}
          </th>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            {t('handling.list.columns.status')}
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
              <div className="text-sm text-gray-900">
                {workOrder.fbo_associations.length} {t('handling.list.fboCount', { count: workOrder.fbo_associations.length })}
              </div>
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