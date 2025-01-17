import { Trash2 } from 'lucide-react';
import { SEO } from '../../components/SEO';
import { STORAGE_KEYS } from '../../utils/storage';
import { useTranslation } from 'react-i18next';

export default function SupportPage() {
  const { t } = useTranslation();

  const clearCache = () => {
    // Clear all storage keys
    Object.values(STORAGE_KEYS).forEach(key => {
      localStorage.removeItem(key);
    });
    
    // Show confirmation
    window.alert(t('support.cacheCleared'));
    window.location.reload();
  };

  return (
    <>
      <SEO 
        title={t('support.title')}
        description={t('support.subtitle')}
      />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <h1 className="text-3xl font-bold mb-8">{t('support.title')}</h1>

        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          {/* Cache Management Card */}
          <div className="bg-white shadow rounded-lg p-6">
            <h2 className="text-xl font-semibold mb-4">{t('support.cache.title')}</h2>
            <p className="text-gray-600 mb-4">
              {t('support.cache.description')}
            </p>
            <button
              onClick={clearCache}
              className="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
            >
              <Trash2 className="h-4 w-4 mr-2" />
              {t('support.cache.refreshButton')}
            </button>
          </div>

          {/* Contact Support Card */}
          <div className="bg-white shadow rounded-lg p-6">
            <h2 className="text-xl font-semibold mb-4">{t('support.contact.title')}</h2>
            <p className="text-gray-600 mb-4">
              {t('support.contact.description')}
            </p>
            <div className="space-y-2">
              <p className="text-sm">
                <strong>{t('support.contact.email')}:</strong> support@jetflyt.com
              </p>
              <p className="text-sm">
                <strong>{t('support.contact.phone')}:</strong> +1 (800) 555-0123
              </p>
            </div>
          </div>

          {/* Documentation Card */}
          <div className="bg-white shadow rounded-lg p-6">
            <h2 className="text-xl font-semibold mb-4">{t('support.docs.title')}</h2>
            <p className="text-gray-600 mb-4">
              {t('support.docs.description')}
            </p>
            <a 
              href="#" 
              className="text-blue-600 hover:text-blue-500 font-medium"
            >
              {t('support.docs.viewButton')} →
            </a>
          </div>
        </div>
      </div>
    </>
  );
}