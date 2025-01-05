import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { HelmetProvider } from 'react-helmet-async';
import { Suspense, lazy } from 'react';
import { AuthProvider } from './contexts/AuthContext';
import { ProtectedRoute } from './components/auth/ProtectedRoute';
import { PublicLayout } from './components/layouts/PublicLayout';
import { AuthLayout } from './components/layouts/AuthLayout';
import { LoadingScreen } from './components/auth/LoadingScreen';

// Lazy load pages
const LandingPage = lazy(() => import('./pages/LandingPage'));
const LoginPage = lazy(() => import('./pages/auth/LoginPage'));
const RegisterPage = lazy(() => import('./pages/auth/RegisterPage'));
const TenderOfferPage = lazy(() => import('./pages/TenderOfferPage'));
const FleetRegistrationPage = lazy(() => import('./pages/FleetRegistrationPage'));
const FBOMapPage = lazy(() => import('./pages/FBOMapPage'));
const AirportsPage = lazy(() => import('./pages/AirportsPage'));
const DispatchPage = lazy(() => import('./pages/DispatchPage'));
const ReportsPage = lazy(() => import('./pages/ReportsPage'));
const PrivacyPolicy = lazy(() => import('./pages/legal/PrivacyPolicy'));
const TermsConditions = lazy(() => import('./pages/legal/TermsConditions'));
const ContactPage = lazy(() => import('./pages/contact/ContactPage'));
const SupportPage = lazy(() => import('./pages/support/SupportPage'));

export default function App() {
  return (
    <HelmetProvider>
      <AuthProvider>
        <BrowserRouter>
          <Suspense fallback={<LoadingScreen />}>
            <Routes>
              {/* Public routes with navigation */}
              <Route element={<PublicLayout />}>
                <Route path="/" element={<LandingPage />} />
                <Route path="/fbos" element={<FBOMapPage />} />
                <Route path="/icaos" element={<AirportsPage />} />
                <Route path="/privacy" element={<PrivacyPolicy />} />
                <Route path="/terms" element={<TermsConditions />} />
                <Route path="/contact" element={<ContactPage />} />
                <Route path="/support" element={<SupportPage />} />
                
                {/* Protected routes */}
                <Route element={<ProtectedRoute />}>
                  <Route path="/dispatch" element={<DispatchPage />} />
                  <Route path="/tender-offer" element={<TenderOfferPage />} />
                  <Route path="/fleet-registration" element={<FleetRegistrationPage />} />
                  <Route path="/reports" element={<ReportsPage />} />
                </Route>
              </Route>

              {/* Auth routes */}
              <Route element={<AuthLayout />}>
                <Route path="/auth/login" element={<LoginPage />} />
                <Route path="/auth/register" element={<RegisterPage />} />
              </Route>
            </Routes>
          </Suspense>
        </BrowserRouter>
      </AuthProvider>
    </HelmetProvider>
  );
}