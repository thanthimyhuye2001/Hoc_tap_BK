
CREATE TABLE rankings (
    artist_id INT,
    judge_id INT,
    score INT
);

INSERT INTO rankings (artist_id, judge_id, score) VALUES
(1, 1001, 4),
(2, 1001, 6),
(3, 1001, 4),
(4, 1001, 10),
(5, 1001, 7),
(1, 1002, 4),
(2, 1002, 6),
(3, 1002, 7),
(4, 1002, 5),
(5, 1002, 10),
(1, 1003, 7),
(2, 1003, 5),
(3, 1003, 4),
(4, 1003, 8),
(5, 1003, 6);

SELECT * FROM day7.rankings;

SELECT artist_id,
		SUM(score)
FROM day7.rankings
GROUP BY artist_id;

SELECT *,  RANK() OVER(ORDER BY sum DESC) AS `rank sum`
FROM (
	SELECT artist_id, SUM(score) as `sum`
	FROM day7.rankings
	GROUP BY artist_id) AS `artist & SUM`;
    
    