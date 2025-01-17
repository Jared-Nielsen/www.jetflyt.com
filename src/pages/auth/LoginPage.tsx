import { useState } from 'react';
import { useNavigate, useLocation, Link } from 'react-router-dom';
import { useAuth } from '../../contexts/AuthContext';
import { Plane } from 'lucide-react';
import { SEO } from '../../components/SEO';
import { useTranslation } from 'react-i18next';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  
  const { signIn } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const { t } = useTranslation();
  const from = (location.state as any)?.from?.pathname || '/';

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email || !password) {
      setError(t('auth.errors.requiredFields'));
      return;
    }

    try {
      setError('');
      setLoading(true);
      await signIn(email, password);
      navigate(from, { replace: true });
    } catch (err: any) {
      console.error('Login error:', err);
      if (err?.name === 'AuthApiError' && err?.status === 400) {
        setError(t('auth.errors.invalidCredentials'));
      } else {
        setError(t('auth.errors.generalError'));
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <SEO 
        title={t('auth.signIn')}
        description={t('auth.signInDescription')}
        noindex={true}
      />
      <div className="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
        <div className="max-w-md w-full space-y-8">
          <div className="text-center">
            <div className="flex justify-center">
              <Plane className="h-12 w-12 text-blue-900" />
            </div>
            <h2 className="mt-6 text-3xl font-extrabold text-gray-900">
              {t('auth.signInToJetFlyt')}
            </h2>
            <p className="mt-2 text-sm text-gray-600">
              {t('auth.or')}{' '}
              <Link to="/auth/register" className="font-medium text-blue-600 hover:text-blue-500">
                {t('auth.createAccount')}
              </Link>
            </p>
          </div>

          <form className="mt-8 space-y-6" onSubmit={handleSubmit}>
            {error && (
              <div className="bg-red-50 border-l-4 border-red-400 p-4">
                <p className="text-sm text-red-700">{error}</p>
              </div>
            )}

            <div className="rounded-md shadow-sm space-y-4">
              <div>
                <label htmlFor="email" className="sr-only">{t('auth.emailAddress')}</label>
                <input
                  id="email"
                  name="email"
                  type="email"
                  autoComplete="email"
                  required
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
                  placeholder={t('auth.emailAddress')}
                />
              </div>
              <div>
                <label htmlFor="password" className="sr-only">{t('auth.password')}</label>
                <input
                  id="password"
                  name="password"
                  type="password"
                  autoComplete="current-password"
                  required
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
                  placeholder={t('auth.password')}
                />
              </div>
            </div>

            <div>
              <button
                type="submit"
                disabled={loading}
                className="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50"
              >
                {loading ? t('auth.signingIn') : t('auth.signIn')}
              </button>
            </div>
          </form>
        </div>
      </div>
    </>
  );
}