CREATE TEMPORARY TABLE temp_prices (
SELECT 
	cpc.name AS name, 
	ROUND(AVG(cp.value), 2) AS avg_price,
	cpc.price_value AS unit_value,
	cpc.price_unit AS unit,
	date_format(cp.date_from, '%Y') AS avg_year,
	quarter(date_from) AS qtr
FROM czechia_price AS cp 
JOIN czechia_price_category AS cpc ON cp.category_code = cpc.code
JOIN czechia_region AS cr ON cp.region_code = cr.code
GROUP BY 
	name,
	avg_year,
	qtr
ORDER BY 
	cpc.name,
	avg_year,
	qtr
)

CREATE TEMPORARY TABLE temp_vages (
SELECT 
	avg(value) AS avg_pay,
	cpu.name AS currency,
	payroll_year,
	payroll_quarter,
	cpib.name AS branch,
	cpvt.name AS TYPE
FROM czechia_payroll cp
JOIN czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code 
JOIN czechia_payroll_calculation cpc ON cp.unit_code = cpc.code 
JOIN czechia_payroll_value_type cpvt ON cp.value_type_code = cpvt.code
JOIN czechia_payroll_unit cpu ON cp.unit_code = cpu.code
GROUP BY 
	branch,
	payroll_year, 
	payroll_quarter 
ORDER BY 
	branch,
	payroll_year,
	payroll_quarter
)