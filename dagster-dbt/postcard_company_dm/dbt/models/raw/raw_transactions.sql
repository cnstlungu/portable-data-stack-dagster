{{ config(schema='raw') }}

SELECT  
    transaction_id, 
    customer_id, 
    product_id, 
    amount, 
    qty, 
    channel_id, 
    bought_date,
    CURRENT_TIMESTAMP AS loaded_timestamp 
FROM 
    {{ source('oltp','transactions') }}