USE finalproject;

/*      
DATA CLEANING
	1. Check Missing Value & NULL
	2. Data Consistency
	3. Removing Duplicates
*/

/* Data cleaning 1. Check Missing Value & NULL  */
-- Check Missing Value
SELECT row_id 		FROM us_household_income WHERE row_id = '';
SELECT id 			FROM us_household_income WHERE id = '' ;
SELECT State_Code  	FROM us_household_income WHERE State_Code = '' ;
SELECT State_Name	FROM us_household_income WHERE State_Name = '' ;
SELECT State_ab  	FROM us_household_income WHERE State_ab = '' ;
SELECT County  		FROM us_household_income WHERE County = '' ;
SELECT City  		FROM us_household_income WHERE City = '' ;
SELECT Place  		FROM us_household_income WHERE Place = '' ;
SELECT Type  		FROM us_household_income WHERE Type = '' ;
SELECT Primary_  	FROM us_household_income WHERE Primary_ = '' ;
SELECT Zip_Code 	FROM us_household_income WHERE Zip_Code = '' ;
SELECT Area_Code 	FROM us_household_income WHERE Area_Code = '' ;
SELECT ALand  		FROM us_household_income WHERE ALand  = '' AND ALand  <> 0;  -- WHERE ALand = '' sẽ đưa ra toàn bộ giá trị = 0, nên cần thêm điều kiện ALand khác 0
SELECT AWater  		FROM us_household_income WHERE AWater = '' AND AWater <> 0;
SELECT Lat  		FROM us_household_income WHERE Lat = '' AND Lat <> 0;
SELECT Lon  		FROM us_household_income WHERE Lon = '' AND Lon <> 0;
-- Result: No missing value.

-- Check NULL
SELECT * 
FROM us_household_income
WHERE row_id IS NULL
	OR id IS NULL
	OR State_Code IS NULL
	OR State_Name IS NULL
	OR State_ab IS NULL
	OR County IS NULL
	OR City IS NULL
	OR Place IS NULL
	OR Type IS NULL
	OR Primary_ IS NULL
	OR Zip_Code IS NULL
	OR Area_Code IS NULL
	OR ALand IS NULL
	OR AWater IS NULL
	OR Lat IS NULL
	OR Lon IS NULL
; 
-- Result: only 1 row has NULL in column "Place"

-- Xóa dòng chứa giá trị NULL ở cột "Place"
DELETE FROM us_household_income WHERE Place IS NULL;


-- -----------------------------------------------------------------------------------------------------------------------------------
/* Data cleaning 2. Data Consistency */

-- Đối với State, mỗi State_Name chỉ có 1 State_Code, 1 State_ab
SELECT 
	COUNT(DISTINCT State_Code),
    COUNT(DISTINCT State_Name),
    COUNT(DISTINCT State_ab) 
FROM us_household_income
;
-- Result: Có 52 State_Code tương ứng với 52 State_ab nhưng có tới 53 State_Name. Tức là có 1 State_Name đang bị sai.

-- Tìm ra State_Name đang bị sai và State_Code tương ứng
WITH cte_count_state_name AS (

	WITH cte_distinct_state AS (
		SELECT DISTINCT State_Code, State_Name
		FROM us_household_income
		)
	SELECT 
		State_Code, 
		State_Name, 
		COUNT(State_Name) OVER(partition by State_Code) count_state_name
	FROM cte_distinct_state
)
SELECT 
	State_Code, 
    State_Name
FROM cte_count_state_name
WHERE count_state_name > 1
;
-- Result (2 rows): State_Code = 13 vừa ứng với State_Name = "Georgia", vừa ứng với State_Name = "georia" nhưng "georia" là sai

-- UPDATE: Trong cột State_Name, thay "georia" thành "Georgia"
UPDATE us_household_income
SET State_Name = CASE WHEN State_Name = 'georia' THEN 'Georgia' ELSE State_Name END;
-- Result 1 row(s) affected Rows matched: 32532  Changed: 1 



-- Đối với County
-- Check ký tự đặc biệt ngoài bộ chữ cái tiếng Anh alphabel, dấu chấm, dấu sở hữu cách, dấu gạch ngang. \d là khoảng space.
SELECT DISTINCT County
FROM us_household_income
WHERE County REGEXP "[^a-z \d . ' -]"
;
-- Result (2 rows): 'Do�a Ana County' và 'R�o Grande Municipio' chứa ký tự lạ �.

-- UPDATE: Trong cột County, thay 'Do�a Ana County' thành 'Dona Ana County', thay 'R�o Grande Municipio' thành 'Rio Grande Municipio'
UPDATE us_household_income
SET County = CASE 
				WHEN County = 'Do�a Ana County' THEN 'Dona Ana County' 
                WHEN County = 'R�o Grande Municipio' THEN 'Rio Grande Municipio'
				ELSE County 
                END;
-- Result: 4 row(s) affected Rows matched: 32532  Changed: 4




-- Đối với City              
-- Check ký tự đặc biệt ngoài bộ chữ cái tiếng Anh alphabel, dấu chấm, dấu sở hữu cách, dấu gạch ngang. \d là khoảng space.
SELECT DISTINCT City
FROM us_household_income
WHERE City REGEXP "[^a-z \d . ' -]"; 
-- Result (1 rows): 'Pennsboro Wv  26415' đang bị lỗi chứa ký tự số. Tên City đúng là 'Pennsboro'.

-- UPDATE: Trong cột City, thay 'Pennsboro Wv  26415' thành 'Pennsboro'.
UPDATE us_household_income
SET City = CASE WHEN City = 'Pennsboro Wv  26415' THEN 'Pennsboro' ELSE City END;
-- Result: 1 row(s) affected Rows matched: 32532  Changed: 1



-- Đối với Place
-- Check ký tự đặc biệt ngoài bộ chữ cái tiếng Anh alphabel, dấu chấm, dấu sở hữu cách, dấu gạch ngang. \d là khoảng space.
SELECT DISTINCT Place
FROM us_household_income
WHERE Place REGEXP "[^a-z \d . ' -]"
;
/* Result (7 rows): 
	'Raymer (New Raymer)'
	'Boquer�n'
	'El Mang�'
	'Fr�nquez'
	'Liborio Negr�n Torres'
	'Parcelas Pe�uelas'
	'R�o Lajas'
*/ 
/* UPDATE: trong cột Place 
	'Raymer (New Raymer)' -----> 'Raymer'
	'Boquer�n' -----> 'Boqueron'
	'El Mang�' -----> 'El Mango'
	'Fr�nquez' -----> 'Franchise'
	'Liborio Negr�n Torres'	-----> 'Liborio Negron Torres'
	'Parcelas Pe�uelas' -----> 'Parcelas Penuelas'
	'R�o Lajas'	-----> 'Rio Lajas'
*/ 
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
-- Result: 7 row(s) affected Rows matched: 32532  Changed: 7 



-- Đối với Type
SELECT DISTINCT Type
FROM us_household_income
ORDER BY 1;
/* Result (12 rows): 
	'Borough'
	'Boroughs'
	'CDP'
	'City'
	'Community'
	'County'
	'CPD'
	'Municipality'
	'Town'
	'Track'
	'Urban'
	'Village'

Có 2 lỗi, có thể là nhầm lẫn khi gõ chữ.
'Borough' và 'Boroughs' là cùng nói về 'Borough'.
CPD là viết tắt của “Continuing Professional Development”, không phải Type of geographic area. Đó có thể là CDP.
*/
-- UPDATE: Trong cột Type, thay 'Boroughs' thành 'Borough', thay 'CPD' thành 'CDP'.
UPDATE us_household_income
SET Type = CASE 
			WHEN Type = 'Boroughs' THEN 'Borough' 
			WHEN Type = 'CPD' THEN 'CDP'
			ELSE Type 
			END;
-- Result: 3 row(s) affected Rows matched: 32532  Changed: 3 


	
-- Đối với Primary_
SELECT Primary_, COUNT(*)
FROM us_household_income
GROUP BY Primary_;
-- Result (2 rows): có 29439 giá trị là 'Track'  và   3093 giá trị là 'place'
-- Ko phát hiện bất thường



-- Đối với Primary_
SELECT Primary_, COUNT(*)
FROM us_household_income
GROUP BY Primary_;




-- Đối với Zip_Code
-- Check định dạng của Zip_Code
SELECT DISTINCT Zip_Code
FROM us_household_income
WHERE Zip_Code REGEXP "[^0-9]";
-- Result: Không có Zip_Code nào có ký tự ngoài bộ chữ số từ 0->9

-- Check độ dài của Zip_Code
SELECT DISTINCT 
	State_Name,
    Zip_Code, 
    LENGTH(Zip_Code) AS length,
    CASE 
		WHEN LENGTH(Zip_Code) = 3 THEN CONCAT('00', Zip_Code)
        WHEN LENGTH(Zip_Code) = 4 THEN CONCAT('0', Zip_Code)
        ELSE Zip_Code
	END as new_Zip_Code
FROM us_household_income
ORDER BY length;
/* Result:
zip code có format gồm 5 chữ số mà data có những zip code chỉ gồm 3-4 chữ số. 
zip code của bang Puerto Rico thường có 2 số 00 ở đầu (ví dụ 00601). 
zip code của bang Connecticut thường có 1 số 0  ở đầu (ví dụ 06001).
*/

-- Cột Zip_Code đang để kiểu dữ liệu INT, ko thể bổ sung thêm số 0 vào đằng trước Zip_Code để đủ 5 chữ số.
-- Đổi kiểu dữ liệu từ INT sang VARCHAR(5)
ALTER TABLE us_household_income 
CHANGE COLUMN `Zip_Code` `Zip_Code` VARCHAR(5) NULL DEFAULT NULL;   

-- UPDATE: Trong cột Zip_Code, bổ sung thêm số 0 vào đằng trước để đủ 5 chữ số.
UPDATE us_household_income
SET Zip_Code = CASE 
					WHEN LENGTH(Zip_Code) = 3 THEN CONCAT('00', Zip_Code)
					WHEN LENGTH(Zip_Code) = 4 THEN CONCAT('0', Zip_Code)
					ELSE Zip_Code
				END;
-- Result: 2775 row(s) affected Rows matched: 32532  Changed: 2775




-- Đối với Area_Code
-- Check định dạng của Area_Code
SELECT DISTINCT Area_Code
FROM us_household_income
WHERE Area_Code REGEXP "[^0-9]";
-- Result (1 row): có Area_Code = 'M' là ký tự chữ cái.

-- Check độ dài của Area_Code
SELECT DISTINCT 
    Area_Code, 
    LENGTH(Area_Code) AS length
FROM us_household_income
ORDER BY length;  
-- Result: có Area_Code = 'M' chỉ có 1 ký tự, trong khi các Area_Code khác đều có 3 chữ số.

-- Kiểm tra thông tin của những dòng có Area_Code = 'M' 
SELECT * 
FROM us_household_income
WHERE Area_Code = 'M';
-- Result (1 row): row_id = 28896, bang Texas, Anderson County, thành phố Pasadena, thị trấn Elkhart

-- Ở những nơi cùng địa điểm, thì có Area_Code như thế nào
SELECT Area_Code, COUNT(*) as count_area_code
FROM us_household_income
WHERE 
	State_Name = 'Texas' 
	AND County = 'Anderson County' 
	AND City = 'Pasadena'
	AND Place = 'Elkhart'
GROUP BY 
	Area_Code;
-- Result (3 rows): có 11 bản ghi chứa Area_Code = 713, 1 bản ghi Area_Code = 832 và 1 bản ghi Area_Code = 'M'.

-- UPDATE: Trong cột Area_Code, thay 'M' thành 713, với điều kiện Area_Code ko chứa ký tự số thuộc [0-9] và nơi đó ở bang Texas, Anderson County, thành phố Pasadena, thị trấn Elkhart
UPDATE us_household_income
SET Area_Code = 713
WHERE Area_Code REGEXP "[^0-9]"
	AND State_Name = 'Texas' 
	AND County = 'Anderson County' 
	AND City = 'Pasadena'
	AND Place = 'Elkhart';
-- Result: 1 row(s) affected Rows matched: 1  Changed: 1




-- Đối với ALand
SELECT 
	MIN(ALand), 
	MAX(ALand), 
	AVG(ALand)
FROM us_household_income; 
-- Result (1 row): Min = 0;   MAX = 91,632,669,709  ; MEAN = 116,759,749.5149
-- Thắc mắc: tại sao diện tích đất ở lại có thể = 0 ???

-- Tìm hiểu các bản ghi có ALand = 0
SELECT * 
FROM us_household_income 
WHERE ALand = 0; 
/* Result: 70 rows 
	Những dòng có ALand = 0 thì có AWater cực lớn ( từ 13,141,095  tới  6,248,340,078)
    Có thể có những hộ gia đình bên Mỹ, sinh sống trên du thuyền, thay vì ở nhà mặt đất.
*/




-- -----------------------------------------------------------------------------------------------------------------------------------
/* DATA CLEANING 3. Removing Duplicates  */

-- Check duplicate values
SELECT id, COUNT(*) as count_id
FROM us_household_income
GROUP BY id
HAVING count_id > 1
;
-- Result (7 rows): có 7 id lặp lại, và chỉ lặp lại 1 lần.
 
-- Xác định row_id của duplicate values
SELECT *
FROM
(
	SELECT row_id, id, ROW_NUMBER() OVER(PARTITION BY id) as Row_Num
    FROM us_household_income
) AS Row_Table
WHERE Row_Num > 1
;
-- Result (7 rows): 7 row_id của duplicate values

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
-- Result 7 rows tương ứng với 7 row_id đã bị xóa.
            