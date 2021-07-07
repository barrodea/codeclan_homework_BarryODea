--MVP
--Q1 (a)
--Find the first name, last name and team name of employees who are members of teams.

SELECT
	ee.first_name,
	ee.last_name,
	t.name AS team_name
FROM employees as ee LEFT JOIN teams as t 
	ON ee.team_id = t.id;
	

--Q1 (b)
-- Find the first name, last name and team name of employees who are members of teams and are enrolled in the pension scheme.
SELECT
	ee.first_name,
	ee.last_name,
	t.name AS team_name
FROM employees as ee LEFT JOIN teams as t 
	ON ee.team_id = t.id
WHERE ee.pension_enrol = TRUE;

--Q1 (c)
--Find the first name, last name and team name of employees who are members of teams, where their team has a charge cost greater than 80
SELECT
	ee.first_name,
	ee.last_name,
	t.name AS team_name,
	t.charge_cost
FROM employees as ee LEFT JOIN teams as t 
	ON ee.team_id = t.id
WHERE CAST(t.charge_cost AS INT4) >= 80;

--Q2 (a)
--  Get a table of all employees details, together with their local_account_no and local_sort_code, if they have them.
SELECT 
	ee.*,
	pd.local_account_no,
	pd.local_sort_code
FROM employees AS ee LEFT JOIN pay_details AS pd
	ON ee.pay_detail_id = pd.id;

--Q2 (b)
--Amend your query above to also return the name of the team that each employee belongs to.

SELECT 
	ee.*,
	pd.local_account_no,
	pd.local_sort_code,
	t.name AS team_name
FROM employees AS ee LEFT JOIN pay_details AS pd
	ON ee.pay_detail_id = pd.id
	LEFT JOIN teams as t 
	ON ee.team_id = t.id;
	
--Q3 (a)
-- Make a table, which has each employee id along with the team that employee belongs to.
SELECT
	ee.id,
	t.name AS team_name
FROM employees AS ee INNER JOIN teams AS t
	ON ee.team_id = t.id;
	
--Q3 (b)
--Breakdown the number of employees in each of the teams.
SELECT	
	t.name AS team_name,
	COUNT(ee.id) AS num_emplyees
FROM employees AS ee INNER JOIN teams AS t
	ON ee.team_id = t.id
GROUP BY t.name;

--Q3(c)
-- Order the table above by so that the teams with the least employees come first.
SELECT	
	t.name AS team_name,
	COUNT(ee.id) AS num_employees
FROM employees AS ee INNER JOIN teams AS t
	ON ee.team_id = t.id
GROUP BY t.name
ORDER BY num_employees;

--Q4 (a)
-- Create a table with the team id, team name and the count of the number of employees in each team
SELECT 
	t.id,
	t.name AS team_name,
	COUNT(ee.id) AS num_employees
FROM teams AS t LEFT JOIN employees AS ee
	ON t.id = ee.team_id
GROUP BY t.id
ORDER BY t.id;	

--Q4 (b)
-- The total_day_charge of a team is defined as the charge_cost of the team multiplied by the number of employees in the team. Calculate the total_day_charge for each team.

SELECT 
	t.id,
	t.name AS team_name,
	COUNT(ee.id)*CAST(t.charge_cost AS INT4) AS total_day_charge
FROM teams AS t LEFT JOIN employees AS ee
	ON t.id = ee.team_id
GROUP BY t.id
ORDER BY t.id;	

--Q4 (c)
--How would you amend your query from above to show only those teams with a total_day_charge greater than 5000
SELECT 
	t.id,
	t.name AS team_name,
	COUNT(ee.id)*CAST(t.charge_cost AS INT4) AS total_day_charge
FROM teams AS t LEFT JOIN employees AS ee
	ON t.id = ee.team_id
GROUP BY t.id
HAVING COUNT(ee.id)*CAST(t.charge_cost AS INT4) > 5000
ORDER BY total_day_charge DESC;
