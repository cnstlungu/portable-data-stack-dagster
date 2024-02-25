{{ config(schema='raw') }}

SELECT 
    "Transaction ID", 
    "Product name", 
    Quantity, 
    "Total amount", 
    "Sales Channel", 
    "Customer First Name", 
    "Customer Last Name", 
    "Customer Email", 
    "Series City", 
    "Created Date", 
    "Reseller ID",
    CURRENT_TIMESTAMP AS loaded_timestamp
FROM 
    {{ source('reseller_csv','sales') }}