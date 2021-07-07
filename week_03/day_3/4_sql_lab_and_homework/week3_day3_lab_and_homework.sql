-- MVP
-- Q1 
-- Are there any pay_details records lacking both a local_account_no and iban number?

SELECT
*
FROM pay_details 
WHERE local_account_no IS NULL
	AND iban IS NULL;
	
-- Q2
-- Get a table of employees first_name, last_name and country, ordered alphabetically first by country and then by last_name (put any NULLs last).
SELECT 
	first_name,
	last_name,
	country
FROM employees 
ORDER BY country ASC NULLS LAST,
	last_name ASC NULLS LAST;
	
--Q3 
--Find the details of the top ten highest paid employees in the corporation.
SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST
LIMIT 10;

--Q4
--Find the first_name, last_name and salary of the lowest paid employee in Hungary.
SELECT 
	first_name,
	last_name
FROM employees 
WHERE country = 'Hungary'
ORDER BY salary ASC NULLS LAST
LIMIT 1;

--Q5
--Find all the details of any employees with a ‘yahoo’ email address?
SELECT
	*
FROM employees 
WHERE email LIKE '%yahoo%';

--Q6
--Obtain a count by department of the employees who started work with the corporation in 2003
SELECT
	department,
	COUNT(id) AS num_employees
FROM employees 
WHERE start_date >= '2003-01-01' AND start_date <= '2013-12-31'
GROUP BY department;

--Q7
--Obtain a table showing department, fte_hours and the number of employees in each department who work each fte_hours pattern. 
--Order the table alphabetically by department, and then in ascending order of fte_hours.

SELECT
	department,
	fte_hours,
	COUNT(id) AS num_emplayees
FROM employees 
GROUP BY department,
	fte_hours 
ORDER BY 
	department ASC NULLS LAST,
	fte_hours ASC NULLS LAST;
	
--Q8
--Provide a breakdown of the numbers of employees enrolled, not enrolled, 
--and with unknown enrollment status in the corporation pension scheme.
SELECT
	pension_enrol,
	COUNT(id) AS num_employees
FROM employees 
GROUP BY pension_enrol;

--Q9
--What is the maximum salary among those employees in the 
--‘Engineering’ department who work 1.0 full-time equivalent hours (fte_hours)?
SELECT 
	MAX(salary) AS max_salary
FROM employees 
WHERE department = 'Engineering'
	AND fte_hours = 1;

--Q10
--Get a table of country, number of employees in that country, and the average salary of employees in that country for 
--any countries in which more than 30 employees are based. Order the table by average salary descending.

SELECT
	country,
	COUNT(id) AS num_emplayees,
	AVG(salary) AS avg_salary
FROM employees 
GROUP BY country
HAVING COUNT(id) > 30
ORDER BY AVG(salary) DESC;

--Q11
--Return a table containing each employees first_name, last_name, full-time equivalent hours (fte_hours), salary, 
--and a new column effective_yearly_salary which should contain fte_hours multiplied by salary
SELECT
	first_name,
	last_name,
	fte_hours,
	salary,
	fte_hours * salary AS effective_yearly_salary
FROM employees;

--Q12
--Find the first name and last name of all employees who lack a local_tax_code.
SELECT
	e.first_name AS first_name,
	e.last_name AS last_name,
	pd.local_tax_code 
FROM employees AS e LEFT JOIN pay_details as pd
	ON e.pay_detail_id = pd.id 
WHERE pd.local_tax_code IS NULL;


--Q13
--The expected_profit of an employee is defined as (48 * 35 * charge_cost - salary) * fte_hours, where charge_cost depends upon the team to which the employee belongs. 
--Get a table showing expected_profit for each employee.
SELECT
	e.first_name AS first_name,
	e.last_name AS last_name,
	(48 * 35 * CAST(t.charge_cost AS INT) - e.salary) * e.fte_hours AS expected_profit
FROM employees AS e INNER JOIN teams AS t
	ON e.team_id = t.id;
	
--Q14
--Obtain a table showing any departments in which there are two or more employees lacking a stored first name. Order the table in descending order of the number of employees 
--lacking a first name, and then in alphabetical order by department.
SELECT
	department,
	COUNT(id) AS num_employees
FROM employees 
WHERE first_name IS NULL
GROUP BY department 
HAVING COUNT(id) > 2
ORDER BY department;


--Q15
--[Bit Tougher] Return a table of those employee first_names shared by more than one employee, together with a count of the number of times each first_name occurs. Omit employees without a stored first_name from the table. 
--Order the table descending by count, and then alphabetically by first_name.
SELECT 
	first_name,
	COUNT(id) AS num_employees
FROM employees 
WHERE first_name IS NOT NULL
GROUP BY first_name
HAVING COUNT(id) >1
ORDER BY first_name;

--Q16
--Find the proportion of employees in each department who are grade 1
SELECT 
	department,
	COUNT(id) AS num_employees,
	SUM(CAST(grade=1 AS INT)) AS grade_score,
	(SUM(CAST(grade=1 AS INT))  / CAST(COUNT(id) AS REAL)) AS employee_poportion
FROM employees
GROUP BY department;

--EXT
-- Q17
--Get a list of the id, first_name, last_name, department, salary and fte_hours of employees in the largest department. Add two extra columns showing the ratio of each employee’s salary to that department’s average salary, 
--and each employee’s fte_hours to that department’s average fte_hours

-- ANSWER NOT COMPLETE
SELECT 
	department,
	AVG(salary) AS avg_salary
FROM employees 
GROUP BY department;

SELECT 
	id,
	first_name,
	last_name,
	department,
	salary,
	fte_hours,
	COUNT(id) AS num_emplyees
From employees
WHERE (
SELECT 
COUNT(id)
FROM employees
GROUP BY department
ORDER BY COUNT(id) DESC
LIMIT 1
)
GROUP BY id 
ORDER BY Count(id);
;


-- Q18
--Have a look again at your table for MVP question 8. It will likely contain a blank cell for the row relating to employees with ‘unknown’ pension enrollment status. 
--This is ambiguous: it would be better if this cell contained ‘unknown’ or something similar. Can you find a way to do this, perhaps using a combination of COALESCE() and CAST(), or a CASE statement?
SELECT
	pension_enrol,
	COUNT(id) AS num_employees,
CASE
	WHEN pension_enrol = TRUE THEN 'TRUE'
	WHEN pension_enrol  = FALSE THEN 'FALSE'
	WHEN pension_enrol IS NULL THEN 'UNKNOWN'
	END AS pension_enrol_categoury
FROM employees 
GROUP BY pension_enrol;