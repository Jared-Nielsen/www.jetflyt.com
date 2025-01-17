import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import { useTranslation } from 'react-i18next';

interface ServiceTenderStatusCount {
  status: string;
  count: number;
}

export function ServiceTenderStatusChart() {
  const [data, setData] = useState<ServiceTenderStatusCount[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const { t } = useTranslation();

  useEffect(() => {
    async function fetchData() {
      try {
        const { data: workOrders, error: workOrdersError } = await supabase
          .from('work_orders')
          .select('status');

        if (workOrdersError) throw workOrdersError;

        // Count work orders by status
        const counts = workOrders.reduce((acc: Record<string, number>, order) => {
          acc[order.status] = (acc[order.status] || 0) + 1;
          return acc;
        }, {});

        // Convert to array format
        const statusData = Object.entries(counts).map(([status, count]) => ({
          status,
          count: count as number
        }));

        setData(statusData);
        setLoading(false);
      } catch (err) {
        console.error('Error fetching service tender status data:', err);
        setError(t('reports.errors.loadFailed'));
        setLoading(false);
      }
    }

    fetchData();
  }, [t]);

  if (loading) {
    return <div className="flex justify-center items-center h-full">{t('common.loading')}</div>;
  }

  if (error) {
    return <div className="text-red-600">{error}</div>;
  }

  const total = data.reduce((sum, item) => sum + item.count, 0);
  const colors = {
    pending: 'bg-yellow-500',
    accepted: 'bg-green-500',
    in_progress: 'bg-blue-500',
    completed: 'bg-green-500',
    cancelled: 'bg-gray-500'
  };

  return (
    <div className="space-y-4">
      <div className="flex flex-col space-y-2">
        {data.map(({ status, count }) => (
          <div key={status} className="flex items-center">
            <div className="w-32 text-sm font-medium capitalize">
              {t(`reports.status.${status}`)}
            </div>
            <div className="flex-1 mx-2">
              <div className="h-4 bg-gray-200 rounded-full overflow-hidden">
                <div 
                  className={`h-full ${colors[status as keyof typeof colors] || 'bg-blue-500'}`}
                  style={{ width: `${(count / total) * 100}%` }}
                />
              </div>
            </div>
            <div className="w-20 text-sm text-right">
              {count} ({((count / total) * 100).toFixed(1)}%)
            </div>
          </div>
        ))}
      </div>

      <div className="border-t pt-4">
        <div className="text-sm text-gray-500">
          {t('reports.charts.total')}: {total}
        </div>
      </div>
    </div>
  );
}