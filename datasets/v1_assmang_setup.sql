-- ============================================================
-- DATASET v1 — Assmang Pty Ltd Training Database
-- SQL100 Beginner SQL Course
-- Used in: Day 1 (Topics 01 – 04)
-- ============================================================
-- Tables: departments, employees, mines
-- Progressive: starts simple, extended in v2 and v3
-- ============================================================

-- Create and select training database
DROP DATABASE IF EXISTS assmang_training;
CREATE DATABASE assmang_training;
GO

USE assmang_training;
GO

-- ============================================================
-- TABLE 1: departments
-- ============================================================
CREATE TABLE departments (
    department_id   INT             IDENTITY(1,1) NOT NULL,
    department_name VARCHAR(100)    NOT NULL,
    location        VARCHAR(100)    NOT NULL,
    budget_zar      DECIMAL(15, 2)  NOT NULL,
    PRIMARY KEY (department_id)
);

INSERT INTO departments (department_name, location, budget_zar) VALUES
('Human Resources',      'Kathu, Northern Cape',   5200000.00),
('Mining Operations',    'Kathu, Northern Cape',  45000000.00),
('Engineering',          'Postmasburg, NC',        18500000.00),
('Safety & Environment', 'Kathu, Northern Cape',   3800000.00),
('Finance',              'Johannesburg, GP',        7600000.00),
('Information Technology','Johannesburg, GP',       4100000.00),
('Logistics',            'Postmasburg, NC',        12300000.00),
('Processing Plant',     'Hotazel, NC',            32000000.00);

-- ============================================================
-- TABLE 2: mines
-- ============================================================
CREATE TABLE mines (
    mine_id         INT             IDENTITY(1,1) NOT NULL,
    mine_name       VARCHAR(100)    NOT NULL,
    mine_type       VARCHAR(50)     NOT NULL,   -- Iron Ore, Manganese, Chrome
    province        VARCHAR(60)     NOT NULL,
    operational     BIT             NOT NULL DEFAULT 1,
    established_year INT            NOT NULL,
    PRIMARY KEY (mine_id)
);

INSERT INTO mines (mine_name, mine_type, province, operational, established_year) VALUES
('Beeshoek Mine',       'Iron Ore',   'Northern Cape', 1, 1964),
('Khumani Mine',        'Iron Ore',   'Northern Cape', 1, 2008),
('Black Rock Mine',     'Manganese',  'Northern Cape', 1, 1940),
('Gloria Mine',         'Manganese',  'Northern Cape', 1, 1975),
('Dwarsrivier Chrome',  'Chrome',     'Limpopo',       1, 1986),
('Machadodorp Works',   'Chrome',     'Mpumalanga',    0, 1970);

-- ============================================================
-- TABLE 3: employees
-- ============================================================
CREATE TABLE employees (
    employee_id     INT             IDENTITY(1,1) NOT NULL,
    first_name      VARCHAR(60)     NOT NULL,
    last_name       VARCHAR(60)     NOT NULL,
    job_title       VARCHAR(100)    NOT NULL,
    department_id   INT             NOT NULL,
    mine_id         INT,                         -- NULL = Head Office based
    salary_zar      DECIMAL(12, 2)  NOT NULL,
    hire_date       DATE            NOT NULL,
    email           VARCHAR(120)    NOT NULL,
    is_active       BIT             NOT NULL DEFAULT 1,
    manager_id      INT,                         -- Self-referencing FK (NULL = top-level)
    PRIMARY KEY (employee_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (mine_id)       REFERENCES mines(mine_id)
);

INSERT INTO employees (first_name, last_name, job_title, department_id, mine_id, salary_zar, hire_date, email, is_active, manager_id) VALUES
-- HR Department (dept 1)
('Nomsa',    'Dlamini',   'HR Manager',             1, NULL, 75000.00, '2015-03-01', 'n.dlamini@assmang.co.za',      1, NULL),
('Thabo',    'Mokoena',   'HR Officer',             1, NULL, 38000.00, '2019-07-15', 't.mokoena@assmang.co.za',      1, 1),
('Sibongile','Khumalo',   'Recruitment Specialist', 1, NULL, 42000.00, '2020-01-10', 's.khumalo@assmang.co.za',      1, 1),

-- Mining Operations (dept 2)
('Johan',    'Van Niekerk','Mine Manager',          2, 1,    120000.00,'2010-06-01', 'j.vanniekerk@assmang.co.za',   1, NULL),
('Petrus',   'Booysen',   'Shift Supervisor',       2, 1,    68000.00, '2013-09-20', 'p.booysen@assmang.co.za',      1, 4),
('Mpho',     'Sithole',   'Driller',                2, 1,    45000.00, '2018-04-05', 'm.sithole@assmang.co.za',      1, 5),
('Lebo',     'Nkosi',     'Blaster',                2, 1,    52000.00, '2017-11-14', 'l.nkosi@assmang.co.za',        1, 5),
('Andile',   'Cele',      'Truck Operator',         2, 2,    44000.00, '2021-02-01', 'a.cele@assmang.co.za',         1, 4),
('Calvin',   'Pretorius', 'Mine Manager',           2, 3,    125000.00,'2009-08-15', 'c.pretorius@assmang.co.za',    1, NULL),
('Refiloe',  'Molefe',    'Shift Supervisor',       2, 3,    70000.00, '2014-05-22', 'r.molefe@assmang.co.za',       1, 9),
('Karabo',   'Tshabalala','Driller',                2, 3,    46000.00, '2020-08-30', 'k.tshabalala@assmang.co.za',   1, 10),
('Sipho',    'Zulu',      'Blaster',                2, 4,    53000.00, '2016-03-17', 's.zulu@assmang.co.za',         1, 9),

-- Engineering (dept 3)
('Werner',   'Fourie',    'Chief Engineer',         3, NULL, 135000.00,'2008-01-15', 'w.fourie@assmang.co.za',       1, NULL),
('Kagiso',   'Mahlangu',  'Mechanical Engineer',    3, 1,    88000.00, '2016-07-01', 'k.mahlangu@assmang.co.za',     1, 13),
('Precious', 'Ndlovu',    'Electrical Engineer',    3, 3,    91000.00, '2015-11-20', 'p.ndlovu@assmang.co.za',       1, 13),
('Deon',     'Steyn',     'Maintenance Technician', 3, 5,    55000.00, '2019-03-12', 'd.steyn@assmang.co.za',        1, 13),

-- Safety (dept 4)
('Lindiwe',  'Mthembu',   'Safety Manager',         4, NULL, 80000.00, '2012-10-01', 'l.mthembu@assmang.co.za',      1, NULL),
('Bongani',  'Hadebe',    'Safety Officer',         4, 1,    47000.00, '2018-06-25', 'b.hadebe@assmang.co.za',       1, 17),
('Zanele',   'Mhlongo',   'Environmental Officer',  4, 3,    50000.00, '2017-09-08', 'z.mhlongo@assmang.co.za',      1, 17),

-- Finance (dept 5)
('Riaan',    'De Jager',  'Finance Director',       5, NULL, 150000.00,'2007-04-01', 'r.dejager@assmang.co.za',      1, NULL),
('Nosipho',  'Buthelezi', 'Senior Accountant',      5, NULL, 82000.00, '2014-02-17', 'n.buthelezi@assmang.co.za',    1, 20),
('Temba',    'Shabalala',  'Payroll Officer',        5, NULL, 46000.00, '2020-09-01', 't.shabalala@assmang.co.za',    1, 20),

-- IT (dept 6)
('Andre',    'Bothma',    'IT Manager',             6, NULL, 95000.00, '2011-08-01', 'a.bothma@assmang.co.za',       1, NULL),
('Sifiso',   'Nxumalo',   'Systems Administrator',  6, NULL, 62000.00, '2017-05-15', 's.nxumalo@assmang.co.za',      1, 23),
('Palesa',   'Mohlala',   'Database Administrator', 6, NULL, 68000.00, '2016-12-01', 'p.mohlala@assmang.co.za',      1, 23),

-- Logistics (dept 7)
('Gert',     'Boshoff',   'Logistics Manager',      7, NULL, 78000.00, '2013-06-20', 'g.boshoff@assmang.co.za',      1, NULL),
('Nolwazi',  'Gwala',     'Transport Coordinator',  7, 1,    43000.00, '2019-11-04', 'n.gwala@assmang.co.za',        1, 26),
('Moses',    'Dube',      'Freight Planner',        7, 3,    41000.00, '2021-04-12', 'm.dube@assmang.co.za',         1, 26),

-- Processing (dept 8)
('Irene',    'Jacobs',    'Plant Manager',          8, 5,    115000.00,'2010-10-01', 'i.jacobs@assmang.co.za',       1, NULL),
('Siphamandla','Mnguni',  'Process Operator',       8, 5,    49000.00, '2020-06-08', 'sp.mnguni@assmang.co.za',      1, 29),
('Francois', 'Du Toit',   'Process Operator',       8, 5,    49000.00, '2021-08-23', 'f.dutoit@assmang.co.za',       1, 29);

-- ============================================================
-- VALIDATION QUERIES (run after setup)
-- ============================================================
-- SELECT COUNT(*) AS total_employees FROM employees;  -- Expected: 31
-- SELECT COUNT(*) AS total_departments FROM departments;  -- Expected: 8
-- SELECT COUNT(*) AS total_mines FROM mines;  -- Expected: 6
-- SHOW TABLES;

SELECT 'Dataset v1 loaded successfully' AS status,
       (SELECT COUNT(*) FROM departments) AS departments_count,
       (SELECT COUNT(*) FROM mines)       AS mines_count,
       (SELECT COUNT(*) FROM employees)   AS employees_count;

