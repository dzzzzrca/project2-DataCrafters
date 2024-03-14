{{ config(schema='dbt', materialized='table') }}

select
    sale_id,
    customer_id,
    product_id,
    date_id,
    quantity,
    revenue
from {{ source('project2', 'sales_fact') }}
