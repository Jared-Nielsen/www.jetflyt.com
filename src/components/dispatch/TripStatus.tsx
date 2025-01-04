interface TripStatusProps {
  status: 'planned' | 'active' | 'completed' | 'cancelled';
}

export function TripStatus({ status }: TripStatusProps) {
  const statusStyles = {
    planned: 'bg-blue-100 text-blue-800',
    active: 'bg-green-100 text-green-800',
    completed: 'bg-gray-100 text-gray-800',
    cancelled: 'bg-red-100 text-red-800'
  };

  return (
    <span className={`text-xs px-2 py-1 rounded ${statusStyles[status]}`}>
      {status.charAt(0).toUpperCase() + status.slice(1)}
    </span>
  );
}