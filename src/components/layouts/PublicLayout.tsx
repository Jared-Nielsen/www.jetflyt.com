import { Outlet } from 'react-router-dom';
import Navigation from '../Navigation';
import Footer from '../Footer';

export function PublicLayout() {
  return (
    <div className="min-h-screen flex flex-col">
      <Navigation />
      <main className="flex-grow">
        <Outlet />
      </main>
      <Footer />
    </div>
  );
}