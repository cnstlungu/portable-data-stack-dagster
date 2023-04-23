-- https://gist.github.com/adityawarmanfw/0612333605d351f2f1fe5c87e1af20d2

{{ config(
      materialized = 'table',
      unique_key = 'date_value',
      schema = 'core'
) }}

WITH generate_date AS (
        SELECT CAST(RANGE AS DATE) AS date_value 
          FROM RANGE(DATE '2015-01-01', DATE '2030-12-31', INTERVAL 1 DAY)
          )
   SELECT 
   
          strftime(date_value, '%Y%m%d')::int AS date_key,
          date_value,
          DAYOFYEAR(date_value) AS day_of_year, 
          YEARWEEK(date_value) AS week_key,
          WEEKOFYEAR(date_value) AS week_of_year,
          DAYOFWEEK(date_value) AS day_of_week,
          ISODOW(date_value) AS iso_day_of_week,
          DAYNAME(date_value) AS day_name,
          DATE_TRUNC('week', date_value) AS first_day_of_week,
          DATE_TRUNC('week', date_value) + 6 AS last_day_of_week,
          YEAR(date_value) || RIGHT('0' || MONTH(date_value), 2) AS month_key,
          MONTH(date_value) AS month_of_year,
          DAYOFMONTH(date_value) AS day_of_month,
          LEFT(MONTHNAME(date_value), 3) AS month_name_short,
          MONTHNAME(date_value) AS month_name,
          DATE_TRUNC('month', date_value) AS first_day_of_month,
          LAST_DAY(date_value) AS last_day_of_month,
          CAST(YEAR(date_value) || QUARTER(date_value) AS INT) AS quarter_key,
          QUARTER(date_value) AS quarter_of_year,
          CAST(date_value - DATE_TRUNC('Quarter', date_value) + 1 AS INT) AS day_of_quarter,
          ('Q' || QUARTER(date_value)) AS quarter_desc_short,
          ('Quarter ' || QUARTER(date_value)) AS quarter_desc,
          DATE_TRUNC('quarter', date_value) AS first_day_of_quarter,
          LAST_DAY(DATE_TRUNC('quarter', date_value) + INTERVAL 2 MONTH) as last_day_of_quarter,
          CAST(YEAR(date_value) AS INT) AS year_key,
          DATE_TRUNC('Year', date_value) AS first_day_of_year,
          DATE_TRUNC('Year', date_value) - 1 + INTERVAL 1 YEAR AS last_day_of_year,
          ROW_NUMBER() OVER (PARTITION BY YEAR(date_value), MONTH(date_value), DAYOFWEEK(date_value) ORDER BY date_value) AS ordinal_weekday_of_month
     FROM generate_date