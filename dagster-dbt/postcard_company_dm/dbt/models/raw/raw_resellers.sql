{{ config(schema='raw') }}

SELECT 
    reseller_id, 
    reseller_name, 
    commission_pct,
    CURRENT_TIMESTAMP AS loaded_timestamp 
FROM 
    {{ source('oltp','resellers') }}