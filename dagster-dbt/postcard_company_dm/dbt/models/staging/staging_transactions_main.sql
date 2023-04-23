{{
    config(
        materialized='incremental',
        schema='staging'
    )
}}

WITH 

  {% if is_incremental() %}

latest_transaction as (

select max(loaded_timestamp) as max_transaction  from {{ this }}

),


  {% endif %}

trans_main AS (
  SELECT
    {{ dbt_utils.generate_surrogate_key(
      [ '0', 'customer_id']
    ) }} AS customer_key,
    customer_id,
    transaction_id,
    product_id,
    amount,
    qty,
    channel_id,
    bought_date,
    loaded_timestamp
  FROM
    {{ ref('raw_transactions') }}

  {% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where loaded_timestamp > (SELECT max_transaction from latest_transaction LIMIT 1)

  {% endif %}



)


SELECT
  t.customer_key,
  transaction_id,
  e.product_key,
  C.channel_key,
  0 AS reseller_id,
  strftime('%Y%m%d', bought_date)::INTEGER AS bought_date_key,
  REPLACE(amount,'$','')::numeric AS total_amount,
  qty,
  e.product_price,
  e.geography_key,
  NULL::numeric AS commissionpaid,
  NULL::numeric AS commissionpct,
  loaded_timestamp


FROM
  trans_main t
  JOIN {{ ref('dim_product') }}
  e
  ON t.product_id = e.product_key
  JOIN {{ ref('dim_channel') }} C
  ON t.channel_id = C.channel_key
  JOIN {{ ref('dim_customer') }}
  cu
  ON t.customer_key = cu.customer_key

