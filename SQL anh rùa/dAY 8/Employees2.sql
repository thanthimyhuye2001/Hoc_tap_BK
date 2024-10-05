
CREATE TABLE employees2 (
    employee_id INT,
    pay_level INT,
    salary INT
);

INSERT INTO employees2 (employee_id, pay_level, salary) VALUES
(1001, 1, 75000),
(1002, 1, 85000),
(1003, 1, 60000),
(1004, 2, 95000),
(1005, 2, 95000),
(1006, 2, 85000),
(1007, 2, 105000),
(1008, 3, 300000),
(1009, 2, 105000),
(1010, 2, 95000),
(1011, 2, 115000),
(1012, 1, 85000),
(1013, 1, 75000),
(1014, 1, 60000),
(1015, 1, 75000),
(1016, 2, 85000),
(1017, 2, 105000),
(1018, 2, 95000),
(1019, 1, 75000);

SELECT
	CASE
		WHEN units_in_stock <= 20 THEN 'ORDER NOW!'
		WHEN units_in_stock BETWEEN 21 AND 50 THEN 'Check in 3 days'
		WHEN units_in_stock >= 51 THEN 'In Stock'
	END as 'Thông báo'
FROM employees2;
