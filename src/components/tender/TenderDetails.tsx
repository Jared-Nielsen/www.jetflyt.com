import { useState } from 'react';
import { TenderStatus } from './TenderStatus';
import { FBOOfferList } from './FBOOfferList';
import { Modal } from '../shared/Modal';
import { useTender } from '../../hooks/useTender';
import type { Tender } from '../../types/tender';

interface TenderDetailsProps {
  tender: Tender;
  onClose: () => void;
  onTenderUpdated: () => void;
}

export function TenderDetails({ tender, onClose, onTenderUpdated }: TenderDetailsProps) {
  const [showCancelModal, setShowCancelModal] = useState(false);
  const { cancelTender, loading, error } = useTender();
  const totalValue = tender.gallons * tender.target_price;

  const handleCancel = async () => {
    try {
      await cancelTender(tender.id);
      await onTenderUpdated();
      setShowCancelModal(false);
      window.location.reload();
    } catch (err) {
      console.error('Error cancelling tender:', err);
    }
  };

  return (
    <div className="bg-white shadow sm:rounded-lg">
      <div className="px-4 py-5 sm:p-6">
        <div className="flex justify-between items-start">
          <div>
            <h3 className="text-lg font-medium text-gray-900">Tender Details</h3>
            <div className="mt-2 text-sm text-gray-500">
              Created {new Date(tender.created_at).toLocaleDateString()}
            </div>
          </div>
          <div className="flex items-center space-x-4">
            <TenderStatus status={tender.status} />
            {tender.status === 'pending' && (
              <button
                onClick={() => setShowCancelModal(true)}
                className="px-3 py-1 text-sm font-medium text-red-600 hover:text-red-500 border border-red-600 rounded"
              >
                Cancel Tender
              </button>
            )}
          </div>
        </div>

        <div className="mt-6 border-t border-gray-200 pt-6">
          <dl className="grid grid-cols-1 gap-x-4 gap-y-6 sm:grid-cols-2">
            <div>
              <dt className="text-sm font-medium text-gray-500">Aircraft</dt>
              <dd className="mt-1">
                <div className="text-sm text-gray-900">{tender.aircraft.tail_number}</div>
                <div className="text-sm text-gray-500">
                  {tender.aircraft.manufacturer} {tender.aircraft.model}
                </div>
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">Location</dt>
              <dd className="mt-1">
                <div className="text-sm text-gray-900">{tender.icao.code}</div>
                <div className="text-sm text-gray-500">{tender.icao.name}</div>
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">Fuel Request</dt>
              <dd className="mt-1 text-sm text-gray-900">
                {tender.gallons.toLocaleString()} gallons
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">Target Price</dt>
              <dd className="mt-1 text-sm text-gray-900">
                ${tender.target_price.toFixed(2)}/gal
                <div className="text-sm text-gray-500">
                  Total Value: ${totalValue.toLocaleString(undefined, { minimumFractionDigits: 2 })}
                </div>
              </dd>
            </div>

            {tender.description && (
              <div className="sm:col-span-2">
                <dt className="text-sm font-medium text-gray-500">Description</dt>
                <dd className="mt-1 text-sm text-gray-900">{tender.description}</dd>
              </div>
            )}
          </dl>
        </div>

        <div className="mt-8">
          <h4 className="text-lg font-medium text-gray-900">FBO Responses</h4>
          <div className="mt-4">
            <FBOOfferList 
              offers={tender.fbo_tenders}
              tenderId={tender.id}
              tenderStatus={tender.status}
              onOfferAccepted={onTenderUpdated}
            />
          </div>
        </div>

        <div className="mt-6 flex justify-between items-center border-t border-gray-200 pt-4">
          <button
            type="button"
            onClick={onClose}
            className="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50"
          >
            Close
          </button>
          <div className="text-sm text-gray-500">
            Tender ID: {tender.id}
          </div>
        </div>

        <Modal
          isOpen={showCancelModal}
          onClose={() => setShowCancelModal(false)}
          title="Cancel Tender"
        >
          <div className="p-6">
            <p className="text-gray-700 mb-4">
              Are you sure you want to cancel this tender? This action cannot be undone.
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
                {loading ? 'Cancelling...' : 'Yes, Cancel Tender'}
              </button>
            </div>
          </div>
        </Modal>
      </div>
    </div>
  );
}