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
	name,
	av_price,
	round(((av_price / (LAG(av_price,1) OVER (PARTITION BY name ORDER BY price_year )))- 1)*100 ,2) AS perc_dif,
	price_year
FROM food_per_year AS fpy


-- Fourth question - Does exist a year where an increase of food price is higher than increase of wages?
CREATE TEMPORARY TABLE average_price(
SELECT 
	name,
	price_year, 
	AVG(avg_price) AS av_price
FROM t_ondrej_hrabina_project_sql_primary_final AS tpf
GROUP BY 
	name,
	price_year
)

CREATE TEMPORARY TABLE average_pay(	
SELECT 
	DISTINCT branch,
	avg_pay,
	price_year 
FROM t_ondrej_hrabina_project_sql_primary_final AS tpf
)

CREATE TEMPORARY TABLE diff_price(
SELECT 
	name,
	av_price,
	round(((av_price / (LAG(av_price,1) OVER (PARTITION BY name ORDER BY price_year )))- 1)*100 ,2) AS perc_dif_price,
	price_year
FROM average_price
)

CREATE TEMPORARY TABLE diff_pay(
SELECT 
	branch,
	avg_pay,
	round(((avg_pay / (LAG(avg_pay,1) OVER (PARTITION BY branch ORDER BY price_year )))- 1)*100 ,2) AS perc_dif_pay,
	price_year AS pay_year
FROM average_pay
)

SELECT
	name,
	branch,
	price_year AS inv_year,
	perc_dif_price AS ceny,
	perc_dif_pay AS plat,
	CASE 
		WHEN perc_dif_price > 10 AND  perc_dif_pay < 10 THEN 1
		ELSE 0
	END AS pay_vs_price
FROM diff_price AS dpr
LEFT JOIN diff_pay AS dpa ON dpr.price_year = dpa.pay_year
ORDER BY 
	pay_vs_price DESC, 
	name,
	branch,
	inv_year


