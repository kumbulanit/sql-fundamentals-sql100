# Topic 01 — Introduction to Databases & SQL
## Day 1 | Assmang Pty Ltd SQL100 Training

---

## 🎯 Learning Objectives

By the end of this topic, participants will be able to:
1. Explain what a database is and why organisations use them
2. Describe the difference between a relational and non-relational database
3. Identify the key components of a relational database (tables, rows, columns, keys)
4. Explain what SQL is and name its sublanguages
5. Connect to the Assmang training database and run a first query

---

## Beginner Visual Map (Layman Version)

Think of a database like a well-organized warehouse: each shelf has a label, each box has a purpose, and you can find things quickly.

![Database visual](../../assets/images/sql-database-logo.png)

```mermaid
flowchart LR
  A[Business event happens] --> B[Data is captured]
  B --> C[Stored in database tables]
  C --> D[SQL asks questions]
  D --> E[Useful report or decision]
```

## 1. What Is a Database?

A **database** is an organised collection of structured data stored and accessed electronically.

Without a database, Assmang would store data in:
- Spreadsheets (Excel)
- Paper files
- Emails

**Problems with unstructured storage:**

| Problem | Example |
|---------|---------|
| Duplication | Employee JVNIEKERK entered twice with different spellings |
| No relationships | Cannot link an employee to their mine in a spreadsheet without complex formulas |
| No simultaneous access | Only one person can edit the Excel file at a time |
| No security | Anyone with file access sees everything |
| Hard to query | Finding "all drillers hired after 2018" requires manual filtering |

A **Database Management System (DBMS)** solves these problems by providing:
- Organised storage (tables)
- Relationships between data
- Multi-user access with security
- Powerful querying language (SQL)

---

## 2. Relational vs. Non-Relational Databases

### Relational Database (RDBMS)
- Stores data in **tables** (rows and columns)
- Tables are **related** to each other via keys
- Uses **SQL** to interact with data
- Best for: structured, consistent data (HR, finance, production records)

```
┌─────────────────────────────────┐      ┌──────────────────────────────┐
│         employees               │      │         departments          │
├──────┬───────────┬──────────────┤      ├───────────┬──────────────────┤
│  id  │   name    │ department_id│      │    id     │  department_name │
├──────┼───────────┼──────────────┤      ├───────────┼──────────────────┤
│  1   │ J Van N.  │     2        │──────│     2     │ Mining Operations│
│  2   │ N Dlamini │     1        │──┐   │     1     │ Human Resources  │
└──────┴───────────┴──────────────┘  └───┘           └──────────────────┘
                    ↑                                          ↑
             Foreign Key                               Primary Key
```

**Popular RDBMS:**
| System | Used By |
|--------|---------|
| MySQL | Web apps, medium enterprise |
| PostgreSQL | Complex analytics, open source |
| Microsoft SQL Server | Large enterprise, Microsoft ecosystem |
| Oracle Database | Large enterprise, ERP systems |
| SQLite | Embedded, mobile apps |

### Non-Relational Database (NoSQL)
- Stores data as documents, key-value pairs, graphs, or columns
- No fixed schema (flexible structure)
- Best for: unstructured data, big data, real-time apps

| Type | Example | Use Case |
|------|---------|----------|
| Document | MongoDB | Content management |
| Key-Value | Redis | Caching, sessions |
| Column | Cassandra | Time-series data |
| Graph | Neo4j | Social networks |

> **For Assmang:** All operational data (employees, production, equipment) is highly structured → **RDBMS is the right choice.**

---

## 3. Key Concepts: Tables, Rows, Columns

```
TABLE: employees
┌─────────────┬────────────┬───────────┬────────────────┬────────────┐
│ employee_id │ first_name │ last_name │   job_title    │salary_zar  │
├─────────────┼────────────┼───────────┼────────────────┼────────────┤
│      1      │   Nomsa    │  Dlamini  │  HR Manager    │ 75000.00   │ ← ROW (record/tuple)
│      2      │   Thabo    │  Mokoena  │  HR Officer    │ 38000.00   │
│      3      │ Sibongile  │  Khumalo  │ Recruitment Sp.│ 42000.00   │
└─────────────┴────────────┴───────────┴────────────────┴────────────┘
       ↑              ↑
    COLUMN          COLUMN
  (attribute)     (attribute)
```

| Term | Description | Analogy |
|------|-------------|---------|
| **Table** | A collection of related data | Spreadsheet tab |
| **Row** (Record/Tuple) | One instance of data in the table | One spreadsheet row |
| **Column** (Field/Attribute) | A specific piece of information | Spreadsheet column header |
| **Cell** | The intersection of a row and column | A single spreadsheet cell |
| **Schema** | The structure / blueprint of the database | The template of all tabs |

---

## 4. Primary Keys and Foreign Keys

### Primary Key (PK)
- **Uniquely identifies** each row in a table
- Cannot be NULL
- Cannot be duplicated
- Usually a number that auto-increments

```
employees table:
employee_id   first_name   last_name
    1    ←PK  Nomsa        Dlamini
    2    ←PK  Thabo        Mokoena
    3    ←PK  Sibongile    Khumalo
```

### Foreign Key (FK)
- A column in one table that **references** the Primary Key of another table
- Creates a **relationship** between two tables
- Enforces **referential integrity** (you cannot assign an employee to a department that doesn't exist)

```
departments table:              employees table:
department_id  dept_name        employee_id  name       department_id
     1    ←PK  Human Resources      1        Nomsa   →FK→    1
     2    ←PK  Mining Ops           4        Johan   →FK→    2
```

### Types of Relationships

| Type | Description | Example |
|------|-------------|---------|
| One-to-Many | One record links to many in another table | One department → many employees |
| Many-to-Many | Many records link to many in another table | Many employees → many training courses |
| One-to-One | One record links to exactly one in another | One employee → one ID card |

---

## 5. What Is SQL?

**SQL** = Structured Query Language

- Pronounced: "S-Q-L" or "sequel"
- The **standard language** for communicating with relational databases
- First developed by IBM in the 1970s
- Now an ISO/ANSI standard (SQL:2023 is the latest revision)
- Used by MySQL, PostgreSQL, SQL Server, Oracle — with minor dialect differences

SQL allows you to:
- **Ask questions** of data: "Show me all employees earning more than R60,000"
- **Add data**: "Record this new employee"
- **Change data**: "Update the salary for employee 5"
- **Delete data**: "Remove this retired equipment record"
- **Define structure**: "Create the employees table"

---

## 6. SQL Sublanguages

SQL is divided into sublanguages by purpose:

```
SQL
├── DQL — Data Query Language
│   └── SELECT                  (retrieve data)
├── DML — Data Manipulation Language
│   ├── INSERT                  (add rows)
│   ├── UPDATE                  (change rows)
│   └── DELETE                  (remove rows)
├── DDL — Data Definition Language
│   ├── CREATE                  (create tables, databases, views)
│   ├── ALTER                   (modify table structure)
│   ├── DROP                    (delete tables/databases)
│   └── TRUNCATE                (empty all rows from a table)
├── DCL — Data Control Language
│   ├── GRANT                   (give permissions)
│   └── REVOKE                  (remove permissions)
└── TCL — Transaction Control Language
    ├── COMMIT                  (save changes permanently)
    ├── ROLLBACK                (undo uncommitted changes)
    └── SAVEPOINT               (mark a point to roll back to)
```

> **This course covers:** DQL (Day 1 & 2), DML (Day 2 Topic 3), DDL (Day 2 Topic 4)

---

## 7. The Assmang Training Database

For this course, we use `assmang_training` — a database modelled on Assmang's operations:

```
assmang_training database
├── departments          (8 rows)  — HR, Mining, Engineering, etc.
├── mines                (6 rows)  — Beeshoek, Khumani, Black Rock...
├── employees           (31 rows)  — Staff across all operations
├── equipment           (20 rows)  — Trucks, excavators, drills
├── production_monthly  (54 rows)  — Monthly production data 2023
├── maintenance_log     (15 rows)  — Equipment service records
└── training_register   (18 rows)  — Employee training history
```

### Entity Relationship Diagram

```
┌─────────────┐        ┌──────────────┐        ┌────────────────┐
│ departments │        │   employees  │        │     mines      │
│─────────────│        │──────────────│        │────────────────│
│ department_id│◄──────│ department_id│        │ mine_id        │
│ department_  │  FK   │ employee_id  │──FK───►│ mine_name      │
│   name      │        │ first_name   │        │ mine_type      │
│ location    │        │ last_name    │        │ province       │
│ budget_zar  │        │ job_title    │        └────────┬───────┘
└─────────────┘        │ salary_zar   │                 │
                       │ hire_date    │                 │
                       │ manager_id   │◄──(self join)   │
                       └──────────────┘                 │
                                                        │
                       ┌──────────────┐◄───────────────┤
                       │   equipment  │        FK       │
                       │──────────────│                 │
                       │ equipment_id │                 │
                       │ mine_id      │                 │
                       │ equipment_   │                 │
                       │   type       │        ┌────────┴──────────────┐
                       └──────────────┘        │  production_monthly   │
                                               │ ─────────────────── ──│
                                               │ production_id         │
                                               │ mine_id               │
                                               │ tonnes_mined          │
                                               │ revenue_zar           │
                                               └───────────────────────┘
```

---

## 8. SQL Syntax Basics

### Case Sensitivity
```sql
-- SQL keywords are NOT case-sensitive:
SELECT * FROM employees;    -- works
select * from employees;    -- also works
Select * From Employees;    -- also works

-- Convention: UPPERCASE for SQL keywords for readability
SELECT * FROM employees;    -- ✅ best practice
```

### Statements & Semicolons
```sql
-- Each SQL statement ends with a semicolon (;)
SELECT * FROM employees;    -- one statement
SELECT * FROM mines;        -- another statement
```

### Comments
```sql
-- This is a single-line comment

/*
   This is a
   multi-line comment
*/

SELECT first_name   -- inline comment on a column
FROM employees;
```

### SQL is Declarative
SQL tells the database **WHAT** you want, not **HOW** to get it:
```sql
-- You say: "Give me all employees from Mining Operations"
SELECT first_name, last_name
FROM employees
WHERE department_id = 2;

-- The database figures out HOW to retrieve that data optimally
```

---

## 9. Connecting to the Training Database

After loading `v1_assmang_setup.sql`, verify your connection:

```sql
-- Step 1: Select the database
USE assmang_training;

-- Step 2: List all tables
SHOW TABLES;

-- Step 3: Run your very first query
SELECT * FROM departments;

-- Step 4: Confirm employee count
SELECT COUNT(*) AS total_employees FROM employees;
-- Expected result: 31
```

---

## ⚠️ Common Beginner Mistakes

| Mistake | Example | Fix |
|---------|---------|-----|
| Missing semicolon | `SELECT * FROM employees` | Add `;` at end |
| Wrong table name | `SELECT * FROM employee` | Check with `SHOW TABLES` |
| Case errors in data | Comparing `'hr'` vs `'HR'` | Use `LOWER()` or exact case |
| Forgetting `USE` | Query runs on wrong database | Always start with `USE assmang_training;` |

---

## 📌 Key Terms Summary

| Term | Definition |
|------|------------|
| Database | Organised collection of structured data |
| RDBMS | Software that manages relational databases (MySQL, SQL Server) |
| Table | A 2D structure of rows and columns |
| Row / Record | One data entry in a table |
| Column / Field | One attribute/property in a table |
| Primary Key | Unique identifier for each row |
| Foreign Key | Column that links to another table's PK |
| SQL | Standard language to interact with relational databases |
| DDL | SQL commands that define structure (CREATE, ALTER, DROP) |
| DML | SQL commands that modify data (INSERT, UPDATE, DELETE) |
| DQL | SQL commands that retrieve data (SELECT) |

---

## 📚 Further Reading
- MySQL Documentation: https://dev.mysql.com/doc/
- W3Schools SQL Tutorial: https://www.w3schools.com/sql/
- SQL ISO Standard: https://www.iso.org/standard/76583.html

