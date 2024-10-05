
CREATE TABLE stores (
    store_id INT,
    year INT,
    revenue INT
);

INSERT INTO stores (store_id, year, revenue) VALUES
(1, 2020, 1000000),
(2, 2020, 1500000),
(3, 2020, 800000),
(4, 2020, 180000),
(1, 2021, 2000000),
(2, 2021, 1800000),
(3, 2021, 1000000),
(4, 2021, 900000),
(1, 2022, 700000),
(2, 2022, 2000000),
(3, 2022, 600000),
(4, 2022, 1300000);

SELECT store_id, 
	   ROUND(AVG(revenue), 2)
FROM stores
GROUP BY store_id
Order by 1;