DROP TABLE IF EXISTS dbq_temporary_table;

--creating a temporary table to store values from a csv file
CREATE TABLE dbq_temporary_table(
    country VARCHAR,
    country_code VARCHAR(10),
    year VARCHAR(4),
    meningitis NUMERIC, 
    dementia NUMERIC, 
    parkinsons NUMERIC, 
    nutritional_deficiency_disorders NUMERIC, 
    malaria NUMERIC, 
    drowning NUMERIC, 
    interpersonal_violence NUMERIC, 
    maternal_disorders NUMERIC, 
    hiv_aids NUMERIC, 
    drug_disorders NUMERIC, 
    tuberculosis NUMERIC, 
    cardiovascular NUMERIC, 
    lower_respiratory NUMERIC, 
    neonatal_disorders NUMERIC, 
    alcohol_disorders NUMERIC, 
    self_harm NUMERIC,
    forces_of_nature NUMERIC, 
    diarrheal_disease NUMERIC, 
    environmental_exposure NUMERIC, 
    neoplasm NUMERIC, 
    conflict NUMERIC,
    diabetes NUMERIC, 
    chronic_kidney NUMERiC, 
    poisoning NUMERIC, 
    protein_energy_malnourishment NUMERIC, 
    road_injury NUMERIC, 
    chronic_respiratory NUMERIC, 
    chronic_liver NUMERIC, 
    digestive_disease NUMERIC, 
    fire NUMERIC, 
    acute_hepatitis NUMERIC, 
    measles NUMERIC
);

--copying values from the csv file to the temp table
COPY dbq_temporary_table
FROM '/home/shruthi/Desktop/github_projects/sql_projects/death_by_query/Annual cause death numbers new.csv'
DELIMITER ','
CSV HEADER;

--indexing the table
ALTER TABLE dbq_temporary_table 
ADD COLUMN index BIGSERIAL;

--adding primary key constraints on the index and country code attributes
ALTER TABLE dbq_temporary_table
ADD CONSTRAINT temp_pk 
PRIMARY KEY(index,country_code);

--creating supporting tables for the schema
--supporting table 1: country table consisting of country code and name
DROP TABLE IF EXISTS countries;
CREATE TABLE IF NOT EXISTS countries(
    country_code VARCHAR,
    country_name VARCHAR
);


--supporting table 2: disease table consisting of disease id and name
DROP TABLE IF EXISTS diseases;
CREATE TABLE IF NOT EXISTS diseases(
    disease_id BIGSERIAL PRIMARY KEY, 
    disease_name VARCHAR
);

--supporting table 3: death toll table with death tolls of induvidual countries in their corresponding years 
--for a particular ailment 
DROP TABLE IF EXISTS death_toll;
CREATE TABLE IF NOT EXISTS death_toll(
    country_code VARCHAR,
    disease_id INTEGER,
    deaths_1990 NUMERIC, 
    deaths_1991 NUMERIC, 
    deaths_1992 NUMERIC,
    deaths_1993 NUMERIC, 
    deaths_1994 NUMERIC, 
    deaths_1995 NUMERIC, 
    deaths_1996 NUMERIC, 
    deaths_1997 NUMERIC, 
    deaths_1998 NUMERIC, 
    deaths_1999 NUMERIC, 
    deaths_2000 NUMERIC,
    deaths_2001 NUMERIC, 
    deaths_2002 NUMERIC,
    deaths_2003 NUMERIC, 
    deaths_2004 NUMERIC, 
    deaths_2005 NUMERIC, 
    deaths_2006 NUMERIC,
    deaths_2007 NUMERIC, 
    deaths_2008 NUMERIC, 
    deaths_2009 NUMERIC, 
    deaths_2010 NUMERIC, 
    deaths_2011 NUMERIC,
    deaths_2012 NUMERIC, 
    deaths_2013 NUMERIC,
    deaths_2014 NUMERIC, 
    deaths_2015 NUMERIC, 
    deaths_2016 NUMERIC, 
    deaths_2017 NUMERIC, 
    deaths_2018 NUMERIC, 
    deaths_2019 NUMERIC
);

--inserting country codes and country names from the temporary table 
--into the country table
INSERT INTO countries
SELECT DISTINCT dbq_temporary_table.country_code, dbq_temporary_table.country
FROM dbq_temporary_table
ORDER BY dbq_temporary_table.country_code ASC;


--selecting count of country codes which have been repeated
SELECT c AS country_count
FROM(
    SELECT DISTINCT COUNT(country_code) AS c
    FROM countries
    GROUP BY country_code
)subquery_alias;

--selecting the country code that has been repeated 23 times
SELECT country_code
FROM countries
GROUP BY country_code
HAVING COUNT(country_code) = 23;

--mapping country names that have the same country codes
SELECT * FROM countries
WHERE country_code = 'wb';

--setting new country codes for the regions/countries that have the same code
UPDATE countries
SET country_code = tmp.country_code
FROM (
    VALUES ('WAL','Wales'),('ENGW','England'),('AFRW','African Region who'),('SAW','South Asia wb'),
    ('NAW','North Asia wb'),('MENA','Middle East & North Africa wb'),('EMR','Eastern Mediterranean Region who'),
    ('EURW','European Region who'), ('OECD','OECD Countries'), ('EUCAW','Europe & Central Asia wb'),
    ('SSAW','SubSaharan Africa wb'), ('G20','G20'),('SEAW','SouthEast Asia Region who'),
    ('NIRD','Northern Ireland'),('WPR','Western Pacific Region who'),('EAPW','East Asia & Pacific wb'),
    ('NAMW','North America wb'),('LAC','Latin America & Caribbean wb'),('SCO','Scotland'),('RAMW','Region of the Americas who'),
    ('HINC','World Bank High Income'),('LINC','World Bank Low Income'), ('LMINC','World Bank Lower Middle Income'),
    ('LUINC','World Bank Upper Middle Income'))
AS tmp(country_code, cname)
WHERE country_name = tmp.cname;


--adding primary key constraint to the table (over country code) once duplications have been removed
--ALTER TABLE countries 
--ADD CONSTRAINT countries_pk 
--PRIMARY KEY(country_code);

--creating a procedure to insert records into the diseases relation
CREATE OR REPLACE PROCEDURE insert_disease_records(
    dname VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO diseases(disease_name) VALUES(dname);
END;
$$;

--inserting the various diseases in the temporary table as records
CALL insert_disease_records('tuberculosis');
CALL insert_disease_records('road_injury');
CALL insert_disease_records('self_harm');
CALL insert_disease_records('protien_energy_malnutrition');
CALL insert_disease_records('poisoning');
CALL insert_disease_records('parkinsons');
CALL insert_disease_records('nutritional_deficiency_disorders');
CALL insert_disease_records('neoplasm');
CALL insert_disease_records('neonatal_disorders');
CALL insert_disease_records('meningitis');
CALL insert_disease_records('measles');
CALL insert_disease_records('maternal_disorders');
CALL insert_disease_records('malaria');
CALL insert_disease_records('lower_respiratory');
CALL insert_disease_records('interpersonal_violence');
CALL insert_disease_records('hiv_aids');
CALL insert_disease_records('forces_of_nature');
CALL insert_disease_records('fire');
CALL insert_disease_records('environmental_exposure');
CALL insert_disease_records('drug_disorders');
CALL insert_disease_records('drowning');
CALL insert_disease_records('digestive_disease');
CALL insert_disease_records('diarrheal_disease');
CALL insert_disease_records('diabetes');
CALL insert_disease_records('dementia');
CALL insert_disease_records('conflict');
CALL insert_disease_records('chronic_respiratory');
CALL insert_disease_records('chronic_liver');
CALL insert_disease_records('chronic_kidney');
CALL insert_disease_records('cardiovascular');
CALL insert_disease_records('alcohol_disorders');
CALL insert_disease_records('acute_hepatitis');

--removing any duplicates
DELETE FROM diseases 
WHERE disease_name IN (
    SELECT DISTINCT disease_name AS name
    FROM diseases 
    GROUP BY disease_name
    HAVING COUNT(disease_name) > 1
);

--confirming deletion of duplicates
SELECT disease_name AS id
FROM diseases 
GROUP BY disease_name
HAVING COUNT(disease_name) > 1;

SELECT disease_name
FROM diseases;
--deleting all values from the relation as they have been incorrectly inserted
--DELETE FROM death_toll
--WHERE true;

--inserting country code from countries relation and disease id from diseases relation
--for every country, 32 diseases are present
INSERT INTO death_toll(country_code, disease_id)
SELECT countries.country_code AS country_code, diseases.disease_id AS disease_id
FROM countries, diseases;

--adding a composite key
ALTER TABLE death_toll 
ADD CONSTRAINT pk_death_toll
PRIMARY KEY(country_code, disease_id);


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
END $$; 

--join operation on country and death toll relation
SELECT countries.country_name AS cname, death_toll.disease_id AS id
FROM countries 
LEFT OUTER JOIN death_toll
ON countries.country_code = death_toll.country_code;


SELECT death_toll.deaths_1990,country_code
FROM death_toll
WHERE disease_id = 13
AND country_code IN (
    SELECT country_code
    FROM countries
);

UPDATE dbq_temporary_table
SET country_code = tmp.ccode
FROM (
    SELECT country_name, country_code
    FROM countries 
    ORDER BY country_code  
)AS tmp(cname,ccode)
WHERE dbq_temporary_table.country = tmp.cname;

--updating death toll values for malaria for all 30 years
UPDATE death_toll
SET deaths_2009 = tmp.malaria
FROM (
    SELECT dbq_temporary_table.malaria,dbq_temporary_table.country_code
    FROM dbq_temporary_table
    WHERE dbq_temporary_table.country_code IN (
        SELECT death_toll.country_code
        FROM death_toll
        ORDER BY death_toll.country_code ASC  
    )
    AND year='2009'
)AS tmp(malaria, code)
WHERE death_toll.disease_id = 13
AND death_toll.country_code =  tmp.code;


--updating death toll values for tuberculosis  
UPDATE death_toll
SET deaths_1992 =tmp.disease_1, deaths_2019 = tmp.disease_2
FROM (
    SELECT tmp1.disease_1, tmp2.disease_2,tmp1.code
    FROM (
        SELECT dbq_temporary_table.diabetes, dbq_temporary_table.country_code
        FROM dbq_temporary_table
        WHERE year='1992'
    )AS tmp1(disease_1,code)
    LEFT OUTER JOIN (
        SELECT dbq_temporary_table.diabetes, dbq_temporary_table.country_code
        FROM dbq_temporary_table
        WHERE year = '2019'
    )AS tmp2(disease_2,code)
    ON tmp1.code = tmp2.code
)AS tmp(disease_1,disease_2,code)
WHERE death_toll.disease_id = 24
AND death_toll.country_code = tmp.code;



--updating death toll for different diseases from the year 1990-1997
UPDATE death_toll
SET deaths_2014 = tmp.d90, deaths_1991=tmp.d91, deaths_1992=tmp.d92, deaths_1993=tmp.d93,
    deaths_1994=tmp.d94, deaths_1995=tmp.d95, deaths_1996=tmp.d96, deaths_1997=tmp.d97
FROM (
    SELECT temp.d90, temp.d91, temp.d92, temp.d93,
           temp1.d94, temp1.d95, temp1.d96, temp1.d97, temp.code
    FROM(
        SELECT tmp1.d90, tmp1.d91, tmp2.d92, tmp2.d93,tmp1.code
        FROM (
            SELECT tp1.d90, tp2.d91, tp1.code
            FROM (
                SELECT dbq_temporary_table.poisoning, dbq_temporary_table.country_code
                FROM dbq_temporary_table
                WHERE year='2014'
            )AS tp1(d90,code)
            LEFT OUTER JOIN(
                SELECT dbq_temporary_table.poisoning, dbq_temporary_table.country_code
                FROM dbq_temporary_table
                WHERE year='1991'
            )AS tp2(d91,code)
            ON tp1.code=tp2.code            
        )AS tmp1(d90, d91, code)
        LEFT OUTER JOIN(
            SELECT tp3.d92, tp4.d93, tp3.code
            FROM (
                SELECT dbq_temporary_table.poisoning, dbq_temporary_table.country_code
                FROM dbq_temporary_table
                WHERE year='1992'
            )AS tp3(d92,code)
            LEFT OUTER JOIN(
                SELECT dbq_temporary_table.poisoning, dbq_temporary_table.country_code
                FROM dbq_temporary_table
                WHERE year='1993'
            )AS tp4(d93,code)
            ON tp3.code = tp4.code
        )AS tmp2(d92,d93,code)
        ON tmp1.code = tmp2.code
    )AS temp(d90,d91,d92,d93,code)
    LEFT OUTER JOIN(
        SELECT tmp3.d94, tmp3.d95, tmp4.d96, tmp4.d97, tmp3.code
        FROM (
            SELECT tp5.d94, tp6.d95, tp5.code
            FROM(
                SELECT dbq_temporary_table.poisoning, dbq_temporary_table.country_code
                FROM dbq_temporary_table
                WHERE year='1994'
            )AS tp5(d94,code)
            LEFT OUTER JOIN(
                SELECT dbq_temporary_table.poisoning, dbq_temporary_table.country_code
                FROM dbq_temporary_table
                WHERE year='1995'
            )AS tp6(d95,code)
            ON tp5.code = tp6.code
        )AS tmp3(d94,d95,code)
        LEFT OUTER JOIN(
            SELECT tp7.d96, tp8.d97, tp7.code
            FROM(
                SELECT dbq_temporary_table.poisoning, dbq_temporary_table.country_code
                FROM dbq_temporary_table
                WHERE year='1996'
            )AS tp7(d96,code)
            LEFT OUTER JOIN(
                SELECT dbq_temporary_table.poisoning, dbq_temporary_table.country_code
                FROM dbq_temporary_table
                WHERE year='1997'
            )AS tp8(d97,code)
            ON tp7.code = tp8.code
        )AS tmp4(d96,d97,code)
        ON tmp3.code= tmp4.code
    )AS temp1(d94,d95,d96,d97,code)
    ON temp.code = temp1.code
)AS tmp(d90,d91,d92,d93,d94,d95,d96,d97,code)
WHERE death_toll.country_code = tmp.code
AND death_toll.disease_id=5;


SELECT * FROM death_toll
WHERE disease_id=6; 