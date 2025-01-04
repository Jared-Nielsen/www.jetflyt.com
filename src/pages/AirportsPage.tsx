import React, { useState, useMemo } from 'react';
import { useICAOData } from '../hooks/useICAOData';
import { SearchBar } from '../components/airports/SearchBar';
import { AirportList } from '../components/airports/AirportList';
import type { ICAO } from '../types/icao';
import NoSupabaseWarning from '../components/NoSupabaseWarning';
import { isSupabaseConfigured } from '../lib/supabase';
import { SEO } from '../components/SEO';
import { LoadingScreen } from '../components/auth/LoadingScreen';

export default function AirportsPage() {
  const { data: airports, loading, error } = useICAOData();
  const [searchQuery, setSearchQuery] = useState('');
  const [sortConfig, setSortConfig] = useState<{
    key: keyof ICAO;
    direction: 'asc' | 'desc';
  }>({
    key: 'code',
    direction: 'asc'
  });

  const filteredAndSortedAirports = useMemo(() => {
    if (!airports) return [];
    
    let filtered = [...airports];

    // Filter
    if (searchQuery) {
      const query = searchQuery.toLowerCase();
      filtered = filtered.filter(
        airport =>
          airport.code.toLowerCase().includes(query) ||
          airport.name.toLowerCase().includes(query) ||
          (airport.state?.toLowerCase() || '').includes(query)
      );
    }

    // Sort
    filtered.sort((a, b) => {
      const aValue = a[sortConfig.key];
      const bValue = b[sortConfig.key];

      if (aValue < bValue) return sortConfig.direction === 'asc' ? -1 : 1;
      if (aValue > bValue) return sortConfig.direction === 'asc' ? 1 : -1;
      return 0;
    });

    return filtered;
  }, [airports, searchQuery, sortConfig]);

  const handleSort = (key: keyof ICAO) => {
    setSortConfig(current => ({
      key,
      direction: current.key === key && current.direction === 'asc' ? 'desc' : 'asc'
    }));
  };

  if (!isSupabaseConfigured()) {
    return <NoSupabaseWarning />;
  }

  if (loading) {
    return <LoadingScreen />;
  }

  if (error) {
    return (
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="bg-red-50 p-4 rounded-md">
          <p className="text-red-700">{error}</p>
        </div>
      </div>
    );
  }

  return (
    <>
      <SEO 
        title="Airports"
        description="Browse and search Texas airports with detailed ICAO information and FBO locations."
      />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="sm:flex sm:items-center sm:justify-between">
          <div>
            <h1 className="text-2xl font-semibold text-gray-900">Airports</h1>
            <p className="mt-2 text-sm text-gray-700">
              A list of all airports in Texas with their ICAO codes and coordinates.
            </p>
          </div>
          <div className="mt-4 sm:mt-0 sm:w-64">
            <SearchBar value={searchQuery} onChange={setSearchQuery} />
          </div>
        </div>

        <div className="mt-8 flex flex-col">
          <AirportList
            airports={filteredAndSortedAirports}
            sortConfig={sortConfig}
            onSort={handleSort}
          />
        </div>
      </div>
    </>
  );
}