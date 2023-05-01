-- First question - does avg_pay in specific Branch rise during investigated years?
CREATE TEMPORARY TABLE min_max(
SELECT 
	branch,
	MIN(avg_pay) AS min_pay,
	MAX(avg_pay) AS max_pay
FROM t_ondrej_hrabina_project_sql_primary_final AS tpf
GROUP BY branch
)

SELECT
	min_max.branch,
	ROUND(min_max.min_pay) AS min_pay,
	ROUND(min_max.max_pay) AS max_pay,
	tpf.price_year AS min_year,
	tpf2.price_year AS max_year
FROM min_max
JOIN t_ondrej_hrabina_project_sql_primary_final AS tpf ON min_max.min_pay = tpf.avg_pay
JOIN t_ondrej_hrabina_project_sql_primary_final AS tpf2 ON min_max.max_pay = tpf2.avg_pay
GROUP BY 
	branch

-- Second question - how many l/kg of milk/bread one can buy in first and last comparable period?
SELECT 
	name,
	avg_price,
	unit_value,
	unit,
	price_year,
	round(AVG(avg_pay)) AS pay_per_year,
	round(round(AVG(avg_pay))/avg_price) AS amount,
	unit AS unit_2
FROM t_ondrej_hrabina_project_sql_primary_final AS tpf
WHERE 
	(name = 'Chléb konzumní kmínový' or name = 'Mléko polotučné pasterované') AND 
	(price_year = '2006' OR price_year = '2018')
GROUP BY
	name,
	price_year 

-- Third question - Which food category has the lowest price increase(year price rise in %)?
-- grow rate = ((last/first)^1/n) - 1

CREATE TEMPORARY TABLE food_per_year(
SELECT 
	name,
	AVG(avg_price) AS av_price,
	price_year 
FROM t_ondrej_hrabina_project_sql_primary_final AS tpf
GROUP BY 
	name,
	price_year 
)	

SELECT 
	fpy.name AS food,
	fpy.av_price AS 2006_price,
	fpy2.av_price AS 2007_price,
	fpy3.av_price AS 2008_price
FROM food_per_year AS fpy
JOIN food_per_year AS fpy2 ON fpy.price_year = fpy2.price_year + 1 AND fpy.name = fpy2.name
JOIN food_per_year AS fpy3 ON fpy.price_year = fpy3.price_year + 2 AND fpy.name = fpy3.name




