--MODULE CHALLENGE
--Create table 
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	titles.title,
	salaries.from_date,
	salaries.salary
INTO number_of_titles_retiring
FROM salaries
RIGHT JOIN titles
ON (salaries.emp_no = titles.emp_no)
INNER JOIN current_emp AS ce
ON (ce.emp_no = salaries.emp_no);

--Exclude the rows of data containing duplicate titles
SELECT notr.emp_no,
	notr.first_name,
	notr.last_name,
	COUNT(*) AS CNT
FROM number_of_titles_retiring as notr
GROUP BY notr.emp_no,
	notr.first_name,
	notr.last_name
HAVING COUNT(*) > 1;

--Delete duplicate rows
WITH cte as (SELECT emp_no, first_name, last_name, from_date, title, ROW_NUMBER() OVER
	 	(PARTITION BY (first_name, last_name)
	  	ORDER BY from_date DESC) rn
	  	FROM number_of_titles_retiring
	 )

SELECT emp_no, first_name, last_name, from_date, title
INTO updated_number_of_titles_retiring
FROM cte tp WHERE rn = 1
ORDER BY emp_no

--Who’s Ready for a Mentor?
SELECT emp.emp_no, emp.first_name, emp.last_name, emp.hire_date, tit.to_date, tit.title, emp.birth_date
INTO ready_to_mentor
FROM employees as emp
LEFT JOIN titles as tit
ON (emp.emp_no = tit.emp_no)
LEFT JOIN dept_emp as de
ON emp.emp_no = de.emp_no
WHERE (tit.to_date = '9999-01-01')
AND (emp.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no