USE finalproject;

/*
EDA TASK 19: Geospatial Analysis 
TẠO stored procedure
INPUT : tọa độ, bán kính
OUTPUT: địa điểm trong phạm vi hình tròn: city name, state name, county  AND  khoảng cách với điểm cho trước

Công thức tính khoảng cách địa lý: 
https://stackoverflow.com/questions/5031268/algorithm-to-find-all-latitude-longitude-locations-within-a-certain-distance-fro/5045027#5045027
*/


DELIMITER $$

CREATE PROCEDURE Geospatial_Analysis(latitude FLOAT, longitude FLOAT, radius_km FLOAT)
BEGIN
	-- cte_distance_km sẽ ra danh sách các City, State_Name, County trùng lặp nhau với khoảng cách khác nhau
    -- nhưng em chỉ muốn biết từ tọa độ cho trước --> thành phố đó, khoảng cách GẦN NHẤT là bao xa ?
	WITH cte_rank_distance_km AS ( 
		WITH cte_distance_km AS (
			SELECT 
				City, 
				State_Name, 
				County, 
				6371 * 2 * ASIN(SQRT(
									POWER(SIN((latitude - Lat) * pi()/180 / 2), 2) + 
									COS(latitude * pi()/180 ) * COS(abs(Lat) * pi()/180) * 
									POWER(SIN((longitude - Lon) * pi()/180 / 2), 2) 
									)) AS `distance_km`
			FROM 
				us_household_income
		)
		SELECT *,
			ROW_NUMBER() OVER(PARTITION BY State_Name, County, City ORDER BY `distance_km`) `rank_`
		FROM cte_distance_km
		WHERE 
			distance_km <= radius_km
	)
	SELECT 
		City, 
		State_Name, 
		County,
		ROUND( distance_km, 4 ) AS `ROUND_distance_km`
	FROM cte_rank_distance_km
	WHERE `rank_` = 1 
	;
END $$
DELIMITER ;

-- CALL `finalproject`.`Geospatial_Analysis`(<{latitude FLOAT}>, <{longitude FLOAT}>, <{radius_km FLOAT}>);
-- Cho trước tọa độ ( vĩ độ = 30,  kinh độ = -100 ). Xác định các City quanh bán kính 100 (km)
-- Result (10 rows): 10 thành phố.
CALL Geospatial_Analysis(30, -100, 100) ;




