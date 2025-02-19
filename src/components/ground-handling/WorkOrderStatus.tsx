import { useTranslation } from 'react-i18next';

interface WorkOrderStatusProps {
  status: 'pending' | 'in_progress' | 'completed' | 'cancelled';
}

export function WorkOrderStatus({ status }: WorkOrderStatusProps) {
  const { t } = useTranslation();
  
  const statusStyles = {
    pending: 'bg-yellow-100 text-yellow-800',
    in_progress: 'bg-blue-100 text-blue-800',
    completed: 'bg-green-100 text-green-800',
    cancelled: 'bg-red-100 text-red-800'
  };

  return (
    <span className={`inline-block px-2 py-1 text-sm rounded-full ${statusStyles[status]}`}>
      {t(`handling.status.${status}`)}
    </span>
  );
}