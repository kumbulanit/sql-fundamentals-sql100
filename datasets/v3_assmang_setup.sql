-- ============================================================
-- DATASET v3 — Assmang Pty Ltd Training Database (Full)
-- SQL100 Beginner SQL Course
-- Used in: Day 2 Topic 03 (DML) & Topic 04 (DDL)
-- INCLUDES: all v2 tables + maintenance_log + training_courses
-- ============================================================
-- Run after v2 in SQL Server, or execute v1 and v2 first in order.
-- ============================================================

-- SQL Server does not support SOURCE in regular query windows.
-- Run datasets/v1_assmang_setup.sql and datasets/v2_assmang_setup.sql first.

USE assmang_training;
GO

-- ============================================================
-- TABLE 6: maintenance_log
-- Used in DML exercises (INSERT/UPDATE/DELETE targets)
-- ============================================================
CREATE TABLE maintenance_log (
    log_id          INT             IDENTITY(1,1) NOT NULL,
    equipment_id    INT             NOT NULL,
    maintenance_date DATE           NOT NULL,
    maintenance_type VARCHAR(50)    NOT NULL,  -- Scheduled, Breakdown, Inspection
    technician_id   INT             NOT NULL,  -- FK to employees
    description     VARCHAR(500),
    cost_zar        DECIMAL(12, 2)  NOT NULL DEFAULT 0.00,
    completed       BIT             NOT NULL DEFAULT 0,
    PRIMARY KEY (log_id),
    FOREIGN KEY (equipment_id)  REFERENCES equipment(equipment_id),
    FOREIGN KEY (technician_id) REFERENCES employees(employee_id)
);

INSERT INTO maintenance_log (equipment_id, maintenance_date, maintenance_type, technician_id, description, cost_zar, completed) VALUES
(1,  '2024-01-15', 'Scheduled',   14, 'Engine oil change and filter replacement',             18500.00, 1),
(2,  '2024-01-20', 'Scheduled',   14, 'Tyre rotation and pressure check — all 6 tyres',      12200.00, 1),
(3,  '2024-02-05', 'Breakdown',   16, 'Hydraulic pump failure — full pump replacement',      185000.00, 1),
(4,  '2024-02-12', 'Inspection',  14, 'Annual drill bit inspection and lubrication service', 8500.00,  1),
(5,  '2024-03-01', 'Scheduled',   14, 'Blade replacement and frame alignment',               24000.00, 1),
(6,  '2024-01-10', 'Scheduled',   16, 'Boom and arm pin inspection',                         15000.00, 1),
(7,  '2024-02-28', 'Breakdown',   16, 'Engine overheating — coolant system overhaul',        220000.00,1),
(8,  '2024-03-15', 'Scheduled',   16, '500-hour service — filters, oil, belts',              32000.00, 1),
(11, '2024-01-25', 'Scheduled',   15, '1000-hour service — tracks and rollers',              45000.00, 1),
(15, '2024-02-20', 'Breakdown',   15, 'Drill string breakage — replacement and alignment',  95000.00,  1),
(18, '2024-01-08', 'Scheduled',   16, 'Engine oil change and hydraulic fluid check',         16000.00, 1),
(19, '2024-03-10', 'Inspection',  16, 'Pre-shift safety inspection — hois and brakes',       5000.00,  1),
(20, '2024-02-15', 'Scheduled',   16, 'Drill bit replacement and boom inspection',           28000.00, 0),
(3,  '2024-04-01', 'Scheduled',   14, 'Post-repair 250-hour service',                        22000.00, 0),
(7,  '2024-04-10', 'Inspection',  16, 'Post-repair engine inspection and load test',         8000.00,  0);

-- ============================================================
-- TABLE 7: training_courses_register
-- Used in DDL exercises (CREATE TABLE practice)
-- ============================================================
CREATE TABLE training_register (
    register_id     INT             IDENTITY(1,1) NOT NULL,
    employee_id     INT             NOT NULL,
    course_name     VARCHAR(150)    NOT NULL,
    course_date     DATE            NOT NULL,
    passed          BIT,                       -- NULL = result pending
    score_pct       DECIMAL(5, 2),
    PRIMARY KEY (register_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

INSERT INTO training_register (employee_id, course_name, course_date, passed, score_pct) VALUES
(6,  'Blasting Certificate Renewal',      '2024-01-20', 1, 88.50),
(7,  'Blasting Certificate Renewal',      '2024-01-20', 1, 82.00),
(5,  'First Aid Level 3',                 '2024-02-05', 1, 91.00),
(18, 'Safety Officer Recertification',    '2024-02-10', 1, 78.50),
(14, 'Diesel Mechanic Refresher',         '2024-02-20', 1, 85.00),
(15, 'Electrical Safety',                 '2024-02-20', 0, 54.00),
(16, 'Diesel Mechanic Refresher',         '2024-02-20', 1, 90.00),
(2,  'HR Compliance 2024',               '2024-03-01', 1, 79.00),
(3,  'HR Compliance 2024',               '2024-03-01', 1, 82.50),
(25, 'Cybersecurity Awareness',           '2024-03-10', 1, 95.00),
(24, 'Cybersecurity Awareness',           '2024-03-10', 1, 88.00),
(11, 'Surface Blasting Level 2',          '2024-03-15', NULL, NULL),
(12, 'Surface Blasting Level 2',          '2024-03-15', NULL, NULL),
(30, 'Plant Operations Refresher',        '2024-03-20', 1, 76.00),
(31, 'Plant Operations Refresher',        '2024-03-20', 1, 73.50),
(8,  'Truck Operator Certification',      '2024-04-05', 1, 87.00),
(27, 'Logistics Safety',                  '2024-04-08', NULL, NULL),
(15, 'Electrical Safety (Re-sit)',        '2024-05-01', NULL, NULL);

-- ============================================================
-- VALIDATION
-- ============================================================
SELECT 'Dataset v3 loaded successfully' AS status,
       (SELECT COUNT(*) FROM maintenance_log)     AS maintenance_records,
       (SELECT COUNT(*) FROM training_register)   AS training_records;

-- ============================================================
-- FULL DATABASE SUMMARY
-- ============================================================
SELECT 'FULL DATASET SUMMARY' AS report;
SELECT 'departments'       AS table_name, COUNT(*) AS row_count FROM departments
UNION ALL
SELECT 'mines',                            COUNT(*) FROM mines
UNION ALL
SELECT 'employees',                        COUNT(*) FROM employees
UNION ALL
SELECT 'equipment',                        COUNT(*) FROM equipment
UNION ALL
SELECT 'production_monthly',               COUNT(*) FROM production_monthly
UNION ALL
SELECT 'maintenance_log',                  COUNT(*) FROM maintenance_log
UNION ALL
SELECT 'training_register',                COUNT(*) FROM training_register;

