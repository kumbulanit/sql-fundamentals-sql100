# Practical Lab — Day 2 Topic 04: DDL & Best Practices
## Assmang Pty Ltd SQL100 Training

**Duration:** 60 minutes | **Dataset:** v3_assmang_setup.sql

```sql
USE assmang_training;
```

---

## Part A: CREATE TABLE (20 minutes)

### A1 — Create a new contractors table
```sql
IF OBJECT_ID('dbo.contractors', 'U') IS NOT NULL
    DROP TABLE dbo.contractors;

CREATE TABLE contractors (
    contractor_id       INT             IDENTITY(1,1) PRIMARY KEY,
    company_name        VARCHAR(150)    NOT NULL,
    contact_person      VARCHAR(100)    NOT NULL,
    contact_email       VARCHAR(150)    NOT NULL UNIQUE,
    mine_id             INT,
    service_type        VARCHAR(100)    NOT NULL,
    contract_start      DATE            NOT NULL,
    contract_end        DATE,
    daily_rate_zar      DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    is_active           BIT             NOT NULL DEFAULT 1,
    created_at          DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (mine_id) REFERENCES mines(mine_id)
);

-- Verify structure
EXEC sp_help 'dbo.contractors';
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME;
```
> **✅ Expected:** Table created with 11 columns; FK to mines table

### A2 — Create a shift_roster table
```sql
IF OBJECT_ID('dbo.shift_roster', 'U') IS NOT NULL
    DROP TABLE dbo.shift_roster;

CREATE TABLE shift_roster (
    shift_id        INT             IDENTITY(1,1) PRIMARY KEY,
    employee_id     INT             NOT NULL,
    mine_id         INT             NOT NULL,
    shift_date      DATE            NOT NULL,
    shift_type      VARCHAR(10)     NOT NULL DEFAULT 'Day'
        CHECK (shift_type IN ('Day','Night','Weekend')),
    hours_worked    DECIMAL(4,2)    NOT NULL DEFAULT 8.00,
    notes           TEXT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (mine_id)     REFERENCES mines(mine_id)
);

EXEC sp_help 'dbo.shift_roster';
```

### A3 — Insert data into your new tables
```sql
-- Add contractors
INSERT INTO contractors
    (company_name, contact_person, contact_email, mine_id, service_type,
     contract_start, contract_end, daily_rate_zar, is_active)
VALUES
    ('MineServ Drilling (Pty) Ltd', 'Pieter Venter', 'p.venter@mineserv.co.za',
     1, 'Drilling Services', '2024-01-01', '2024-12-31', 35000.00, 1),
    ('SafeGuard Africa', 'Nompumelelo Dube', 'n.dube@safeguard.co.za',
     3, 'Safety Consulting', '2024-02-01', NULL, 18000.00, 1),
    ('TechRock Engineering', 'Jan Botha', 'j.botha@techrock.co.za',
     2, 'Blasting & Explosives', '2024-03-01', '2025-02-28', 42000.00, 1);

-- Verify
SELECT * FROM contractors;

-- Add shift records
INSERT INTO shift_roster
    (employee_id, mine_id, shift_date, shift_type, hours_worked)
VALUES
    (6,  1, '2024-05-01', 'Day',   9.0),
    (7,  1, '2024-05-01', 'Day',   9.0),
    (11, 3, '2024-05-01', 'Night', 8.5),
    (12, 3, '2024-05-01', 'Night', 8.5),
    (5,  1, '2024-05-02', 'Day',   8.0),
    (10, 3, '2024-05-02', 'Day',   8.0);

SELECT * FROM shift_roster;
```

---

## Part B: ALTER TABLE (15 minutes)

### B1 — Add a phone number column to contractors
```sql
-- Add column
ALTER TABLE contractors
ADD phone_number VARCHAR(20);

-- Verify
DESC contractors;

-- Update some records with phone numbers
UPDATE contractors SET phone_number = '012 345 6789' WHERE contractor_id = 1;
UPDATE contractors SET phone_number = '011 998 4321' WHERE contractor_id = 2;
SELECT contractor_id, company_name, phone_number FROM contractors;
```

### B2 — Modify the notes column in shift_roster
```sql
-- Change TEXT to VARCHAR(500)
ALTER TABLE shift_roster
ALTER COLUMN notes VARCHAR(500);

-- Verify
DESC shift_roster;
```

### B3 — Add a cancelled status column to shift_roster
```sql
ALTER TABLE shift_roster
ADD is_cancelled BIT NOT NULL DEFAULT 0;

-- Mark one shift as cancelled
UPDATE shift_roster SET is_cancelled = 1 WHERE shift_id = 3;

SELECT * FROM shift_roster;
```

### B4 — Rename a column
```sql
EXEC sp_rename 'dbo.contractors.is_active', 'active_status', 'COLUMN';

EXEC sp_help 'dbo.contractors';
```

### B5 — Add an index for performance
```sql
-- Index for frequent queries by mine and shift date
CREATE INDEX idx_shift_mine_date
ON shift_roster (mine_id, shift_date);

SELECT i.name AS index_name, c.name AS column_name
FROM sys.indexes i
JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('dbo.shift_roster')
ORDER BY i.name, ic.key_ordinal;
```

---

## Part C: CREATE VIEW (15 minutes)

### C1 — Employee directory view (safe for sharing)
```sql
CREATE OR ALTER VIEW vw_employee_directory AS
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name)      AS full_name,
    e.job_title,
    d.department_name,
    COALESCE(m.mine_name, 'Head Office')         AS site,
    e.email,
    e.hire_date
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
LEFT  JOIN mines m       ON e.mine_id       = m.mine_id
WHERE e.is_active = 1;

-- Test the view
SELECT * FROM vw_employee_directory ORDER BY department_name, full_name;
SELECT * FROM vw_employee_directory WHERE site LIKE '%Black Rock%';
SELECT COUNT(*) FROM vw_employee_directory;
```

### C2 — Production performance view
```sql
CREATE OR ALTER VIEW vw_production_2023 AS
SELECT
    m.mine_name,
    m.mine_type,
    p.production_month,
    p.tonnes_mined,
    p.tonnes_processed,
    p.ore_grade_pct,
    p.revenue_zar,
    ROUND(p.revenue_zar / p.tonnes_processed, 2) AS revenue_per_tonne
FROM production_monthly p
INNER JOIN mines m ON p.mine_id = m.mine_id
WHERE p.production_year = 2023;

-- Use the view with aggregation
SELECT mine_name, mine_type,
       SUM(tonnes_mined)           AS annual_tonnes,
       SUM(revenue_zar)            AS annual_revenue,
       ROUND(AVG(revenue_per_tonne),2) AS avg_rev_per_tonne
FROM vw_production_2023
GROUP BY mine_name, mine_type
ORDER BY annual_revenue DESC;
```

### C3 — Payroll summary view
```sql
CREATE OR ALTER VIEW vw_dept_payroll AS
SELECT
    d.department_name,
    COUNT(e.employee_id)            AS headcount,
    SUM(e.salary_zar)               AS monthly_payroll,
    ROUND(AVG(e.salary_zar), 2)     AS avg_salary,
    MIN(e.salary_zar)               AS min_salary,
    MAX(e.salary_zar)               AS max_salary
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id AND e.is_active = 1
GROUP BY d.department_id, d.department_name;

-- Use it
SELECT * FROM vw_dept_payroll ORDER BY monthly_payroll DESC;
```

---

## Part D: DROP and Cleanup (5 minutes)

```sql
-- Show all tables and views
SELECT name, type_desc
FROM sys.objects
WHERE type IN ('U','V')
ORDER BY type_desc, name;

-- Drop the shift roster (we'll go back to basics)
DROP TABLE IF EXISTS shift_roster;

-- Drop views (if we want to start fresh)
-- DROP VIEW IF EXISTS vw_employee_directory;  -- uncomment if desired

-- Verify
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
```

---

## ✅ Comprehensive Validation — Full Database Inventory

```sql
-- Show all tables and their row counts
SELECT
    table_name,
        SUM(CASE WHEN p.index_id IN (0,1) THEN p.rows ELSE 0 END) AS row_count
FROM information_schema.tables
LEFT JOIN sys.partitions p ON OBJECT_ID(QUOTENAME(table_schema) + '.' + QUOTENAME(table_name)) = p.object_id
WHERE table_catalog = 'assmang_training'
    AND table_schema = 'dbo'
GROUP BY table_name
ORDER BY table_name;

-- Show all indexes on key tables
SELECT i.name AS index_name, o.name AS table_name
FROM sys.indexes i
JOIN sys.objects o ON i.object_id = o.object_id
WHERE o.name IN ('employees', 'equipment')
    AND i.name IS NOT NULL
ORDER BY o.name, i.name;

-- Show all views
SELECT name AS view_name
FROM sys.views
ORDER BY name;

-- Test all three views
SELECT COUNT(*) AS directory_count  FROM vw_employee_directory;
SELECT COUNT(*) AS production_count FROM vw_production_2023;
SELECT COUNT(*) AS payroll_count    FROM vw_dept_payroll;
```

> **Expected Views Created:** vw_employee_directory, vw_production_2023, vw_dept_payroll

---

## Lab Completion Checklist

- [ ] Created `contractors` table with constraints (A1)
- [ ] Created `shift_roster` table with a CHECK constraint (A2)
- [ ] Inserted data into both tables (A3)
- [ ] Added column with ALTER TABLE (B1)
- [ ] Modified column type (B2)
- [ ] Created index (B5)
- [ ] Created `vw_employee_directory` view (C1)
- [ ] Queried the view with WHERE and GROUP BY (C1, C2, C3)
- [ ] Ran final validation (all views working)

---

*End of Practical — Day 2 Topic 04 — Final Practical of the Course*

