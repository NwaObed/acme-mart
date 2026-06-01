{{ config(materialized='table') }}

select distinct
    customer_id
from {{ ref('int_sales_cleaned') }}