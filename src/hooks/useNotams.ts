import { useState, useEffect } from 'react';
import type { NOTAM } from '../types/notam';

// Simulated NOTAM data for Texas airports
const TEXAS_NOTAMS: NOTAM[] = [
  {
    identifier: 'KHOU 02/024',
    description: 'TWY A CLSD BTN TWY B AND TWY C',
    startTime: '2024-02-15T00:00:00Z',
    endTime: '2024-03-15T23:59:59Z',
    coordinates: [
      [29.6459, -95.2789],
      [29.6469, -95.2799],
      [29.6479, -95.2789],
      [29.6469, -95.2779],
    ]
  },
  {
    identifier: 'KDFW 02/031',
    description: 'RWY 17R/35L CLSD FOR MAINTENANCE',
    startTime: '2024-02-20T00:00:00Z',
    endTime: '2024-02-25T23:59:59Z',
    coordinates: [
      [32.8968, -97.0380],
      [32.8978, -97.0390],
      [32.8988, -97.0380],
      [32.8978, -97.0370],
    ]
  }
];

export function useNotams() {
  const [notams, setNotams] = useState<NOTAM[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Simulate API call delay
    const timer = setTimeout(() => {
      setNotams(TEXAS_NOTAMS);
      setLoading(false);
    }, 1000);

    return () => clearTimeout(timer);
  }, []);

  return { notams, loading };
}