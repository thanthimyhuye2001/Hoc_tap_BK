-- EDA TASK 0: Create Store Procedure and Create Event 
-- Quy trình hoạt động HÀNG TUẦN để cập nhật và xóa dữ liệu (From Cleaning Tasks)

DELIMITER $$
CREATE PROCEDURE clean_data_us_household_income ()
BEGIN
	-- Xóa dòng chứa giá trị NULL ở cột "Place"
	DELETE FROM us_household_income WHERE Place IS NULL;
    
    -- UPDATE: Trong cột State_Name, thay "georia" thành "Georgia"
	UPDATE us_household_income
	SET State_Name = CASE WHEN State_Name = 'georia' THEN 'Georgia' ELSE State_Name END;
    
    -- UPDATE: Trong cột County, thay 'Do�a Ana County' thành 'Dona Ana County', thay 'R�o Grande Municipio' thành 'Rio Grande Municipio'
	UPDATE us_household_income
	SET County = CASE 
					WHEN County = 'Do�a Ana County' THEN 'Dona Ana County' 
					WHEN County = 'R�o Grande Municipio' THEN 'Rio Grande Municipio'
					ELSE County 
					END;
                    
	-- UPDATE: Trong cột City, thay 'Pennsboro Wv  26415' thành 'Pennsboro'.
	UPDATE us_household_income
	SET City = CASE WHEN City = 'Pennsboro Wv  26415' THEN 'Pennsboro' ELSE City END;	
    
    -- UPDATE: trong cột Place 
    UPDATE us_household_income
	SET Place = CASE 
					WHEN Place = 'Raymer (New Raymer)' THEN 'Raymer'
					WHEN Place = 'Boquer�n' THEN 'Boqueron'
					WHEN Place = 'El Mang�' THEN 'El Mango'
					WHEN Place = 'Fr�nquez' THEN 'Franchise'
					WHEN Place = 'Liborio Negr�n Torres' THEN 'Liborio Negron Torres'
					WHEN Place = 'Parcelas Pe�uelas' THEN 'Parcelas Penuelas'
					WHEN Place = 'R�o Lajas' THEN 'Rio Lajas'
					ELSE Place 
					END;
                                        
	-- UPDATE: Trong cột Type, thay 'Boroughs' thành 'Borough', thay 'CPD' thành 'CDP'.
	UPDATE us_household_income
	SET Type = CASE 
				WHEN Type = 'Boroughs' THEN 'Borough' 
				WHEN Type = 'CPD' THEN 'CDP'
				ELSE Type 
				END;                    
    
    -- ========================================================================================================================
	-- Cột Zip_Code đang để kiểu dữ liệu INT, ko thể bổ sung thêm số 0 vào đằng trước Zip_Code để đủ 5 chữ số.
	-- Đổi kiểu dữ liệu từ INT sang TEXT
	ALTER TABLE us_household_income 
	CHANGE COLUMN `Zip_Code` `Zip_Code` TEXT NULL DEFAULT NULL;    

	-- UPDATE: Trong cột Zip_Code, bổ sung thêm số 0 vào đằng trước để đủ 5 chữ số.
	UPDATE us_household_income
	SET Zip_Code = CASE 
						WHEN LENGTH(Zip_Code) = 3 THEN CONCAT('00', Zip_Code)
						WHEN LENGTH(Zip_Code) = 4 THEN CONCAT('0', Zip_Code)
						ELSE Zip_Code
					END;
                    
	-- =========================================================================================================================                    
	-- UPDATE: Trong cột Area_Code, thay 'M' thành 713, với điều kiện Area_Code ko chứa ký tự số thuộc [0-9] và nơi đó ở bang Texas, Anderson County, thành phố Pasadena, thị trấn Elkhart
	UPDATE us_household_income
	SET Area_Code = 713
	WHERE Area_Code REGEXP "[^0-9]"
		AND State_Name = 'Texas' 
		AND County = 'Anderson County' 
		AND City = 'Pasadena'
		AND Place = 'Elkhart';    
        
	-- =========================================================================================================================                    
	-- Remove duplicate values
	DELETE FROM us_household_income
	WHERE row_id IN (
					SELECT row_id
					FROM
					(
						SELECT row_id, id, ROW_NUMBER() OVER(PARTITION BY id) as Row_Num
						FROM us_household_income
					) AS Row_Table
					WHERE Row_Num > 1
				);
    
END $$
DELIMITER ;

-- Enable the event scheduler
SET GLOBAL event_scheduler = ON;

-- Create the event
CREATE EVENT weekly_clean_us_household_income
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_TIMESTAMP 
DO CALL clean_data_us_household_income();