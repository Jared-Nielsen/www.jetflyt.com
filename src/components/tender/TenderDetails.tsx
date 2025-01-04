import { TenderStatus } from './TenderStatus';
import { FBOOfferList } from './FBOOfferList';
import type { Tender, FBOTender } from '../../types/tender';

interface TenderDetailsProps {
  tender: Tender & {
    aircraft: { tail_number: string; manufacturer: string; model: string };
    icao: { code: string; name: string };
    fbo_tenders: FBOTender[];
  };
  onClose: () => void;
}

export function TenderDetails({ tender, onClose }: TenderDetailsProps) {
  const totalValue = tender.gallons * tender.target_price;

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
          <TenderStatus status={tender.status} />
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
            />
          </div>
        </div>

        <div className="mt-6 flex justify-end">
          <button
            type="button"
            onClick={onClose}
            className="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50"
          >
            Close
          </button>
        </div>
      </div>
    </div>
  );
}