import React, { useState } from 'react';
import { TenderStatus } from './TenderStatus';
import { TenderDetails } from './TenderDetails';
import type { Tender } from '../../types/tender';

interface TenderListProps {
  tenders: (Tender & {
    aircraft: { tail_number: string; manufacturer: string; model: string };
    icao: { code: string; name: string };
    fbo_tenders: Array<any>;
  })[];
}

export function TenderList({ tenders }: TenderListProps) {
  const [selectedTender, setSelectedTender] = useState<typeof tenders[0] | null>(null);

  if (tenders.length === 0) {
    return (
      <div className="text-center py-8 bg-white rounded-lg shadow">
        <p className="text-gray-500">No tender offers found.</p>
      </div>
    );
  }

  if (selectedTender) {
    return (
      <TenderDetails 
        tender={selectedTender} 
        onClose={() => setSelectedTender(null)} 
      />
    );
  }

  return (
    <div className="bg-white shadow overflow-hidden sm:rounded-lg">
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
              Fuel Request
            </th>
            <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Target Price
            </th>
            <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Status
            </th>
            <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              FBO Responses
            </th>
          </tr>
        </thead>
        <tbody className="bg-white divide-y divide-gray-200">
          {tenders.map((tender) => (
            <tr 
              key={tender.id} 
              onClick={() => setSelectedTender(tender)}
              className="hover:bg-gray-50 cursor-pointer"
            >
              <td className="px-6 py-4 whitespace-nowrap">
                <div className="text-sm font-medium text-gray-900">
                  {tender.aircraft.tail_number}
                </div>
                <div className="text-sm text-gray-500">
                  {tender.aircraft.manufacturer} {tender.aircraft.model}
                </div>
              </td>
              <td className="px-6 py-4 whitespace-nowrap">
                <div className="text-sm font-medium text-gray-900">
                  {tender.icao.code}
                </div>
                <div className="text-sm text-gray-500">
                  {tender.icao.name}
                </div>
              </td>
              <td className="px-6 py-4 whitespace-nowrap">
                <div className="text-sm text-gray-900">
                  {tender.gallons.toLocaleString()} gallons
                </div>
              </td>
              <td className="px-6 py-4 whitespace-nowrap">
                <div className="text-sm text-gray-900">
                  ${tender.target_price.toFixed(2)}/gal
                </div>
              </td>
              <td className="px-6 py-4 whitespace-nowrap">
                <TenderStatus status={tender.status} />
              </td>
              <td className="px-6 py-4 whitespace-nowrap">
                <div className="text-sm text-gray-900">
                  {tender.fbo_tenders.length} FBOs
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}