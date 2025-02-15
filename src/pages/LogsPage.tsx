import { useState, useEffect } from 'react';
import { supabase } from '../lib/supabase';
import { SEO } from '../components/SEO';
import { useTranslation } from 'react-i18next';
import { useAuth } from '../contexts/AuthContext';
import { Navigate, useLocation } from 'react-router-dom';
import { LoadingScreen } from '../components/auth/LoadingScreen';

interface Log {
  id: string;
  tender_id: string;
  auth_id: string;
  changed_at: string;
  action: 'INSERT' | 'UPDATE' | 'DELETE';
  old_data: any;
  new_data: any;
  tender: {
    aircraft: {
      tail_number: string;
    };
    icao: {
      code: string;
    };
  };
  fbo_tender: {
    fbo: {
      name: string;
    };
  };
}

export default function LogsPage() {
  const [tenderLogs, setTenderLogs] = useState<Log[]>([]);
  const [fboTenderLogs, setFboTenderLogs] = useState<Log[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const { t } = useTranslation();
  const { user, loading: authLoading } = useAuth();
  const location = useLocation();

  useEffect(() => {
    const fetchLogs = async () => {
      try {
        setLoading(true);
        setError(null);

        // Fetch tender logs
        const { data: tenderLogsData, error: tenderLogsError } = await supabase
          .from('tender_logs')
          .select(`
            *,
            tender:tender_id(
              aircraft:aircraft_id(tail_number),
              icao:icao_id(code)
            )
          `)
          .order('changed_at', { ascending: false });

        if (tenderLogsError) throw tenderLogsError;

        // Fetch FBO tender logs
        const { data: fboTenderLogsData, error: fboTenderLogsError } = await supabase
          .from('fbo_tender_logs')
          .select(`
            *,
            tender:tender_id(
              aircraft:aircraft_id(tail_number),
              icao:icao_id(code)
            ),
            fbo_tender:fbo_tender_id(
              fbo:fbo_id(name)
            )
          `)
          .order('changed_at', { ascending: false });

        if (fboTenderLogsError) throw fboTenderLogsError;

        setTenderLogs(tenderLogsData || []);
        setFboTenderLogs(fboTenderLogsData || []);
      } catch (err) {
        console.error('Error fetching logs:', err);
        setError(err instanceof Error ? err.message : 'Failed to fetch logs');
      } finally {
        setLoading(false);
      }
    };

    if (user) {
      fetchLogs();
    }
  }, [user]);

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit'
    });
  };

  const renderChanges = (oldData: any, newData: any) => {
    if (!oldData) return 'New record created';
    if (!newData) return 'Record deleted';

    const changes: string[] = [];
    Object.keys(newData).forEach(key => {
      if (JSON.stringify(oldData[key]) !== JSON.stringify(newData[key])) {
        changes.push(`${key}: ${oldData[key]} → ${newData[key]}`);
      }
    });
    return changes.join(', ');
  };

  if (authLoading) {
    return <LoadingScreen />;
  }

  if (!user) {
    return <Navigate to="/auth/login" state={{ from: location }} replace />;
  }

  if (loading) {
    return (
      <div className="flex justify-center items-center h-screen">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-gray-900"></div>
      </div>
    );
  }

  return (
    <>
      <SEO 
        title={t('logs.title')}
        description={t('logs.subtitle')}
      />
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8">
          <h1 className="text-2xl font-semibold text-gray-900">{t('logs.title')}</h1>
          <p className="mt-2 text-sm text-gray-700">
            {t('logs.subtitle')}
          </p>
        </div>

        {error && (
          <div className="mb-4 bg-red-50 border-l-4 border-red-400 p-4">
            <p className="text-red-700">{error}</p>
          </div>
        )}

        <div className="space-y-8">
          {/* Tender Logs */}
          <div>
            <h2 className="text-lg font-medium text-gray-900 mb-4">{t('logs.tenderLogs')}</h2>
            <div className="bg-white shadow overflow-hidden sm:rounded-lg">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      {t('logs.timestamp')}
                    </th>
                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      {t('logs.user')}
                    </th>
                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      {t('logs.tender')}
                    </th>
                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      {t('logs.action')}
                    </th>
                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      {t('logs.changes')}
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {tenderLogs.map((log) => (
                    <tr key={log.id}>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {formatDate(log.changed_at)}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {log.auth_id}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {log.tender?.aircraft?.tail_number} @ {log.tender?.icao?.code}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm">
                        <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full 
                          ${log.action === 'INSERT' ? 'bg-green-100 text-green-800' : 
                            log.action === 'UPDATE' ? 'bg-yellow-100 text-yellow-800' : 
                            'bg-red-100 text-red-800'}`}>
                          {log.action}
                        </span>
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-500">
                        {renderChanges(log.old_data, log.new_data)}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          {/* FBO Tender Logs */}
          <div>
            <h2 className="text-lg font-medium text-gray-900 mb-4">{t('logs.fboTenderLogs')}</h2>
            <div className="bg-white shadow overflow-hidden sm:rounded-lg">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      {t('logs.timestamp')}
                    </th>
                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      {t('logs.user')}
                    </th>
                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      {t('logs.tender')}
                    </th>
                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      {t('logs.fbo')}
                    </th>
                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      {t('logs.action')}
                    </th>
                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      {t('logs.changes')}
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {fboTenderLogs.map((log) => (
                    <tr key={log.id}>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {formatDate(log.changed_at)}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {log.auth_id}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {log.tender?.aircraft?.tail_number} @ {log.tender?.icao?.code}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {log.fbo_tender?.fbo?.name}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm">
                        <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full 
                          ${log.action === 'INSERT' ? 'bg-green-100 text-green-800' : 
                            log.action === 'UPDATE' ? 'bg-yellow-100 text-yellow-800' : 
                            'bg-red-100 text-red-800'}`}>
                          {log.action}
                        </span>
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-500">
                        {renderChanges(log.old_data, log.new_data)}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
