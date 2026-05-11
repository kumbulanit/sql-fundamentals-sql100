# Practical Lab 01 — Introduction to Databases & SQL
## Day 1, Topic 01 | Assmang Pty Ltd SQL100 Training

**Duration:** 45 minutes  
**Dataset:** v1_assmang_setup.sql  
**Tool:** DBeaver Community Edition + SQL Server

---

## Pre-Lab Setup

Before starting, ensure the training database is loaded:

```sql
-- Step 1: Run the setup script in DBeaver
-- File > Open SQL Script > navigate to datasets/v1_assmang_setup.sql > Run

-- Step 2: Confirm the database exists
SELECT name
FROM sys.databases
WHERE name = 'assmang_training';

-- Step 3: Select the database
USE assmang_training;

-- Step 4: Verify tables exist
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME;
```

**Expected output from table list:**
```
departments
employees
mines
```

---

## Exercise 1: Exploring the Database Structure (10 minutes)

### 1.1 — List all databases on the server
```sql
SELECT name
FROM sys.databases
ORDER BY name;
```
> **✅ Validation:** You should see `assmang_training` in the list.

### 1.2 — Select the training database
```sql
USE assmang_training;
```

### 1.3 — List all tables
```sql
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME;
```
> **✅ Validation:** Three tables should appear: `departments`, `employees`, `mines`

### 1.4 — Describe the structure of the employees table
```sql
EXEC sp_help 'employees';
```
or query the column catalog directly:
```sql
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'employees'
ORDER BY ORDINAL_POSITION;
```

> **✅ Validation:** You should see columns including `employee_id`, `first_name`, `last_name`, `job_title`, `department_id`, `mine_id`, `salary_zar`, `hire_date`, `email`, `is_active`, `manager_id`

### 1.5 — Describe the departments table
```sql
EXEC sp_help 'departments';
```

### 1.6 — Describe the mines table
```sql
EXEC sp_help 'mines';
```

---

## Exercise 2: Your First SELECT Queries (15 minutes)

### 2.1 — View all departments
```sql
SELECT * FROM departments;
```
> **✅ Validation:** 8 rows returned — HR, Mining, Engineering, Safety, Finance, IT, Logistics, Processing Plant

### 2.2 — View all mines
```sql
SELECT * FROM mines;
```
> **✅ Validation:** 6 rows returned — Beeshoek, Khumani, Black Rock, Gloria, Dwarsrivier, Machadodorp

### 2.3 — View all employees
```sql
SELECT * FROM employees;
```
> **✅ Validation:** 31 rows returned

### 2.4 — Count the records in each table
```sql
SELECT COUNT(*) AS total_departments  FROM departments;
SELECT COUNT(*) AS total_mines        FROM mines;
SELECT COUNT(*) AS total_employees    FROM employees;
```

**Expected results:**
| Query | Expected Count |
|-------|----------------|
| departments | 8 |
| mines | 6 |
| employees | 31 |

---

## Exercise 3: Understanding Table Relationships (10 minutes)

### 3.1 — Look at the department_id column in employees
```sql
SELECT employee_id, first_name, last_name, department_id
FROM employees
ORDER BY employee_id
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
```
> **Question:** What does the `department_id` value represent?
> **Answer:** It is a Foreign Key linking each employee to a row in the `departments` table.

### 3.2 — Look at the primary keys
```sql
-- departments PK
SELECT department_id, department_name FROM departments;

-- mines PK
SELECT mine_id, mine_name FROM mines;

-- employees PK
SELECT TOP (5) employee_id, first_name, last_name FROM employees;
```

### 3.3 — Find an employee linked to a specific mine
```sql
-- First look at mines
SELECT mine_id, mine_name FROM mines;

-- Then find employees at mine_id = 3 (Black Rock Mine)
SELECT first_name, last_name, job_title, mine_id
FROM employees
WHERE mine_id = 3;
```
> **✅ Validation:** You should see employees working at Black Rock Mine (mine_id = 3)

---

## Exercise 4: SQL Syntax Practice (10 minutes)

### 4.1 — Try different cases (all should work)
```sql
SELECT * FROM departments;
select * from departments;
Select * From Departments;
```
> **Key Takeaway:** SQL keywords are case-insensitive

### 4.2 — Add a comment to your query
```sql
-- This query retrieves all Assmang departments
SELECT * FROM departments;
```

### 4.3 — Run multiple statements
```sql
USE assmang_training;
SELECT 'Welcome to Assmang SQL Training!' AS message;
SELECT CAST(GETDATE() AS date) AS todays_date;
SELECT @@VERSION AS sql_server_version;
```
> **✅ Validation:** Each statement runs independently. You should see a welcome message, today's date, and the SQL Server version number.

---

## Exercise 5: Exploration Challenge (Bonus — 5 minutes)

Try to answer these questions using only `SELECT * FROM tablename;` and `EXEC sp_help 'tablename';`:

1. Which table stores the budget for each area?
2. What column would you use to find all Chrome mines?
3. Which column in `employees` tells you if an employee is still working at Assmang?
4. What data type is `salary_zar`?
5. Which mines are currently NOT operational?

**Answers:**

1. `departments` — column: `budget_zar`
2. `mines` — column: `mine_type` where value = `'Chrome'`
3. `employees` — column: `is_active` (1 = active, 0 = inactive)
4. `DECIMAL(12,2)` — confirmed via `EXEC sp_help 'employees'` or `INFORMATION_SCHEMA.COLUMNS`
5. `mines` — `operational = 0` → Machadodorp Works

---

## Lab Completion Checklist

- [ ] Connected to SQL Server via DBeaver
- [ ] Loaded v1_assmang_setup.sql successfully
- [ ] Ran the table list query and confirmed 3 tables
- [ ] Ran `EXEC sp_help 'employees'` and identified key columns
- [ ] Retrieved all rows from all 3 tables
- [ ] Confirmed correct row counts (8 / 6 / 31)
- [ ] Understood FK relationship between employees and departments

---

*End of Practical 01*

