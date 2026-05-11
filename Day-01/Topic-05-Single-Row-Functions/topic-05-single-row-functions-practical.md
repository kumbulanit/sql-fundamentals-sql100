# Practical Lab 02 — SELECT Statements & Single-Row Functions
## Day 1, Topic 02 | Assmang Pty Ltd SQL100 Training

**Duration:** 60 minutes  
**Dataset:** v1_assmang_setup.sql  
**Tool:** DBeaver + SQL Server

---

## Setup Check

```sql
USE assmang_training;
SELECT COUNT(*) FROM employees;  -- Expected: 31
```

---

## Part A: Basic SELECT & Aliases (15 minutes)

### A1 — Retrieve specific columns from employees
```sql
SELECT first_name, last_name, job_title, salary_zar
FROM employees;
```
> Count the columns in the output. Should be exactly 4.

### A2 — Rename columns with aliases
```sql
SELECT
    first_name  AS "First Name",
    last_name   AS Surname,
    job_title   AS "Job Title",
    salary_zar  AS "Monthly Salary (R)"
FROM employees;
```

### A3 — Display mine information professionally
```sql
SELECT
    mine_name       AS "Mine Name",
    mine_type       AS "Commodity",
    province        AS "Province",
    established_year AS "Est. Year"
FROM mines;
```

### A4 — Find unique job titles at Assmang
```sql
SELECT DISTINCT job_title AS "Unique Job Titles"
FROM employees
ORDER BY job_title;
```
> **Question:** How many unique job titles are there? (Count the rows)

### A5 — Find unique mine types
```sql
SELECT DISTINCT mine_type AS "Mine Types"
FROM mines;
```
> **Expected:** 3 rows — Iron Ore, Manganese, Chrome

---

## Part B: Arithmetic Expressions (10 minutes)

### B1 — Calculate annual salaries
```sql
SELECT
    CONCAT(first_name, ' ', last_name)  AS employee,
    salary_zar                          AS monthly_salary,
    salary_zar * 12                     AS annual_salary,
    ROUND(salary_zar * 12 * 0.72, 2)   AS after_tax_annual  -- approx 28% tax
FROM employees;
```

### B2 — Calculate daily rate (based on 22 working days)
```sql
SELECT
    first_name,
    last_name,
    salary_zar,
    ROUND(salary_zar / 22, 2)   AS daily_rate_zar
FROM employees
ORDER BY salary_zar DESC;
```
> **✅ Validation:** Riaan De Jager (Finance Director, R150,000) should have the highest daily rate of ~R6,818.18

### B3 — Department budget in millions
```sql
SELECT
    department_name             AS department,
    budget_zar                  AS total_budget,
    ROUND(budget_zar / 1000000, 2)  AS budget_millions
FROM departments
ORDER BY budget_zar DESC;
```
> **Question:** Which department has the largest budget?

---

## Part C: String Functions (15 minutes)

### C1 — Standardise name display
```sql
SELECT
    UPPER(last_name)                AS surname_caps,
    CONCAT(
        UPPER(LEFT(first_name, 1)),
        LOWER(SUBSTRING(first_name, 2))
    )                               AS first_name_proper
FROM employees;
```

### C2 — Extract username from email
```sql
SELECT
    email,
    REPLACE(email, '@assmang.co.za', '') AS username
FROM employees;
```

### C3 — Count characters in job titles
```sql
SELECT
    job_title,
    LENGTH(job_title)   AS title_char_count
FROM employees
ORDER BY LENGTH(job_title) DESC;
```
> **Question:** Which job title is longest (most characters)?

### C4 — Create a formatted employee ID card line
```sql
SELECT
    CONCAT(
        UPPER(last_name), ', ',
        first_name,
        ' | ', job_title,
        ' | Assmang Pty Ltd'
    ) AS id_card_line
FROM employees;
```

### C5 — Find the first 3 characters of each mine name
```sql
SELECT
    mine_name,
    LEFT(mine_name, 3)  AS short_code
FROM mines;
```

---

## Part D: Date Functions (10 minutes)

### D1 — Calculate years of service for all employees
```sql
SELECT
    CONCAT(first_name, ' ', last_name)              AS employee,
    hire_date,
    DATEDIFF(YEAR, hire_date, GETDATE())            AS years_service,
    DATEDIFF(MONTH, hire_date, GETDATE())           AS months_service
FROM employees
ORDER BY hire_date ASC;
```
> **Question:** Who is the longest-serving employee at Assmang?

### D2 — Format hire dates
```sql
SELECT
    first_name,
    last_name,
    FORMAT(hire_date, 'dd MMMM yyyy')   AS hire_date_formatted
FROM employees
ORDER BY hire_date
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
```

### D3 — When does probation end? (3 months after hire)
```sql
SELECT
    CONCAT(first_name, ' ', last_name)              AS employee,
    hire_date,
    DATEADD(MONTH, 3, hire_date)                    AS probation_end_date
FROM employees
WHERE YEAR(hire_date) >= 2021;
```

---

## Part E: CASE WHEN & NULL Handling (10 minutes)

### E1 — Classify employees by salary band
```sql
SELECT
    CONCAT(first_name, ' ', last_name)  AS employee,
    job_title,
    salary_zar,
    CASE
        WHEN salary_zar >= 100000 THEN 'Executive'
        WHEN salary_zar >= 75000  THEN 'Senior'
        WHEN salary_zar >= 50000  THEN 'Mid-Level'
        ELSE                           'Junior'
    END                                 AS salary_band
FROM employees
ORDER BY salary_zar DESC;
```

### E2 — Replace NULL mine with "Head Office"
```sql
SELECT
    CONCAT(first_name, ' ', last_name)  AS employee,
    CASE
        WHEN mine_id IS NULL THEN 'Head Office'
        ELSE CONCAT('Mine ID: ', mine_id)
    END                                 AS work_location
FROM employees;
```

### E3 — Mark operational status of mines
```sql
SELECT
    mine_name,
    mine_type,
    CASE operational
        WHEN 1 THEN '✅ Operational'
        WHEN 0 THEN '❌ Non-Operational'
    END AS current_status
FROM mines;
```

### E4 — COALESCE for safe NULL display
```sql
SELECT
    first_name,
    last_name,
    COALESCE(CAST(mine_id AS VARCHAR(10)), 'Head Office')  AS site
FROM employees;
```

---

## ✅ Validation Summary

After completing all parts, run this comprehensive query:

```sql
SELECT
    CONCAT(UPPER(last_name), ', ', first_name)  AS employee_name,
    job_title,
    salary_zar                                  AS monthly_salary,
    ROUND(salary_zar * 12, 2)                   AS annual_salary,
    DATEDIFF(YEAR, hire_date, GETDATE())        AS years_service,
    CASE
        WHEN salary_zar >= 100000 THEN 'Executive'
        WHEN salary_zar >= 75000  THEN 'Senior'
        WHEN salary_zar >= 50000  THEN 'Mid-Level'
        ELSE                           'Junior'
    END                                         AS grade,
    COALESCE(CAST(mine_id AS VARCHAR(10)), 'HO') AS site
FROM employees
ORDER BY salary_zar DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
```

> **Expected:** Top 10 highest-paid employees with salary band, years of service, and site assignment. Riaan De Jager (R150,000/month) should be first.

---

## Lab Completion Checklist

- [ ] Successfully selected specific columns with aliases
- [ ] Used DISTINCT to find unique job titles
- [ ] Calculated annual salary using arithmetic
- [ ] Extracted username from email using REPLACE
- [ ] Calculated years of service using DATEDIFF
- [ ] Applied CASE WHEN for salary band classification
- [ ] Used COALESCE to handle NULL mine_id values
- [ ] Ran the comprehensive validation query at the bottom

---

*End of Practical 02*

