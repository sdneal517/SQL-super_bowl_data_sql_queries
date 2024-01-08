-- Using 'superbowl_data' table
SELECT * FROM nfl_project.superbowl_data;
/*
Columns: superbowl number, date, SB (roman numeral), winner, 
winner pts, loser, loser pts, MVP, stadium, city, state
*/

-- Using 'superbowl_data' table
SELECT * FROM nfl_project.superbowl_ratings;
/*
Columns: super_bowl (roman numeral), super_bowl_number, date,
network, average_viewers, household_rating, household_share,
cost_of_30_second_ad_usd
*/


-- Retrieve the top 5 superbowl-winning teams
SELECT winner, COUNT(winner) AS total_wins
FROM nfl_project.superbowl_data
GROUP BY winner
ORDER BY total_wins DESC
LIMIT 6;


-- Retrieve the state with the most superbowls played in
SELECT state, COUNT(*) AS total_superbowls_played
FROM nfl_project.superbowl_data
GROUP BY state
ORDER BY total_superbowls_played DESC
LIMIT 1;

-- Sum to have purchased one 30-second add at every superbowl
SELECT CONCAT('$', FORMAT(SUM(cost_of_30_second_ad_usd), 'N0')) AS formatted_total_cost
FROM nfl_project.superbowl_ratings;

-- Retrieve number, date, teams, points and point differences of any superbowl decided by 3 points or less
SELECT super_bowl_number, date, winner, winner_Pts, loser, loser_pts, winner_pts - loser_pts AS "point difference"
FROM nfl_project.superbowl_data
WHERE ABS(winner_pts - loser_pts) <= 3;

-- Join tables to look up what teams were playing the first time the superbowl was aired on FOX
SELECT sd.super_bowl_number, sd.Date, sd.winner AS winning_team, sd.loser AS losing_team
FROM nfl_project.superbowl_data AS sd
JOIN nfl_project.superbowl_ratings AS sr
ON sd.super_bowl_number = sr.super_bowl_number
WHERE sr.network = 'Fox'
ORDER BY sd.super_bowl_number
LIMIT 1;

/*
Retrieve superbowl data including winner & loser point difference
sorted by the total viewership
*/ 
SELECT
    sd.super_bowl_number, sd.winner AS winning_team, 
    sd.loser AS losing_team, 
    sd.date,
    FORMAT(sr.total_viewers, 'N0') AS total_viewers,
    (sd.winner_pts - sd.loser_pts) AS point_difference
FROM
    nfl_project.superbowl_data AS sd
INNER JOIN
    nfl_project.superbowl_ratings AS sr
ON
    sd.super_bowl_number = sr.super_bowl_number
ORDER BY
    sr.average_viewers DESC;
    
/*
Retrieve a list of teams sorted by how many times 
they played in a super bowl with 'X' in its roman numeral
*/
SELECT team, COUNT(*) AS appearances
FROM (
    SELECT winner AS team
    FROM nfl_project.superbowl_data
    WHERE SB LIKE '%X%'
    
    UNION ALL
    
    SELECT loser AS team
    FROM nfl_project.superbowl_data
    WHERE SB LIKE '%X%'
) AS X_superbowl_teams
GROUP BY team
ORDER BY appearances DESC;