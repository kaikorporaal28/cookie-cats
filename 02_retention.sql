-- Cookie Cats A/B test: retention by gate version
-- Uses the players_clean view created in 01_validation.sql

-- Day-1 and day-7 retention rates by version
-- (AVG of a 0/1 column = the share of players retained)
SELECT version,
       COUNT(*) AS n_players,
       ROUND(AVG(retention_1) * 100, 2) AS retention_1_percent,
       ROUND(AVG(retention_7) * 100, 2) AS retention_7_percent
FROM players_clean
GROUP BY version;

-- Retained counts by version, used to build the 2x2 tables
-- for the chi-square tests in analysis.ipynb
SELECT version,
       SUM(retention_7) AS retention_7_count,
       SUM(retention_1) AS retention_1_count
FROM players_clean
GROUP BY version;
