DROP TABLE IF EXISTS dbq_temporary_table;

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
    diabets NUMERIC, 
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

COPY dbq_temporary_table
FROM 'C:\Users\shrut\OneDrive\Desktop\sql projects\cause of deaths analysis\Annual cause death numbers new.csv'
DELIMITER ','
CSV HEADER;

ALTER TABLE dbq_temporary_table ADD COLUMN index BIGSERIAL;

ALTER TABLE dbq_temporary_table
ADD CONSTRAINT temp_pk 
PRIMARY KEY(index,country_code);

DROP TABLE IF EXISTS countries;
CREATE TABLE IF NOT EXISTS countries(
    country_code VARCHAR,
    country_name VARCHAR
);

CREATE TABLE IF NOT EXISTS diseases(
    disease_id BIGSERIAL PRIMARY KEY, 
    disease_name VARCHAR
);

CREATE TABLE IF NOT EXISTS death_toll(
    country_code VARCHAR, 
    year_of_study VARCHAR(4), 
    disease_id INTEGER,
    deaths NUMERIC
);


INSERT INTO countries
SELECT DISTINCT dbq_temporary_table.country_code, dbq_temporary_table.country
FROM dbq_temporary_table
ORDER BY dbq_temporary_table.country_code ASC;


SELECT c AS country_count
FROM(
    SELECT DISTINCT COUNT(country_code) AS c
    FROM countries
    GROUP BY country_code
)subquery_alias;

SELECT country_code
FROM countries
GROUP BY country_code
HAVING COUNT(country_code) = 23;

SELECT * FROM countries
WHERE country_code = 'wb';

UPDATE countries
SET country_code = 'WAL'
WHERE country_name = 'Wales';

UPDATE countries
SET country_code='ENG'
WHERE country_name = 'England';

UPDATE countries
SET country_code = 'AFR'
WHERE country_name = 'African Region who';

UPDATE countries
SET country_code='SA'
WHERE country_name = 'South Asia wb';

UPDATE countries
SET country_code='NA'
WHERE country_name ='North Asia wb';

UPDATE countries
SET country_code = 'MENA'
WHERE country_name='Middle East & North Africa wb';

UPDATE countries
SET country_code = 'EM'
WHERE country_name = 'Eastern Mediterranean Region who';


UPDATE countries
SET country_code = tmp.cname
FROM (
    VALUES ('EUR','European Region who'), ('OECD','OECD Countries'), ('EUCA','Europe & Central Asia wb'),
    ('SSA','SubSaharan Africa wb'), ('G20','G20'),('SEA','SouthEast Asia Region who'),
    ('NIR','Northern Ireland'),('WPR','Western Pacific Region who'),('EAP','East Asia & Pacific wb'),
    ('NAM','North America wb'),('LAC','Latin America & Caribbean wb'),('SCO','Scotland'),('RAM','Region of the Americas who'),
    ('HINC','World Bank High Income'),('LINC','World Bank Low Income'), ('LMINC','World Bank Lower Middle Income'),
    ('LUINC','World Bank Upper Middle Income'))
AS tmp(country_code, cname)
WHERE country_name = tmp.cname;

ALTER TABLE countries ADD CONSTRAINT countries_pk PRIMARY KEY(country_code);


SELECT * FROM diseases;


INSERT INTO diseases 
SELECT column_name AS col_name
FROM INFORMATION_SCHEMA.columns
WHERE TABLE_NAME = 'dbq_temporary_table'
ORDER BY col_name DESC;