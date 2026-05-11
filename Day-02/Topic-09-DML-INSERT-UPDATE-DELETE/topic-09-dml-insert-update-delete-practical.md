# Practical Lab — Day 2 Topic 03: DML
## Assmang Pty Ltd SQL100 Training

**Duration:** 60 minutes | **Dataset:** v3_assmang_setup.sql

```sql
USE assmang_training;
```

**⚠️ Safety Rule: Before every UPDATE or DELETE, run the SELECT version first!**

---

## Part A: INSERT INTO (20 minutes)

### A1 — Add a new employee
```sql
-- Step 1: Check current count
SELECT COUNT(*) AS before_insert FROM employees;

-- Step 2: Insert new employee
INSERT INTO employees
    (first_name, last_name, job_title, department_id, mine_id,
     salary_zar, hire_date, email, is_active, manager_id)
VALUES
    ('Simphiwe', 'Dube', 'Safety Officer', 4, 2,
     47500.00, '2024-05-01', 'si.dube@assmang.co.za', 1, 17);

-- Step 3: Verify
SELECT COUNT(*) AS after_insert FROM employees;
SELECT * FROM employees WHERE last_name = 'Dube' AND first_name = 'Simphiwe';
```
> **✅ Expected:** Count increases from 31 to 32; new record visible

### A2 — Add multiple new employees in one statement
```sql
INSERT INTO employees
    (first_name, last_name, job_title, department_id, mine_id,
     salary_zar, hire_date, email, is_active, manager_id)
VALUES
    ('Lungelo', 'Ntuli',   'Driller',         2, 4, 45000.00, '2024-04-15', 'l.ntuli@assmang.co.za',  1, 10),
    ('Marelize','Van Wyk',  'Finance Analyst',  5, NULL, 55000.00, '2024-03-20', 'm.vanwyk@assmang.co.za', 1, 20);

-- Verify
SELECT last_name, first_name, job_title, hire_date
FROM employees
WHERE hire_date >= '2024-01-01'
ORDER BY hire_date;
```

### A3 — Add a maintenance log entry
```sql
-- Check current maintenance records
SELECT COUNT(*) FROM maintenance_log;

-- Add new entry
INSERT INTO maintenance_log
    (equipment_id, maintenance_date, maintenance_type, technician_id,
     description, cost_zar, completed)
VALUES
    (9, '2024-05-01', 'Scheduled', 14,
     '750-hour service — full filter replacement and fluid top-up',
     19500.00, 0);

-- Verify
SELECT * FROM maintenance_log WHERE equipment_id = 9;
```

### A4 — INSERT INTO ... SELECT (salary snapshot)
```sql
-- Create snapshot table
IF OBJECT_ID('dbo.salary_snapshot_2024', 'U') IS NOT NULL
    DROP TABLE dbo.salary_snapshot_2024;

CREATE TABLE salary_snapshot_2024 (
    snapshot_id     INT IDENTITY(1,1) PRIMARY KEY,
    captured_date   DATE NOT NULL,
    employee_id     INT,
    full_name       VARCHAR(130),
    job_title       VARCHAR(100),
    salary_zar      DECIMAL(12,2)
);

-- Populate from employees
INSERT INTO salary_snapshot_2024 (captured_date, employee_id, full_name, job_title, salary_zar)
SELECT
    CAST(GETDATE() AS date)                 AS captured_date,
    employee_id,
    CONCAT(first_name, ' ', last_name),
    job_title,
    salary_zar
FROM employees
WHERE is_active = 1;

-- Verify
SELECT COUNT(*) AS snapshot_count FROM salary_snapshot_2024;
SELECT TOP (5) * FROM salary_snapshot_2024;
```

---

## Part B: UPDATE (20 minutes)

### B1 — Single row update: give an employee a title change and raise
```sql
-- Before
SELECT employee_id, first_name, last_name, job_title, salary_zar
FROM employees WHERE employee_id = 2;

-- Update
UPDATE employees
SET job_title  = 'Senior HR Officer',
    salary_zar = 43000.00
WHERE employee_id = 2;

-- After
SELECT employee_id, first_name, last_name, job_title, salary_zar
FROM employees WHERE employee_id = 2;
```
> **✅ Expected:** Thabo Mokoena now shows 'Senior HR Officer' at R43,000

### B2 — Mark a maintenance job as completed
```sql
-- Before
SELECT log_id, equipment_id, completed, cost_zar
FROM maintenance_log WHERE log_id = 13;

-- Update
UPDATE maintenance_log
SET completed = 1
WHERE log_id = 13;

-- After
SELECT log_id, equipment_id, completed FROM maintenance_log WHERE log_id = 13;
```

### B3 — Bulk update: 8% salary increase for Mining Operations
```sql
-- SAFETY CHECK: see who will be affected and current totals
SELECT
    COUNT(*) AS employees_affected,
    SUM(salary_zar) AS current_payroll,
    ROUND(SUM(salary_zar * 1.08), 2) AS new_payroll
FROM employees
WHERE department_id = 2 AND is_active = 1;

-- Apply the update
UPDATE employees
SET salary_zar = ROUND(salary_zar * 1.08, 2)
WHERE department_id = 2 AND is_active = 1;

-- Verify
SELECT first_name, last_name, salary_zar
FROM employees
WHERE department_id = 2
ORDER BY salary_zar DESC;
```

### B4 — Update with transaction (safe approach)
```sql
START TRANSACTION;

-- Check before
SELECT salary_zar FROM employees WHERE employee_id = 16;

-- Update
UPDATE employees
SET salary_zar = 58000.00
WHERE employee_id = 16;  -- Deon Steyn: Maintenance Technician

-- Check after
SELECT salary_zar FROM employees WHERE employee_id = 16;

-- Looks good? Commit
COMMIT;

-- Changed your mind? Use ROLLBACK instead:
-- ROLLBACK;
```

---

## Part C: DELETE (15 minutes)

### C1 — Delete a specific training record
```sql
-- Step 1: Find the record
SELECT * FROM training_register WHERE register_id = 17;  -- Nolwazi Gwala - pending

-- Step 2: Delete
DELETE FROM training_register
WHERE register_id = 17;

-- Step 3: Verify
SELECT * FROM training_register WHERE register_id = 17;  -- Should return 0 rows
SELECT COUNT(*) AS remaining FROM training_register;
```

### C2 — Delete multiple records with condition
```sql
-- Remove all training records where result is NULL (not yet taken / no result)
-- Step 1: Check how many
SELECT COUNT(*) AS pending_records
FROM training_register
WHERE passed IS NULL;

-- Step 2: Delete
DELETE FROM training_register
WHERE passed IS NULL;

-- Step 3: Confirm
SELECT COUNT(*) AS after_delete FROM training_register;
-- Expected: previously 18 records; verify correct reduction
```

### C3 — Delete using transaction (safe)
```sql
START TRANSACTION;

-- Check what we're about to delete
SELECT * FROM maintenance_log WHERE completed = 0;

-- Delete incomplete (future) maintenance entries from our snapshot
DELETE FROM maintenance_log
WHERE completed = 0
  AND maintenance_date > '2024-03-31';

-- Verify remaining
SELECT * FROM maintenance_log ORDER BY maintenance_date;

-- Commit if satisfied
COMMIT;
-- Or: ROLLBACK;
```

---

## Part D: TRUNCATE (5 minutes — demonstration only)

```sql
-- Check records before truncate
SELECT COUNT(*) FROM salary_snapshot_2024;

-- TRUNCATE — removes all rows, resets auto-increment
TRUNCATE TABLE salary_snapshot_2024;

-- Verify
SELECT COUNT(*) FROM salary_snapshot_2024;  -- Expected: 0
```
> **Note:** You can re-insert with A4 to restore the snapshot table for further exercises.

---

## ✅ Comprehensive Validation

Run these to confirm your DML operations worked correctly:

```sql
-- 1. Employee count after inserts
SELECT COUNT(*) AS total_employees FROM employees;
-- Expected: 33 (31 original + 2 new in A1/A2)

-- 2. Thabo Mokoena's updated records
SELECT employee_id, first_name, last_name, job_title, salary_zar
FROM employees WHERE employee_id = 2;

-- 3. Mining Ops salary after 8% raise (B3)
SELECT MIN(salary_zar) AS new_min, MAX(salary_zar) AS new_max, AVG(salary_zar) AS new_avg
FROM employees WHERE department_id = 2;

-- 4. Training register record count after deletes
SELECT COUNT(*) FROM training_register;
```

---

## Lab Completion Checklist

- [ ] Inserted single employee row (A1) with verification
- [ ] Inserted multiple rows at once (A2)
- [ ] Used INSERT INTO ... SELECT for snapshot (A4)
- [ ] Performed targeted single-row UPDATE (B1)
- [ ] Performed bulk conditional UPDATE (B3)
- [ ] Used START TRANSACTION + COMMIT (B4)
- [ ] Deleted specific row with confirmation (C1)
- [ ] Deleted multiple rows with condition (C2)
- [ ] Ran validation queries

---

*End of Practical — Day 2 Topic 03*

