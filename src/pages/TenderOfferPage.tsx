import { useState, useEffect, useCallback } from 'react';
import { Plus } from 'lucide-react';
import { Modal } from '../components/shared/Modal';
import { TenderForm } from '../components/tender/TenderForm';
import { TenderList } from '../components/tender/TenderList';
import { useTender } from '../hooks/useTender';
import { SEO } from '../components/SEO';
import { LoadingScreen } from '../components/auth/LoadingScreen';
import { useTranslation } from 'react-i18next';

export default function TenderOfferPage() {
  const [showForm, setShowForm] = useState(false);
  const { loading, error, createTender, getTenders } = useTender();
  const [tenders, setTenders] = useState<any[]>([]);
  const { t } = useTranslation();

  const loadTenders = useCallback(async () => {
    try {
      const data = await getTenders();
      setTenders(data || []);
    } catch (err) {
      console.error('Error loading tenders:', err);
    }
  }, [getTenders]);

  useEffect(() => {
    loadTenders();
  }, []); // Only run on mount

  const handleSubmit = async (data: any) => {
    try {
      const { selected_fbos, ...tenderData } = data;
      await createTender(tenderData, selected_fbos);
      window.location.href = '/tender-offer'; // Hard reload after creation
    } catch (err) {
      console.error('Error submitting tender:', err);
    }
  };

  if (loading && tenders.length === 0) {
    return <LoadingScreen />;
  }

  return (
    <>
      <SEO 
        title={t('tenders.title')}
        description={t('tenders.subtitle')}
      />
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="sm:flex sm:items-center sm:justify-between">
          <div>
            <h1 className="text-2xl font-semibold text-gray-900">{t('tenders.title')}</h1>
            <p className="mt-2 text-sm text-gray-700">
              {t('tenders.subtitle')}
            </p>
          </div>
          <div className="mt-4 sm:mt-0">
            <button
              onClick={() => setShowForm(true)}
              className="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700"
            >
              <Plus className="h-4 w-4 mr-2" />
              {t('tenders.newTender')}
            </button>
          </div>
        </div>

        {error && (
          <div className="mt-4 bg-red-50 border-l-4 border-red-400 p-4">
            <p className="text-red-700">{error}</p>
          </div>
        )}

        <div className="mt-8">
          <TenderList tenders={tenders} onTendersUpdated={loadTenders} />
        </div>

        <Modal
          isOpen={showForm}
          onClose={() => setShowForm(false)}
          title={t('tenders.form.title.new')}
        >
          <TenderForm
            onSubmit={handleSubmit}
            onCancel={() => setShowForm(false)}
          />
        </Modal>
      </div>
    </>
  );
}