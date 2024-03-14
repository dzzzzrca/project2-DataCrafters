{{ config(schema='dbt', materialized='table') }}

select
    customer_id,
    customer_name,
    email,
    phone_number
from {{ source('project2', 'customer_dimension') }}
