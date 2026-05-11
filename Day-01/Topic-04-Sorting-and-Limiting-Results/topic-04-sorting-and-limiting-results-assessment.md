# Assessment — Topic 04: Sorting, Limiting & Ordering
## Assmang Pty Ltd SQL100 Training | Day 1

**Time allowed:** 20 minutes | **Total marks:** 25 | **Pass mark:** 17/25

---

## Section 1: Multiple Choice (10 marks — 2 marks each)

**Q1.** What does `ORDER BY salary_zar DESC OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY` return?

A) The lowest-paid employee  
B) All employees ordered by salary  
C) The single highest-paid employee  
D) The last employee in the table  

**Q2.** Which clause is used to skip the first 10 rows and return the next 5?

A) `OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY`  
B) `OFFSET 5 ROWS FETCH NEXT 10 ROWS ONLY`  
C) `ROWNUM BETWEEN 11 AND 15`  
D) `TOP 5`  

**Q3.** In SQL Server, when sorting by a column that has NULL values `ORDER BY col ASC`, where do NULLs appear?

A) At the end  
B) At the beginning  
C) NULLs are excluded from sorted results  
D) It depends on the data type  

**Q4.** What is wrong with this query?
```sql
SELECT salary_zar * 12 AS annual_salary
FROM employees
WHERE annual_salary > 960000;
```
A) The alias `annual_salary` cannot be used in the WHERE clause  
B) The multiplication operator is wrong  
C) `salary_zar * 12` is not a valid expression  
D) Nothing is wrong with this query  

**Q5.** For a directory application showing 10 results per page, what is the correct OFFSET/FETCH for page 5?

A) `OFFSET 40 ROWS FETCH NEXT 10 ROWS ONLY`  
B) `OFFSET 50 ROWS FETCH NEXT 10 ROWS ONLY`  
C) `OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY`  
D) `OFFSET 4 ROWS FETCH NEXT 10 ROWS ONLY`  

---

## Section 2: Write the Query (15 marks — 5 marks each)

**Q6.** Write a query that returns the job title and salary of the top 5 highest-paid employees at Assmang. Include their full name. _(5 marks)_

**Q7.** Write a query showing all mines ordered by: first by `mine_type` alphabetically ascending, then by `established_year` ascending within each type. Show `mine_name`, `mine_type`, and `established_year`. _(5 marks)_

**Q8.** An IT developer is building a mobile app that shows 6 employees per page, sorted by last name then first name. Write the query for **page 3** of the results. Show `last_name`, `first_name`, and `job_title`. _(5 marks)_

---

## ✅ ANSWER KEY

### Section 1
| Q | Answer | Explanation |
|---|--------|-------------|
| Q1 | **C** | DESC sorts highest first; OFFSET/FETCH 1 returns only that one row |
| Q2 | **A** | `OFFSET n ROWS FETCH NEXT m ROWS ONLY` skips n rows and returns m rows |
| Q3 | **B** | SQL Server ASC puts NULLs first (treated as lowest value) |
| Q4 | **A** | WHERE runs before SELECT; alias not yet defined when WHERE evaluates |
| Q5 | **A** | Page 5: OFFSET = (5-1)×10 = 40; FETCH NEXT 10 ROWS ONLY |

### Section 2

**Q6 (5 marks):**
```sql
SELECT
    CONCAT(first_name, ' ', last_name)  AS full_name,
    job_title,
    salary_zar
FROM employees
ORDER BY salary_zar DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
```
Expected result: Riaan De Jager (150k), Werner Fourie (135k), Calvin Pretorius (125k), Johan Van Niekerk (120k), Irene Jacobs (115k)

**Q7 (5 marks):**
```sql
SELECT mine_name, mine_type, established_year
FROM mines
ORDER BY mine_type ASC,
         established_year ASC;
```

**Q8 (5 marks):**
```sql
-- Page 3: OFFSET = (3-1) × 6 = 12
SELECT last_name, first_name, job_title
FROM employees
ORDER BY last_name ASC, first_name ASC
OFFSET 12 ROWS FETCH NEXT 6 ROWS ONLY;
```

---

*Assessment 04 — End of Day 1 — Assmang Pty Ltd SQL100 Training Programme*

