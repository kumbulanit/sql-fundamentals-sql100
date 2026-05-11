# Later Hands-On — Day 2 Topic 02: JOINs & Subqueries

**Ex 1.** Show all active equipment with its mine name and province. Include equipment_code, type, status, mine_name, province.

**Ex 2.** Show all employees with their department name, but only for employees in the Engineering or Mining Operations departments. Use an INNER JOIN.

**Ex 3.** Find all employees whose salary is higher than the highest salary in the Safety department.

**Ex 4.** Show each mine's name alongside the total number of equipment pieces and total purchase value. Include mines with zero equipment (use LEFT JOIN from mines table).

**Ex 5.** Find which employees share the same job title as employee #5 (Petrus Booysen). Show name and job title.

**Ex 6.** Using a subquery, find all employees who work in a department whose total budget is above R15 million.

**Ex 7.** For each mine that has production data, show the mine name, total annual tonnage mined, and the month with the highest production. (Multi-step query.)

**Ex 8.** Show a "manager team" view: for each manager (where manager_id IS NULL — they manage others), list how many employees report directly to them.

---

## Answer Key

**Ex 1.**
```sql
SELECT eq.equipment_code, eq.equipment_type, eq.status,
       m.mine_name, m.province
FROM equipment eq
INNER JOIN mines m ON eq.mine_id = m.mine_id
WHERE eq.status = 'Active'
ORDER BY m.mine_name;
```

**Ex 2.**
```sql
SELECT e.first_name, e.last_name, d.department_name, e.salary_zar
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name IN ('Engineering', 'Mining Operations')
ORDER BY d.department_name, e.salary_zar DESC;
```

**Ex 3.**
```sql
SELECT first_name, last_name, salary_zar
FROM employees
WHERE salary_zar > (
    SELECT MAX(salary_zar) FROM employees
    WHERE department_id = 4
)
ORDER BY salary_zar DESC;
```

**Ex 4.**
```sql
SELECT m.mine_name,
       COUNT(eq.equipment_id)   AS equipment_count,
       COALESCE(SUM(eq.purchase_price), 0) AS total_value
FROM mines m
LEFT JOIN equipment eq ON m.mine_id = eq.mine_id
GROUP BY m.mine_id, m.mine_name
ORDER BY total_value DESC;
```

**Ex 5.**
```sql
SELECT first_name, last_name, job_title
FROM employees
WHERE job_title = (
    SELECT job_title FROM employees WHERE employee_id = 5
)
AND employee_id <> 5;
```

**Ex 6.**
```sql
SELECT e.first_name, e.last_name, e.department_id
FROM employees e
WHERE e.department_id IN (
    SELECT department_id FROM departments
    WHERE budget_zar > 15000000
);
```

**Ex 7.**
```sql
SELECT m.mine_name,
       SUM(p.tonnes_mined) AS total_annual_tonnes,
       (SELECT production_month FROM production_monthly p2
        WHERE p2.mine_id = p.mine_id AND p2.production_year = 2023
        ORDER BY p2.tonnes_mined DESC OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY) AS best_month
FROM production_monthly p
INNER JOIN mines m ON p.mine_id = m.mine_id
WHERE p.production_year = 2023
GROUP BY p.mine_id, m.mine_name
ORDER BY total_annual_tonnes DESC;
```

**Ex 8.**
```sql
SELECT
    CONCAT(mgr.first_name,' ',mgr.last_name) AS manager,
    mgr.job_title,
    COUNT(emp.employee_id) AS direct_reports
FROM employees mgr
INNER JOIN employees emp ON emp.manager_id = mgr.employee_id
WHERE mgr.manager_id IS NULL
GROUP BY mgr.employee_id, mgr.first_name, mgr.last_name, mgr.job_title
ORDER BY direct_reports DESC;
```

---

*End of Later Hands-On — Day 2 Topic 02*

