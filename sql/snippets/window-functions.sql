-- Window Functions Snippets

-- 1) ROW_NUMBER
-- SELECT
--   *,
--   ROW_NUMBER() OVER (PARTITION BY group_col ORDER BY sort_col) AS rn
-- FROM t;

-- 2) RANK / DENSE_RANK
-- SELECT
--   *,
--   DENSE_RANK() OVER (ORDER BY score DESC) AS dense_rank
-- FROM t;

