{{ config(schema='raw') }}

SELECT 
    channel_id,
    channel_name,
    CURRENT_TIMESTAMP AS loaded_timestamp 
FROM 
    {{ source('oltp','channels') }}