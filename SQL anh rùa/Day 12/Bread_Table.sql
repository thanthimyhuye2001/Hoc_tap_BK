
CREATE TABLE bread_table (
    bread_id INT,
    bread_name VARCHAR(255)
);

INSERT INTO bread_table (bread_id, bread_name) VALUES
(1, 'Whole Wheat'),
(2, 'White'),
(3, 'Sourdough'),
(4, 'Brioche');


SELECT bread_id, meat_id, bread_name, meat_name
FROM bread_table
CROSS JOIN meat_table
ORDER BY 3, 4;