# Assessment — Day 2 Topic 04: DDL & Best Practices
## Assmang Pty Ltd SQL100 Training

**Time:** 25 minutes | **Total:** 35 marks | **Pass:** 24/35

---

## Section 1: Multiple Choice (15 marks — 3 marks each)

**Q1.** Why shouldn't you assume a DROP TABLE statement can be rolled back in SQL Server?

A) DROP TABLE requires admin rights  
B) DDL statements are auto-committed and not transactional  
C) DROP TABLE only removes the structure, not the data  
D) You need to use UNDO DROP instead  

**Q2.** What is the purpose of a VIEW?

A) To permanently store aggregated data  
B) To save a SELECT query as a reusable virtual table  
C) To create a backup of a table  
D) To speed up all queries automatically  

**Q3.** Which data type would you use to store the ore grade percentage (e.g., 64.50)?

A) `INT`  
B) `VARCHAR(10)`  
C) `DECIMAL(5,2)`  
D) `FLOAT`  

**Q4.** What does `ALTER TABLE employees ADD COLUMN mobile VARCHAR(20);` do?

A) Creates a new table called mobile  
B) Adds a new column called mobile to the existing employees table  
C) Replaces the existing email column with mobile  
D) Drops the employees table and recreates it  

**Q5.** When is an index MOST beneficial?

A) On a column that is rarely searched  
B) On a small table with fewer than 100 rows  
C) On a large table's column that is frequently used in WHERE or JOIN conditions  
D) On every column of every table  

---

## Section 2: Write the Query (15 marks — 5 marks each)

**Q6.** Write a complete `CREATE TABLE` statement for an `audit_log` table to record all data changes at Assmang. Include: `log_id` (PK, identity), `action_type` (INSERT, UPDATE, or DELETE — enforce with a CHECK constraint), `table_name` (VARCHAR), `performed_by` (INT, FK to employees), `action_timestamp` (DATETIME2, default current time). _(5 marks)_

**Q7.** Write the ALTER TABLE statements to:
a) Add a `certification_number` column (VARCHAR(50)) to the `employees` table  
b) Rename it to `cert_id` using ALTER TABLE  
_(5 marks)_

**Q8.** Create a view called `vw_active_mine_staff` that shows all active employees who are assigned to a mine (not Head Office). Include: full name, job title, department name, mine name, and mine type. _(5 marks)_

---

## Section 3: Best Practices (5 marks)

**Q9.** List FIVE SQL best practices every developer should follow. For each, explain WHY it matters in a real-world context like Assmang's database. _(5 marks — 1 mark each)_

---

## ✅ ANSWER KEY

### Section 1
| Q | Answer |
|---|--------|
| Q1 | B |
| Q2 | B |
| Q3 | C — DECIMAL(5,2) stores values up to 999.99 with 2 decimal places |
| Q4 | B |
| Q5 | C |

### Section 2

**Q6:**
```sql
IF OBJECT_ID('dbo.audit_log', 'U') IS NOT NULL
    DROP TABLE dbo.audit_log;

CREATE TABLE audit_log (
    log_id           INT         IDENTITY(1,1) NOT NULL,
    action_type      VARCHAR(20) NOT NULL CHECK (action_type IN ('INSERT','UPDATE','DELETE')),
    table_name       VARCHAR(100) NOT NULL,
    performed_by     INT,
    action_timestamp DATETIME2   NOT NULL DEFAULT SYSDATETIME(),
    PRIMARY KEY (log_id),
    FOREIGN KEY (performed_by) REFERENCES employees(employee_id)
);
```

**Q7:**
```sql
-- a) Add column
ALTER TABLE employees
ADD COLUMN certification_number VARCHAR(50);

-- b) Rename it
ALTER TABLE employees
EXEC sp_rename 'dbo.employees.certification_number', 'cert_id', 'COLUMN';
```

**Q8:**
```sql
CREATE OR ALTER VIEW vw_active_mine_staff AS
SELECT
    CONCAT(e.first_name, ' ', e.last_name)  AS full_name,
    e.job_title,
    d.department_name,
    m.mine_name,
    m.mine_type
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN mines m       ON e.mine_id       = m.mine_id
WHERE e.is_active = 1;
```

### Section 3 — Q9

Any 5 of the following (1 mark each):

1. **Always name SELECT columns explicitly** (avoid SELECT *) — prevents issues when table schema changes; reduces unnecessary data transfer; protects sensitive columns in production
2. **Use WHERE with every UPDATE/DELETE** — prevents accidental bulk data changes that affect all rows
3. **Use transactions (START TRANSACTION/COMMIT/ROLLBACK) for bulk DML** — allows reverting mistakes before committing
4. **Use meaningful, consistent naming conventions** (snake_case, descriptive names) — improves maintainability and readability for team members
5. **Add IF NOT EXISTS to CREATE TABLE / IF EXISTS to DROP** — prevents errors when scripts are re-run
6. **Add appropriate indexes on FK and frequently searched columns** — improves query performance on large datasets
7. **Use appropriate data types** (DECIMAL for money, not FLOAT) — prevents rounding errors in financial calculations
8. **Add comments to complex queries** — helps other developers (and your future self) understand the logic
9. **Always parenthesise OR conditions in WHERE** — prevents logical errors due to operator precedence
10. **Check with SELECT before UPDATE/DELETE** — verify affected rows match your expectation

---

*Assessment — Day 2 Topic 04 — End of Course — Assmang SQL100*

