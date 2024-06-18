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
FROM 'C:\Users\shrut\OneDrive\Desktop\sql projects\cause of deaths analysis\Annual cause death numbers new.csv'
DELIMITER ','
CSV HEADER;

--indexing the table
ALTER TABLE dbq_temporary_table ADD COLUMN index BIGSERIAL;

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
SET country_code = tmp.cname
FROM (
    VALUES ('WAL','Wales'),('ENG','England'),('AFR','African Region who'),('SA','South Asia wb'),
    ('NA','North Asia wb'),('MENA','Middle East & North Africa wb'),('EM','Eastern Mediterranean Region who'),
    ('EUR','European Region who'), ('OECD','OECD Countries'), ('EUCA','Europe & Central Asia wb'),
    ('SSA','SubSaharan Africa wb'), ('G20','G20'),('SEA','SouthEast Asia Region who'),
    ('NIR','Northern Ireland'),('WPR','Western Pacific Region who'),('EAP','East Asia & Pacific wb'),
    ('NAM','North America wb'),('LAC','Latin America & Caribbean wb'),('SCO','Scotland'),('RAM','Region of the Americas who'),
    ('HINC','World Bank High Income'),('LINC','World Bank Low Income'), ('LMINC','World Bank Lower Middle Income'),
    ('LUINC','World Bank Upper Middle Income'))
AS tmp(country_code, cname)
WHERE country_name = tmp.cname;

--adding primary key constraint to the table (over country code) once duplications have been removed
ALTER TABLE countries ADD CONSTRAINT countries_pk PRIMARY KEY(country_code);

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

INSERT INTO death_toll(disease_id)
SELECT disease_id 
FROM diseases;


INSERT INTO death_toll(country_code)
SELECT country_code
FROM countries 
ORDER BY country_code ASC
LIMIT 1;

SELECT * FROM death_toll;




