{% set tiers=[
    {'name': 'low', 'min': 0, 'max': 29.99},
    {'name': 'mediaum', 'min': 30, 'max': 59.99},
    {'name': 'high', 'min': 60, 'max': 199.99}
] %}
with cte_read_product as(
    select id, name, code, category, price, currency, color, created_at, updated_at
    from {{ ref('product_cleaned') }}
),

cte_transform_product as(
    select id, name, code, category, price, currency, 
    case -- This complexcity can be avoided by using Jinja for loop
    -- when price between {{ tiers[0].min}} and {{ tiers[0].max}} then '{{ tiers[0].name }}'
    -- when price between {{ tiers[1].min}} and {{ tiers[1].max }} then '{{ tiers[1].name }}'
    -- when price between {{ tiers[2].min }} and {{ tiers[2].max}} then '{{ tiers[2].name }}'
    {% for tier in tiers %}
        when price between {{ tier.min }} and {{ tier.max }} then '{{ tier.name }}'
    {% endfor %}
    else null
    end as tier, 
    color, created_at, updated_at from cte_read_product
)

select * from cte_transform_product