import React, { useState } from 'react';
import { TenderStatus } from './TenderStatus';
import { TenderDetails } from './TenderDetails';
import type { Tender } from '../../types/tender';
import { useTender } from '../../hooks/useTender';
import { useTranslation } from 'react-i18next';

interface TenderListProps {
  tenders: (Tender & {
    aircraft: { tail_number: string; manufacturer: string; model: string };
    icao: { code: string; name: string };
    fbo_tenders: Array<any>;
  })[];
  onTendersUpdated: () => void;
}

export function TenderList({ tenders, onTendersUpdated }: TenderListProps) {
  const [selectedTender, setSelectedTender] = useState<typeof tenders[0] | null>(null);
  const { t } = useTranslation();

  if (tenders.length === 0) {
    return (
      <div className="text-center py-8 bg-white rounded-lg shadow">
        <p className="text-gray-500">{t('tenders.offers.noResponses')}</p>
      </div>
    );
  }

  if (selectedTender) {
    return (
      <TenderDetails 
        tender={selectedTender} 
        onClose={() => setSelectedTender(null)}
        onTenderUpdated={onTendersUpdated}
      />
    );
  }

  // Mobile card view
  const MobileView = () => (
    <div className="space-y-4">
      {tenders.map((tender) => (
        <div 
          key={tender.id}
          onClick={() => setSelectedTender(tender)}
          className="bg-white shadow rounded-lg p-4 cursor-pointer hover:bg-gray-50"
        >
          <div className="flex justify-between items-start mb-2">
            <div>
              <div className="font-medium text-gray-900">
                {tender.aircraft.tail_number}
              </div>
              <div className="text-sm text-gray-500">
                {tender.aircraft.manufacturer} {tender.aircraft.model}
              </div>
            </div>
            <TenderStatus status={tender.status} />
          </div>

          <div className="mt-2">
            <div className="text-sm font-medium text-gray-900">
              {tender.icao.code}
            </div>
            <div className="text-xs text-gray-500">
              {tender.icao.name}
            </div>
          </div>

          <div className="mt-2 flex justify-between items-end">
            <div className="text-sm text-gray-600">
              {tender.gallons.toLocaleString()} gal
            </div>
            <div className="text-sm text-gray-600">
              ${tender.target_price.toFixed(2)}/gal
            </div>
          </div>

          <div className="mt-2 text-xs text-gray-500">
            {tender.fbo_tenders.length} FBO {tender.fbo_tenders.length !== 1 ? t('tenders.offers.responses') : t('tenders.offers.response')}
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
            {t('tenders.details.aircraft')}
          </th>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            {t('tenders.details.location')}
          </th>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            {t('tenders.details.fuelRequest')}
          </th>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            {t('tenders.details.bestPrice')}
          </th>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            {t('tenders.status.title')}
          </th>
          <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
            {t('tenders.details.fboResponses')}
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
                {tender.gallons.toLocaleString()} gal
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