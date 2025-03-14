import { MobileNav } from './navigation/MobileNav';
import { DesktopNav } from './navigation/DesktopNav';

export default function Navigation() {
  return (
    <nav className="bg-blue-900 text-white sticky top-0 z-[9999] shadow-md w-full">
      <div className="w-full max-w-[2000px] mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16 w-full">
          <DesktopNav />
          <MobileNav />
        </div>
      </div>
    </nav>
  );
}