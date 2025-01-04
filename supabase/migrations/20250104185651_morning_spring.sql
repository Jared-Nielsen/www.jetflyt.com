-- Add Chinese airports and their FBOs
DO $$ 
BEGIN
  -- Insert ICAO codes
  INSERT INTO icaos (code, name, country, continent, latitude, longitude, icao_type_id)
  VALUES
    -- Major International Hubs
    ('ZBAA', 'Beijing Capital International Airport', 'China', 'Asia', 40.0799, 116.6031,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('ZBAD', 'Beijing Daxing International Airport', 'China', 'Asia', 39.5098, 116.4105,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('ZPPP', 'Kunming Changshui International Airport', 'China', 'Asia', 25.1019, 102.9290,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('ZSPD', 'Shanghai Pudong International Airport', 'China', 'Asia', 31.1443, 121.8083,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('ZGGG', 'Guangzhou Baiyun International Airport', 'China', 'Asia', 23.3924, 113.2988,
      (SELECT id FROM icao_types WHERE name = 'major_international')),
    ('ZUUU', 'Chengdu Shuangliu International Airport', 'China', 'Asia', 30.5785, 103.9471,
      (SELECT id FROM icao_types WHERE name = 'major_international')),

    -- International Airports
    ('ZSSS', 'Shanghai Hongqiao International Airport', 'China', 'Asia', 31.1979, 121.3363,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('ZGSZ', 'Shenzhen Bao''an International Airport', 'China', 'Asia', 22.6392, 113.8129,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('ZHCC', 'Zhengzhou Xinzheng International Airport', 'China', 'Asia', 34.5197, 113.8409,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('ZUCK', 'Chongqing Jiangbei International Airport', 'China', 'Asia', 29.7192, 106.6414,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('ZLXY', 'Xi''an Xianyang International Airport', 'China', 'Asia', 34.4471, 108.7516,
      (SELECT id FROM icao_types WHERE name = 'international')),
    ('ZSHC', 'Hangzhou Xiaoshan International Airport', 'China', 'Asia', 30.2295, 120.4344,
      (SELECT id FROM icao_types WHERE name = 'international')),

    -- Regional Airports - Eastern China
    ('ZSOF', 'Hefei Xinqiao International Airport', 'China', 'Asia', 31.9878, 116.9784,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('ZSNJ', 'Nanjing Lukou International Airport', 'China', 'Asia', 31.7418, 118.8622,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('ZSFZ', 'Fuzhou Changle International Airport', 'China', 'Asia', 25.9335, 119.6619,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('ZSAM', 'Xiamen Gaoqi International Airport', 'China', 'Asia', 24.5440, 118.1274,
      (SELECT id FROM icao_types WHERE name = 'regional')),

    -- Regional Airports - Northern China
    ('ZBSJ', 'Shijiazhuang Zhengding International Airport', 'China', 'Asia', 38.2807, 114.6964,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('ZBTJ', 'Tianjin Binhai International Airport', 'China', 'Asia', 39.1246, 117.3462,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('ZBYN', 'Taiyuan Wusu International Airport', 'China', 'Asia', 37.7469, 112.6281,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('ZYHB', 'Harbin Taiping International Airport', 'China', 'Asia', 45.6234, 126.2500,
      (SELECT id FROM icao_types WHERE name = 'regional')),

    -- Regional Airports - Southern China
    ('ZGNN', 'Nanning Wuxu International Airport', 'China', 'Asia', 22.6082, 108.1722,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('ZGHA', 'Changsha Huanghua International Airport', 'China', 'Asia', 28.1892, 113.2197,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('ZGKL', 'Guilin Liangjiang International Airport', 'China', 'Asia', 25.2178, 110.0391,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('ZGOW', 'Wenzhou Longwan International Airport', 'China', 'Asia', 27.9122, 120.8519,
      (SELECT id FROM icao_types WHERE name = 'regional')),

    -- Regional Airports - Western China
    ('ZLLL', 'Lanzhou Zhongchuan International Airport', 'China', 'Asia', 36.5152, 103.6205,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('ZPPP', 'Kunming Changshui International Airport', 'China', 'Asia', 25.1019, 102.9290,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('ZLIC', 'Yinchuan Hedong International Airport', 'China', 'Asia', 38.3216, 106.3928,
      (SELECT id FROM icao_types WHERE name = 'regional')),
    ('ZWWW', 'Urumqi Diwopu International Airport', 'China', 'Asia', 43.9071, 87.4742,
      (SELECT id FROM icao_types WHERE name = 'regional'))
  ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    continent = EXCLUDED.continent,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    icao_type_id = EXCLUDED.icao_type_id;

  -- Add FBO locations
  INSERT INTO fbos (name, icao_id, latitude, longitude, address, country)
  SELECT 
    fbo.name,
    i.id as icao_id,
    fbo.latitude,
    fbo.longitude,
    fbo.address,
    'China'
  FROM (
    VALUES 
      -- Beijing Capital (ZBAA)
      ('Capital Jet FBO', 40.0799, 116.6031, 'Business Aviation Terminal, Beijing Capital International Airport'),
      ('Deer Jet FBO Beijing', 40.0795, 116.6028, 'VIP Terminal, Beijing Capital International Airport'),
      ('Beijing Business Aviation Center', 40.0790, 116.6025, 'General Aviation Area, Beijing Capital Airport'),

      -- Beijing Daxing (ZBAD)
      ('Daxing Business Aviation Center', 39.5098, 116.4105, 'Business Aviation Terminal, Beijing Daxing International Airport'),
      ('China Business Aviation Group', 39.5095, 116.4100, 'VIP Terminal, Beijing Daxing International Airport'),

      -- Shanghai Pudong (ZSPD)
      ('Shanghai Hawker Pacific', 31.1443, 121.8083, 'Business Aviation Center, Shanghai Pudong International Airport'),
      ('Shanghai Eastern FBO', 31.1440, 121.8080, 'VIP Aviation Terminal, Shanghai Pudong International Airport'),

      -- Shanghai Hongqiao (ZSSS)
      ('Shanghai Business Aviation Center', 31.1979, 121.3363, 'Business Aviation Terminal, Shanghai Hongqiao International Airport'),
      ('China Eastern Business Jet', 31.1975, 121.3360, 'VIP Terminal, Shanghai Hongqiao International Airport'),

      -- Guangzhou (ZGGG)
      ('Southern Airlines FBO', 23.3924, 113.2988, 'Business Aviation Terminal, Guangzhou Baiyun International Airport'),
      ('Pearl FBO Services', 23.3920, 113.2985, 'VIP Aviation Center, Guangzhou Baiyun International Airport'),

      -- Shenzhen (ZGSZ)
      ('Shenzhen Business Aviation FBO', 22.6392, 113.8129, 'Business Aviation Center, Shenzhen Bao''an International Airport'),
      ('Bay Area Business Aviation', 22.6388, 113.8125, 'VIP Terminal, Shenzhen Bao''an International Airport'),

      -- Chengdu (ZUUU)
      ('Shuangliu Business Aviation', 30.5785, 103.9471, 'Business Aviation Terminal, Chengdu Shuangliu International Airport'),
      ('Western China Aviation Services', 30.5780, 103.9468, 'VIP Terminal, Chengdu Shuangliu International Airport'),

      -- Xi'an (ZLXY)
      ('Silk Road Business Aviation', 34.4471, 108.7516, 'Business Aviation Center, Xi''an Xianyang International Airport'),
      ('Northwest FBO Services', 34.4468, 108.7512, 'VIP Terminal, Xi''an Xianyang International Airport')
  ) as fbo(name, latitude, longitude, address)
  CROSS JOIN (
    SELECT id, code FROM icaos WHERE code IN (
      'ZBAA', 'ZBAD', 'ZSPD', 'ZSSS', 'ZGGG', 'ZGSZ', 'ZUUU', 'ZLXY'
    )
  ) i
  WHERE i.code = (
    CASE 
      WHEN fbo.name LIKE '%Capital Jet%' OR fbo.name LIKE '%Deer Jet%' OR fbo.name LIKE '%Beijing Business Aviation Center%' THEN 'ZBAA'
      WHEN fbo.name LIKE '%Daxing%' OR fbo.name LIKE '%China Business Aviation Group%' THEN 'ZBAD'
      WHEN fbo.name LIKE '%Hawker Pacific%' OR fbo.name LIKE '%Shanghai Eastern%' THEN 'ZSPD'
      WHEN fbo.name LIKE '%Shanghai Business Aviation Center%' OR fbo.name LIKE '%China Eastern Business Jet%' THEN 'ZSSS'
      WHEN fbo.name LIKE '%Southern Airlines%' OR fbo.name LIKE '%Pearl FBO%' THEN 'ZGGG'
      WHEN fbo.name LIKE '%Shenzhen Business%' OR fbo.name LIKE '%Bay Area Business%' THEN 'ZGSZ'
      WHEN fbo.name LIKE '%Shuangliu%' OR fbo.name LIKE '%Western China%' THEN 'ZUUU'
      WHEN fbo.name LIKE '%Silk Road%' OR fbo.name LIKE '%Northwest FBO%' THEN 'ZLXY'
    END
  )
  ON CONFLICT DO NOTHING;
END $$;