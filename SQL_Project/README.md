SQL project - database analysis

MariaDB documentation: https://mariadb.com/kb/en/

For successful funning of the script you need ENGETO training database.

t_ondrej_hrabina_project_SQL_primary_final.sql -> this file is used for creation of table which contains all data needed for project

t_ondrej_hrabina_project_sql_secondary_final.sql -> this file is used for create of table which contains all data for EU countries

analysis.sql -> in this file could be found SQL queries used for finding the test answers
supporting_data.xlsx -> supprting data for project visualisation - graphs, tables, etc.....

1st Question: Does during examined years pay rise?
Answer: yes, in all branches pays rise, wher min is in 2006 and max in 2018

2nd Question: How many liters of milk and how many kilograms of bread one can buy in first and last investigated period
Answer: During this question it is not specified if diferentiation based on branches is need, therefore an average pay was used as marker
        In 2006 one can buy 1287 kg of bread and 1437 l of milk. In 2018 one can buey 1342 kg of bread and 1642 l of milk. 

3rd Question: Which price of food rise the slowest? (lowest interannual rise in percent)?
Answer: This is a little tricky. The easiest way to compare rise is sum of rises between each year. 
	Based on assumption above the food with slowest rise (in this case decrease) is "Cukr krystal"

4th Question: In which year is interannual rise of price bigger than rise of pay (larger than 10%)?
Answer: Except 2006 atleast one foods price rise was higher than 10% and in same tame rise of pay was less than 10%.

5th Question: Does HDP affect prices of food and pay?
Ansver: 