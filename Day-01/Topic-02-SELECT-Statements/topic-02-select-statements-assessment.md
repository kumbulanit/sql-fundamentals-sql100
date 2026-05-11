# Assessment — Topic 02: SELECT Statements & Functions
## Assmang Pty Ltd SQL100 Training | Day 1

**Time allowed:** 25 minutes  
**Total marks:** 35  
**Pass mark:** 24/35 (69%)

---

## Section 1: Multiple Choice (15 marks — 3 marks each)

**Q1.** What does the `DISTINCT` keyword do in a SELECT statement?

A) Sorts results in alphabetical order  
B) Removes duplicate rows from the result set  
C) Counts the number of unique values  
D) Filters rows based on a condition  

---

**Q2.** What is the output of the following SQL expression?
```sql
SELECT CONCAT(UPPER('beeshoek'), ' ', 'Mine');
```

A) `beeshoek Mine`  
B) `BEESHOEK Mine`  
C) `BEESHOEK MINE`  
D) `beeshoek mine`  

---

**Q3.** An Assmang payroll analyst needs to display each employee's annual salary. The monthly salary is stored in `salary_zar`. Which expression is correct?

A) `salary_zar + 12`  
B) `salary_zar * 12`  
C) `ANNUAL(salary_zar)`  
D) `salary_zar / 12`  

---

**Q4.** Which function returns today's date only (no time component) in SQL Server?

A) `GETDATE()`  
B) `GETDATE()`  
C) `CAST(GETDATE() AS date)`  
D) `TODAY()`  

---

**Q5.** What does `COALESCE(mine_id, 'Head Office')` return when `mine_id` is NULL?

A) `NULL`  
B) `0`  
C) `'Head Office'`  
D) An error  

---

## Section 2: Write the Query (15 marks — 5 marks each)

**Q6.** Write a SQL query that retrieves the `mine_name` and `established_year` columns from the `mines` table. Rename the columns as `"Mine"` and `"Year Established"` in the output. _(5 marks)_

**Q7.** Write a SQL query to show each employee's full name (LAST NAME in uppercase, followed by a comma and space, followed by first name in proper case) and their job title. Name the full name column `"Employee Name"`. _(5 marks)_  
_Example output: `DLAMINI, Nomsa | HR Manager`_

**Q8.** Write a SQL query that classifies each department into a budget tier using CASE WHEN:
- Budget ≥ R30,000,000 → `'Tier 1'`
- Budget ≥ R10,000,000 → `'Tier 2'`
- Below R10,000,000 → `'Tier 3'`

Show: `department_name`, `budget_zar`, and `budget_tier`. Order by budget descending. _(5 marks)_

---

## Section 3: Identify the Error (5 marks)

**Q9.** The following query has errors. Identify and fix ALL errors. _(5 marks)_

```sql
select firstname + ' ' + lastname AS Full Name,
salary * 12 AS annual salary
from Employee;
```

_List each error and the corrected query._

---

## ✅ ANSWER KEY

### Section 1

| Q | Answer | Explanation |
|---|--------|-------------|
| Q1 | **B** | DISTINCT removes duplicate rows from result set |
| Q2 | **B** | UPPER('beeshoek') → 'BEESHOEK'; ' Mine' remains unchanged |
| Q3 | **B** | Annual = monthly × 12 |
| Q4 | **C** | `CAST(GETDATE() AS date)` returns date only; `GETDATE()` includes time |
| Q5 | **C** | COALESCE returns first non-NULL; mine_id is NULL so returns 'Head Office' |

### Section 2

**Q6 (5 marks):**
```sql
SELECT
    mine_name       AS "Mine",
    established_year AS "Year Established"
FROM mines;
```
Mark allocation: SELECT correct (1), aliases correct (2), FROM mines (1), semicolon (1)

**Q7 (5 marks):**
```sql
SELECT
    CONCAT(UPPER(last_name), ', ', first_name)  AS "Employee Name",
    job_title
FROM employees;
```
Mark allocation: CONCAT (1), UPPER(last_name) (1), first_name proper (1), alias (1), FROM employees (1)

**Q8 (5 marks):**
```sql
SELECT
    department_name,
    budget_zar,
    CASE
        WHEN budget_zar >= 30000000 THEN 'Tier 1'
        WHEN budget_zar >= 10000000 THEN 'Tier 2'
        ELSE                             'Tier 3'
    END AS budget_tier
FROM departments
ORDER BY budget_zar DESC;
```
Mark allocation: SELECT cols (1), CASE structure (2), ELSE (1), ORDER BY (1)

### Section 3

**Q9 (5 marks) — Errors:**

| # | Error | Fix |
|---|-------|-----|
| 1 | `firstname` — column name is `first_name` (with underscore) | `first_name` |
| 2 | `+` operator for string concatenation (not valid in MySQL) | Use `CONCAT()` |
| 3 | `AS Full Name` — alias with space must be quoted | `AS "Full Name"` |
| 4 | `salary` — column name is `salary_zar` | `salary_zar` |
| 5 | `AS annual salary` — alias with space must be quoted; also `Employee` wrong table name | `AS "annual salary"` ; `FROM employees` |

**Corrected Query:**
```sql
SELECT
    CONCAT(first_name, ' ', last_name) AS "Full Name",
    salary_zar * 12                    AS "Annual Salary"
FROM employees;
```

---

### Scoring Guide

| Score | Grade |
|-------|-------|
| 32–35 | Distinction |
| 28–31 | Merit |
| 24–27 | Pass |
| Below 24 | Refer |

---

*Assessment 02 — Assmang Pty Ltd SQL100 Training Programme*

