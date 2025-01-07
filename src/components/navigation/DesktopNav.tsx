import { Link, useNavigate } from 'react-router-dom';
import { Plane, FileText, LogOut, Route, BarChart3 } from 'lucide-react';
import { useAuth } from '../../contexts/AuthContext';

export function DesktopNav() {
  const { user, signOut } = useAuth();
  const navigate = useNavigate();

  const handleTenderClick = (e: React.MouseEvent) => {
    e.preventDefault();
    window.location.href = '/tender-offer';
  };

  return (
    <div className="hidden md:flex items-center w-full">
      <Link to="/" className="flex items-center space-x-2 flex-shrink-0">
        <Plane className="h-8 w-8" />
        <span className="font-bold text-xl">JetFlyt</span>
      </Link>
      
      <div className="flex items-center justify-end space-x-4 ml-auto">
        {user && (
          <>
            <Link to="/dispatch" className="flex items-center space-x-1 px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-800">
              <Route className="h-4 w-4" />
              <span>Dispatch</span>
            </Link>
            
            <a 
              href="/tender-offer"
              onClick={handleTenderClick}
              className="flex items-center space-x-1 px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-800"
            >
              <FileText className="h-4 w-4" />
              <span>Tenders</span>
            </a>
            
            <Link to="/fleet-registration" className="flex items-center space-x-1 px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-800">
              <Plane className="h-4 w-4" />
              <span>Fleet</span>
            </Link>

            <Link to="/reports" className="flex items-center space-x-1 px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-800">
              <BarChart3 className="h-4 w-4" />
              <span>Reports</span>
            </Link>

            <button
              onClick={() => signOut()}
              className="flex items-center space-x-1 px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-800"
            >
              <LogOut className="h-4 w-4" />
              <span>Sign Out</span>
            </button>
          </>
        )}

        {!user && (
          <Link
            to="/auth/login"
            className="flex items-center space-x-1 px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-800"
          >
            <span>Sign In</span>
          </Link>
        )}
      </div>
    </div>
  );
}