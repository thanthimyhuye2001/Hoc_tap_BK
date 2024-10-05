
CREATE TABLE twitter_addiction (
    twitter_id INT,
    tweet_time DATETIME
);

INSERT INTO twitter_addiction (twitter_id, tweet_time) VALUES
(1001, '2023-01-01 08:30:00'),
(1002, '2023-01-02 13:30:00'),
(1003, '2023-01-03 16:30:00'),
(1001, '2023-01-01 10:30:00'),
(1002, '2023-01-02 20:45:00'),
(1003, '2023-01-03 16:45:00'),
(1001, '2023-01-01 16:30:00'),
(1003, '2023-01-03 17:15:00');

WITH CTE_time AS (
	SELECT *, 
	LAG(tweet_time) OVER(PARTITION BY twitter_id ORDER BY tweet_time) as `last_time`
	FROM twitter_addiction
)
SELECT *, 
TIMESTAMPDIFF(MINUTE,`last_time`, tweet_time) as `diff_minute`,
AVG(TIMESTAMPDIFF(MINUTE,`last_time`, tweet_time)) OVER(PARTITION BY twitter_id) as `AVG_last_time`
FROM CTE_time;