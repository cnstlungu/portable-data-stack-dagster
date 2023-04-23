{{ config(schema='raw') }}
SELECT *, CURRENT_TIMESTAMP AS loaded_timestamp FROM {{ source('oltp','transactions') }}