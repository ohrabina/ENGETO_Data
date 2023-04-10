-- First question - does avg_pay in specific Branch rise during investigated years?

SELECT 
	DISTINCT price_year AS pay_year,
	tpf.avg_pay,
	branch
FROM t_ondrej_hrabina_project_sql_primary_final AS tpf