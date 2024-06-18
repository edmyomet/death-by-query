
--total number of countries that have partaken in the survey
SELECT SUM(country_count) AS country_total
FROM (
    SELECT COUNT(DISTINCT(country_code)) AS country_count
    FROM dbq_temporary_table
) subquery_alias;

--the years considered in the survey
SELECT DISTINCT(year) AS years_considered
FROM dbq_temporary_table
ORDER BY year ASC;

--various fields in the table
SELECT column_name AS col_name
FROM INFORMATION_SCHEMA.columns
WHERE TABLE_NAME = 'dbq_temporary_table'
ORDER BY col_name DESC
LIMIT 29;

SELECT * FROM countries;
