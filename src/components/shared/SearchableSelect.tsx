import { useState, useRef, useEffect } from 'react';
import { Search } from 'lucide-react';

interface Option {
  id: string;
  label: string;
  sublabel?: string;
  keywords?: string[]; // Additional searchable terms
}

interface SearchableSelectProps {
  options: Option[];
  value: string;
  onChange: (value: string) => void;
  label: string;
  placeholder?: string;
  required?: boolean;
  disabled?: boolean;
  maxResults?: number; // Maximum number of results to show
}

export function SearchableSelect({
  options,
  value,
  onChange,
  label,
  placeholder = 'Search...',
  required = false,
  disabled = false,
  maxResults = 100
}: SearchableSelectProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [search, setSearch] = useState('');
  const wrapperRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);
  const listRef = useRef<HTMLDivElement>(null);

  // Close dropdown when clicking outside
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (wrapperRef.current && !wrapperRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    }

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Scroll selected item into view
  useEffect(() => {
    if (isOpen && listRef.current) {
      const selectedElement = listRef.current.querySelector('[data-selected="true"]');
      if (selectedElement) {
        selectedElement.scrollIntoView({ block: 'nearest' });
      }
    }
  }, [isOpen, value]);

  // Filter options based on search
  const filteredOptions = options
    .filter(option => {
      const searchLower = search.toLowerCase();
      return (
        option.label.toLowerCase().includes(searchLower) ||
        (option.sublabel && option.sublabel.toLowerCase().includes(searchLower)) ||
        (option.keywords && option.keywords.some(keyword => 
          keyword.toLowerCase().includes(searchLower)
        ))
      );
    })
    .slice(0, maxResults);

  // Get selected option label
  const selectedOption = options.find(option => option.id === value);

  return (
    <div className="relative" ref={wrapperRef}>
      <label className="block text-sm font-medium text-gray-700 mb-1">
        {label}
        {required && <span className="text-red-500 ml-1">*</span>}
      </label>
      
      <div className="relative">
        <input
          ref={inputRef}
          type="text"
          className={`
            block w-full px-4 py-2 pr-10 border border-gray-300 rounded-md shadow-sm
            focus:ring-blue-500 focus:border-blue-500
            ${disabled ? 'bg-gray-50 cursor-not-allowed' : 'bg-white'}
          `}
          value={isOpen ? search : (selectedOption?.label || '')}
          onChange={(e) => {
            setSearch(e.target.value);
            setIsOpen(true);
          }}
          onFocus={() => {
            setIsOpen(true);
            setSearch('');
          }}
          placeholder={placeholder}
          disabled={disabled}
          required={required}
        />
        <div className="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
          <Search className="h-5 w-5 text-gray-400" />
        </div>
      </div>

      {isOpen && !disabled && (
        <div 
          ref={listRef}
          className="absolute z-10 w-full mt-1 bg-white shadow-lg max-h-60 rounded-md py-1 text-base overflow-auto focus:outline-none sm:text-sm"
        >
          {filteredOptions.length === 0 ? (
            <div className="px-4 py-2 text-sm text-gray-500">
              No results found
            </div>
          ) : (
            filteredOptions.map((option) => (
              <div
                key={option.id}
                data-selected={option.id === value}
                className={`
                  cursor-pointer select-none relative py-2 pl-3 pr-9 
                  ${option.id === value ? 'bg-blue-50' : 'hover:bg-gray-50'}
                `}
                onClick={() => {
                  onChange(option.id);
                  setIsOpen(false);
                  setSearch('');
                  inputRef.current?.blur();
                }}
              >
                <div className="flex flex-col">
                  <span className={`
                    block truncate
                    ${option.id === value ? 'font-semibold' : 'font-normal'}
                  `}>
                    {option.label}
                  </span>
                  {option.sublabel && (
                    <span className="block truncate text-sm text-gray-500">
                      {option.sublabel}
                    </span>
                  )}
                </div>
              </div>
            ))
          )}
          {filteredOptions.length >= maxResults && (
            <div className="px-4 py-2 text-xs text-gray-500 border-t">
              Showing first {maxResults} results. Please refine your search.
            </div>
          )}
        </div>
      )}
    </div>
  );
}