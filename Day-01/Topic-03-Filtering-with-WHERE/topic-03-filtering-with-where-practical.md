# Practical Lab 03 — Filtering Data with WHERE
## Day 1, Topic 03 | Assmang Pty Ltd SQL100 Training

**Duration:** 60 minutes  
**Dataset:** v1_assmang_setup.sql  
**Tool:** DBeaver + SQL Server

---

## Setup
```sql
USE assmang_training;
```

---

## Part A: Basic Comparison Operators (15 minutes)

### A1 — Find the Finance Director
```sql
SELECT first_name, last_name, job_title, salary_zar
FROM employees
WHERE job_title = 'Finance Director';
```
> **✅ Expected:** Riaan De Jager — R150,000.00

### A2 — Find all employees who are NOT in Mining Operations (dept 2)
```sql
SELECT first_name, last_name, department_id, job_title
FROM employees
WHERE department_id <> 2;
```
> **Question:** How many employees are NOT in Mining Operations?

### A3 — Find high earners (salary over R100,000)
```sql
SELECT
    CONCAT(first_name, ' ', last_name)  AS employee,
    job_title,
    salary_zar
FROM employees
WHERE salary_zar > 100000
ORDER BY salary_zar DESC;
```
> **✅ Expected:** 4 rows — Riaan De Jager, Werner Fourie, Calvin Pretorius, Johan Van Niekerk

### A4 — Mines established from 1980 onwards
```sql
SELECT mine_name, mine_type, established_year
FROM mines
WHERE established_year >= 1980;
```
> **✅ Expected:** 2 rows — Khumani Mine (2008), Dwarsrivier Chrome (1986)

### A5 — Departments with budget less than R6 million
```sql
SELECT department_name, budget_zar
FROM departments
WHERE budget_zar < 6000000
ORDER BY budget_zar ASC;
```

---

## Part B: AND, OR, NOT (15 minutes)

### B1 — Senior engineers (Engineering dept, salary > R85,000)
```sql
SELECT first_name, last_name, job_title, salary_zar
FROM employees
WHERE department_id = 3
  AND salary_zar > 85000;
```
> **✅ Expected:** Werner Fourie (R135,000), Precious Ndlovu (R91,000)

### B2 — Safety OR HR employees
```sql
SELECT
    CONCAT(first_name, ' ', last_name)  AS employee,
    job_title,
    department_id
FROM employees
WHERE department_id = 1
   OR department_id = 4
ORDER BY department_id, last_name;
```
> **✅ Expected:** 6 rows (3 HR + 3 Safety)

### B3 — Exclude support roles
```sql
SELECT first_name, last_name, job_title
FROM employees
WHERE NOT job_title IN ('HR Officer', 'Payroll Officer', 'Transport Coordinator', 'Freight Planner');
```

### B4 — Field operations: Active drillers and blasters
```sql
SELECT
    CONCAT(first_name, ' ', last_name)  AS employee,
    job_title,
    mine_id
FROM employees
WHERE (job_title = 'Driller' OR job_title = 'Blaster')
  AND is_active = 1;
```
> **✅ Expected:** 4 rows — Mpho Sithole, Lebo Nkosi, Karabo Tshabalala, Sipho Zulu

### B5 — Operational Manganese or Chrome mines
```sql
SELECT mine_name, mine_type, province
FROM mines
WHERE (mine_type = 'Manganese' OR mine_type = 'Chrome')
  AND operational = 1;
```
> **✅ Expected:** 3 rows — Black Rock, Gloria, Dwarsrivier

---

## Part C: BETWEEN, IN, LIKE (15 minutes)

### C1 — Mid-salary employees (R45,000 – R75,000)
```sql
SELECT
    CONCAT(first_name, ' ', last_name)  AS employee,
    salary_zar
FROM employees
WHERE salary_zar BETWEEN 45000 AND 75000
ORDER BY salary_zar;
```

### C2 — Employees in HR, Safety, and Finance (using IN)
```sql
SELECT
    first_name,
    last_name,
    department_id
FROM employees
WHERE department_id IN (1, 4, 5)
ORDER BY department_id, last_name;
```
> **✅ Expected:** 8 rows

### C3 — Find all engineers and managers using LIKE
```sql
SELECT DISTINCT job_title
FROM employees
WHERE job_title LIKE '%Engineer%'
   OR job_title LIKE '%Manager%';
```

### C4 — Find employees hired between 2017 and 2019
```sql
SELECT
    CONCAT(first_name, ' ', last_name)  AS employee,
    hire_date
FROM employees
WHERE hire_date BETWEEN '2017-01-01' AND '2019-12-31'
ORDER BY hire_date;
```

### C5 — Mines whose names contain "Black" or start with "K"
```sql
SELECT mine_name, mine_type
FROM mines
WHERE mine_name LIKE '%Black%'
   OR mine_name LIKE 'K%';
```
> **✅ Expected:** 2 rows — Black Rock Mine, Khumani Mine

### C6 — Employees with email starting with 'n'
```sql
SELECT first_name, last_name, email
FROM employees
WHERE email LIKE 'n.%';
```

---

## Part D: NULL Handling (10 minutes)

### D1 — Head Office employees (no mine assignment)
```sql
SELECT
    CONCAT(first_name, ' ', last_name)  AS employee,
    job_title,
    department_id
FROM employees
WHERE mine_id IS NULL
ORDER BY department_id;
```
> **✅ Expected:** 13 employees based at Head Office

### D2 — All employees assigned to a mine
```sql
SELECT
    CONCAT(first_name, ' ', last_name)  AS employee,
    job_title,
    mine_id
FROM employees
WHERE mine_id IS NOT NULL
ORDER BY mine_id;
```
> **✅ Expected:** 18 employees (31 total - 13 head office)

### D3 — Top-level staff (no manager)
```sql
SELECT
    CONCAT(first_name, ' ', last_name)  AS employee,
    job_title
FROM employees
WHERE manager_id IS NULL;
```
> **✅ Expected:** Directors and Managers with no reporting line above them

---

## Part E: Combined Realistic Scenarios (5 minutes)

### E1 — Monthly payroll filter: active mid-level field staff
**Business scenario:** Generate payroll for active employees at Black Rock Mine (mine_id=3) or Beeshoek Mine (mine_id=1), earning between R40,000 and R80,000.
```sql
SELECT
    CONCAT(first_name, ' ', last_name)  AS employee,
    job_title,
    mine_id,
    salary_zar
FROM employees
WHERE mine_id IN (1, 3)
  AND salary_zar BETWEEN 40000 AND 80000
  AND is_active = 1
ORDER BY mine_id, salary_zar DESC;
```

---

## ✅ Final Validation

```sql
-- How many employees are in the Mining Operations department?
SELECT COUNT(*) AS mining_ops_count
FROM employees
WHERE department_id = 2;
-- Expected: 9

-- How many employees earn above the overall average?
SELECT COUNT(*) AS above_average_earners
FROM employees
WHERE salary_zar > 67419.35;  -- approximate average; calculate your own!
```

**Calculate the actual average first:**
```sql
SELECT ROUND(AVG(salary_zar), 2) AS avg_salary FROM employees;
```

---

## Lab Completion Checklist

- [ ] Used `=`, `<>`, `>`, `>=`, `<`, `<=` operators
- [ ] Combined conditions with AND and OR
- [ ] Used parentheses correctly for mixed AND/OR
- [ ] Used BETWEEN for salary and date ranges
- [ ] Used IN to filter multiple values
- [ ] Used LIKE with % and _ wildcards
- [ ] Used IS NULL and IS NOT NULL correctly
- [ ] Completed the combined business scenario (E1)

---

*End of Practical 03*

