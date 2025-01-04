import React from 'react';

interface MapContainerProps {
  children?: React.ReactNode;
  containerRef?: React.RefObject<HTMLDivElement>;
}

export function MapContainer({ children, containerRef }: MapContainerProps) {
  return (
    <div className="h-[calc(100vh-64px)]">
      <div ref={containerRef} className="h-full relative">
        {children}
      </div>
    </div>
  );
}