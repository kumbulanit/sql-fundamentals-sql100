.md files with their relavatent # Assessment — Day 2 Topic 02: JOINs & Subqueries
## Assmang Pty Ltd SQL100 Training

**Time:** 30 minutes | **Total:** 40 marks | **Pass:** 28/40

---

## Section 1: Multiple Choice (15 marks — 3 marks each)

**Q1.** Which JOIN returns only rows where a match exists in BOTH tables?

A) LEFT JOIN  
B) RIGHT JOIN  
C) INNER JOIN  
D) CROSS JOIN  

**Q2.** An employee's `mine_id` is NULL. If you run an INNER JOIN between `employees` and `mines` on `mine_id`, what happens to this employee?

A) They appear with NULL mine columns  
B) They are excluded from the result  
C) They cause an error  
D) They appear with a default mine  

**Q3.** What is the risk of the following query?
```sql
SELECT * FROM employees, mines;
```

A) Syntax error  
B) Returns a Cartesian product (every employee × every mine)  
C) Returns only matching rows  
D) Returns employees without mines  

**Q4.** In a self JOIN on the `employees` table to show employee + manager names, which alias pattern is used?

A) `FROM employees AS employee, employees AS department`  
B) `FROM employees e INNER JOIN employees m ON e.manager_id = m.employee_id`  
C) `FROM employees SELF JOIN employees`  
D) `FROM employees AS e WHERE e.manager_id = employee_id`  

**Q5.** When should you use `IN` vs `=` with a subquery?

A) Use `=` always for performance  
B) Use `IN` when the subquery might return multiple rows  
C) Use `IN` only with numeric values  
D) They are always interchangeable  

---

## Section 2: Write the Query (20 marks — 5 marks each)

**Q6.** Write a query that shows each employee's full name, job title, and their department name (not department_id). Sort by department name, then employee last name. _(5 marks)_

**Q7.** Using a LEFT JOIN, show ALL mines along with how many employees are assigned to each. Mines with 0 employees should still appear. Show mine_name, mine_type, and employee_count. _(5 marks)_

**Q8.** Using a subquery, find all employees who earn more than the average salary of the Mining Operations department (department_id = 2). Show their name, department_id, and salary. _(5 marks)_

**Q9.** Show each employee's full name, their manager's full name, and the manager's job title. Use a self JOIN. Employees with no manager should show 'No Manager' instead of NULL. _(5 marks)_

---

## Section 3: Analysis (5 marks)

**Q10.** A developer wrote this query:
```sql
SELECT e.first_name, m.mine_name
FROM employees e
INNER JOIN mines m ON e.mine_id = m.mine_id
WHERE m.mine_type = 'Iron Ore';
```
The developer expected to see head office staff in the results but they don't appear. Explain why, and write the corrected query that includes all employees (with 'Head Office' for non-mine staff) while still filtering to show only employees linked to Iron Ore mines or to Head Office. _(5 marks)_

---

## ✅ ANSWER KEY

### Section 1
| Q | Answer |
|---|--------|
| Q1 | C |
| Q2 | B — no matching mine_id, INNER JOIN excludes the row |
| Q3 | B — Cartesian product: 31 × 6 = 186 rows |
| Q4 | B |
| Q5 | B |

### Section 2

**Q6:**
```sql
SELECT CONCAT(e.first_name,' ',e.last_name) AS employee,
       e.job_title, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_name, e.last_name;
```

**Q7:**
```sql
SELECT m.mine_name, m.mine_type, COUNT(e.employee_id) AS employee_count
FROM mines m
LEFT JOIN employees e ON m.mine_id = e.mine_id
GROUP BY m.mine_id, m.mine_name, m.mine_type
ORDER BY employee_count DESC;
```

**Q8:**
```sql
SELECT CONCAT(first_name,' ',last_name) AS employee,
       department_id, salary_zar
FROM employees
WHERE salary_zar > (
    SELECT AVG(salary_zar)
    FROM employees
    WHERE department_id = 2
)
ORDER BY salary_zar DESC;
```

**Q9:**
```sql
SELECT
    CONCAT(e.first_name,' ',e.last_name)            AS employee,
    COALESCE(CONCAT(m.first_name,' ',m.last_name), 'No Manager') AS manager,
    COALESCE(m.job_title, 'No Manager')             AS manager_title
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id
ORDER BY manager, e.last_name;
```

### Section 3 — Q10

**Explanation:** INNER JOIN only returns rows where both sides match. Head Office employees have `mine_id = NULL` which won't match any `mine_id` in the mines table, so they're excluded. Additionally, the `WHERE m.mine_type = 'Iron Ore'` filter further limits results.

**Corrected query:**
```sql
SELECT
    CONCAT(e.first_name,' ',e.last_name)        AS employee,
    COALESCE(m.mine_name, 'Head Office')        AS location,
    COALESCE(m.mine_type, 'N/A')               AS mine_type
FROM employees e
LEFT JOIN mines m ON e.mine_id = m.mine_id
WHERE m.mine_type = 'Iron Ore'
   OR m.mine_id IS NULL;
```

---

*Assessment — Day 2 Topic 02 — Assmang SQL100*

