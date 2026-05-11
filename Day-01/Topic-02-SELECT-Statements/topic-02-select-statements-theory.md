# Topic 02 — SELECT Statements & Single-Row Functions
## Day 1 | Assmang Pty Ltd SQL100 Training

---

## 🎯 Learning Objectives

By the end of this topic, participants will be able to:
1. Write basic SELECT statements to retrieve specific columns
2. Use `SELECT *` and column aliases (`AS`)
3. Use `DISTINCT` to remove duplicates
4. Write arithmetic expressions in SQL
5. Use string, numeric, date, and conditional functions
6. Handle NULL values with `COALESCE` and `NULLIF`

---

## 1. Basic SELECT Syntax

The `SELECT` statement is the foundation of all data retrieval in SQL.

```
SELECT  column1, column2, ...
FROM    table_name;
```

### Components

| Clause | Purpose | Mandatory? |
|--------|---------|-----------|
| `SELECT` | Specifies WHAT columns to retrieve | ✅ Yes |
| `FROM` | Specifies WHICH table to query | ✅ Yes (for table data) |
| `;` | Terminates the statement | ✅ Best practice |

### Examples

```sql
-- Select all columns
SELECT * FROM employees;

-- Select specific columns only
SELECT first_name, last_name, job_title FROM employees;

-- Select from departments
SELECT department_name, location FROM departments;

-- Select from mines
SELECT mine_name, mine_type, province FROM mines;
```

> **Best Practice:** Avoid `SELECT *` in production code — always name the columns you need. It's fine for exploration/learning.

---

## 2. Column Aliases (AS)

Aliases rename a column in the output — they do NOT change the actual column name in the table.

```sql
-- Without alias
SELECT salary_zar FROM employees;
-- Column heading: salary_zar

-- With alias
SELECT salary_zar AS "Monthly Salary (ZAR)" FROM employees;
-- Column heading: Monthly Salary (ZAR)

-- Alias without AS keyword (also works, but AS is more readable)
SELECT salary_zar "Monthly Salary" FROM employees;

-- Alias with no spaces (no quotes needed)
SELECT salary_zar AS monthly_salary FROM employees;
```

### Practical Example — Assmang Employee Report
```sql
SELECT
    first_name      AS "First Name",
    last_name       AS "Surname",
    job_title       AS "Position",
    salary_zar      AS "Salary (ZAR)"
FROM employees;
```

---

## 3. Selecting Distinct Values

`DISTINCT` removes duplicate values from results.

```sql
-- Without DISTINCT — shows all rows (some job titles appear multiple times)
SELECT job_title FROM employees;

-- With DISTINCT — shows each job title only once
SELECT DISTINCT job_title FROM employees;

-- DISTINCT on mine type
SELECT DISTINCT mine_type FROM mines;
-- Returns: Iron Ore, Manganese, Chrome (3 unique values)

-- DISTINCT on province
SELECT DISTINCT province FROM mines;
-- Returns: Northern Cape, Limpopo, Mpumalanga

-- DISTINCT on multiple columns
SELECT DISTINCT department_id, job_title FROM employees;
-- Returns each unique COMBINATION of department + job title
```

---

## 4. Arithmetic Expressions in SELECT

SQL can perform math directly in the SELECT clause:

```sql
-- Calculate annual salary from monthly
SELECT
    first_name,
    last_name,
    salary_zar                          AS monthly_salary,
    salary_zar * 12                     AS annual_salary,
    salary_zar * 12 * 0.80             AS annual_after_tax  -- rough 20% tax estimate
FROM employees;

-- Calculate department budget per employee (needs subquery — preview)
SELECT
    budget_zar,
    budget_zar / 1000000               AS budget_millions
FROM departments;
```

**Arithmetic Operators:**

| Operator | Meaning | Example |
|----------|---------|---------|
| `+` | Addition | `salary_zar + 5000` |
| `-` | Subtraction | `budget_zar - 1000000` |
| `*` | Multiplication | `salary_zar * 12` |
| `/` | Division | `budget_zar / 12` |
| `%` or `MOD()` | Modulus (remainder) | `11 % 3` → 2 |

> **Operator Precedence:** Multiplication and division before addition and subtraction. Use parentheses to control order: `(salary_zar + 2000) * 12` ≠ `salary_zar + 2000 * 12`

---

## 5. String Concatenation

Combine text columns using `CONCAT()` (supported in SQL Server):

```sql
-- Combine first and last name
SELECT
    CONCAT(first_name, ' ', last_name)          AS full_name,
    job_title
FROM employees;

-- Build email-style format
SELECT
    CONCAT(first_name, ' ', last_name, ' <', email, '>')  AS email_display
FROM employees;

-- Mine name with type
SELECT
    CONCAT(mine_name, ' (', mine_type, ')')     AS mine_display
FROM mines;
```

---

## 6. Introduction to NULL Values

**NULL** means "unknown" or "no value" — it is NOT zero, NOT an empty string.

```sql
-- Find employees with no mine assignment (Head Office staff)
SELECT first_name, last_name, mine_id
FROM employees
WHERE mine_id IS NULL;

-- Arithmetic with NULL always returns NULL
SELECT 50000 + NULL;   -- Returns: NULL (not 50000)
```

> **Key Rule:** NULL ≠ anything. You cannot compare with `= NULL`. Always use `IS NULL` or `IS NOT NULL`.

---

## 7. String Functions

```sql
-- UPPER — convert to uppercase
SELECT UPPER(first_name) AS first_name_upper FROM employees;

-- LOWER — convert to lowercase
SELECT LOWER(email) AS email_lower FROM employees;

-- LENGTH — count characters
SELECT first_name, LENGTH(first_name) AS name_length FROM employees;

-- TRIM — remove leading/trailing spaces
SELECT TRIM('  Assmang  ') AS trimmed;  -- Returns: 'Assmang'

-- LTRIM / RTRIM — left/right trim only
SELECT LTRIM('  Beeshoek') AS left_trimmed;

-- SUBSTRING (SUBSTR) — extract part of a string
SELECT
    email,
    SUBSTRING(email, 1, 3)  AS initials   -- first 3 chars
FROM employees;

-- REPLACE — replace part of a string
SELECT REPLACE(email, '@assmang.co.za', '') AS username FROM employees;

-- LEFT / RIGHT — extract from left or right
SELECT
    LEFT(mine_name, 5)  AS first_5_chars,
    RIGHT(mine_name, 4) AS last_4_chars
FROM mines;

-- Full Example
SELECT
    CONCAT(UPPER(LEFT(first_name, 1)), '.', UPPER(LEFT(last_name, 1)), '.') AS initials,
    UPPER(last_name)    AS surname,
    LENGTH(job_title)   AS title_length
FROM employees;
```

---

## 8. Numeric Functions

```sql
-- ROUND — round to decimal places
SELECT
    salary_zar,
    ROUND(salary_zar / 22, 2)  AS daily_rate  -- approx 22 working days/month
FROM employees;

-- FLOOR — round down to nearest integer
SELECT FLOOR(75000.90);   -- Returns: 75000

-- CEIL / CEILING — round up to nearest integer
SELECT CEIL(75000.10);    -- Returns: 75001

-- ABS — absolute value
SELECT ABS(-5000);        -- Returns: 5000

-- MOD — modulus (remainder)
SELECT MOD(employee_id, 2) AS is_even  -- 0=even, 1=odd
FROM employees;

-- POWER — raise to a power
SELECT POWER(2, 10);      -- Returns: 1024

-- Practical example
SELECT
    department_name,
    budget_zar,
    ROUND(budget_zar / 1000000, 2)  AS budget_millions,
    FLOOR(budget_zar / 100000)      AS budget_100k_units
FROM departments;
```

---

## 9. Date & Time Functions

```sql
-- Current date and time
SELECT GETDATE()        AS current_datetime;
SELECT CAST(GETDATE() AS date)   AS today;
SELECT CURRENT_TIME()   AS right_now;

-- Extract parts of a date
SELECT
    hire_date,
    YEAR(hire_date)     AS hire_year,
    MONTH(hire_date)    AS hire_month,
    DAY(hire_date)      AS hire_day,
    DAYNAME(hire_date)  AS day_of_week
FROM employees;

-- Calculate years of service
SELECT
    first_name,
    last_name,
    hire_date,
    DATEDIFF(YEAR, hire_date, GETDATE()) AS years_service
FROM employees;

-- Date arithmetic
SELECT
    hire_date,
    DATEADD(YEAR, 1, hire_date)             AS first_anniversary,
    DATEADD(MONTH, 3, hire_date)            AS probation_end,
    DATEDIFF(DAY, hire_date, GETDATE())     AS days_employed
FROM employees
ORDER BY hire_date
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

-- Format dates
SELECT
    FORMAT(hire_date, 'dd MMMM yyyy')       AS formatted_date
FROM employees
ORDER BY hire_date
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
-- Output example: 01 March 2015
```

---

## 10. Conversion Functions

```sql
-- CAST — convert data types
SELECT CAST(salary_zar AS UNSIGNED)  AS salary_no_decimals
FROM employees;

SELECT CAST('2024-01-15' AS DATE)    AS converted_date;

SELECT CAST(75000.75 AS CHAR)        AS salary_as_text;

-- CONVERT (SQL Server syntax)
SELECT CONVERT(INT, salary_zar) AS salary_int
FROM employees;
```

---

## 11. CASE WHEN — Conditional Logic

`CASE WHEN` is SQL's equivalent of IF/ELSE:

```sql
-- Salary band classification
SELECT
    first_name,
    last_name,
    salary_zar,
    CASE
        WHEN salary_zar >= 100000 THEN 'Executive'
        WHEN salary_zar >= 75000  THEN 'Senior'
        WHEN salary_zar >= 50000  THEN 'Mid-Level'
        ELSE                           'Junior'
    END AS salary_band
FROM employees;

-- Mine operational status
SELECT
    mine_name,
    CASE operational
        WHEN 1 THEN 'Currently Operating'
        WHEN 0 THEN 'Non-Operational'
        ELSE        'Unknown'
    END AS status
FROM mines;

-- Department budget tier
SELECT
    department_name,
    budget_zar,
    CASE
        WHEN budget_zar >= 30000000 THEN '🟢 Large Budget'
        WHEN budget_zar >= 10000000 THEN '🟡 Medium Budget'
        ELSE                             '🔴 Small Budget'
    END AS budget_tier
FROM departments
ORDER BY budget_zar DESC;
```

---

## 12. COALESCE and NULLIF

```sql
-- COALESCE — return the first non-NULL value
-- Useful for replacing NULL with a default

SELECT
    first_name,
    last_name,
    COALESCE(mine_id, 0)                    AS mine_id_safe,  -- replace NULL with 0
    COALESCE(mine_id, 'Head Office')        -- note: type mismatch — use CAST
FROM employees;

-- Practical: display "Head Office" for employees with no mine
SELECT
    CONCAT(first_name, ' ', last_name)  AS employee,
    CASE
        WHEN mine_id IS NULL THEN 'Head Office'
        ELSE CAST(mine_id AS CHAR)
    END                                 AS assignment
FROM employees;

-- NULLIF — return NULL if two values are equal (avoids division by zero)
SELECT NULLIF(10, 10);   -- Returns: NULL (values match)
SELECT NULLIF(10, 5);    -- Returns: 10 (values don't match)

-- Safe division example
SELECT
    budget_zar / NULLIF(0, 0)  AS safe_divide;  -- avoids divide by zero error
```

---

## ⚠️ Common Mistakes

| Mistake | Wrong | Right |
|---------|-------|-------|
| Adding space in alias without quotes | `AS full name` | `AS full_name` or `AS "full name"` |
| Comparing to NULL with = | `WHERE mine_id = NULL` | `WHERE mine_id IS NULL` |
| Integer division losing decimals | `10 / 3` → 3 | `10 / 3.0` → 3.333 or `ROUND(10/3, 2)` |
| Forgetting CONCAT for strings | `first_name + ' ' + last_name` | `CONCAT(first_name, ' ', last_name)` |

---

## 📌 Function Quick Reference

| Category | Function | Example |
|----------|---------|---------|
| String | `UPPER(x)` | `UPPER('beeshoek')` → 'BEESHOEK' |
| String | `LOWER(x)` | `LOWER('ASSMANG')` → 'assmang' |
| String | `LENGTH(x)` | `LENGTH('SQL')` → 3 |
| String | `CONCAT(a,b,c)` | `CONCAT('A','B')` → 'AB' |
| String | `TRIM(x)` | `TRIM('  hi  ')` → 'hi' |
| String | `REPLACE(s,a,b)` | `REPLACE('abc','b','X')` → 'aXc' |
| String | `SUBSTRING(s,p,l)` | `SUBSTRING('Assmang',1,3)` → 'Ass' |
| Numeric | `ROUND(x,d)` | `ROUND(3.567,2)` → 3.57 |
| Numeric | `FLOOR(x)` | `FLOOR(3.9)` → 3 |
| Numeric | `CEIL(x)` | `CEIL(3.1)` → 4 |
| Numeric | `ABS(x)` | `ABS(-5)` → 5 |
| Date | `GETDATE()` | Current datetime |
| Date | `YEAR(d)` | `YEAR('2024-03-15')` → 2024 |
| Date | `DATEDIFF(a,b)` | Days between two dates |
| Conditional | `CASE WHEN` | If-then-else logic |
| Null | `COALESCE(a,b)` | First non-NULL of a, b |
| Null | `NULLIF(a,b)` | NULL if a=b, else a |

