import { Link } from 'react-router-dom';
import { Plane, FileText, MapPin, Building2, LogOut, Route } from 'lucide-react';
import { useAuth } from '../../contexts/AuthContext';

export function DesktopNav() {
  const { user, signOut } = useAuth();

  return (
    <div className="hidden md:flex items-center justify-between w-full">
      <Link to="/" className="flex items-center space-x-2">
        <Plane className="h-8 w-8" />
        <span className="font-bold text-xl">JetFlyt</span>
      </Link>
      
      <div className="flex items-center space-x-4">
        <Link to="/fbos" className="flex items-center space-x-1 px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-800">
          <Building2 className="h-4 w-4" />
          <span>FBOs</span>
        </Link>
        
        <Link to="/icaos" className="flex items-center space-x-1 px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-800">
          <MapPin className="h-4 w-4" />
          <span>Airports</span>
        </Link>

        {user && (
          <>
            <Link to="/dispatch" className="flex items-center space-x-1 px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-800">
              <Route className="h-4 w-4" />
              <span>Dispatch</span>
            </Link>
            
            <Link to="/tender-offer" className="flex items-center space-x-1 px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-800">
              <FileText className="h-4 w-4" />
              <span>Tenders</span>
            </Link>
            
            <Link to="/fleet-registration" className="flex items-center space-x-1 px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-800">
              <Plane className="h-4 w-4" />
              <span>Fleet</span>
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