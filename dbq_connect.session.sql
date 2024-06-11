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



SELECT SUM(country_count) AS country_total
FROM (
    SELECT DISTINCT COUNT(country_code) AS country_count
    FROM dbq_temporary_table
    WHERE country_code IN (
        SELECT DISTINCT country_code
        FROM dbq_temporary_table
    )
) subquery_alias;


