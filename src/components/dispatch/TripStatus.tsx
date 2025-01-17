import { useTranslation } from 'react-i18next';

interface TripStatusProps {
  status: 'planned' | 'active' | 'completed' | 'cancelled';
}

export function TripStatus({ status }: TripStatusProps) {
  const { t } = useTranslation();
  
  const statusStyles = {
    planned: 'bg-blue-100 text-blue-800',
    active: 'bg-green-100 text-green-800',
    completed: 'bg-gray-100 text-gray-800',
    cancelled: 'bg-red-100 text-red-800'
  };

  return (
    <span className={`inline-block px-2 py-1 text-sm rounded-full ${statusStyles[status]}`}>
      {t(`trip.status.${status}`)}
    </span>
  );
}