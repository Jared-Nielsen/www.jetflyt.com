import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import LanguageDetector from 'i18next-browser-languagedetector';
import { en } from './locales/en';
import { es } from './locales/es';
import { pt } from './locales/pt';
import { de } from './locales/de';
import { fr } from './locales/fr';
import { ar } from './locales/ar';
import { zh } from './locales/zh';
import { ja } from './locales/ja';
import { hi } from './locales/hi';

// Initialize i18next
i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    resources: {
      en,
      es,
      pt,
      de,
      fr,
      ar,
      zh,
      ja,
      hi
    },
    fallbackLng: 'en',
    debug: process.env.NODE_ENV === 'development',
    interpolation: {
      escapeValue: false
    },
    detection: {
      order: ['localStorage', 'navigator'],
      caches: ['localStorage']
    }
  });

export default i18n;