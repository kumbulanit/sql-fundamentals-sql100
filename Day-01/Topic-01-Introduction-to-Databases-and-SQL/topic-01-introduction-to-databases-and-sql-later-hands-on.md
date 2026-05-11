# Later Hands-On Exercises — Topic 01
## Introduction to Databases & SQL
### Assmang Pty Ltd SQL100 | Day 1 Take-Home / Independent Practice

---

**Instructions:**  
These exercises are designed to be completed independently — after the session, at home, or as revision before Day 2. All answers use the `assmang_training` database (v1 dataset).

---

## Section A: Conceptual Questions

Answer the following WITHOUT using SQL — from memory or your notes:

**A1.** List THREE problems that arise when storing employee data in Excel instead of a database.

**A2.** Match each SQL sublanguage to its command:

| Sublanguage | Commands |
|-------------|---------|
| a) DQL | ___ |
| b) DML | ___ |
| c) DDL | ___ |
| d) TCL | ___ |

Commands to match: `SELECT`, `INSERT / UPDATE / DELETE`, `CREATE / ALTER / DROP`, `COMMIT / ROLLBACK`

**A3.** What is the difference between a Primary Key and a Foreign Key? Give a real example from the Assmang database.

**A4.** Name TWO popular RDBMS systems used in enterprise environments and state one advantage of each.

**A5.** True or False:
- a) SQL is case-sensitive for keywords: _______
- b) A Foreign Key can be NULL in some cases: _______
- c) SQL can only be used to retrieve data: _______
- d) Two rows in a table can have the same Primary Key value: _______

---

## Section B: Exploration Exercises

Use DBeaver and the `assmang_training` database to answer:

**B1.** Run `DESC mines;` — How many columns does the `mines` table have? List them.

**B2.** Run `SHOW TABLES;` — How many tables are in the v1 dataset?

**B3.** Which column in the `employees` table links an employee to their manager?

**B4.** What are the possible values for `mine_type` in the `mines` table? (Hint: Use `SELECT * FROM mines`)

**B5.** How many employees have a `mine_id` value of NULL? (Hint: These work from Head Office)
```sql
-- Try writing this query yourself:
SELECT _____ FROM _____ WHERE _____ IS _____;
```

---

## Section C: SQL Syntax Exercises

Write and execute the following:

**C1.** Write a query that displays the current date and time using SQL Server's built-in function:
```sql
SELECT NOW() AS current_datetime;
```
Run it and note the result.

**C2.** Write a query that displays a greeting message:
```sql
SELECT 'Hello from Assmang SQL Training!' AS welcome_message;
```

**C3.** What happens if you run this query? Why?
```sql
SELECT * FROM Employees;
```
(Hint: Try it — then try `SELECT * FROM employees;` — note the case of the table name)

**C4.** Fix the errors in this SQL statement:
```sql
sELECT * fRoM employeees
```

**C5.** Write a query to show the SQL Server version and today's date in the same result:
```sql
-- Expected columns: sql_server_version | today
SELECT ______ AS sql_server_version, ______ AS today;
```

---

## Section D: Research Questions

Complete without a computer (use your theory notes):

**D1.** Assmang has mines in Northern Cape, Limpopo, and Mpumalanga. If each mine produces thousands of equipment records and millions of production records per year — which type of database (relational or NoSQL) makes most sense? Justify your answer.

**D2.** Draw (by hand) a simple ER diagram showing the relationship between `employees` and `departments`. Label the Primary Key and Foreign Key.

**D3.** What does "referential integrity" mean? Give an example of what could go wrong without it in the Assmang database.

---

## Answer Key

### Section A
**A1.** Any three of: data duplication, no concurrent access, no relationships between data, poor security, hard to query/filter, no audit trail, file size limitations

**A2.** a=SELECT, b=INSERT/UPDATE/DELETE, c=CREATE/ALTER/DROP, d=COMMIT/ROLLBACK

**A3.** PK uniquely identifies each row in a table. FK references a PK in another table to create a relationship. Example: `employees.department_id` (FK) → `departments.department_id` (PK)

**A4.** Any two of: SQL Server (deep Windows/Microsoft integration), PostgreSQL (advanced features, excellent compliance), Oracle (enterprise-grade, strong security), MySQL (open source, free, widely supported)

**A5.** a=False, b=True (nullable FKs allowed), c=False (DML and DDL change data/structure), d=False

### Section B
**B1.** 6 columns: mine_id, mine_name, mine_type, province, operational, established_year

**B2.** 3 tables: departments, employees, mines

**B3.** `manager_id` — self-referencing FK to `employee_id`

**B4.** Iron Ore, Manganese, Chrome

**B5.**
```sql
SELECT COUNT(*) FROM employees WHERE mine_id IS NULL;
-- Expected: 13 (Head Office employees)
```

### Section C
**C3.** SQL Server treats identifiers according to the database collation. Best practice: always use exact object names and casing consistently.

**C4.** `SELECT * FROM employees;`

**C5.** `SELECT @@VERSION AS sql_server_version, CAST(GETDATE() AS date) AS today;`

### Section D
**D1.** Relational database — the data is highly structured (fixed columns: mine, equipment type, tonnage, date), consistent schema, requires joins between tables (equipment → mine → production), needs reporting queries.

**D3.** Referential integrity = the rule that a FK value must match an existing PK. Without it, you could assign an employee to `department_id = 99` which doesn't exist — creating "orphan" records with no valid link.

---

*End of Later Hands-On 01 — Discuss answers in the Day 2 morning review*

