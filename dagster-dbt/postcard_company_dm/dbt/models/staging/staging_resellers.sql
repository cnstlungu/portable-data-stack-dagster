{{ config(schema='staging') }}

SELECT 
    reseller_id, 
    reseller_name, 
    commission_pct, 
FROM {{ref('raw_resellers')}}

QUALIFY ROW_NUMBER() OVER(PARTITION BY reseller_id ORDER BY loaded_timestamp DESC )=1