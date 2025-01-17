import { useState } from 'react';
import { Upload, Download } from 'lucide-react';
import { read, utils, writeFile } from 'xlsx';
import { useAircraftTypes } from '../../hooks/useAircraftTypes';
import { useAircraftEngineTypes } from '../../hooks/useAircraftEngineTypes';
import { useFuelTypes } from '../../hooks/useFuelTypes';
import type { Aircraft } from '../../types/aircraft';
import { useTranslation } from 'react-i18next';

interface ExcelUploadProps {
  onUpload: (aircraft: Omit<Aircraft, 'id' | 'user_id' | 'created_at' | 'updated_at'>[]) => Promise<void>;
}

export function ExcelUpload({ onUpload }: ExcelUploadProps) {
  const [error, setError] = useState<string | null>(null);
  const { types: aircraftTypes } = useAircraftTypes();
  const { types: engineTypes } = useAircraftEngineTypes();
  const { types: fuelTypes } = useFuelTypes();
  const { t } = useTranslation();

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    try {
      setError(null);
      const file = e.target.files?.[0];
      if (!file) return;

      const reader = new FileReader();
      reader.onload = async (event) => {
        try {
          const workbook = read(event.target?.result, { type: 'array' });
          const firstSheet = workbook.Sheets[workbook.SheetNames[0]];
          const data = utils.sheet_to_json(firstSheet);

          // Validate and transform data
          const aircraft = data.map((row: any) => ({
            tail_number: row.tail_number,
            type_id: aircraftTypes.find(t => t.name === row.aircraft_type)?.id,
            manufacturer: row.manufacturer,
            model: row.model,
            year: parseInt(row.year),
            max_range: parseFloat(row.max_range),
            fuel_type_id: fuelTypes.find(t => t.name === row.fuel_type)?.id,
            fuel_capacity: parseFloat(row.fuel_capacity),
            engine_type_id: engineTypes.find(t => t.name === row.engine_type)?.id,
            latitude: parseFloat(row.latitude),
            longitude: parseFloat(row.longitude)
          }));

          await onUpload(aircraft);
          e.target.value = ''; // Reset file input
        } catch (err) {
          console.error('Error processing Excel file:', err);
          setError(t('fleet.errors.uploadFailed'));
        }
      };
      reader.readAsArrayBuffer(file);
    } catch (err) {
      console.error('Error handling file upload:', err);
      setError(t('fleet.errors.uploadFailed'));
    }
  };

  const downloadTemplate = () => {
    // Create workbook with multiple sheets
    const wb = utils.book_new();

    // Main aircraft sheet
    const mainHeaders = [
      'tail_number',
      'aircraft_type',
      'manufacturer',
      'model',
      'year',
      'max_range',
      'fuel_type',
      'fuel_capacity',
      'engine_type',
      'latitude',
      'longitude'
    ];
    const mainWs = utils.aoa_to_sheet([mainHeaders]);
    utils.book_append_sheet(wb, mainWs, 'Aircraft');

    // Reference sheets
    const aircraftTypesWs = utils.aoa_to_sheet([
      ['name', 'manufacturer', 'category'],
      ...aircraftTypes.map(t => [t.name, t.manufacturer, t.category])
    ]);
    utils.book_append_sheet(wb, aircraftTypesWs, 'Aircraft Types');

    const engineTypesWs = utils.aoa_to_sheet([
      ['name', 'description'],
      ...engineTypes.map(t => [t.name, t.description])
    ]);
    utils.book_append_sheet(wb, engineTypesWs, 'Engine Types');

    const fuelTypesWs = utils.aoa_to_sheet([
      ['name', 'description'],
      ...fuelTypes.map(t => [t.name, t.description])
    ]);
    utils.book_append_sheet(wb, fuelTypesWs, 'Fuel Types');

    // Download the file
    writeFile(wb, 'fleet_upload_template.xlsx');
  };

  return (
    <div className="flex items-center space-x-4">
      {error && (
        <div className="text-sm text-red-600 mr-4">
          {error}
        </div>
      )}
      
      <button
        onClick={downloadTemplate}
        className="flex items-center px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
      >
        <Download className="w-4 h-4 mr-2" />
        {t('fleet.downloadTemplate')}
      </button>

      <label className="flex items-center px-3 py-2 text-sm font-medium text-white bg-blue-600 rounded-md hover:bg-blue-700 cursor-pointer">
        <Upload className="w-4 h-4 mr-2" />
        {t('fleet.uploadExcel')}
        <input
          type="file"
          accept=".xlsx,.xls"
          onChange={handleFileUpload}
          className="hidden"
        />
      </label>
    </div>
  );
}