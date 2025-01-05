import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';

interface TenderStatusCount {
  status: string;
  count: number;
}

export function TenderStatusChart() {
  const [data, setData] = useState<TenderStatusCount[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchData() {
      try {
        const { data: tenders, error: tendersError } = await supabase
          .from('tenders')
          .select('status');

        if (tendersError) throw tendersError;

        // Count tenders by status
        const counts = tenders.reduce((acc: Record<string, number>, tender) => {
          acc[tender.status] = (acc[tender.status] || 0) + 1;
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
        console.error('Error fetching tender status data:', err);
        setError('Failed to load tender status data');
        setLoading(false);
      }
    }

    fetchData();
  }, []);

  if (loading) {
    return <div className="flex justify-center items-center h-full">Loading...</div>;
  }

  if (error) {
    return <div className="text-red-600">{error}</div>;
  }

  const total = data.reduce((sum, item) => sum + item.count, 0);
  const colors = {
    pending: 'bg-yellow-500',
    accepted: 'bg-green-500',
    rejected: 'bg-red-500',
    cancelled: 'bg-gray-500'
  };

  return (
    <div className="space-y-4">
      <div className="flex flex-col space-y-2">
        {data.map(({ status, count }) => (
          <div key={status} className="flex items-center">
            <div className="w-32 text-sm font-medium capitalize">{status}</div>
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
          Total Tenders: {total}
        </div>
      </div>
    </div>
  );
}