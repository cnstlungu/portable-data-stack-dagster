{{ config(schema='raw') }}

SELECT 
    product_id,
    name,
    city,
    price,
    CURRENT_TIMESTAMP AS loaded_timestamp 
FROM {{ source('oltp','products') }}