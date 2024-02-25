{{ config(
    materialized = 'table',
    schema='staging'
) }}


SELECT
  customer_key,
  transaction_id,
  product_key,
  channel_key,
  reseller_id,
  bought_date_key,
  total_amount,
  qty,
  product_price,
  geography_key,
  commissionpaid,
  commissionpct,
  loaded_timestamp
FROM 
    {{ref('staging_transactions_main')}}

UNION ALL

SELECT 
  customer_key,
  transaction_id,
  product_key,
  channel_key,
  reseller_id,
  bought_date_key,
  total_amount,
  number_of_purchased_postcards AS qty,
  product_price,
  geography_key,
  commissionpaid,
  commissionpct,
  loaded_timestamp
FROM 
    {{ref('staging_transactions_resellers_csv')}}

UNION ALL

SELECT 
  customer_key,
  transaction_id,
  product_key,
  channel_key,
  reseller_id,
  bought_date_key,
  total_amount,
  no_purchased_postcards AS qty,
  product_price,
  geography_key,
  commissionpaid,
  commissionpct,
  loaded_timestamp
FROM 
    {{ref('staging_transactions_resellers_json')}}