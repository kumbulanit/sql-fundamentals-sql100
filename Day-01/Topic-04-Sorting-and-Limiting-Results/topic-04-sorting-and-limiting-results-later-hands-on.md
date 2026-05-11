# Later Hands-On — Topic 04: Sorting & Limiting
## Assmang Pty Ltd SQL100 | Independent Practice

---

**Ex 1.** Show the 3 most recent hires at Assmang (newest hire_date first). Show full name, job title, and hire date.

**Ex 2.** Show the 5 departments with the smallest budgets, ordered from smallest to largest. Include department name and budget in millions (rounded to 1 decimal place).

**Ex 3.** Create a salary ranking report for employees in the Mining Operations department (dept_id=2). Show rank position (use ORDER BY), employee name, job title, and salary. No LIMIT — show all.

**Ex 4.** Show page 4 of an employee directory (sorted by last_name ASC, first_name ASC), showing 5 employees per page.

**Ex 5.** Find the employee who was hired exactly in the middle of Assmang's hiring history (hint: use OFFSET/FETCH; there are 31 employees so record 16 is the median). Sort by hire_date ASC.

**Ex 6.** Sort the mines so that Chrome mines appear first, then Manganese, then Iron Ore — without using a column that already contains this order. Use CASE WHEN in ORDER BY.

**Ex 7.** Show all employees that were hired in 2019 or 2020, sorted by department (asc) then hire date (desc). Include: name, department_id, hire_date.

**Ex 8.** Display the top 3 departments by budget per employee. Show: department_name, budget_zar, a calculated `budget_per_employee` value. You'll need to manually count or look up employee counts per department.  
_(Hint: Use what you know — the result doesn't need to be perfect, just show the calculation approach)_

---

## Answer Key

**Ex 1.**
```sql
SELECT CONCAT(first_name,' ',last_name) AS employee, job_title, hire_date
FROM employees
ORDER BY hire_date DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;
```

**Ex 2.**
```sql
SELECT department_name, ROUND(budget_zar/1000000, 1) AS budget_millions
FROM departments
ORDER BY budget_zar ASC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
```

**Ex 3.**
```sql
SELECT CONCAT(first_name,' ',last_name) AS employee, job_title, salary_zar
FROM employees
WHERE department_id = 2
ORDER BY salary_zar DESC;
```

**Ex 4.**
```sql
-- Page 4: rows 16-20 (OFFSET = (4-1)*5 = 15)
SELECT first_name, last_name
FROM employees
ORDER BY last_name ASC, first_name ASC
OFFSET 15 ROWS FETCH NEXT 5 ROWS ONLY;
```

**Ex 5.**
```sql
SELECT first_name, last_name, hire_date
FROM employees
ORDER BY hire_date ASC
OFFSET 15 ROWS FETCH NEXT 1 ROWS ONLY;  -- 0-indexed: record 16 = OFFSET 15
```

**Ex 6.**
```sql
SELECT mine_name, mine_type
FROM mines
ORDER BY
    CASE mine_type
        WHEN 'Chrome'    THEN 1
        WHEN 'Manganese' THEN 2
        WHEN 'Iron Ore'  THEN 3
    END ASC;
```

**Ex 7.**
```sql
SELECT CONCAT(first_name,' ',last_name) AS employee, department_id, hire_date
FROM employees
WHERE YEAR(hire_date) IN (2019, 2020)
ORDER BY department_id ASC, hire_date DESC;
```

**Ex 8.**
```sql
-- Approximate (without GROUP BY — covered Day 2)
-- Using known employee counts per department:
SELECT department_name, budget_zar,
    ROUND(budget_zar /
        CASE department_id
            WHEN 1 THEN 3   -- HR: 3 employees
            WHEN 2 THEN 9   -- Mining: 9 employees
            WHEN 3 THEN 4   -- Engineering: 4 employees
            WHEN 4 THEN 3   -- Safety: 3 employees
            WHEN 5 THEN 3   -- Finance: 3 employees
            WHEN 6 THEN 3   -- IT: 3 employees
            WHEN 7 THEN 3   -- Logistics: 3 employees
            WHEN 8 THEN 3   -- Processing: 3 employees
        END, 2) AS budget_per_employee
FROM departments
ORDER BY budget_per_employee DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;
```

---

*End of Later Hands-On 04 — End of Day 1 Materials*

