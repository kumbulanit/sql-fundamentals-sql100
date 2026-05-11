# Assessment — Day 2 Topic 01: Aggregation & GROUP BY
## Assmang Pty Ltd SQL100 Training

**Time:** 25 minutes | **Total:** 35 marks | **Pass:** 24/35

---

## Section 1: Multiple Choice (15 marks — 3 marks each)

**Q1.** What is the difference between `COUNT(*)` and `COUNT(mine_id)` when `mine_id` contains NULL values?

A) They return the same result  
B) `COUNT(*)` counts all rows; `COUNT(mine_id)` counts only non-NULL values  
C) `COUNT(mine_id)` counts all rows; `COUNT(*)` excludes NULLs  
D) `COUNT(*)` includes duplicates; `COUNT(mine_id)` does not  

**Q2.** In which order does SQL process these clauses?

A) SELECT → FROM → WHERE → GROUP BY → HAVING  
B) FROM → WHERE → SELECT → GROUP BY → HAVING  
C) FROM → WHERE → GROUP BY → HAVING → SELECT  
D) WHERE → FROM → GROUP BY → SELECT → HAVING  

**Q3.** Which clause is used to filter groups AFTER aggregation?

A) WHERE  
B) FILTER  
C) HAVING  
D) GROUP FILTER  

**Q4.** What is wrong with this query?
```sql
SELECT department_id, first_name, COUNT(*)
FROM employees
GROUP BY department_id;
```
A) Cannot use GROUP BY with COUNT  
B) `first_name` is not in GROUP BY and not aggregated  
C) Cannot group by department_id  
D) COUNT(*) should be COUNT(employee_id)  

**Q5.** Which query correctly finds departments with MORE than 3 employees?

A) `WHERE COUNT(*) > 3`  
B) `HAVING employee_count > 3` (if COUNT(*) is aliased as employee_count in the SELECT list)  
C) `HAVING COUNT(*) > 3`  
D) Both B and C are correct  

---

## Section 2: Write the Query (15 marks — 5 marks each)

**Q6.** Write a query that shows the total monthly salary bill, average salary, and employee count for EACH department. Sort by total monthly bill, highest first. _(5 marks)_

**Q7.** Write a query that finds mines (from `production_monthly`) that had a total 2023 revenue of MORE than R1,000,000,000 (1 billion). Show mine_id and total revenue. _(5 marks)_

**Q8.** Write a query showing the count of equipment in each `status` category (Active, Maintenance, Retired), but only include status categories with more than 1 piece of equipment. _(5 marks)_

---

## Section 3: Explain the Difference (5 marks)

**Q9.** Explain the difference between WHERE and HAVING. Write one example of each in the context of the Assmang database. _(5 marks)_

---

## ✅ ANSWER KEY

### Section 1
| Q | Answer |
|---|--------|
| Q1 | B |
| Q2 | C |
| Q3 | C |
| Q4 | B |
| Q5 | D — both B and C work when the alias is available to HAVING |

### Section 2

**Q6:**
```sql
SELECT department_id, COUNT(*) AS headcount,
       ROUND(AVG(salary_zar),2) AS avg_salary,
       SUM(salary_zar) AS monthly_bill
FROM employees
GROUP BY department_id
ORDER BY monthly_bill DESC;
```

**Q7:**
```sql
SELECT mine_id, SUM(revenue_zar) AS total_revenue
FROM production_monthly
WHERE production_year = 2023
GROUP BY mine_id
HAVING SUM(revenue_zar) > 1000000000
ORDER BY total_revenue DESC;
-- Expected: mine_id=2 (Khumani) and mine_id=3 (Black Rock)
```

**Q8:**
```sql
SELECT status, COUNT(*) AS count
FROM equipment
GROUP BY status
HAVING COUNT(*) > 1
ORDER BY count DESC;
```

### Section 3 — Q9 (5 marks)
WHERE filters individual rows BEFORE GROUP BY runs. It cannot use aggregate functions.  
HAVING filters groups AFTER GROUP BY runs. It CAN use aggregate functions.

Examples:
```sql
-- WHERE: filter active employees before grouping
SELECT department_id, AVG(salary_zar)
FROM employees
WHERE is_active = 1
GROUP BY department_id;

-- HAVING: filter departments where average salary > R60k
SELECT department_id, AVG(salary_zar) AS avg
FROM employees
GROUP BY department_id
HAVING avg > 60000;
```

---

*Assessment — Day 2 Topic 01 — Assmang SQL100*

