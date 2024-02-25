{{ config(schema='staging') }}
WITH 

customers_main AS (

    SELECT 
        customer_id, 
        first_name, 
        last_name, 
        email
    FROM 
        {{ref('raw_customers')}}

),

customers_csv  AS (

    SELECT  
        "customer first name" AS customer_first_name, 
        "customer last name" AS customer_last_name ,
        "customer email" AS customer_email,
        "reseller id"::INT AS reseller_id,
        "transaction id" AS transaction_id
    FROM 
        {{ref('raw_resellers_csv')}}
)
,

customers_json AS (


    SELECT 
        customer.firstname AS customer_first_name, 
        customer.lastname AS customer_last_name, 
        customer.email AS customer_email,
        "reseller-id" AS reseller_id,
        transactionId AS transaction_id
    FROM 
        {{ref('raw_resellers_json')}}
), 

customers AS (


SELECT reseller_id, transaction_id AS customer_id , customer_first_name, customer_last_name, customer_email  FROM customers_csv

UNION 

SELECT reseller_id, transaction_id AS customer_id, customer_first_name, customer_last_name, customer_email  FROM customers_json

UNION

SELECT 0 AS reseller_id, customer_id, first_name, last_name, email  FROM customers_main
)

SELECT 
    {{ dbt_utils.generate_surrogate_key([
        'c.reseller_id',
        'customer_id']
    ) }} AS customer_key,
    customer_first_name, 
    customer_last_name, 
    customer_email, 
    s.sales_agent_key

FROM customers c
LEFT JOIN {{ref('dim_salesagent')}} s ON c.reseller_id = s.original_reseller_id