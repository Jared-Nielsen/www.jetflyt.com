import type { FBO } from '../../types/fbo';

interface FBOPopupProps {
  fbo: FBO;
}

export function FBOPopup({ fbo }: FBOPopupProps) {
  return (
    <div className="p-2">
      <h3 className="text-lg font-bold mb-1">{fbo.name}</h3>
      {fbo.icao && (
        <div className="mb-2">
          <span className="inline-block px-2 py-1 bg-blue-100 text-blue-800 rounded text-sm font-medium">
            {fbo.icao.code}
          </span>
          <p className="text-sm text-gray-600 mt-1">{fbo.icao.name}</p>
        </div>
      )}
      <p className="text-sm text-gray-600">{fbo.address}</p>
      {fbo.state && (
        <p className="text-sm text-gray-600">{fbo.state}, {fbo.country}</p>
      )}
    </div>
  );
}