SELECT DISTINCT `Status` FROM worldlifexpectancy;

SELECT  * FROM (
	SELECT  Row_ID, Country, `Year`, 
			`Status`,
			LAG(`Status`)  OVER() AS `status_next`,
			LEAD(`Status`) OVER() AS `status_last`
	FROM worldlifexpectancy) t1
WHERE `Status` IS NULL;


SELECT MAX(`Lifeexpectancy`), MIN(`Lifeexpectancy`), AVG(`Lifeexpectancy`)
FROM worldlifexpectancy
WHERE `Lifeexpectancy` IS NOT NULL;

SELECT COUNT(*)
FROM worldlifexpectancy
WHERE `Lifeexpectancy` = 0
GROUP BY `Lifeexpectancy`;

SELECT `Lifeexpectancy`, Row_ID
FROM worldlifexpectancy
WHERE `Lifeexpectancy` IS NULL;


SELECT  * FROM (
	SELECT  Row_ID, Country, `Year`, 
			`Lifeexpectancy`,
			LAG(`Lifeexpectancy`)  OVER() AS `Lifeexpectancy_next`,
			LEAD(`Lifeexpectancy`) OVER() AS `Lifeexpectancy_last`
	FROM worldlifexpectancy) t2
WHERE `Lifeexpectancy` IS NULL;

SELECT *,
      ROUND((Lifeexpectancy_next + Lifeexpectancy_last)/2 , 1) 
FROM (

    SELECT  * FROM (
      SELECT  Row_ID, Country, `Year`, 
          `Lifeexpectancy`,
          LAG(`Lifeexpectancy`)  OVER() AS `Lifeexpectancy_next`,
          LEAD(`Lifeexpectancy`) OVER() AS `Lifeexpectancy_last`
      FROM worldlifexpectancy) t2
    WHERE `Lifeexpectancy` IS NULL) t3;
    
    
SELECT  *, row_number() over() as "stt" FROM (
SELECT DISTINCT `Country`  FROM worldlifexpectancy ORDER BY 1 ) t4;    