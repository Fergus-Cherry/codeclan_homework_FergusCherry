-- MVP
-- 1
SELECT *
FROM employees 
WHERE department = 'Human Resources';

-- 2
SELECT first_name, last_name, country
FROM employees 
WHERE department = 'Legal';

-- 3
SELECT count(*) AS count_portuguese 
FROM employees 
WHERE country = 'Portugal';

-- 4
SELECT count(*) AS count_portuguese_or_spanish
FROM employees 
WHERE country = 'Portugal' OR country = 'Spain';

-- 5
SELECT count(*) AS missing_account_no
FROM pay_details 
WHERE local_account_no IS NULL;

-- 6
SELECT count(*) AS missing_account_iban
FROM pay_details 
WHERE local_account_no IS NULL AND iban IS NULL;
-- answer, no

-- 7
SELECT first_name, last_name, country
FROM employees 
ORDER BY last_name NULLS LAST;

-- 8
SELECT first_name, last_name, country
FROM employees 
ORDER BY country, last_name NULLS LAST;

-- 9
SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST
FETCH FIRST 10 ROWS WITH TIES;

--10
SELECT first_name, last_name, salary
FROM employees 
WHERE country = 'Hungary'
ORDER BY salary 
FETCH FIRST ROW WITH TIES;

--11
SELECT count(*) AS name_starts_with_f
FROM employees 
WHERE first_name ILIKE 'f%';

--12
SELECT *
FROM employees 
WHERE email ~* '@yahoo';

--13
SELECT count(*) AS pension_exc_fr_ger
FROM employees 
WHERE pension_enrol = TRUE
	AND NOT (country = 'Germany' OR country = 'France');
	
--14
SELECT max(salary) AS max_full_time_eng
FROM employees 
WHERE fte_hours = 1 AND department = 'Engineering';

--15
SELECT first_name, last_name, fte_hours, salary, 
	fte_hours * salary AS effective_yearly_salary
FROM employees;

-- Extension
--16
SELECT concat(first_name, ' ', last_name, ' - ', department) AS badge_label
FROM employees
WHERE NOT (first_name IS NULL OR last_name IS NULL OR department IS null);

--17
SELECT concat(first_name, ' ', last_name, ' - ', department,
	' (joined ', to_char(start_date, 'FMMonth'), ' ', 
	EXTRACT(YEAR FROM start_date), ')') AS badge_label
FROM employees
WHERE NOT (first_name IS NULL 
	OR last_name IS NULL 
	OR department IS NULL
	OR start_date IS NULL);
	
--18
SELECT first_name, last_name, salary, 
	CASE 
		WHEN salary < 40000 THEN 'low'
		WHEN salary >= 40000 THEN 'high'
		WHEN salary IS NULL THEN 'N/A'
	END
	AS salary_class
FROM employees;