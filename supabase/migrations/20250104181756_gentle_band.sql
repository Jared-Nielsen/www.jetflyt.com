-- Add ICAOs for New Jersey, New York, and Virginia airports
DO $$ 
BEGIN
  -- Insert ICAO codes
  INSERT INTO icaos (code, name, state, country, continent, latitude, longitude)
  VALUES
    -- New Jersey Airports
    ('KACY', 'Atlantic City International Airport', 'NJ', 'United States', 'North America', 39.4577, -74.5773),
    ('KEWR', 'Newark Liberty International Airport', 'NJ', 'United States', 'North America', 40.6895, -74.1745),
    ('KTTN', 'Trenton Mercer Airport', 'NJ', 'United States', 'North America', 40.2767, -74.8135),
    ('KMIV', 'Millville Executive Airport', 'NJ', 'United States', 'North America', 39.3678, -75.0722),
    ('KBLM', 'Monmouth Executive Airport', 'NJ', 'United States', 'North America', 40.1867, -74.1248),
    ('KTEB', 'Teterboro Airport', 'NJ', 'United States', 'North America', 40.8501, -74.0608),
    ('KWRI', 'McGuire Air Force Base', 'NJ', 'United States', 'North America', 40.0157, -74.5936),
    ('KCDW', 'Essex County Airport', 'NJ', 'United States', 'North America', 40.8752, -74.2813),
    ('KMMU', 'Morristown Municipal Airport', 'NJ', 'United States', 'North America', 40.7994, -74.4149),
    ('KSMQ', 'Somerset Airport', 'NJ', 'United States', 'North America', 40.6262, -74.6707),

    -- New York Airports (Additional to existing ones)
    ('KPBG', 'Plattsburgh International Airport', 'NY', 'United States', 'North America', 44.6509, -73.4683),
    ('KELM', 'Elmira Corning Regional Airport', 'NY', 'United States', 'North America', 42.1599, -76.8916),
    ('KGFL', 'Floyd Bennett Memorial Airport', 'NY', 'United States', 'North America', 43.3412, -73.6103),
    ('KIAG', 'Niagara Falls International Airport', 'NY', 'United States', 'North America', 43.1073, -78.9462),
    ('KPOU', 'Hudson Valley Regional Airport', 'NY', 'United States', 'North America', 41.6266, -73.8842),
    ('KFOK', 'Francis S. Gabreski Airport', 'NY', 'United States', 'North America', 40.8437, -72.6317),
    ('KART', 'Watertown International Airport', 'NY', 'United States', 'North America', 43.9919, -76.0217),
    ('KPLB', 'Clinton County Airport', 'NY', 'United States', 'North America', 44.6875, -73.5247),
    ('KSLK', 'Adirondack Regional Airport', 'NY', 'United States', 'North America', 44.3853, -74.2062),
    ('KDSV', 'Dansville Municipal Airport', 'NY', 'United States', 'North America', 42.5708, -77.7131),

    -- Virginia Airports
    ('KIAD', 'Washington Dulles International Airport', 'VA', 'United States', 'North America', 38.9445, -77.4558),
    ('KRIC', 'Richmond International Airport', 'VA', 'United States', 'North America', 37.5052, -77.3197),
    ('KORF', 'Norfolk International Airport', 'VA', 'United States', 'North America', 36.8946, -76.2012),
    ('KPHF', 'Newport News/Williamsburg International', 'VA', 'United States', 'North America', 37.1319, -76.4930),
    ('KROA', 'Roanoke-Blacksburg Regional Airport', 'VA', 'United States', 'North America', 37.3255, -79.9754),
    ('KCHO', 'Charlottesville-Albemarle Airport', 'VA', 'United States', 'North America', 38.1386, -78.4529),
    ('KLYH', 'Lynchburg Regional Airport', 'VA', 'United States', 'North America', 37.3267, -79.2004),
    ('KDCA', 'Ronald Reagan Washington National', 'VA', 'United States', 'North America', 38.8521, -77.0377),
    ('KSHD', 'Shenandoah Valley Regional Airport', 'VA', 'United States', 'North America', 38.2638, -78.8964),
    ('KJGG', 'Williamsburg-Jamestown Airport', 'VA', 'United States', 'North America', 37.2391, -76.7164)
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    state = EXCLUDED.state,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude;
END $$;