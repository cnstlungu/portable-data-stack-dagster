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



resellers_csv AS (
  SELECT
    "reseller id" :: INT AS reseller_id,
    "Transaction ID" AS  transaction_id,
    "Product name" AS product_name,
    "Total amount" AS total_amount,
    "Quantity" AS number_of_purchased_postcards,
    "Created Date" AS created_date,
    "Series City" AS office_location,
    "Sales Channel" AS sales_channel,
    loaded_timestamp
  FROM
    {{ ref(
      'raw_resellers_csv'
    ) }}

      {% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where loaded_timestamp > (SELECT max_transaction from latest_transaction LIMIT 1)

  {% endif %}



),
trans_csv AS (
  SELECT
    {{ dbt_utils.generate_surrogate_key(
      [ 'reseller_id', 'transaction_id']
    ) }} AS customer_key,
    transaction_id,
    reseller_id,
    product_name,
    total_amount,
    number_of_purchased_postcards,
    created_date,
    office_location,
    sales_channel,
    loaded_timestamp
  FROM
    resellers_csv
)


SELECT
  t.customer_key,
  transaction_id,
  product_key,
  channel_key,
  t.reseller_id,
  strftime('%Y%m%d', created_date)::INTEGER AS bought_date_key,
  total_amount::numeric,
  number_of_purchased_postcards,
  e.product_price::numeric,
  e.geography_key,
  s.commission_pct * total_amount::numeric AS commisionpaid,
  s.commission_pct AS commission_pct,
  loaded_timestamp
FROM
  trans_csv t
  JOIN {{ ref('dim_product') }}
  e
  ON t.product_name = e.product_name
  JOIN {{ ref('dim_channel') }} C
  ON t.sales_channel = C.channel_name
  JOIN {{ ref('dim_customer') }}
  cu
  ON t.customer_key = cu.customer_key
  JOIN {{ ref('dim_salesagent') }}
  s
  ON t.reseller_id = s.original_reseller_id