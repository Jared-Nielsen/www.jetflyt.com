/*
  # Add coordinates to ICAO table

  1. Changes
    - Add latitude and longitude columns to icaos table
    - Update Texas airport coordinates with accurate data

  2. Notes
    - Coordinates sourced from official airport data
    - All coordinates are in decimal degrees format
*/

-- Add coordinate columns
ALTER TABLE icaos 
ADD COLUMN latitude numeric,
ADD COLUMN longitude numeric;

-- Update Texas airport coordinates
UPDATE icaos SET
  latitude = CASE code
    WHEN 'KADS' THEN 32.9686
    WHEN 'KAUS' THEN 30.1945
    WHEN 'KDAL' THEN 32.8481
    WHEN 'KHOU' THEN 29.6459
    WHEN 'KSAT' THEN 29.5339
    WHEN 'KFTW' THEN 32.8198
    WHEN 'KELP' THEN 31.8069
    WHEN 'KMAF' THEN 31.9425
    WHEN 'KTME' THEN 29.8053
    WHEN 'KCXO' THEN 30.3518
    WHEN 'KDFW' THEN 32.8968
    WHEN 'KIAH' THEN 29.9902
    WHEN 'KLBB' THEN 33.6636
    WHEN 'KAMA' THEN 35.2194
    WHEN 'KGRK' THEN 31.0672
    WHEN 'KCRP' THEN 27.7704
    WHEN 'KBPT' THEN 29.9508
    WHEN 'KABI' THEN 32.4113
    WHEN 'KACT' THEN 31.6112
    WHEN 'KGGG' THEN 32.3829
  END,
  longitude = CASE code
    WHEN 'KADS' THEN -96.8362
    WHEN 'KAUS' THEN -97.6699
    WHEN 'KDAL' THEN -96.8512
    WHEN 'KHOU' THEN -95.2789
    WHEN 'KSAT' THEN -98.4690
    WHEN 'KFTW' THEN -97.3622
    WHEN 'KELP' THEN -106.3778
    WHEN 'KMAF' THEN -102.2019
    WHEN 'KTME' THEN -95.8935
    WHEN 'KCXO' THEN -95.4144
    WHEN 'KDFW' THEN -97.0380
    WHEN 'KIAH' THEN -95.3368
    WHEN 'KLBB' THEN -101.8230
    WHEN 'KAMA' THEN -101.7059
    WHEN 'KGRK' THEN -97.8289
    WHEN 'KCRP' THEN -97.5012
    WHEN 'KBPT' THEN -94.0207
    WHEN 'KABI' THEN -99.6819
    WHEN 'KACT' THEN -97.2304
    WHEN 'KGGG' THEN -94.7115
  END
WHERE state = 'TX';