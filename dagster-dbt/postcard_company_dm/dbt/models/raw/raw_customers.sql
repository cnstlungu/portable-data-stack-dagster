{{ config(schema='raw') }}

SELECT
    customer_id,
    first_name,
    last_name,
    email,
    CURRENT_TIMESTAMP AS loaded_timestamp 
FROM 
    {{ source('oltp','customers') }}