with
    cte_read_customer as (
        select
            id,
            name,
            gender,
            dateofbirth as date_of_birth,
            email,
            country as country_code,
            city,
            created_at,
            updated_at
        from {{ source("file_system", "customer_raw") }}
    ),

    cte_cast_customer as (
        select
            cast(id as string) as id,
            cast(name as string) as name,
            cast(gender as string) as gender,
            try_to_date(date_of_birth, 'DD.MM.YY') as date_of_birth,
            cast(email as string) as email,
            cast(country_code as string) as country_code,
            cast(city as string) as city,
            cast(created_at as timestamp) as created_at,
            cast(updated_at as timestamp) as updated_at
        from cte_read_customer

    ),

    cte_clean_customer as (
        select
            id,
            name,
            gender,
            date_of_birth,
            email,
            case
                when country_code is not null and country_code != ''
                then country_code
                when city = 'Las Vegas'
                then 'US'
                when city = 'New York'
                then 'US'
                when city = 'Stuttgart'
                then 'DE'
                else null
            end as country_code,
            city,
            created_at,
            updated_at
        from cte_cast_customer
    )

select *
from cte_clean_customer
