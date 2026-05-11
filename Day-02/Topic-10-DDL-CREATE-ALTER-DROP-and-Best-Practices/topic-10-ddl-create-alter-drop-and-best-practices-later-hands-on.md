# Later Hands-On & Assessment — Day 2 Topic 04: DDL & Best Practices
## Assmang Pty Ltd SQL100

---

## Later Hands-On Exercises

**Ex 1.** Create a table called `incident_log` for Assmang's safety department. Include: incident_id (PK, identity), mine_id (FK), reported_by (FK to employees), incident_date, incident_type (use a CHECK constraint for 'Near Miss','Minor Injury','Major Injury','Fatality'), description, is_resolved (BIT, default 0). Verify with `sp_help` or a column query.

**Ex 2.** Add a `severity_score` column (TINYINT, 1-5) to incident_log using ALTER TABLE. Set a DEFAULT of 1.

**Ex 3.** Create a view called `vw_mine_equipment_summary` that shows each mine's name, total equipment count, active equipment count, and total investment. Test it.

**Ex 4.** Create a view called `vw_employee_service_report` that shows each active employee's name, department, site, hire date, and years of service (calculated). Sort by years_service descending.

**Ex 5.** Write a CREATE TABLE statement for a `leave_requests` table: leave_id PK, employee_id FK, leave_type VARCHAR(50), start_date DATE, end_date DATE, status enforced with a CHECK constraint and default 'Pending', approved_by INT (FK to employees, nullable).

---

## Answer Key

**Ex 1.**
```sql
IF OBJECT_ID('dbo.incident_log', 'U') IS NOT NULL
    DROP TABLE dbo.incident_log;

CREATE TABLE incident_log (
    incident_id     INT             IDENTITY(1,1) NOT NULL,
    mine_id         INT             NOT NULL,
    reported_by     INT             NOT NULL,
    incident_date   DATE            NOT NULL,
    incident_type   VARCHAR(20)     NOT NULL CHECK (incident_type IN ('Near Miss','Minor Injury','Major Injury','Fatality')),
    description     TEXT,
    is_resolved     BIT             NOT NULL DEFAULT 0,
    created_at      DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    PRIMARY KEY (incident_id),
    FOREIGN KEY (mine_id)      REFERENCES mines(mine_id),
    FOREIGN KEY (reported_by)  REFERENCES employees(employee_id)
);
EXEC sp_help 'dbo.incident_log';
```

**Ex 2.**
```sql
ALTER TABLE incident_log
ADD severity_score TINYINT NOT NULL DEFAULT 1;
EXEC sp_help 'dbo.incident_log';
```

**Ex 3.**
```sql
CREATE OR ALTER VIEW vw_mine_equipment_summary AS
SELECT
    m.mine_name,
    m.mine_type,
    COUNT(eq.equipment_id)                                      AS total_equipment,
    SUM(CASE WHEN eq.status = 'Active' THEN 1 ELSE 0 END)      AS active_count,
    COALESCE(SUM(eq.purchase_price), 0)                        AS total_investment
FROM mines m
LEFT JOIN equipment eq ON m.mine_id = eq.mine_id
GROUP BY m.mine_id, m.mine_name, m.mine_type;

SELECT * FROM vw_mine_equipment_summary ORDER BY total_investment DESC;
```

**Ex 4.**
```sql
CREATE OR ALTER VIEW vw_employee_service_report AS
SELECT
    CONCAT(e.first_name, ' ', e.last_name)            AS employee,
    d.department_name,
    COALESCE(m.mine_name, 'Head Office')              AS site,
    e.hire_date,
    DATEDIFF(YEAR, e.hire_date, GETDATE())           AS years_service
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
LEFT  JOIN mines m       ON e.mine_id       = m.mine_id
WHERE e.is_active = 1
ORDER BY years_service DESC;

SELECT * FROM vw_employee_service_report;
```

**Ex 5.**
```sql
IF OBJECT_ID('dbo.leave_requests', 'U') IS NOT NULL
    DROP TABLE dbo.leave_requests;

CREATE TABLE leave_requests (
    leave_id        INT             IDENTITY(1,1) NOT NULL,
    employee_id     INT             NOT NULL,
    leave_type      VARCHAR(50)     NOT NULL,
    start_date      DATE            NOT NULL,
    end_date        DATE            NOT NULL,
    status          VARCHAR(20)     NOT NULL DEFAULT 'Pending' CHECK (status IN ('Pending','Approved','Rejected')),
    approved_by     INT,
    created_at      DATETIME2       NOT NULL DEFAULT SYSDATETIME(),
    PRIMARY KEY (leave_id),
    FOREIGN KEY (employee_id)   REFERENCES employees(employee_id),
    FOREIGN KEY (approved_by)   REFERENCES employees(employee_id)
);
```

---

*End of Later Hands-On — Day 2 Topic 04*

