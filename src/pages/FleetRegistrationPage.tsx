import React, { useState, useRef } from 'react';
import { Plus } from 'lucide-react';
import { useAircraft } from '../hooks/useAircraft';
import { AircraftList } from '../components/fleet/AircraftList';
import { AircraftForm } from '../components/fleet/AircraftForm';
import { ExcelUpload } from '../components/fleet/ExcelUpload';
import { LoadingScreen } from '../components/auth/LoadingScreen';
import { SEO } from '../components/SEO';
import type { Aircraft } from '../types/aircraft';

export default function FleetRegistrationPage() {
  const { aircraft, loading, error, addAircraft, updateAircraft, deleteAircraft } = useAircraft();
  const [showForm, setShowForm] = useState(false);
  const [editingAircraft, setEditingAircraft] = useState<Aircraft | null>(null);
  const pageTopRef = useRef<HTMLDivElement>(null);

  const scrollToTop = () => {
    pageTopRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  const handleSubmit = async (data: Omit<Aircraft, 'id' | 'user_id' | 'created_at' | 'updated_at'>) => {
    try {
      if (editingAircraft) {
        await updateAircraft(editingAircraft.id, data);
      } else {
        await addAircraft(data);
      }
      setShowForm(false);
      setEditingAircraft(null);
      scrollToTop();
    } catch (err) {
      console.error('Error saving aircraft:', err);
      alert('Failed to save aircraft. Please try again.');
    }
  };

  const handleEdit = (aircraft: Aircraft) => {
    setEditingAircraft(aircraft);
    setShowForm(true);
    scrollToTop();
  };

  const handleDelete = async (id: string) => {
    if (window.confirm('Are you sure you want to delete this aircraft?')) {
      try {
        await deleteAircraft(id);
        scrollToTop();
      } catch (err) {
        console.error('Error deleting aircraft:', err);
        alert('Failed to delete aircraft. Please try again.');
      }
    }
  };

  const handleBulkUpload = async (aircraftData: Omit<Aircraft, 'id' | 'user_id' | 'created_at' | 'updated_at'>[]) => {
    try {
      for (const data of aircraftData) {
        await addAircraft(data);
      }
      alert('Successfully uploaded aircraft data');
    } catch (err) {
      console.error('Error uploading aircraft:', err);
      alert('Failed to upload aircraft data. Please check the format and try again.');
    }
  };

  const handleAddNew = () => {
    setEditingAircraft(null);
    setShowForm(true);
    scrollToTop();
  };

  const handleCancel = () => {
    setShowForm(false);
    setEditingAircraft(null);
    scrollToTop();
  };

  if (loading) {
    return <LoadingScreen />;
  }

  return (
    <>
      <SEO 
        title="Fleet Management"
        description="Register and manage your aircraft fleet information."
      />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div ref={pageTopRef} className="sm:flex sm:items-center sm:justify-between">
          <div>
            <h1 className="text-2xl font-semibold text-gray-900">Aircraft Fleet</h1>
            <p className="mt-2 text-sm text-gray-700">
              Manage your aircraft fleet information and specifications.
            </p>
          </div>
          <div className="mt-4 sm:mt-0 sm:flex sm:space-x-4">
            <ExcelUpload onUpload={handleBulkUpload} />
            <button
              onClick={handleAddNew}
              className="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
            >
              <Plus className="h-4 w-4 mr-2" />
              Add Aircraft
            </button>
          </div>
        </div>

        {error && (
          <div className="mt-4 bg-red-50 border-l-4 border-red-400 p-4">
            <p className="text-red-700">{error}</p>
          </div>
        )}

        <div className="mt-8">
          {showForm ? (
            <div className="bg-white shadow sm:rounded-lg p-6">
              <h2 className="text-lg font-medium text-gray-900 mb-4">
                {editingAircraft ? 'Edit Aircraft' : 'Add New Aircraft'}
              </h2>
              <AircraftForm
                onSubmit={handleSubmit}
                initialData={editingAircraft || undefined}
                onCancel={handleCancel}
              />
            </div>
          ) : (
            <div className="bg-white shadow overflow-hidden sm:rounded-lg">
              <AircraftList
                aircraft={aircraft}
                onEdit={handleEdit}
                onDelete={handleDelete}
              />
            </div>
          )}
        </div>
      </div>
    </>
  );
}