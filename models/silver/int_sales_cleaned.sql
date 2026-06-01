{{ config(materialized='table') }}

with source as (

    select *
    from {{ ref('stg_google_sales_data__csv_sales') }}

),

cleaned as (

    select
        customer_id,
        product_id,
        store_id,
        transaction_id,
        payment_method,
        quantity,
        unit_price,
        total_amount
    from source
    where transaction_id is not null
      and product_id is not null
      and customer_id is not null
      and store_id is not null
      and payment_method is not null
      and quantity >= 0
      and unit_price >= 0
      and total_amount >= 0

)

select *
from cleaned