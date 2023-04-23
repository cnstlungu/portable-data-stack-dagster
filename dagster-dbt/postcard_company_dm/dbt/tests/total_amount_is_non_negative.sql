select * from {{ref('fact_sales')}}

where total_amount <= 0.00