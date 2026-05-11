# Later Hands-On — Topic 02: SELECT Statements & Functions
## Assmang Pty Ltd SQL100 | Independent Practice

---

## Exercises

**Ex 1.** Write a query that shows each employee's full name (first + last), email, and the number of characters in their email address. Alias the character count as `email_length`. Order by email length descending.

**Ex 2.** Write a query that shows each mine's name, its province, and how many years ago it was established (from today). Name the calculated column `years_since_established`.

**Ex 3.** Write a query to display a "payslip header" for each employee:  
Format: `DLAMINI, Nomsa | HR Manager | Hired: 01 March 2015`  
All in one column called `payslip_header`.

**Ex 4.** Categorise each department by budget:
- R40M+: "Major Division"
- R15M–R39.9M: "Standard Division"  
- Below R15M: "Support Division"

Show department name, budget, and category. Order by budget descending.

**Ex 5.** Show all employees with their `manager_id`. For employees where `manager_id` IS NULL (they have no manager — they are directors/top-level), display "No Manager" instead of NULL. Name the column `reports_to`.

**Ex 6.** Using only string functions, produce employee initials in format `J.V.N.` from `first_name` (J), and `last_name` (V.N. — first 3 chars). Use the employees table.

**Ex 7.** Calculate a "loyalty bonus" for employees:
- 10+ years service: 10% of annual salary
- 5–9 years: 5% of annual salary
- Under 5 years: 2% of annual salary  

Show employee name, years of service, annual salary, and the bonus amount rounded to 2 decimal places.

**Ex 8.** Write a query that returns only the `mine_type` values from the mines table — but returns each type exactly ONCE, in uppercase, with the word "MINING" appended.  
Expected output:
```
IRON ORE MINING
MANGANESE MINING
CHROME MINING
```

---

## Answer Key

**Ex 1.**
```sql
SELECT
    CONCAT(first_name, ' ', last_name)  AS full_name,
    email,
    LENGTH(email)                       AS email_length
FROM employees
ORDER BY LENGTH(email) DESC;
```

**Ex 2.**
```sql
SELECT
    mine_name,
    province,
    YEAR(GETDATE()) - established_year AS years_since_established
FROM mines;
```

**Ex 3.**
```sql
SELECT
    CONCAT(
        UPPER(last_name), ', ', first_name,
        ' | ', job_title,
        ' | Hired: ', FORMAT(hire_date, 'dd MMMM yyyy')
    ) AS payslip_header
FROM employees;
```

**Ex 4.**
```sql
SELECT
    department_name,
    budget_zar,
    CASE
        WHEN budget_zar >= 40000000 THEN 'Major Division'
        WHEN budget_zar >= 15000000 THEN 'Standard Division'
        ELSE                             'Support Division'
    END AS division_category
FROM departments
ORDER BY budget_zar DESC;
```

**Ex 5.**
```sql
SELECT
    CONCAT(first_name, ' ', last_name)      AS employee,
    COALESCE(CAST(manager_id AS CHAR), 'No Manager') AS reports_to
FROM employees;
```

**Ex 6.**
```sql
SELECT
    first_name,
    last_name,
    CONCAT(
        LEFT(first_name, 1), '.',
        LEFT(last_name, 1), '.',
        SUBSTRING(last_name, 2, 1), '.'
    ) AS initials
FROM employees;
```

**Ex 7.**
```sql
SELECT
    CONCAT(first_name, ' ', last_name)              AS employee,
    DATEDIFF(YEAR, hire_date, GETDATE())  AS years_service,
    ROUND(salary_zar * 12, 2)                       AS annual_salary,
    ROUND(
        salary_zar * 12 *
        CASE
            WHEN DATEDIFF(YEAR, hire_date, GETDATE()) >= 10
                THEN 0.10
            WHEN DATEDIFF(YEAR, hire_date, GETDATE()) >= 5
                THEN 0.05
            ELSE 0.02
        END,
    2)                                              AS loyalty_bonus
FROM employees
ORDER BY years_service DESC;
```

**Ex 8.**
```sql
SELECT DISTINCT
    CONCAT(UPPER(mine_type), ' MINING') AS mine_type_label
FROM mines;
```

---

*End of Later Hands-On 02*

