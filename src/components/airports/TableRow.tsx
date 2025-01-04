import React from 'react';
import type { ICAO } from '../../types/icao';

interface TableRowProps {
  airport: ICAO;
}

export function TableRow({ airport }: TableRowProps) {
  return (
    <tr className="hover:bg-gray-50">
      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
        {airport.code}
      </td>
      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
        {airport.name}
      </td>
      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
        {airport.state}
      </td>
      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
        {airport.latitude.toFixed(4)}
      </td>
      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
        {airport.longitude.toFixed(4)}
      </td>
    </tr>
  );
}