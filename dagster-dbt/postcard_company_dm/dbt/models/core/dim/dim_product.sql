{{
config(
materialized = 'table',
unique_key = 'product_key',
schema = 'core'
)
}}


SELECT 
    product_id AS product_key, 
    product_id AS original_product_id, 
    product_name, 
    geography_key, 
    product_price


FROM {{ref('staging_products')}}
