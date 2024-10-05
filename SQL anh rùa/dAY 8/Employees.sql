
CREATE TABLE employees (
    employee_id INT,
    birth_date DATE
);

INSERT INTO employees (employee_id, birth_date) VALUES
(1, '1990-01-15'),
(2, '1995-05-22'),
(3, '2000-08-17'),
(4, '1985-12-29'),
(5, '1992-04-05'),
(6, '1998-06-30'),
(7, '1988-09-02'),
(8, '1996-11-12'),
(9, '1990-02-19'),
(10, '1993-07-10'),
(11, '1988-03-26'),
(12, '1995-10-08'),
(13, '2000-01-01'),
(14, '1997-05-29'),
(15, '1991-12-31');

SELECT employee_id 
FROM employees
ORDER BY birth_date
LIMIT 3;

SELECT * 
FROM employees
ORDER BY birth_date
LIMIT 3;