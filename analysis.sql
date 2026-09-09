SELECT sector,sum(value) as total FROM gdp_data
GROUP BY sector
ORDER BY total desc

--What is absolute MT production in 2000 vs 2024? (anchor numbers)
WITH BASE AS (
SELECT
    crop_type,
    crop,
    year,
    MAX(CASE WHEN type = 'Area' THEN value END) AS area,
    MAX(CASE WHEN type = 'Production' THEN value END) AS production,
    MAX(CASE WHEN type = 'Productivity' THEN value END) AS productivity
  FROM agriculture_production
  GROUP BY crop_type, crop, year
)
SELECT YEAR,SUM(PRODUCTION) FROM BASE
WHERE crop_type = 'cash' 
GROUP BY YEAR
ORDER BY YEAR
--IN 2020: 11120.51 AND 2023: 11293.84 CASH
--IN 2020: 3616.33 AND 2023: 3788.72  FOOD

  SELECT 
    year,
	crop,
	crop_type,
    MAX(CASE WHEN type = 'Area' THEN value END) AS Area,
	MAX(CASE WHEN type = 'Production' THEN value END) AS Production,
	MAX(CASE WHEN type = 'Productivity' THEN value END) AS Productivity,
    MAX(CASE WHEN type='Production' THEN value END) / NULLIF(MAX(CASE WHEN type='Area' THEN value END),0) AS yield
FROM agriculture_production
GROUP BY year,crop,crop_type
),
PREV_CAL AS (
  SELECT 
    year,
	crop,
	crop_type,
	Area,
    Production,
    Productivity,
    yield,
    LAG(Area) OVER(PARTITION BY crop_type,crop ORDER BY year) as prev_area,
    LAG(Production) OVER(PARTITION BY crop_type,crop ORDER BY year) as prev_prod,
    LAG(yield) OVER(PARTITION BY crop_type,crop ORDER BY year) as prev_yield
FROM BASE
)
SELECT 
    year,
    crop,
    crop_type,
    Area,
    Production,
    Productivity,
    prev_area,
    prev_prod,
    prev_yield,
    (Area - prev_area) AS delta_area,
	(Production - prev_prod) AS delta_production,
	(yield - prev_yield) AS delta_yield
FROM PREV_CAL 
ORDER BY year

WITH ranked AS (
SELECT
  crop,
  year,
  value,
  ROW_NUMBER() OVER(PARTITION BY crop ORDER BY year) AS first_row,
  ROW_NUMBER() OVER(PARTITION BY crop ORDER BY year DESC) AS last_row
FROM agriculture_production
where type = 'Production'

)

SELECT
    crop,
    MAX(CASE WHEN first_row = 1 THEN year END) AS first_year,
    MAX(CASE WHEN first_row = 1 THEN value END) AS first_production,
    MAX(CASE WHEN last_row = 1 THEN year END) AS last_year,
    MAX(CASE WHEN last_row = 1 THEN value END) AS last_production
FROM ranked
GROUP BY crop;

WITH AGGREGRATION AS (
SELECT
    year,
	crop,
    SUM(value) as production
FROM agriculture_production
WHERE type = 'Production'
GROUP BY crop,year
)
SELECT 
	crop,
	STDDEV_POP(production) as std_production,
	AVG(production) as average_production,
	(STDDEV_POP(production)/AVG(production)) as cv
FROM AGGREGRATION
GROUP BY crop


--CAGR of total production 2000–2024
--CAGR = (end/start)^(1/n) - 1. Apply to production, area, productivity separately.
WITH ranked AS (
SELECT
  crop,
  type,
  year,
  value,
  ROW_NUMBER() OVER(PARTITION BY crop ORDER BY year) AS first_row,
  ROW_NUMBER() OVER(PARTITION BY crop ORDER BY year DESC) AS last_row
FROM agriculture_production
)
SELECT
    crop,
	type
    MAX(CASE WHEN first_row = 1 THEN year END) AS first_year,
    MAX(CASE WHEN first_row = 1 THEN value END) AS first_production,
    MAX(CASE WHEN last_row = 1 THEN year END) AS last_year,
    MAX(CASE WHEN last_row = 1 THEN value END) AS last_production
FROM ranked
GROUP BY crop;
