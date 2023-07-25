-- MVP

-- 1
-- a

SELECT 
	e.first_name AS first_name,
	e.last_name AS last_name,
	t."name" AS team_name
FROM employees AS e
INNER JOIN teams AS t 
ON e.team_id = t.id;

-- b

SELECT 
	e.first_name AS first_name,
	e.last_name AS last_name,
	t."name" AS team_name
FROM employees AS e
INNER JOIN teams AS t 
ON e.team_id = t.id
WHERE e.pension_enrol = TRUE;

-- c

SELECT 
	e.first_name AS first_name,
	e.last_name AS last_name,
	t."name" AS team_name
FROM employees AS e
INNER JOIN teams AS t 
ON e.team_id = t.id
WHERE t.charge_cost::INTEGER > 80;


-- 2
-- a

SELECT e.*, pd.local_account_no, pd.local_sort_code
FROM employees AS e
LEFT JOIN pay_details AS pd
ON e.pay_detail_id = pd.id;

-- b

SELECT e.*, t."name" AS team_name, pd.local_account_no, pd.local_sort_code
FROM employees AS e
LEFT JOIN pay_details AS pd
ON e.pay_detail_id = pd.id
LEFT JOIN teams AS t
ON e.team_id = t.id;


-- 3
-- a

SELECT e.id AS employee_id, t."name" AS team
FROM employees AS e
LEFT JOIN teams AS t 
ON e.team_id = t.id;

-- b

SELECT t."name" AS team, count(*) AS num_members
FROM employees AS e
LEFT JOIN teams AS t 
ON e.team_id = t.id
GROUP BY t."name";

-- c

SELECT t."name" AS team, count(*) AS num_members
FROM employees AS e
LEFT JOIN teams AS t 
ON e.team_id = t.id
GROUP BY t."name"
ORDER BY num_members;


-- 4
-- a

SELECT t.id AS team_id, t."name" AS team_name, count(*) AS num_members
FROM teams AS t
LEFT JOIN employees AS e 
ON t.id = e.team_id
GROUP BY t.id;

-- b

SELECT t.id AS team_id, t."name" AS team_name, 
	count(*) * t.charge_cost::integer  AS total_day_charge
FROM teams AS t
LEFT JOIN employees AS e 
ON t.id = e.team_id
GROUP BY t.id;

-- c

SELECT t.id AS team_id, t."name" AS team_name, 
	count(*) * t.charge_cost::integer  AS total_day_charge
FROM teams AS t
LEFT JOIN employees AS e 
ON t.id = e.team_id
GROUP BY t.id
HAVING count(*) * t.charge_cost::integer > 5000;


-- Extension

-- 5

SELECT count(DISTINCT ec.employee_id) AS num_with_committees
FROM employees_committees AS ec;


-- 6
SELECT count(DISTINCT e.id) - count(DISTINCT ec.employee_id) AS num_without_committees
FROM employees AS e
LEFT JOIN employees_committees AS ec 
ON e.id = ec.employee_id ;