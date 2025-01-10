import { useState } from 'react';
import { Link, useNavigate, useLocation } from 'react-router-dom';
import { Menu, X, Plane, FileText, LogOut, BarChart3, Briefcase } from 'lucide-react';
import { useAuth } from '../../contexts/AuthContext';

export function MobileNav() {
  const [isOpen, setIsOpen] = useState(false);
  const { user, signOut } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();

  const toggleMenu = () => setIsOpen(!isOpen);

  const handleTenderClick = (e: React.MouseEvent) => {
    e.preventDefault();
    window.location.href = '/tender-offer';
    toggleMenu();
  };

  const handleHandlingClick = (e: React.MouseEvent) => {
    e.preventDefault();
    if (location.pathname.startsWith('/ground-handling')) {
      window.location.href = '/ground-handling';
    } else {
      navigate('/ground-handling');
    }
    toggleMenu();
  };

  return (
    <div className="md:hidden flex items-center justify-between w-full">
      <Link to="/" className="flex items-center space-x-2">
        <Plane className="h-8 w-8" />
        <span className="font-bold text-xl">JetFlyt</span>
      </Link>

      <button
        onClick={toggleMenu}
        className="p-2 rounded-md hover:bg-blue-800 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white"
      >
        <span className="sr-only">Open main menu</span>
        {isOpen ? (
          <X className="h-6 w-6" aria-hidden="true" />
        ) : (
          <Menu className="h-6 w-6" aria-hidden="true" />
        )}
      </button>

      {isOpen && (
        <div className="absolute top-16 inset-x-0 bg-blue-900 shadow-lg z-[9999]">
          <div className="px-2 pt-2 pb-3 space-y-1">
            {user && (
              <>
                <a
                  href="/tender-offer"
                  className="flex items-center space-x-2 px-3 py-2 rounded-md text-base font-medium hover:bg-blue-800 w-full"
                  onClick={handleTenderClick}
                >
                  <FileText className="h-5 w-5" />
                  <span>Tenders</span>
                </a>

                <a
                  href="/ground-handling"
                  className="flex items-center space-x-2 px-3 py-2 rounded-md text-base font-medium hover:bg-blue-800 w-full"
                  onClick={handleHandlingClick}
                >
                  <Briefcase className="h-5 w-5" />
                  <span>Handling</span>
                </a>

                <Link
                  to="/fleet-registration"
                  className="flex items-center space-x-2 px-3 py-2 rounded-md text-base font-medium hover:bg-blue-800 w-full"
                  onClick={toggleMenu}
                >
                  <Plane className="h-5 w-5" />
                  <span>Fleet</span>
                </Link>

                <Link
                  to="/reports"
                  className="flex items-center space-x-2 px-3 py-2 rounded-md text-base font-medium hover:bg-blue-800 w-full"
                  onClick={toggleMenu}
                >
                  <BarChart3 className="h-5 w-5" />
                  <span>Reports</span>
                </Link>

                <button
                  onClick={() => {
                    signOut();
                    toggleMenu();
                  }}
                  className="flex items-center space-x-2 px-3 py-2 rounded-md text-base font-medium hover:bg-blue-800 w-full"
                >
                  <LogOut className="h-5 w-5" />
                  <span>Sign Out</span>
                </button>
              </>
            )}

            {!user && (
              <Link
                to="/auth/login"
                className="flex items-center space-x-2 px-3 py-2 rounded-md text-base font-medium hover:bg-blue-800 w-full"
                onClick={toggleMenu}
              >
                <span>Sign In</span>
              </Link>
            )}
          </div>
        </div>
      )}
    </div>
  );
}