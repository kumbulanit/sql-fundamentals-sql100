# Practical Lab 04 — Sorting, Limiting & Ordering
## Day 1, Topic 04 | Assmang Pty Ltd SQL100 Training

**Duration:** 45 minutes  
**Dataset:** v1_assmang_setup.sql

---

```sql
USE assmang_training;
```

## Part A: Basic ORDER BY (15 minutes)

### A1 — Employees from lowest to highest salary
```sql
SELECT first_name, last_name, salary_zar
FROM employees
ORDER BY salary_zar ASC;
```
> **Question:** Who earns the least?

### A2 — Employees from highest to lowest salary
```sql
SELECT first_name, last_name, salary_zar
FROM employees
ORDER BY salary_zar DESC;
```
> **✅ Expected first row:** Riaan De Jager — R150,000

### A3 — Mines from oldest to newest
```sql
SELECT mine_name, mine_type, established_year
FROM mines
ORDER BY established_year ASC;
```
> **✅ Expected first:** Black Rock Mine (1940)

### A4 — Departments by budget descending
```sql
SELECT department_name, budget_zar
FROM departments
ORDER BY budget_zar DESC;
```
> **✅ Expected first:** Mining Operations (R45,000,000)

### A5 — Employees alphabetically by last name then first name
```sql
SELECT last_name, first_name, job_title
FROM employees
ORDER BY last_name ASC, first_name ASC;
```

---

## Part B: Multi-Column Sorting (10 minutes)

### B1 — Sort by department, then by salary within each department
```sql
SELECT
    department_id,
    CONCAT(first_name, ' ', last_name)  AS employee,
    salary_zar
FROM employees
ORDER BY department_id ASC,
         salary_zar DESC;
```
> **Observation:** Within each department, who earns the most?

### B2 — Mines sorted by type and then name
```sql
SELECT mine_name, mine_type, province, established_year
FROM mines
ORDER BY mine_type ASC,
         mine_name ASC;
```

### B3 — Active field employees sorted by mine, then salary
```sql
SELECT
    mine_id,
    CONCAT(first_name, ' ', last_name)  AS employee,
    job_title,
    salary_zar
FROM employees
WHERE mine_id IS NOT NULL
  AND is_active = 1
ORDER BY mine_id ASC,
         salary_zar DESC;
```

---

## Part C: TOP & OFFSET/FETCH (15 minutes)

### C1 — Top 3 highest-paid employees
```sql
SELECT
    CONCAT(first_name, ' ', last_name)  AS employee,
    job_title,
    salary_zar
FROM employees
ORDER BY salary_zar DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;
```
> **✅ Expected:** Riaan De Jager, Werner Fourie, Calvin Pretorius

### C2 — The single most recently hired employee
```sql
SELECT first_name, last_name, hire_date, job_title
FROM employees
ORDER BY hire_date DESC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;
```

### C3 — Pagination: View employees in pages of 5
```sql
-- Page 1 (employees 1-5)
SELECT employee_id, first_name, last_name
FROM employees
ORDER BY employee_id
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

-- Page 2 (employees 6-10)
SELECT employee_id, first_name, last_name
FROM employees
ORDER BY employee_id
OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;

-- Page 3 (employees 11-15)
SELECT employee_id, first_name, last_name
FROM employees
ORDER BY employee_id
OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY;
```
> **Observation:** Each page shows a different block of 5 employees

### C4 — Bottom 5 earners (lowest paid)
```sql
SELECT
    CONCAT(first_name, ' ', last_name)  AS employee,
    job_title,
    salary_zar
FROM employees
ORDER BY salary_zar ASC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
```

### C5 — 2nd and 3rd most expensive departments
```sql
SELECT department_name, budget_zar
FROM departments
ORDER BY budget_zar DESC
OFFSET 1 ROWS FETCH NEXT 2 ROWS ONLY;   -- skip the #1 (Mining Ops), show #2 and #3
```

---

## Part D: Sorting with Functions & Expressions (5 minutes)

### D1 — Sort by annual salary (use alias in ORDER BY)
```sql
SELECT
    CONCAT(first_name, ' ', last_name)  AS employee,
    salary_zar                          AS monthly,
    salary_zar * 12                     AS annual_salary
FROM employees
ORDER BY annual_salary DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
```

### D2 — Sort by longest last name
```sql
SELECT last_name, first_name, LENGTH(last_name) AS name_length
FROM employees
ORDER BY name_length DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
```

### D3 — Sort by years of service (longest-serving first)
```sql
SELECT
    CONCAT(first_name, ' ', last_name)              AS employee,
    hire_date,
    DATEDIFF(YEAR, hire_date, GETDATE())            AS years_service
FROM employees
ORDER BY years_service DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
```
> **Question:** Who has been at Assmang the longest?

---

## ✅ Comprehensive Validation

Run this complete query that uses all Day 1 skills:

```sql
SELECT
    CONCAT(UPPER(last_name), ', ', first_name)      AS employee,
    job_title                                        AS position,
    salary_zar                                       AS monthly_salary,
    ROUND(salary_zar * 12 * 0.72, 2)                AS net_annual_est,
    DATEDIFF(YEAR, hire_date, GETDATE())            AS years_service,
    CASE
        WHEN mine_id IS NULL THEN 'Head Office'
        ELSE CONCAT('Mine #', mine_id)
    END                                              AS site,
    CASE
        WHEN salary_zar >= 100000 THEN 'Executive'
        WHEN salary_zar >= 75000  THEN 'Senior'
        WHEN salary_zar >= 50000  THEN 'Mid-Level'
        ELSE                           'Junior'
    END                                              AS grade
FROM employees
WHERE is_active = 1
ORDER BY salary_zar DESC
OFFSET 0 ROWS FETCH NEXT 15 ROWS ONLY;
```

> **Expected:** Top 15 active employees with grade classification and site assignment, sorted highest to lowest salary. Riaan De Jager should appear first.

---

## Lab Completion Checklist

- [ ] Sorted by single column ASC and DESC
- [ ] Sorted by multiple columns
- [ ] Used TOP or OFFSET/FETCH to get top N rows
- [ ] Used OFFSET/FETCH for pagination
- [ ] Used alias in ORDER BY clause
- [ ] Ran the comprehensive validation query

---

*End of Practical 04 — End of Day 1*

