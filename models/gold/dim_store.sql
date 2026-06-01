{{ config(materialized='table') }}

select distinct
    store_id
from {{ ref('int_sales_cleaned') }}