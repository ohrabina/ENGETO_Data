CREATE TEMPORARY TABLE temp_prices (
SELECT 
	cpc.name AS name, 
	ROUND(AVG(cp.value), 2) AS avg_price,
	cpc.price_value AS unit_value,
	cpc.price_unit AS unit,
	date_format(cp.date_from, '%Y') AS price_year,
	quarter(date_from) AS qtr
FROM czechia_price AS cp 
JOIN czechia_price_category AS cpc ON cp.category_code = cpc.code
JOIN czechia_region AS cr ON cp.region_code = cr.code
GROUP BY 
	name,
	price_year,
	qtr
ORDER BY 
	cpc.name,
	price_year,
	qtr
)

CREATE TEMPORARY TABLE temp_vages (
SELECT 
	avg(value) AS avg_pay,
	cpu.name AS currency,
	payroll_year,
	payroll_quarter,
	cpib.name AS branch,
	cpvt.name AS job_type
FROM czechia_payroll cp
JOIN czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code 
JOIN czechia_payroll_calculation cpc ON cp.unit_code = cpc.code 
JOIN czechia_payroll_value_type cpvt ON cp.value_type_code = cpvt.code
JOIN czechia_payroll_unit cpu ON cp.unit_code = cpu.code
WHERE cpvt.code = '5958'
GROUP BY 
	branch,
	payroll_year, 
	payroll_quarter 
ORDER BY 
	branch,
	payroll_year,
	payroll_quarter
)

CREATE TEMPORARY TABLE gdp(
SELECT 
	country,
	`year` AS GDP_year,
	GDP
FROM economies e 
WHERE country = 'Czech Republic'
)

SELECT 
	tp.name,
	tp.avg_price,
	tp.unit_value,
	tp.unit,
	tp.price_year,
	tp.qtr,
	tv.avg_pay,
	tv.currency,
	tv.branch,
	gdp.GDP
FROM temp_prices AS tp
JOIN temp_vages AS tv ON tp.price_year = tv.payroll_year AND tp.qtr = tv.payroll_quarter
JOIN gdp ON gdp.GDP_year = tv.payroll_year
ORDER BY 
	branch,
	price_year,
	qtr


