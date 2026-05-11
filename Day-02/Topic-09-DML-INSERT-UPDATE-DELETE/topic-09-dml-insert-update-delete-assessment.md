# Assessment — Day 2 Topic 03: DML
## Assmang Pty Ltd SQL100 Training

**Time:** 25 minutes | **Total:** 35 marks | **Pass:** 24/35

---

## Section 1: Multiple Choice (15 marks — 3 marks each)

**Q1.** What is the safest practice BEFORE running an UPDATE or DELETE statement?

A) Take a database backup first  
B) Run the equivalent SELECT with the same WHERE condition to verify rows  
C) Start a new database connection  
D) Grant yourself admin rights  

**Q2.** What is the key difference between DELETE and TRUNCATE?

A) DELETE is faster than TRUNCATE  
B) TRUNCATE can use a WHERE clause  
C) DELETE logs each row and can be rolled back; TRUNCATE does not log rows and typically cannot be rolled back  
D) TRUNCATE only removes specific rows  

**Q3.** Which statement correctly inserts a new mine into the `mines` table?

A) `INSERT mines ('Kathu Mine', 'Iron Ore', 'Northern Cape', 1, 2024);`  
B) `INSERT INTO mines VALUES (7, 'Kathu Mine',  'Iron Ore', 'Northern Cape', 1, 2024);`  
C) `INSERT INTO mines (mine_name, mine_type, province, operational, established_year) VALUES ('Kathu Mine', 'Iron Ore', 'Northern Cape', 1, 2024);`  
D) `ADD ROW INTO mines ('Kathu Mine', 'Iron Ore');`  

**Q4.** What happens if you run this statement?
```sql
UPDATE employees SET salary_zar = 55000;
```

A) Only employees earning less than 55000 are updated  
B) Only the first employee is updated  
C) ALL employees get their salary set to 55000 — WHERE clause is missing  
D) Nothing — UPDATE requires at least two conditions  

**Q5.** To undo DML changes made within a transaction, you use:

A) `UNDO`  
B) `ROLLBACK`  
C) `REVERT`  
D) `DELETE TRANSACTION`  

---

## Section 2: Write the Query (15 marks — 5 marks each)

**Q6.** Write an INSERT statement to add a new department to the `departments` table:
- Name: `Research & Development`
- Location: `Pretoria, GP`
- Budget: R6,500,000
_(5 marks)_

**Q7.** The Processing Plant department (department_id = 8) has received budget approval for a 10% salary increase for all its employees. Write the UPDATE statement. Include the safety SELECT first, then the UPDATE. _(5 marks)_

**Q8.** Write a DELETE statement that removes all training records from `training_register` where the employee failed (passed = 0) and the course was completed before 2024-03-01. Include a before-count SELECT. _(5 marks)_

---

## Section 3: Practical Scenario (5 marks)

**Q9.** An Assmang HR manager accidentally ran:
```sql
UPDATE employees SET salary_zar = 25000;
```
This ran without a WHERE clause and changed everyone's salary. Luckily, they had started a transaction beforehand. What single command saves the day? Explain how transactions protect against accidents like this. _(5 marks)_

---

## ✅ ANSWER KEY

### Section 1
| Q | Answer |
|---|--------|
| Q1 | B |
| Q2 | C |
| Q3 | C |
| Q4 | C |
| Q5 | B |

### Section 2

**Q6:**
```sql
INSERT INTO departments (department_name, location, budget_zar)
VALUES ('Research & Development', 'Pretoria, GP', 6500000.00);
```

**Q7:**
```sql
-- Safety check first:
SELECT COUNT(*), SUM(salary_zar), ROUND(SUM(salary_zar*1.10),2) AS new_total
FROM employees WHERE department_id = 8;

-- Apply update:
UPDATE employees
SET salary_zar = ROUND(salary_zar * 1.10, 2)
WHERE department_id = 8;
```

**Q8:**
```sql
-- Before count:
SELECT COUNT(*) FROM training_register
WHERE passed = 0 AND course_date < '2024-03-01';

-- Delete:
DELETE FROM training_register
WHERE passed = 0
  AND course_date < '2024-03-01';
```

### Section 3 — Q9 (5 marks)

**Answer:** `ROLLBACK;`

**Explanation (2 marks):** A transaction is a logical unit of work that groups SQL statements together. When you run `START TRANSACTION`, all subsequent DML changes are held in a temporary "pending" state — not yet permanent.

`ROLLBACK` reverts ALL changes made since the most recent `START TRANSACTION`, restoring the data to its state before the transaction began.

`COMMIT` makes the changes permanent.

This is why the golden rule is: **always use `START TRANSACTION` before risky or bulk data changes** — it gives you a safety net.

---

*Assessment — Day 2 Topic 03 — Assmang SQL100*

