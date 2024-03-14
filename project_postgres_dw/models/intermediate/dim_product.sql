{{ config(schema='dbt', materialized='table') }}

select
    product_id,
    product_name,
    category,
    price
from {{ source('project2', 'product_dimension') }}
