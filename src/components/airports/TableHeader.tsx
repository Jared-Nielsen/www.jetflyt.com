import React from 'react';
import { ArrowUpDown } from 'lucide-react';
import type { ICAO } from '../../types/icao';

interface TableHeaderProps {
  sortConfig: {
    key: keyof ICAO;
    direction: 'asc' | 'desc';
  };
  onSort: (key: keyof ICAO) => void;
}

export function TableHeader({ sortConfig, onSort }: TableHeaderProps) {
  const headers: { key: keyof ICAO; label: string }[] = [
    { key: 'code', label: 'ICAO Code' },
    { key: 'name', label: 'Airport Name' },
    { key: 'state', label: 'State' },
    { key: 'latitude', label: 'Latitude' },
    { key: 'longitude', label: 'Longitude' }
  ];

  return (
    <thead className="bg-gray-50">
      <tr>
        {headers.map(({ key, label }) => (
          <th
            key={key}
            scope="col"
            className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
            onClick={() => onSort(key)}
          >
            <div className="flex items-center space-x-1">
              <span>{label}</span>
              <ArrowUpDown className="h-4 w-4" />
            </div>
          </th>
        ))}
      </tr>
    </thead>
  );
}