with cte_read_sales as(
    select customer_id, product_id, sales_date, quantity, total_amount,
    currency, created_at, updated_at from {{ source('file_system', 'sales_raw') }}
),

cte_cast_sales as(
    select
    cast(customer_id as string) as customer_id,
    cast(product_id as string) as product_id, 
    cast(sales_date as date) as sales_date,
    cast(quantity as integer) as quantity,
    cast(total_amount as float) as total_amount,
    cast(currency as string) as currency,
    cast(created_at as timestamp) as created_at,
    cast(updated_at as timestamp) as updated_at
    from cte_read_sales
),

cte_calculate_sales as(
    select 
    {{ dbt_utils.generate_surrogate_key(['customer_id', 'product_id', 'sales_date'])}} as id,
    customer_id, product_id, sales_date, quantity, total_amount, currency, created_at, updated_at from cte_cast_sales

)

select * from cte_calculate_sales