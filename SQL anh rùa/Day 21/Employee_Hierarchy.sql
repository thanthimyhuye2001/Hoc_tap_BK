
CREATE TABLE employee_hierarchy (
    employee_id INT,
    supervisor_id INT
);

INSERT INTO employee_hierarchy (employee_id, supervisor_id) VALUES
(1, NULL),
(2, 1),
(3, 2),
(4, 3),
(5, 3),
(6, 1),
(7, 6),
(8, 7),
(9, 7);


WITH RECURSIVE cty_level AS 
(	SELECT *,  1 AS hierarchy_level
	FROM employee_hierarchy e
	WHERE supervisor_id IS NULL
    
UNION ALL

	SELECT e.employee_id, e.supervisor_id, hierarchy_level + 1
	FROM employee_hierarchy e, cty_level cl
	WHERE e.supervisor_id = cl.employee_id
)
SELECT *
FROM cty_level
ORDER BY employee_id; 