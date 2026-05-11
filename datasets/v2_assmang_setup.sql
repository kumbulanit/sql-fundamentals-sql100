-- ============================================================
-- DATASET v2 — Assmang Pty Ltd Training Database (Extended)
-- SQL100 Beginner SQL Course
-- Used in: Day 2 Topic 01 (Aggregations) & Topic 02 (JOINs)
-- INCLUDES: all v1 tables + equipment + production_monthly
-- ============================================================
-- Run v1 first in SQL Server, then run this file in the same database session.
-- ============================================================

-- SQL Server does not support SOURCE in regular query windows.
-- Run datasets/v1_assmang_setup.sql first, then execute this file.

USE assmang_training;
GO

-- ============================================================
-- TABLE 4: equipment
-- ============================================================
CREATE TABLE equipment (
    equipment_id    INT             IDENTITY(1,1) NOT NULL,
    equipment_code  VARCHAR(20)     NOT NULL UNIQUE,
    equipment_type  VARCHAR(80)     NOT NULL,
    manufacturer    VARCHAR(80)     NOT NULL,
    model           VARCHAR(80)     NOT NULL,
    mine_id         INT             NOT NULL,
    purchase_date   DATE            NOT NULL,
    purchase_price  DECIMAL(14, 2)  NOT NULL,
    status          VARCHAR(20)     NOT NULL DEFAULT 'Active',  -- Active, Maintenance, Retired
    PRIMARY KEY (equipment_id),
    FOREIGN KEY (mine_id) REFERENCES mines(mine_id)
);

INSERT INTO equipment (equipment_code, equipment_type, manufacturer, model, mine_id, purchase_date, purchase_price, status) VALUES
-- Beeshoek Mine (mine 1)
('BEE-EX-001', 'Excavator',          'Caterpillar', 'CAT 374F',      1, '2018-03-15', 8500000.00, 'Active'),
('BEE-TR-001', 'Haul Truck',         'Komatsu',     'HD785-7',       1, '2017-08-22', 9200000.00, 'Active'),
('BEE-TR-002', 'Haul Truck',         'Komatsu',     'HD785-7',       1, '2017-08-22', 9200000.00, 'Maintenance'),
('BEE-DR-001', 'Drill Rig',          'Atlas Copco', 'Pit Viper 271', 1, '2019-01-10', 4800000.00, 'Active'),
('BEE-GR-001', 'Grader',             'Caterpillar', 'CAT 16M',       1, '2020-05-01', 3100000.00, 'Active'),

-- Khumani Mine (mine 2)
('KHU-EX-001', 'Excavator',          'Liebherr',    'R 9350',        2, '2016-11-30', 12000000.00,'Active'),
('KHU-TR-001', 'Haul Truck',         'Caterpillar', 'CAT 793F',      2, '2016-11-30', 14500000.00,'Active'),
('KHU-TR-002', 'Haul Truck',         'Caterpillar', 'CAT 793F',      2, '2018-02-14', 14500000.00,'Active'),
('KHU-DR-001', 'Drill Rig',          'Sandvik',     'DP1500i',       2, '2020-07-20', 5200000.00, 'Active'),
('KHU-WA-001', 'Water Bowser',       'Bell',        'B45E',          2, '2019-09-05', 2800000.00, 'Active'),

-- Black Rock Mine (mine 3)
('BRK-EX-001', 'Excavator',          'Caterpillar', 'CAT 390F',      3, '2015-06-01', 9800000.00, 'Active'),
('BRK-TR-001', 'Haul Truck',         'Komatsu',     'HD605-7',       3, '2015-06-01', 8100000.00, 'Retired'),
('BRK-TR-002', 'Haul Truck',         'Komatsu',     'HD785-7',       3, '2021-01-15', 9500000.00, 'Active'),
('BRK-LO-001', 'Front-End Loader',   'Bell',        'L70H',          3, '2017-04-10', 3600000.00, 'Active'),
('BRK-DR-001', 'Drill Rig',          'Atlas Copco', 'ROC L8',        3, '2018-10-22', 4300000.00, 'Maintenance'),

-- Gloria Mine (mine 4)
('GLO-TR-001', 'Haul Truck',         'Komatsu',     'HD465-7',       4, '2016-03-08', 7200000.00, 'Active'),
('GLO-LO-001', 'Front-End Loader',   'Caterpillar', 'CAT 992K',      4, '2019-07-14', 4100000.00, 'Active'),

-- Dwarsrivier Chrome (mine 5)
('DWA-EX-001', 'Excavator',          'Liebherr',    'R 9100',        5, '2017-12-01', 7800000.00, 'Active'),
('DWA-TR-001', 'Haul Truck',         'Bell',        'B50E',          5, '2017-12-01', 5500000.00, 'Active'),
('DWA-DR-001', 'Drill Rig',          'Sandvik',     'DI550',         5, '2020-03-25', 3900000.00, 'Active');

-- ============================================================
-- TABLE 5: production_monthly
-- ============================================================
CREATE TABLE production_monthly (
    production_id   INT             IDENTITY(1,1) NOT NULL,
    mine_id         INT             NOT NULL,
    production_year INT             NOT NULL,
    production_month INT            NOT NULL,  -- 1=Jan, 12=Dec
    tonnes_mined    DECIMAL(12, 2)  NOT NULL,
    tonnes_processed DECIMAL(12, 2) NOT NULL,
    ore_grade_pct   DECIMAL(5, 2)   NOT NULL,  -- % grade
    revenue_zar     DECIMAL(16, 2)  NOT NULL,
    PRIMARY KEY (production_id),
    FOREIGN KEY (mine_id) REFERENCES mines(mine_id),
    CONSTRAINT uq_mine_month UNIQUE (mine_id, production_year, production_month)
);

INSERT INTO production_monthly (mine_id, production_year, production_month, tonnes_mined, tonnes_processed, ore_grade_pct, revenue_zar) VALUES
-- Beeshoek Mine 2023 (Iron Ore)
(1, 2023, 1,  185000, 162000, 64.50, 38500000),
(1, 2023, 2,  172000, 151000, 63.80, 36200000),
(1, 2023, 3,  198000, 175000, 65.10, 42000000),
(1, 2023, 4,  191000, 168000, 64.90, 40100000),
(1, 2023, 5,  205000, 181000, 65.50, 43600000),
(1, 2023, 6,  178000, 156000, 64.20, 37400000),
(1, 2023, 7,  195000, 172000, 65.00, 41200000),
(1, 2023, 8,  210000, 185000, 65.80, 44400000),
(1, 2023, 9,  188000, 165000, 64.70, 39600000),
(1, 2023, 10, 202000, 178000, 65.30, 42800000),
(1, 2023, 11, 196000, 173000, 65.10, 41500000),
(1, 2023, 12, 183000, 160000, 64.40, 38300000),

-- Khumani Mine 2023 (Iron Ore)
(2, 2023, 1,  420000, 378000, 65.20, 90500000),
(2, 2023, 2,  398000, 358000, 64.80, 85900000),
(2, 2023, 3,  445000, 401000, 65.60, 96200000),
(2, 2023, 4,  432000, 389000, 65.40, 93400000),
(2, 2023, 5,  455000, 410000, 65.90, 98000000),
(2, 2023, 6,  410000, 369000, 65.00, 88600000),
(2, 2023, 7,  442000, 398000, 65.50, 95800000),
(2, 2023, 8,  468000, 421000, 66.10, 101000000),
(2, 2023, 9,  428000, 385000, 65.30, 92600000),
(2, 2023, 10, 450000, 405000, 65.70, 97200000),
(2, 2023, 11, 438000, 394000, 65.40, 94500000),
(2, 2023, 12, 415000, 374000, 65.10, 89700000),

-- Black Rock Mine 2023 (Manganese)
(3, 2023, 1,  95000, 88000, 38.50, 125000000),
(3, 2023, 2,  88000, 82000, 38.20, 116000000),
(3, 2023, 3,  102000, 95000, 38.80, 134000000),
(3, 2023, 4,  98000, 91000, 38.60, 128000000),
(3, 2023, 5,  108000, 100000, 39.10, 140000000),
(3, 2023, 6,  92000, 86000, 38.40, 121000000),
(3, 2023, 7,  105000, 98000, 38.90, 137000000),
(3, 2023, 8,  112000, 104000, 39.20, 145000000),
(3, 2023, 9,  98000, 91000, 38.70, 128000000),
(3, 2023, 10, 108000, 100000, 39.00, 140000000),
(3, 2023, 11, 104000, 97000, 38.90, 136000000),
(3, 2023, 12, 96000, 89000, 38.50, 126000000),

-- Dwarsrivier Chrome 2023
(5, 2023, 1,  48000, 43000, 44.50, 62000000),
(5, 2023, 2,  45000, 40000, 44.20, 58000000),
(5, 2023, 3,  52000, 47000, 44.80, 68000000),
(5, 2023, 4,  50000, 45000, 44.60, 65000000),
(5, 2023, 5,  55000, 50000, 45.00, 72000000),
(5, 2023, 6,  47000, 42000, 44.40, 61000000);

-- ============================================================
-- VALIDATION
-- ============================================================
SELECT 'Dataset v2 loaded successfully' AS status,
       (SELECT COUNT(*) FROM equipment)           AS equipment_count,
       (SELECT COUNT(*) FROM production_monthly)  AS production_records;

