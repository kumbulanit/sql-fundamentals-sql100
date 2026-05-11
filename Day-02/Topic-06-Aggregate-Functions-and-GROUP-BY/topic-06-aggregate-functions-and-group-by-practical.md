# Practical Lab — Day 2, Topic 01: Aggregation & GROUP BY
## Assmang Pty Ltd SQL100 Training

**Duration:** 60 minutes | **Dataset:** v2_assmang_setup.sql

```sql
USE assmang_training;
```

---

## Part A: Basic Aggregates (15 minutes)

### A1 — Total employee count and payroll summary
```sql
SELECT
    COUNT(*)                            AS total_employees,
    ROUND(AVG(salary_zar), 2)           AS avg_monthly_salary,
    MIN(salary_zar)                     AS lowest_salary,
    MAX(salary_zar)                     AS highest_salary,
    SUM(salary_zar)                     AS total_monthly_payroll
FROM employees;
```
> **✅ Expected:** 31 employees, total payroll around R2.05M/month

### A2 — Count employees assigned to a mine vs Head Office
```sql
SELECT
    COUNT(*)        AS total,
    COUNT(mine_id)  AS assigned_to_mine,
    COUNT(*) - COUNT(mine_id) AS head_office
FROM employees;
```
> **✅ Expected:** 31 total, 18 mine-based, 13 head office

### A3 — Total and average equipment value
```sql
SELECT
    COUNT(*)                            AS equipment_count,
    SUM(purchase_price)                 AS total_asset_value,
    ROUND(AVG(purchase_price), 2)       AS avg_price,
    MIN(purchase_price)                 AS cheapest,
    MAX(purchase_price)                 AS most_expensive
FROM equipment;
```

### A4 — Annual production totals across all mines (2023)
```sql
SELECT
    SUM(tonnes_mined)                   AS total_tonnes_mined,
    SUM(tonnes_processed)               AS total_tonnes_processed,
    ROUND(AVG(ore_grade_pct), 2)        AS overall_avg_grade,
    SUM(revenue_zar)                    AS total_revenue_2023
FROM production_monthly
WHERE production_year = 2023;
```

---

## Part B: GROUP BY — One Column (15 minutes)

### B1 — Headcount and payroll by department
```sql
SELECT
    department_id,
    COUNT(*)                            AS headcount,
    ROUND(AVG(salary_zar), 2)           AS avg_salary,
    SUM(salary_zar)                     AS dept_payroll
FROM employees
GROUP BY department_id
ORDER BY dept_payroll DESC;
```
> **Question:** Which department has the highest payroll?

### B2 — Equipment count by mine
```sql
SELECT
    mine_id,
    COUNT(*)                            AS equipment_count,
    SUM(purchase_price)                 AS total_investment
FROM equipment
GROUP BY mine_id
ORDER BY total_investment DESC;
```

### B3 — Equipment count by status
```sql
SELECT
    status,
    COUNT(*)                            AS count,
    ROUND(AVG(purchase_price), 2)       AS avg_value
FROM equipment
GROUP BY status
ORDER BY count DESC;
```
> **✅ Expected:** Active, Maintenance, Retired groups

### B4 — Production by mine (2023)
```sql
SELECT
    mine_id,
    SUM(tonnes_mined)                   AS annual_total_tonnes,
    ROUND(AVG(ore_grade_pct), 2)        AS avg_grade,
    SUM(revenue_zar)                    AS total_revenue
FROM production_monthly
WHERE production_year = 2023
GROUP BY mine_id
ORDER BY total_revenue DESC;
```
> **Question:** Which mine generates the most revenue?

---

## Part C: GROUP BY with HAVING (15 minutes)

### C1 — Departments with 3 or more employees
```sql
SELECT
    department_id,
    COUNT(*)    AS headcount
FROM employees
GROUP BY department_id
HAVING COUNT(*) >= 3
ORDER BY headcount DESC;
```

### C2 — Departments with average salary above R60,000
```sql
SELECT
    department_id,
    ROUND(AVG(salary_zar), 2)   AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary_zar) > 60000
ORDER BY avg_salary DESC;
```

### C3 — Mines with total annual revenue above R1 billion
```sql
SELECT
    mine_id,
    SUM(revenue_zar)            AS total_revenue
FROM production_monthly
WHERE production_year = 2023
GROUP BY mine_id
HAVING SUM(revenue_zar) > 1000000000
ORDER BY total_revenue DESC;
```
> **✅ Expected:** Khumani Mine (mine_id=2) — Iron Ore giant

### C4 — Equipment types with more than 2 pieces
```sql
SELECT
    equipment_type,
    COUNT(*)    AS quantity,
    SUM(purchase_price) AS total_value
FROM equipment
GROUP BY equipment_type
HAVING COUNT(*) > 2
ORDER BY quantity DESC;
```

---

## Part D: WHERE + GROUP BY + HAVING Combined (10 minutes)

### D1 — Active employee payroll by department (departments with payroll > R200,000)
```sql
SELECT
    department_id,
    COUNT(*)                            AS active_headcount,
    SUM(salary_zar)                     AS monthly_payroll
FROM employees
WHERE is_active = 1
GROUP BY department_id
HAVING SUM(salary_zar) > 200000
ORDER BY monthly_payroll DESC;
```

### D2 — Production months where Khumani Mine exceeded 440,000 tonnes
```sql
SELECT
    mine_id,
    production_month,
    tonnes_mined
FROM production_monthly
WHERE mine_id = 2
  AND production_year = 2023
  AND tonnes_mined > 440000
ORDER BY tonnes_mined DESC;
```

### D3 — Mines with more than 3 pieces of Active equipment
```sql
SELECT
    mine_id,
    COUNT(*)    AS active_equipment_count
FROM equipment
WHERE status = 'Active'
GROUP BY mine_id
HAVING COUNT(*) > 3
ORDER BY active_equipment_count DESC;
```

---

## ✅ Comprehensive Validation

```sql
-- Department payroll summary — full business report
SELECT
    d.department_id,
    COUNT(e.employee_id)                AS headcount,
    SUM(e.salary_zar)                   AS monthly_payroll,
    ROUND(AVG(e.salary_zar), 2)         AS avg_salary,
    MIN(e.salary_zar)                   AS min_salary,
    MAX(e.salary_zar)                   AS max_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.is_active = 1
GROUP BY d.department_id
HAVING COUNT(e.employee_id) >= 3
ORDER BY monthly_payroll DESC;
```

> Note: This query uses JOIN (Day 2 Topic 2) — it's a preview. If you haven't learned JOINs yet, the simpler version without the JOIN is fine.

---

## Lab Completion Checklist

- [ ] Ran 5 basic aggregate functions (COUNT, SUM, AVG, MIN, MAX)
- [ ] Used GROUP BY with single column
- [ ] Used GROUP BY with multiple columns (B4)
- [ ] Applied HAVING to filter groups
- [ ] Combined WHERE + GROUP BY + HAVING
- [ ] Ran the comprehensive validation query

---

*End of Practical — Day 2 Topic 01*

