CREATE OR REPLACE TABLE stg_tourism AS
SELECT
  geo                                              AS nuts2_code,
  unit,
  c_resid                                          AS residence,
  CAST(TRIM(period) AS INT)                        AS year,
  arrivals
FROM raw_eurostat
WHERE geo LIKE 'IT%'              -- Italy only
  AND arrivals IS NOT NULL
  AND c_resid = 'TOTAL'           -- residents + non-residents combined
  AND unit = 'NR'                 -- absolute numbers, not % changes
  AND nace_r2 = 'I551-I553';      -- aggregated accommodation sector: the
                                  -- individual I551/I552/I553 rows overlap
                                  -- with this total, so keeping them all
                                  -- would double count