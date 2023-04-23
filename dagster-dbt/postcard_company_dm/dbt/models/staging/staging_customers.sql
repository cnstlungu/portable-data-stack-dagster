{{ config(schema='staging') }}
WITH 

customers_main AS (

    SELECT 
    
    customer_id, 
    first_name, 
    last_name, 
    email 
    
    
    FROM {{ref('raw_customers')}}

),

customers_csv  AS (

    SELECT  
    
    "customer first name" as customer_first_name, 
    "customer last name" as customer_last_name ,
    "customer email" as customer_email,
    "reseller id"::int AS reseller_id,
    "transaction id" AS transaction_id

    FROM {{ref('raw_resellers_csv')}}
)
,

customers_json AS (


    SELECT 
    customer.firstname AS customer_first_name, 
    customer.lastname AS customer_last_name, 
    customer.email AS customer_email,
    "reseller-id" AS reseller_id,
    transactionId AS transaction_id
    
    FROM {{ref('raw_resellers_json')}}
), 

customers AS (


select reseller_id, transaction_id as customer_id , customer_first_name, customer_last_name, customer_email  from customers_csv

union 

select reseller_id, transaction_id as customer_id, customer_first_name, customer_last_name, customer_email  from customers_json

union

select 0 as reseller_id, customer_id, first_name, last_name, email  from customers_main
)

select 

  {{ dbt_utils.generate_surrogate_key([
      'c.reseller_id',
      'customer_id']
  ) }} as customer_key,
 
 customer_first_name, 
 customer_last_name, 
 customer_email, 
 s.sales_agent_key

from customers c
left join {{ref('dim_salesagent')}} s on c.reseller_id = s.original_reseller_id