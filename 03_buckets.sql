-- Cookie Cats A/B test: results by rounds played
-- Uses the players_clean view created in 01_validation.sql
-- Bucket boundaries sit at 30 and 40 to line up with the two gate positions.
-- Note: rounds are not the same as levels, so buckets only approximate
-- which players reached each gate.

-- Number of players in each rounds bucket, by version
SELECT version,
       CASE
           WHEN sum_gamerounds <= 10 THEN '1-10'
           WHEN sum_gamerounds <= 29 THEN '11-29'
           WHEN sum_gamerounds <= 39 THEN '30-39'
           WHEN sum_gamerounds <= 99 THEN '40-99'
           ELSE '100+'
       END AS rounds_bucket,
       COUNT(*) AS n_players
FROM players_clean
GROUP BY version, rounds_bucket
ORDER BY version, MIN(sum_gamerounds);

-- Day-7 retention in each rounds bucket, by version.
-- Shows whether the gap between versions appears only among players
-- who played enough to reach a gate.
SELECT version,
       CASE
           WHEN sum_gamerounds <= 10 THEN '1-10'
           WHEN sum_gamerounds <= 29 THEN '11-29'
           WHEN sum_gamerounds <= 39 THEN '30-39'
           WHEN sum_gamerounds <= 99 THEN '40-99'
           ELSE '100+'
       END AS rounds_bucket,
       COUNT(*) AS n_players,
       ROUND(AVG(retention_7) * 100, 2) AS retention_7_percent
FROM players_clean
GROUP BY version, rounds_bucket
ORDER BY version, MIN(sum_gamerounds);
