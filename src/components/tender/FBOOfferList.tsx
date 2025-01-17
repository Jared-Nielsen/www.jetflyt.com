import React, { useState } from 'react';
import { Check } from 'lucide-react';
import { Modal } from '../shared/Modal';
import { useTender } from '../../hooks/useTender';
import type { FBOTender } from '../../types/tender';
import { useTranslation } from 'react-i18next';

interface FBOOfferListProps {
  offers: FBOTender[];
  tenderId: string;
  tenderStatus: string;
  onOfferAccepted: () => Promise<void>;
}

export function FBOOfferList({ offers, tenderId, tenderStatus, onOfferAccepted }: FBOOfferListProps) {
  const [showContractModal, setShowContractModal] = useState(false);
  const [selectedFBO, setSelectedFBO] = useState<FBOTender['fbo'] | null>(null);
  const { acceptOffer, loading } = useTender();
  const { t } = useTranslation();

  const handleAcceptOffer = async (offerId: string, fbo: FBOTender['fbo']) => {
    try {
      await acceptOffer(offerId, tenderId);
      await onOfferAccepted();
      setSelectedFBO(fbo);
      setShowContractModal(true);
    } catch (err) {
      console.error('Error accepting offer:', err);
      alert(t('tenders.offers.errors.acceptFailed'));
    }
  };

  if (offers.length === 0) {
    return (
      <div className="text-sm text-gray-500 italic">
        {t('tenders.offers.noResponses')}
      </div>
    );
  }

  return (
    <>
      <div className="overflow-x-auto">
        <table className="min-w-full divide-y divide-gray-200">
          <thead>
            <tr>
              <th scope="col" className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                {t('tenders.offers.columns.fbo')}
              </th>
              <th scope="col" className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                {t('tenders.offers.columns.location')}
              </th>
              <th scope="col" className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                {t('tenders.offers.columns.offerPrice')}
              </th>
              <th scope="col" className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                {t('tenders.offers.columns.totalCost')}
              </th>
              <th scope="col" className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                {t('tenders.offers.columns.taxesAndFees')}
              </th>
              <th scope="col" className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                {t('tenders.offers.columns.finalCost')}
              </th>
              <th scope="col" className="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                {t('tenders.offers.columns.actions')}
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {offers.map((offer) => {
              const finalCost = offer.total_cost + offer.taxes_and_fees;
              const hasCounterOffer = offer.counter_price && offer.counter_total_cost;
              const counterFinalCost = hasCounterOffer ? 
                (offer.counter_total_cost + (offer.counter_taxes_and_fees || 0)) : 0;
              
              return (
                <tr key={offer.id} className={`${offer.status === 'accepted' ? 'bg-gray-50' : 'bg-white'}`}>
                  <td className="px-4 py-3">
                    <div className="text-sm text-gray-900">
                      {offer.fbo?.name || `FBO ${offer.fbo_id}`}
                    </div>
                  </td>
                  <td className="px-4 py-3">
                    <div className="text-sm text-gray-900">
                      {offer.fbo?.icao?.code}
                    </div>
                    <div className="text-xs text-gray-500">
                      {offer.fbo?.icao?.name}
                    </div>
                  </td>
                  <td className="px-4 py-3">
                    <div className="text-sm text-gray-900">
                      ${offer.offer_price.toFixed(2)}/gal
                    </div>
                    {hasCounterOffer && (
                      <div className="text-sm text-blue-600 mt-1">
                        ${offer.counter_price.toFixed(2)}/gal
                      </div>
                    )}
                  </td>
                  <td className="px-4 py-3">
                    <div className="text-sm text-gray-900">
                      ${offer.total_cost.toLocaleString(undefined, { minimumFractionDigits: 2 })}
                    </div>
                    {hasCounterOffer && (
                      <div className="text-sm text-blue-600 mt-1">
                        ${offer.counter_total_cost.toLocaleString(undefined, { minimumFractionDigits: 2 })}
                      </div>
                    )}
                  </td>
                  <td className="px-4 py-3">
                    <div className="text-sm text-gray-900">
                      ${offer.taxes_and_fees.toLocaleString(undefined, { minimumFractionDigits: 2 })}
                    </div>
                    {hasCounterOffer && (
                      <div className="text-sm text-blue-600 mt-1">
                        ${(offer.counter_taxes_and_fees || 0).toLocaleString(undefined, { minimumFractionDigits: 2 })}
                      </div>
                    )}
                  </td>
                  <td className="px-4 py-3">
                    <div className="text-sm text-gray-900">
                      ${finalCost.toLocaleString(undefined, { minimumFractionDigits: 2 })}
                    </div>
                    {hasCounterOffer && (
                      <div className="text-sm text-blue-600 mt-1">
                        ${counterFinalCost.toLocaleString(undefined, { minimumFractionDigits: 2 })}
                      </div>
                    )}
                  </td>
                  <td className="px-4 py-3 text-right">
                    {offer.status === 'accepted' ? (
                      <button
                        onClick={() => {
                          setSelectedFBO(offer.fbo);
                          setShowContractModal(true);
                        }}
                        className="inline-flex items-center px-3 py-1 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-black"
                      >
                        <Check className="h-4 w-4 mr-1" />
                        {t('tenders.offers.buttons.sendContract')}
                      </button>
                    ) : tenderStatus === 'pending' && (
                      <button
                        onClick={() => handleAcceptOffer(offer.id, offer.fbo)}
                        className="inline-flex items-center px-3 py-1 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500"
                        disabled={loading}
                      >
                        {t('tenders.offers.buttons.accept')}
                      </button>
                    )}
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>

      <Modal
        isOpen={showContractModal}
        onClose={() => setShowContractModal(false)}
        title={t('tenders.offers.modal.contractTitle')}
      >
        <div className="p-6">
          <p className="text-lg text-gray-700">
            {t('tenders.offers.modal.contractSent', { fbo: selectedFBO?.name })}
          </p>
          <div className="mt-6 flex justify-end">
            <button
              onClick={() => {
                setShowContractModal(false);
                window.location.reload();
              }}
              className="px-4 py-2 bg-black text-white rounded-md hover:bg-gray-800"
            >
              {t('tenders.offers.buttons.close')}
            </button>
          </div>
        </div>
      </Modal>
    </>
  );
}