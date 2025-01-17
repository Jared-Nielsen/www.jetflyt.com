import { Link, useNavigate, useLocation } from 'react-router-dom';
import { Plane, FileText, LogOut, BarChart3, Briefcase } from 'lucide-react';
import { useAuth } from '../../contexts/AuthContext';
import { useTranslation } from 'react-i18next';
import { LanguageSelector } from '../LanguageSelector';

export function DesktopNav() {
  const { user, signOut } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const { t } = useTranslation();

  const handleTenderClick = (e: React.MouseEvent) => {
    e.preventDefault();
    window.location.href = '/tender-offer';
  };

  const handleHandlingClick = (e: React.MouseEvent) => {
    e.preventDefault();
    if (location.pathname.startsWith('/ground-handling')) {
      window.location.href = '/ground-handling';
    } else {
      navigate('/ground-handling');
    }
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
            <a 
              href="/tender-offer"
              onClick={handleTenderClick}
              className="flex items-center space-x-1 px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-800"
            >
              <FileText className="h-4 w-4" />
              <span>{t('nav.tenders')}</span>
            </a>
            
            <a
              href="/ground-handling"
              onClick={handleHandlingClick}
              className="flex items-center space-x-1 px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-800"
            >
              <Briefcase className="h-4 w-4" />
              <span>{t('nav.handling')}</span>
            </a>
            
            <Link to="/fleet-registration" className="flex items-center space-x-1 px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-800">
              <Plane className="h-4 w-4" />
              <span>{t('nav.fleet')}</span>
            </Link>

            <Link to="/reports" className="flex items-center space-x-1 px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-800">
              <BarChart3 className="h-4 w-4" />
              <span>{t('nav.reports')}</span>
            </Link>

            <button
              onClick={() => signOut()}
              className="flex items-center space-x-1 px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-800"
            >
              <LogOut className="h-4 w-4" />
              <span>{t('nav.signOut')}</span>
            </button>
          </>
        )}

        {!user && (
          <Link
            to="/auth/login"
            className="flex items-center space-x-1 px-3 py-2 rounded-md text-sm font-medium hover:bg-blue-800"
          >
            <span>{t('nav.signIn')}</span>
          </Link>
        )}

        <LanguageSelector />
      </div>
    </div>
  );
}