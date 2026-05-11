# Practical Lab — Day 2 Topic 02: JOINs & Subqueries
## Assmang Pty Ltd SQL100 Training

**Duration:** 90 minutes | **Dataset:** v2_assmang_setup.sql

```sql
USE assmang_training;
```

---

## Part A: INNER JOIN (20 minutes)

### A1 — Employees with department names (no department IDs)
```sql
SELECT
    e.first_name,
    e.last_name,
    e.job_title,
    e.salary_zar,
    d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_name, e.last_name;
```
> **✅ Expected:** 31 rows — every employee with their department name shown

### A2 — Field employees with mine names
```sql
SELECT
    e.first_name,
    e.last_name,
    e.job_title,
    m.mine_name,
    m.mine_type,
    m.province
FROM employees e
INNER JOIN mines m ON e.mine_id = m.mine_id
ORDER BY m.mine_name, e.last_name;
```
> **✅ Expected:** 18 rows (only mine-based employees; Head Office excluded by INNER JOIN)

### A3 — Equipment with mine names
```sql
SELECT
    eq.equipment_code,
    eq.equipment_type,
    eq.manufacturer,
    eq.model,
    eq.status,
    m.mine_name
FROM equipment eq
INNER JOIN mines m ON eq.mine_id = m.mine_id
ORDER BY m.mine_name, eq.equipment_type;
```

### A4 — Production data with mine names (2023 summary)
```sql
SELECT
    m.mine_name,
    m.mine_type,
    SUM(p.tonnes_mined)                 AS total_tonnes,
    ROUND(AVG(p.ore_grade_pct), 2)      AS avg_grade,
    SUM(p.revenue_zar)                  AS total_revenue
FROM production_monthly p
INNER JOIN mines m ON p.mine_id = m.mine_id
WHERE p.production_year = 2023
GROUP BY m.mine_name, m.mine_type
ORDER BY total_revenue DESC;
```
> **Question:** Which mine type generates the most revenue per tonne?

---

## Part B: LEFT JOIN (20 minutes)

### B1 — All employees including Head Office (with mine or 'Head Office')
```sql
SELECT
    CONCAT(e.first_name, ' ', e.last_name)      AS employee,
    e.job_title,
    COALESCE(m.mine_name, 'Head Office')         AS location,
    COALESCE(m.mine_type, 'N/A')                AS mine_type
FROM employees e
LEFT JOIN mines m ON e.mine_id = m.mine_id
ORDER BY location, e.last_name;
```
> **✅ Expected:** All 31 employees — Head Office shows for non-mine staff

### B2 — Find Head Office employees using LEFT JOIN
```sql
SELECT
    e.first_name,
    e.last_name,
    e.job_title,
    e.department_id
FROM employees e
LEFT JOIN mines m ON e.mine_id = m.mine_id
WHERE m.mine_id IS NULL
ORDER BY e.department_id;
```
> **✅ Expected:** 13 Head Office employees

### B3 — All mines including those with no employees
```sql
SELECT
    m.mine_name,
    m.mine_type,
    m.operational,
    COUNT(e.employee_id)    AS assigned_employees
FROM mines m
LEFT JOIN employees e ON m.mine_id = e.mine_id
GROUP BY m.mine_id, m.mine_name, m.mine_type, m.operational
ORDER BY assigned_employees DESC;
```
> **Note:** Gloria Mine and Machadodorp Works should show 0 employees

---

## Part C: Three-Table JOIN (20 minutes)

### C1 — Full employee profile: name + department + mine
```sql
SELECT
    CONCAT(e.first_name, ' ', e.last_name)      AS employee,
    e.job_title,
    e.salary_zar,
    d.department_name,
    d.location                                   AS dept_location,
    COALESCE(m.mine_name, 'Head Office')         AS mine_site
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
LEFT  JOIN mines m       ON e.mine_id       = m.mine_id
ORDER BY d.department_name, e.last_name;
```

### C2 — Payroll report by department name (not ID)
```sql
SELECT
    d.department_name,
    d.location,
    COUNT(e.employee_id)                AS headcount,
    SUM(e.salary_zar)                   AS monthly_payroll,
    ROUND(AVG(e.salary_zar), 2)         AS avg_salary
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name, d.location
ORDER BY monthly_payroll DESC;
```

---

## Part D: Self JOIN (10 minutes)

### D1 — Employee + their manager's name
```sql
SELECT
    CONCAT(e.first_name, ' ', e.last_name)  AS employee,
    e.job_title,
    CONCAT(m.first_name, ' ', m.last_name)  AS manager_name,
    m.job_title                             AS manager_title
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id
ORDER BY manager_name, e.last_name;
```
> **Note:** Top-level employees (no manager) will show NULL for manager fields

---

## Part E: Subqueries (20 minutes)

### E1 — Employees earning above company average
```sql
SELECT first_name, last_name, salary_zar
FROM employees
WHERE salary_zar > (SELECT AVG(salary_zar) FROM employees)
ORDER BY salary_zar DESC;
```
> **Question:** What is the company average? (Run the subquery separately to check)

### E2 — Find employees in Johannesburg-based departments (using subquery)
```sql
SELECT first_name, last_name, job_title, department_id
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE location LIKE '%Johannesburg%'
);
```
> **✅ Expected:** Finance and IT employees

### E3 — Mines that have NO production data loaded
```sql
SELECT mine_name, mine_type, province
FROM mines
WHERE mine_id NOT IN (
    SELECT DISTINCT mine_id FROM production_monthly
);
```
> **✅ Expected:** Gloria Mine, Machadodorp Works

### E4 — Salary comparison vs company average (scalar subquery in SELECT)
```sql
SELECT
    CONCAT(first_name, ' ', last_name)                          AS employee,
    salary_zar,
    (SELECT ROUND(AVG(salary_zar), 2) FROM employees)           AS company_avg,
    ROUND(salary_zar - (SELECT AVG(salary_zar) FROM employees), 2) AS diff
FROM employees
ORDER BY diff DESC;
```

### E5 — EXISTS: Find mines that HAVE production records
```sql
SELECT mine_name, mine_type
FROM mines m
WHERE EXISTS (
    SELECT 1 FROM production_monthly p
    WHERE p.mine_id = m.mine_id
);
```
> **✅ Expected:** 4 mines (Beeshoek, Khumani, Black Rock, Dwarsrivier)

---

## ✅ Comprehensive Validation

```sql
-- Full employee directory: name, department, mine, manager, salary relative to avg
SELECT
    CONCAT(e.first_name, ' ', e.last_name)                      AS employee,
    d.department_name                                            AS department,
    COALESCE(m.mine_name, 'Head Office')                        AS site,
    COALESCE(CONCAT(mgr.first_name,' ',mgr.last_name), 'Director') AS reports_to,
    e.salary_zar,
    CASE
        WHEN e.salary_zar > (SELECT AVG(salary_zar) FROM employees) THEN 'Above Avg'
        ELSE 'Below Avg'
    END                                                          AS vs_avg
FROM employees e
INNER JOIN departments d  ON e.department_id = d.department_id
LEFT  JOIN mines m        ON e.mine_id       = m.mine_id
LEFT  JOIN employees mgr  ON e.manager_id    = mgr.employee_id
ORDER BY d.department_name, e.salary_zar DESC;
```

---

## Lab Completion Checklist

- [ ] INNER JOIN: employees + departments (A1, A2)
- [ ] INNER JOIN with GROUP BY and aggregation (A4)
- [ ] LEFT JOIN: all employees including Head Office (B1)
- [ ] LEFT JOIN: find unmatched rows (B2, B3)
- [ ] Three-table JOIN: employees + departments + mines (C1)
- [ ] Self JOIN: employee + manager (D1)
- [ ] Subquery in WHERE (E1, E2)
- [ ] Subquery with IN (E3)
- [ ] Scalar subquery in SELECT (E4)
- [ ] EXISTS subquery (E5)

---

*End of Practical — Day 2 Topic 02*

