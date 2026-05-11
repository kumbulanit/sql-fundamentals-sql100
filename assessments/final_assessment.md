# Final Assessment — SQL100: SQL Fundamentals
### Assmang Pty Ltd Internal Training Programme

---

**Participant Name:** _________________________________  
**Department:** _________________________________  
**Date:** _________________________________  
**Trainer:** _________________________________  

---

**Total Marks:** 100  
**Pass Mark:** 70/100 (70%)  
**Duration:** 60 minutes  
**Permitted:** DBeaver + MySQL (practical sections); closed-book for theory  

---

## PART A: Theory Questions (30 marks)

### Section A1: Multiple Choice (20 marks — 2 marks each)

**1.** Which SQL command retrieves data from a database?

A) INSERT  B) SELECT  C) UPDATE  D) FETCH

---

**2.** What does a Foreign Key do?

A) Uniquely identifies each row in a table  
B) Allows NULL values in a column  
C) Links a column in one table to the Primary Key of another table  
D) Speeds up query performance  

---

**3.** Which operator correctly finds all employees hired between 2018 and 2020?

A) `WHERE hire_date = BETWEEN '2018-01-01' AND '2020-12-31'`  
B) `WHERE hire_date BETWEEN '2018-01-01' AND '2020-12-31'`  
C) `WHERE hire_date FROM '2018-01-01' TO '2020-12-31'`  
D) `WHERE hire_date >= 2018 AND hire_date <= 2020`  

---

**4.** What does `SELECT DISTINCT job_title FROM employees` return?

A) All job titles ordered alphabetically  
B) Only the first occurrence of each job title  
C) A count of unique job titles  
D) Each unique job title once, removing duplicates  

---

**5.** What does `COALESCE(mine_id, 'Head Office')` return when `mine_id = 3`?

A) 'Head Office'  
B) 3  
C) NULL  
D) An error  

---

**6.** What is the execution order of SQL clauses?

A) SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY  
B) FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY  
C) WHERE → FROM → GROUP BY → SELECT → ORDER BY  
D) FROM → SELECT → WHERE → GROUP BY → HAVING → ORDER BY  

---

**7.** Which JOIN returns all employees even if they have no department?

A) INNER JOIN  
B) RIGHT JOIN  
C) LEFT JOIN — with employees on the left  
D) CROSS JOIN  

---

**8.** What happens if you run `DELETE FROM employees;` without a WHERE clause?

A) Nothing — DELETE requires WHERE  
B) The table structure is deleted  
C) ALL rows in the employees table are deleted  
D) Only the first row is deleted  

---

**9.** Which aggregate function counts only NON-NULL values?

A) `COUNT(*)`  
B) `COUNT(DISTINCT *)`  
C) `COUNT(column_name)`  
D) `SUM()`  

---

**10.** What is a VIEW in SQL?

A) A graphical user interface for viewing tables  
B) A copy of a table stored in memory  
C) A saved SELECT query that behaves like a virtual table  
D) A table that automatically updates when data changes  

---

### Section A2: True or False (10 marks — 2 marks each)

**11.** `WHERE mine_id = NULL` correctly finds employees with no mine assignment. ________

**12.** The `HAVING` clause can use aggregate functions like `COUNT()` and `SUM()`. ________

**13.** An `INNER JOIN` includes rows from both tables even if there is no match. ________

**14.** `CREATE TABLE` is a DDL command and cannot be rolled back in MySQL. ________

**15.** `ORDER BY salary DESC LIMIT 1` returns the employee with the HIGHEST salary. ________

---

## PART B: SQL Writing (40 marks)

**Use the `assmang_training` database for all queries.**

---

**B1. (5 marks)** Write a query that shows each employee's full name (in format: SURNAME, Firstname), job title, and their annual salary (monthly × 12). Order by annual salary descending. Show only the top 10.

---

**B2. (5 marks)** Write a query that finds all employees hired in 2019 or 2020 who are assigned to mine_id 1 or mine_id 3. Show: first name, last name, hire date, mine_id.

---

**B3. (5 marks)** Write a query that shows the number of employees and total monthly payroll for EACH department. Include only departments with 3 or more employees. Order by total payroll descending.

---

**B4. (5 marks)** Write a query showing each employee's full name, their department name (not ID), and the name of their mine (or 'Head Office' if none). Use appropriate JOINs.

---

**B5. (5 marks)** Write a query that finds all employees earning more than the average salary of their own department.  
_(Hint: Use a correlated subquery or a derived table — this is a challenge question!)_

---

**B6. (5 marks)** Write an UPDATE statement to give all employees in the Safety department (department_id = 4) a 7% salary increase. Include a safety SELECT first.

---

**B7. (5 marks)** Create a new table called `performance_reviews` with the following columns:
- review_id (PK, auto-increment)
- employee_id (FK to employees)
- review_year INT
- overall_rating ENUM ('Excellent', 'Good', 'Satisfactory', 'Needs Improvement')
- reviewed_by INT (FK to employees)
- comments TEXT
- review_date DATE

---

**B8. (5 marks)** Create a view called `vw_high_earners` that shows all employees earning R80,000 or more per month. Include: employee_id, full name, job title, department name, salary.

---

## PART C: Practical Scenario (30 marks)

**Read the scenario carefully and complete all tasks.**

---

### Scenario: Annual Assmang Production & Payroll Analysis

The Assmang CFO requires an end-of-year report. Complete the following queries to support the report:

---

**C1. Equipment Asset Value by Mine (5 marks)**  
Show each mine's name, total number of equipment pieces, and total purchase investment. Sort by highest investment. Include mines with no equipment.

---

**C2. Top 3 Producing Mines by Revenue (5 marks)**  
Using `production_monthly` and `mines`, show the top 3 mines by total 2023 revenue. Show mine name, mine type, and total revenue (formatted in millions to 2 decimal places).

---

**C3. Salary Distribution Report (5 marks)**  
Count how many employees fall into each salary band:
- `Executive`: R100,000+  
- `Senior`: R75,000–R99,999  
- `Mid-Level`: R50,000–R74,999  
- `Junior`: below R50,000  

Show band name and headcount. Order from Senior to Junior.

---

**C4. Department + Mine Cross-Reference (5 marks)**  
Show a count of employees per department per mine (for mine-based employees only, i.e., mine_id IS NOT NULL). Use department names (not IDs). Order by department name, then mine_id.

---

**C5. Safety Audit Report — Long-Serving Field Staff (5 marks)**  
Find all active employees who:
- Are assigned to a mine (not Head Office)
- Have worked at Assmang for 7 or more years  

Show: full name, job title, mine name, hire date, years of service. Order by years descending.

---

**C6. Maintenance Cost Summary (5 marks)**  
From `maintenance_log`, show total maintenance cost per mine (use equipment table to link to mine). Show mine name, number of completed maintenance jobs, total cost. Order by total cost descending.

---

## ANSWER KEY — FACILITATOR COPY

### Part A Answers

| Q | Answer |
|---|--------|
| 1 | B |
| 2 | C |
| 3 | B |
| 4 | D |
| 5 | B (COALESCE returns first non-NULL; 3 is not NULL) |
| 6 | B |
| 7 | C |
| 8 | C |
| 9 | C |
| 10 | C |
| 11 | FALSE — must use IS NULL |
| 12 | TRUE |
| 13 | FALSE — INNER JOIN excludes non-matching rows |
| 14 | TRUE |
| 15 | TRUE |

### Part B Answers

**B1:**
```sql
SELECT
    CONCAT(UPPER(last_name), ', ', first_name)  AS employee,
    job_title,
    salary_zar * 12                             AS annual_salary
FROM employees
ORDER BY annual_salary DESC
LIMIT 10;
```

**B2:**
```sql
SELECT first_name, last_name, hire_date, mine_id
FROM employees
WHERE YEAR(hire_date) IN (2019, 2020)
  AND mine_id IN (1, 3);
```

**B3:**
```sql
SELECT department_id,
       COUNT(*) AS headcount,
       SUM(salary_zar) AS monthly_payroll
FROM employees
GROUP BY department_id
HAVING COUNT(*) >= 3
ORDER BY monthly_payroll DESC;
```

**B4:**
```sql
SELECT
    CONCAT(e.first_name, ' ', e.last_name)      AS full_name,
    d.department_name,
    COALESCE(m.mine_name, 'Head Office')         AS mine
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
LEFT  JOIN mines m       ON e.mine_id       = m.mine_id;
```

**B5 (Challenge):**
```sql
-- Using correlated subquery
SELECT first_name, last_name, department_id, salary_zar
FROM employees e
WHERE salary_zar > (
    SELECT AVG(salary_zar)
    FROM employees
    WHERE department_id = e.department_id
)
ORDER BY department_id, salary_zar DESC;
```

**B6:**
```sql
-- Safety check first:
SELECT COUNT(*), SUM(salary_zar), ROUND(SUM(salary_zar*1.07),2)
FROM employees WHERE department_id = 4;

-- Apply:
UPDATE employees
SET salary_zar = ROUND(salary_zar * 1.07, 2)
WHERE department_id = 4;
```

**B7:**
```sql
CREATE TABLE IF NOT EXISTS performance_reviews (
    review_id       INT     NOT NULL AUTO_INCREMENT,
    employee_id     INT     NOT NULL,
    review_year     INT     NOT NULL,
    overall_rating  ENUM('Excellent','Good','Satisfactory','Needs Improvement') NOT NULL,
    reviewed_by     INT     NOT NULL,
    comments        TEXT,
    review_date     DATE    NOT NULL,
    PRIMARY KEY (review_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (reviewed_by) REFERENCES employees(employee_id)
);
```

**B8:**
```sql
CREATE OR REPLACE VIEW vw_high_earners AS
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name)  AS full_name,
    e.job_title,
    d.department_name,
    e.salary_zar
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE e.salary_zar >= 80000;

SELECT * FROM vw_high_earners ORDER BY salary_zar DESC;
```

### Part C Answers

**C1:**
```sql
SELECT m.mine_name,
       COUNT(eq.equipment_id)               AS equipment_count,
       COALESCE(SUM(eq.purchase_price), 0)  AS total_investment
FROM mines m
LEFT JOIN equipment eq ON m.mine_id = eq.mine_id
GROUP BY m.mine_id, m.mine_name
ORDER BY total_investment DESC;
```

**C2:**
```sql
SELECT m.mine_name, m.mine_type,
       ROUND(SUM(p.revenue_zar)/1000000, 2) AS revenue_millions
FROM production_monthly p
INNER JOIN mines m ON p.mine_id = m.mine_id
WHERE p.production_year = 2023
GROUP BY m.mine_id, m.mine_name, m.mine_type
ORDER BY revenue_millions DESC
LIMIT 3;
```

**C3:**
```sql
SELECT
    CASE
        WHEN salary_zar >= 100000 THEN 'Executive'
        WHEN salary_zar >= 75000  THEN 'Senior'
        WHEN salary_zar >= 50000  THEN 'Mid-Level'
        ELSE                           'Junior'
    END AS salary_band,
    COUNT(*) AS headcount
FROM employees
GROUP BY salary_band
ORDER BY MIN(salary_zar) DESC;
```

**C4:**
```sql
SELECT d.department_name, e.mine_id, COUNT(*) AS employees
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE e.mine_id IS NOT NULL
GROUP BY d.department_name, e.mine_id
ORDER BY d.department_name, e.mine_id;
```

**C5:**
```sql
SELECT
    CONCAT(e.first_name, ' ', e.last_name)              AS employee,
    e.job_title,
    m.mine_name,
    e.hire_date,
    TIMESTAMPDIFF(YEAR, e.hire_date, CURRENT_DATE())    AS years_service
FROM employees e
INNER JOIN mines m ON e.mine_id = m.mine_id
WHERE e.is_active = 1
  AND TIMESTAMPDIFF(YEAR, e.hire_date, CURRENT_DATE()) >= 7
ORDER BY years_service DESC;
```

**C6:**
```sql
SELECT m.mine_name,
       COUNT(ml.log_id)      AS completed_jobs,
       SUM(ml.cost_zar)      AS total_cost
FROM maintenance_log ml
INNER JOIN equipment eq ON ml.equipment_id = eq.equipment_id
INNER JOIN mines m       ON eq.mine_id     = m.mine_id
WHERE ml.completed = 1
GROUP BY m.mine_id, m.mine_name
ORDER BY total_cost DESC;
```

---

## Scoring Guide

| Range | Grade | Certificate Level |
|-------|-------|-------------------|
| 90–100 | Distinction | SQL100 with Distinction |
| 80–89 | Merit | SQL100 Pass |
| 70–79 | Pass | SQL100 Pass |
| 60–69 | Refer | Reassessment required |
| Below 60 | Fail | Repeat course recommended |

---

## Post-Course Next Steps

✅ **Recommended SQL200 topics to explore next:**
- Common Table Expressions (WITH clause)
- Window Functions (ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD)
- Stored Procedures and Functions
- Advanced query optimisation with EXPLAIN

---

*Final Assessment — Assmang Pty Ltd SQL100 — 2-Day SQL Fundamentals Programme*  
*NobleProg SQL100 Curriculum | Delivered for Assmang Pty Ltd*

