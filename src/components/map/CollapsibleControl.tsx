import React, { useState } from 'react';
import { ChevronRight, ChevronDown } from 'lucide-react';

interface CollapsibleControlProps {
  title: string;
  children: React.ReactNode;
  defaultCollapsed?: boolean;
}

export function CollapsibleControl({ title, children, defaultCollapsed = true }: CollapsibleControlProps) {
  const [isCollapsed, setIsCollapsed] = useState(defaultCollapsed);

  return (
    <div className="bg-white rounded-lg shadow-md overflow-hidden">
      <button
        onClick={() => setIsCollapsed(!isCollapsed)}
        className="w-full px-4 py-2 flex items-center justify-between bg-gray-50 hover:bg-gray-100"
      >
        <span className="font-medium text-gray-700">{title}</span>
        {isCollapsed ? (
          <ChevronRight className="h-4 w-4 text-gray-500" />
        ) : (
          <ChevronDown className="h-4 w-4 text-gray-500" />
        )}
      </button>
      {!isCollapsed && (
        <div className="p-2">
          {children}
        </div>
      )}
    </div>
  );
}