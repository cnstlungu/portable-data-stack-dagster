{{ config(schema='staging') }}
    SELECT  

        id AS product_id, 
        name AS product_name, 
        g.id AS geography_key, 
        REPLACE(price,'$','')::NUMERIC AS product_price

    FROM {{ref('raw_products')}} e
    JOIN {{ref('geography')}} g ON g.cityname = e.city

    QUALIFY ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY e.loaded_timestamp DESC)=1
