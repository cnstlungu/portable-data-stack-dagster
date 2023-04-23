{{ config(schema='staging') }}
with products as (

    SELECT  

        id AS product_id, 
        name AS product_name, 
        g.id as geography_key, REPLACE(price,'$','')::NUMERIC AS product_price, 
        row_number() over (partition by product_id order by e.loaded_timestamp desc ) as rn 

    from {{ref('raw_products')}} e
    join {{ref('geography')}} g on g.cityname = e.city

)

select product_id, product_name, geography_key, product_price

from products

where rn = 1
