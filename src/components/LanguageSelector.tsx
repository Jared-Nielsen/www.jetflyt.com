import { useState, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import { Languages } from 'lucide-react';

const languages = [
  { code: 'en', name: 'English' },
  { code: 'es', name: 'Español' },
  { code: 'pt', name: 'Português' },
  { code: 'de', name: 'Deutsch' },
  { code: 'fr', name: 'Français' },
  { code: 'ar', name: 'العربية' },
  { code: 'zh', name: '中文' },
  { code: 'ja', name: '日本語' },
  { code: 'hi', name: 'हिन्दी' }
];

export function LanguageSelector() {
  const { i18n } = useTranslation();
  const [isOpen, setIsOpen] = useState(false);

  // Load saved language preference on mount
  useEffect(() => {
    const savedLanguage = localStorage.getItem('preferredLanguage');
    if (savedLanguage && i18n.language !== savedLanguage) {
      i18n.changeLanguage(savedLanguage);
    }
  }, [i18n]);

  const handleLanguageChange = (languageCode: string) => {
    i18n.changeLanguage(languageCode);
    setIsOpen(false);
    localStorage.setItem('preferredLanguage', languageCode);
  };

  // Handle click outside to close dropdown
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      const target = event.target as HTMLElement;
      if (!target.closest('.language-selector')) {
        setIsOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  return (
    <div className="relative language-selector">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-1 px-3 py-2 text-sm font-medium text-white hover:bg-blue-800 rounded-md"
        aria-expanded={isOpen}
        aria-haspopup="true"
      >
        <Languages className="h-4 w-4" />
        <span className="hidden md:inline">
          {languages.find(lang => lang.code === i18n.language)?.name || 'English'}
        </span>
      </button>

      {isOpen && (
        <div 
          className="absolute right-0 mt-2 w-48 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 z-50"
          role="menu"
          aria-orientation="vertical"
        >
          <div className="py-1">
            {languages.map((language) => (
              <button
                key={language.code}
                onClick={() => handleLanguageChange(language.code)}
                className={`block w-full text-left px-4 py-2 text-sm ${
                  i18n.language === language.code
                    ? 'bg-blue-50 text-blue-700'
                    : 'text-gray-700 hover:bg-gray-100'
                }`}
                role="menuitem"
              >
                {language.name}
              </button>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}