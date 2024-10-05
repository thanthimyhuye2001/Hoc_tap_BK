
CREATE TABLE highest_grade (
    student_name VARCHAR(255),
    class_id INT,
    grade INT
);

INSERT INTO highest_grade (student_name, class_id, grade) VALUES
('Ron', 1, 90),
('Leslie', 1, 95),
('Ben', 1, 87),
('April', 1, 65),
('Ron', 2, 86),
('Leslie', 2, 95),
('Ben', 2, 97),
('April', 2, 75),
('Ron', 3, 90),
('Leslie', 3, 88),
('Ben', 3, 84),
('April', 3, 80);

WITH CTE_max_diem_min_class AS (

	WITH CTE_max_diem AS (
		SELECT *, MAX(grade) OVER (PARTITION BY student_name) AS MAX_diem
		FROM highest_grade 
	)
    
	SELECT *, ROW_NUMBER() OVER(PARTITION BY student_name ORDER BY class_id) AS `thứ tự lớp`
	FROM CTE_max_diem
	WHERE grade = MAX_diem
)
SELECT *
FROM CTE_max_diem_min_class
WHERE `thứ tự lớp` = 1
ORDER BY 1;

SELECT *, 
ROW_NUMBER() OVER (PARTITION BY student_name ORDER BY grade desc, class_id asc) AS MAX_diem
FROM highest_grade;