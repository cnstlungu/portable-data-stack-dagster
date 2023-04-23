{{ config(
      materialized = 'table',
      unique_key = 'geographykey',
      schema = 'core'
) }}

SELECT
      id AS geography_key,
      cityname as city_name,
      countryname as country_name,
      regionname as region_name
FROM
      {{ ref('geography') }}
