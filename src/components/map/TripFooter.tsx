import { useState } from 'react';
import { ChevronUp, ChevronDown, Plus } from 'lucide-react';
import { useTrip } from '../../hooks/useTrip';
import { useAuth } from '../../contexts/AuthContext';
import { RouteList } from './RouteList';
import { AddTripModal } from '../dispatch/AddTripModal';
import { useTranslation } from 'react-i18next';

export function TripFooter() {
  const [isExpanded, setIsExpanded] = useState(false);
  const [showAddModal, setShowAddModal] = useState(false);
  const { activeTrip } = useTrip();
  const { user } = useAuth();
  const { t } = useTranslation();

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white shadow-lg z-[1000]">
      <div className="flex items-center justify-between px-4 py-2 border-b">
        <button
          onClick={() => setIsExpanded(!isExpanded)}
          className="flex items-center space-x-2 text-gray-700"
        >
          {isExpanded ? (
            <ChevronDown className="h-5 w-5" />
          ) : (
            <ChevronUp className="h-5 w-5" />
          )}
          <span className="font-medium">
            {activeTrip ? activeTrip.name : t('trip.noActiveTrip')}
          </span>
        </button>
        <button
          onClick={() => user && setShowAddModal(true)}
          disabled={!user}
          className={`flex items-center space-x-1 px-3 py-1 rounded ${
            user 
              ? 'bg-blue-600 text-white hover:bg-blue-700' 
              : 'bg-gray-100 text-gray-400 cursor-not-allowed'
          }`}
          title={user ? t('trip.newTrip') : t('trip.signInRequired')}
        >
          <Plus className="h-4 w-4" />
          <span>{t('trip.newTrip')}</span>
        </button>
      </div>

      {isExpanded && activeTrip && (
        <div className="p-4 max-h-64 overflow-y-auto">
          <RouteList trip={activeTrip} />
        </div>
      )}

      <AddTripModal
        isOpen={showAddModal}
        onClose={() => setShowAddModal(false)}
      />
    </div>
  );
}