import { Link } from 'react-router-dom';
import { Plane, FileText, BarChart3, Briefcase } from 'lucide-react';
import { SEO } from '../components/SEO';
import { useAuth } from '../contexts/AuthContext';
import { useTranslation } from 'react-i18next';

export default function LandingPage() {
  const { user } = useAuth();
  const { t } = useTranslation();

  return (
    <>
      <SEO 
        title="Welcome"
        description="Streamline your aviation fuel procurement process with JetFlyt's comprehensive tender management system."
      />
      <div className="min-h-[calc(100vh-64px)] bg-gradient-to-b from-blue-900 to-blue-700 text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pt-20">
          <div className="text-center">
            <Plane className="h-20 w-20 mx-auto mb-8" />
            <h1 className="text-5xl font-bold mb-4">{t('landing.title')}</h1>
            <p className="text-xl mb-12">{t('landing.subtitle')}</p>
          </div>

          <div className="grid md:grid-cols-4 gap-8 mt-16">
            {/* Protected features */}
            {user ? (
              <>
                <Link to="/tender-offer" className="bg-white/10 backdrop-blur-lg rounded-xl p-6 hover:bg-white/20 transition">
                  <FileText className="h-12 w-12 mb-4" />
                  <h2 className="text-2xl font-semibold mb-2">{t('landing.features.tenders.title')}</h2>
                  <p>{t('landing.features.tenders.description')}</p>
                </Link>

                <Link to="/ground-handling" className="bg-white/10 backdrop-blur-lg rounded-xl p-6 hover:bg-white/20 transition">
                  <Briefcase className="h-12 w-12 mb-4" />
                  <h2 className="text-2xl font-semibold mb-2">{t('landing.features.handling.title')}</h2>
                  <p>{t('landing.features.handling.description')}</p>
                </Link>

                <Link to="/fleet-registration" className="bg-white/10 backdrop-blur-lg rounded-xl p-6 hover:bg-white/20 transition">
                  <Plane className="h-12 w-12 mb-4" />
                  <h2 className="text-2xl font-semibold mb-2">{t('landing.features.fleet.title')}</h2>
                  <p>{t('landing.features.fleet.description')}</p>
                </Link>

                <Link to="/reports" className="bg-white/10 backdrop-blur-lg rounded-xl p-6 hover:bg-white/20 transition">
                  <BarChart3 className="h-12 w-12 mb-4" />
                  <h2 className="text-2xl font-semibold mb-2">{t('landing.features.reports.title')}</h2>
                  <p>{t('landing.features.reports.description')}</p>
                </Link>
              </>
            ) : (
              <>
                <div className="bg-white/5 backdrop-blur-lg rounded-xl p-6">
                  <FileText className="h-12 w-12 mb-4 opacity-50" />
                  <h2 className="text-2xl font-semibold mb-2">{t('landing.features.tenders.title')}</h2>
                  <p className="mb-4">{t('landing.features.tenders.description')}</p>
                  <Link to="/auth/login" className="text-sm text-blue-300 hover:text-blue-200">
                    {t('landing.auth.signInCta')}
                  </Link>
                </div>

                <div className="bg-white/5 backdrop-blur-lg rounded-xl p-6">
                  <Briefcase className="h-12 w-12 mb-4 opacity-50" />
                  <h2 className="text-2xl font-semibold mb-2">{t('landing.features.handling.title')}</h2>
                  <p className="mb-4">{t('landing.features.handling.description')}</p>
                  <Link to="/auth/login" className="text-sm text-blue-300 hover:text-blue-200">
                    {t('landing.auth.signInCta')}
                  </Link>
                </div>

                <div className="bg-white/5 backdrop-blur-lg rounded-xl p-6">
                  <Plane className="h-12 w-12 mb-4 opacity-50" />
                  <h2 className="text-2xl font-semibold mb-2">{t('landing.features.fleet.title')}</h2>
                  <p className="mb-4">{t('landing.features.fleet.description')}</p>
                  <Link to="/auth/login" className="text-sm text-blue-300 hover:text-blue-200">
                    {t('landing.auth.signInCta')}
                  </Link>
                </div>

                <div className="bg-white/5 backdrop-blur-lg rounded-xl p-6">
                  <BarChart3 className="h-12 w-12 mb-4 opacity-50" />
                  <h2 className="text-2xl font-semibold mb-2">{t('landing.features.reports.title')}</h2>
                  <p className="mb-4">{t('landing.features.reports.description')}</p>
                  <Link to="/auth/login" className="text-sm text-blue-300 hover:text-blue-200">
                    {t('landing.auth.signInCta')}
                  </Link>
                </div>
              </>
            )}
          </div>

          <div className="mt-20 text-center">
            <img
              src="https://images.unsplash.com/photo-1464037866556-6812c9d1c72e"
              alt="Aircraft refueling"
              className="rounded-lg mx-auto max-w-4xl w-full object-cover h-96"
            />
          </div>
        </div>
      </div>
    </>
  );
}