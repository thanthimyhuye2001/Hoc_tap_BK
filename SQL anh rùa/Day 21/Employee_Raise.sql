
CREATE TABLE employee_raise (
    employee_id INT,
    department VARCHAR(255),
    salary INT
);

INSERT INTO employee_raise (employee_id, department, salary) VALUES
(1, 'IT', 50000),
(2, 'Sales', 11000),
(3, 'Accounting', 55000),
(4, 'IT', 65000),
(5, 'Sales', 75000),
(6, 'Accounting', 50000),
(7, 'IT', 75000),
(8, 'Accounting', 40000);

WITH cte_table AS 
(
	SELECT *, MIN(salary) OVER(PARTITION BY department) AS `MIN_salary` 
	FROM employee_raise
)
SELECT *, 
CASE  WHEN salary = MIN_salary THEN salary * 1.15 ELSE salary END as `new_salary`
FROM cte_table 
ORDER BY new_salary DESC;
    
SELECT employee_id, department, salary*1.15 FROM employee_raise WHERE salary = (SELECT *, MIN(salary) OVER(PARTITION BY department) FROM employee_raise);



CREATE TEMPORARY TABLE temp_table
SELECT *
FROM employee_raise;





