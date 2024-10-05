
CREATE TABLE candy_poll (
    vote_date TEXT,
    right_vote FLOAT,
    left_vote FLOAT
);

INSERT INTO candy_poll (vote_date, right_vote, left_vote) VALUES
('2023-04-08', 1924123, 2243421);



SELECT *,
ROUND(right_vote/ (right_vote + left_vote) * 100, 2) `Right_Twix_Percentage`,
ROUND(left_vote / (right_vote + left_vote) * 100, 2) `Left_Twix_Percentage`
FROM candy_poll;