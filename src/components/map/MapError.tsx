import React from 'react';

interface MapErrorProps {
  message: string;
}

export function MapError({ message }: MapErrorProps) {
  return (
    <div className="p-4 bg-red-50 border-l-4 border-red-400">
      <div className="flex">
        <div className="ml-3">
          <h3 className="text-sm font-medium text-red-800">Error</h3>
          <div className="mt-2 text-sm text-red-700">
            <p>{message}</p>
          </div>
        </div>
      </div>
    </div>
  );
}