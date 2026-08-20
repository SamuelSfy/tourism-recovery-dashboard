CREATE OR REPLACE VIEW recovery_index AS
WITH yearly AS (
  SELECT region_name, year, SUM(arrivals) AS yearly_arrivals
  FROM   fct_yearly_arrivals
  GROUP BY region_name, year
),
pivoted AS (
  SELECT
    region_name,
    SUM(CASE WHEN year = 2019 THEN yearly_arrivals END) AS arrivals_2019,
    SUM(CASE WHEN year = 2022 THEN yearly_arrivals END) AS arrivals_2022,
    SUM(CASE WHEN year = 2025 THEN yearly_arrivals END) AS arrivals_2025
  FROM yearly
  GROUP BY region_name
)
SELECT
  region_name,
  arrivals_2019,
  arrivals_2022,
  arrivals_2025,
  ROUND(arrivals_2022 / arrivals_2019, 3) AS recovery_2022,
  ROUND(arrivals_2025 / arrivals_2019, 3) AS recovery_2025,
  ROUND((arrivals_2025 - arrivals_2022) / arrivals_2019, 3) AS lift_22_to_25
FROM pivoted
ORDER BY recovery_2025 DESC NULLS LAST;