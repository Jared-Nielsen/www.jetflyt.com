import React from 'react';
import type { ICAO } from '../../types/icao';
import { TableHeader } from './TableHeader';
import { TableRow } from './TableRow';

interface AirportListProps {
  airports: ICAO[];
  sortConfig: {
    key: keyof ICAO;
    direction: 'asc' | 'desc';
  };
  onSort: (key: keyof ICAO) => void;
}

export function AirportList({ airports, sortConfig, onSort }: AirportListProps) {
  return (
    <div className="overflow-x-auto">
      <table className="min-w-full divide-y divide-gray-200">
        <TableHeader sortConfig={sortConfig} onSort={onSort} />
        <tbody className="bg-white divide-y divide-gray-200">
          {airports.map((airport) => (
            <TableRow key={airport.id} airport={airport} />
          ))}
        </tbody>
      </table>
    </div>
  );
}