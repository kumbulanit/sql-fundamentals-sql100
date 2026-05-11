# Later Hands-On — Topic 03: Filtering with WHERE
## Assmang Pty Ltd SQL100 | Independent Practice

---

## Exercises

**Ex 1.** Find all employees hired in 2020 or later who earn less than R50,000 per month.

**Ex 2.** Find all operational mines that were established between 1960 and 1999 (inclusive). Show mine name, type, province, and year established.

**Ex 3.** Find all employees whose job title contains "Officer" and who are assigned to a mine (not Head Office).

**Ex 4.** Find employees in departments 2, 3, or 8 (Mining, Engineering, Processing) who earn between R80,000 and R130,000.

**Ex 5.** Find all mines whose name does NOT contain the word "Mine" (only returns those with non-standard naming).

**Ex 6.** List all employees whose email address uses the initial format `x.surname@assmang.co.za` (i.e., starts with a single letter, then a dot). Use `LIKE` with `_` wildcard.

**Ex 7.** Find all departments with budget either below R5 million OR above R30 million. Show department name and budget, ordered by budget.

**Ex 8.** Find all employees who are top-level staff (no manager) AND earn more than R80,000. Show their name, job title, and salary.

**Ex 9.** The Safety team wants to find field employees at Black Rock Mine (mine_id=3) who are NOT Safety Officers. Write the query.

**Ex 10.** Write a query that finds employees whose first name is exactly 5 characters long AND whose last name starts with a vowel (A, E, I, O, U).

---

## Answer Key

**Ex 1.**
```sql
SELECT first_name, last_name, hire_date, salary_zar
FROM employees
WHERE hire_date >= '2020-01-01'
  AND salary_zar < 50000;
```

**Ex 2.**
```sql
SELECT mine_name, mine_type, province, established_year
FROM mines
WHERE established_year BETWEEN 1960 AND 1999
  AND operational = 1;
```

**Ex 3.**
```sql
SELECT first_name, last_name, job_title, mine_id
FROM employees
WHERE job_title LIKE '%Officer%'
  AND mine_id IS NOT NULL;
```

**Ex 4.**
```sql
SELECT first_name, last_name, department_id, salary_zar
FROM employees
WHERE department_id IN (2, 3, 8)
  AND salary_zar BETWEEN 80000 AND 130000;
```

**Ex 5.**
```sql
SELECT mine_name, mine_type
FROM mines
WHERE mine_name NOT LIKE '%Mine%';
-- Returns: Dwarsrivier Chrome, Machadodorp Works
```

**Ex 6.**
```sql
SELECT first_name, last_name, email
FROM employees
WHERE email LIKE '_.%@assmang.co.za';
```

**Ex 7.**
```sql
SELECT department_name, budget_zar
FROM departments
WHERE budget_zar < 5000000
   OR budget_zar > 30000000
ORDER BY budget_zar;
```

**Ex 8.**
```sql
SELECT CONCAT(first_name,' ',last_name) AS employee, job_title, salary_zar
FROM employees
WHERE manager_id IS NULL
  AND salary_zar > 80000;
```

**Ex 9.**
```sql
SELECT first_name, last_name, job_title
FROM employees
WHERE mine_id = 3
  AND job_title <> 'Safety Officer';
```

**Ex 10.**
```sql
SELECT first_name, last_name
FROM employees
WHERE first_name LIKE '_____'  -- exactly 5 characters
  AND (last_name LIKE 'A%' OR last_name LIKE 'E%'
    OR last_name LIKE 'I%' OR last_name LIKE 'O%'
    OR last_name LIKE 'U%');
```

---

*End of Later Hands-On 03*

