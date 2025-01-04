import { formatDateTime } from '../../utils/date';
import { getTransitIcon } from '../../utils/transitIcons';
import type { Leg, TransitType } from '../../types/trip';

interface LegPopupProps {
  leg: Leg;
  transitCategory: string;
  transitType: TransitType;
}

export function LegPopup({ leg, transitCategory, transitType }: LegPopupProps) {
  const Icon = getTransitIcon(transitType.name);

  return (
    <div className="min-w-[250px] p-3">
      <div className="flex items-center gap-2 mb-2">
        <Icon className="h-5 w-5" style={{ color: transitType.color }} />
        <h3 className="text-lg font-semibold">{transitCategory} Details</h3>
      </div>
      
      <div className="space-y-2">
        <div>
          <div className="text-sm font-medium text-gray-500">Route</div>
          <div className="text-base">
            {leg.origin.code} → {leg.destination.code}
          </div>
        </div>

        <div>
          <div className="text-sm font-medium text-gray-500">Departure</div>
          <div className="text-base">{formatDateTime(leg.scheduled_departure)}</div>
        </div>

        <div>
          <div className="text-sm font-medium text-gray-500">Arrival</div>
          <div className="text-base">{formatDateTime(leg.scheduled_arrival)}</div>
        </div>

        {leg.notes && (
          <div>
            <div className="text-sm font-medium text-gray-500">Notes</div>
            <div className="text-base">{leg.notes}</div>
          </div>
        )}

        <div className="pt-2">
          <span className={`inline-block px-2 py-1 text-sm rounded-full ${
            leg.status === 'scheduled' ? 'bg-blue-100 text-blue-800' :
            leg.status === 'departed' ? 'bg-yellow-100 text-yellow-800' :
            leg.status === 'arrived' ? 'bg-green-100 text-green-800' :
            'bg-red-100 text-red-800'
          }`}>
            {leg.status.charAt(0).toUpperCase() + leg.status.slice(1)}
          </span>
        </div>
      </div>
    </div>
  );
}