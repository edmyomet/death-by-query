DROP TABLE IF EXISTS youtube_data;

CREATE TABLE IF NOT EXISTS youtube_data(
    rank INTEGER NOT NULL, 
    youtuber VARCHAR(200),
    subscribers BIGINT, 
    video_views BIGINT, 
    category VARCHAR(100),
    title VARCHAR(200),
    uploads BIGINT,
    country VARCHAR(75),
    abbreviation VARCHAR(4),
    channel_type VARCHAR(100),
    video_views_rank BIGINT, 
    video_views_for_the_last_30_days BIGINT, 
    lowest_monthly_earnings DOUBLE PRECISION,
    highest_monthly_earnings DOUBLE PRECISION, 
    lowest_yearly_earnings DOUBLE PRECISION,
    highest_yearly_earnings DOUBLE PRECISION, 
    subscribers_for_last_30_days BIGINT, 
    created_year VARCHAR(4),
    created_month VARCHAR(4),
    created_date VARCHAR(3),
    gross_tertiary_education_enrollment INTEGER,
    population BIGINT,
    unemployment_rate DOUBLE PRECISION,
    urban_population BIGINT, 
    latitude DOUBLE PRECISION, 
    longitude DOUBLE PRECISION
);

ALTER TABLE youtube_data
ALTER COLUMN video_views
TYPE NUMERIC;

COPY youtube_data(
    rank,
    youtuber,
    subscribers,
    video_views,
    category,
    title,
    uploads,
    country,
    abbreviation,
    channel_type,
    video_views_rank,
    video_views_for_the_last_30_days,
    lowest_monthly_earnings,
    highest_monthly_earnings,
    lowest_yearly_earnings,
    highest_yearly_earnings,
    subscribers_for_last_30_days,
    created_year,
    created_month,
    created_date,
    gross_tertiary_education_enrollment,
    population,
    unemployment_rate,urban_population,
    latitude,
    longitude
)
FROM 'C:\Users\shrut\OneDrive\Desktop\sql projects\youtube analysis\Global YouTube Statistics.csv'
DELIMITER ','
CSV HEADER
ENCODING 'UTF-8';
