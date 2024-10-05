
CREATE TABLE patients (
    patient_id INT,
    height_inches INT,
    weight_pounds INT
);

INSERT INTO patients (patient_id, height_inches, weight_pounds) VALUES
(1001, 69, 178),
(1002, 63, 250),
(1003, 70, 190),
(1004, 66, 155),
(1005, 65, 375),
(1006, 72, 100),
(1007, 68, 450),
(1008, 61, 290);

-- (Công thức: cân nặng (lb) / [chiều cao (in)]^2 x 703)
SELECT patient_id, 
	   height_inches, 
       weight_pounds,
	   ROUND(weight_pounds/ POW(height_inches, 2) * 703, 1) AS 'BMI = W/H^2 * 703'
FROM patients
WHERE weight_pounds/ POW(height_inches, 2) * 703 >= 30;


