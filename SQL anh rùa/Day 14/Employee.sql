
CREATE TABLE employee (
    employee_id INT,
    name VARCHAR(255),
    salary INT,
    supervisor_id FLOAT
);

INSERT INTO employee (employee_id, name, salary, supervisor_id) VALUES
(1, 'Josh', 65000, NULL),
(2, 'Mary', 30000, 1),
(3, 'Tim', 32000, 1),
(4, 'Sarah', 40000, NULL),
(5, 'Michael', 35000, 4);


