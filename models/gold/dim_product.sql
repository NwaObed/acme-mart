{{ config(materialized='table') }}

select distinct
    product_id,
    product_name,
    category
from {{ ref('int_sales_cleaned') }}