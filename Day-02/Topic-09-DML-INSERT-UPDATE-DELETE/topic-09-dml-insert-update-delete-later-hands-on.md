# Later Hands-On — Day 2 Topic 03: DML
## Assmang Pty Ltd SQL100 | Independent Practice

---

**Ex 1.** Insert a new mine into the `mines` table: "Hotazel Mine", Manganese, Northern Cape, operational=1, established_year=2025. Verify it was inserted.

**Ex 2.** Insert a new equipment record for Black Rock Mine (mine_id=3). Create a `Haul Truck` from `Bell`, model `B60E`, purchased today at R11,500,000, status Active. Use equipment_code `BRK-TR-003`.

**Ex 3.** The Equipment Department has corrected a purchase price. Update equipment `KHU-TR-001`'s purchase_price from R14,500,000 to R15,200,000. Use a transaction. Verify before and after.

**Ex 4.** The Safety Manager (Lindiwe Mthembu, employee_id=17) has been promoted. Update her salary to R92,000 and job_title to 'Head of Safety'. Verify the change.

**Ex 5.** Give all employees who have been at Assmang for MORE than 10 years a 3% loyalty increase. Use DATEDIFF to calculate tenure. Show count affected before applying.

**Ex 6.** Francois Du Toit (employee_id=31) has left the company. Mark him as inactive (is_active = 0) — do NOT delete him. Show his record before and after.

**Ex 7.** Delete all equipment records marked 'Retired' from the equipment table. Verify count before and after.

**Ex 8.** Using a transaction with ROLLBACK: Practice intentionally rolling back a change. Update Werner Fourie's salary to R999,999 → verify → ROLLBACK → verify the rollback worked.

---

## Answer Key

**Ex 1.**
```sql
INSERT INTO mines (mine_name, mine_type, province, operational, established_year)
VALUES ('Hotazel Mine', 'Manganese', 'Northern Cape', 1, 2025);
SELECT * FROM mines WHERE mine_name = 'Hotazel Mine';
```

**Ex 2.**
```sql
INSERT INTO equipment (equipment_code, equipment_type, manufacturer, model,
    mine_id, purchase_date, purchase_price, status)
VALUES ('BRK-TR-003', 'Haul Truck', 'Bell', 'B60E',
    3, CAST(GETDATE() AS date), 11500000.00, 'Active');
SELECT * FROM equipment WHERE equipment_code = 'BRK-TR-003';
```

**Ex 3.**
```sql
START TRANSACTION;
SELECT purchase_price FROM equipment WHERE equipment_code = 'KHU-TR-001';
UPDATE equipment SET purchase_price = 15200000.00
WHERE equipment_code = 'KHU-TR-001';
SELECT purchase_price FROM equipment WHERE equipment_code = 'KHU-TR-001';
COMMIT;
```

**Ex 4.**
```sql
SELECT job_title, salary_zar FROM employees WHERE employee_id = 17;
UPDATE employees
SET salary_zar = 92000.00, job_title = 'Head of Safety'
WHERE employee_id = 17;
SELECT job_title, salary_zar FROM employees WHERE employee_id = 17;
```

**Ex 5.**
```sql
-- Check who qualifies (tenure > 10 years)
SELECT COUNT(*) AS qualifying_employees
FROM employees
WHERE DATEDIFF(YEAR, hire_date, GETDATE()) > 10
  AND is_active = 1;

-- Apply increase
UPDATE employees
SET salary_zar = ROUND(salary_zar * 1.03, 2)
WHERE DATEDIFF(YEAR, hire_date, GETDATE()) > 10
  AND is_active = 1;
```

**Ex 6.**
```sql
SELECT employee_id, first_name, last_name, is_active FROM employees WHERE employee_id = 31;
UPDATE employees SET is_active = 0 WHERE employee_id = 31;
SELECT employee_id, first_name, last_name, is_active FROM employees WHERE employee_id = 31;
```

**Ex 7.**
```sql
SELECT COUNT(*) FROM equipment WHERE status = 'Retired';
DELETE FROM equipment WHERE status = 'Retired';
SELECT COUNT(*) FROM equipment;
```

**Ex 8.**
```sql
START TRANSACTION;
SELECT salary_zar FROM employees WHERE first_name='Werner' AND last_name='Fourie';
UPDATE employees SET salary_zar = 999999.00
WHERE first_name = 'Werner' AND last_name = 'Fourie';
SELECT salary_zar FROM employees WHERE first_name='Werner' AND last_name='Fourie';
ROLLBACK;
SELECT salary_zar FROM employees WHERE first_name='Werner' AND last_name='Fourie';
-- Should be back to 135000.00
```

---

*End of Later Hands-On — Day 2 Topic 03*

