{{ config(materialized='table') }}

select distinct
    md5(payment_method) as payment_method_id,
    payment_method
from {{ ref('int_sales_cleaned') }}