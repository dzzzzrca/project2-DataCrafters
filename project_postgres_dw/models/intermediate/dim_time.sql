{{ config(schema='dbt', materialized='table') }}

select
    date_id,
    day_of_week,
    month,
    quarter,
    year
from {{ source('project2', 'time_dimension') }}
