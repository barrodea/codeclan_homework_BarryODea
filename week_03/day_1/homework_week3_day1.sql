/*MVP*/

/*Q1*/
/*Find all the employees who work in the ‘Human Resources’ department.*/
SELECT *
FROM employees 
WHERE department = 'Human Resources';


/*Q2*/
/*Get the first_name, last_name, and country of the employees who work in the ‘Legal’ department.*/
SELECT 
	first_name,
	last_name,
	country
FROM employees 
WHERE department = 'Legal';

/*Q3*/
/*Count the number of employees based in Portugal.*/
SELECT 
	COUNT(*)
FROM employees 
WHERE country = 'Portugal';


/*Q4*/
/*Count the number of employees based in either Portugal or Spain*/
SELECT 
	COUNT(*)
FROM employees 
WHERE country = 'Portugal'
OR country = 'Spain';

/*Q5*/
/*Count the number of pay_details records lacking a local_account_no*/
SELECT 
	COUNT(*)
FROM pay_details 
WHERE local_account_no IS NULL;

/*Q6*/
/*Are there any pay_details records lacking both a local_account_no and iban number*/
SELECT 
	COUNT(*)
FROM pay_details 
WHERE 
	local_account_no IS NULL 
	AND iban IS NULL;

/*Q7*/
/*Get a table with employees first_name and last_name ordered alphabetically by last_name (put any NULLs last).*/
SELECT 
	first_name,
	last_name
FROM employees 
ORDER BY last_name ASC NULLS LAST; 


/*Q8*/
/*Get a table of employees first_name, last_name and country, ordered alphabetically first by country and then by last_name (put any NULLs last).*/
SELECT 
	first_name,
	last_name,
	country 
FROM employees 
ORDER BY country ASC NULLS LAST,
	last_name ASC NULLS LAST; 

/*Q9*/
/*Find the details of the top ten highest paid employees in the corporation.*/
SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST
LIMIT 10;

/*Q10*/
/*Find the first_name, last_name and salary of the lowest paid employee in Hungary*/
SELECT 
	first_name,
	last_name 
FROM employees
WHERE country = 'Hungary'
ORDER BY salary ASC NULLS LAST
LIMIT 1;

/*Q11*/
/*How many employees have a first_name beginning with ‘F’*/
SELECT 
	COUNT (*)
FROM employees 
WHERE last_name LIKE 'F%';

/*Q12*/
/*Find all the details of any employees with a ‘yahoo’ email address?*/
SELECT *
FROM employees 
WHERE email LIKE '%yahoo%';


/*Q13*/
/*Count the number of pension enrolled employees not based in either France or Germany.*/
SELECT
	COUNT(*)
FROM employees 
WHERE pension_enrol is TRUE;

/*Q14*/
/*What is the maximum salary among those employees in the ‘Engineering’ department who work 1.0 full-time equivalent hours (fte_hours)*/
SELECT salary
FROM employees 
WHERE department = 'Engineering'
AND fte_hours = '1'
ORDER BY salary DESC NULLS LAST
LIMIT 1;

/*Q15*/
/*Return a table containing each employees first_name, last_name, full-time equivalent hours (fte_hours), salary, and a new column effective_yearly_salary which should contain fte_hours multiplied by salary.*/
SELECT
	first_name,
	last_name,
	fte_hours,
	salary,
	(fte_hours * salary) AS effective_yearly_salary
FROM employees;


/*Extension*/
/*Q16*/
/*The corporation wants to make name badges for a forthcoming conference. Return a column badge_label showing employees’ first_name and last_name joined together with their department in the following style: ‘Bob Smith - Legal’. Restrict output to only those employees with stored first_name, last_name and department.*/
SELECT 
	CONCAT(first_name, ' ', last_name, ' ', '-', ' ', department) AS badge_label
FROM employees	
WHERE 
	first_name IS NOT NULL
	AND last_name IS NOT NULL
	AND department IS NOT NULL;


/*Q17*/
SELECT 
 	CONCAT(first_name, ' ', last_name, ' ', '-', ' ', department,' ( ','joined ', TO_CHAR(start_date, 'FMMonth') ,EXTRACT(YEAR FROM start_date), ')') AS badge_label
FROM employees	
WHERE 
	first_name IS NOT NULL
	AND last_name IS NOT NULL
	AND department IS NOT NULL;


/*Q18*/
SELECT 
	first_name,
	last_name,
	salary,
	CASE
		WHEN salary < 40000 THEN 'low'
		WHEN salary >= 40000 THEN 'high'
	END AS salary_class	
FROM employees; 
