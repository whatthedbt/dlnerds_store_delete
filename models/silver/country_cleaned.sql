with cte_read_country as(
    select code as country_code,
    name as country_name from {{ source('file_system', 'country_raw') }}
),

cte_cast_country as(
    select cast(country_code as string) as country_code,
    cast(country_name as string) as country_name
    from cte_read_country
)

select * from cte_cast_country