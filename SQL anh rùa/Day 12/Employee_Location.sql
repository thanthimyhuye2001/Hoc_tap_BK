
CREATE TABLE employee_location (
    employee_id INT,
    city VARCHAR(255),
    state VARCHAR(255),
    state_id VARCHAR(2)
);

INSERT INTO employee_location (employee_id, city, state, state_id) VALUES
(1, 'Charlotte', 'North Carolina', 'NC'),
(3, 'Austin', 'Texas', 'TX'),
(4, 'New York', 'New York', 'NY');

SELECT first_name, last_name, state
FROM employee_name en
LEFT OUTER JOIN employee_location el
	ON en.person_id = el.employee_id;