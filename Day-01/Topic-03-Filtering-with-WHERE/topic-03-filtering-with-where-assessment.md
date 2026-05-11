# Assessment — Topic 03: Filtering with WHERE
## Assmang Pty Ltd SQL100 Training | Day 1

**Time allowed:** 20 minutes | **Total marks:** 30 | **Pass mark:** 20/30

---

## Section 1: Multiple Choice (15 marks — 3 marks each)

**Q1.** Which of the following correctly filters employees earning between R40,000 and R80,000?

A) `WHERE salary_zar > 40000 AND salary_zar < 80000`  
B) `WHERE salary_zar BETWEEN 40000 AND 80000`  
C) `WHERE salary_zar IN (40000, 80000)`  
D) Both A and B (but A excludes endpoints, B includes them)  

---

**Q2.** What does this query return?
```sql
SELECT COUNT(*) FROM employees WHERE mine_id = NULL;
```

A) The number of employees with no mine assignment  
B) 0 — because you cannot compare with `= NULL`  
C) An error  
D) All rows in the employees table  

---

**Q3.** Which `LIKE` pattern would find all mines whose name starts with "B"?

A) `LIKE '%B'`  
B) `LIKE 'B_'`  
C) `LIKE 'B%'`  
D) `LIKE '_B%'`  

---

**Q4.** What is the result of this WHERE clause?
```sql
WHERE department_id = 1 OR department_id = 2 AND salary_zar > 100000
```

A) Employees in dept 1 OR dept 2, all with salary > 100000  
B) Employees in dept 1 (any salary) OR employees in dept 2 with salary > 100000  
C) Employees in dept 2 only, with salary > 100000  
D) An error — cannot mix OR and AND  

---

**Q5.** Which operator is the correct replacement for `NOT IN` when the list might contain NULL values?

A) `<> ALL`  
B) `NOT LIKE`  
C) `NOT EXISTS` with a subquery  
D) `NOT BETWEEN`  

---

## Section 2: Write the Query (10 marks — 5 marks each)

**Q6.** Write a query that retrieves `first_name`, `last_name`, and `hire_date` for all employees hired between 1 January 2018 and 31 December 2020, who are assigned to a mine (mine_id is not null). Order results by hire date ascending. _(5 marks)_

**Q7.** Write a query to find all Chrome or Manganese mines that are operational. Return `mine_name`, `mine_type`, and `province`. _(5 marks)_

---

## Section 3: Find the Bug (5 marks)

**Q8.** The following query is supposed to find Head Office employees (no mine assigned) earning more than R70,000. It returns 0 rows. Find and fix the bug. _(5 marks)_

```sql
SELECT first_name, last_name, salary_zar
FROM employees
WHERE mine_id = NULL
  AND salary_zar > 70000;
```

---

## ✅ ANSWER KEY

### Section 1
| Q | Answer | Explanation |
|---|--------|-------------|
| Q1 | **D** | BETWEEN includes both endpoints (equivalent to >= AND <=); plain > AND < excludes them |
| Q2 | **B** | `= NULL` is never TRUE in SQL; returns 0 rows. Use `IS NULL` |
| Q3 | **C** | `B%` means starts with B followed by anything |
| Q4 | **B** | AND binds tighter than OR. Evaluates as: dept=1 OR (dept=2 AND salary>100000) |
| Q5 | **C** | NOT EXISTS with subquery is the safe choice; NOT IN with NULL returns no rows |

### Section 2

**Q6 (5 marks):**
```sql
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date BETWEEN '2018-01-01' AND '2020-12-31'
  AND mine_id IS NOT NULL
ORDER BY hire_date ASC;
```
Mark allocation: SELECT cols (1), BETWEEN dates (1.5), IS NOT NULL (1.5), ORDER BY (1)

**Q7 (5 marks):**
```sql
SELECT mine_name, mine_type, province
FROM mines
WHERE mine_type IN ('Chrome', 'Manganese')
  AND operational = 1;
-- OR using OR:
WHERE (mine_type = 'Chrome' OR mine_type = 'Manganese')
  AND operational = 1;
```
Mark allocation: SELECT cols (1), mine_type filter (2), operational filter (1), FROM mines (1)

### Section 3

**Q8 (5 marks):**

Bug: `WHERE mine_id = NULL` — cannot compare with `= NULL`. This always evaluates to FALSE/UNKNOWN.

**Fixed query:**
```sql
SELECT first_name, last_name, salary_zar
FROM employees
WHERE mine_id IS NULL
  AND salary_zar > 70000;
```
Expected result: Nomsa Dlamini (R75,000), Werner Fourie (R135,000), Riaan De Jager (R150,000), Lindiwe Mthembu (R80,000), Andre Bothma (R95,000)  
Mark allocation: identify bug (2), correct fix `IS NULL` (2), expected result acknowledgment (1)

---

*Assessment 03 — Assmang Pty Ltd SQL100 Training Programme*

