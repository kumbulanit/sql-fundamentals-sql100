# Assessment — Topic 01: Introduction to Databases & SQL
## Assmang Pty Ltd SQL100 Training | Day 1

**Time allowed:** 20 minutes  
**Total marks:** 30  
**Pass mark:** 20/30 (67%)

---

## Section 1: Multiple Choice Questions (15 marks — 3 marks each)

**Q1.** Which of the following best describes a Primary Key?

A) A column that can store NULL values  
B) A column that uniquely identifies each row in a table  
C) A column that stores password information  
D) A column linking two tables together  

---

**Q2.** Assmang stores equipment records that reference which mine the equipment belongs to. The `mine_id` column in the `equipment` table is an example of a:

A) Primary Key  
B) Candidate Key  
C) Foreign Key  
D) Composite Key  

---

**Q3.** Which SQL sublanguage would you use to permanently remove a table from the database?

A) DQL  
B) DML  
C) DDL  
D) TCL  

---

**Q4.** What is the correct way to write an SQL comment?

A) `// This is a comment`  
B) `/* This is a comment */` or `-- This is a comment`  
C) `## This is a comment`  
D) `<!-- This is a comment -->`  

---

**Q5.** An HR Officer at Assmang tries to insert a new employee record with `department_id = 99`, but no department with ID 99 exists. What database principle prevents this?

A) Atomicity  
B) Referential Integrity  
C) Normalisation  
D) Data Redundancy  

---

## Section 2: True/False (10 marks — 2 marks each)

**Q6.** SQL is case-sensitive for keywords such as SELECT, FROM, and WHERE. _(True / False)_

**Q7.** A table can have more than one Primary Key column (called a composite key). _(True / False)_

**Q8.** NoSQL databases are better than relational databases for all use cases. _(True / False)_

**Q9.** The `COMMIT` command is part of TCL (Transaction Control Language). _(True / False)_

**Q10.** The `employees` table in the Assmang training database has a self-referencing Foreign Key for the manager relationship. _(True / False)_

---

## Section 3: Short Answer (5 marks)

**Q11.** List the three tables in the v1 Assmang training dataset and state the purpose of each table (one sentence per table). _(3 marks)_

**Q12.** Write the SQL command to display the structure/columns of the `mines` table. _(1 mark)_

**Q13.** In the context of the Assmang database, explain what would happen if you deleted the record `department_id = 2` (Mining Operations) from the `departments` table while employees still reference that department. _(1 mark)_

---

## ✅ ANSWER KEY — DO NOT DISTRIBUTE BEFORE ASSESSMENT

### Section 1 Answers

| Q | Answer | Explanation |
|---|--------|-------------|
| Q1 | **B** | A Primary Key uniquely identifies each row; cannot be NULL or duplicated |
| Q2 | **C** | `mine_id` in equipment references the PK in the mines table — that's a FK |
| Q3 | **C** | DDL — `DROP TABLE` removes the table structure and all data permanently |
| Q4 | **B** | SQL uses `--` for single-line and `/* */` for multi-line comments |
| Q5 | **B** | Referential Integrity ensures FK values must match existing PK values |

### Section 2 Answers

| Q | Answer | Explanation |
|---|--------|-------------|
| Q6 | **False** | SQL keywords are case-INSENSITIVE; `SELECT` = `select` = `Select` |
| Q7 | **True** | A composite primary key uses multiple columns together to ensure uniqueness |
| Q8 | **False** | Each has its use case; relational DBs are better for structured transactional data |
| Q9 | **True** | TCL includes COMMIT, ROLLBACK, SAVEPOINT |
| Q10 | **True** | `manager_id` in `employees` references `employee_id` in the same table |

### Section 3 Answers

**Q11 (3 marks):**
- `departments` — Stores information about each business unit/department at Assmang (name, location, budget)
- `mines` — Stores information about each mine/operation (name, type, province, status)
- `employees` — Stores all staff records including their department, mine assignment, salary, and hire date

**Q12 (1 mark):**
```sql
DESCRIBE mines;
-- OR --
DESC mines;
```

**Q13 (1 mark):** The delete would fail with a foreign key constraint violation error, because 12+ employees have `department_id = 2` in the employees table. The database protects referential integrity by preventing deletion of a referenced parent record.

---

### Scoring Guide

| Score | Grade | Outcome |
|-------|-------|---------|
| 27–30 | Distinction | Excellent understanding |
| 23–26 | Merit | Good understanding |
| 20–22 | Pass | Adequate understanding |
| Below 20 | Refer | Re-study required |

---

*Assessment 01 — Assmang Pty Ltd SQL100 Training Programme*

