CREATE OR REPLACE TABLE fct_yearly_arrivals AS
SELECT
  s.nuts2_code,
  d.region_name,
  s.year,
  s.arrivals
FROM stg_tourism s
JOIN dim_region d ON d.nuts2_code = s.nuts2_code
WHERE s.year BETWEEN 2019 AND 2025;        -- pre-COVID baseline through latest