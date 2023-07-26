-- MVP

-- 1
SELECT count(id)
FROM employees 
WHERE grade IS NULL AND salary IS NULL;


-- 2
SELECT department, concat(first_name, ' ', last_name)
FROM employees
ORDER BY department, last_name;


-- 3
SELECT *
FROM employees 
WHERE last_name LIKE 'A%'
ORDER BY salary DESC NULLS LAST
FETCH FIRST 10 ROWS WITH TIES;


-- 4
SELECT department, count(id) AS num_employees
FROM employees 
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY department;


-- 5
SELECT 
	department,
	fte_hours,
	count(id) OVER (PARTITION BY department, fte_hours) AS num_employees
FROM  employees
ORDER BY department, fte_hours;


-- 6
SELECT pension_enrol, count(id) AS num_employees
FROM employees 
GROUP BY pension_enrol;


-- 7
SELECT *
FROM employees
WHERE department = 'Accounting' AND pension_enrol = FALSE
ORDER BY salary DESC NULLS LAST
FETCH FIRST ROW WITH TIES;


-- 8
SELECT country, count(id) AS num_employees, avg(salary) AS avg_salary_by_dep
FROM employees 
GROUP BY country 
HAVING count(id) > 30
ORDER BY avg_salary_by_dep DESC NULLS LAST;


-- 9
SELECT first_name,
	last_name,
	fte_hours,
	salary,
	fte_hours * salary AS effective_yearly_salary
FROM employees 
WHERE fte_hours * salary > 30000;


--10
SELECT e.*
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id
WHERE t.name IN ('Data Team 1', 'Data Team 2');


--11
SELECT first_name, last_name
FROM employees AS e
INNER JOIN pay_details AS pd
ON e.pay_detail_id = pd.id
WHERE pd.local_tax_code IS NULL;


--12
SELECT 
	first_name,
	last_name,
	(48 * 35 * charge_cost::int - salary) * fte_hours AS expected_profit
FROM employees AS e
INNER JOIN teams AS t
ON e.team_id = t.id;


--13
WITH least_common_fte AS (
	SELECT fte_hours, count(id) AS num_employees
	FROM employees
	GROUP BY fte_hours
	ORDER BY num_employees
	FETCH FIRST ROW WITH TIES
)
SELECT first_name, last_name, salary
FROM employees AS e
RIGHT JOIN least_common_fte AS lcf
ON e.fte_hours = lcf.fte_hours
WHERE country = 'Japan'
ORDER BY salary
FETCH FIRST ROW WITH TIES;


--14
SELECT department
FROM employees 
GROUP BY department 
HAVING count(id) - count(first_name) > 1
ORDER BY count(id) - count(first_name), department;


--15
SELECT first_name, count(first_name) AS num_with_name
FROM employees
WHERE first_name IS NOT NULL
GROUP BY first_name
HAVING count(first_name) > 1
ORDER BY num_with_name DESC, first_name;


--16
WITH num_grade_1 AS (
	SELECT department , count(id) AS num_employees
	FROM employees
	WHERE grade = 1
	GROUP BY department
), num_each_dep AS (
	SELECT department , count(id) AS num_employees
	FROM employees
	GROUP BY department
)
SELECT
	ned.department,
	ng1.num_employees::NUMERIC  / ned.num_employees::NUMERIC AS proportion_grade_1
FROM num_each_dep AS ned
inner JOIN num_grade_1 AS ng1
ON ned.department = ng1.department;

-- using hints this time
SELECT 
	department,
	sum((grade = 1)::integer)::NUMERIC / count(id)::NUMERIC AS proportion_grade_1
FROM employees
GROUP BY department;



-- Extension

-- 1
WITH department_stats AS (
	SELECT 
		department,
		count(id) AS num_employees,
		avg(salary) AS avg_salary,
		avg(fte_hours) AS avg_fte_hours 
	FROM employees
	GROUP BY department
	ORDER BY num_employees
	FETCH FIRST ROW WITH TIES
)
SELECT 
	id, first_name, last_name, e.department, salary, fte_hours,
	salary / avg_salary AS proportion_salary_of_dep_avg,
	fte_hours / avg_fte_hours AS proportion_fte_hours_of_dep_avg
FROM employees AS e
INNER JOIN department_stats AS ds
ON e.department = ds.department;


-- 2
SELECT 
	CASE 
		WHEN pension_enrol = TRUE THEN 'Enrolled'
		WHEN pension_enrol = FALSE THEN 'Not enrolled'
		ELSE 'Unknown'
	END
	AS pension_enrollment,
	count(id) AS num_employees
FROM employees 
GROUP BY pension_enrol;


-- 3
SELECT first_name, last_name, email, start_date
FROM employees AS e
INNER JOIN employees_committees AS ec
ON e.id = ec.employee_id
INNER JOIN committees AS c
ON ec.committee_id = c.id
WHERE "name" = 'Equality and Diversity'
ORDER BY start_date;


-- 4
WITH salary_classes AS (
	SELECT id,
	CASE 
		WHEN salary < 40000 THEN 'low'
		WHEN salary >= 40000 THEN 'high'
		WHEN salary IS NULL THEN 'none'
	END AS salary_class
	FROM employees
)
SELECT sc.salary_class, count(DISTINCT sc.id)
FROM salary_classes AS sc
INNER JOIN employees_committees AS ec
ON sc.id = ec.employee_id
GROUP BY sc.salary_class;