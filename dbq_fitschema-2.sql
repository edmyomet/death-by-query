--queries to load the structure of various tables 
--selecting singlular column name from columns returned by information scheme
SELECT column_name as cname
FROM INFORMATION_SCHEMA.columns
WHERE TABLE_NAME = 'dbq_temporary_table'
AND column_name = 'parkinsons';

--displaying disease ids with their corresponding disease names (displayed as columns)
--in the dbq_temporary_table relation, using information schema and left join on disease name
SELECT diseases.disease_id, tmp.cname 
FROM diseases
LEFT OUTER JOIN (
    SELECT column_name AS cname
    FROM INFORMATION_SCHEMA.columns
    WHERE TABLE_NAME='dbq_temporary_table' 
) AS tmp(cname)
ON diseases.disease_name = tmp.cname;

--selecting the names of countries and the diseases 
SELECT countries.country_name, tmp.cname
FROM countries
CROSS JOIN (
    SELECT column_name AS cname 
    FROM INFORMATION_SCHEMA.columns
    WHERE TABLE_NAME = 'dbq_temporary_table'
) AS tmp(cname)
WHERE tmp.cname NOT IN (
    VALUES ('country'),('country_code'), ('year'), ('index')
);

DO $$
DECLARE column_vars VARCHAR[];
BEGIN 
    SELECT column_name INTO column_vars
    FROM INFORMATION_SCHEMA.columns
    WHERE TABLE_NAME = 'dbq_temporary_schema'
    AND column_name NOT IN (
        VALUES ('country'),('country_code'),('year'),('index')
    );
    SELECT ARRAY(column_vars);
END $$; 








