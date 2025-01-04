interface LegStatusProps {
  status: 'scheduled' | 'departed' | 'arrived' | 'cancelled';
}

export function LegStatus({ status }: LegStatusProps) {
  const statusStyles = {
    scheduled: 'bg-blue-100 text-blue-800',
    departed: 'bg-yellow-100 text-yellow-800',
    arrived: 'bg-green-100 text-green-800',
    cancelled: 'bg-red-100 text-red-800'
  };

  return (
    <span className={`text-xs px-2 py-1 rounded ${statusStyles[status]}`}>
      {status.charAt(0).toUpperCase() + status.slice(1)}
    </span>
  );
}