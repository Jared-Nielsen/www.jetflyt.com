import { useState } from 'react';
import { TenderStatus } from './TenderStatus';
import { FBOOfferList } from './FBOOfferList';
import { Modal } from '../shared/Modal';
import { TenderForm } from './TenderForm';
import { useTender } from '../../hooks/useTender';
import type { Tender } from '../../types/tender';
import { Pencil, Calendar, ArrowRight, CalendarCheck } from 'lucide-react';
import { useTranslation } from 'react-i18next';

interface TenderDetailsProps {
  tender: Tender;
  onClose: () => void;
  onTenderUpdated: () => void;
}

export function TenderDetails({ tender, onClose, onTenderUpdated }: TenderDetailsProps) {
  const [showCancelModal, setShowCancelModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showContractModal, setShowContractModal] = useState(false);
  const [selectedFBO, setSelectedFBO] = useState<any>(null);
  const { cancelTender, updateTender, getTenders, loading, error } = useTender();
  const [currentTender, setCurrentTender] = useState(tender);
  const { t } = useTranslation();
  
  const totalValue = currentTender.gallons * currentTender.target_price;

  const isAnnual = currentTender.start_date && currentTender.end_date && 
    new Date(currentTender.end_date).getTime() - new Date(currentTender.start_date).getTime() >= 364 * 24 * 60 * 60 * 1000 &&
    new Date(currentTender.end_date).getTime() - new Date(currentTender.start_date).getTime() <= 366 * 24 * 60 * 60 * 1000;

  const refreshTenderData = async () => {
    try {
      const tenders = await getTenders();
      const updatedTender = tenders?.find(t => t.id === currentTender.id);
      if (updatedTender) {
        setCurrentTender(updatedTender);
      }
    } catch (err) {
      console.error('Error refreshing tender data:', err);
    }
  };

  const handleCancel = async () => {
    try {
      await cancelTender(currentTender.id);
      await onTenderUpdated();
      setShowCancelModal(false);
      window.location.reload();
    } catch (err) {
      console.error('Error cancelling tender:', err);
    }
  };

  const handleEdit = async (data: any) => {
    try {
      await updateTender(currentTender.id, {
        gallons: data.gallons,
        target_price: data.target_price,
        description: data.description,
        start_date: data.start_date,
        end_date: data.end_date
      });
      await refreshTenderData();
      setShowEditModal(false);
    } catch (err) {
      console.error('Error updating tender:', err);
    }
  };

  const handleContractSend = async () => {
    try {
      await updateTender(currentTender.id, { status: 'accepted' });
      await refreshTenderData();
      setShowContractModal(false);
    } catch (err) {
      console.error('Error sending contract:', err);
    }
  };

  return (
    <div className="bg-white shadow sm:rounded-lg">
      <div className="px-4 py-5 sm:p-6">
        <div className="flex justify-between items-start">
          <div>
            <h3 className="text-lg font-medium text-gray-900">{t('tenders.details.title')}</h3>
            <div className="mt-2 text-sm text-gray-500">
              {t('tenders.details.created')} {new Date(currentTender.created_at).toLocaleDateString()}
            </div>
            {(currentTender.start_date || currentTender.end_date) && (
              <div className="mt-2 flex items-center text-sm text-gray-500">
                {isAnnual ? (
                  <CalendarCheck className="h-4 w-4 mr-1 text-green-600" />
                ) : (
                  <Calendar className="h-4 w-4 mr-1" />
                )}
                <span>
                  {currentTender.start_date && new Date(currentTender.start_date).toLocaleDateString()}
                  {currentTender.end_date && (
                    <>
                      <ArrowRight className="inline-block h-4 w-4 mx-1" />
                      {new Date(currentTender.end_date).toLocaleDateString()}
                    </>
                  )}
                </span>
              </div>
            )}
          </div>
          <div className="flex items-center space-x-4">
            <TenderStatus status={currentTender.status} />
            {currentTender.status === 'pending' && (
              <>
                <button
                  onClick={() => setShowEditModal(true)}
                  className="flex items-center px-3 py-1 text-sm font-medium text-blue-600 hover:text-blue-500 border border-blue-600 rounded"
                >
                  <Pencil className="h-4 w-4 mr-1" />
                  {t('tenders.form.buttons.edit')}
                </button>
                <button
                  onClick={() => setShowCancelModal(true)}
                  className="px-3 py-1 text-sm font-medium text-red-600 hover:text-red-500 border border-red-600 rounded"
                >
                  {t('tenders.form.buttons.cancelTender')}
                </button>
              </>
            )}
          </div>
        </div>

        <div className="mt-6 border-t border-gray-200 pt-6">
          <dl className="grid grid-cols-1 gap-x-4 gap-y-6 sm:grid-cols-2">
            <div>
              <dt className="text-sm font-medium text-gray-500">{t('tenders.details.aircraft')}</dt>
              <dd className="mt-1">
                <div className="text-sm text-gray-900">{currentTender.aircraft.tail_number}</div>
                <div className="text-sm text-gray-500">
                  {currentTender.aircraft.manufacturer} {currentTender.aircraft.model}
                </div>
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">{t('tenders.details.location')}</dt>
              <dd className="mt-1">
                <div className="text-sm text-gray-900">{currentTender.icao.code}</div>
                <div className="text-sm text-gray-500">{currentTender.icao.name}</div>
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">{t('tenders.details.fuelRequest')}</dt>
              <dd className="mt-1 text-sm text-gray-900">
                {currentTender.gallons.toLocaleString()} gal
              </dd>
            </div>

            <div>
              <dt className="text-sm font-medium text-gray-500">{t('tenders.details.bestPrice')}</dt>
              <dd className="mt-1 text-sm text-gray-900">
                ${currentTender.target_price.toFixed(2)}/gal
                <div className="text-sm text-gray-500">
                  {t('tenders.details.totalValue')}: ${totalValue.toLocaleString(undefined, { minimumFractionDigits: 2 })}
                </div>
              </dd>
            </div>

            {currentTender.description && (
              <div className="sm:col-span-2">
                <dt className="text-sm font-medium text-gray-500">{t('tenders.details.description')}</dt>
                <dd className="mt-1 text-sm text-gray-900">{currentTender.description}</dd>
              </div>
            )}
          </dl>
        </div>

        <div className="mt-8">
          <h4 className="text-lg font-medium text-gray-900">{t('tenders.details.fboResponses')}</h4>
          <div className="mt-4">
            <FBOOfferList 
              offers={currentTender.fbo_tenders}
              tenderId={currentTender.id}
              tenderStatus={currentTender.status}
              onOfferAccepted={refreshTenderData}
            />
          </div>
        </div>

        <div className="mt-6 flex justify-between items-center border-t border-gray-200 pt-4">
          <button
            type="button"
            onClick={onClose}
            className="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50"
          >
            {t('tenders.form.buttons.close')}
          </button>
          <div className="text-sm text-gray-500">
            {t('tenders.details.tenderId')}: {currentTender.id}
          </div>
        </div>

        <Modal
          isOpen={showCancelModal}
          onClose={() => setShowCancelModal(false)}
          title={t('tenders.form.title.cancel')}
        >
          <div className="p-6">
            <p className="text-gray-700 mb-4">
              {t('tenders.form.confirmCancel')}
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
                {t('tenders.form.buttons.keepIt')}
              </button>
              <button
                onClick={handleCancel}
                className="px-4 py-2 text-white bg-red-600 rounded-md hover:bg-red-700"
                disabled={loading}
              >
                {loading ? t('tenders.form.buttons.cancelling') : t('tenders.form.buttons.confirmCancel')}
              </button>
            </div>
          </div>
        </Modal>

        <Modal
          isOpen={showEditModal}
          onClose={() => setShowEditModal(false)}
          title={t('tenders.form.title.edit')}
        >
          <TenderForm
            initialData={currentTender}
            onSubmit={handleEdit}
            onCancel={() => setShowEditModal(false)}
          />
        </Modal>

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
                onClick={handleContractSend}
                className="px-4 py-2 bg-black text-white rounded-md hover:bg-gray-800"
              >
                {t('tenders.offers.buttons.close')}
              </button>
            </div>
          </div>
        </Modal>
      </div>
    </div>
  );
}