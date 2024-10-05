
CREATE TABLE desserts (
    date_sold DATE,
    product VARCHAR(255),
    amount_sold INT
);

INSERT INTO desserts (date_sold, product, amount_sold) VALUES
('2022-06-01', 'Cake', 6),
('2022-06-01', 'Pie', 18),
('2022-06-02', 'Pie', 3),
('2022-06-02', 'Cake', 2),
('2022-06-03', 'Pie', 14),
('2022-06-03', 'Cake', 15),
('2022-06-04', 'Pie', 15),
('2022-06-04', 'Cake', 6),
('2022-06-05', 'Cake', 16),
('2022-06-05', 'Pie', NULL);


SELECT * FROM day25.desserts;
SELECT * FROM temp_table_cake;
SELECT * FROM temp_table_Pie;

CREATE TEMPORARY TABLE temp_table_cake
SELECT date_sold, product as cake, amount_sold as amount_sold_cake FROM day25.desserts WHERE product = 'Cake';

CREATE TEMPORARY TABLE temp_table_Pie
SELECT date_sold, product as Pie, amount_sold as amount_sold_Pie FROM day25.desserts WHERE product = 'Pie';


SELECT first_name, last_name, email 
FROM people p 
LEFT JOIN contacts c ON p.id = c.id;

SELECT *, 
	   ABS(amount_sold_cake - COALESCE(amount_sold_Pie,0)) AS diff_amount,
       CASE
       WHEN amount_sold_cake - COALESCE(amount_sold_Pie,0) > 0 THEN 'cake' ELSE 'pie' END as 'Best_seller'
FROM temp_table_Pie p
JOIN temp_table_cake c ON p.date_sold = c.date_sold;

SELECT *
FROM salaries s
JOIN employees e
	ON s.employee_id = e.employee_id;
    
WITH CTE_table AS (
SELECT date_sold,
	   SUM( IF(product = 'Cake', amount_sold, 0)) AS amount_sold_cake, 
	   SUM( IF(product = 'Pie', amount_sold, 0)) AS amount_sold_Pie
FROM desserts
GROUP BY date_sold
ORDER BY 1
) 
SELECT  *, 
		ABS(amount_sold_cake - amount_sold_Pie) as diff_amount,
		CASE
        WHEN amount_sold_cake - amount_sold_Pie > 0 THEN 'cake' ELSE 'pie' END as `Best_seller`
FROM CTE_table;