/*
  # Add color and category fields to transit types

  1. Changes
    - Add color field to transit_types table
    - Add category field to transit_types table
    - Update existing transit types with colors and categories
*/

-- Add new columns
ALTER TABLE transit_types
ADD COLUMN IF NOT EXISTS color text DEFAULT '#2563eb',
ADD COLUMN IF NOT EXISTS category text DEFAULT 'Transit';

-- Update existing transit types with meaningful colors and categories
UPDATE transit_types SET
  color = CASE name
    WHEN 'private_jet' THEN '#2563eb'
    WHEN 'commercial_air' THEN '#1d4ed8'
    WHEN 'limousine' THEN '#4f46e5'
    WHEN 'car' THEN '#7c3aed'
    WHEN 'walking' THEN '#a855f7'
    WHEN 'boat' THEN '#0891b2'
    WHEN 'bus' THEN '#0d9488'
    WHEN 'train' THEN '#059669'
    WHEN 'space' THEN '#dc2626'
    WHEN 'other' THEN '#71717a'
  END,
  category = CASE name
    WHEN 'private_jet' THEN 'Flight'
    WHEN 'commercial_air' THEN 'Flight'
    WHEN 'limousine' THEN 'Ground'
    WHEN 'car' THEN 'Ground'
    WHEN 'walking' THEN 'Ground'
    WHEN 'boat' THEN 'Maritime'
    WHEN 'bus' THEN 'Ground'
    WHEN 'train' THEN 'Rail'
    WHEN 'space' THEN 'Space'
    WHEN 'other' THEN 'Other'
  END;