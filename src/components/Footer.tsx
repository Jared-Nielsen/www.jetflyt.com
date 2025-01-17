import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

export default function Footer() {
  const { t } = useTranslation();

  return (
    <footer className="bg-black text-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div>
            <h3 className="text-lg font-semibold mb-4">{t('footer.about.title')}</h3>
            <p className="text-gray-400">
              {t('footer.about.description')}
            </p>
          </div>
          
          <div>
            <h3 className="text-lg font-semibold mb-4">{t('footer.quickLinks.title')}</h3>
            <ul className="space-y-2">
              <li>
                <Link to="/fbos" className="text-gray-400 hover:text-white">
                  {t('footer.quickLinks.fboMap')}
                </Link>
              </li>
              <li>
                <Link to="/icaos" className="text-gray-400 hover:text-white">
                  {t('footer.quickLinks.airports')}
                </Link>
              </li>
              <li>
                <Link to="/dispatch" className="text-gray-400 hover:text-white">
                  {t('footer.quickLinks.dispatch')}
                </Link>
              </li>
              <li>
                <Link to="/support" className="text-gray-400 hover:text-white">
                  {t('footer.quickLinks.support')}
                </Link>
              </li>
            </ul>
          </div>
          
          <div>
            <h3 className="text-lg font-semibold mb-4">{t('footer.legal.title')}</h3>
            <ul className="space-y-2">
              <li>
                <Link to="/privacy" className="text-gray-400 hover:text-white">
                  {t('footer.legal.privacy')}
                </Link>
              </li>
              <li>
                <Link to="/terms" className="text-gray-400 hover:text-white">
                  {t('footer.legal.terms')}
                </Link>
              </li>
            </ul>
          </div>
          
          <div>
            <h3 className="text-lg font-semibold mb-4">{t('footer.contact.title')}</h3>
            <ul className="space-y-2">
              <li>
                <Link to="/contact" className="text-gray-400 hover:text-white">
                  {t('footer.contact.contactUs')}
                </Link>
              </li>
              <li className="text-gray-400">
                support@jetflyt.com
              </li>
            </ul>
          </div>
        </div>
        
        <div className="border-t border-gray-800 mt-8 pt-8 text-center text-gray-400">
          <p>{t('footer.copyright', { year: new Date().getFullYear() })}</p>
        </div>
      </div>
    </footer>
  );
}