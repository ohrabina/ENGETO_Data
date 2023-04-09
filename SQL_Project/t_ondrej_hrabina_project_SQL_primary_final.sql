CREATE TEMPORARY TABLE temp_prices (
SELECT 
	cpc.name AS name, 
	ROUND(AVG(cp.value), 2) AS avg_price,
	cpc.price_value AS unit_value,
	cpc.price_unit AS unit,
	YEAR(cp.date_from) AS price_year
FROM czechia_price AS cp 
LEFT JOIN czechia_price_category AS cpc ON cp.category_code = cpc.code
LEFT JOIN czechia_region AS cr ON cp.region_code = cr.code
WHERE region_code is NOT NULL
-- if region code is NULL I can not be sure if it is republic AVG or "just" missing value, there fore I am not usig these rows
GROUP BY 
	name,
	price_year
ORDER BY 
	cpc.name,
	price_year
)

CREATE TEMPORARY TABLE temp_vages (
SELECT 
	avg(value) AS avg_pay,
	cpu.name AS currency,
	payroll_year AS py,
	cpib.name AS branch,
	cpvt.name AS job_type
FROM czechia_payroll cp
LEFT JOIN czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code 
LEFT JOIN czechia_payroll_calculation cpc ON cp.unit_code = cpc.code 
LEFT JOIN czechia_payroll_value_type cpvt ON cp.value_type_code = cpvt.code
LEFT JOIN czechia_payroll_unit cpu ON cp.unit_code = cpu.code
WHERE cpvt.code = '5958' AND cpib.name IS NOT NULL 
-- I asume that I will sort based on branch in the future, therefore NULL is not wanted value in column
GROUP BY 
	branch,
	py  
ORDER BY 
	branch,
	py
)

CREATE TEMPORARY TABLE gdp(
SELECT 
	country,
	`year` AS GDP_year,
	GDP
FROM economies e 
WHERE country = 'Czech Republic'
)

CREATE TABLE t_ondrej_hrabina_project_SQL_primary_final (
SELECT 
	tp.name,
	tp.avg_price,
	tp.unit_value,
	tp.unit,
	tp.price_year,
	tv.avg_pay,
	tv.currency,
	tv.branch,
	gdp.GDP
FROM temp_prices AS tp
LEFT JOIN temp_vages AS tv ON tp.price_year = tv.payroll_year 
LEFT JOIN gdp ON gdp.GDP_year = tv.payroll_year
ORDER BY 
	branch,
	price_year
)

