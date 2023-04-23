{{
config(
materialized = 'table',
unique_key = 'product_key',
schema = 'core'
)
}}


select product_id as product_key, product_id as original_product_id, product_name, geography_key , product_price


FROM {{ref('staging_products')}}
