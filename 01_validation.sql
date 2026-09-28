-- Cookie Cats A/B test: data validation
-- Source: Kaggle, "Mobile Games A/B Testing - Cookie Cats"
-- Table: players (one row per player)

-- Total number of players
SELECT COUNT(*) AS n_players
FROM players;

-- Duplicate check: total rows should equal distinct userids
SELECT COUNT(DISTINCT userid) AS unique_players,
       COUNT(*) AS total_players
FROM players;

-- Players per version: is the A/B split roughly even?
SELECT version,
       COUNT(*) AS n_players
FROM players
GROUP BY version;

-- Distribution of rounds played in the first 14 days (raw data)
SELECT MAX(sum_gamerounds) AS max_rounds,
       MIN(sum_gamerounds) AS min_rounds,
       AVG(sum_gamerounds) AS avg_rounds
FROM players;

-- Players who never played a round (they can't be affected by the gate)
SELECT COUNT(*) AS zero_rounds
FROM players
WHERE sum_gamerounds = 0;

-- Top 20 players by rounds, with implied play time per day.
-- Assumes ~3 minutes per round to test whether values are physically possible.
WITH daily AS (
    SELECT userid,
           version,
           sum_gamerounds,
           ROUND(sum_gamerounds / 14.0, 2) AS rounds_per_day
    FROM players
)
SELECT *,
       ROUND(rounds_per_day * 3.0, 2) AS minutes_spent_per_day
FROM daily
ORDER BY sum_gamerounds DESC
LIMIT 20;

-- Cleaned view used for all analysis:
--   1. Exclude zero-round players (never exposed to the game, let alone the gate)
--   2. Exclude implausible values. Assuming ~3 minutes per round, more than
--      (1440 / 3) * 14 = 6,720 rounds in 14 days would require nonstop play.
DROP VIEW IF EXISTS players_clean;

CREATE VIEW players_clean AS
SELECT *
FROM players
WHERE sum_gamerounds != 0
  AND sum_gamerounds < (1440 / 3) * 14;

-- Rows before and after cleaning
SELECT (SELECT COUNT(*) FROM players)       AS raw_rows,
       (SELECT COUNT(*) FROM players_clean) AS clean_rows;

-- Distribution of rounds played after cleaning
SELECT MAX(sum_gamerounds) AS max_rounds,
       MIN(sum_gamerounds) AS min_rounds,
       ROUND(AVG(sum_gamerounds), 2) AS avg_rounds
FROM players_clean;

-- Median rounds played (SQLite has no MEDIAN function, so take the middle row)
SELECT sum_gamerounds AS median_rounds
FROM players_clean
ORDER BY sum_gamerounds ASC
LIMIT 1
OFFSET 86194 / 2;
