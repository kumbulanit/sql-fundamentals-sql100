# Later Hands-On — Day 2 Topic 01: Aggregation & GROUP BY
## Assmang Pty Ltd SQL100 | Independent Practice

---

**Ex 1.** Find the total value (purchase_price) of equipment at each mine. Show mine_id, count, and total value. Include only mines with total equipment value above R20 million.

**Ex 2.** Calculate the average ore grade per mine for 2023. Show mine_id and average grade. Order by average grade descending.

**Ex 3.** Find the month in 2023 that had the highest total production across ALL mines combined. Show month number and total tonnes mined.

**Ex 4.** Count how many employees fall into each salary band:
- Junior (< R50,000)
- Mid-Level (R50,000–R74,999)
- Senior (R75,000–R99,999)
- Executive (R100,000+)
(Hint: Use CASE WHEN inside GROUP BY or SUM with CASE)

**Ex 5.** Find the average monthly revenue per mine type (Iron Ore, Manganese, Chrome) in 2023. Use the `mines` and `production_monthly` tables. (Hint: Use JOIN — covered in Topic 02)

**Ex 6.** How many employees were hired each year? Show hire_year and count, ordered by year.

**Ex 7.** Write ONE query that finds all departments where:
- At least 3 employees are assigned
- The total monthly payroll exceeds R150,000

Show department_id, headcount, and total payroll.

---

## Answer Key

**Ex 1.**
```sql
SELECT mine_id, COUNT(*) AS equipment_count,
       SUM(purchase_price) AS total_value
FROM equipment
GROUP BY mine_id
HAVING SUM(purchase_price) > 20000000
ORDER BY total_value DESC;
```

**Ex 2.**
```sql
SELECT mine_id, ROUND(AVG(ore_grade_pct), 2) AS avg_grade
FROM production_monthly
WHERE production_year = 2023
GROUP BY mine_id
ORDER BY avg_grade DESC;
```

**Ex 3.**
```sql
SELECT production_month, SUM(tonnes_mined) AS total_all_mines
FROM production_monthly
WHERE production_year = 2023
GROUP BY production_month
ORDER BY total_all_mines DESC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;
```

**Ex 4.**
```sql
SELECT
    CASE
        WHEN salary_zar < 50000  THEN 'Junior'
        WHEN salary_zar < 75000  THEN 'Mid-Level'
        WHEN salary_zar < 100000 THEN 'Senior'
        ELSE                          'Executive'
    END AS salary_band,
    COUNT(*) AS headcount
FROM employees
GROUP BY salary_band
ORDER BY MIN(salary_zar);
```

**Ex 5.**
```sql
SELECT m.mine_type,
       ROUND(AVG(p.revenue_zar), 2) AS avg_monthly_revenue
FROM production_monthly p
JOIN mines m ON p.mine_id = m.mine_id
WHERE p.production_year = 2023
GROUP BY m.mine_type
ORDER BY avg_monthly_revenue DESC;
```

**Ex 6.**
```sql
SELECT YEAR(hire_date) AS hire_year, COUNT(*) AS new_hires
FROM employees
GROUP BY hire_year
ORDER BY hire_year;
```

**Ex 7.**
```sql
SELECT department_id, COUNT(*) AS headcount, SUM(salary_zar) AS total_payroll
FROM employees
GROUP BY department_id
HAVING COUNT(*) >= 3
   AND SUM(salary_zar) > 150000
ORDER BY total_payroll DESC;
```

---

*End of Later Hands-On — Day 2 Topic 01*

