import React from 'react';

export default function NoSupabaseWarning() {
  return (
    <div className="p-4 bg-yellow-50 border-l-4 border-yellow-400">
      <div className="flex">
        <div className="ml-3">
          <h3 className="text-sm font-medium text-yellow-800">Supabase Connection Required</h3>
          <div className="mt-2 text-sm text-yellow-700">
            <p>Please click the "Connect to Supabase" button in the top right corner to set up your database connection.</p>
          </div>
        </div>
      </div>
    </div>
  );
}