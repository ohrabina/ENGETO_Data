CREATE TEMPORARY TABLE eu_countries(
SELECT 
	DISTINCT country 
FROM religions r 
WHERE region = 'Europe'
)

CREATE TABLE t_ondrej_hrabina_project_sql_secondary_final(
SELECT 
	euc.country,
	ec.`year` AS GDP_year,
	GDP,
	population,
	gini,
	taxes,
	fertility,
	mortaliy_under5
FROM eu_countries AS euc
JOIN economies AS ec ON euc.country = ec.country
-- WHERE gini IS NOT NULL AND taxes IS NOT NULL AND fertility IS NOT NULL and GDP IN NOT NULL
ORDER BY 
	euc.country,
	GDP_year
)
	


