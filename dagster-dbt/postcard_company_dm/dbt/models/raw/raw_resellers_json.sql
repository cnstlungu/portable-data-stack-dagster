{{ config(schema='raw') }}

SELECT
    "date", 
    "reseller-id", 
    productName, 
    qty, 
    totalAmount, 
    salesChannel, 
    customer, 
    dateCreated, 
    seriesCity, 
    "Created Date", 
    transactionId, 
    CURRENT_TIMESTAMP AS loaded_timestamp

FROM {{ source('reseller_json','sales') }}