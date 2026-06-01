with cte_read_sales as(
    select id, customer_id,product_id, sales_date, quantity, total_amount, currency, created_at, updated_at
    from {{ ref('sales_cleaned') }} where sales_date >= '2020-01-01'
),

cte_transform_sales as(
    select id, customer_id, product_id, sales_date, extract(year from sales_date) as sales_year,
    quantity, total_amount, currency, created_at, updated_at from cte_read_sales
)

select * from cte_transform_sales