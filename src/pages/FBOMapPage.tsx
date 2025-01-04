import React from 'react';
import { isSupabaseConfigured } from '../lib/supabase';
import NoSupabaseWarning from '../components/NoSupabaseWarning';
import { MapError } from '../components/map/MapError';
import { LeafletMap } from '../components/map/LeafletMap';
import { TripFooter } from '../components/map/TripFooter';
import { useICAOData } from '../hooks/useICAOData';
import { SEO } from '../components/SEO';
import { LoadingScreen } from '../components/auth/LoadingScreen';

export default function FBOMapPage() {
  const { data: airports, error: icaoError, loading: icaoLoading } = useICAOData();

  if (!isSupabaseConfigured()) {
    return <NoSupabaseWarning />;
  }

  if (icaoError) {
    return <MapError message={icaoError} />;
  }

  if (icaoLoading) {
    return <LoadingScreen />;
  }

  return (
    <>
      <SEO 
        title="Airport Map"
        description="Interactive map showing airports across Texas with real-time weather data and FBO locations."
      />
      <div className="h-[calc(100vh-64px)]">
        <LeafletMap airports={airports || []} />
        <TripFooter />
      </div>
    </>
  );
}