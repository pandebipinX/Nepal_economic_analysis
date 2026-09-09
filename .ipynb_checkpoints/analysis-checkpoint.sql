
WITH data as (
SELECT 
    crop_type,
	type,
    year,
    value,
    LAG(value) OVER (PARTITION BY crop_type ORDER BY year) AS prev_value
FROM agriculture_production
where type = 'Production'
)
SELECT 
	*,
	(value-prev_value)/nullif(prev_value,0)*100 as pct_change
FROM data;


SELECT 
    year,
    crop_type,
    SUM(value) * 100.0 / SUM(SUM(value)) OVER (PARTITION BY year) AS contribution_pct
FROM agriculture_production
WHERE type = 'Production'
GROUP BY year, crop_type;

SELECT 
	a.year,
    SUM(a.value) as production,
    c.value as cpi_value
FROM agriculture_production a
JOIN cpi_data c
ON c.year = a.year
	WHERE a.crop_type = 'food' AND a.type='Production'
AND c.category = 'fiscal_year_food_and_beverages'
GROUP BY a.year,c.value
ORDER BY a.year

WITH base AS (
  SELECT
    crop,
    year,
    MAX(CASE WHEN type = 'Area' THEN value END) AS area,
    MAX(CASE WHEN type = 'Production' THEN value END) AS production,
    MAX(CASE WHEN type = 'Productivity' THEN value END) AS productivity
  FROM agriculture_production
  GROUP BY crop, year
),
calc AS (
  SELECT
    crop,
    year,
    production,
    area,
    productivity,
    LAG(production) OVER (PARTITION BY crop ORDER BY year) AS prev_prod,
    LAG(area) OVER (PARTITION BY crop ORDER BY year) AS prev_area,
    LAG(productivity) OVER (PARTITION BY crop ORDER BY year) AS prev_prodty
  FROM base
)
SELECT
  crop,
  year,

  (production - prev_prod) / NULLIF(prev_prod, 0) * 100 AS prod_growth,

  (area - prev_area) / NULLIF(prev_area, 0) * 100 AS area_growth,

  (productivity - prev_prodty) / NULLIF(prev_prodty, 0) * 100 AS productivity_growth

FROM calc
ORDER BY crop, year;

SELECT 
	sector,
	year_adjusted,
	sum(value) as total_gdp
FROM gdp_data
GROUP BY sector,year_adjusted
order by year_adjusted Asc






